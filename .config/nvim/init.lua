local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
local api = vim.api  -- neovim API


cmd 'packadd paq-nvim'               -- load the package manager
require "paq" {
	{"savq/paq-nvim", opt = true};
	"shougo/deoplete-lsp";
	{"shougo/deoplete.nvim", build = fn["remote#host#UpdateRemotePlugins"], enable_at_startup = 1};
	{"nvim-treesitter/nvim-treesitter", build=function() require('nvim-treesitter.install').update({ with_sync = true }) end};
	"neovim/nvim-lspconfig";
	{"junegunn/fzf", build = fn["fzf#install"]};
	"ojroques/nvim-lspfuzzy";
	"antoinemadec/FixCursorHold.nvim"; -- required by nvim-lightbulb
	"kosayoda/nvim-lightbulb";
	"sharkdp/fd"; -- for telescope ripgrep
	"nvim-lua/plenary.nvim"; -- required by nvim-telescope
	{"nvim-telescope/telescope.nvim", branch = "0.1.x"};
	"nvim-telescope/telescope-file-browser.nvim";
	"nvim-telescope/telescope-project.nvim";
	"mhinz/vim-startify";
	"kyazdani42/nvim-web-devicons";
	"nvim-lualine/lualine.nvim";
	--"jedrzejboczar/possession.nvim";
}

g["deoplete#enable_at_startup"] = 1  -- enable deoplete at startup

cmd 'colorscheme lunaperche'            -- Put your favorite colorscheme here
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options (for deoplete)
opt.expandtab = false                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.relativenumber = false           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 8                  -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = 8                     -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap
opt.textwidth = 80
opt.formatprg='par -w81 -q'
opt.modeline = true

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode
map('n', 'rB', 'o<c-m>Reviewed-by: Caleb Connolly <lt>caleb.connolly@linaro.org><c-m><c-m>// Caleb (they/them)<c-m><Esc>')

local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = {"c", "lua", "rust", "cpp", "bash"},
  highlight = {enable = true},
  auto_install = true,
}

require('nvim-lightbulb').setup({autocmd = {enabled = true}})

local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'

-- We use the default settings for ccls and pylsp: the option table can stay empty
lsp.ccls.setup {
	init_options = {
		index = { threads = 4; };
	}
}
lsp.pylsp.setup {}
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'  -- disabled in visual mode

-- Project management / telescope

--require('possession').setup()

require('telescope').setup {
	extensions = {
		file_browser = {
			theme = "ivy",
			hijack_netrw = true,
		},
	},
}

require('telescope').load_extension('project')
require("telescope").load_extension('file_browser')

map('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
map('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
-- map('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
map('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>")

map('n', '<leader>fp', ":lua require'telescope'.extensions.project.project{}<CR>", {noremap = true, silent = true})
map('n', '<leader>fb', ":lua require'telescope'.extensions.file_browser.file_browser{}<CR>", {noremap = true, silent = true})

require('telescope')--.load_extension('possession')

-- statusline
require('lualine').setup {
  sections = {
    lualine_a = {'mode', 'ObsessionStatus'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

