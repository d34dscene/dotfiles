local module = {}

function module.apply_to_config(config)
	config.launch_menu = {
		{
			label = "Sentinel",
			domain = { DomainName = "SSH:jk" },
		},
		{
			label = "Router",
			domain = { DomainName = "SSH:ub" },
		},
		{
			label = "DIST:Fedora",
			args = { "bash", "-c", "/usr/bin/distrobox-enter fedora" },
		},
		{
			label = "DIST:Ubuntu",
			args = { "bash", "-c", "/usr/bin/distrobox-enter ubuntu" },
		},
		{
			label = "DIST:Arch",
			args = { "bash", "-c", "/usr/bin/distrobox-enter arch" },
		},
	}
end

return module
