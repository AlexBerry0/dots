const CONFIG_DIR = '/etc/nixos/modules/nixos/hyprland/ags/'
const TMP = '/tmp/ags/'

const entry = CONFIG_DIR + 'main.ts'
const main = TMP + 'main.js'

const scss = CONFIG_DIR + 'style/style.scss' // main scss file
const css = '/tmp/ags/style.css' // output css file

async function loadCSS() {
	try {
		await Utils.execAsync(`sassc ${scss} ${css}`) 
	} catch (error) {
		console.log(error)
		App.quit()
	}

	App.resetCss()
	App.applyCss(css)
}

try {
	await Utils.execAsync([
		'bun', 'build', entry,
		'--outfile', main
	])

	await loadCSS()
} catch (error) {
	console.error(error)
	App.quit()
}

await import('file://' + main)

Utils.monitorFile(CONFIG_DIR + 'style', loadCSS)

export { }
