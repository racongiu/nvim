-- Web tools (biome, prettier, eslint, stylelint), shared by plugins/lang/
-- typescript.lua, json.lua, yaml.lua, html.lua and css.lua.
-- Rule: a tool runs only when the project configures it; a biome config
-- replaces prettier, eslint and stylelint, but only for the filetypes biome
-- supports (scss, less, yaml stay with prettier/stylelint).
local M = {}

-- filetypes biome formats and lints (html: the project must opt in, in biome.json)
local biome_fts = {
	javascript = true,
	javascriptreact = true,
	typescript = true,
	typescriptreact = true,
	json = true,
	jsonc = true,
	css = true,
	html = true,
}

local function has(path, file, text)
	local f = io.open(vim.fs.joinpath(path, file))
	if not f then
		return false
	end
	local hit = f:read("*a"):find(text, 1, true) ~= nil
	f:close()
	return hit
end

-- biome config root, only when biome handles this buffer's filetype
local function biome_root(buf)
	if not biome_fts[vim.bo[buf].filetype] then
		return nil
	end
	return vim.fs.root(buf, { "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" })
end

-- a config root found by `match(name)` or by `key` in package.json; nil when biome owns the buffer
local function config_root(match, key)
	return function(buf)
		if biome_root(buf) then
			return nil
		end
		return vim.fs.root(buf, function(name, path)
			return match(name) or (name == "package.json" and has(path, name, key))
		end)
	end
end

local prettier_root = config_root(function(name)
	return name:find("^%.prettierrc") ~= nil or name:find("^prettier%.config%.") ~= nil
end, '"prettier"')

local eslint_root = config_root(function(name)
	return name:find("^eslint%.config%.") ~= nil or name:find("^%.eslintrc") ~= nil
end, '"eslintConfig"')

local stylelint_root = config_root(function(name)
	return name:find("^%.stylelintrc") ~= nil or name:find("^stylelint%.config%.") ~= nil
end, '"stylelint"')

local function cwd(root)
	return function(_, ctx)
		return root(ctx.buf)
	end
end

-- conform: formatters (biome first) and fixers, each gated by its config root
function M.formatters()
	return { "biome", "prettier", stop_after_first = true }
end

M.custom_formatters = {
	biome = { cwd = cwd(biome_root), require_cwd = true },
	["biome-check"] = { cwd = cwd(biome_root), require_cwd = true }, -- fix + format
	prettier = { cwd = cwd(prettier_root), require_cwd = true },
	eslint_d = { cwd = cwd(eslint_root), require_cwd = true }, -- eslint --fix
	stylelint = { cwd = cwd(stylelint_root), require_cwd = true }, -- stylelint --fix
}

-- nvim-lint: JS/TS
function M.linters(bufnr)
	if biome_root(bufnr) then
		return { "biomejs" }
	end
	if eslint_root(bufnr) then
		return { "eslint_d" }
	end
	return {}
end

-- nvim-lint: CSS/SCSS/LESS
function M.css_linters(bufnr)
	if biome_root(bufnr) then
		return { "biomejs" }
	end
	if stylelint_root(bufnr) then
		return { "stylelint" }
	end
	return {}
end

-- nvim-lint: HTML (biome only; no project-configured html linter otherwise)
function M.html_linters(bufnr)
	return biome_root(bufnr) and { "biomejs" } or {}
end

-- nvim-lint's built-ins look for ./node_modules/.bin in Neovim's cwd only: use
-- the plain name instead (plugins/lint.lua resolves it from the buffer: project,
-- $PATH, mason) and run from the config's root
local function from_root(name, root, bin)
	return function()
		local def = vim.deepcopy(require("lint.linters." .. name))
		def.cwd = root(0)
		def.cmd = bin
		return def
	end
end

M.custom_linters = {
	biomejs = from_root("biomejs", biome_root, "biome"),
	eslint_d = from_root("eslint_d", eslint_root, "eslint_d"),
	stylelint = from_root("stylelint", stylelint_root, "stylelint"),
}

return M
