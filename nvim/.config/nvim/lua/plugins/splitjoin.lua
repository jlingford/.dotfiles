return {
    "echasnovski/mini.splitjoin",
    version = false,
    event = "BufEnter",
    config = function ()
        require('mini.splitjoin').setup()
    end,
}
