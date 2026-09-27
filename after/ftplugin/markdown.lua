-- Prose: soft-wrap long lines at word boundaries (display only, the file is unchanged).
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- Prose: no line-length bar (utils/overlength.lua)
vim.b.overlength = false
