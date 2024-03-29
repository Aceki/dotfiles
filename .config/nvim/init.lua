vim.opt.autoread = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 0
vim.opt.colorcolumn = '100'
vim.opt.cursorline = true
vim.opt.encoding = 'utf8'
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.exrc = true
vim.opt.ffs = {'unix', 'dos', 'mac'}
vim.opt.foldcolumn = '0'
vim.opt.foldenable = false
vim.opt.foldlevel = 100
vim.opt.foldmarker = {'{', '}'}
vim.opt.foldmethod = 'marker'
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.list =  true
vim.opt.listchars = {trail = '@'}
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.secure = true
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.syntax = 'off'
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.updatetime = 750
vim.opt.visualbell = false

vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'BurntSushi/ripgrep'
Plug 'akinsho/bufferline.nvim',         { 'tag': 'v3.*' }
Plug 'hrsh7th/cmp-buffer',              { 'commit': '3022dbc' }
Plug 'hrsh7th/cmp-cmdline',             { 'commit': '8ee981b' }
Plug 'hrsh7th/cmp-nvim-lsp',            { 'commit': '44b16d1' }
Plug 'hrsh7th/cmp-path',                { 'commit': '91ff86c' }
Plug 'hrsh7th/nvim-cmp',                { 'commit': '5dce1b7' }
Plug 'hrsh7th/vim-vsnip',               { 'commit': 'be27746' }
Plug 'itchyny/lightline.vim',           { 'commit': 'f11645c' }
Plug 'jiangmiao/auto-pairs',            { 'commit': '39f06b8' }
Plug 'morhetz/gruvbox',                 { 'commit': 'f1ecde8' }
Plug 'neovim/nvim-lspconfig',           { 'tag': 'v0.1.7' }
Plug 'nvim-lua/plenary.nvim',           { 'commit': '5001291' }
Plug 'nvim-telescope/telescope.nvim',   { 'tag': '0.1.5' }
Plug 'nvim-tree/nvim-tree.lua',         { 'commit': 'aaee4cd' }
Plug 'nvim-tree/nvim-web-devicons',     { 'commit': '3af7451' }
Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '30604fd' }
Plug 'phaazon/hop.nvim',                { 'commit': '1a1ecea' }
Plug 'vimwiki/vimwiki',                 { 'commit': 'f0fe154' }
call plug#end()
]])

vim.cmd('colorscheme gruvbox')
vim.cmd('highlight clear DiagnosticHint')
vim.cmd('highlight link DiagnosticHint DiagnosticWarn')

require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_buffer_default_icon = false,
    show_close_icon = false,
    show_buffer_close_icons = false,
    hover = {
      enabled = false
    },
  }
})

require('nvim-tree').setup({
  view = {
    side = 'right',
    width = {
        padding = 2
    }
  },
  renderer = {
    special_files = {}
  },
  git = {
    enable = true
  },
  modified = {
    enable = false
  },
  filters = {
      dotfiles = true,
      exclude = {
          '.gitignore',
          '.dockerignore',
          '.prettier*',
          '.sequelizerc',
          '.env*',
      }
  }
})

require("hop").setup()

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'c',
    'cmake',
    'cpp',
    'dockerfile',
    'json',
    'lua',
    'markdown',
    'yaml',
    'javascript',
    'typescript',
    'tsx'
  },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
})

local telescope = require('telescope')
telescope.setup({
  defaults = {
    layout_strategy = 'vertical',
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim'
    },
    initial_mode = 'insert'
  }
})

vim.api.nvim_set_var('lightline', {
  colorscheme = 'gruvbox',
  enable = {
    tabline = 0
  },
  active = {
    left = {{'mode', 'paste'}, {'readonly', 'filename', 'modified'}},
    right = {{'lineinfo'}, {'percent'}, {'fileformat', 'fileencoding', 'filetype'}}
  }
})
vim.api.nvim_set_var('AutoPairsShortcutToggle', '<M-8>')
vim.api.nvim_set_var('markdown_folding', 1)

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources(
    {{ name = 'nvim_lsp' }},
    {{ name = 'vsnip' }},
    {{ name = 'buffer' }},
    {{ name = 'nvim_lsp_signature_help' }}
  )
})
cmp.setup.cmdline('/', {
  sources = {{ name = 'buffer' }},
  mapping = cmp.mapping.preset.cmdline()
})
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }}),
  mapping = cmp.mapping.preset.cmdline()
})

local lspconfig = require('lspconfig')

lspconfig.tsserver.setup({})
lspconfig.clangd.setup({})
lspconfig.sqlls.setup({})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end
})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set({'n', 'v'}, '<Leader>hw', '<cmd>HopWord<CR>')
vim.keymap.set('n', '<Leader>ha', '<cmd>HopAnywhere<CR>')
vim.keymap.set('n', '<A-o>', '<cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<A-p>', '<cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', '<A-9>', '<cmd>BufferLineMovePrev<CR>')
vim.keymap.set('n', '<A-0>', '<cmd>BufferLineMoveNext<CR>')
vim.keymap.set('n', '<A-u>', '<cmd>tabnext<CR>')
vim.keymap.set('n', 'ff', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', 'fg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', 'fr', '<cmd>Telescope lsp_references<CR>')
vim.keymap.set('n', 'fb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<A-k>', '<cmd>wincmd k<CR>')
vim.keymap.set('n', '<A-j>', '<cmd>wincmd j<CR>')
vim.keymap.set('n', '<A-h>', '<cmd>wincmd h<CR>')
vim.keymap.set('n', '<A-l>', '<cmd>wincmd l<CR>')
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<C-w>c', '<cmd>tabnew<CR>')

vim.cmd("imap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'")
vim.cmd("smap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'")

vim.cmd("let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]")

vim.diagnostic.config({ severity_sort = true })

