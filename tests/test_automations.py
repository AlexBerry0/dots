"""Exercise automation safety paths in temporary repositories and mocked update sessions."""

import os, pathlib, re, subprocess, tempfile, time, unittest
SOURCE = pathlib.Path(os.environ['UPDATER_SCRIPT']).read_text()
REPO = os.environ['REPO_DIR']

class UpdaterTests(unittest.TestCase):

    def run_case(self, args=(), dirty=False, action='UPDATE', build_fail=False, auth_fail=False, recent=False, snoozed=False, busy=False):
        with tempfile.TemporaryDirectory(prefix='nix-updater-test-') as tmp:
            root = pathlib.Path(tmp)
            repo = root / 'repo'
            repo.mkdir()
            (repo / 'flake.lock').write_text('original')
            home = root / 'home'
            state = home / '.local/state'
            state.mkdir(parents=True)
            bins = root / 'bin'
            bins.mkdir()
            calls = root / 'calls'
            scripts = {'git': 'echo "git $*" >> "$CALLS"\nif [ "$DIRTY" = 1 ]; then echo " M pending.nix"; fi\n', 'nix': 'echo "nix $*" >> "$CALLS"\ncase "$1" in\neval) echo /test/system.drv;;\nflake) echo updated > flake.lock;;\nbuild) if [ "$BUILD_FAIL" = 1 ]; then exit 1; fi\nwhile [ "$1" != --out-link ]; do shift; done\nln -s "$FAKE_SYSTEM" "$2";;\n*) exit 9;;\nesac\n', 'nix-env': 'echo unexpected-nix-env >> "$CALLS"; exit 99\n', 'osascript': 'cat > /dev/null\necho "osascript $*" >> "$CALLS"\nif [ "$1" = - ]; then [ "$AUTH_FAIL" != 1 ]; elif [ "$1" != -e ]; then echo "$ACTION"; fi\n'}
            for name, body in scripts.items():
                path = bins / name
                path.write_text('#!/bin/bash\n' + body)
                path.chmod(493)
            if recent:
                (state / 'nix-auto-update-last').write_text(str(int(time.time())))
            if snoozed:
                (state / 'nix-auto-update-snooze').write_text(str(int(time.time())))
            if busy:
                (state / 'nix-auto-update/running').mkdir(parents=True)
            text = SOURCE.replace(REPO, str(repo)).replace(os.environ['GIT_BIN'], str(bins / 'git')).replace('/usr/bin/osascript', str(bins / 'osascript')).replace('export PATH="/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin"', f'export PATH="{bins}:/usr/bin:/bin"')
            script = root / 'update.sh'
            script.write_text(text)
            env = dict(os.environ, HOME=str(home), CALLS=str(calls), DIRTY=str(int(dirty)), ACTION=action, BUILD_FAIL=str(int(build_fail)), AUTH_FAIL=str(int(auth_fail)), FAKE_SYSTEM=str(root / 'system'))
            result = subprocess.run(['/bin/bash', str(script), *args], env=env, text=True, capture_output=True)
            return (result, calls.read_text() if calls.exists() else '', (repo / 'flake.lock').read_text().strip(), (state / 'nix-auto-update-last').exists(), (state / 'nix-auto-update-snooze').exists(), (state / 'nix-auto-update/running').exists())

    def test_diagnostics_only_even_with_pending_edits(self):
        r, c, lock, last, snooze, busy = self.run_case(['--test'], dirty=True)
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn('nix eval', c)
        self.assertNotIn('osascript', c)
        self.assertNotIn('nix flake', c)
        self.assertEqual(lock, 'original')
        self.assertFalse(last or snooze or busy)

    def test_dirty_repo_stops(self):
        r, c, lock, last, *_ = self.run_case(dirty=True)
        self.assertEqual(r.returncode, 0)
        self.assertNotIn('nix ', c)
        self.assertNotIn('osascript', c)
        self.assertEqual(lock, 'original')
        self.assertFalse(last)

    def test_success_leaves_lock_local(self):
        r, c, lock, last, snooze, busy = self.run_case()
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(lock, 'updated')
        self.assertTrue(last)
        self.assertFalse(snooze or busy)
        self.assertIn('nix build', c)
        self.assertIn('osascript - ', c)
        self.assertNotIn('git commit', c)
        self.assertNotIn('git push', c)

    def test_build_failure_restores_lock(self):
        r, c, lock, last, _, busy = self.run_case(build_fail=True)
        self.assertNotEqual(r.returncode, 0)
        self.assertEqual(lock, 'original')
        self.assertFalse(last or busy)
        self.assertNotIn('osascript - ', c)

    def test_auth_failure_retains_lock_for_review(self):
        r, c, lock, last, _, busy = self.run_case(auth_fail=True)
        self.assertNotEqual(r.returncode, 0)
        self.assertEqual(lock, 'updated')
        self.assertFalse(last or busy)

    def test_postpone(self):
        r, c, lock, last, snooze, busy = self.run_case(action='SNOOZE')
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(lock, 'original')
        self.assertTrue(snooze)
        self.assertFalse(last or busy)
        self.assertNotIn('nix flake', c)

    def test_weekly_throttle(self):
        r, c, *_ = self.run_case(recent=True)
        self.assertEqual(r.returncode, 0)
        self.assertNotIn('osascript', c)

    def test_snooze_throttle(self):
        r, c, *_ = self.run_case(snoozed=True)
        self.assertEqual(r.returncode, 0)
        self.assertNotIn('osascript', c)

    def test_force_still_checks_dirty_repo(self):
        r, c, *_ = self.run_case(['--force'], dirty=True)
        self.assertEqual(r.returncode, 0)
        self.assertNotIn('osascript', c)

    def test_force_bypasses_throttle(self):
        r, c, *_ = self.run_case(['--force'], recent=True)
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn('nix flake', c)

    def test_concurrent_run_stops(self):
        r, c, *_ = self.run_case(busy=True)
        self.assertEqual(r.returncode, 0)
        self.assertNotIn('osascript', c)

    def test_unknown_flag_stops(self):
        r, c, *_ = self.run_case(['--typo'])
        self.assertEqual(r.returncode, 2)
        self.assertEqual(c, '')

