" Vim-Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'shaunsingh/seoul256.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'
Plug 'ojroques/nvim-osc52', {'branch': 'main'}
Plug 'ggandor/leap.nvim'
Plug 'nvim-lualine/lualine.nvim'
call plug#end()

" formating options for text
" see http://vimcasts.org/episodes/hard-wrapping-text/ for more infos
set formatoptions=qrm1
set nowrap
set textwidth=79

"" No need to be compatible with vi and lose features.
set nocompatible

filetype plugin on
filetype indent on

" UTF-8 is the one true encoding
set encoding=utf-8
set fileencoding=utf-8

" Line numbers
set number
set norelativenumber

" Default indentation
set smarttab
set smartindent

" set colorcolumn=80
set linebreak
set list
set listchars=tab:▸\ ,eol:¬,trail:~
set background=dark
set mouse=nv
set omnifunc=syntaxcomplete#Complete

"" Keep the horizontal cursor position when moving vertically.
set nostartofline
" highlight matching braces
set showmatch
" highlight search terms
set hlsearch
set smartcase
" no visual flash on error
set novisualbell
" don't beep
set noerrorbells
" show (partial) command in the last line of the screen
" this also shows visual selection info
set showcmd
" automatically update the buffer if file got updated
set autoread 
" Show the mode (insert,replace,etc.)
set showmode

" Enable secure per directory options
set exrc
set secure

syntax on
"" Don't be disruptive with LSP hints
set signcolumn=no
let g:seoul256_disable_background = v:true
colo seoul256
highlight Normal ctermbg=none
highlight NonText ctermbg=none
set termguicolors

"" Go setup
let g:go_version_warning = 0

" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

" Remappings
inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" better identation
vnoremap < <gv
vnoremap > >gv

"" Cycling through Windows quicker.
map <A-Down>  <C-W><Down><C-W>_
map <A-Up>    <C-W><Up><C-W>_
map <A-Left>  <C-W><Left><C-W>|
map <A-Right> <C-W><Right><C-W>|

"" Quickfix navigation
map <C-j> :cn<CR>
map <C-k> :cp<CR>

" More logical Y (defaul was alias for yy)
nnoremap Y y$

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc
" Don't yank to default register when pasting something
xnoremap p "_dp
xnoremap P "_dP

" # Filetype specifics
augroup filtypes
    autocmd!
    autocmd FileType c setlocal syntax=cpp.doxygen tabstop=8 shiftwidth=8 softtabstop=8 cc=100
    autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType tex command Latexmk execute "!latexmk -pdf %" 
augroup END
let g:c_syntax_for_h = 1

" Lua Section
lua << EOF
-- Clipboard
local function osccopy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function oscpaste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {
          ['+'] = osccopy,
          ['*'] = osccopy
          },
  paste = {
          ['+'] = oscpaste,
          ['*'] = oscpaste
  },
  cache_enabled = 1,
}

vim.opt.clipboard = "unnamedplus"

-- Setup leap.nvim
require('leap').create_default_mappings()
require('leap').opts.safe_labels = {}
-- Leap colors
vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = 'gray47' }) -- or some grey
vim.api.nvim_set_hl(0, 'LeapMatch', {
  -- For light themes, set to 'black' or similar.
  fg = 'white', bold = true, nocombine = true,
})
vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
  fg = 'coral', bold = true, nocombine = true,
})
vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
  fg = 'LightYellow', bold = true, nocombine = true,
})

vim.keymap.set({'n', 'v'}, 's', function ()
  require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
end)

-- Setup lualine
-- Colors from seoul256
local colors = {
  bg1    = '#3c474d',
  bg3    = '#505a60',
  fg =     "#565656",
  aqua = "#93b2b2",
  paleblue = "#afeeee",
  green = "#678568",
  orange = "#67a9aa",
  purple = "#c66d86",
  red = "#a07474",
  pink = "#d0a39f",
  grey1  = '#868d80',
  grey2    = '#323d43',
  white = "#dfe0e0",
}

local custom_theme = {
  normal = {
    a = { bg = colors.aqua, fg = colors.grey2, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg },
  },
  insert = {
    a = { bg = colors.green, fg = colors.white, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg },
  },
  visual = {
    a = { bg = colors.pink, fg = colors.grey2, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg },
  },
  replace = {
    a = { bg = colors.orange, fg = colors.grey2, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg },
  },
  command = {
    a = { bg = colors.aqua, fg = colors.grey2, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg },
  },
  terminal = {
    a = { bg = colors.purple, fg = colors.bg0, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg },
  },
  inactive = {
    a = { bg = colors.bg1, fg = colors.grey1, gui = 'bold' },
    b = { bg = colors.bg1, fg = colors.grey1 },
    c = { bg = colors.bg1, fg = colors.grey1 },
  },
}
custom_theme.normal.c.bg = 'None'
custom_theme.insert.c.bg = 'None'
custom_theme.visual.c.bg = 'None'
custom_theme.replace.c.bg = 'None'
custom_theme.command.c.bg = 'None'
custom_theme.inactive.c.bg = 'None'

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = custom_theme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {'fileformat'},
    lualine_c = {
      {'tabs',
        mode = 2,
        max_length = vim.o.columns,
        use_mode_colors = false,
        show_modified_status = true,
        symbols = {
          modified = '[+]',
         },
         tabs_color = {
         active = {fg = 'white'},
         inactive = {fg = 'gray'},
         }
      }
    },
    lualine_z = {'hostname'},
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Setup nvim-lsp
local lspconfig = require('lspconfig')
local tgl = require('toggle_lsp_diagnostics')

tgl.init()

vim.diagnostic.config({
  float = {
    border = 'rounded',
  },
})

local function on_list(options)
  vim.fn.setqflist({}, ' ', options)
  vim.api.nvim_command('cfirst')
end

-- Global mappings for LSP things
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<F6>', tgl.toggle_diagnostics)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Borders around hover and signatures
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
        {border = 'rounded'}
    )
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
      {border = 'rounded'}
    )
    vim.lsp.handlers['textDocument/diagnostics'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
      {border = 'rounded'}
    )

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', function()
        vim.lsp.buf.references(nil, {on_list=on_list})
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'sh', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

lspconfig.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
            check = {
                command = "clippy",
            },
        }
    }
})

lspconfig.clangd.setup({
    on_attach=on_attach,
})

EOF
