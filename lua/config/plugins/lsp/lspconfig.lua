return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- NOTE: LSP Custom Keybinds
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				-- Buffer local mappings
				local opts = { buffer = ev.buf, silent = true }

				-- Keymaps
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				-- vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				vim.keymap.set("n", "<leader>D", function()
					require("snacks").picker.diagnostics_buffer()
				end, opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "df", function()
					vim.diagnostic.open_float()
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Show signature help"
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		-- NOTE: Diagnostic Setup
		-- Define sign icons for each severity
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}
		-- update diagnostic config function
		vim.diagnostic.config({
			signs = { text = signs },
			virtual_text = true,
			underline = true,
			update_in_insert = false,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
			},
		})

		-- toggle for virtual text
		vim.keymap.set("n", "<leader>lx", function()
			local current = vim.diagnostic.config().virtual_text
			vim.diagnostic.config({ virtual_text = not current })
		end, { desc = "Toggle LSP virtual text" })

		-- NOTE: Setup servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- blink cmp
		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		-- Global LSP settings (applied to all servers)
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- Configure and enable LSP servers
		-- lua_ls
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- Intelphense (php 8.5 & Laravel 13)
		vim.lsp.config("intelphense", {
			filetypes = { "php", "blade" },
			settings = {
				intelephense = {
					stubs = {
						"bcmath",
						"bz2",
						"calendar",
						"Core",
						"curl",
						"date",
						"dba",
						"dom",
						"enchant",
						"fileinfo",
						"filter",
						"ftp",
						"gd",
						"gettext",
						"hash",
						"iconv",
						"imap",
						"intl",
						"json",
						"ldap",
						"libxml",
						"mbstring",
						"meta",
						"mysqli",
						"oci8",
						"odbc",
						"openssl",
						"pcntl",
						"pcre",
						"PDO",
						"pdo_mysql",
						"pdo_pgsql",
						"pdo_sqlite",
						"pgsql",
						"Phar",
						"posix",
						"pspell",
						"readline",
						"Reflection",
						"session",
						"shmop",
						"SimpleXML",
						"snmp",
						"soap",
						"sockets",
						"sodium",
						"SPL",
						"standard",
						"superglobals",
						"sysvmsg",
						"sysvsem",
						"sysvshm",
						"tidy",
						"tokenizer",
						"xml",
						"xmlreader",
						"xmlrpc",
						"xmlwriter",
						"xsl",
						"zip",
						"zlib",
						"laravel",
						"phpunit", -- Membaca class Facade milik Laravel 13 dengan baik
						"wordpress",
					},
					files = {
						maxSize = 8000000,
					},
					completion = {
						fullyQualifyGlobalConstantsAndFunctions = false,
						includeCompletionsForImportStatements = true,
					},
					diagnostics = {
						enable = true,
					},
				},
			},
		})

		-- Laravel Language Server
		vim.lsp.config("laravel-ls", {
			filetypes = { "php", "blade" },
			cmd = { "laravel-ls" },
			root_markers = { "artisan" },
		})

		-- Volar (Vue 3)
		vim.lsp.config("volar", {
			filetypes = { "vue" },
			init_options = {
				vue = {
					hybridMode = true, -- Mengaktifkan Hybrid Mode berperforma tinggi dengan ts_ls
				},
			},
		})

		-- emmet_language_server
		vim.lsp.config("emmet_language_server", {
			filetypes = {
				"css",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"typescriptreact",
				-- Menambahkan blade & vue
				"blade",
				"vue",
			},
			init_options = {
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})

		-- emmet_ls
		vim.lsp.config("emmet_ls", {
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
				-- tambahan untuk blade & vue
				"blade",
				"vue",
			},
		})

		-- ts_ls (TypeScript/JavaScript)
		vim.lsp.config("ts_ls", {
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue", -- Diperlukan untuk koordinasi tipe data komponen Vue 3
			},
			single_file_support = true,
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data")
							.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
						languages = { "vue" },
					},
				},
				preferences = {
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
				},
			},
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayVariableTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
					},
				},
				javascript = {
					validate = {
						enable = true,
					},
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayVariableTypeHints = true,
					},
				},
			},
		})

		-- gopls
		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})

		-- css
		vim.lsp.config("cssls", {
			filetypes = { "css", "scss", "less" },
			init_options = { provideFormatter = true },
			single_file_support = true,
			settings = {
				css = {
					lint = {
						unknownAtRules = "ignore",
					},
					validate = true,
				},
				scss = {
					lint = {
						unknownAtRules = "ignore",
					},
					validate = true,
				},
				less = {
					lint = {
						unknownAtRules = "ignore",
					},
					validate = true,
				},
			},
		})

		-- tailwind
		vim.lsp.config("tailwindcss", {
			filetypes = {
				"html",
				"css",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"astro",
				"blade",
			},
			init_options = {
				userLanguages = {
					astro = "html",
				},
			},
		})

		-- astro
		vim.lsp.config("astro", {
			filetypes = { "astro" },

			init_options = {
				typescript = {
					tsdk = vim.fn.stdpath("data")
						.. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
				},
			},
		})

		-- Instead of using mason enable all configured LSP via `automatic_enable=true`
		-- Prefer more control by enable manual server call below via vim.lsp.enable("")
		-- mason config: lua/sethy/plugins/lsp/mason.lua:22
		vim.lsp.enable({
			"lua_ls",
			"cssls",
			"emmet_language_server",
			"emmet_ls",
			"ts_ls",
			"gopls",
			"rust_analyzer",
			"astro",
			"tailwindcss",
			"marksman",
			"intelephense", -- Aktifkan PHP
			"volar", -- Aktifkan Vue
			"laravel-ls",
		})
	end,
}
