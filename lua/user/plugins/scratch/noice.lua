local u = require("utils")

---@param bufnr number
local function highlightsInStacktrace(bufnr)
  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    vim.api.nvim_buf_call(bufnr, function()
      vim.fn.matchadd("WarningMsg", [[[^/]\+\.lua:\d\+\ze:]]) -- \ze: lookahead
    end)
  end, 1)
end

--------------------------------------------------------------------------------

-- DOCS https://github.com/folke/noice.nvim#-routes
local routes = {
  -- REDIRECT TO POPUP
  {
    filter = {
      min_height = 10,
      ["not"] = {
        cond = function(msg)
          local title = (msg.opts and msg.opts.title) or ""
          return title:find("Commit Preview")
              or title:find("tinygit")
              or title:find("Changed Files")
        end,
      },
    },
    view = "popup",
  },

  -----------------------------------------------------------------------------
  -- REDIRECT TO MINI

  -- write/deletion messages
  { filter = { event = "msg_show", find = "%d+B written$" },              view = "mini" },
  { filter = { event = "msg_show", find = "%d+L, %d+B$" },                view = "mini" },
  { filter = { event = "msg_show", find = "%-%-No lines in buffer%-%-" }, view = "mini" },

  -- search pattern not found
  { filter = { event = "msg_show", find = "^E486: Pattern not found" },   view = "mini" },

  -- Word added to spellfile via `zg`
  { filter = { event = "msg_show", find = "^Word .*%.add$" },             view = "mini" },

  { -- Mason
    filter = {
      event = "notify",
      cond = function(msg) return msg.opts and (msg.opts.title or ""):find("mason") end,
    },
    view = "mini",
  },

  -- nvim-treesitter
  { filter = { event = "msg_show", find = "^%[nvim%-treesitter%]" },            view = "mini" },
  { filter = { event = "notify", find = "All parsers are up%-to%-date" },       view = "mini" },

  -----------------------------------------------------------------------------
  -- SKIP

  -- supermaven, -- PENDING https://github.com/supermaven-inc/supermaven-nvim/issues/18
  { filter = { event = "msg_show", find = "Supermaven Free Tier is running." }, skip = true },

  -- FIX LSP bugs?
  { filter = { event = "msg_show", find = "lsp_signature? handler RPC" },       skip = true },
  {
    filter = { event = "msg_show", find = "^%s*at process.processTicksAndRejections" },
    skip = true,
  },

  -- code actions
  { filter = { event = "notify", find = "No code actions available" },           skip = true },

  -- unneeded info on search patterns
  { filter = { event = "msg_show", find = "^[/?]." },                            skip = true },

  -- E211 no longer needed, since auto-closing deleted buffers
  { filter = { event = "msg_show", find = "E211: File .* no longer available" }, skip = true },
}

--------------------------------------------------------------------------------

