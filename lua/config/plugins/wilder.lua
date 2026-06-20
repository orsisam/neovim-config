return {
	"gelguy/wilder.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"romgrk/fzy-lua-native",
	},
	config = function()
		local wilder = require("wilder")

		wilder.setup({ modes = { ":", "/", "?" } })

		-- Define custom highlight groups
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				min_width = "20%",
				max_height = "15%",
				reverse = 0,
				highlighter = {
					wilder.lua_pcre2_highlighter(),
					wilder.lua_fzy_highlighter(),
				},
				highlights = {
					default = wilder.make_hl(
						"WilderPopupMenu",
						"Pmenu",
						{ { a = 1 }, { a = 1 }, { background = "#1e212b" } }
					),
					accent = wilder.make_hl(
						"WilderAccent",
						"Pemnu",
						{ { a = 1 }, { a = 1 }, { foreground = "#58ffd6", background = "#1e1e2e" } }
					),
				},
				-- 'single', 'double', 'rounded', or 'solid'
				-- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
				border = "single",
			}))
		)
	end,
}
