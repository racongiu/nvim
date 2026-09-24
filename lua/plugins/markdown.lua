-- render-markdown.nvim: in-buffer markdown rendering (headings, code blocks,
-- tables, checkboxes) via the bundled markdown/markdown_inline treesitter
-- parsers; glyphs come from mini.icons, read directly by render-markdown
require("render-markdown").setup({
	latex = { enabled = false }, -- no latex toolchain installed (see snacks.image)
})
