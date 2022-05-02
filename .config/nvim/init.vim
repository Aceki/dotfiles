call plug#begin('~/.vim/plugged')

" colorschemes
Plug 'morhetz/gruvbox' 

" completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" syntax highlight
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'cdelledonne/vim-cmake'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'bfrg/vim-cpp-modern'

" other
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'phaazon/hop.nvim'
Plug 'itchyny/lightline.vim'

call plug#end()

set expandtab           " Если данная опция включена, вместо табуляции создаются пробелы 
set smarttab
set tabstop=4           " Количество пробелов, которые создаёт символ табуляции 
set softtabstop=4
set shiftwidth=4
set number
set foldcolumn=0
syntax on
set noerrorbells
set novisualbell
set hlsearch
set incsearch
set ignorecase
set exrc
set secure
set smartcase
set cursorline
set updatetime=750
set encoding=utf8
set ffs=unix,dos,mac
set termguicolors
set autoread

colorscheme gruvbox
" Custom highlights for gruvbox ------
hi LineNr ctermbg=234
hi clear DiagnosticHint
hi link DiagnosticHint DiagnosticWarn
hi clear Todo
hi link Todo Keyword
" ------------------------------------

" mappings
map <C-n> :NERDTreeToggle<CR>
map <A-p> :tabn<CR>
map <A-o> :tabp<CR>
map <A-0> :tabm +1<CR>
map <A-9> :tabm -1<CR>
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>
map <C-\> :tabnew<CR>
map <Leader>w :HopWord<CR>


" configuration
let g:lightline = { 'colorscheme': 'wombat' }
let g:AutoPairsShortcutToggle = '<M-8>'

let g:markdown_folding = 1
set nofoldenable

" configure hop
lua << EOF
  local hop = require'hop'
  hop.setup()
EOF

" configure vsnip
imap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'

" configure Treesitter 
lua << EOF
--  local treesitter = require'nvim-treesitter.configs'
--
--  treesitter.setup({
--    highlight = {
--      enable = true
--    }
--  })
EOF

lua << EOF
  local lsp = require'lspconfig'
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
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
      {{ name = 'buffer' }}
    )
  })

  -- Use buffer source for `/`.
  cmp.setup.cmdline('/', {
    sources = {{ name = 'buffer' }},
    mapping = cmp.mapping.preset.cmdline()
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }}),
    mapping = cmp.mapping.preset.cmdline()
  })

  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  lsp.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150
    }
  }

  -- lsp.eslint.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   flags = {
  --     debounce_text_changes = 150
  --   }
  -- }

  lsp.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'clangd-12' },
    flags = {
      debounce_text_changes = 150
    }
  }

  lsp.cmake.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150
    }
  }
EOF
