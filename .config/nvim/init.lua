vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 6

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git","clone","--filter=blob:none","https://github.com/folke/lazy.nvim.git","--branch=stable",lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() vim.cmd("colorscheme tokyonight") end },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", opts = { ensure_installed = { "lua","c","cpp","c_sharp","json","markdown","bash","python" }, highlight = { enable = true } }, config = function(_,o) require("nvim-treesitter.configs").setup(o) end },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("lualine").setup({ options = { theme = "tokyonight" } }) end },
  { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()  require("bufferline").setup({    options = {      diagnostics = "nvim_lsp",      diagnostics_indicator = function(count, level)        local icon = level:match("error") and " " or " "        return " " .. icon .. count      end,    }  }) end },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" }, config = function()
      local t = require("telescope")
      t.setup({ defaults = { sorting_strategy = "ascending", layout_config = { prompt_position = "top" } }, extensions = { ["ui-select"] = {} } })
      t.load_extension("ui-select")
    end },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
      require("todo-comments").setup({
        keywords = { TODO = { icon = "" }, FIX = { icon = "" }, NOTE = { icon = "" }, NTS = { icon = "", color = "hint", alt = { "NOTICE", "NTS" } } }
      })
    end },
  { "stevearc/oil.nvim", opts = { view_options = { show_hidden = true } } },
  { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },
  { "kylechui/nvim-surround", version = "*", config = function() require("nvim-surround").setup() end },
  { "folke/which-key.nvim", config = function() require("which-key").setup() end },
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("trouble").setup() end },
  { "aznhe21/actions-preview.nvim" },

  { "williamboman/mason.nvim", config = function() require("mason").setup() end },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "neovim/nvim-lspconfig" }, config = function()
      require("mason-lspconfig").setup({ ensure_installed = { "lua_ls","clangd","omnisharp","pyright" } })
    end },

  { "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp","hrsh7th/cmp-buffer","hrsh7th/cmp-path","hrsh7th/cmp-cmdline","L3MON4D3/LuaSnip","saadparwaiz1/cmp_luasnip","rafamadriz/friendly-snippets" },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } , { name = "path" }, { name = "buffer" } }),
      })
    end
  },

  { "stevearc/overseer.nvim", config = function() require("overseer").setup() end },
  { "akinsho/toggleterm.nvim", version = "*", config = function() require("toggleterm").setup({ direction = "float" }) end },

  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end
  },
})

local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config["lua_ls"] = { capabilities = cmp_caps, settings = { Lua = { diagnostics = { globals = { "vim" } } } } }
vim.lsp.config["clangd"] = { capabilities = cmp_caps }
vim.lsp.config["omnisharp"] = { capabilities = cmp_caps }
vim.lsp.config["pyright"] = { capabilities = cmp_caps }
vim.lsp.enable({ "lua_ls","clangd","omnisharp","pyright" })

vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", callback = function() vim.lsp.buf.format({ async = false }) end })

vim.keymap.set("n","<leader>e",require("oil").open,{ silent = true })
vim.keymap.set("n","<leader>ff",function() require("telescope.builtin").find_files() end,{ silent = true })
vim.keymap.set("n","<leader>fg",function() require("telescope.builtin").live_grep() end,{ silent = true })
vim.keymap.set("n","<leader>fb",function() require("telescope.builtin").buffers() end,{ silent = true })
vim.keymap.set("n","<leader>fh",function() require("telescope.builtin").help_tags() end,{ silent = true })
vim.keymap.set("n","<leader>ft",":TodoTelescope<CR>",{ silent = true })
vim.keymap.set({ "n","v" },"<leader>ca",function() require("actions-preview").code_actions() end,{ silent = true })

vim.keymap.set("n","gd",vim.lsp.buf.definition,{ silent = true })
vim.keymap.set("n","gr",vim.lsp.buf.references,{ silent = true })
vim.keymap.set("n","gi",vim.lsp.buf.implementation,{ silent = true })
vim.keymap.set("n","K",vim.lsp.buf.hover,{ silent = true })
vim.keymap.set("n","<leader>rn",vim.lsp.buf.rename,{ silent = true })
vim.keymap.set("n","<leader>sd","<cmd>Trouble diagnostics toggle<cr>",{ silent = true })

vim.keymap.set("n","<leader>tt","<cmd>OverseerToggle<cr>",{ silent = true })
vim.keymap.set("n","<leader>tr","<cmd>OverseerRun<cr>",{ silent = true })
vim.keymap.set("n","<leader>tv","<cmd>ToggleTerm<cr>",{ silent = true })

local dap = require("dap")
vim.keymap.set("n","<F5>",dap.continue)
vim.keymap.set("n","<F10>",dap.step_over)
vim.keymap.set("n","<F11>",dap.step_into)
vim.keymap.set("n","<F12>",dap.step_out)
vim.keymap.set("n","<leader>db",dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>zy", function()
  local diags = vim.diagnostic.get(0)  -- get diagnostics for current buffer
  if #diags == 0 then
    vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
    return
  end
  local lines = {}
  for _, d in ipairs(diags) do
    table.insert(lines, d.lnum+1 .. ":" .. d.col+1 .. " " .. d.message)
  end
  vim.fn.setreg("+", table.concat(lines, "\n"))  -- copy to system clipboard
  vim.notify("Diagnostics copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy buffer diagnostics to clipboard" })
vim.keymap.set("n","<leader>fd",function() require("telescope.builtin").diagnostics() end,{ silent = true })