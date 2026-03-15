local function abbrev(from, to)
  vim.cmd(string.format(
    [[cnoreabbrev <expr> %s getcmdtype() == ':' && getcmdline() =~# '^\s*%s\>' ? '%s' : '%s']],
    from, from, to, from
  ))
end

-- plugin commands
abbrev("git",       "Git")
abbrev("telescope", "Telescope")

-- quit
abbrev("Q",  "q")
abbrev("1",  "q")
abbrev("1a", "qa")

-- write
abbrev("W",  "w")
abbrev("2",  "w")

-- write + quit
abbrev("qw", "wq")