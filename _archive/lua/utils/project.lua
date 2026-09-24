-- Project-aware tool selection, used by plugins/lang/*.lua.
-- A marker is a filename, or { "filename", has = "substring" }: it matches
-- when the file exists upward from the buffer (and contains `has` if given).
local M = {}

local function present(bufnr, markers)
	for _, m in ipairs(markers) do
		local file = type(m) == "table" and m[1] or m
		local root = vim.fs.root(bufnr, file)
		if root then
			if type(m) == "table" and m.has then
				local fh = io.open(root .. "/" .. file)
				if fh then
					local hit = fh:read("*a"):find(m.has, 1, true) ~= nil
					fh:close()
					if hit then
						return true
					end
				end
			else
				return true
			end
		end
	end
	return false
end

-- Tools of every candidate the project is configured for (deduped)
local function matched(bufnr, candidates)
	local out, seen = {}, {}
	for _, c in ipairs(candidates) do
		if present(bufnr, c.markers) then
			for _, tool in ipairs(c.tools) do
				if not seen[tool] then
					seen[tool] = true
					out[#out + 1] = tool
				end
			end
		end
	end
	return out
end

-- resolve(spec) returns { format = fn(bufnr), lint = fn(bufnr) } for conform/nvim-lint.
-- As soon as the project configures ANY tool, only the project's tools are
-- used; the defaults apply only when the project configures nothing at all.
function M.resolve(spec)
	local function compute(bufnr)
		local f = matched(bufnr, spec.formatters or {})
		local l = matched(bufnr, spec.linters or {})
		if #f > 0 or #l > 0 then
			return f, l
		end
		return spec.default_formatters or {}, spec.default_linters or {}
	end

	return {
		format = function(bufnr)
			local f = compute(bufnr)
			return f
		end,
		lint = function(bufnr)
			local _, l = compute(bufnr)
			return l
		end,
	}
end

return M
