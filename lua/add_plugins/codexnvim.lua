return {
  "johnseth97/codex.nvim",

  lazy = false,

  cmd = { "Codex", "CodexToggle" },

  opts = {
    border = "rounded",
    width = 0.30,
    height = 0.8,
    model = nil,
    autoinstall = true,
    keymaps = {
      quit = nil,
    },
  },

  init = function()
    require("utils").load_mappings("codex")
  end,

  config = function(_, opts)
    local codex = require("codex")
    codex.setup(opts)

    local state = require("codex.state")
    local original_open = codex.open
    local fn = vim.fn
    local api = vim.api

    local function target_width()
      local configured = opts.width
      if type(configured) ~= "number" then
        return nil
      end
      if configured > 0 and configured < 1 then
        return math.max(20, math.floor(vim.o.columns * configured))
      end
      return math.max(20, math.floor(configured))
    end

    codex.open = function()
      if state.win and api.nvim_win_is_valid(state.win) then
        api.nvim_set_current_win(state.win)
        return
      end

      local needs_bootstrap = (not state.buf or not api.nvim_buf_is_valid(state.buf)) or not state.job
      if needs_bootstrap then
        original_open()
      end

      local buf = state.buf
      if not buf or not api.nvim_buf_is_valid(buf) then
        return
      end

      local float_win = state.win
      if float_win and api.nvim_win_is_valid(float_win) then
        api.nvim_win_close(float_win, true)
      end
      state.win = nil

      vim.cmd("botright vsplit")
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, buf)
      vim.cmd("wincmd L")
      win = vim.api.nvim_get_current_win()

      local function enforce_width()
        local width = target_width()
        if width and vim.api.nvim_win_get_width(win) ~= width then
          pcall(vim.api.nvim_win_set_width, win, width)
        end
      end

      enforce_width()

      for _, opt in ipairs({ "number", "relativenumber", "cursorline" }) do
        pcall(vim.api.nvim_win_set_option, win, opt, false)
      end
      pcall(vim.api.nvim_win_set_option, win, "winfixwidth", true)

      state.win = win

      local enforce_group = api.nvim_create_augroup("CodexWinEnforce", { clear = false })
      api.nvim_clear_autocmds({ group = enforce_group })
      api.nvim_create_autocmd({ "WinResized", "VimResized", "BufWinEnter" }, {
        group = enforce_group,
        callback = function(args)
          if not (state.win and api.nvim_win_is_valid(state.win)) then
            return
          end
          if args.event == "BufWinEnter" then
            if api.nvim_buf_get_option(args.buf, "filetype") ~= "codex" then
              return
            end
          end
          if api.nvim_win_get_width(state.win) ~= target_width() then
            enforce_width()
            pcall(api.nvim_win_set_option, state.win, "winfixwidth", true)
          end
        end,
      })
    end

    -- Resolve a fresh terminal channel for the current Codex buffer
    local function get_codex_chan()
      if not (state.win and api.nvim_win_is_valid(state.win)) then
        return nil
      end
      local buf = api.nvim_win_get_buf(state.win)
      if not (buf and api.nvim_buf_is_valid(buf)) then
        return nil
      end

      local chan = vim.b[buf].terminal_job_id or vim.bo[buf].channel or state.job
      if not chan then
        return nil
      end

      -- verify channel is alive
      local ok = pcall(vim.api.nvim_get_chan_info, chan)
      if not ok then
        return nil
      end
      return chan, buf
    end

    -- open & wait until terminal is ready, then call cb(chan, buf)
    local function with_ready_codex(cb)
      codex.open()

      local tries = 0
      local function try_once()
        local chan, buf = get_codex_chan()
        if chan then
          cb(chan, buf)
          return
        end
        tries = tries + 1
        if tries <= 10 then
          vim.defer_fn(try_once, 40) -- wait 40ms and retry
        else
          -- last resort: hard re-bootstrap (original open spawns job)
          original_open()
          vim.defer_fn(function()
            local c2, b2 = get_codex_chan()
            if c2 then
              cb(c2, b2)
            else
              vim.notify("Codex: no terminal channel available", vim.log.levels.ERROR)
            end
          end, 80)
        end
      end

      try_once()
    end

    -- safer yank (your helper is fine; keeping as-is)
    local function yank_visual_selection()
      local mode = fn.mode()
      if not mode or not mode:match("[vV\22]") then
        return nil, nil
      end
      local original = fn.getreg("z")
      local original_type = fn.getregtype("z")
      local ok = pcall(vim.cmd, [[silent! normal! "zy]])
      if not ok then
        fn.setreg("z", original, original_type)
        return nil, nil
      end
      local text = fn.getreg("z")
      local regtype = fn.getregtype("z")
      fn.setreg("z", original, original_type)
      if not text or text == "" then
        return nil, nil
      end
      return text, regtype
    end

    function codex.send_visual_selection()
      local text = select(1, yank_visual_selection())
      if not text then
        vim.notify("Select some text before sending to Codex", vim.log.levels.WARN)
        return
      end

      with_ready_codex(function(chan, buf)
        -- Build message block (use \n newlines for chansend)
        local nl = "\n"
        local first = (api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "")
        local prefix = first:match("^%s*> You are") and nl or ""
        local block = prefix .. "```" .. nl .. text
        if not text:match("[\r\n]$") then
          block = block .. nl
        end
        block = block .. "```" .. nl .. nl

        local ok, err = pcall(api.nvim_chan_send, chan, block)
        if not ok then
          -- If chansend failed, try once more after a short delay
          vim.defer_fn(function()
            local c2, _ = get_codex_chan()
            if not c2 then
              vim.notify("Codex: send failed; no channel", vim.log.levels.ERROR)
              return
            end
            local ok2, err2 = pcall(api.nvim_chan_send, c2, block)
            if not ok2 then
              vim.notify("Codex: send failed: " .. tostring(err2), vim.log.levels.ERROR)
            end
          end, 60)
        end

        -- ensure the Codex window is focused (optional)
        if state.win and api.nvim_win_is_valid(state.win) then
          api.nvim_set_current_win(state.win)
        end
      end)
    end

    vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
      pattern = "*",
      callback = function(args)
        local buf = args.buf
        local api = vim.api

        -- Only act on Codex buffers
        local ft = vim.bo[buf].filetype
        local name = api.nvim_buf_get_name(buf)
        if ft ~= "codex" and not name:match("codex") then
          return
        end

        local esc_termcode = api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)

        local function close_codex()
          if package.loaded["codex"] and require("codex").close then
            require("codex").close()
          end
        end

        -- In terminal mode: leave terminal without immediately closing Codex
        vim.keymap.set(
          "t",
          "<Esc>",
          esc_termcode,
          { buffer = buf, noremap = true, silent = true, desc = "Codex: exit terminal on Esc" }
        )

        -- Keep <Esc> for normal-mode movement; use q to close the Codex window instead
        vim.keymap.set("n", "q", close_codex, { buffer = buf, noremap = true, silent = true, desc = "Codex: close" })
      end,
    })
  end,
}
