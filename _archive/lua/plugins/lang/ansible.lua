-- Ansible: ansiblels runs ansible-lint itself (no nvim-lint entry).
-- No format-on-save; ansible-lint --fix on demand (<leader>cf).
return {
	lsp = { "ansiblels" },
	tools = { "ansible-language-server", "ansible-lint" },
	-- A FUNCTION returning {} is required: conform skips empty tables and
	-- would fall back to the "yaml" key (yamlfmt would rewrite playbooks)
	formatters = { ["yaml.ansible"] = function() return {} end },
	-- ansiblels runs ansible-lint internally (no nvim-lint entry); surfaced
	-- in the statusline, keyed by client name (see plugins/ui.lua)
	embedded_linters = { ansiblels = function() return "ansible-lint" end },
	setup = function()
		vim.filetype.add({
			pattern = {
				[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
				[".*/molecule/.*%.ya?ml"] = "yaml.ansible",
				[".*/playbook%.ya?ml"] = "yaml.ansible",
				[".*/site%.ya?ml"] = "yaml.ansible",
				[".*/group_vars/.*"] = "yaml.ansible",
				[".*/host_vars/.*"] = "yaml.ansible",
				-- requirements.yml exists outside ansible too: only claim it
				-- when its content looks like galaxy requirements
				[".*/requirements%.ya?ml"] = function(_, bufnr)
					local head = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, 50, false), "\n")
					if head:find("^roles:") or head:find("\nroles:") or head:find("collections:") then
						return "yaml.ansible"
					end
				end,
			},
		})

		-- ansible-lint --fix, async (too slow for format_on_save).
		-- Shadows the global <leader>cf (conform), a no-op on this filetype.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "yaml.ansible",
			group = vim.api.nvim_create_augroup("ansible-fix", { clear = true }),
			callback = function(args)
				vim.keymap.set("n", "<leader>cf", function()
					local file = vim.api.nvim_buf_get_name(args.buf)
					vim.cmd.write()
					vim.notify("ansible-lint --fix…", vim.log.levels.INFO)
					-- ansible-lint exits non-zero when unfixable issues remain: not an error
					vim.system({ "ansible-lint", "--fix", file }, {}, vim.schedule_wrap(function()
						vim.cmd.checktime() -- reload the buffer if changed on disk
						vim.notify("ansible-lint --fix done", vim.log.levels.INFO)
					end))
				end, { buffer = args.buf, desc = "Format (ansible-lint --fix)" })
			end,
		})
	end,
}
