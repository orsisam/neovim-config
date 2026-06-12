return {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = false,
		opts = {
			enable_autocmd = false, -- Let Comment.nvim handle triggering
		},
        config = function (_, opts)
            require("ts_context_commentstring").setup(opts)

            -- Integrasikan deteksi konteks langsung ke dalam sistem komentar bawaan Neovim
            local get_option = vim.filetype.get_option
            vim.filetype.get_option = function (filetype, option)
                if option == "commentstring" then
                    local commentstring = require("ts_context_commentstring.internal").calculate_commentstring()
                    if commentstring then
                        return commentstring
                    end
                end
                return get_option(filetype, option)
            end
        end
	},
}
