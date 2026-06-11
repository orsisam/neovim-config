return {
    "windwp/nvim-autopairs",
    event = {"InsertEnter"},
    -- dependencies = {
    --     "hrsh7th/nvim-cmp",
    -- },
    config = function()
        local autopairs = require("nvim-autopairs")

        -- setup autopairs
        autopairs.setup({
            enable_afterquote = false,
            check_ts = true, -- treesitter enabled
            ts_config = {
                lua = {"string"}, -- dont add pairs in lua string treesitter nodes
                -- javascript = {"template_string"}, -- dont add pairs in javascript template_string treesitter nodes
                java = false, -- dont check treesitter on java
            },
        })

        -- disabling the nvim-cmp - replace with blink.cmp
        -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        -- local cmp = require("cmp")
        --
        -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    end,
}
