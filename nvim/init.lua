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

  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = { ensure_installed = { "lua","c","cpp","c_sharp","json","markdown","bash","python","html","javascript","typescript","css" }, highlight = { enable = true } },
    config = function(_,o) require("nvim-treesitter.configs").setup(o) end
  },

  { "nvim-treesitter/nvim-treesitter-context", config = function() require("treesitter-context").setup({}) end },
  { "windwp/nvim-ts-autotag", config = function() require("nvim-ts-autotag").setup() end },

  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("lualine").setup({ options = { theme = "tokyonight" } }) end },

  { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level) local icon = level:match("error") and " " or " "; return " " .. icon .. count end,
        }
      })
    end
  },

  { "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local t = require("telescope")
      t.setup({
        defaults = { sorting_strategy = "ascending", layout_config = { prompt_position = "top" } },
        extensions = { ["ui-select"] = {}, fzf = { fuzzy = true, case_mode = "smart_case" } }
      })
      t.load_extension("ui-select")
      pcall(t.load_extension, "fzf")
    end
  },

  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
      require("todo-comments").setup({ keywords = { TODO = { icon = "" }, FIX = { icon = "" }, NOTE = { icon = "" }, NTS = { icon = "", color = "hint", alt = { "NOTICE","NTS" } } } })
    end
  },
  { "nvim-mini/mini.icons", config = function() require("mini.icons").setup() end },

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
    end
  },

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
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" }, { name = "buffer" } }),
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

  { "ThePrimeagen/refactoring.nvim", config = function() require("refactoring").setup({}) end },

  { "RRethy/vim-illuminate", config = function()
      require("illuminate").configure({ providers = { "lsp","treesitter","regex" }, delay = 120 })
    end
  },

  { "NvChad/nvim-colorizer.lua", config = function() require("colorizer").setup() end },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  { "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }, config = function()
      require("notify").setup({})
      require("noice").setup({ lsp = { progress = { enabled = true } } })
      vim.notify = require("notify")
    end
  },

  { "folke/neodev.nvim", config = function() require("neodev").setup() end },

  { "goolord/alpha-nvim", config = function() require("alpha").setup(require("alpha.themes.startify").config) end },

  { "folke/persistence.nvim", config = function() require("persistence").setup() end },

  { "theprimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" }, config = function() require("harpoon"):setup({}) end },

  { "tomasky/bookmarks.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, config = function() require("bookmarks").setup({}) end },

  { "anuvyklack/fold-preview.nvim", dependencies = { "anuvyklack/keymap-amend.nvim" }, config = function() require("fold-preview").setup() end },
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
vim.keymap.set("n","<leader>fd",function() require("telescope.builtin").diagnostics() end,{ silent = true })

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

vim.keymap.set({ "n","x" },"<leader>re", function() require("refactoring").refactor("Extract Function") end)
vim.keymap.set({ "n","x" },"<leader>ri", function() require("refactoring").refactor("Inline Variable") end)

vim.keymap.set("n","<leader>ha", function() require("harpoon"):list():add() end)
vim.keymap.set("n","<leader>hm", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end)
vim.keymap.set("n","<leader>h1", function() require("harpoon"):list():select(1) end)
vim.keymap.set("n","<leader>h2", function() require("harpoon"):list():select(2) end)
vim.keymap.set("n","<leader>h3", function() require("harpoon"):list():select(3) end)
vim.keymap.set("n","<leader>h4", function() require("harpoon"):list():select(4) end)

vim.keymap.set("n","<leader>ps","<cmd>lua require('persistence').load()<cr>",{ silent = true })
vim.keymap.set("n","<leader>pl","<cmd>lua require('persistence').load({ last = true })<cr>",{ silent = true })
vim.keymap.set("n","<leader>pd","<cmd>lua require('persistence').stop()<cr>",{ silent = true })

vim.keymap.set("n", "<leader>zy", function()
  local diags = vim.diagnostic.get(0)
  if #diags == 0 then
    vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
    return
  end
  local lines = {}
  for _, d in ipairs(diags) do
    table.insert(lines, d.lnum+1 .. ":" .. d.col+1 .. " " .. d.message)
  end
  vim.fn.setreg("+", table.concat(lines, "\n"))
  vim.notify("Diagnostics copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy buffer diagnostics to clipboard" })

-- Below is keymap labelling for which-key.nvim

local wk = require("which-key")

wk.add({
  -- File explorer
  { "<leader>e", function() require("oil").open() end, desc = "File Explorer" },

  -- Find
  { "<leader>f", group = "Find" },
  { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
  { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep Text" },
  { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
  { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
  { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
  { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "TODOs" },

  -- LSP
  { "<leader>s", group = "LSP" },
  { "<leader>sg", vim.lsp.buf.definition, desc = "Go to Definition" },
  { "<leader>si", vim.lsp.buf.implementation, desc = "Go to Implementation" },
  { "<leader>sR", vim.lsp.buf.references, desc = "References" },
  { "<leader>sK", vim.lsp.buf.hover, desc = "Hover Info" },
  { "<leader>sr", vim.lsp.buf.rename, desc = "Rename Symbol" },
  { "<leader>sa", function() require("actions-preview").code_actions() end, desc = "Code Action" },
  { "<leader>sd", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics List" },

  -- Git
  { "<leader>g", group = "Git" },
  { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },
  { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage" },
  { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
  { "<leader>gp", function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Hunk" },
  { "<leader>gb", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
  { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Diff File" },

  -- Window
  { "<leader>w", group = "Window" },
  { "<leader>ww", "<C-w>w", desc = "Next Window" },
  { "<leader>wh", "<C-w>h", desc = "Left Window" },
  { "<leader>wj", "<C-w>j", desc = "Down Window" },
  { "<leader>wk", "<C-w>k", desc = "Up Window" },
  { "<leader>wl", "<C-w>l", desc = "Right Window" },
  { "<leader>ws", "<cmd>split<CR>", desc = "Horizontal Split" },
  { "<leader>wv", "<cmd>vsplit<CR>", desc = "Vertical Split" },
  { "<leader>wq", "<C-w>q", desc = "Close Window" },
  { "<leader>wo", "<C-w>o", desc = "Only Window" },
  { "<leader>w=", "<C-w>=", desc = "Balance Windows" },

  -- Tasks & Terminals
  { "<leader>t", group = "Tasks/Term" },
  { "<leader>tt", "<cmd>OverseerToggle<CR>", desc = "Tasks Panel" },
  { "<leader>tr", "<cmd>OverseerRun<CR>", desc = "Run Task" },
  { "<leader>tv", "<cmd>ToggleTerm<CR>", desc = "Terminal" },

  -- Debug
  { "<leader>d", group = "Debug" },
  { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
  { "<leader>dc", function() require("dap").continue() end, desc = "Continue Debug" },
  { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
  { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
  { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },

  -- Utilities
  { "<leader>z", group = "Utils" },
  { "<leader>zy", function()
      local diags = vim.diagnostic.get(0)
      if #diags == 0 then
        vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
        return
      end
      local lines = {}
      for _, d in ipairs(diags) do
        table.insert(lines, (d.lnum + 1) .. ":" .. (d.col + 1) .. " " .. d.message)
      end
      vim.fn.setreg("+", table.concat(lines, "\n"))
      vim.notify("Diagnostics copied to clipboard", vim.log.levels.INFO)
    end, desc = "Copy Diagnostics" },
})