class NotesBackupTests(unittest.TestCase):

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='notes-backup-test-')
        self.addCleanup(self.tmp.cleanup)
        self.root = pathlib.Path(self.tmp.name).resolve()
        self.env = dict(os.environ, HOME=str(self.root / 'home'), GIT_CONFIG_GLOBAL='/dev/null', GIT_CONFIG_SYSTEM='/dev/null', GIT_TERMINAL_PROMPT='0')
        self.git = os.environ['GIT_BIN']
        self.repo = self.root / 'notes'
        self.remote = self.root / 'remote.git'
        self.command('init', '--bare', str(self.remote))
        self.command('init', '--initial-branch=main', str(self.repo))
        self.command('-C', str(self.repo), 'config', 'user.name', 'Test')
        self.command('-C', str(self.repo), 'config', 'user.email', 'test@example.invalid')
        (self.repo / 'note.txt').write_text('original')
        self.command('-C', str(self.repo), 'add', '-A')
        self.command('-C', str(self.repo), 'commit', '-m', 'initial')
        self.command('-C', str(self.repo), 'remote', 'add', 'origin', str(self.remote))
        self.command('-C', str(self.repo), 'push', '-u', 'origin', 'main')
        self.source = pathlib.Path(os.environ['NOTES_SCRIPT']).read_text().replace(os.environ['NOTES_DIR'], str(self.repo))

    def command(self, *args):
        r = subprocess.run([self.git, *args], env=self.env, text=True, capture_output=True)
        self.assertEqual(r.returncode, 0, r.stderr)
        return r.stdout.strip()

    def run_backup(self, source=None):
        script = self.root / 'backup.sh'
        script.write_text(source or self.source)
        return subprocess.run(['/bin/bash', str(script)], env=self.env, text=True, capture_output=True)

    def remote_tip(self):
        return self.command('--git-dir', str(self.remote), 'rev-parse', 'refs/heads/main')

    def test_all_new_files_are_backed_up(self):
        (self.repo / 'another-note.txt').write_text('new')
        r = self.run_backup()
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(self.command('-C', str(self.repo), 'status', '--porcelain'), '')
        self.assertEqual(self.command('--git-dir', str(self.remote), 'show', 'main:another-note.txt'), 'new')

    def test_clean_run_does_not_add_commit(self):
        before = self.remote_tip()
        r = self.run_backup()
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(self.remote_tip(), before)

    def test_wrong_branch_is_skipped(self):
        self.command('-C', str(self.repo), 'checkout', '-b', 'other')
        (self.repo / 'note.txt').write_text('pending')
        before = self.remote_tip()
        r = self.run_backup()
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(self.remote_tip(), before)
        self.assertIn('Skipping', r.stdout)
        self.assertEqual(self.command('-C', str(self.repo), 'status', '--porcelain'), 'M note.txt')

    def test_missing_upstream_fails_before_staging(self):
        self.command('-C', str(self.repo), 'branch', '--unset-upstream')
        (self.repo / 'note.txt').write_text('pending')
        r = self.run_backup()
        self.assertNotEqual(r.returncode, 0)
        self.assertIn('upstream', r.stderr)
        self.assertEqual(self.command('-C', str(self.repo), 'diff', '--cached', '--name-only'), '')

    def test_remote_changes_require_manual_reconciliation(self):
        other = self.root / 'other'
        self.command('clone', '--branch', 'main', str(self.remote), str(other))
        self.command('-C', str(other), 'config', 'user.name', 'Test')
        self.command('-C', str(other), 'config', 'user.email', 'test@example.invalid')
        (other / 'remote-note.txt').write_text('remote change')
        self.command('-C', str(other), 'add', '-A')
        self.command('-C', str(other), 'commit', '-m', 'remote change')
        self.command('-C', str(other), 'push')
        (self.repo / 'note.txt').write_text('pending')
        r = self.run_backup()
        self.assertNotEqual(r.returncode, 0)
        self.assertIn('Reconcile', r.stderr)
        self.assertEqual(self.command('-C', str(self.repo), 'diff', '--cached', '--name-only'), '')

    def test_commit_failure_is_reported_without_push(self):
        wrapper = self.root / 'git-wrapper'
        wrapper.write_text('#!/bin/bash\nif [ "$1" = commit ]; then echo "test commit failed" >&2; exit 42; fi\nexec ' + self.git + ' "$@"\n')
        wrapper.chmod(493)
        (self.repo / 'note.txt').write_text('pending')
        before = self.remote_tip()
        r = self.run_backup(self.source.replace(self.git, str(wrapper)))
        self.assertEqual(r.returncode, 42)
        self.assertIn('test commit failed', r.stderr)
        self.assertEqual(self.remote_tip(), before)

    def test_detached_head_is_rejected(self):
        self.command('-C', str(self.repo), 'checkout', '--detach')
        r = self.run_backup()
        self.assertNotEqual(r.returncode, 0)
        self.assertIn('Detached HEAD', r.stderr)

    def test_missing_notes_is_skipped(self):
        r = self.run_backup(self.source.replace(str(self.repo), str(self.root / 'missing')))
        self.assertEqual(r.returncode, 0, r.stderr)

    def test_upstream_can_have_a_different_name(self):
        self.command('-C', str(self.repo), 'push', 'origin', 'main:notes-backup')
        self.command('-C', str(self.repo), 'config', 'branch.main.merge', 'refs/heads/notes-backup')
        original = self.remote_tip()
        (self.repo / 'new.txt').write_text('new')
        r = self.run_backup()
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(self.remote_tip(), original)
        self.assertEqual(self.command('--git-dir', str(self.remote), 'show', 'notes-backup:new.txt'), 'new')

