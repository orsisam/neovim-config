return {
    "thePrimeagen/harpoon",
    enabled = true,
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local harpoon = require("harpoon")
        -- local conf = require("telescope.config").values

        harpoon:setup({
            global_settings = {
                save_on_toggle = true,
                save_on_change = true,
            },
        })

        -- NOTE: Experimenting
		-- Telescope into Harpoon function
		-- local function toggle_telescope(harpoon_files)
		-- 	local file_paths = {}
		-- 	for _, item in ipairs(harpoon_files.items) do
		-- 		table.insert(file_paths, item.value)
		-- 	end
		-- 	require("telescope.pickers")
		-- 		.new({}, {
		-- 			prompt_title = "Harpoon",
		-- 			finder = require("telescope.finders").new_table({
		-- 				results = file_paths,
		-- 			}),
		-- 			previewer = conf.file_previewer({}),
		-- 			sorter = conf.generic_sorter({}),
		-- 		})
		-- 		:find()
		-- end

        -- Harpoon Nav Interface
        local keymap = vim.keymap.set

        keymap("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
        keymap("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon toggle list (floating window)"})

        -- Harpoon marked files
        -- Switch between active window in harpoon list. Just 1 - 3 on top list.
        keymap("n", "<C-y>", function() harpoon:list():select(1) end, { desc = "Harpoon: switch to 1st list" })
        keymap("n", "<C-i>", function() harpoon:list():select(2) end, { desc = "Harpoon: switch to 2nd list" })
        keymap("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Harpoon: switch to 3th list" })
        keymap("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Harpoon: switch to 4th list" })

        -- Toggle previous & next buffers stored within Harpoon list
        keymap("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon: jumpt to next buffer stored" })
        keymap("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon: jump to previous buffers stored" })

        -- Telescope inside Harpoon Window
		-- vim.keymap.set("n", "<C-f>", function()
		-- 	toggle_telescope(harpoon:list())
		-- end)
    end,
}
