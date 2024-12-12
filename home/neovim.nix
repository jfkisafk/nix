{ pkgs, ... }: {
  enable = true;

  extraLuaConfig = ''
    -- Make line numbers default
    vim.wo.number = true

    -- Tabs vs spaces
    vim.o.tabstop = 2
    vim.o.expandtab = true
    vim.o.softtabstop = 2
    vim.o.shiftwidth = 2

    -- Enable mouse mode
    vim.o.mouse = "a"

    -- Sync clipboard between OS and Neovim.
    -- Remove this option if you want your OS clipboard to remain independent.
    -- See `:help 'clipboard'`
    vim.o.clipboard = "unnamedplus"

    -- Enable break indent
    vim.o.breakindent = true

    -- Save undo history
    vim.o.undofile = true

    -- Case-insensitive searching UNLESS \C or capital in search
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Keep signcolumn on by default
    vim.wo.signcolumn = "yes"

    -- Decrease update time
    vim.o.updatetime = 250
    vim.o.timeoutlen = 300

    -- Set completeopt to have a better completion experience
    vim.o.completeopt = "menuone,noselect"

    -- Set terminal gui colors to true
    vim.o.termguicolors = true

    -- Enable syntax highlighting
    vim.cmd('syntax on')

    -- Search settings
    vim.o.hlsearch = true
    vim.o.incsearch = true

    -- File encoding
    vim.o.encoding = 'utf-8'
  '';
}