class TakeTests(unittest.TestCase):

    def run_take(self, args, fail_clone=False):
        with tempfile.TemporaryDirectory(prefix='take-test-') as tmp:
            root = pathlib.Path(tmp).resolve()
            bins = root / 'bin'
            bins.mkdir()
            git = bins / 'git'
            git.write_text('#!/bin/bash\n' + ('exit 17\n' if fail_clone else 'mkdir -p -- "$4"\n'))
            git.chmod(493)
            (root / 'existing-file').write_text('file')
            command = 'source "$TAKE_SCRIPT"; take $argv; set -l result $status; pwd; exit $result'
            env = dict(os.environ, PATH=str(bins) + ':' + os.environ['PATH'])
            r = subprocess.run([os.environ['FISH_BIN'], '--no-config', '-c', command, *args], cwd=root, env=env, text=True, capture_output=True)
            return (r, root)

    def test_directory_with_spaces(self):
        r, root = self.run_take(['space dir'])
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(r.stdout.strip(), str(root / 'space dir'))

    def test_url_without_dot_git(self):
        r, root = self.run_take(['https://example.invalid/alex/project'])
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(r.stdout.strip(), str(root / 'project'))

    def test_ssh_url_and_destination(self):
        r, root = self.run_take(['git@example.invalid:alex/project.git', 'custom directory'])
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(r.stdout.strip(), str(root / 'custom directory'))

    def test_clone_failure_does_not_change_directory(self):
        r, root = self.run_take(['https://example.invalid/alex/project.git'], fail_clone=True)
        self.assertEqual(r.returncode, 17)
        self.assertEqual(r.stdout.strip(), str(root))

    def test_mkdir_failure_does_not_change_directory(self):
        r, root = self.run_take(['existing-file'])
        self.assertNotEqual(r.returncode, 0)
        self.assertEqual(r.stdout.strip(), str(root))

    def test_missing_argument(self):
        r, root = self.run_take([])
        self.assertNotEqual(r.returncode, 0)
        self.assertTrue(r.stdout.strip().endswith(str(root)))
if __name__ == '__main__':
    unittest.main(verbosity=2)
