-- vtsls: wraps VSCode's TypeScript extension; settings follow the VSCode schema.
-- No Deno-exclusion logic (add it back if a Deno project ever shows up).
local inlay_hints = {
	parameterNames = { enabled = "literals" },
	parameterTypes = { enabled = true },
	functionLikeReturnTypes = { enabled = true },
	variableTypes = { enabled = false },
}

return {
	cmd = { "vtsls", "--stdio" },
	init_options = { hostInfo = "neovim" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	-- Lockfiles first: they only exist at the workspace root, so a monorepo
	-- gets a SINGLE vtsls instance (it resolves per-package tsconfigs itself)
	root_markers = {
		{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lock", "bun.lockb" },
		{ "tsconfig.json", "jsconfig.json", "package.json" },
		{ ".git" },
	},
	settings = {
		vtsls = {
			autoUseWorkspaceTsdk = true, -- use the project's typescript when present
			experimental = {
				completion = { enableServerSideFuzzyMatch = true },
			},
		},
		typescript = {
			inlayHints = inlay_hints,
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
		},
		javascript = {
			inlayHints = inlay_hints,
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
		},
	},
}
