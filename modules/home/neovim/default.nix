{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      fzf-lua
      oil-nvim
      nvim-lspconfig
      undotree
      (nvim-treesitter.withAllGrammars)
      nvim-treesitter-textobjects
      ultimate-autopair-nvim
      nvim-surround
      plenary-nvim
      harpoon2
    ];

    initLua = builtins.readFile ./init.lua;
  };
}