local wezterm = require("wezterm")
local act = wezterm.action

local fish_path = "/run/current-system/sw/bin/fish"
-- Use config builder object if possible
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- Need a local copy of this to specify location of zoxide
local function get_zoxide_workspaces(workspace_formatter)
	local _, stdout, _ = wezterm.run_child_process({ "/Users/scotte/.nix-profile/bin/zoxide", "query", "-l" })

	local workspace_table = {}
	for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
		table.insert(workspace_table, {
			id = workspace,
			label = workspace_formatter(workspace),
		})
	end
	for _, path in ipairs(wezterm.split_by_newlines(stdout)) do
		local updated_path = string.gsub(path, wezterm.home_dir, "~")
		table.insert(workspace_table, {
			id = path,
			label = updated_path,
		})
	end
	return workspace_table
end

local function workspace_switcher(workspace_formatter)
	return wezterm.action_callback(function(window, pane)
		local workspaces = get_zoxide_workspaces(workspace_formatter)

		window:perform_action(
			act.InputSelector({
				action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
					if not id and not label then -- do nothing
					else
						local fullPath = string.gsub(label, "^~", wezterm.home_dir)
						if fullPath:sub(1, 1) == "/" or fullPath:sub(3, 3) == "\\" then
							-- if path is choosen
							inner_window:perform_action(
								act.SwitchToWorkspace({
									name = label,
									spawn = {
										label = "Workspace: " .. label,
										cwd = fullPath,
									},
								}),
								inner_pane
							)
							window:set_right_status(window:active_workspace())
							-- increment path score
							wezterm.run_child_process({
								"zoxide",
								"add",
								fullPath,
							})
						else
							-- if workspace is choosen
							inner_window:perform_action(
								act.SwitchToWorkspace({
									name = id,
								}),
								inner_pane
							)
							window:set_right_status(window:active_workspace() .. "  ")
						end
					end
				end),
				title = "Choose Workspace",
				choices = workspaces,
				fuzzy = true,
			}),
			pane
		)
	end)
end

local function apply_to_config(config, key, mods, formatter)
	if key == nil then
		key = "s"
	end
	if mods == nil then
		mods = "s"
	end
	if formatter == nil then
		formatter = function(label)
			return wezterm.format({
				{ Text = "󱂬: " .. label },
			})
		end
	end
	table.insert(config.keys, {
		key = key,
		mods = mods,
		action = workspace_switcher(formatter),
	})
end

-- Settings
config.default_prog = {fish_path, "-l"}

config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium' })

config.window_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
    saturation = 0.24,
    brightness = 0.5
}

-- Colors
-- config.color_scheme = "Tokyo Night"
config.colors = {
	foreground = '#F8F8F2',
	background = '#0B0D0F',
	cursor_bg = '#F8F8F8',
	cursor_fg = '#0B0D0F',
	cursor_border = '#F8F8F8',
	selection_bg = '#414D58',
	selection_fg = '#F8F8F2',
	scrollbar_thumb = '#44475A',
	ansi = {
    '#708CA9',
    '#FF9580',
    '#8AFF80',
    '#FFFF80',
    '#9580FF',
    '#FF80BF',
    '#80FFEA',
    '#F8F8F2'
	},
	brights = {
    '#708CA9',
    '#FFAA99',
    '#A2FF99',
    '#FFFF99',
    '#AA99FF',
    '#FF99CC',
    '#99FFEE',
    '#FFFFFF'
	}
}

config.leader = {
    key = "t",
    mods = "CTRL",
    timeout_milliseconds = 1000
}
config.keys = {
    -- Send C-t when pressing C-a twice
    { key = "t",          mods = "LEADER|CTRL", action = act.SendKey { key = "t", mods = "CTRL" } },
    { key = "c",          mods = "LEADER",      action = act.ActivateCopyMode },
    { key = "phys:Space", mods = "LEADER",      action = act.ActivateCommandPalette },

    -- Pane keybindings
    { key = "-",          mods = "LEADER",      action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "\\",          mods = "LEADER",      action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "n",          mods = "LEADER",      action = act.ActivatePaneDirection("Left") },
    { key = "e",          mods = "LEADER",      action = act.ActivatePaneDirection("Down") },
    { key = "i",          mods = "LEADER",      action = act.ActivatePaneDirection("Up") },
    { key = "o",          mods = "LEADER",      action = act.ActivatePaneDirection("Right") },
    { key = "q",          mods = "LEADER",      action = act.CloseCurrentPane { confirm = true } },
    { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
    { key = "l",          mods = "LEADER",      action = act.RotatePanes "Clockwise" },

    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    { key = "u",          mods = "LEADER",      action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

    -- Tab keybindings
    { key = "t",          mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
    { key = ",",          mods = "LEADER",      action = act.ActivateTabRelative(-1) },
    { key = ".",          mods = "LEADER",      action = act.ActivateTabRelative(1) },
    { key = "j",          mods = "LEADER",      action = act.ShowTabNavigator },
    { key = "r",          mods = "LEADER",      action = act.PromptInputLine {
        description = wezterm.format {{
            Attribute = { Intensity = "Bold" }
        }, {
            Foreground = {
                AnsiColor = "Fuchsia"
            }
        }, {
            Text = "Renaming Tab Title...:"
        }},
        action = wezterm.action_callback(function(window, pane, line)
            if line then
                window:active_tab():set_title(line)
            end
        end) } },
    -- Key table for moving tabs around
    { key = "m", mods = "LEADER", action = act.ActivateKeyTable {name = "move_tab", one_shot = false } },
    -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
    { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
    { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
    -- Lastly, workspace
    { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } }
}

apply_to_config(config, "j", "CMD", function(label)
    return wezterm.format({
        { Attribute = { Italic = true } },
        { Foreground = { Color = "#9580FF" } },
        { Background = { Color = "black" } },
        { Text = "󱂬: " .. label },
    })
end)

return config
