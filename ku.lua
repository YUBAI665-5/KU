local module = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/1.6.54/main.lua"))()
game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function func(arg1)
	local str = ""

	local tbl = {
		Color3.fromRGB(180, 100, 255),
		Color3.fromRGB(150, 80, 235),
		Color3.fromRGB(120, 60, 215),
		Color3.fromRGB(90, 40, 195),
		Color3.fromRGB(70, 30, 175),
	}

	local v1 = #arg1:gsub("[^%w]", "")
	local num = 1

	for i = 1, #arg1 do
		local v2 = arg1:sub(i, i)
		if v2:match("[%w]") then
			local v3 = (num - 1) / math.max(v1 - 1, 1) * (#tbl - 1)
			local v4 = math.clamp(math.floor(v3) + 1, 1, #tbl)
			local v5 = math.clamp(v4 + 1, 1, #tbl)
			local v6 = tbl[v4]
			local v7 = tbl[v5]
			local v8 = v3 % 1
			local v9 = v6.R + (v7.R - v6.R) * v8
			local v10 = v6.G + (v7.G - v6.G) * v8
			local v11 = v6.B + (v7.B - v6.B) * v8
			str = str .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', v9 * 255, v10 * 255, v11 * 255, v2)
			num = num + 1
		else
			str = str .. v2
		end
	end

	return str
end

local function func1(arg1)
	module:Notify({Title = "Kyo Scripts", Content = arg1, Duration = 3})
end

local function func2(arg1)
	local ok, result = pcall(function()
		if syn and syn.request then
			return syn.request(arg1)
		end

		if request and type(request) == "function" then
			return request(arg1)
		end

		if http and http.request then
			return http.request(arg1)
		end

		return {Body = HttpService:GetAsync(arg1.Url), StatusCode = 200, Success = true}
	end)

	if ok and result then
		return result
	end

	return {Body = "{}", StatusCode = 0, Success = false}
end

local function func3(arg1, arg2)
	for _ = 1, arg2 or 2 do
		local v1 = func2(arg1)

		if v1 and v1.StatusCode == 200 then
			return v1
		end

		task.wait(1)
	end
	return {Success = false}
end

-- ===== iOS Liquid Glass 主题 =====
local tbl = {
	Name = "iOSGlass",
	Dialog = Color3.fromHex("#0B0B0F"),
	Outline = Color3.fromHex("#FFFFFF"),
	Text = Color3.fromHex("#FFFFFF"),
	Placeholder = Color3.fromHex("#8E8E93"),
	Background = Color3.fromHex("#101014"),
	Button = Color3.fromHex("#1C1C22"),
}

local tbl1 = {Color = Color3.fromHex("#A8D8FF"), Transparency = 0}
local tbl2 = {Color = Color3.fromHex("#C8B6FF"), Transparency = 0}
tbl.Icon = module:Gradient({["0"] = tbl1, ["100"] = tbl2}, {Rotation = 90})
module:AddTheme(tbl)

local tbl3 = {
	Title = func("Kyo Scripts — v1.0.0"),
	Author = "Kyo Scripts Community",
	Folder = "Kyo Scripts",
	Size = UDim2.fromOffset(605, 360),
	Transparent = true,
	Resizable = true,
	Theme = "iOSGlass",
	SideBarWidth = 200,
	Background = "rbxassetid://124138067839032",
	BackgroundTransparency = 0.85,
	HideSearchBar = false,
	ScrollBarEnabled = true,
}

local Window = module:CreateWindow(tbl3)

-- ===== 注入 iOS 毛玻璃 & 圆角描边 =====
local Lighting = game:GetService("Lighting")
local glassBlur = Lighting:FindFirstChild("iOSGlassBlur") or Instance.new("BlurEffect")
glassBlur.Name = "iOSGlassBlur"
glassBlur.Size = 16
glassBlur.Parent = Lighting

local function applyGlassToGui(gui)
	if not gui or not gui:IsA("GuiObject") then
		return
	end

	local corner = gui:FindFirstChildOfClass("UICorner")
	if corner then
		corner.CornerRadius = UDim.new(0, 22)
	else
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 22)
		c.Parent = gui
	end

	local stroke = gui:FindFirstChildOfClass("UIStroke")
	if stroke then
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 1
		stroke.Transparency = 0.75
	else
		local s = Instance.new("UIStroke")
		s.Color = Color3.fromRGB(255, 255, 255)
		s.Thickness = 1
		s.Transparency = 0.75
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Parent = gui
	end
end

local function addGlassHighlight(btn)
	if not btn:IsA("GuiObject") then
		return
	end
	if btn:FindFirstChild("GlassGrad") then
		return
	end
	local g = Instance.new("UIGradient")
	g.Name = "GlassGrad"
	g.Rotation = 90
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
	})
	g.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.85),
		NumberSequenceKeypoint.new(0.5, 0.95),
		NumberSequenceKeypoint.new(1, 0.98),
	})
	g.Parent = btn
end

task.spawn(function()
	local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	pg.DescendantAdded:Connect(function(obj)
		if obj:IsA("Frame") then
			task.wait(0.05)
			applyGlassToGui(obj)
		elseif obj:IsA("TextButton") then
			task.wait(0.05)
			applyGlassToGui(obj)
			addGlassHighlight(obj)
			local c = obj:FindFirstChildOfClass("UICorner")
			if c then
				c.CornerRadius = UDim.new(0, 14)
			else
				local cc = Instance.new("UICorner")
				cc.CornerRadius = UDim.new(0, 14)
				cc.Parent = obj
			end
		elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			task.wait(0.05)
			pcall(function()
				obj.Font = Enum.Font.GothamMedium
			end)
		end
	end)
end)

local tbl4 = {Color = Color3.fromHex("#6A0DAD"), Transparency = 0}
local tbl5 = {Color = Color3.fromHex("#00008B"), Transparency = 0}

Window:Tag({
	Title = "v1.0.0",
	Color = module:Gradient({["0"] = tbl4, ["100"] = tbl5}, {Rotation = 45}),
	Radius = 13,
})

local tbl6 = {Color = Color3.fromHex("#00FF00"), Transparency = 0}
local tbl7 = {Color = Color3.fromHex("#FFFF00"), Transparency = 0}

Window:Tag({
	Title = "Free",
	Color = module:Gradient({["0"] = tbl6, ["100"] = tbl7}, {Rotation = 45}),
	Radius = 13,
})

Window:EditOpenButton({
	Title = func("Open Kyo Scripts"),
	CornerRadius = UDim.new(0, 16),
	StrokeThickness = 2,
	Color = ColorSequence.new(Color3.fromHex("6A0DAD"), Color3.fromHex("00008B")),
	OnlyMobile = false,
	Enabled = true,
	Draggable = true,
})

Window:SetBackgroundImageTransparency(0.85)

Window:Dialog({
	Icon = "house",
	Title = "Discord Server",
	Content = "Join our Discord server for updates and support!",
	Buttons = {
		{
			Title = "Sure!",
			Callback = function()
				setclipboard("https://discord.gg/7QrCxJxh68")
			end,
		},
		{Title = "Cancel", Callback = function() end},
	},
})

Window:Dialog({
	Icon = "house",
	Title = "Official Only!",
	Content = "The only real Kyo Scripts is at discord.gg/7QrCxJxh68. Do not use or claim this as your own script!",
	Buttons = {
		{
			Title = "I agree!",
			Callback = function()
				func1("Thanks!")
			end,
		},
		{Title = "Cancel", Callback = function() end},
	},
})

local v1 = Window:Tab({Title = func("Introduction"), Icon = "house"})
v1:Section({Title = "Welcome to Kyo Scripts"})
local tbl8 = {Title = func("Community"), Content = ""}
v1:Paragraph(tbl8)

local function func4()
	local ok, result = pcall(function()
		return HttpService:JSONDecode(func3({
			Url = "https://discord.com/api/v10/invites/7QrCxJxh68?with_counts=true&with_expiration=true",
			Method = "GET",
			Headers = {["User-Agent"] = "RobloxBot/1.0", Accept = "application/json"},
		}).Body)
	end)
	if ok and result and result.guild then
		local v2 = v1:Paragraph({
			Title = result.guild.name,
			Desc = ' <font color="#52525b"></font> Member Count : ' .. tostring(result.approximate_member_count) .. '\n <font color="#16a34a"></font> Online Count : ' .. tostring(result.approximate_presence_count),
			Image = "https://cdn.discordapp.com/attachments/1477384799147524253/1511617264837988442/IMG_3826.png?ex=6a2afe08&is=6a29ac88&hm=961dece7a9f92f0a9e529512933fc94023e57ea94fde21c9c8f31845691eed42",
			ImageSize = 42,
		})
		v1:Button({
			Title = "Update Discord Info",
			Callback = function()
				local ok, result = pcall(function()
					return HttpService:JSONDecode(func3({
						Url = "https://discord.com/api/v10/invites/7QrCxJxh68?with_counts=true&with_expiration=true",
						Method = "GET",
					}).Body)
				end)
				if ok and result and result.guild then
					v2:SetDesc(' <font color="#52525b"></font> Member Count : ' .. tostring(result.approximate_member_count) .. '\n <font color="#16a34a"></font> Online Count : ' .. tostring(result.approximate_presence_count))
					module:Notify({
						Title = "Discord Info Updated",
						Content = "Successfully refreshed Discord statistics",
						Duration = 2,
						Icon = "refresh-cw",
					})
				else
					module:Notify({
						Title = "Update Failed",
						Content = "Could not refresh Discord info",
						Duration = 3,
						Icon = "alert-triangle",
					})
				end
			end,
		})
	else
		v1:Paragraph({Title = "Discord info unavailable", Desc = "Could not fetch server stats.", Color = "Red"})
	end
end

v1:Button({
	Title = "Copy Discord Invite",
	Callback = function()
		setclipboard("https://discord.gg/7QrCxJxh68")
		module:Notify({
			Title = "Copied!",
			Content = "Discord invite copied to clipboard",
			Duration = 2,
			Icon = "clipboard-check",
		})
	end,
})

v1:Button({
	Title = "Kyo Scripts — Community",
	Callback = function()
		setclipboard("https://discord.gg/7QrCxJxh68")
		module:Notify({Title = "Copied!", Content = "Discord link copied to clipboard!", Duration = 3, Icon = "link"})
	end,
})

func4()
local tbl9 = {Title = func("About"), Content = ""}
v1:Paragraph(tbl9)
v1:Paragraph({Title = "Kyo Scripts is a free script hub with quality tools and features.", Content = ""})
local tbl10 = {Title = func("Information"), Content = ""}
v1:Paragraph(tbl10)

v1:Paragraph({
	Title = "Kyo Scripts is the official free script hub. Do not proclaim this as your own script.",
	Content = "",
})

local tbl11 = {Title = func("Features"), Content = ""}
v1:Paragraph(tbl11)
v1:Paragraph({Title = "Add your features here as you build out tabs!", Content = ""})
local tbl12 = {Title = func("Discord"), Content = ""}
v1:Paragraph(tbl12)
v1:Paragraph({Title = "Join our Discord for updates and support!\ndiscord.gg/7QrCxJxh68", Content = ""})

v1:Button({
	Title = "Copy Discord Link",
	Callback = function()
		setclipboard("https://discord.gg/7QrCxJxh68")
		func1("Discord link copied!")
	end,
})

local tbl13 = {Title = func("YouTube"), Content = ""}
v1:Paragraph(tbl13)

v1:Paragraph({
	Title = "Subscribe to our YouTube channel for tutorials and updates!\nyoutube.com/@kyo_scripts",
	Content = "",
})

v1:Button({
	Title = "Copy YouTube Channel Link",
	Icon = "youtube",
	Callback = function()
		setclipboard("https://youtube.com/@kyo_scripts")
		module:Notify({
			Title = "Copied!",
			Content = "YouTube channel link copied to clipboard!",
			Duration = 2,
			Icon = "clipboard-check",
		})
	end,
})

-- ================= Main Tab =================
Tab = Window:Tab({Title = "Main", Icon = "square", Locked = false})

