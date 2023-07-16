local wezterm = require "wezterm"
local module = {}

local function distro_list()
	local handle = io.popen "podman ps -a --format '{{.Names}}'"
	local distros = {}
	if handle then
		for line in handle:lines() do
			table.insert(distros, line)
		end
		handle:close()
	end
	return distros
end

local function get_exec_domains()
	local domains = {}
	for _, name in pairs(distro_list()) do
		table.insert(
			domains,
			wezterm.exec_domain("DIST@" .. name, function(cmd)
				local wrapped = {
					"bash",
					"-c",
					"/usr/bin/distrobox-enter " .. name,
				}
				cmd.args = wrapped
				return cmd
			end)
		)
	end
	return domains
end

local function get_exec_entries()
	local entries = {}
	for _, name in pairs(distro_list()) do
		table.insert(entries, {
			label = name:gsub("^%l", string.upper),
			domain = { DomainName = "DIST@" .. name },
		})
	end
	return entries
end

local function merged_entries()
	local base_domains = {
		{
			label = "Sentinel",
			domain = { DomainName = "SSH:jk" },
		},
		{
			label = "Router",
			domain = { DomainName = "SSH:ub" },
		},
	}
	for _, v in pairs(get_exec_entries()) do
		table.insert(base_domains, v)
	end
	return base_domains
end

function module.apply_to_config(config)
	config.launch_menu = merged_entries()
	config.exec_domains = get_exec_domains()
end

return module
