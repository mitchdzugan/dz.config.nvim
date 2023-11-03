-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


require('orgmode').setup_ts_grammar()
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "clojure", "javascript", "lua", "vim", "vimdoc", "query", "org" },
  sync_install = false,
  auto_install = true,

  -- parser_install_dir = "/some/path/to/store/parsers"
  -- -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,
    -- disable = { "c", "rust" },
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}
require('orgmode').setup({
  mappings = { disable_all = true }
})

local ivy_full = {
  theme = "ivy",
  layout_config = {
    height_ratio = 1.0,
  }
}

local ivy_compact = {
  theme = "ivy",
  layout_config = {
    height_ratio = 0.75,
  }
}

require('telescope').setup{
  defaults = {
    theme = "ivy",
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<esc>"] = "close",
        ["<C-h>"] = "which_key",
      }
    }
  },
  pickers = {
    -- GLOBAL
    find_files = ivy_compact,
    live_grep = ivy_full,
    buffers = ivy_compact,
    help_tags = ivy_compact,
    current_buffer_fuzzy_find = ivy_full,
    treesitter = ivy_full,
  }
}

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}

require('lualine').setup()

local paredit = require("nvim-paredit")
paredit.setup({
  use_default_keys = false,
  indent = {
    enabled = true,
  }
})

local wk = require("which-key")
local vimk = {
  name = "nvim",
  d = { "<cmd>e ~/.config/nvim/<cr>", "open vim directory" },
  v = { "<cmd>e ~/.config/nvim/init.vim<cr>", "edit `init.vim`" },
  l = { "<cmd>e ~/.config/nvim/lua/init.lua<cr>", "edit `init.lua`" },
  p = { "<cmd>e ~/.config/nvim/lua/plugins.lua<cr>", "edit `plugins.lua`" },
}
local configk = {
  name = "configs",
  d = { "<cmd>e ~/.config/<cr>", "open config directory" },
  v = vimk,
}

local function do_paredit(fn_name, do_continue)
  return function()
    paredit.api[fn_name]()
    if (do_continue) then
      vim.cmd("execute \"WhichKey <leader>L\"")
    end
  end
