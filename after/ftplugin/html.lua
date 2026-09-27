-- 2-space indent. A project .editorconfig overrides this.
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

-- No standard line length for HTML (long text, URLs, inline SVG): no bar (utils/overlength.lua)
vim.b.overlength = false
