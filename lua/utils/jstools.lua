-- JS/TS/JSON tools, shared by plugins/lang/typescript.lua, json.lua and yaml.lua.
-- Rule: a tool runs only when the project configures it; a biome config
-- replaces prettier and eslint.
local M = {}

local function has(path, file, text)
	local f = io.open(vim.fs.joinpath(path, file))
	if not f then
		return false
	end
	local hit = f:read("*a"):find(text, 1, true) ~= nil
	f:close()
	return hit
end

local function biome_root(source)
	return vim.fs.root(source, { "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" })
end

local function prettier_root(source)
	if biome_root(source) then
		return nil
	end
	return vim.fs.root(source, function(name, path)
		return name:find("^%.prettierrc") ~= nil
			or name:find("^prettier%.config%.") ~= nil
			or (name == "package.json" and has(path, name, '"prettier"'))
	end)
end

local function eslint_root(source)
	if biome_root(source) then
		return nil
	end
	return vim.fs.root(source, function(name, path)
		return name:find("^eslint%.config%.") ~= nil
			or name:find("^%.eslintrc") ~= nil
			or (name == "package.json" and has(path, name, '"eslintConfig"'))
	end)
end

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
}

-- nvim-lint
function M.linters(bufnr)
	if biome_root(bufnr) then
		return { "biomejs" }
	end
	if eslint_root(bufnr) then
		return { "eslint_d" }
	end
	return {}
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
}

return M
