-- Python: basedpyright + tools enabled ONLY by the project's config.
--   ruff config   (ruff.toml, .ruff.toml, [tool.ruff] in pyproject.toml) -> ruff (format + lint)
--   flake8 config (.flake8, [flake8] in setup.cfg / tox.ini)            -> autopep8 + flake8
--   autopep8 config ([tool.autopep8] in pyproject.toml, .pep8, or a
--     [pycodestyle] / [pep8] section in setup.cfg / tox.ini / .flake8)  -> autopep8
--   none of these                                                        -> no formatting, no linting
-- autopep8 reads the same [flake8] section, so formatter and linter follow the
-- same rules. Each runs from the root of the config that enabled it.
-- Project configs only: autopep8's global config (~/.config/pycodestyle) is ignored.
local function has(path, file, text)
	local f = io.open(vim.fs.joinpath(path, file)):
	if not f then
		return false
	end
	local hit = f:read("*a"):find(text, 1, true) ~= nil
	f:close()
	return hit
end

local function ruff_root(source)
	return vim.fs.root(source, function(name, path)
		return name == "ruff.toml"
			or name == ".ruff.toml"
			or (name == "pyproject.toml" and has(path, name, "[tool.ruff"))
	end)
end

local function is_flake8_config(name, path)
	return name == ".flake8" or ((name == "setup.cfg" or name == "tox.ini") and has(path, name, "[flake8]"))
end

local function flake8_root(source)
	return vim.fs.root(source, is_flake8_config)
end

-- Every project config autopep8 reads (autopep8.py: PROJECT_CONFIG + [tool.autopep8])
local function autopep8_root(source)
	return vim.fs.root(source, function(name, path)
		if name == "pyproject.toml" then
			return has(path, name, "[tool.autopep8]")
		end
		if name == ".flake8" or name == ".pep8" then
			return true
		end
		if name == "setup.cfg" or name == "tox.ini" then
			return has(path, name, "[flake8]") or has(path, name, "[pycodestyle]") or has(path, name, "[pep8]")
		end
		return false
	end)
end

return {
	lsp = { "basedpyright" },
	tools = { "basedpyright", "ruff", "autopep8", "flake8" },
	formatters = { python = { "ruff_format", "autopep8", stop_after_first = true } },
	custom_formatters = {
		ruff_format = {
			cwd = function(_, ctx)
				return ruff_root(ctx.buf)
			end,
			require_cwd = true,
		},
		autopep8 = {
			cwd = function(_, ctx)
				return autopep8_root(ctx.buf)
			end,
			require_cwd = true,
			prepend_args = { "--global-config", "/dev/null" }, -- project configs only
		},
	},
	linters = {
		python = function(bufnr)
			if ruff_root(bufnr) then
				return { "ruff" }
			end
			if flake8_root(bufnr) then
				return { "flake8" }
			end
			return {}
		end,
	},
	custom_linters = {
		flake8 = function() -- nvim-lint's built-in definition, run from the root of the flake8 config
			local def = vim.deepcopy(require("lint.linters.flake8"))
			def.cwd = flake8_root(0)
			return def
		end,
	},
}
