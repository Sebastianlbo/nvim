local abbrev = require("utils").abbrev

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
