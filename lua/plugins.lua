-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- themes
  use "savq/melange-nvim"
  use "rose-pine/neovim"
  use "EdenEast/nightfox.nvim"
  use "cesardeazevedo/fx-colorscheme"
  use "sainnhe/sonokai"
  use "sainnhe/everforest"
  use "sainnhe/edge"
  use "catppuccin/nvim"
  use "folke/tokyonight.nvim"
  use "rebelot/kanagawa.nvim"
  -- /themes
  use "jbyuki/venn.nvim"
  use "nvim-tree/nvim-tree.lua"
  use "lewis6991/gitsigns.nvim"
  use "yamatsum/nvim-cursorline"
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  use {
    '~/Projects/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use "julienvincent/nvim-paredit"
  use {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  }
  use "lukas-reineke/indent-blankline.nvim"
  use "HiPhish/rainbow-delimiters.nvim"
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = false
      vim.o.timeoutlen = 0
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  use "mcauley-penney/tidy.nvim"
  use {
    "ms-jpq/coq_nvim",
    branch = "coq"
  }
  use {
    "ms-jpq/coq.thirdparty",
    branch = "3p"
  }
  use 'nanozuki/tabby.nvim'
  use {
    'nvim-orgmode/orgmode',
    config = function()
      require('orgmode').setup{}
    end
  }
end)
