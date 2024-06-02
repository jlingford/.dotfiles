return {
	"chipsenkbeil/distant.nvim",
	branch = "v0.3",
	cmd = "Distant",
	config = function()
		require("distant"):setup()
	end,
}

-- to use:
-- CLI: distant launch ssh://jamesl@[IP-OF-M3.MASSIVE]
-- NVIM: :DistantLaunch ssh://jamesl@[IP-OF-M3.MASSIVE]
