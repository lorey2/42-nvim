return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = true, -- Automatically runs require('neogen').setup()
	keys = {
		{
			"<leader>nf",
			function() require('neogen').generate() end,
			desc = "Generate Doxygen Func"
		},
		{
			"<leader>nc",
			function() require('neogen').generate({ type = 'class' }) end,
			desc = "Generate Doxygen Class"
		}
	},
	-- Optional: Force the specific C++ Doxygen style if defaults aren't enough
	opts = {
		languages = {
			cpp = {
				template = {
					annotation_convention = "doxygen"
				}
			}
		}
	}
}