return {
  {                     -- Message & Command System Overhaul
    "folke/noice.nvim",
    event = "VimEnter", -- earlier to catch notifications on startup
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "nvim-lualine/lualine.nvim",
    },
    keys = {
      {
        "<Esc>",
        function()
          vim.snippet.stop()
          vim.cmd.NoiceDismiss()
        end,
        desc = "󰎟 Clear Notifications & Snippet",
      },
      { "<D-0>", vim.cmd.NoiceHistory, mode = { "n", "x", "i" }, desc = "󰎟 Noice Log" },
      { "<D-9>", vim.cmd.NoiceLast, mode = { "n", "x", "i" }, desc = "󰎟 Noice Last" },
    },
    opts = {
      routes = routes,
      cmdline = {
        view = "mini",
        format = {
          search_down = { icon = "  ", view = "cmdline" },
        },
      },
      -- DOCS https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua
      views = {
        cmdline_popup = {
          border = { style = vim.g.borderStyle },
          padding = { 2, 2 }
        },
        mini = {
          timeout = 3000,
          zindex = 10,                          -- lower, so it does not cover nvim-notify
          position = { col = -64, row = -12 },  -- to the left to avoid collision with scrollbar
          format = { "{title} ", "{message}" }, -- leave out "{level}"
        },
        hover = {
          border = { style = vim.g.borderStyle },
          size = { max_width = 80 },
          win_options = {
            scrolloff = 4,
            wrap = true,
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        popup = {
          border = { style = vim.g.borderStyle },
          size = { width = 90, height = 25 },
          win_options = { scrolloff = 8, wrap = true, concealcursor = "nv" },
          close = { keys = { "q", "<D-w>", "<D-9>", "<D-0>" } },
        },
        split = {
          enter = true,
          size = "5%",
          win_options = { scrolloff = 6 },
          close = { keys = { "q", "<D-w>", "<D-9>", "<D-0>" } },
        },
      },
      commands = {
        history = {
          view = "split",
          filter_opts = { reverse = true }, -- show newest entries first
          -- https://github.com/folke/noice.nvim#-formatting
          opts = { format = { "{title} ", "{cmdline} ", "{message}" } },
        },
        last = {
          view = "popup",
          -- https://github.com/folke/noice.nvim#-formatting
          opts = { format = { "{title} ", "{cmdline} ", "{message}" } },
        },
      },

      -- DISABLE features, since conflicts with existing plugins I prefer to use
      lsp = {
        progress = { enabled = false },
        signature = { enabled = false }, -- using lsp_signature.nvim instead

        -- ENABLE features
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      -- PENDING https://github.com/rcarriga/nvim-notify/pull/277
      -- render = "wrapped-compact",
      render = require("utils.TEMP-wrapped-compact"),

      max_width = math.floor(vim.o.columns * 0.45),
      minimum_width = 15,
      top_down = false,
      level = vim.log.levels.TRACE, -- minimum severity
      stages = "slide",
      icons = { ERROR = "", WARN = "▲", INFO = "●", TRACE = "", DEBUG = "" },
      on_open = function(win)
        -- set borderstyle
        if not vim.api.nvim_win_is_valid(win) then return end
        vim.api.nvim_win_set_config(win, { border = vim.g.borderStyle })

        local bufnr = vim.api.nvim_win_get_buf(win)
        highlightsInStacktrace(bufnr)
      end,
    },
    config = function()
      local noiceconfig = require('noice.config')
      require('noice').setup({
        cmdline = {
          view = 'cmdline',
          format = vim.tbl_extend('force', noiceconfig.defaults().cmdline.format, {
            -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            -- view: (default is cmdline view)
            -- opts: any options passed to the view
            -- icon_hl_group: optional hl_group for the icon
            -- title: set to anything or empty string to hide
            cmdline = { pattern = '^:', icon = '󰅂', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '', lang = 'bash' },
            lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua', icon_hl_group = 'DevIconLua' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
            -- register <c-r> =
            calculator = { pattern = '^=', icon = '󰃬', lang = 'vimnormal' },
            input = {}, -- Used by input()
            -- lua = false, -- to disable a format, set to `false`
            increname = { pattern = '^:%s*IncRename%s+', icon = '󰑕', icon_hl_group = 'NoiceCmdlinePrompt' },
          }),
        },
        messages = {
          -- NOTE: If you enable messages, then the cmdline is enabled automatically.
          -- This is a current Neovim limitation.
          enabled = true,              -- enables the Noice messages UI
          view = 'notify',             -- default view for messages
          view_error = 'notify',       -- view for errors
          view_warn = 'notify',        -- view for warnings
          view_history = 'messages',   -- view for :messages
          view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
        },
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = false,      -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
        routes = {
          {
            filter = {
              event = 'notify',
              warning = true,
              find = 'To execute the command you must write the buffer contents.',
            },
            view = 'mini',
          },
        },
      })
    end,
    require("lualine-ext").init_noice()
  },
}
