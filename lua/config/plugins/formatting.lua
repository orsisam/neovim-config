return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
			formatters_by_ft = {
				javascript = { "biome-check" },
				typescript = { "biome-check" },
				javascriptreact = { "biome-check" },
				typescriptreact = { "biome-check" },
				css = { "biome-check" },
				html = { "prettier" },
				svelte = { "prettier" },
				json = { "biome-check" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				markdown = { "mdformat", "markdownlint-cli2", "markdown-toc" },
				php = { "pint" },
				dart = { "dart_format" },
				blade = { "blade-fomatter" },
				-- python = { "black" },
			},
			format_on_save = function(bufnr)
				-- Check file type
				local filetype = vim.bo[bufnr].filetype

				-- if filetype == "php" give more times (3s)
				if filetype == "php" then
					return {
						lsp_format = "fallback",
						async = false,
						timeout_ms = 5000,
					}
				end

				-- default return
				return {
					lsp_format = "fallback",
					async = false,
					timeout_ms = 1000,
				}
			end,
		})

		-- Configure individual formatters
		conform.formatters.prettier = {
			args = {
				"--stdin-filepath",
				"$FILENAME",
				"--tab-width",
				"4",
				"--use-tabs",
				"false",
			},
		}
		conform.formatters.shfmt = {
			prepend_args = { "-i", "4" },
		}

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			local filetype = vim.bo[0].filetype
			local timeout = (filetype == "php") and 5000 or 1000

			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = timeout,
			})
		end, { desc = "Format whole file or range in visual mode" })
	end,
}
