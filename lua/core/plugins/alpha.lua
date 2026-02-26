local utils = require("utils")

return {
	"goolord/alpha-nvim",

	lazy = false,

	dependencies = { "nvim-tree/nvim-web-devicons" },

	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		local nvdash = utils.ui and utils.ui.nvdash or {}
		local hdr = nvdash.header0 or dashboard.section.header.val

		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.header.opts.position = "center"
		dashboard.section.header.val = hdr

		-- Helper: prompt for a new filename and open it
		local function prompt_new_file()
			local fn = vim.fn
			local cwd = fn.getcwd()
			local base = (
				(vim.g.alpha_newfile_lastdir and vim.g.alpha_newfile_lastdir ~= "")
					and (vim.g.alpha_newfile_lastdir .. "/")
				or (cwd .. "/")
			)

			-- Use built-in input with 'file' completion so <Tab> completes paths.
			local name = fn.input("New file: ", base, "file")
			if not name or name == "" then
				return
			end
			name = fn.expand(name)
			pcall(function()
				name = vim.fs.normalize(name)
			end)
			local dir = fn.fnamemodify(name, ":h")
			if dir ~= "" and dir ~= "." then
				pcall(fn.mkdir, dir, "p")
			end
			vim.g.alpha_newfile_lastdir = dir
			vim.cmd("edit " .. fn.fnameescape(name))
		end

		-- Helper: safely detect if we're inside a Git repository (avoid prompts)
		local function in_git_repo()
			-- Use git rev-parse which exits 0 when inside a work tree
			-- Use list form to avoid shell and any interactive prompts
			pcall(vim.fn.system, { "git", "-C", vim.fn.getcwd(), "rev-parse", "--is-inside-work-tree" })
			return vim.v.shell_error == 0
		end

		local nvterm = require("nvterm.terminal")

		local function open_terminal()
			nvterm.new("vertical")
			local keep = vim.api.nvim_get_current_buf()

			pcall(vim.cmd, "silent! only")

			local function is_dashboard(buf)
				local ft = vim.bo[buf].filetype
				if ft == "nvdash" or ft == "dashboard" or ft == "alpha" then
					return true
				end
				local name = (vim.api.nvim_buf_get_name(buf):match("[^/]+$") or ""):lower()
				return name:find("nvdash") or name:find("dashboard") or name:find("alpha")
			end

			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if buf ~= keep and vim.api.nvim_buf_is_loaded(buf) then
					if vim.bo[buf].buflisted or is_dashboard(buf) then
						pcall(vim.api.nvim_buf_delete, buf, { force = true })
					end
				end
			end
		end

		local items = {
			{ key = "@", label = "󰈔  Cycle Header", cmd = ":lua _G.alpha_cycle_header()<CR>" },
			{ key = "@", label = "󰈔  Cycle Header", cmd = ":lua _G.alpha_cycle_header()<CR>" },
			{ key = "f", label = "  Find File", cmd = ":Telescope find_files<CR>" },
			{ key = "o", label = "󰈚  Recent Files", cmd = ":Telescope oldfiles<CR>" },
			{ key = "e", label = "  File Explorer", cmd = ":NvimTreeToggle <CR>" },
			{ key = "c", label = "󰚩  Claude", cmd = ":ClaudeCode <CR>" },
			{ key = "g", label = "  Git Status", cmd = ":LazyGit<CR>" },
			{ key = "d", label = "  Git Diff", cmd = ":DiffviewOpen HEAD<CR>" },
			{ key = "t", label = "  Terminal", action = open_terminal },
			{ key = "w", label = "󰈭  Find Word", cmd = ":Telescope live_grep<CR>" },
			{ key = "m", label = "  Marks", cmd = ":Telescope marks<CR>" },
			{ key = "n", label = "  New File", action = prompt_new_file },
			{ key = "q", label = "  Quit", cmd = ":qa<CR>" },
		}

		-- Build two columns of aligned text
		local fn = vim.fn
		local function dwidth(s)
			return fn.strdisplaywidth(s)
		end
		local function pad_to(s, w)
			local dw = dwidth(s)
			return s .. string.rep(" ", math.max(0, w - dw))
		end
		local function sp(n)
			return string.rep(" ", math.max(0, n))
		end

		local left, right = {}, {}
		for i, it in ipairs(items) do
			local key = string.format("[%s]", it.key)
			if i % 2 == 1 then
				table.insert(left, { key = key, label = it.label })
			else
				table.insert(right, { key = key, label = it.label })
			end
		end

		local left_key_w, right_key_w = 0, 0
		for _, r in ipairs(left) do
			left_key_w = math.max(left_key_w, dwidth(r.key))
		end
		for _, r in ipairs(right) do
			right_key_w = math.max(right_key_w, dwidth(r.key))
		end

		local function build_rows(col, key_w)
			local out = {}
			for _, r in ipairs(col) do
				table.insert(out, pad_to(r.key, key_w) .. "  " .. r.label)
			end
			return out
		end

		local left_rows = build_rows(left, left_key_w)
		local right_rows = build_rows(right, right_key_w)

		local left_w, right_w = 0, 0
		for _, s in ipairs(left_rows) do
			left_w = math.max(left_w, dwidth(s))
		end
		for _, s in ipairs(right_rows) do
			right_w = math.max(right_w, dwidth(s))
		end

		local gap = 30

		local rows = math.max(#left_rows, #right_rows)
		local lines = {}
		local function hl_ranges_for_keys(str)
			local hl = {}
			local init = 1
			while true do
				local s, e = string.find(str, "%[[^%]]%]", init)
				if not s then
					break
				end
				table.insert(hl, { "AlphaKeyHint", s - 1, e })
				init = e + 1
			end
			return hl
		end

		for i = 2, rows do
			local L = left_rows[i] or ""
			local R = right_rows[i] or ""
			local Lp = pad_to(L, left_w)
			local Rp = pad_to(R, right_w)
			local val = (i ~= 4) and (Lp .. sp(gap) .. Rp)
				or (Lp .. sp(gap / 2 - 7) .. "󰙴  Press @ 󰙴 " .. sp(gap / 2 - 6) .. Rp)
			local hl = hl_ranges_for_keys(val)
			if i == 4 then
				local s, e = string.find(val, "󰙴  Press @ 󰙴 ")
				if s then
					table.insert(hl, { "AlphaKeyHint", s - 1, e })
				end
			end
			table.insert(lines, { type = "text", val = val, opts = { position = "center", hl = hl } })
		end

		local function footer()
			local v = vim.version()
			local stats = (pcall(require, "lazy") and require("lazy").stats()) or {}
			local count = stats and stats.count or 0
			return string.format(" v%d.%d.%d    %d plugins", v.major, v.minor, v.patch, count)
		end
		dashboard.section.footer.val = footer()
		dashboard.section.footer.opts.position = "center"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		-- Compute dynamic vertical padding to center content
		local group_spacing = 1
		local header_lines = type(dashboard.section.header.val) == "table" and #dashboard.section.header.val or 1
		local menu_lines = #lines
		local footer_lines = type(dashboard.section.footer.val) == "table" and #dashboard.section.footer.val or 1
		local inner_padding = 2 -- one between header->menu and one between menu->footer
		local total_content = header_lines
			+ menu_lines
			+ math.max(0, (menu_lines - 1) * group_spacing)
			+ footer_lines
			+ inner_padding

		local win_height = vim.api.nvim_win_get_height(0)
		local free = win_height - total_content
		if free < 0 then
			free = 0
		end
		local top_pad = math.floor(free / 2)
		local bottom_pad = free - top_pad

		local layout = {
			-- Symmetric vertical padding; equal or off by 1 when odd
			{ type = "padding", val = math.max(0, top_pad) },
			dashboard.section.header,
			{ type = "padding", val = 1 },
			{ type = "group", val = lines, opts = { position = "center", spacing = group_spacing } },
			{ type = "padding", val = 1 },
			dashboard.section.footer,
			{ type = "padding", val = bottom_pad },
		}

		return { layout = layout, opts = { margin = 5 }, __items = items }
	end,

	config = function(_, opts)
		require("alpha").setup(opts)

		-- Normalize a header into a table of lines
		local function normalize_header(h)
			if type(h) == "string" then
				local t = {}
				for line in (h .. "\n"):gmatch("(.-)\n") do
					table.insert(t, line)
				end
				return t
			elseif type(h) == "table" then
				return h
			end
			return nil
		end

		local nvdash = utils.ui and utils.ui.nvdash or {}
		local h0 = normalize_header(nvdash.header0)
		local h1 = normalize_header(nvdash.header1)
		local h2 = normalize_header(nvdash.header2)

		_G.alpha_headers = _G.alpha_headers or {}
		_G.alpha_headers = vim.tbl_filter(function(h)
			return type(h) == "table" and #h > 0
		end, { h1, h2, h1, h0 })

		if #_G.alpha_headers == 0 then
			local dashboard = require("alpha.themes.dashboard")
			_G.alpha_headers = { dashboard.section.header.val }
		end

		_G.alpha_header_idx = _G.alpha_header_idx or 1

		_G.alpha_cycle_header = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			local headers = _G.alpha_headers
			local i = _G.alpha_header_idx
			local new_header = headers[i]
			if not new_header then
				return
			end

			dashboard.section.header.val = new_header

			-- Recompute padding against your returned layout
			local l = opts.layout
			local group = l[4]
			local group_spacing = (group.opts and group.opts.spacing) or 1
			local header_lines = #dashboard.section.header.val
			local menu_lines = #group.val
			local footer_lines = (type(dashboard.section.footer.val) == "table") and #dashboard.section.footer.val or 1
			local inner_padding = 2

			local win_height = vim.api.nvim_win_get_height(0)
			local total_content = header_lines
				+ menu_lines
				+ math.max(0, (menu_lines - 1) * group_spacing)
				+ footer_lines
				+ inner_padding

			local free = math.max(0, win_height - total_content)
			l[1].val = math.floor(free / 2) -- top padding
			l[#l].val = free - l[1].val -- bottom padding

			alpha.redraw()

			_G.alpha_header_idx = (i % #headers) + 1
		end

		-- Show Alpha only when starting with no files
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 0 and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
					require("alpha").start(true)
				end
			end,
		})

		-- Highlight bracketed shortcuts like [f], [w] using the header orange
		local ns_alpha_keys = vim.api.nvim_create_namespace("alpha_key_hl")

		local function highlight_alpha_keys(buf)
			if not buf or not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			-- clear previous highlights in case of redraw
			vim.api.nvim_buf_clear_namespace(buf, ns_alpha_keys, 0, -1)
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			for i, line in ipairs(lines) do
				local init = 1
				while true do
					-- match a single character inside brackets, e.g. [f]
					local s, e = string.find(line, "%[[^%]]%]", init)
					if not s then
						break
					end
					-- Use extmarks with priority to avoid being overridden by line highlights
					pcall(vim.api.nvim_buf_set_extmark, buf, ns_alpha_keys, i - 1, s - 1, {
						end_col = e,
						hl_group = "AlphaKeyHint",
						priority = 10000,
						hl_mode = "combine",
					})
					init = e + 1
				end
			end
		end

		-- Bind single-letter keys when Alpha is ready
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function(ev)
				local buf = ev.buf
				local items = opts.__items or {}
				for _, it in ipairs(items) do
					vim.keymap.set("n", it.key, function()
						if type(it.action) == "function" then
							it.action()
						elseif type(it.cmd) == "string" and it.cmd ~= "" then
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(it.cmd, true, false, true), "t", false)
						end
					end, { buffer = buf, nowait = true, noremap = true, silent = true, desc = it.label })
				end

				-- After alpha renders and mappings are set, color the [x] markers
				vim.schedule(function()
					highlight_alpha_keys(buf)
				end)

				-- Disable cursor movement with j/k/l in the Alpha buffer (leave 'h' usable for Cheatsheet)
				for _, key in ipairs({ "j", "k", "l", "h" }) do
					vim.keymap.set("n", key, "<Nop>", {
						buffer = buf,
						noremap = true,
						silent = true,
						nowait = true,
						desc = "Disable movement in Alpha",
					})
				end
			end,
		})
	end,
}
