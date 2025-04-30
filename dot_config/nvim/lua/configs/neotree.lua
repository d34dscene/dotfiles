local status_ok, neotree = pcall(require, "neo-tree")
if not status_ok then
	return
end

neotree.setup {
	close_if_last_window = true,
	enable_git_status = true,
	enable_diagnostics = true,
	git_status_async = false,
	hide_root_node = true,
	source_selector = {
		winbar = true,
		truncation_character = "",
	},
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		indent = {
			indent_size = 2,
			padding = 1, -- extra padding on left hand side
			-- indent guides
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
			-- expander config, needed for nesting files
			with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			folder_closed = "",
			folder_open = "",
			folder_empty = "󰜌",
			folder_empty_open = "󰜌",
			default = "*",
			highlight = "NeoTreeFileIcon",
		},
		git_status = {
			symbols = {
				-- Change type
				added = "",
				modified = "",
				deleted = "✖",
				renamed = "󰁕",
				-- Status type
				untracked = "",
				ignored = "",
				unstaged = "󰄱",
				staged = "",
				conflict = "",
			},
		},
	},
	window = {
		width = 35,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
			["<space>"] = {
				"toggle_node",
				nowait = false,
			},
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["<esc>"] = "cancel",
			["P"] = { "toggle_preview", config = { use_float = true } },
			["S"] = "open_split",
			["s"] = "open_vsplit",
			["w"] = "open_with_window_picker",
			["C"] = "close_node",
			["z"] = "close_all_nodes",
			["Z"] = "expand_all_nodes",
			["a"] = { "add", config = { show_path = "relative" } },
			["A"] = { "add_directory", config = { show_path = "relative" } },
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["c"] = { "copy", config = { show_path = "relative" } },
			["m"] = { "move", config = { show_path = "relative" } },
			["q"] = "close_window",
			["R"] = "refresh",
			["?"] = "show_help",
			["<A-j>"] = "prev_source",
			["<A-k>"] = "next_source",
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
		},
		follow_current_file = {
			enabled = true,
		},
		hijack_netrw_behavior = "open_default",
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				["H"] = "toggle_hidden",
				["f"] = "fuzzy_finder",
				["u"] = "fuzzy_finder_directory",
				["D"] = "diff_files",
				["/"] = "filter_on_submit",
				["cl"] = "clear_filter",
				["[g"] = "prev_git_modified",
				["]g"] = "next_git_modified",
			},
		},
		commands = {
			diff_files = function(state)
				local node = state.tree:get_node()
				local log = require "neo-tree.log"
				state.clipboard = state.clipboard or {}
				if diff_Node and diff_Node ~= tostring(node.id) then
					local current_Diff = node.id
					require("neo-tree.utils").open_file(state, diff_Node, open)
					vim.cmd("vert diffs " .. current_Diff)
					log.info("Diffing " .. diff_Name .. " against " .. node.name)
					diff_Node = nil
					current_Diff = nil
					state.clipboard = {}
					require("neo-tree.ui.renderer").redraw(state)
				else
					local existing = state.clipboard[node.id]
					if existing and existing.action == "diff" then
						state.clipboard[node.id] = nil
						diff_Node = nil
						require("neo-tree.ui.renderer").redraw(state)
					else
						state.clipboard[node.id] = { action = "diff", node = node }
						diff_Name = state.clipboard[node.id].node.name
						diff_Node = tostring(state.clipboard[node.id].node.id)
						log.info("Diff source file " .. diff_Name)
						require("neo-tree.ui.renderer").redraw(state)
					end
				end
			end,
		},
	},
	git_status = {
		window = {
			mappings = {
				["A"] = "git_add_all",
				["u"] = "git_unstage_file",
				["a"] = "git_add_file",
				["r"] = "git_revert_file",
				["c"] = "git_commit",
				["p"] = "git_push",
				["gg"] = "git_commit_and_push",
			},
		},
	},
	event_handlers = {
		{
			event = "neo_tree_buffer_enter",
			handler = function(_)
				vim.opt_local.signcolumn = "auto"
			end,
		},
	},
}

vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