end
local function strsplit (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end
local function pretty_date(d)
  return os.date("%Y_%m_%d", d)
end
local function mk_date_str(offset_, from_time_)
  offset = ((offset_ ~= nil) and offset_) or 0
  from_time = ((from_time_ ~= nil) and from_time_) or os.time(os.date("!*t"))
  return pretty_date(from_time + (offset * 60 * 60 * 24))
end
local function mk_todo_filename(offset)
  if (offset == nil) then return mk_date_str() end
  local currfile = vim.api.nvim_buf_get_name(0)
  local steps = strsplit(currfile, "/")
  local fname_parts = strsplit(steps[#steps] or "", ".")
  local date_parts = strsplit(fname_parts[1] or "", "_")
  if (#date_parts ~= 3) then return mk_date_str(offset) end
  local from_time = os.time(
    { year=date_parts[1], month=date_parts[2], day=date_parts[3], hour=12 }
  )
  return mk_date_str(offset, from_time)
end
local function open_todo(offset)
  return function()
    vim.cmd("e ~/.todos/" .. mk_todo_filename(offset) .. ".org")
  end
end
local function mk_lispk(do_continue_)
  local do_continue = do_continue_ == true
  return {
    name = "lisp" .. ((do_continue and " - cont.") or ""),
    b = { do_paredit("barf_forwards", do_continue), "barf" },
    s = { do_paredit("slurp_forwards", do_continue), "slurp" },
    B = { do_paredit("barf_backwards", do_continue), "barf back" },
    S = { do_paredit("slurp_backwards", do_continue), "slurp back" },
    d = { do_paredit("delete_element", do_continue), "delete element" },
    D = { do_paredit("delete_form", do_continue), "delete form" },
    h = { do_paredit("drag_element_forwards", do_continue), "drag element" },
    k = { do_paredit("raise_element", do_continue), "raise element" },
    l = { do_paredit("drag_element_backwards", do_continue), "drag element back" },
    H = { do_paredit("drag_form_forwards", do_continue), "drag form" },
    K = { do_paredit("raise_form", do_continue), "raise form" },
    L = { do_paredit("drag_form_backwards", do_continue), "drag form back" },
    f = { do_paredit("move_to_next_element", do_continue), "move next" },
    F = { do_paredit("move_to_prev_element", do_continue), "move prev" },
    ["<Space>"] = { "!a)zprint<cr>", "format form" },
  }
end
local orgm = require('orgmode')
wk.register(
  {
    name = "nvim commands",
    ["<tab>"] = { "<cmd>TabMRU<cr>", "most recent buffer [tab local]" },
    ["<Up>"]    = { "<C-w><Up>"   , "navigate windows up"    },
    ["<Right>"] = { "<C-w><Right>", "navigate windows right" },
    ["<Down>"]  = { "<C-w><Down>" , "navigate windows down"  },
    ["<Left>"]  = { "<C-w><Left>" , "navigate windows left"  },
    ["["] = { "%", "goto matching brace" },
    [","] = { "<cmd>WhichKey ;<cr>", "filetype specific" },
    ["/"] = { "<cmd>noh<cr>", "clear search" },
    v = vimk,
    c = configk,
    b = { "<cmd>Telescope buffers<cr>", "open buffers" },
    f = {
      name = "file",
      p = { "<cmd>e ~/Projects/<cr>", "open projects directory" },
      f = { "<cmd>Telescope find_files<cr>", "find file" },
      b = { "<cmd>Telescope buffers<cr>", "open buffers" },
      r = { "<cmd>Telescope oldfiles<cr>", "recent files" },
      v = vimk,
      c = configk,
      g = { "<cmd>Telescope live_grep grep_current_only=true<cr>", "grep current file" },
      t = { "<cmd>NvimTreeToggle<cr>", "toggle file tree" },
    },
    o = {
      name="org",
      o = { open_todo(), "open today's todos" },
      t = { function()
        orgm.action("org_mappings.insert_todo_heading_respect_content")
      end, "open todo"},
      ["<Space>"] = { open_todo(), "open today's todos" },
      ["<Left>"] = { open_todo(-1), "back 1 day's todos" },
      ["<Right>"] = { open_todo(1), "forward 1 day's todos" },
    },
    s = {
      name = "search",
      p = { "<cmd>Telescope live_grep<cr>", "grep project" },
      f = { "<cmd>Telescope live_grep grep_current_only=true<cr>", "grep current file" },
      o = { "<cmd>Telescope live_grep grep_open_files=true<cr>", "grep open buffers" },
      s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "swoop in file" },
    },
    h = { "<cmd>Telescope help_tags<cr>", "help" },
    T = { "<cmd>Telescope colorscheme<cr>", "themes" },
    l = mk_lispk(false),
    L = mk_lispk(true),
  },
  {
    prefix = "<leader>"
  }
)

vim.keymap.set('n', '<space>', ':WhichKey <leader><cr>')

local function notify(funname, opts)
  opts.once = vim.F.if_nil(opts.once, false)
  local level = vim.log.levels[opts.level]
  if not level then
    error("Invalid error level", 2)
  end
  local notify_fn = opts.once and vim.notify_once or vim.notify
  notify_fn(string.format("[telescope.%s]: %s", funname, opts.msg), level, {
    title = "telescope.nvim",
  })
end

if (vim.g.dz_dev == nil) then
  vim.g.dz_dev = {
    backgrounded = 0,
    tabs = {},
    start_picking = function()
      local dz_dev = vim.g.dz_dev
      dz_dev.backgrounded = 0
      vim.g.dz_dev = dz_dev
    end,
    stop_picking = function()
      return nil -- pass for now
    end,
    prenav = function (fname, newtab, col, row)
      local dz_dev =  vim.g.dz_dev
      local currfile = vim.api.nvim_buf_get_name(0)
      local tab_id = vim.api.nvim_get_current_tabpage()
      local tabs = dz_dev.tabs
      local tab = tabs[tab_id] or {}
      if (newtab) then
        tab = dz_dev.newtab or {}
      end
      local history = tab.history or {}
      local position = math.min(tab.position or 0, #history)
      local new_position = position + 1
      local new_history = {}
      for i=1, position do new_history[i] = history[i] end
      new_history[new_position] = { fname = fname, col = col, row = row }
      tab.history = new_history
      tab.position = new_position
      if (tab.last_position == nil or history[tab.last_position].fname ~= currfile) then
        tab.last_position = ((new_history[position] == nil) and new_position) or position
      end
      if (newtab) then
        dz_dev.newtab = tab
      else
        tabs[tab_id] = tab
        dz_dev.tabs = tabs
      end
      vim.g.dz_dev = dz_dev
    end
  }
end

function handle_enter (ev)
  local currfile = vim.api.nvim_buf_get_name(0)
  if (currfile == "") then return end
  local tab_id = vim.api.nvim_get_current_tabpage()
  local dz_dev =  vim.g.dz_dev
  local tabs = dz_dev.tabs
  local tab = tabs[tab_id]
  if (tab == nil) then
    tab = dz_dev.newtab or {}
  end
  local history = tab.history or {}
  local position = math.min(tab.position or 0, #history)
  local is_set = (history[position] or {}).fname == currfile
  if (not is_set) then
    local new_position = position + 1
    local new_history = {}
    for i=1, position do new_history[i] = history[i] end
    new_history[new_position] = { fname = currfile }
    tab.history = new_history
    tab.position = new_position
    if (tab.last_position == nil or history[tab.last_position].fname ~= currfile) then
      tab.last_position = ((new_history[position] == nil) and new_position) or position
    end
  end
  tabs[tab_id] = tab
  dz_dev.newtab = nil
  dz_dev.tabs = tabs
  vim.g.dz_dev = dz_dev
end

vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"*"},
  callback = function(ev)
    handle_enter(ev)
  end
})

function move_in_tab_history(amount)
  local tab_id = vim.api.nvim_get_current_tabpage()
  local dz_dev =  vim.g.dz_dev
  local tabs = dz_dev.tabs
  local tab = tabs[tab_id] or {}
  local position = tab.position or 1
  local history = tab.history
  local new_position = math.min(#history, math.max(1, position + amount))
  local nav_data = history[new_position]
  if (new_position == position or nav_data == nil) then return end
  tab.position = new_position
  tabs[tab_id] = tab
  dz_dev.tabs = tabs
  vim.g.dz_dev = dz_dev
  vim.cmd("e " .. nav_data.fname)
  local row = nav_data.row
  local col = nav_data.col or 0
  if (row ~= nil) then
    vim.cmd("call cursor(" .. row .. ", " .. col ")")
  end
end

function back_tab_history() move_in_tab_history(-1) end
function frwd_tab_history() move_in_tab_history( 1) end
vim.api.nvim_create_user_command("TabHistoryBack", back_tab_history, { nargs = 0 })
vim.api.nvim_create_user_command("TabHistoryFrwd", frwd_tab_history, { nargs = 0 })
vim.keymap.set('n', 'H', ':TabHistoryBack<cr>')
vim.keymap.set('n', 'L', ':TabHistoryFrwd<cr>')

function mru_in_tab()
  local tab_id = vim.api.nvim_get_current_tabpage()
  local dz_dev =  vim.g.dz_dev
  local tabs = dz_dev.tabs
  local tab = tabs[tab_id] or {}
  local history = tab.history
  local position = tab.position or 1
  local last_position = tab.last_position or 1
  local nav_data = history[last_position]
  if (last_position == position or nav_data == nil) then return end
  tab.position = last_position
  tab.last_position = position
  tabs[tab_id] = tab
  dz_dev.tabs = tabs
  vim.g.dz_dev = dz_dev
  vim.cmd("e " .. nav_data.fname)
  local row = nav_data.row
  local col = nav_data.col or 0
  if (row ~= nil) then
    vim.cmd("call cursor(" .. row .. ", " .. col ")")
  end
end
vim.api.nvim_create_user_command("TabMRU", mru_in_tab, { nargs = 0 })

function print_dev_state ()
  print(vim.inspect(vim.g.dz_dev))
end

vim.api.nvim_create_user_command("DevState", print_dev_state, { nargs = 0 })

function apply_bg_tab(cmd)
  return function (opts)
    tab_id = vim.api.nvim_get_current_tabpage()
    vim.cmd("+" .. vim.g.dz_dev.backgrounded .. cmd .. " " .. opts.args .. " | tabn " .. tab_id)
  end
end

vim.api.nvim_create_user_command("BGtabedit", apply_bg_tab("tabe"), { nargs = "*" })
vim.api.nvim_create_user_command("BGtab"    , apply_bg_tab("tab") , { nargs = "*" })


require('tabby.tabline').set(function(line)
  local lsep =  ""
  local rsep =  ""
  local theme = {
    fill = 'TabLineFill',
    head = 'TabLine',
    current_tab = 'TabLineSel',
    tab = 'TabLine',
    win = 'TabLine',
    tail = 'TabLine',
  }
  local win_count = 0
  line.wins_in_tab(line.api.get_current_tab()).foreach(function()
    win_count = win_count + 1
  end)
  local win_printing_count = 0
  local is_first = true
  return {
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      lside = (is_first and " ") or line.sep(lsep, hl, theme.fill)
      is_first = false
      return {
        lside,
        tab.is_current() and '' or '󰆣',
        tab.name(),
        line.sep(rsep, hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      win_printing_count = win_printing_count + 1
      local is_last = win_count == win_printing_count
      return {
        line.sep(lsep, theme.win, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        ((is_last and " ") or line.sep(rsep, theme.win, theme.fill)),
        hl = theme.tab,
        margin = ' ',
      }
    end),
    hl = theme.fill,
  }
end)

require('nvim-cursorline').setup {
  cursorline = {
    enable = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

require("tidy").setup {}

require "coq"

require "coq_3p" {
  { src = "builtin/clojure", short_name = "clj" },
}

require("ibl").setup()
require("nvim-tree").setup()
require('gitsigns').setup()
