-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- set line number
vim.wo.number = true
vim.wo.relativenumber = true
vim.g.mapleader = " "

vim.o.guifont = "CaskaydiaCove NFM:h11"
-- tabs to 4 spaces
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")

require("lazy").setup({
    spec = {
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" }
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "lua",
                        "java",
                        "python",
                        "javascript",
                        "typescript",
                        "c",
                        "cpp",
                        "html",
                        "css"
                    },
                    highlight = { enabled = true },
                    incremental_selection = { enable = true },
                    indent = { enable = true }
                })
            end
        },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/nvim-cmp' },
        { 'nvim-tree/nvim-web-devicons' },
        { 'echasnovski/mini.statusline',      version = '*' },
        { 'echasnovski/mini-git',             version = '*',  main = 'mini.git' },
        { 'echasnovski/mini.diff',            version = '*' },
        { 'm4xshen/autoclose.nvim' },
        { 'echasnovski/mini.nvim',            version = '*' },
        { "miikanissi/modus-themes.nvim",     priority = 1000 },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
            keys = {
                {
                    "<leader>?",
                    function()
                        require("which-key").show({ global = false })
                    end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        {
            'rmagatti/auto-session',
            lazy = false,

            ---enables autocomplete for opts
            ---@module "auto-session"
            ---@type AutoSession.Config
            opts = {
                suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
                -- log_level = 'debug',
            },
        }
        -- {'nvim-tree/nvim-tree.lua'},
    },
    -- install = { colorscheme = { "modus" } },
    checker = { enabled = true },
})

require('telescope').load_extension('fzf')

require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}

require('mini.statusline').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('autoclose').setup()
-- require("nvim-tree").setup()
-- require('mini.tabline').setup()

-- set colorscheme
vim.cmd("colorscheme modus_vivendi")

local function open_file()
    local file = vim.fn.input("Enter file: ")
    vim.cmd.e(file)
end


vim.keymap.set("n", "<leader>E", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", open_file)
vim.keymap.set("n", "\\", vim.cmd.noh)
vim.keymap.set("n", "<leader>[", vim.cmd.bprev)
vim.keymap.set("n", "<leader>]", vim.cmd.bnext)
vim.keymap.set("n", "<leader>w", vim.cmd.split)
vim.keymap.set("n", "<leader>W", vim.cmd.vs)
vim.keymap.set("n", "U", vim.cmd.redo)

vim.keymap.set("n", "<leader>ts", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>td", function()
    require("telescope.builtin").grep_string({ search = vim.fn.input("Grep: ") })
end)

vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
    ensure_installed = { "lua_ls", "clangd", "java_language_server", "html", "ts_ls", "cssls", "emmet_ls", "pylsp" }
})

---
-- Autocompletion config
---
local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
})
