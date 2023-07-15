local wezterm = require "wezterm"
local module = {}

local function distro_list()
	local boxes = io.popen "podman ps -a --format '{{.Names}}'"
	local distros = {}
	for line in boxes:lines() do
		table.insert(distros, line)
	end
	return distros
end

local exec_domains = {}
local exec_entries = {}
for _, name in pairs(distro_list()) do
	table.insert(
		exec_domains,
		wezterm.exec_domain("DIST:" .. name, function(cmd)
			local wrapped = {
				"bash",
				"-c",
				"/usr/bin/distrobox-enter " .. name,
			}
			cmd.args = wrapped
			return cmd
		end)
	)
	table.insert(exec_entries, {
		label = name:gsub("^%l", string.upper),
		domain = { DomainName = "DIST:" .. name },
	})
end

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
			label = "Fedora",
			domain = { DomainName = "DIST:fedora" },
		},
		{
			label = "Ubuntu",
			domain = { DomainName = "DIST:ubuntu" },
		},
		{
			label = "Arch",
			domain = { DomainName = "DIST:arch" },
		},
	}
	config.exec_domains = exec_domains
end

return module
