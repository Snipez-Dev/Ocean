if not getgenv().OceanToken then
	warn("[Ocean] Start via Ocean Loader.")
	return
end
getgenv().OceanToken = nil

local library = getgenv().library
library:init()

local Window = library.NewWindow({ title = 'OceanUI' })

-- simplified API: Tab:AddToggle etc. without needing AddSection
local AimbotTab = Window:AddTab('Aimbot')

AimbotTab:AddToggle({
	text = 'Aimbot', flag = 'aim_enabled',
	callback = function(state) end
})

AimbotTab:AddBind({
	text = 'Aimbot Key', flag = 'aim_bind', mode = 'hold',
	callback = function(state) end
})

AimbotTab:AddSlider({
	text = 'FOV', flag = 'aim_fov',
	min = 1, max = 360, value = 90, increment = 1, suffix = '°',
	callback = function(val) end
})

AimbotTab:AddSlider({
	text = 'Smoothness', flag = 'aim_smooth',
	min = 1, max = 50, value = 10, increment = 1,
	callback = function(val) end
})

AimbotTab:AddList({
	text = 'Hitbox', flag = 'aim_hitbox',
	values = {'Head', 'Torso', 'Nearest', 'Random'}, selected = 'Head',
	callback = function(val) end
})

AimbotTab:AddToggle({ text = 'Prediction',   flag = 'aim_pred',     side = 2, callback = function(s) end })
AimbotTab:AddToggle({ text = 'Team Check',   flag = 'aim_team',     side = 2, callback = function(s) end })
AimbotTab:AddToggle({ text = 'Visible Only', flag = 'aim_vischeck', side = 2, callback = function(s) end })
AimbotTab:AddSlider({ text = 'Pred Amount',  flag = 'aim_pred_val', side = 2, min=0, max=100, value=30, callback = function(v) end })
AimbotTab:AddColor({  text = 'FOV Color',    flag = 'aim_fov_col',  side = 2, color = Color3.fromRGB(255, 80, 80), callback = function(c,a) end })

-- explicit sections for two-column layout
local VisualsTab = Window:AddTab('Visuals')

local espSection  = VisualsTab:AddSection('ESP',  1)
local miscSection = VisualsTab:AddSection('Misc', 2)

espSection:AddToggle({ text = 'Enabled',      flag = 'esp_enabled',   callback = function(s) end })
espSection:AddToggle({ text = 'Box',          flag = 'esp_box',       callback = function(s) end })
espSection:AddToggle({ text = 'Name',         flag = 'esp_name',      callback = function(s) end })
espSection:AddToggle({ text = 'Health Bar',   flag = 'esp_health',    callback = function(s) end })
espSection:AddToggle({ text = 'Tracers',      flag = 'esp_tracers',   callback = function(s) end })
espSection:AddSlider({ text = 'Max Distance', flag = 'esp_dist',      min=0, max=2000, value=1000, suffix='st', callback = function(v) end })
espSection:AddColor({  text = 'Enemy Color',  flag = 'esp_col_enemy', color = Color3.fromRGB(255, 50, 50),  callback = function(c,a) end })
espSection:AddColor({  text = 'Team Color',   flag = 'esp_col_team',  color = Color3.fromRGB(50, 180, 255), callback = function(c,a) end })

miscSection:AddToggle({ text = 'Fullbright', flag = 'misc_fullbright', callback = function(s) end })
miscSection:AddToggle({ text = 'No Fog',     flag = 'misc_nofog',      callback = function(s) end })
miscSection:AddToggle({ text = 'Crosshair',  flag = 'misc_crosshair',  callback = function(s) end })
miscSection:AddSeparator({ text = 'Movement' })
miscSection:AddToggle({ text = 'Speed Hack', flag = 'misc_speed', callback = function(s)
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild('Humanoid') then
		char.Humanoid.WalkSpeed = s and library.flags.misc_speed_val or 16
	end
end })
miscSection:AddSlider({ text = 'Speed', flag = 'misc_speed_val', min=16, max=100, value=24, callback = function(v)
	if library.flags.misc_speed then
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild('Humanoid') then
			char.Humanoid.WalkSpeed = v
		end
	end
end })

local MiscTab = Window:AddTab('Misc')

MiscTab:AddToggle({
	text = 'No Recoil', flag = 'misc_norecoil',
	callback = function(s) end
})

MiscTab:AddButton({
	text = 'Teleport to Mouse',
	callback = function()
		local cam    = workspace.CurrentCamera
		local mpos   = game:GetService('UserInputService'):GetMouseLocation()
		local ray    = cam:ScreenPointToRay(mpos.X, mpos.Y)
		local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
		if result then
			local root = game.Players.LocalPlayer.Character
				and game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
			if root then
				root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
			end
		end
	end
})

MiscTab:AddBox({
	text = 'Chat Spoof', flag = 'misc_chatspoof',
	callback = function(input)
		if input ~= '' then
			local events = game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents
			if events then
				events.SayMessageRequest:FireServer(input, 'All')
			end
		end
	end
})

MiscTab:AddSeparator({ text = 'Server', side = 2 })
MiscTab:AddButton({
	text = 'Rejoin', side = 2, confirm = true,
	callback = function()
		game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end
})
MiscTab:AddButton({
	text = 'Copy JobId', side = 2,
	callback = function()
		setclipboard(game.JobId)
		library:SendNotification('JobId copied!', 2)
	end
})

library:CreateSettingsTab(Window)
library:SendNotification('OceanUI loaded!', 4, Color3.fromRGB(80, 200, 120))