Section = Tab:Section({
	Title = "Auto Stun",
	Icon = "bird",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local MonsterHitByTorch = game:GetService("ReplicatedStorage").RemoteEvents.MonsterHitByTorch
local flag = false
local flag1 = false
local Deer = workspace.Characters:FindFirstChild("Deer")
local Ram = workspace.Characters:FindFirstChild("Ram")

Tab:Toggle({
	Title = "Hit Deer with Torch",
	Default = false,
	Callback = function(value)
		flag = value
		if value then
			spawn(function()
				while flag do
					if Deer then
						MonsterHitByTorch:InvokeServer(Deer)
					end
					task.wait()
				end
			end)
		end
	end,
})

Tab:Toggle({
	Title = "Auto Stun deer (Hold Flashlight)",
	Default = false,
	Callback = function(value)
		flag1 = value
		if value then
			spawn(function()
				while flag1 do
					if Ram then
						MonsterHitByTorch:InvokeServer(Ram)
					end
					task.wait()
				end
			end)
		end
	end,
})

Section = Tab:Section({
	Title = "God Mode",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players = game:GetService("Players")
local flag2 = false
local connection

local function func5(arg1)
	if arg1 and flag2 then
		arg1.MaxHealth = 100
		arg1.Health = 100
		arg1.BreakJointsOnDeath = false

		if connection then
			connection:Disconnect()
		end

		connection = arg1.HealthChanged:Connect(function(health)
			if flag2 and health < 100 then
				arg1.Health = 100
			end
		end)
	end
end

local function func6(arg1)
	if arg1 then
		arg1.MaxHealth = 100
		arg1.Health = 100
		arg1.BreakJointsOnDeath = true

		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end

Tab:Toggle({
	Title = "God mode (Invincibility)",
	Desc = "Makes you completely invincible to all damage, hunger, and death.",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		flag2 = value
		local Character1 = Players.LocalPlayer.Character

		if Character1 then
			local Humanoid1 = Character1:FindFirstChild("Humanoid")
			if value then
				func5(Humanoid1)
			else
				func6(Humanoid1)
			end
		end
	end,
})

Players.LocalPlayer.CharacterAdded:Connect(function(character1)
	if flag2 then
		local Humanoid1 = character1:WaitForChild("Humanoid")
		func5(Humanoid1)
	end
end)

task.spawn(function()
	local RunService = game:GetService("RunService")
	while true do
		RunService.RenderStepped:Wait()
		if flag2 then
			local Character1 = Players.LocalPlayer.Character

			if Character1 then
				local Humanoid1 = Character1:FindFirstChild("Humanoid")
				if Humanoid1 then
					if Humanoid1.Health < 100 then
						Humanoid1.Health = 100
					end
				end
			end

			Players.LocalPlayer:SetAttribute("Hunger", 100)
		end
	end
end)

Section = Tab:Section({
	Title = "Hip Height",
	Icon = "diameter",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid")
originalHipHeight = Humanoid.HipHeight
hipHeightSlider = 20
hipHeightEnabled = false

HipHeightSlider = Tab:Slider({
	Title = "Hip Height",
	Step = 1,
	Value = {Min = 20, Max = 100, Default = 20},
	Callback = function(value)
		hipHeightSlider = value
		if hipHeightEnabled then
			Humanoid.HipHeight = hipHeightSlider
		end
	end,
})

HipHeightToggle = Tab:Toggle({
	Title = "Hip Height",
	Desc = "This Hip height will save you from the hostile Monster/Enemies Use Minimum :20: For It TO work!!",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		hipHeightEnabled = value
		if hipHeightEnabled then
			Humanoid.HipHeight = hipHeightSlider
		else
			Humanoid.HipHeight = originalHipHeight
		end
	end,
})

Section = Tab:Section({
	Title = "Chop Tree",
	Icon = "axe",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

rs = game:GetService("ReplicatedStorage")
plrs = game:GetService("Players")
lp = plrs.LocalPlayer
tdr = rs.RemoteEvents.ToolDamageObject
er = rs.RemoteEvents.EquipItemHandle
hrp = lp.Character and lp.Character:WaitForChild("HumanoidRootPart")

lp.CharacterAdded:Connect(function(character1)
	hrp = character1:WaitForChild("HumanoidRootPart")
end)

range = 70
chopAuraEnabled = false
active = {}

tdi = {
	["Old Axe"] = "3_7367831688",
	["Good Axe"] = "112_7367831688",
	["Strong Axe"] = "116_7367831688",
	["Ice Axe"] = "116_7367831688",
	["Admin Axe"] = "116_7367831688",
	Chainsaw = "120_7367831688",
}

SelectedTreeTypes = {"Small Tree"}

Slider = Tab:Slider({
	Title = "Range",
	Step = 1,
	Value = {Min = 20, Max = 1000, Default = 70},
	Callback = function(value)
		range = tonumber(value) or 70
	end,
})

TreeDropdown = Tab:Dropdown({
	Title = "Select Trees to Chop",
	Values = {"Snowy Small Tree", "Small Tree", "TreeBig"},
	Value = {"Small Tree"},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		SelectedTreeTypes = value
	end,
})

function gtool()
	inv = lp:FindFirstChild("Inventory")

	if not inv then
		return nil, nil
	end

	for k, v1 in pairs(tdi) do
		tool = inv:FindFirstChild(k)
		if tool then
			return tool, v1
		end
	end

	return nil, nil
end

function eq(arg1)
	if arg1 then
		er:FireServer("FireAllClients", arg1)
	end
end

task.spawn(function()
	while true do
		task.wait(3)
		if chopAuraEnabled then
			tool = gtool()
			if tool then
				eq(tool)
			end
		end
	end
end)

function startloop(arg1)
	if not arg1:IsA("Model") or not arg1:FindFirstChildWhichIsA("BasePart") then
		return
	end

	if active[arg1] then
		return
	end

	active[arg1] = true

	task.spawn(function()
		while arg1.Parent and active[arg1] do
			local v1, v2 = gtool()
			tool = v1
			dmgId = v2

			if not tool or not dmgId or not hrp then
				task.wait(0.2)
			else
				pp = arg1.PrimaryPart or arg1:FindFirstChildWhichIsA("BasePart")

				if not pp then
					break
				end

				dist = (hrp.Position - pp.Position).Magnitude

				if dist <= range then
					tdr:InvokeServer(arg1, tool, dmgId, hrp.CFrame)
				end

				cd = tool:GetAttribute("ToolCooldown") or 1
				task.wait(cd)
			end
		end
		active[arg1] = nil
	end)
end

AutoChopToggle = Tab:Toggle({
	Title = "Auto Chop Selected Trees",
	Desc = "Chop all trees of selected types in your range",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		chopAuraEnabled = value
		if value then
			for _, v1 in ipairs({workspace.Map.Landmarks, workspace.Map.Foliage}) do
				for _, child in ipairs(v1:GetChildren()) do
					if table.find(SelectedTreeTypes, child.Name) then
						startloop(child)
					end
				end
			end
		else
			for k in pairs(active) do
				active[k] = nil
			end
		end
	end,
})

for _, v2 in ipairs({workspace.Map.Landmarks, workspace.Map.Foliage}) do
	v2.ChildAdded:Connect(function(child)
		if chopAuraEnabled and table.find(SelectedTreeTypes, child.Name) then
			startloop(child)
		end
	end)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
Players = game:GetService("Players")
player = Players.LocalPlayer
autoPlantEnabled = false

function findSapling()
	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant.Name == "Sapling" and descendant:IsA("Model") then
			return descendant
		end
	end
	return nil
end

function plantSapling(arg1)
	if not arg1 then
		return
	end

	position = arg1.PrimaryPart and arg1.PrimaryPart.Position or arg1:GetModelCFrame().p
	ReplicatedStorage.RemoteEvents.RequestPlantItem:InvokeServer(arg1, position)
end

task.spawn(function()
	while true do
		task.wait(1)
		if autoPlantEnabled then
			sapling = findSapling()
			if sapling then
				plantSapling(sapling)
			end
		end
	end
end)

AutoPlantToggle = Tab:Toggle({
	Title = "Auto Plant Sapling",
	Desc = "Auto Plants Saplings",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		autoPlantEnabled = value
	end,
})

Section = Tab:Section({
	Title = "Auto Food",
	Icon = "carrot",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

ReplicatedStorage = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
Workspace = game:GetService("Workspace")
player = Players.LocalPlayer
Remote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")

foodOptions = {
	"Carrot",
	"Berry",
	"Chili",
	"Morsel",
	"Steak",
	"Cooked Morsel",
	"Cooked Steak",
	"Salmon",
	"Clownfish",
	"Mackerel",
	"Cooked Mackerel",
	"Cooked Salmon",
	"Cooked Clownfish",
	"Ribs",
	"Cooked Ribs",
	"Cake",
	"Apple",
}

autoConsumeEnabled = false
selectedFoods = {}
hungerThreshold = 70

FoodDropdown = Tab:Dropdown({
	Title = "Auto Eat Food",
	Values = foodOptions,
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		selectedFoods = {}
		for _, v1 in ipairs(value) do
			selectedFoods[v1] = true
		end
	end,
})

HungerSlider = Tab:Slider({
	Title = "Eat Food when Hunger Below",
	Step = 1,
	Value = {Min = 20, Max = 200, Default = 70},
	Callback = function(value)
		hungerThreshold = tonumber(value) or 70
	end,
})

function getNearestFood()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return nil
	end

	local v2
	local huge = math.huge
	local HumanoidRootPart = player.Character.HumanoidRootPart

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if selectedFoods[descendant.Name] and descendant:IsA("Model") then
			local v1 = descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart")
			if v1 then
				local Magnitude = (HumanoidRootPart.Position - v1.Position).Magnitude
				if Magnitude < huge then
					huge = Magnitude
					v2 = descendant
				end
			end
		end
	end

	return v2
end

task.spawn(function()
	while task.wait(0.5) do
		if autoConsumeEnabled then
			hunger = player:GetAttribute("Hunger") or 0
			if hunger <= hungerThreshold then
				food = getNearestFood()
				if food then
					Remote:InvokeServer(food)
				end
			end
		end
	end
end)

AutoConsumeToggle = Tab:Toggle({
	Title = "Auto Eat",
	Desc = "Automatically eats food when hunger is low",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		autoConsumeEnabled = value
	end,
})

Section = Tab:Section({
	Title = "Kill aura (Select)",
	Icon = "hand-fist",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local ReplicatedStorage1 = game:GetService("ReplicatedStorage")
local LocalPlayer1 = game.Players.LocalPlayer
local ToolDamageObject = ReplicatedStorage1.RemoteEvents:WaitForChild("ToolDamageObject")
local flag3 = false
local num = 70
local tbl14 = {}

local tbl15 = {
	["Old Axe"] = "3_7367831688",
	["Good Axe"] = "112_7367831688",
	["Strong Axe"] = "116_7367831688",
	["Ice Axe"] = "116_7367831688",
	["Admin Axe"] = "116_7367831688",
	Morningstar = "116_7367831688",
	["Laser Sword"] = "116_7367831688",
	["Ice Sword"] = "116_7367831688",
	Katana = "116_7367831688",
	Trident = "116_7367831688",
	["Poison Spear"] = "116_7367831688",
	Spear = "196_8999010016",
}

local tbl16 = {
	"Bunny",
	"Wolf",
	"Alpha Wolf",
	"Bear",
	"Cultist",
	"Crossbow Cultist",
	"Juggernaut Cultist",
	"Meteor Crab",
	"Lava Mammoth",
	"FrogKing",
	"Cultist king",
	"Horse",
	"Scorpion",
	"Hellephant",
	"FrogBlue",
}

local function func7()
	local v1 = LocalPlayer1:FindFirstChild("Inventory") or LocalPlayer1:FindFirstChild("Backpack")
	if v1 then
		for k, v2 in pairs(tbl15) do
			local v3 = v1:FindFirstChild(k)
			if v3 then
				return v3, v2
			end
		end
	end
end

Tab:Slider({
	Title = "Range",
	Step = 1,
	Value = {Min = 20, Max = 300, Default = 70},
	Callback = function(value)
		num = tonumber(value) or 70
	end,
})

Tab:Dropdown({
	Title = "Enemies",
	Values = tbl16,
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		tbl14 = {}
		for _, v1 in ipairs(value) do
			tbl14[v1] = true
		end
	end,
})

Tab:Toggle({
	Title = "Kill Aura",
	Desc = "Auto kill selected enemies in range",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		flag3 = value
	end,
})

task.spawn(function()
	while task.wait(0.05) do
		if flag3 and LocalPlayer1.Character and LocalPlayer1.Character:FindFirstChild("HumanoidRootPart") then
			local v1, v2 = func7()
			if v1 and v2 then
				for _, child in ipairs(workspace.Characters:GetChildren()) do
					if tbl14[child.Name] and child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
						if (LocalPlayer1.Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude <= num then
							ToolDamageObject:InvokeServer(child, v1, v2, child.HumanoidRootPart.CFrame)
						end
					end
				end
			end
		end
	end
end)

Section = Tab:Section({
	Title = "Kill aura (Nearby)",
	Icon = "hand-fist",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
local LocalPlayer2 = game:GetService("Players").LocalPlayer
local workspaceRef = workspace
local ToolDamageObject1 = ReplicatedStorage2.RemoteEvents:WaitForChild("ToolDamageObject")

local tbl17 = {
	["Old Axe"] = "3_7367831688",
	["Good Axe"] = "112_7367831688",
	["Strong Axe"] = "116_7367831688",
	["Ice Axe"] = "116_7367831688",
	["Admin Axe"] = "116_7367831688",
	Morningstar = "116_7367831688",
	["Laser Sword"] = "116_7367831688",
	["Ice Sword"] = "116_7367831688",
	Katana = "116_7367831688",
	Trident = "116_7367831688",
	["Poison Spear"] = "116_7367831688",
	Spear = "196_8999010016",
}

local flag4 = false
local num1 = 70

local function func8()
	local v1 = LocalPlayer2:FindFirstChild("Backpack") or LocalPlayer2:FindFirstChild("Inventory")

	if v1 then
		for k, v2 in pairs(tbl17) do
			local v3 = v1:FindFirstChild(k)
			if v3 then
				return v3, v2
			end
		end
	end

	return nil, nil
end

Tab:Slider({
	Title = "Range",
	Step = 1,
	Value = {Min = 20, Max = 300, Default = 70},
	Callback = function(value)
		num1 = tonumber(value) or 70
	end,
})

Tab:Toggle({
	Title = "Kill Aura",
	Desc = "Auto Kills All Nearby Enemies in range",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		flag4 = value
	end,
})

task.spawn(function()
	while task.wait(0.05) do
		if flag4 and LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") then
			local v1, v2 = func8()
			if v1 and v2 then
				for _, child in ipairs(workspaceRef.Characters:GetChildren()) do
					if
						child ~= LocalPlayer2.Character
						and child:IsA("Model")
						and child:FindFirstChild("HumanoidRootPart")
					then
						local HumanoidRootPart = child.HumanoidRootPart
						if (LocalPlayer2.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude <= num1 then
							ToolDamageObject1:InvokeServer(child, v1, v2, HumanoidRootPart.CFrame)
						end
					end
				end
			end
		end
	end
end)

Section = Tab:Section({
	Title = "Auto Heal",
	Icon = "cross",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local ReplicatedStorage3 = game:GetService("ReplicatedStorage")
local Players1 = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer3 = Players1.LocalPlayer
local Inventory = LocalPlayer3:WaitForChild("Inventory")
local Humanoid1 = (LocalPlayer3.Character or LocalPlayer3.CharacterAdded:Wait()):WaitForChild("Humanoid")
local RequestConsumeItem = ReplicatedStorage3:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")
local flag5 = false
local flag6 = false
local num2 = 50

Tab:Slider({
	Title = "Auto Bandage When Health is Below",
	Step = 1,
	Value = {Min = 1, Max = 100, Default = 50},
	Callback = function(value)
		num2 = tonumber(value) or 50
	end,
})

Tab:Toggle({
	Title = "Auto Bandage",
	Desc = "Use Bandage when health is below this value",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		flag5 = value
	end,
})

Tab:Toggle({
	Title = "Include MedKit",
	Desc = "Include MedKit to auto heal",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		flag6 = value
	end,
})

local function func9(name)
	local v1 = Inventory:FindFirstChild(name)
	if v1 then
		RequestConsumeItem:InvokeServer(v1)
	end
end

RunService.Heartbeat:Connect(function()
	if Humanoid1.Health <= num2 then
		if flag5 then
			func9("Bandage")
		end
		if flag6 then
			func9("MedKit")
		end
	end
end)

Section = Tab:Section({
	Title = "Others",
	Icon = "gear",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Workspace1 = game:GetService("Workspace")
local flag7 = false

local function func10(arg1)
	arg1.HoldDuration = 0
	arg1.RequiresLineOfSight = false
	arg1.MaxActivationDistance = 10
	arg1.ClickablePrompt = true
end

local tab = Tab
local tbl18 = {Title = "Instant Open Chests"}
tbl18.Desc = nil
tbl18.Type = "Toggle"
tbl18.Default = false

function tbl18.Callback(arg1)
	flag7 = arg1
	if flag7 then
		for _, descendant in ipairs(Workspace1.Items:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				func10(descendant)
			end
		end
	end
end

tab:Toggle(tbl18)
local Players2 = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService1 = game:GetService("RunService")
local LocalPlayer4 = Players2.LocalPlayer
local flag8 = false
local flag9 = false
local vector3 = Vector3.new(0, 10, 0)

local function func11()
	local ClockTime = Lighting.ClockTime
	return ClockTime >= 18 or ClockTime <= 6
end

local tab1 = Tab
local tbl19 = {Title = "Teleport to camp at night"}
tbl19.Desc = nil
tbl19.Type = "Toggle"
tbl19.Default = false

function tbl19.Callback(arg1)
	flag8 = arg1
end

tab1:Toggle(tbl19)

RunService1.RenderStepped:Connect(function()
	if not flag8 then
		return
	end

	local Character1 = LocalPlayer4.Character

	if not Character1 then
		return
	end

	local HumanoidRootPart = Character1:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	if func11() and not flag9 then
		flag9 = true
		HumanoidRootPart.CFrame = CFrame.new(vector3)
	elseif not func11() then
		flag9 = false
	end
end)

-- ================= Teleports Tab =================
Tab = Window:Tab({Title = "Teleports", Icon = "map-pin", Locked = false})

Section = Tab:Section({
	Title = "Main Locations",
	Icon = "map-pin",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local function func12(name)
	local LocalPlayer = game.Players.LocalPlayer

	if not LocalPlayer then
		return
	end

	local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local v1 = workspace:FindFirstChild(name, true)

	if v1 then
		HumanoidRootPart.CFrame = (v1:IsA("Model") and v1:GetPivot() or v1.CFrame) + Vector3.new(0, 5, 0)
	end
end

Tab:Button({
	Title = "Teleport to Camp",
	Locked = false,
	Callback = function()
		func12("Camp")
	end,
})

Tab:Button({
	Title = "Teleport To Pelt Trader",
	Locked = false,
	Callback = function()
		func12("Pelt Trader")
	end,
})

Tab:Button({
	Title = "Teleport To Fairy",
	Locked = false,
	Callback = function()
		func12("Fairy")
	end,
})

Tab:Button({
	Title = "Teleport To Military Base",
	Locked = false,
	Callback = function()
		func12("Military Base")
	end,
})

Tab:Button({
	Title = "Teleport To Stronghold",
	Locked = false,
	Callback = function()
		func12("Stronghold")
	end,
})

Tab:Button({
	Title = "Teleport To Caravan",
	Locked = false,
	Callback = function()
		func12("Caravan")
	end,
})

Tab:Button({
	Title = "Teleport To Kings Palace",
	Locked = false,
	Callback = function()
		func12("Kings Palace")
	end,
})

Section = Tab:Section({
	Title = "Enemies/Animals",
	Icon = "bird",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local v5

Tab:Dropdown({
	Title = "Select Enemy",
	Values = {
		"Bunny",
		"Wolf",
		"Alpha Wolf",
		"Bear",
		"Cultist",
		"Crossbow Cultist",
		"Juggernaut Cultist",
		"Cultist King",
		"Hellephant",
		"Mammoth",
		"Meteor Crab",
		"Scorpion",
		"Artic Fox",
		"Polar Bear",
		"FrogKing",
		"Horse",
		"Kiwi",
		"Alien",
	},
	Value = "Bunny",
	Callback = function(value)
		v5 = value
	end,
})

local tab2 = Tab
local tbl20 = {Title = "Teleport to Enemy"}
tbl20.Desc = nil
tbl20.Locked = false

function tbl20.Callback()
	if not v5 then
		return
	end

	local LocalPlayer = game.Players.LocalPlayer
	local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
	local tbl = {}

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant.Name == v5 and descendant:IsA("Model") then
			table.insert(tbl, descendant)
		end
	end

	if #tbl > 0 then
		local v1 = tbl[math.random(1, #tbl)]
		local v2 = v1.PrimaryPart or v1:FindFirstChildWhichIsA("BasePart")

		if v2 then
			HumanoidRootPart.CFrame = v2.CFrame + Vector3.new(0, 5, 0)
		end
	end
end

tab2:Button(tbl20)

Section = Tab:Section({
	Title = "Child",
	Icon = "baby",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

selectedKid = nil

Tab:Dropdown({
	Title = "Select Kid",
	Values = {"DinoKid", "KrakenKid", "SquidKid", "KoalaKid"},
	Value = "DinoKid",
	Callback = function(value)
		selectedKid = value
	end,
})

Tab:Button({
	Title = "Teleport to Kid",
	Desc = "Teleports you to the selected kid type",
	Locked = false,
	Callback = function()
		if not selectedKid then
			print("[Kyo Scripts] No kid selected!")
			return
		end

		local LocalPlayer = game.Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local v1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if not v1 then
			return
		end

		local HumanoidRootPart = v1:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			local HumanoidRootPart1 = v1:WaitForChild("HumanoidRootPart", 5)
			HumanoidRootPart = HumanoidRootPart1

			if not HumanoidRootPart1 then
				return
			end
		end

		local flag = false

		for _, descendant in pairs(workspace:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == selectedKid then
				local v2 = descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
				if v2 then
					HumanoidRootPart.CFrame = v2.CFrame + Vector3.new(0, 5, 0)
					flag = true
					print("[Kyo Scripts] Teleported to " .. selectedKid)
					break
				end
			end
		end

		if not flag then
			print("[Kyo Scripts] Could not find " .. selectedKid .. " in the game!")
		end
	end,
})

Section = Tab:Section({
	Title = "Chests",
	Icon = "package",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

SelectedChest = nil
ChestOptions = {}

function updateChestOptions()
	ChestOptions = {}

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("Model") and (descendant.Name:find("Item Chest") or descendant.Name:find("Volcanic")) then
			table.insert(ChestOptions, descendant.Name)
		end
	end

	SelectedChest = ChestOptions[1]
end

updateChestOptions()

ChestDropdown = Tab:Dropdown({
	Title = "Select Chest",
	Values = ChestOptions,
	Value = SelectedChest,
	Callback = function(value)
		SelectedChest = value
	end,
})

TeleportChestButton = Tab:Button({
	Title = "Teleport to Selected Chest",
	Callback = function()
		if not SelectedChest then
			return
		end

		local LocalPlayer = game.Players.LocalPlayer
		local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
		local tbl = {}

		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == SelectedChest then
				table.insert(tbl, descendant)
			end
		end

		if #tbl > 0 then
			HumanoidRootPart.CFrame = tbl[math.random(1, #tbl)]:GetPivot() + Vector3.new(0, 5, 0)
		end
	end,
})

RefreshChestsButton = Tab:Button({
	Title = "Refresh Chest List",
	Callback = function()
		updateChestOptions()
		ChestDropdown:UpdateValues(ChestOptions)
	end,
})

TeleportRandomChestButton = Tab:Button({
	Title = "Teleport to Random Chest",
	Callback = function()
		local LocalPlayer = game.Players.LocalPlayer
		local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
		local tbl = {}

		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("Model") and (descendant.Name:find("Item Chest") or descendant.Name:find("Volcanic")) then
				table.insert(tbl, descendant)
			end
		end

		if #tbl > 0 then
			HumanoidRootPart.CFrame = tbl[math.random(1, #tbl)]:GetPivot() + Vector3.new(0, 5, 0)
		end
	end,
})

Section = Tab:Section({
	Title = "Fuel",
	Icon = "fuel",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

SelectedObject = nil

DropdownObjects = {
	"Sapling",
	"Log",
	"Coal",
	"Chair",
	"Fuel Canister",
	"Oil Barrel",
	"Biofuel",
	"Cultist Corpse",
	"Crossbow Cultist Corpse",
	"Juggernaut Cultist Corpse",
	"Wolf Corpse",
	"Alpha Wolf Corpse",
	"Bear Corpse",
}

ObjectDropdown = Tab:Dropdown({
	Title = "Select Object",
	Values = DropdownObjects,
	Value = DropdownObjects[1],
	Callback = function(value)
		SelectedObject = value
	end,
})

Tab:Button({
	Title = "Teleport to Object",
	Callback = function()
		if not SelectedObject then
			return
		end

		local LocalPlayer = game.Players.LocalPlayer
		local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
		local tbl = {}

		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant.Name == SelectedObject then
				table.insert(tbl, descendant)
			end
		end

		if #tbl > 0 then
			local v1 = tbl[math.random(1, #tbl)]
			HumanoidRootPart.CFrame = (v1:IsA("Model") and v1:GetPivot() or v1.CFrame) + Vector3.new(0, 5, 0)
		end
	end,
})

Section = Tab:Section({
	Title = "Scrap",
	Icon = "cog",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

SelectedItem = nil

DropdownItems = {
	"Bolt",
	"Sheet Metal",
	"Broken Fan",
	"Old Radio",
	"Metal Chair",
	"Old Microwave",
	"Tyre",
	"Old Car Engine",
	"Washing Machine",
	"Cultist Prototype",
	"Cultist Experiment",
	"Cultist Gem",
	"Forest Gem",
}

ItemDropdown = Tab:Dropdown({
	Title = "Select Scrap",
	Values = DropdownItems,
	Value = DropdownItems[1],
	Callback = function(value)
		SelectedItem = value
	end,
})

TeleportButtonItem = Tab:Button({
	Title = "Teleport to Scrap",
	Callback = function()
		if not SelectedItem then
			return
		end

		local LocalPlayer = game.Players.LocalPlayer
		local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
		local tbl = {}

		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant.Name == SelectedItem then
				table.insert(tbl, descendant)
			end
		end

		if #tbl > 0 then
			local v1 = tbl[math.random(1, #tbl)]
			HumanoidRootPart.CFrame = (v1:IsA("Model") and v1:GetPivot() or v1.CFrame) + Vector3.new(0, 5, 0)
		end
	end,
})

-- ================= Automatic Tab =================
Tab = Window:Tab({Title = "Automatic", Icon = "telescope", Locked = false})

Section = Tab:Section({
	Title = "Auto Fuel (TweenSource)",
	Icon = "fuel",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players3 = game:GetService("Players")
local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
TweenService = game:GetService("TweenService")
workspaceRef = workspace
LocalPlayer2 = Players3.LocalPlayer
character = LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()
hrp = character:WaitForChild("HumanoidRootPart")
camera = workspaceRef.CurrentCamera
startDrag = ReplicatedStorage4.RemoteEvents:WaitForChild("RequestStartDraggingItem")
stopDrag = ReplicatedStorage4.RemoteEvents:WaitForChild("StopDraggingItem")
selectedItems = {}
autoBringEnabled = false
bringPos = CFrame.new(0, 10, 0)
camPos = CFrame.new(2, 9, 2)
bringDistanceThreshold = 15

ItemDropdown = Tab:Dropdown({
	Title = "Select Fuel",
	Values = {
		"Log",
		"Chair",
		"Coal",
		"Fuel Canister",
		"Oil Barrel",
		"Wolf Corpse",
		"Alpha Wolf Corpse",
		"Bear Corpse",
		"Cultist Corpse",
	},
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		selectedItems = {}
		for i = 1, #value do
			selectedItems[value[i]] = true
		end
	end,
})

local tab3 = Tab
local tbl21 = {Title = "Auto Fuel Campfire (BETA)"}
tbl21.Desc = nil
tbl21.Type = "Toggle"
tbl21.Default = false

function tbl21.Callback(arg1)
	autoBringEnabled = arg1
end

ToggleBring = tab3:Toggle(tbl21)

task.spawn(function()
	while true do
		if autoBringEnabled then
			camera.CFrame = camPos
			pool = {}

			for i = 1, #workspaceRef.Items:GetChildren() do
				item = workspaceRef.Items:GetChildren()[i]
				if item:IsA("Model") and selectedItems[item.Name] then
					pivot = item:GetPivot()
					if (pivot.Position - bringPos.Position).Magnitude > bringDistanceThreshold then
						table.insert(pool, item)
					end
				end
			end

			if #pool > 0 then
				tweenCount = math.max(1, math.floor(#pool * 0.5))
				local v1 = #pool

				for i1 = 1, v1 do
					if not autoBringEnabled then
						break
					end

					bringItem = pool[i1]

					if i1 <= tweenCount then
						pivot = bringItem:GetPivot()
						tween = TweenService:Create(hrp, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {CFrame = pivot * CFrame.new(0, 3, 0)})
						tween:Play()
						tween.Completed:Wait()
					end

					startDrag:FireServer(bringItem)
					bringItem:PivotTo(bringPos)
					stopDrag:FireServer(bringItem)
				end
			end
		else
			task.wait(0.05)
		end
		task.wait()
	end
end)

Section = Tab:Section({
	Title = "Auto fuel (Insta)",
	Icon = "fuel",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players4 = game:GetService("Players")
local ReplicatedStorage5 = game:GetService("ReplicatedStorage")
local workspaceRef1 = workspace
local LocalPlayer5 = Players4.LocalPlayer;
(LocalPlayer5.Character or LocalPlayer5.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
local RequestStartDraggingItem = ReplicatedStorage5:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
local StopDraggingItem = ReplicatedStorage5:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
local tbl22 = {}
local flag10 = false
local cFrame = CFrame.new(0, 10, 0)

Tab:Dropdown({
	Title = "Select Fuel",
	Values = {
		"Log",
		"Chair",
		"Coal",
		"Fuel Canister",
		"Oil Barrel",
		"Wolf Corpse",
		"Alpha Wolf Corpse",
		"Bear Corpse",
		"Cultist Corpse",
	},
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		tbl22 = {}
		for _, v1 in ipairs(value) do
			tbl22[v1] = true
		end
	end,
})

local tab4 = Tab
local tbl23 = {Title = "Auto Fuel Campfire 2"}
tbl23.Desc = nil
tbl23.Type = "Toggle"
tbl23.Default = false

function tbl23.Callback(arg1)
	flag10 = arg1
end

tab4:Toggle(tbl23)

task.spawn(function()
	while true do
		if flag10 then
			for _, child in ipairs(workspaceRef1.Items:GetChildren()) do
				if child:IsA("Model") and tbl22[child.Name] then
					if (child:GetPivot().Position - cFrame.Position).Magnitude > 1 then
						RequestStartDraggingItem:FireServer(child)
						child:PivotTo(cFrame)
						StopDraggingItem:FireServer(child)
					end
				end
			end
		end
		task.wait(0.01)
	end
end)

Section = Tab:Section({
	Title = "Auto Shred Scrap (Uses Tween for godly advantage)",
	Icon = "cog",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players5 = game:GetService("Players")
local ReplicatedStorage6 = game:GetService("ReplicatedStorage")
TweenService = game:GetService("TweenService")
workspaceRef1 = workspace
local LocalPlayer6 = Players5.LocalPlayer
local HumanoidRootPart = (LocalPlayer6.Character or LocalPlayer6.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
RequestStartDraggingItem = ReplicatedStorage6:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
StopDraggingItem = ReplicatedStorage6:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
tbl22 = {}
flag10 = false
cFrame = CFrame.new(21, 14, -6)

Tab:Dropdown({
	Title = "Select Items",
	Values = {
		"Bolt",
		"Sheet Metal",
		"Broken Fan",
		"Old Radio",
		"Broken Microwave",
		"Tyre",
		"Metal Chair",
		"Old Car Engine",
		"Washing Machine",
		"Cultist Experiment",
		"Cultist Prototype",
	},
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		tbl22 = {}
		for i = 1, #value do
			tbl22[value[i]] = true
		end
	end,
})

local tab5 = Tab
local tbl24 = {Title = "Auto Shred Scrap"}
tbl24.Desc = nil
tbl24.Type = "Toggle"
tbl24.Default = false

function tbl24.Callback(arg1)
	flag10 = arg1
end

tab5:Toggle(tbl24)

function tweenToPosition(arg1)
	tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	goal = {CFrame = arg1}
	tween = TweenService:Create(HumanoidRootPart, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
end

task.spawn(function()
	while true do
		if flag10 then
			items = workspaceRef1.Items:GetChildren()
			for i = 1, #items do
				item = items[i]
				if item:IsA("Model") and tbl22[item.Name] then
					pivot = item:GetPivot()
					if (pivot.Position - cFrame.Position).Magnitude > 15 then
						tweenToPosition(pivot * CFrame.new(0, 3, 0))
						RequestStartDraggingItem:FireServer(item)
						item:PivotTo(CFrame.new(cFrame.Position))
						StopDraggingItem:FireServer(item)
						task.wait(0.01)
					end
				end
			end
		end
		task.wait(0.01)
	end
end)

Section = Tab:Section({
	Title = "Auto Shred Scrap (Insta)",
	Icon = "cog",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players6 = game:GetService("Players")
local ReplicatedStorage7 = game:GetService("ReplicatedStorage")
workspaceRef1 = workspace
local LocalPlayer7 = Players6.LocalPlayer
HumanoidRootPart = (LocalPlayer7.Character or LocalPlayer7.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
RequestStartDraggingItem = ReplicatedStorage7:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
StopDraggingItem = ReplicatedStorage7:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
tbl22 = {}
flag10 = false
cFrame = CFrame.new(0, 10, 0)

Tab:Dropdown({
	Title = "Select Items",
	Values = {
		"Bolt",
		"Sheet Metal",
		"Broken Fan",
		"Old Radio",
		"Broken Microwave",
		"Tyre",
		"Metal Chair",
		"Old Car Engine",
		"Washing Machine",
		"Cultist Experiment",
		"Cultist Prototype",
		"Forest Gem",
	},
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		tbl22 = {}
		for i = 1, #value do
			tbl22[value[i]] = true
		end
	end,
})

local tab6 = Tab
local tbl25 = {Title = "Auto Shred Scrap"}
tbl25.Desc = nil
tbl25.Type = "Toggle"
tbl25.Default = false

function tbl25.Callback(arg1)
	flag10 = arg1
end

tab6:Toggle(tbl25)

task.spawn(function()
	while true do
		if flag10 then
			items = workspaceRef1.Items:GetChildren()
			for i = 1, #items do
				item = items[i]
				if item:IsA("Model") and tbl22[item.Name] then
					RequestStartDraggingItem:FireServer(item)
					item:PivotTo(cFrame)
					StopDraggingItem:FireServer(item)
				end
			end
		end
		task.wait(0.01)
	end
end)

Section = Tab:Section({
	Title = "Flowers",
	Icon = "flower-2",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local ReplicatedStorage8 = game:GetService("ReplicatedStorage")
wp = game:GetService("Workspace")
r = ReplicatedStorage8.RemoteEvents:WaitForChild("RequestPickFlower")
lm = wp.Map.Landmarks
autoPickEnabled = false
local tab7 = Tab
local tbl26 = {Title = "Auto Pick Flowers"}
tbl26.Desc = nil
tbl26.Type = "Toggle"
tbl26.Default = false

function tbl26.Callback(arg1)
	autoPickEnabled = arg1
end

TogglePickFlowers = tab7:Toggle(tbl26)

function pickFlower(arg1)
	pcall(function()
		r:InvokeServer(arg1)
	end)
end

function checkFlowers()
	if not autoPickEnabled then
		return
	end

	flowers = lm:GetDescendants()

	for i = 1, #flowers do
		f = flowers[i]
		if f.Name == "Flower" then
			pickFlower(f)
		end
	end
end

lm.DescendantAdded:Connect(function(descendant)
	if descendant.Name == "Flower" and autoPickEnabled then
		pickFlower(descendant)
	end
end)

task.spawn(function()
	while true do
		task.wait(0.3)
		checkFlowers()
	end
end)

checkFlowers()

Section = Tab:Section({
	Title = "Auto Collect Coin",
	Icon = "coins",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players7 = game:GetService("Players")
local ReplicatedStorage9 = game:GetService("ReplicatedStorage")
local Workspace2 = game:GetService("Workspace")
local HumanoidRootPart1

if Players7.LocalPlayer.Character then
	HumanoidRootPart1 = Players7.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
end

Players7.LocalPlayer.CharacterAdded:Connect(function(character1)
	HumanoidRootPart1 = character1:WaitForChild("HumanoidRootPart")
end)

local RequestCollectCoints = ReplicatedStorage9.RemoteEvents:WaitForChild("RequestCollectCoints")
_G.autoCollectCoins = false

Tab:Toggle({
	Title = "Auto Collect Coins",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		_G.autoCollectCoins = value
	end,
})

task.spawn(function()
	while task.wait(0.2) do
		if _G.autoCollectCoins then
			for _, descendant in ipairs(Workspace2:GetDescendants()) do
				if descendant:IsA("Model") and descendant.Name:find("Coin Stack") then
					pcall(function()
						RequestCollectCoints:InvokeServer(descendant)
					end)
				end
			end
		end
	end
end)

Section = Tab:Section({
	Title = "Seed Box",
	Icon = "bean",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local tab8 = Tab
local tbl27 = {Title = "Auto Open Seed Box"}
tbl27.Desc = nil
tbl27.Icon = "leaf"
tbl27.Type = "Toggle"
tbl27.Default = false

function tbl27.Callback(autoOpenSeeds)
	getgenv().autoOpenSeeds = autoOpenSeeds
	if autoOpenSeeds then
		getgenv().autoOpenSeedsThread = task.spawn(function()
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Workspace1 = game:GetService("Workspace")
			local LocalPlayer = game:GetService("Players").LocalPlayer
			local v1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			LocalPlayer.CharacterAdded:Connect(function(character1)
				v1 = character1:WaitForChild("HumanoidRootPart")
			end)

			local RequestPlantSeeds = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPlantSeeds")

			while getgenv().autoOpenSeeds and task.wait(0.5) do
				if v1 then
					for _, descendant in ipairs(Workspace1:GetDescendants()) do
						if descendant:IsA("Model") and descendant.Name:find("Seed Box") then
							RequestPlantSeeds:InvokeServer(descendant)
						end
					end
				end
			end
		end)
	elseif getgenv().autoOpenSeedsThread then
		task.cancel(getgenv().autoOpenSeedsThread)
		getgenv().autoOpenSeedsThread = nil
	end
end

tab8:Toggle(tbl27)

Section = Tab:Section({
	Title = "Crockpot",
	Icon = "cooking-pot",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players8 = game:GetService("Players")
local ReplicatedStorage10 = game:GetService("ReplicatedStorage")
WorkspaceItems = workspace:WaitForChild("Items")
StartDrag = ReplicatedStorage10:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
StopDrag = ReplicatedStorage10:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
local LocalPlayer8 = Players8.LocalPlayer
HumanoidRootPart1 = LocalPlayer8.Character and LocalPlayer8.Character:FindFirstChild("HumanoidRootPart")

if not HumanoidRootPart1 then
	return
end

tbl22 = {"Carrot"}
toggleActive = false

Dropdown = Tab:Dropdown({
	Title = "Select Items",
	Values = {"Carrot", "Apple", "Morsel", "Cooked Morsel", "Steak", "Cooked Steak"},
	Value = {"Carrot"},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		tbl22 = value
	end,
})

Toggle = Tab:Toggle({
	Title = "Auto Crockpot",
	Desc = "Auto Make Stews Basically",
	Icon = "bird",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		toggleActive = value
		if value then
			task.spawn(function()
				while toggleActive do
					filteredItems = {}
					children = WorkspaceItems:GetChildren()

					for i = 1, #children do
						item = children[i]
						if table.find(tbl22, item.Name) then
							table.insert(filteredItems, item)
						end
					end

					for _ = 1, math.min(3, #filteredItems) do
						idx = math.random(1, #filteredItems)
						item = filteredItems[idx]
						table.remove(filteredItems, idx)
						part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")) or item

						if part then
							if item:IsA("Model") and not item.PrimaryPart then
								item.PrimaryPart = part
							end

							crockPot = workspace:FindFirstChild("Crock Pot")

							if crockPot and crockPot.PrimaryPart then
								StartDrag:FireServer(item)
								item:SetPrimaryPartCFrame(crockPot.PrimaryPart.CFrame)
								StopDrag:FireServer(item)
							end
						end
					end

					task.wait(10)
				end
			end)
		end
	end,
})

Section = Tab:Section({
	Title = "Meat",
	Icon = "ham",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players9 = game:GetService("Players")
local ReplicatedStorage11 = game:GetService("ReplicatedStorage")
WorkspaceItems = workspace:WaitForChild("Items")
StartDrag = ReplicatedStorage11:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
StopDrag = ReplicatedStorage11:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
local LocalPlayer9 = Players9.LocalPlayer
HumanoidRootPart1 = LocalPlayer9.Character and LocalPlayer9.Character:FindFirstChild("HumanoidRootPart")

if not HumanoidRootPart1 then
	return
end

selectedItems2 = {"Morsel"}

Dropdown2 = Tab:Dropdown({
	Title = "Select Items to Bring Once",
	Values = {"Morsel", "Steak", "Ribs"},
	Value = {"Morsel"},
	Multi = true,
	AllowNone = true,
	Callback = function(value)
		selectedItems2 = value
	end,
})

Toggle2 = Tab:Toggle({
	Title = "Auto Cook Meat",
	Desc = "Auto Cooks Food basically yk meat",
	Icon = "bird",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		if value then
			filteredItems = {}
			children = WorkspaceItems:GetChildren()

			for i = 1, #children do
				item = children[i]
				if table.find(selectedItems2, item.Name) then
					table.insert(filteredItems, item)
				end
			end

			for i1 = 1, #filteredItems do
				item = filteredItems[i1]
				part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")) or item

				if part then
					if item:IsA("Model") and not item.PrimaryPart then
						item.PrimaryPart = part
					end

					targetPos = CFrame.new(0, 10, 0)
					StartDrag:FireServer(item)
					item:SetPrimaryPartCFrame(targetPos)
					StopDrag:FireServer(item)
				end
			end
		end
	end,
})

Section = Tab:Section({
	Title = "Auto Days",
	Icon = "cog",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local Players10 = game:GetService("Players")
Workspace2 = game:GetService("Workspace")
local LocalPlayer10 = Players10.LocalPlayer
local v3 = LocalPlayer10.Character or LocalPlayer10.CharacterAdded:Wait()
HumanoidRootPart1 = v3:WaitForChild("HumanoidRootPart")
baseplate = nil

BaseToggle = Tab:Toggle({
	Title = "Safe",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		if value then
			if baseplate then
				baseplate:Destroy()
			end

			baseplate = Instance.new("Part")
			baseplate.Size = Vector3.new(50, 50, 50)
			baseplate.Anchored = true
			baseplate.Position = Vector3.new(0, 6009, 0)
			baseplate.Material = Enum.Material.Grass
			baseplate.Color = Color3.fromRGB(0, 100, 0)
			baseplate.Name = "SafeZoneBaseplate"
			baseplate.Parent = Workspace2
			HumanoidRootPart1.CFrame = CFrame.new(baseplate.Position + Vector3.new(0, 5, 0))
		else
			if baseplate then
				baseplate:Destroy()
				baseplate = nil
			end
			HumanoidRootPart1.CFrame = CFrame.new(0, 10, 0)
		end
	end,
})

Section = Tab:Section({
	Title = "Circle Planting",
	Icon = "sprout",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

getgenv().plantRadius = getgenv().plantRadius or 70
getgenv().plantCenterPos = Vector3.new(-2, 4, 0)
getgenv().lastCircleAngle = getgenv().lastCircleAngle or 0
getgenv().saplingGap = 2

Tab:Slider({
	Title = "Circle Planting Radius",
	Step = 1,
	Value = {Min = 70, Max = 300, Default = getgenv().plantRadius},
	Callback = function(value)
		local v1 = math.max(70, value)
		getgenv().plantRadius = v1
		getgenv().lastCircleAngle = 0
		print(" Circle radius updated to:", getgenv().plantRadius)
	end,
})

local tab9 = Tab
local tbl28 = {Title = "Plant Saplings in a Circle"}
tbl28.Desc = nil
tbl28.Locked = false

function tbl28.Callback()
	task.spawn(function()
		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Workspace1 = game:GetService("Workspace")
		local StarterGui = game:GetService("StarterGui")
		local Items = Workspace1:WaitForChild("Items")
		local RequestStartDraggingItem = ReplicatedStorage.RemoteEvents:WaitForChild("RequestStartDraggingItem")
		local StopDraggingItem = ReplicatedStorage.RemoteEvents:WaitForChild("StopDraggingItem")
		local RequestPlantItem = ReplicatedStorage.RemoteEvents:WaitForChild("RequestPlantItem")
		local plantRadius = getgenv().plantRadius
		local plantCenterPos = getgenv().plantCenterPos
		local saplingGap = getgenv().saplingGap
		local tbl = {}

		for _, child in ipairs(Items:GetChildren()) do
			if child.Name == "Sapling" and (child:IsA("Model") or child:IsA("BasePart")) then
				table.insert(tbl, child)
			end
		end

		if #tbl == 0 then
			StarterGui:SetCore("SendNotification", {Title = "SpamX Notification", Text = "No saplings found!", Duration = 4})
			return
		end

		local LocalPlayer = Players.LocalPlayer

		if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
			StarterGui:SetCore(
				"SendNotification",
				{Title = "SpamX Notification", Text = "Player character not found!", Duration = 4}
			)
			return
		end

		local tbl1 = {}

		for _, child1 in ipairs(Items:GetChildren()) do
			if child1.Name == "Sapling" and child1:IsA("Model") and child1.PrimaryPart then
				table.insert(tbl1, child1.PrimaryPart.Position)
			end
		end

		local lastCircleAngle = getgenv().lastCircleAngle

		for _, v1 in ipairs(tbl) do
			local v2 = 2 * math.asin(saplingGap / (2 * plantRadius))
			local v3 = plantCenterPos.X + math.cos(lastCircleAngle) * plantRadius
			local v4 = plantCenterPos.Z + math.sin(lastCircleAngle) * plantRadius
			local vector3 = Vector3.new(v3, plantCenterPos.Y, v4)
			local flag = false

			for _, v5 in ipairs(tbl1) do
				if (vector3 - v5).Magnitude < saplingGap then
					flag = true
					break
				end
			end

			if flag then
				lastCircleAngle = lastCircleAngle + v2
			else
				local v6 = v1:IsA("Model")

				if v6 then
					v6 = v1.PrimaryPart
					v6 = v6 or v1:FindFirstChildWhichIsA("BasePart")
					v6 = v6 or v1:FindFirstChild("Handle")
				end

				v6 = v6 or v1

				if v6 then
					if v1:IsA("Model") and not v1.PrimaryPart then
						pcall(function()
							v1.PrimaryPart = v6
						end)
					end
					pcall(function()
						RequestStartDraggingItem:FireServer(v1)
						v1:SetPrimaryPartCFrame(CFrame.new(vector3))
						RequestPlantItem:InvokeServer(v1, vector3)
						StopDraggingItem:FireServer(v1)
					end)
				end

				table.insert(tbl1, vector3)
				lastCircleAngle = lastCircleAngle + v2
				getgenv().lastCircleAngle = lastCircleAngle
				task.wait(0.1)
			end
		end

		StarterGui:SetCore(
			"SendNotification",
			{Title = "SpamX Notification", Text = "All Saplings Planted in Circle", Duration = 4}
		)
	end)
end

tab9:Button(tbl28)

-- ================= Fun Features Tab =================
Tab = Window:Tab({Title = "Fun Features", Icon = "play", Locked = false})

Button = Tab:Button({
	Title = "Teleport All Trees To You",
	Desc = "A button to basically teleport all the trees next to you!",
	Locked = false,
	Callback = function()
		Players10 = game:GetService("Players")
		Workspace2 = game:GetService("Workspace")
		LocalPlayer4 = Players10.LocalPlayer
		v3 = LocalPlayer4.Character or LocalPlayer4.CharacterAdded:Wait()
		HumanoidRootPart1 = v3:WaitForChild("HumanoidRootPart")
		frontPos = HumanoidRootPart1.Position + HumanoidRootPart1.CFrame.LookVector * 10

		for _, descendant in pairs(Workspace2:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == "Small Tree" then
				if not descendant.PrimaryPart then
					base = descendant:FindFirstChildWhichIsA("BasePart")
					if base then
						descendant.PrimaryPart = base
					else
						continue
					end
				end
				descendant:SetPrimaryPartCFrame(CFrame.new(frontPos))
			end
		end
	end,
})

Button = Tab:Button({
	Title = "Teleport All Big Trees To You",
	Desc = "a button to basically teleport all big trees next to you",
	Locked = false,
	Callback = function()
		Players10 = game:GetService("Players")
		Workspace2 = game:GetService("Workspace")
		LocalPlayer4 = Players10.LocalPlayer
		v3 = LocalPlayer4.Character or LocalPlayer4.CharacterAdded:Wait()
		HumanoidRootPart1 = v3:WaitForChild("HumanoidRootPart")
		frontPos = HumanoidRootPart1.Position + HumanoidRootPart1.CFrame.LookVector * 10

		for _, descendant in pairs(Workspace2:GetDescendants()) do
			if descendant:IsA("Model") and string.find(descendant.Name, "TreeBig") then
				if not descendant.PrimaryPart then
					base = descendant:FindFirstChildWhichIsA("BasePart")
					if base then
						descendant.PrimaryPart = base
					else
						continue
					end
				end
				descendant:SetPrimaryPartCFrame(CFrame.new(frontPos))
			end
		end
	end,
})

Button_BringSnowyTrees = Tab:Button({
	Title = "Bring Snowy Small Tree Infront Of You",
	Desc = "A button to basically bring all snowy Small trees next to you",
	Locked = false,
	Callback = function()
		LocalPlayer4 = game:GetService("Players").LocalPlayer
		char = LocalPlayer4.Character or LocalPlayer4.CharacterAdded:Wait()
		HumanoidRootPart1 = char:WaitForChild("HumanoidRootPart")
		frontPos = HumanoidRootPart1.Position + HumanoidRootPart1.CFrame.LookVector * 10
		Workspace2 = game:GetService("Workspace")
		allDescendants = Workspace2:GetDescendants()

		for i = 1, #allDescendants do
			model = allDescendants[i]
			if model:IsA("Model") and model.Name == "Snowy Small Tree" then
				part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
				if part then
					model.PrimaryPart = part
					model:SetPrimaryPartCFrame(CFrame.new(frontPos))
				end
			end
		end
	end,
})

Section = Tab:Section({
	Title = "Freeze",
	Icon = "snowflake",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

workspaceCharacters = workspace:WaitForChild("Characters")

FreezeToggle = Tab:Toggle({
	Title = "Freeze All Enemies/Animal",
	Desc = "A Toggle To Basically Freeze All Enemies Or Animals Like Time Stop",
	Icon = "snowflake",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		children = workspaceCharacters:GetChildren()
		for i = 1, #children do
			model = children[i]
			if model:IsA("Model") then
				parts = model:GetDescendants()
				for i1 = 1, #parts do
					part = parts[i1]
					if part:IsA("BasePart") then
						part.Anchored = value
					end
				end
			end
		end
	end,
})

Section = Tab:Section({
	Title = "Chests",
	Icon = "package",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Button_BringChests = Tab:Button({
	Title = "Bring All Chests",
	Desc = "Brings all Chests basically like Volcanic Chest and Item Chest!",
	Locked = false,
	Callback = function()
		Players10 = game:GetService("Players")
		Workspace2 = game:GetService("Workspace")
		LocalPlayer4 = Players10.LocalPlayer
		v3 = LocalPlayer4.Character or LocalPlayer4.CharacterAdded:Wait()
		HumanoidRootPart1 = v3:WaitForChild("HumanoidRootPart")
		frontPos = HumanoidRootPart1.Position + HumanoidRootPart1.CFrame.LookVector * 10

		for _, descendant in pairs(Workspace2:GetDescendants()) do
			if descendant:IsA("Model") and (string.find(descendant.Name, "Item Chest") or string.find(descendant.Name, "Volcanic")) then
				part = descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart")
				if part then
					descendant.PrimaryPart = part
					descendant:SetPrimaryPartCFrame(CFrame.new(frontPos))
				end
			end
		end
	end,
})

Section = Tab:Section({
	Title = "Kids Alternative",
	Icon = "baby",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

SelectedKid = "DinoKid"

Dropdown = Tab:Dropdown({
	Title = "Select Kid Type",
	Values = {"DinoKid", "KrakenKid", "SquidKid", "KoalaKid"},
	Value = "DinoKid",
	Callback = function(value)
		SelectedKid = value
	end,
})

Button = Tab:Button({
	Title = "Bring Kid To You",
	Desc = "Brings the selected kid in front of you",
	Locked = false,
	Callback = function()
		if not SelectedKid then
			print("[Kyo Scripts] No kid selected!")
			return
		end

		local Players = game:GetService("Players")
		local Workspace1 = game:GetService("Workspace")
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local v1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if not v1 then
			return
		end

		local HumanoidRootPart = v1:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			local HumanoidRootPart1 = v1:WaitForChild("HumanoidRootPart", 5)
			HumanoidRootPart = HumanoidRootPart1

			if not HumanoidRootPart1 then
				return
			end
		end

		local v2 = HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 10
		local flag = false
		local Descendants = Workspace1:GetDescendants()

		for i = 1, #Descendants do
			local v3 = Descendants[i]
			if v3:IsA("Model") and string.find(v3.Name, SelectedKid) then
				local v4 = v3.PrimaryPart or v3:FindFirstChildWhichIsA("BasePart")
				if v4 then
					v3.PrimaryPart = v4

					pcall(function()
						v3:SetPrimaryPartCFrame(CFrame.new(v2))
					end)

					flag = true
					print("[Kyo Scripts] Brought " .. SelectedKid .. " to you!")
					break
				end
			end
		end

		if not flag then
			print("[Kyo Scripts] Could not find " .. SelectedKid .. " in the world!")
		end
	end,
})

Section = Tab:Section({
	Title = "Summon Map",
	Icon = "map",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Button({
	Title = "Teleport to Steal A Brainrot Map",
	Callback = function()
		local Players = game:GetService("Players")
		local Workspace1 = game:GetService("Workspace")
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local vector3 = Vector3.new(0, 6388, 0)
		local vector31 = Vector3.new(0, 20, 0)

		local function func(player1, arg2)
			local v1 = arg2 or 10
			local v2 = tick()

			while tick() - v2 <= v1 do
				local Character1 = player1.Character

				if Character1 and Character1.Parent then
					return Character1
				end

				task.wait(0.05)
			end

			return player1.Character
		end

		local function func1(arg1)
			local tbl = {}
			local vector3 = Vector3.new(0, 0, 0)
			local num = 0

			for _, descendant in ipairs(arg1:GetDescendants()) do
				if descendant:IsA("BasePart") then
					num = num + 1
					vector3 = vector3 + descendant.Position
					tbl[#tbl + 1] = descendant
				end
			end

			if num == 0 then
				return tbl, nil
			end

			return tbl, vector3 / num
		end

		local function func2(arg1, arg2)
			local _, v1 = func1(arg1)
			local v2 = v1

			if not v2 then
				if typeof(arg1.GetPivot) == "function" then
					local ok, result = pcall(function()
						return arg1:GetPivot()
					end)
					if ok and result then
						v2 = result.Position
					end
				end
			end

			if not v2 then
				return false
			end

			pcall(function()
				arg2.CFrame = CFrame.new(v2 + vector31)
			end)

			return true
		end

		local v1 = func(LocalPlayer, 10)

		if not v1 then
			return
		end

		local v2 = v1:FindFirstChild("HumanoidRootPart") or v1:FindFirstChild("Torso") or v1:FindFirstChild("UpperTorso")

		if not v2 then
			return
		end

		local __LOADED_MODEL_96439444595951 = Workspace1:FindFirstChild("__LOADED_MODEL_96439444595951")

		if __LOADED_MODEL_96439444595951 and __LOADED_MODEL_96439444595951.Parent then
			if pcall(function()
				if not func2(__LOADED_MODEL_96439444595951, v2) then
					error("Teleport failed.")
				end
			end) then
				return
			end
		end

		local ok, result = pcall(function()
			return game:GetObjects("rbxassetid://96439444595951")[1]
		end)

		if not ok or not result then
			return
		end

		result.Name = "__LOADED_MODEL_96439444595951"
		result.Parent = Workspace1
		local v3, v4 = func1(result)

		if v4 then
			local v5 = vector3 - v4
			local tbl = {}

			for _, v6 in ipairs(v3) do
				tbl[v6] = v6.Anchored
				v6.Anchored = true
				v6.CFrame = v6.CFrame + v5
			end

			for k, v7 in pairs(tbl) do
				if k and k.Parent then
					k.Anchored = v7
				end
			end
		else
			local flag = false

			pcall(function()
				if typeof(result.PivotTo) == "function" then
					result:PivotTo(CFrame.new(vector3))
					flag = true
				end
			end)

			if not flag then
				for _, descendant in ipairs(result:GetDescendants()) do
					if descendant:IsA("BasePart") then
						pcall(function()
							result.PrimaryPart = descendant
						end)
						break
					end
				end
				pcall(function()
					if result.PrimaryPart then
						result:SetPrimaryPartCFrame(CFrame.new(vector3))
						flag = true
					end
				end)
			end
		end

		func2(result, v2)
	end,
})

local Players11 = game:GetService("Players")
local Workspace3 = game:GetService("Workspace")
local LocalPlayer11 = Players11.LocalPlayer

if not LocalPlayer11 then
	return
end

local vector31 = Vector3.new(0, 65782, 0)
local vector32 = Vector3.new(0, 20, 0)

local function func13(player1, arg2)
	local v1 = tick()

	while tick() - v1 <= (arg2 or 10) do
		if player1.Character and player1.Character.Parent then
			return player1.Character
		end
		task.wait(0.05)
	end

	return player1.Character
end

local function func14(arg1)
	local tbl = {}
	local vector3 = Vector3.new()
	local num = 0

	for _, descendant in ipairs(arg1:GetDescendants()) do
		if descendant:IsA("BasePart") then
			num = num + 1
			vector3 = vector3 + descendant.Position
			tbl[#tbl + 1] = descendant
		end
	end

	return tbl, num > 0 and vector3 / num or nil
end

local function func15(arg1, arg2)
	local _, v1 = func14(arg1)
	local v2 = v1

	if not v2 then
		if typeof(arg1.GetPivot) == "function" then
			local ok, result = pcall(function()
				return arg1:GetPivot()
			end)
			if ok and result then
				v2 = result.Position
			end
		end
	end

	if v2 then
		pcall(function()
			arg2.CFrame = CFrame.new(v2 + vector32)
		end)
	end
end

local function func16()
	local v1 = func13(LocalPlayer11, 10)

	if not v1 then
		return
	end

	local v2 = v1:FindFirstChild("HumanoidRootPart") or v1:FindFirstChild("Torso") or v1:FindFirstChild("UpperTorso")

	if not v2 then
		return
	end

	local __LOADED_MODEL_105019154044298 = Workspace3:FindFirstChild("__LOADED_MODEL_105019154044298")

	if __LOADED_MODEL_105019154044298 then
		func15(__LOADED_MODEL_105019154044298, v2)
		return
	end

	local ok, result = pcall(function()
		return game:GetObjects("rbxassetid://105019154044298")[1]
	end)

	if not ok or not result then
		return
	end

	result.Name = "__LOADED_MODEL_105019154044298"
	result.Parent = Workspace3
	local v3, v4 = func14(result)

	if v4 then
		local v5 = vector31 - v4
		local tbl = {}

		for _, v6 in ipairs(v3) do
			tbl[v6] = v6.Anchored
			v6.Anchored = true
			v6.CFrame = v6.CFrame + v5
		end

		for k, v7 in pairs(tbl) do
			if k and k.Parent then
				k.Anchored = v7
			end
		end
	else
		pcall(function()
			if typeof(result.PivotTo) == "function" then
				result:PivotTo(CFrame.new(vector31))
			elseif result.PrimaryPart then
				result:SetPrimaryPartCFrame(CFrame.new(vector31))
			else
				for _, descendant in ipairs(result:GetDescendants()) do
					if descendant:IsA("BasePart") then
						result.PrimaryPart = descendant
						result:SetPrimaryPartCFrame(CFrame.new(vector31))
						break
					end
				end
			end
		end)
	end

	func15(result, v2)
end

Tab:Button({
	Title = "Teleport to Grow A Garden",
	Desc = "Teleport to Grow a gArden ahah",
	Callback = function()
		task.spawn(func16)
	end,
})

Tab:Button({
	Title = "Teleport to Prison Life",
	Callback = function()
		local Players = game:GetService("Players")
		local Workspace1 = game:GetService("Workspace")
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local vector3 = Vector3.new(0, 67379, 127)
		local vector31 = Vector3.new(0, 20, 0)

		local function func(player1, arg2)
			local v1 = tick()

			while tick() - v1 <= (arg2 or 10) do
				if player1.Character and player1.Character.Parent then
					return player1.Character
				end
				task.wait(0.05)
			end

			return player1.Character
		end

		local function func1(arg1)
			local tbl = {}
			local vector3 = Vector3.new()
			local num = 0

			for _, descendant in ipairs(arg1:GetDescendants()) do
				if descendant:IsA("BasePart") then
					num = num + 1
					vector3 = vector3 + descendant.Position
					tbl[#tbl + 1] = descendant
				end
			end

			return tbl, num > 0 and vector3 / num or nil
		end

		local function func2(arg1, arg2)
			local _, v1 = func1(arg1)
			local v2 = v1

			if not v2 then
				if typeof(arg1.GetPivot) == "function" then
					local ok, result = pcall(function()
						return arg1:GetPivot()
					end)
					if ok and result then
						v2 = result.Position
					end
				end
			end

			if v2 then
				pcall(function()
					arg2.CFrame = CFrame.new(v2 + vector31)
				end)
			end
		end

		local v1 = func(LocalPlayer, 10)

		if not v1 then
			return
		end

		local v2 = v1:FindFirstChild("HumanoidRootPart") or v1:FindFirstChild("Torso") or v1:FindFirstChild("UpperTorso")

		if not v2 then
			return
		end

		local __LOADED_MODEL_13820453861 = Workspace1:FindFirstChild("__LOADED_MODEL_13820453861")

		if __LOADED_MODEL_13820453861 then
			func2(__LOADED_MODEL_13820453861, v2)
			return
		end

		local ok, result = pcall(function()
			return game:GetObjects("rbxassetid://13820453861")[1]
		end)

		if not ok or not result then
			return
		end

		result.Name = "__LOADED_MODEL_13820453861"
		result.Parent = Workspace1
		local v3, v4 = func1(result)

		if v4 then
			local v5 = vector3 - v4
			local tbl = {}

			for _, v6 in ipairs(v3) do
				tbl[v6] = v6.Anchored
				v6.Anchored = true
				v6.CFrame = v6.CFrame + v5
			end

			for k, v7 in pairs(tbl) do
				if k and k.Parent then
					k.Anchored = v7
				end
			end
		else
			pcall(function()
				if typeof(result.PivotTo) == "function" then
					result:PivotTo(CFrame.new(vector3))
				elseif result.PrimaryPart then
					result:SetPrimaryPartCFrame(CFrame.new(vector3))
				else
					for _, descendant in ipairs(result:GetDescendants()) do
						if descendant:IsA("BasePart") then
							result.PrimaryPart = descendant
							result:SetPrimaryPartCFrame(CFrame.new(vector3))
							break
						end
					end
				end
			end)
		end

		func2(result, v2)
	end,
})

-- ================= Bring Stuff Tab =================
Tab = Window:Tab({Title = "Bring Stuff", Icon = "maximize-2", Locked = false})
local Players12 = game:GetService("Players")
RS = game:GetService("ReplicatedStorage")
WorkspaceItems = workspace:WaitForChild("Items")
TweenService = game:GetService("TweenService")
StartDrag = RS:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
StopDrag = RS:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
LP = Players12.LocalPlayer
HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(character1)
	HRP = character1:WaitForChild("HumanoidRootPart")
end)

TargetCFrame = "Myself"
BringSpeed = "Instant"
BringCount = 1
BringCooldown = 0.1

function GetTargetCFrame(name)
	if name == "Myself" then
		return HRP.CFrame
	end

	if name == "Fire" then
		return CFrame.new(0, 10, 0)
	end

	if name == "Workbench" then
		return CFrame.new(21, 14, -5)
	end

	local v1 = Players12:FindFirstChild(name)

	if v1 and v1.Character and v1.Character:FindFirstChild("HumanoidRootPart") then
		return v1.Character.HumanoidRootPart.CFrame
	end

	return HRP.CFrame
end

function BringItems(arg1)
	origCFrame = HRP.CFrame
	count = tonumber(BringCount) or 1
	cooldown = tonumber(BringCooldown) or 0.1

	for _, v1 in ipairs(arg1) do
		itemsBrought = 0
		for _, child in ipairs(WorkspaceItems:GetChildren()) do
			if itemsBrought >= count then
				break
			end
			if child.Name == v1 then
				part = child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart") or child:FindFirstChild("Handle")) or child
				if part then
					if child:IsA("Model") and not child.PrimaryPart then
						pcall(function()
							child.PrimaryPart = part
						end)
					end

					pcall(function()
						StartDrag:FireServer(child)
						targetCF = GetTargetCFrame(TargetCFrame)

						if BringSpeed == "Tween" then
							info = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
							TweenService:Create(HRP, info, {CFrame = part.CFrame + Vector3.new(0, 3, 0)}):Play()
							task.wait(0.2)
						end

						if child:IsA("Model") then
							child:SetPrimaryPartCFrame(targetCF)
						else
							part.CFrame = targetCF
						end

						if BringSpeed == "Tween" then
							HRP.CFrame = origCFrame
						end

						StopDrag:FireServer(child)
					end)

					itemsBrought = itemsBrought + 1
					task.wait(cooldown)
				end
			end
		end
	end
end

function GetPlayerList()
	list = {"Myself", "Fire", "Workbench"}

	for _, player1 in ipairs(Players12:GetPlayers()) do
		if player1 ~= LP then
			table.insert(list, player1.Name)
		end
	end

	return list
end

Tab:Dropdown({
	Title = "Select Target",
	Values = GetPlayerList(),
	Value = "Myself",
	Multi = false,
	Callback = function(value)
		TargetCFrame = value
	end,
})

Tab:Dropdown({
	Title = "Bring Speed",
	Values = {"Instant", "Tween"},
	Value = "Instant",
	Multi = false,
	Callback = function(value)
		BringSpeed = value
	end,
})

Tab:Input({
	Title = "Item Count",
	Value = "1",
	Callback = function(value)
		BringCount = tonumber(value) or 1
	end,
})

Tab:Input({
	Title = "Bring Cooldown",
	Value = "0.1",
	Callback = function(value)
		BringCooldown = tonumber(value) or 0.1
	end,
})

Tab:Section({
	Title = "Bring Fuel",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Dropdown({
	Title = "Select Fuel Items",
	Values = {
		"Sapling",
		"Log",
		"Chair",
		"Fuel Canister",
		"Oil Barrel",
		"Biofuel",
		"Cultist Corpse",
		"Crossbow Cultist Corpse",
		"Juggernaut Cultist Corpse",
		"Wolf Corpse",
		"Alpha Wolf Corpse",
		"Bear Corpse",
	},
	Value = {"Sapling"},
	Multi = true,
	Callback = function(value)
		FuelSelected = value
	end,
})

Tab:Button({
	Title = "Bring Fuel Items",
	Callback = function()
		BringItems(FuelSelected or {"Sapling"})
	end,
})

Tab:Button({
	Title = "Bring All Logs",
	Callback = function()
		BringItems({"Log"})
	end,
})

Tab:Section({
	Title = "Bring Scraps",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Dropdown({
	Title = "Select Scrap Items",
	Values = {
		"Bolt",
		"Sheet Metal",
		"Broken Fan",
		"Old Radio",
		"Metal Chair",
		"Old Microwave",
		"Tyre",
		"Old Car Engine",
		"Washing Machine",
		"Cultist Prototype",
		"Cultist Experiment",
		"Cultist Gem",
		"Forest Gem",
	},
	Value = {"Bolt"},
	Multi = true,
	Callback = function(value)
		ScrapsSelected = value
	end,
})

Tab:Button({
	Title = "Bring Scraps",
	Callback = function()
		BringItems(ScrapsSelected or {"Bolt"})
	end,
})

Tab:Section({
	Title = "Bring Food",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Dropdown({
	Title = "Select Food Items",
	Values = {
		"Carrot",
		"Berry",
		"Chili",
		"Bandage",
		"Medkit",
		"Morsel",
		"Steak",
		"Cooked Morsel",
		"Cooked Steak",
		"Morsel?",
		"Cake",
		"Stew",
		"Hearty Stew",
		"Ribs",
		"Cooked Ribs",
		"Carrot Cake",
		"BBQ Ribs",
	},
	Value = {"Carrot"},
	Multi = true,
	Callback = function(value)
		FoodSelected = value
	end,
})

Tab:Button({
	Title = "Bring Food",
	Callback = function()
		BringItems(FoodSelected or {"Carrot"})
	end,
})

Tab:Section({
	Title = "Bring Tools",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Dropdown({
	Title = "Select Tools",
	Values = {
		"Good Axe",
		"Strong Axe",
		"Good Sack",
		"Giant Sack",
		"Infernal Sack",
		"Old flashlight",
		"Strong Flashlight",
		"Ice Axe",
		"Chainsaw",
	},
	Value = {"Good Axe"},
	Multi = true,
	Callback = function(value)
		ToolsSelected = value
	end,
})

Tab:Button({
	Title = "Bring Tools",
	Callback = function()
		BringItems(ToolsSelected or {"Good Axe"})
	end,
})

Tab:Section({
	Title = "Bring Armor & Melee",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Dropdown({
	Title = "Select Armor/Melee",
	Values = {
		"Spear",
		"Katana",
		"Morningstar",
		"Blowpipe",
		"Laser Sword",
		"Ice Sword",
		"Poison Spear",
		"Infernal Sword",
		"Cultist King Mace",
		"Obsidiron Hammer",
		"Leather Body",
		"Iron Body",
		"Thorn Body",
		"Poison Armor",
		"Alien Armor",
		"Obsidiron Body",
		"Riot Shield",
	},
	Value = {"Spear"},
	Multi = true,
	Callback = function(value)
		ArmorSelected = value
	end,
})

Tab:Button({
	Title = "Bring Armor/Melee",
	Callback = function()
		BringItems(ArmorSelected or {"Spear"})
	end,
})

Tab:Section({
	Title = "Bring Ranged Weapons & Ammo",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Dropdown({
	Title = "Select Ranged Items",
	Values = {
		"Revolver",
		"Rifle",
		"Tactical Shotgun",
		"Revolver Ammo",
		"Rifle Ammo",
		"Shotgun Ammo",
		"Snowball",
		"Kunai",
		"Frozen Shuriken",
		"Wildfire",
		"Crossbow",
		"Infernal Crossbow",
		"Flamethrower",
		"Raygun",
		"Laser Cannon",
	},
	Value = {"Revolver"},
	Multi = true,
	Callback = function(value)
		RangedSelected = value
	end,
})

Tab:Button({
	Title = "Bring Ranged Items",
	Callback = function()
		BringItems(RangedSelected or {"Revolver"})
	end,
})

Tab:Section({
	Title = "Bring Other Items",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Dropdown({
	Title = "Select Other Items",
	Values = {
		"Seed Box",
		"Wolf Pelt",
		"Alpha Wolf Pelt",
		"Bear Pelt",
		"Artic Fox Pelt",
		"Polar Bear Pelt",
		"Mammoth Tusk",
		"Scorpion Shell",
		"Cultist King Antler",
		"FrogKey",
		"Hammer",
		"Paint Brush",
		"Forest Gem Fragment",
		"Mossy coin",
		"Coin Stack",
		"Sacrifice Totem",
		"Meteor Shard",
		"Gold Shard",
		"Obsidiron Ingot",
		"RedKey",
		"BlueKey",
		"YellowKey",
		"GreyKey",
		"Anvil Front",
		"Anvil Back",
		"Anvil Base",
	},
	Value = {"Seed Box"},
	Multi = true,
	Callback = function(value)
		OtherSelected = value
	end,
})

Tab:Button({
	Title = "Bring Other Items",
	Callback = function()
		BringItems(OtherSelected or {"Seed Box"})
	end,
})

-- ================= Hitbox/Aimbot Tab =================
Tab = Window:Tab({Title = "Hitbox/Aimbot", Icon = "expand", Locked = false})
Players12 = game:GetService("Players")
Workspace3 = game:GetService("Workspace")
local RunService2 = game:GetService("RunService")
HitboxStudSize = 30
HitboxEnabled = false
ShowHitboxes = false

Tab:Slider({
	Title = "Hitbox Size (Studs)",
	Value = {Min = 10, Max = 150, Default = 30},
	Step = 5,
	Callback = function(value)
		HitboxStudSize = value
	end,
})

Tab:Toggle({
	Title = "Enable Expanded Hitboxes",
	Default = false,
	Callback = function(value)
		HitboxEnabled = value
	end,
})

Tab:Toggle({
	Title = "Show Hitboxes",
	Default = false,
	Callback = function(value)
		ShowHitboxes = value
	end,
})

function CreateHitbox(parent)
	local part1 = Instance.new("Part")
	part1.Name = "HitboxPart"
	part1.Anchored = true
	part1.CanCollide = false
	part1.Material = Enum.Material.Neon
	part1.Color = Color3.fromRGB(255, 60, 60)
	part1.Size = Vector3.new(HitboxStudSize, HitboxStudSize, HitboxStudSize)
	part1.Transparency = ShowHitboxes and 0.4 or 1
	part1.Parent = parent
	return part1
end

RunService2.RenderStepped:Connect(function()
	if not Workspace3:FindFirstChild("Characters") then
		return
	end
	for _, child in ipairs(Workspace3.Characters:GetChildren()) do
		if child:IsA("Model") then
			local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")
			if HumanoidRootPart then
				local HitboxPart = child:FindFirstChild("HitboxPart")
				if HitboxEnabled then
					HitboxPart = HitboxPart or CreateHitbox(child)
					HitboxPart.Size = Vector3.new(HitboxStudSize, HitboxStudSize, HitboxStudSize)
					HitboxPart.Transparency = ShowHitboxes and 0.4 or 1
					HitboxPart.CFrame = HumanoidRootPart.CFrame
				elseif HitboxPart then
					HitboxPart:Destroy()
				end
			end
		end
	end
end)

Section = Tab:Section({
	Title = "Aimbot",
	Icon = "crosshair",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

local tab10 = Tab
local tbl29 = {Title = "Silent Aimbot Coming Soon"}
tbl29.Desc = nil
tbl29.Locked = false

function tbl29.Callback()
end

Button = tab10:Button(tbl29)

-- ================= Taming/Fishing Tab =================
Tab = Window:Tab({Title = "Taming/Fishing", Icon = "fish-symbol", Locked = false})
SuccessAreaTallEnabled = false

Tab:Toggle({
	Title = "100% Success Tame",
	Default = false,
	Callback = function(value)
		SuccessAreaTallEnabled = value
	end,
})

game:GetService("RunService").RenderStepped:Connect(function()
	if SuccessAreaTallEnabled then
		local LocalPlayer = game.Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local Interface = LocalPlayer.PlayerGui:FindFirstChild("Interface")

		if not Interface then
			return
		end

		local TamingFluteFrame = Interface:FindFirstChild("TamingFluteFrame")

		if not TamingFluteFrame or not TamingFluteFrame.Visible then
			return
		end

		local TimingBar = TamingFluteFrame:FindFirstChild("TimingBar")

		if not TimingBar then
			return
		end

		local SuccessArea = TimingBar:FindFirstChild("SuccessArea")

		if SuccessArea then
			local X = SuccessArea.Size.X
			SuccessArea.Size = UDim2.new(X.Scale, X.Offset, 0, 225)
		end
	end
end)

local tab11 = Tab
local tbl30 = {Title = "Bring Steak"}
tbl30.Desc = nil
tbl30.Locked = false

function tbl30.Callback()
	Players12 = game:GetService("Players")
	WorkspaceItems = workspace:WaitForChild("Items")
	RS = game:GetService("ReplicatedStorage")
	StartDrag = RS:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
	StopDrag = RS:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
	LocalPlayer11 = Players12.LocalPlayer
	HumanoidRootPart1 = LocalPlayer11.Character:WaitForChild("HumanoidRootPart")

	function BringItem(arg1)
		for _, child in ipairs(WorkspaceItems:GetChildren()) do
			if child.Name == arg1 then
				part = child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart") or child:FindFirstChild("Handle")) or child
				if part then
					if child:IsA("Model") and not child.PrimaryPart then
						pcall(function()
							child.PrimaryPart = part
						end)
					end

					pcall(function()
						StartDrag:FireServer(child)

						if child:IsA("Model") then
							child:SetPrimaryPartCFrame(HumanoidRootPart1.CFrame)
						else
							part.CFrame = HumanoidRootPart1.CFrame
						end

						StopDrag:FireServer(child)
					end)

					break
				end
			end
		end
	end

	BringItem("Steak")
end

tab11:Button(tbl30)
local tab12 = Tab
local tbl31 = {Title = "Bring Carrot"}
tbl31.Desc = nil
tbl31.Locked = false

function tbl31.Callback()
	Players12 = game:GetService("Players")
	WorkspaceItems = workspace:WaitForChild("Items")
	RS = game:GetService("ReplicatedStorage")
	StartDrag = RS:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
	StopDrag = RS:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
	LocalPlayer11 = Players12.LocalPlayer
	HumanoidRootPart1 = LocalPlayer11.Character:WaitForChild("HumanoidRootPart")

	function BringItem(arg1)
		for _, child in ipairs(WorkspaceItems:GetChildren()) do
			if child.Name == arg1 then
				part = child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart") or child:FindFirstChild("Handle")) or child
				if part then
					if child:IsA("Model") and not child.PrimaryPart then
						pcall(function()
							child.PrimaryPart = part
						end)
					end

					pcall(function()
						StartDrag:FireServer(child)

						if child:IsA("Model") then
							child:SetPrimaryPartCFrame(HumanoidRootPart1.CFrame)
						else
							part.CFrame = HumanoidRootPart1.CFrame
						end

						StopDrag:FireServer(child)
					end)

					break
				end
			end
		end
	end

	BringItem("Carrot")
end

tab12:Button(tbl31)
local tab13 = Tab
local tbl32 = {Title = "Teleport to Taming Tent"}
tbl32.Desc = nil

function tbl32.Callback()
	LocalPlayer11 = game.Players.LocalPlayer
	HumanoidRootPart1 = LocalPlayer11.Character and LocalPlayer11.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart1 then
		return
	end

	tamingTent = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Landmarks") and workspace.Map.Landmarks:FindFirstChild("Taming Tent")

	if tamingTent then
		part = tamingTent:FindFirstChildWhichIsA("BasePart")
		if part then
			HumanoidRootPart1.CFrame = part.CFrame + Vector3.new(0, 5, 0)
		else
			warn("Taming Tent has no parts to teleport to!")
		end
	else
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "SpamX Reminder",
			Text = "Taming Tent not found! Explore the map so it loads.",
			Duration = 5,
		})
	end
end

tab13:Button(tbl32)

Section = Tab:Section({
	Title = "Fishing",
	Icon = "fish",
	Box = true,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

Tab:Toggle({
	Title = "Auto Catch Minigame",
	Default = false,
	Callback = function(value)
		getgenv().autoCatchEnabled = value
		if value then
			getgenv().wasInZone = false
			getgenv().autoCatchConnection = game:GetService("RunService").Heartbeat:Connect(function()
				local ok, result = pcall(function()
					LocalPlayer11 = game.Players.LocalPlayer

					if not LocalPlayer11 then
						return
					end

					interface = LocalPlayer11.PlayerGui:FindFirstChild("Interface") or LocalPlayer11:FindFirstChild("Interface")

					if not interface then
						return
					end

					fishingFrame = interface:FindFirstChild("FishingCatchFrame")

					if not fishingFrame or not fishingFrame.Visible then
						getgenv().wasInZone = false
						return
					end

					timingBar = fishingFrame:FindFirstChild("TimingBar")

					if not timingBar then
						return
					end

					bar = timingBar:FindFirstChild("Bar")
					successArea = timingBar:FindFirstChild("SuccessArea")

					if not bar or not successArea then
						return
					end

					barPos = bar.AbsolutePosition
					barSize = bar.AbsoluteSize
					successPos = successArea.AbsolutePosition
					successSize = successArea.AbsoluteSize
					xOverlap = barPos.X < successPos.X + successSize.X and barPos.X + barSize.X > successPos.X
					yOverlap = barPos.Y < successPos.Y + successSize.Y and barPos.Y + barSize.Y > successPos.Y
					inZone = xOverlap and yOverlap

					if inZone and not getgenv().wasInZone then
						vim = game:GetService("VirtualInputManager")
						vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
						task.wait(0.03)
						vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
					end

					getgenv().wasInZone = inZone
				end)
				if not ok then
					warn("Auto Catch Error:", result)
				end
			end)
		else
			if getgenv().autoCatchConnection then
				getgenv().autoCatchConnection:Disconnect()
				getgenv().autoCatchConnection = nil
			end
			getgenv().wasInZone = false
		end
	end,
})

Tab:Toggle({
	Title = "100% Catch Chance",
	Default = false,
	Callback = function(value)
		getgenv().GreenBarHeightEnabled = value
		if value then
			getgenv().GreenBarConnection = game:GetService("RunService").RenderStepped:Connect(function()
				LocalPlayer11 = game.Players.LocalPlayer

				if not LocalPlayer11 then
					return
				end

				interface = LocalPlayer11.PlayerGui:FindFirstChild("Interface") or LocalPlayer11:FindFirstChild("Interface")

				if not interface then
					return
				end

				fishingFrame = interface:FindFirstChild("FishingCatchFrame")

				if not fishingFrame or not fishingFrame.Visible then
					return
				end

				timingBar = fishingFrame:FindFirstChild("TimingBar")

				if not timingBar then
					return
				end

				successArea = timingBar:FindFirstChild("SuccessArea")

				if successArea then
					width = successArea.Size.X
					successArea.Size = UDim2.new(width.Scale, width.Offset, 0, 80)
				end
			end)
		elseif getgenv().GreenBarConnection then
			getgenv().GreenBarConnection:Disconnect()
			getgenv().GreenBarConnection = nil
		end
	end,
})

ToggleCatchEnabled = false

Tab:Toggle({
	Title = "Instant Catch",
	Default = false,
	Callback = function(value)
		ToggleCatchEnabled = value
		if value then
			if not getgenv().CatchConnection then
				ReplicatedStorage11 = game:GetService("ReplicatedStorage")
				remoteEvents = ReplicatedStorage11:WaitForChild("RemoteEvents")
				startCatchTimer = remoteEvents:WaitForChild("StartCatchTimer")
				confirmCatchItem = remoteEvents:WaitForChild("ConfirmCatchItem")

				getgenv().CatchConnection = startCatchTimer.OnClientEvent:Connect(function()
					if ToggleCatchEnabled then
						confirmCatchItem:FireServer()
					end
				end)
			end
		elseif getgenv().CatchConnection then
			getgenv().CatchConnection:Disconnect()
			getgenv().CatchConnection = nil
		end
	end,
})

Tab:Button({
	Title = "Teleport to Fishing Hut",
	Desc = "Teleports you to the fishing hut where you get fishing rod ifykyk imo",
	Callback = function()
		local LocalPlayer = game.Players.LocalPlayer

		if not LocalPlayer or not LocalPlayer.Character then
			return
		end

		local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local v1 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Landmarks") and workspace.Map.Landmarks:FindFirstChild("Fishing Hut")

		if v1 then
			local BasePart = v1:FindFirstChildWhichIsA("BasePart")
			if BasePart then
				HumanoidRootPart.CFrame = BasePart.CFrame + Vector3.new(0, 5, 0)
			else
				warn("Fishing Hut has no parts to teleport to!")
			end
		else
			warn("Fishing Hut not found in workspace.Map.Landmarks!")
		end
	end,
})

-- ================= ESP Tab =================
Tab = Window:Tab({Title = "esp", Icon = "eye", Locked = false})
local flag11 = false
local v4 = Color3.fromRGB(255, 255, 0)
local tbl33 = {}
local tbl34 = {}
local tbl35 = {}
local tbl36 = {}
local tbl37 = {}
local tbl38 = {}
local tbl39 = {}

Tab:Toggle({
	Title = "ESP Enabled",
	Default = false,
	Callback = function(value)
		flag11 = value
	end,
})

Tab:Colorpicker({
	Title = "ESP Color",
	Default = Color3.fromRGB(255, 255, 0),
	Callback = function(value)
		v4 = value
	end,
})

Tab:Dropdown({
	Title = "Select Fuel",
	Values = {
		"Log",
		"Coal",
		"Chair",
		"Fuel Canister",
		"Oil Barrel",
		"Biofuel",
		"Wolf Corpse",
		"Alpha Wolf Corpse",
		"Bear Corpse",
		"Cultist Corpse",
		"Crossbow Cultist Corpse",
	},
	Multi = true,
	Callback = function(value)
		tbl33 = value
	end,
})

Tab:Dropdown({
	Title = "Select Scrap",
	Values = {
		"Bolt",
		"Sheet Metal",
		"Broken Fan",
		"Old Radio",
		"Broken Microwave",
		"Tyre",
		"Metal Chair",
		"Old Car Engine",
		"Washing Machine",
		"Cultist Experiment",
		"Cultist Prototype",
	},
	Multi = true,
	Callback = function(value)
		tbl34 = value
	end,
})

Tab:Dropdown({
	Title = "Select Food",
	Values = {
		"Carrot",
		"Berry",
		"Chili",
		"Bandage",
		"Medkit",
		"Morsel",
		"Steak",
		"Cooked Morsel",
		"Cooked Steak",
		"Morsel?",
		"Cake",
		"Stew",
		"Hearty Stew",
		"Ribs",
		"Cooked Ribs",
		"Carrot Cake",
		"BBQ Ribs",
	},
	Multi = true,
	Callback = function(value)
		tbl35 = value
	end,
})

Tab:Dropdown({
	Title = "Select Tools",
	Values = {
		"Good Axe",
		"Strong Axe",
		"Good Sack",
		"Giant Sack",
		"Infernal Sack",
		"Old flashlight",
		"Strong Flashlight",
		"Ice Axe",
		"Chainsaw",
	},
	Multi = true,
	Callback = function(value)
		tbl36 = value
	end,
})

Tab:Dropdown({
	Title = "Select Melee/Armor",
	Values = {
		"Spear",
		"Katana",
		"Morningstar",
		"Blowpipe",
		"Laser Sword",
		"Ice Sword",
		"Poison Spear",
		"Infernal Sword",
		"Cultist King Mace",
		"Obsidiron Hammer",
		"Leather Body",
		"Iron Body",
		"Thorn Body",
		"Poison Armor",
		"Alien Armor",
		"Obsidiron Body",
		"Riot Shield",
	},
	Multi = true,
	Callback = function(value)
		tbl37 = value
	end,
})

Tab:Dropdown({
	Title = "Select Ranged/Ammo",
	Values = {
		"Revolver",
		"Rifle",
		"Tactical Shotgun",
		"Revolver Ammo",
		"Rifle Ammo",
		"Shotgun Ammo",
		"Snowball",
		"Kunai",
		"Frozen Shuriken",
		"Wildfire",
		"Crossbow",
		"Infernal Crossbow",
		"Flamethrower",
		"Raygun",
		"Laser Cannon",
	},
	Multi = true,
	Callback = function(value)
		tbl38 = value
	end,
})

Tab:Dropdown({
	Title = "Select Others",
	Values = {
		"Seed Box",
		"Wolf Pelt",
		"Alpha Wolf Pelt",
		"Bear Pelt",
		"Artic Fox Pelt",
		"Polar Bear Pelt",
		"Mammoth Tusk",
		"Scorpion Shell",
		"Cultist King Antler",
		"FrogKey",
		"Hammer",
		"Paint Brush",
		"Forest Gem Fragment",
		"Mossy coin",
		"Coin Stack",
		"Sacrifice Totem",
		"Meteor Shard",
		"Gold Shard",
		"Obsidiron Ingot",
		"RedKey",
		"BlueKey",
		"YellowKey",
		"GreyKey",
		"Anvil Front",
		"Anvil Back",
		"Anvil Base",
	},
	Multi = true,
	Callback = function(value)
		tbl39 = value
	end,
})

task.spawn(function()
	while true do
		if flag11 then
			local Children = workspace:WaitForChild("Items"):GetChildren()
			local tbl = {}

			for _, v1 in ipairs(tbl33) do
				tbl[v1] = true
			end

			for _, v2 in ipairs(tbl34) do
				tbl[v2] = true
			end

			for _, v3 in ipairs(tbl35) do
				tbl[v3] = true
			end

			for _, v5 in ipairs(tbl36) do
				tbl[v5] = true
			end

			for _, v6 in ipairs(tbl37) do
				tbl[v6] = true
			end

			for _, v7 in ipairs(tbl38) do
				tbl[v7] = true
			end

			for _, v8 in ipairs(tbl39) do
				tbl[v8] = true
			end

			for _, v9 in ipairs(Children) do
				if tbl[v9.Name] then
					local v10 = v9:IsA("Model") and (v9.PrimaryPart or v9:FindFirstChildWhichIsA("BasePart") or v9:FindFirstChild("Handle")) or v9
					if v10 then
						local ESPLabel = v9:FindFirstChild("ESPLabel")

						if not ESPLabel then
							local billboardGui = Instance.new("BillboardGui")
							ESPLabel = billboardGui
							billboardGui.Name = "ESPLabel"
							billboardGui.Adornee = v10
							billboardGui.Size = UDim2.new(0, 100, 0, 40)
							billboardGui.StudsOffset = Vector3.new(0, 3, 0)
							billboardGui.AlwaysOnTop = true
							local textLabel = Instance.new("TextLabel", billboardGui)
							textLabel.Size = UDim2.new(1, 0, 1, 0)
							textLabel.BackgroundTransparency = 1
							textLabel.TextColor3 = v4
							textLabel.TextStrokeTransparency = 0
							textLabel.TextScaled = true
							textLabel.Text = v9.Name
							billboardGui.Parent = v9
						end

						local TextLabel = ESPLabel:FindFirstChildOfClass("TextLabel")

						if TextLabel then
							TextLabel.TextColor3 = v4
							local v11 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v10.Position
							TextLabel.Text = v9.Name .. "\n[" .. math.floor(v11.Magnitude) .. "m]"
						end
					end
				elseif v9:FindFirstChild("ESPLabel") then
					v9.ESPLabel:Destroy()
				end
			end
		end
		task.wait(0.1)
	end
end)

-- ================= Player Tab =================
Tab = Window:Tab({Title = "Player", Icon = "eye", Locked = false})
getgenv().WalkSpeedEnabled = false
getgenv().WalkSpeedValue = 70

Tab:Slider({
	Title = "WalkSpeed",
	Step = 1,
	Value = {Min = 15, Max = 500, Default = 70},
	Callback = function(value)
		getgenv().WalkSpeedValue = value
		if getgenv().WalkSpeedEnabled then
			local Character1 = game:GetService("Players").LocalPlayer.Character
			if Character1 then
				local Humanoid1 = Character1:FindFirstChildOfClass("Humanoid")
				if Humanoid1 then
					Humanoid1.WalkSpeed = value
				end
			end
		end
	end,
})

Tab:Toggle({
	Title = "Enable WalkSpeed",
	Icon = "gauge",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		getgenv().WalkSpeedEnabled = value
		local Character1 = game:GetService("Players").LocalPlayer.Character

		if not Character1 then
			return
		end

		local Humanoid1 = Character1:FindFirstChildOfClass("Humanoid")

		if not Humanoid1 then
			return
		end

		if value then
			Humanoid1.WalkSpeed = getgenv().WalkSpeedValue
		else
			Humanoid1.WalkSpeed = 16
		end
	end,
})

Section = Tab:Section({
	Title = "Jump-power",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

getgenv().JumpPowerEnabled = false
getgenv().JumpPowerValue = 50

Tab:Slider({
	Title = "JumP-Power",
	Step = 1,
	Value = {Min = 25, Max = 500, Default = 50},
	Callback = function(value)
		getgenv().JumpPowerValue = value
		if getgenv().JumpPowerEnabled then
			local Character1 = game:GetService("Players").LocalPlayer.Character
			if Character1 then
				local Humanoid1 = Character1:FindFirstChildOfClass("Humanoid")
				if Humanoid1 then
					Humanoid1.UseJumpPower = true
					Humanoid1.JumpPower = value
				end
			end
		end
	end,
})

Tab:Toggle({
	Title = "Enable JumP-Power",
	Icon = "chevron-up",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		getgenv().JumpPowerEnabled = value
		local Character1 = game:GetService("Players").LocalPlayer.Character

		if not Character1 then
			return
		end

		local Humanoid1 = Character1:FindFirstChildOfClass("Humanoid")

		if not Humanoid1 then
			return
		end

		if value then
			Humanoid1.UseJumpPower = true
			Humanoid1.JumpPower = getgenv().JumpPowerValue
		else
			Humanoid1.JumpPower = 50
		end
	end,
})

Section = Tab:Section({
	Title = "Fly",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

getgenv().FlyEnabled = false
getgenv().FlySpeed = 70
getgenv().FlyConnection = nil

function FlyLoop()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local Character1 = LocalPlayer.Character

	if not Character1 then
		return
	end

	local HumanoidRootPart = Character1:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	if not HumanoidRootPart:FindFirstChild("BodyGyro") then
		local bodyGyro = Instance.new("BodyGyro", HumanoidRootPart)
		bodyGyro.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
		bodyGyro.P = 90000
		bodyGyro.CFrame = HumanoidRootPart.CFrame
	end

	if not HumanoidRootPart:FindFirstChild("BodyVelocity") then
		Instance.new("BodyVelocity", HumanoidRootPart).MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
	end

	getgenv().FlyConnection = game:GetService("RunService").RenderStepped:Connect(function()
		if not getgenv().FlyEnabled then
			return
		end

		local MoveVector = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector()
		local CurrentCamera = workspace.CurrentCamera
		local v1 = Vector3.zero + CurrentCamera.CFrame.RightVector * (MoveVector.X * getgenv().FlySpeed) - CurrentCamera.CFrame.LookVector * (MoveVector.Z * getgenv().FlySpeed)
		HumanoidRootPart.BodyVelocity.Velocity = v1
		HumanoidRootPart.BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + CurrentCamera.CFrame.LookVector)
	end)
end

function StopFly()
	local Character1 = game:GetService("Players").LocalPlayer.Character

	if not Character1 then
		return
	end

	local HumanoidRootPart = Character1:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	if HumanoidRootPart:FindFirstChild("BodyGyro") then
		HumanoidRootPart.BodyGyro:Destroy()
	end

	if HumanoidRootPart:FindFirstChild("BodyVelocity") then
		HumanoidRootPart.BodyVelocity:Destroy()
	end

	if getgenv().FlyConnection then
		getgenv().FlyConnection:Disconnect()
		getgenv().FlyConnection = nil
	end
end

Tab:Slider({
	Title = "Fly Speed",
	Step = 1,
	Value = {Min = 15, Max = 500, Default = 70},
	Callback = function(value)
		getgenv().FlySpeed = value
	end,
})

Tab:Toggle({
	Title = "Enable Fly",
	Icon = "plane",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		getgenv().FlyEnabled = value
		if value then
			FlyLoop()
		else
			StopFly()
		end
	end,
})

Section = Tab:Section({
	Title = "Misc",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

getgenv().InfJumpEnabled = false
getgenv().InfJumpConnection = nil

Tab:Toggle({
	Title = "Infinite Jump",
	Icon = "rabbit",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		getgenv().InfJumpEnabled = value
		if value then
			if getgenv().InfJumpConnection then
				getgenv().InfJumpConnection:Disconnect()
			end
			getgenv().InfJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
				if getgenv().InfJumpEnabled then
					local Character1 = game:GetService("Players").LocalPlayer.Character
					if Character1 and Character1:FindFirstChildOfClass("Humanoid") then
						Character1:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)
		elseif getgenv().InfJumpConnection then
			getgenv().InfJumpConnection:Disconnect()
			getgenv().InfJumpConnection = nil
		end
	end,
})

NoclipToggle = Tab:Toggle({
	Title = "Noclip",
	Icon = "ghost",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		getgenv().NoclipEnabled = value
		local LocalPlayer = game.Players.LocalPlayer
		local v1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if not v1 then
			return
		end

		v1:WaitForChild("HumanoidRootPart")
		v1:WaitForChild("Humanoid")

		if value then
			getgenv().NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
				for _, descendant in ipairs(v1:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = false
					end
				end
			end)
		else
			if getgenv().NoclipConnection then
				getgenv().NoclipConnection:Disconnect()
				getgenv().NoclipConnection = nil
			end
			for _, descendant in ipairs(v1:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = true
				end
			end
		end
	end,
})

playerNames = {}

for _, player1 in ipairs(game.Players:GetPlayers()) do
	table.insert(playerNames, player1.Name)
end

selectedPlayer = playerNames[1]

Dropdown = Tab:Dropdown({
	Title = "Select Player",
	Values = playerNames,
	Value = selectedPlayer,
	Callback = function(value)
		selectedPlayer = value
	end,
})

Button = Tab:Button({
	Title = "Teleport to Player",
	Desc = "Teleport to the selected player",
	Locked = false,
	Callback = function()
		LocalPlayer11 = game.Players:FindFirstChild(selectedPlayer)
		LocalPlayer10 = game.Players.LocalPlayer
		HumanoidRootPart1 = LocalPlayer10.Character and LocalPlayer10.Character:FindFirstChild("HumanoidRootPart")

		if
			LocalPlayer11
			and LocalPlayer11.Character
			and LocalPlayer11.Character:FindFirstChild("HumanoidRootPart")
			and HumanoidRootPart1
		then
			HumanoidRootPart1.CFrame = LocalPlayer11.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
		else
			game.StarterGui:SetCore(
				"SendNotification",
				{Title = "Voidex Error", Text = "Player not found or character not loaded.", Duration = 5}
			)
		end
	end,
})

game.Players.PlayerAdded:Connect(function(player1)
	table.insert(playerNames, player1.Name)
	Dropdown:Refresh(playerNames)
end)

game.Players.PlayerRemoving:Connect(function(player1)
	for i, playerName in ipairs(playerNames) do
		if playerName == player1.Name then
			table.remove(playerNames, i)
			break
		end
	end
	Dropdown:Refresh(playerNames)
end)

Section = Tab:Section({
	Title = "Brightness",
	Box = false,
	FontWeight = Enum.FontWeight.SemiBold,
	TextTransparency = 0,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	TextSize = 17,
	Opened = true,
})

FullBrightEnabled = false

OriginalLighting = {
	Ambient = game.Lighting.Ambient,
	OutdoorAmbient = game.Lighting.OutdoorAmbient,
	Brightness = game.Lighting.Brightness,
	ClockTime = game.Lighting.ClockTime,
}

function applyFullBright()
	game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	game.Lighting.Brightness = 2
	game.Lighting.ClockTime = 14
end

game:GetService("RunService").RenderStepped:Connect(function()
	if FullBrightEnabled then
		applyFullBright()
	end
end)

FullBrightToggle = Tab:Toggle({
	Title = "Full Bright",
	Icon = "sun",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		FullBrightEnabled = value
		if not value then
			game.Lighting.Ambient = OriginalLighting.Ambient
			game.Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
			game.Lighting.Brightness = OriginalLighting.Brightness
			game.Lighting.ClockTime = OriginalLighting.ClockTime
		end
	end,
})

NightToDayEnabled = false
OriginalClockTime = game.Lighting.ClockTime

game:GetService("RunService").RenderStepped:Connect(function()
	if NightToDayEnabled then
		game.Lighting.ClockTime = 14
	end
end)

NightToDayToggle = Tab:Toggle({
	Title = "Turn Night Into Day",
	Icon = "moon",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		NightToDayEnabled = value
		if not value then
			game.Lighting.ClockTime = OriginalClockTime
		end
	end,
})

RemoveFogEnabled = false
local Lighting1 = game:GetService("Lighting")
OriginalFogStart = Lighting1.FogStart
OriginalFogEnd = Lighting1.FogEnd

game:GetService("RunService").RenderStepped:Connect(function()
	if RemoveFogEnabled then
		Lighting1.FogStart = 0
		Lighting1.FogEnd = 100000
	end
end)

RemoveFogToggle = Tab:Toggle({
	Title = "Remove Fog",
	Icon = "eye-off",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		RemoveFogEnabled = value
		if not value then
			Lighting1.FogStart = OriginalFogStart
			Lighting1.FogEnd = OriginalFogEnd
		end
	end,
})

BeautifulPurpleSkyEnabled = false
Lighting1 = game:GetService("Lighting")
OriginalSky = Lighting1:FindFirstChildOfClass("Sky")
OriginalAmbient = Lighting1.Ambient
OriginalOutdoorAmbient = Lighting1.OutdoorAmbient
OriginalClockTime = Lighting1.ClockTime
OriginalTimeOfDay = Lighting1.TimeOfDay
OriginalFogColor = Lighting1.FogColor
OriginalFogStart = Lighting1.FogStart
OriginalFogEnd = Lighting1.FogEnd
OriginalTechnology = Lighting1.Technology
OriginalShadowSoftness = Lighting1.ShadowSoftness
OriginalGlobalShadows = Lighting1.GlobalShadows
bloom = nil
cc = nil
sun = nil
dof = nil

Tab:Toggle({
	Title = "Beautiful Purple Sky",
	Icon = "sun",
	Type = "Toggle",
	Default = false,
	Callback = function(value)
		BeautifulPurpleSkyEnabled = value
		if value then
			if Lighting1:FindFirstChildOfClass("Sky") then
				Lighting1:FindFirstChildOfClass("Sky"):Destroy()
			end

			PurpleSky = Instance.new("Sky")
			PurpleSky.Name = "PurpleSky"
			PurpleSky.Parent = Lighting1
			Lighting1.Technology = Enum.Technology.Future
			Lighting1.ShadowSoftness = 0.5
			Lighting1.GlobalShadows = true
			Lighting1.Ambient = Color3.fromRGB(128, 0, 128)
			Lighting1.OutdoorAmbient = Color3.fromRGB(180, 0, 180)
			Lighting1.ClockTime = 14
			Lighting1.TimeOfDay = "14:00:00"
			Lighting1.FogColor = Color3.fromRGB(128, 0, 128)
			Lighting1.FogStart = 0
			Lighting1.FogEnd = 1000
			bloom = Instance.new("BloomEffect")
			bloom.Intensity = 2
			bloom.Size = 50
			bloom.Threshold = 0.5
			bloom.Parent = Lighting1
			cc = Instance.new("ColorCorrectionEffect")
			cc.TintColor = Color3.fromRGB(180, 0, 180)
			cc.Contrast = 0.2
			cc.Saturation = 0.3
			cc.Parent = Lighting1
			sun = Instance.new("SunRaysEffect")
			sun.Intensity = 0.3
			sun.Parent = Lighting1
			dof = Instance.new("DepthOfFieldEffect")
			dof.FocusDistance = 50
			dof.InFocusRadius = 20
			dof.Parent = Lighting1
		else
			if Lighting1:FindFirstChild("PurpleSky") then
				Lighting1.PurpleSky:Destroy()
			end

			if bloom then
				bloom:Destroy()
				bloom = nil
			end

			if cc then
				cc:Destroy()
				cc = nil
			end

			if sun then
				sun:Destroy()
				sun = nil
			end

			if dof then
				dof:Destroy()
				dof = nil
			end

			if OriginalSky then
				OriginalSky.Parent = Lighting1
			end

			Lighting1.Ambient = OriginalAmbient
			Lighting1.OutdoorAmbient = OriginalOutdoorAmbient
			Lighting1.ClockTime = OriginalClockTime
			Lighting1.TimeOfDay = OriginalTimeOfDay
			Lighting1.FogColor = OriginalFogColor
			Lighting1.FogStart = OriginalFogStart
			Lighting1.FogEnd = OriginalFogEnd
			Lighting1.Technology = OriginalTechnology
			Lighting1.ShadowSoftness = OriginalShadowSoftness
			Lighting1.GlobalShadows = OriginalGlobalShadows
		end
	end,
})