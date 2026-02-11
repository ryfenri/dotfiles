return {
	"norcalli/nvim-colorizer.lua",
	config=true,
	lazy=true,
	cmd = {
		"ColorizerToggle",
		"ColorizerAttachToBuffer",
		"ColorizerReloadAllBuffers",
		"ColorizerDetachFromBuffer",
	},
	opts = {
		"css",
		"javascriptreact",
		"html",
	},
	ft = { "css", "javascriptreact", "html" },
}
