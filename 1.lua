-- ============================================
-- iOS 液态玻璃 UI 模板（独立版，不依赖 WindUI）
-- 作者：KU HUB 风格参考
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ============ 毛玻璃背景模糊 ============
local glassBlur = Lighting:FindFirstChild("iOSGlassBlur") or Instance.new("BlurEffect")
glassBlur.Name = "iOSGlassBlur"
glassBlur.Size = 18
glassBlur.Parent = Lighting

-- ============ 主 ScreenGui ============
local gui = Instance.new("ScreenGui")
gui.Name = "iOSGlassUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = PlayerGui

-- ============ 悬浮开启按钮（胶囊） ============
local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenButton"
openBtn.Size = UDim2.new(0, 140, 0, 46)
openBtn.Position = UDim2.new(0, 24, 0, 24)
openBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
openBtn.BackgroundTransparency = 0.15
openBtn.Text = "打开 KU HUB"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamMedium
openBtn.TextSize = 15
openBtn.AutoButtonColor = false
openBtn.Parent = gui

-- 开启按钮圆角
local oc = Instance.new("UICorner")
oc.CornerRadius = UDim.new(0, 23)
oc.Parent = openBtn

-- 开启按钮描边（玻璃边缘）
local os = Instance.new("UIStroke")
os.Color = Color3.fromRGB(255, 255, 255)
os.Thickness = 1
os.Transparency = 0.7
os.Parent = openBtn

-- 开启按钮高光渐变
local og = Instance.new("UIGradient")
og.Rotation = 90
og.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
}
og.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.82),
	NumberSequenceKeypoint.new(1, 0.97),
}
og.Parent = openBtn

-- 开启按钮文字阴影
local ostroke = Instance.new("UIStroke")
ostroke.Color = Color3.fromRGB(0, 0, 0)
ostroke.Thickness = 1
ostroke.Transparency = 0.5
ostroke.Parent = openBtn

-- ============ 主窗口 ============
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 620, 0, 380)
main.Position = UDim2.new(0.5, -310, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
main.BackgroundTransparency = 0.18
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui

-- 主窗口圆角
local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 24)
mc.Parent = main

-- 主窗口描边
local ms = Instance.new("UIStroke")
ms.Color = Color3.fromRGB(255, 255, 255)
ms.Thickness = 1
ms.Transparency = 0.78
ms.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ms.Parent = main

-- 主窗口内部高光
local mg = Instance.new("UIGradient")
mg.Rotation = 90
mg.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
}
mg.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.9),
	NumberSequenceKeypoint.new(0.5, 0.95),
	NumberSequenceKeypoint.new(1, 0.98),
}
mg.Parent = main

-- 外发光（玻璃边缘反光）
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(255, 255, 255)
glow.Thickness = 2
glow.Transparency = 0.92
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Outside
glow.Parent = main

-- ============ 标题栏 ============
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundTransparency = 1
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 24, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KU HUB — iOS 玻璃"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -46, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.BackgroundTransparency = 0.35
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(1, 0)
cc.Parent = closeBtn

local cs = Instance.new("UIStroke")
cs.Color = Color3.fromRGB(255, 255, 255)
cs.Thickness = 1
cs.Transparency = 0.6
cs.Parent = closeBtn

-- ============ 侧边栏 ============
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 180, 1, -76)
sidebar.Position = UDim2.new(0, 16, 0, 60)
sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
sidebar.BackgroundTransparency = 0.35
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sc = Instance.new("UICorner")
sc.CornerRadius = UDim.new(0, 18)
sc.Parent = sidebar

local ss = Instance.new("UIStroke")
ss.Color = Color3.fromRGB(255, 255, 255)
ss.Thickness = 1
ss.Transparency = 0.82
ss.Parent = sidebar

local sLayout = Instance.new("UIListLayout")
sLayout.Padding = UDim.new(0, 6)
sLayout.SortOrder = Enum.SortOrder.LayoutOrder
sLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sLayout.Parent = sidebar

local sPad = Instance.new("UIPadding")
sPad.PaddingTop = UDim.new(0, 10)
sPad.PaddingLeft = UDim.new(0, 10)
sPad.PaddingRight = UDim.new(0, 10)
sPad.Parent = sidebar

-- ============ 内容区 ============
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -212, 1, -76)
content.Position = UDim2.new(0, 196, 0, 60)
content.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
content.BackgroundTransparency = 0.35
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.Parent = main

local ccc = Instance.new("UICorner")
ccc.CornerRadius = UDim.new(0, 18)
ccc.Parent = content

local ccs = Instance.new("UIStroke")
ccs.Color = Color3.fromRGB(255, 255, 255)
ccs.Thickness = 1
ccs.Transparency = 0.82
ccs.Parent = content

local cLayout = Instance.new("UIListLayout")
cLayout.Padding = UDim.new(0, 8)
cLayout.SortOrder = Enum.SortOrder.LayoutOrder
cLayout.Parent = content

local cPad = Instance.new("UIPadding")
cPad.PaddingTop = UDim.new(0, 12)
cPad.PaddingLeft = UDim.new(0, 14)
cPad.PaddingRight = UDim.new(0, 14)
cPad.Parent = content

-- ============ 工具函数：创建玻璃按钮 ============
local function createGlassButton(parent, text, layoutOrder)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
	btn.BackgroundTransparency = 0.25
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.LayoutOrder = layoutOrder or 0
	btn.Parent = parent

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 12)
	c.Parent = btn

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Thickness = 1
	s.Transparency = 0.8
	s.Parent = btn

	local g = Instance.new("UIGradient")
	g.Rotation = 90
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 140)),
	}
	g.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.85),
		NumberSequenceKeypoint.new(1, 0.96),
	}
	g.Parent = btn

	-- 按下反馈
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.25}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.25}):Play()
	end)

	return btn
end

-- ============ 工具函数：创建侧边栏标签按钮 ============
local function createSidebarTab(parent, text, layoutOrder, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
	btn.BackgroundTransparency = 0.45
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.LayoutOrder = layoutOrder or 0
	btn.Parent = parent

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 12)
	c.Parent = btn

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Thickness = 1
	s.Transparency = 0.85
	s.Parent = btn

	btn.MouseButton1Click:Connect(function()
		-- 取消其他选中
		for _, other in ipairs(parent:GetChildren()) do
			if other:IsA("TextButton") and other ~= btn then
				TweenService:Create(other, TweenInfo.new(0.15), {BackgroundTransparency = 0.45, BackgroundColor3 = Color3.fromRGB(36, 36, 44)}):Play()
			end
		end
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, BackgroundColor3 = Color3.fromRGB(60, 60, 72)}):Play()
		if callback then callback() end
	end)

	return btn
end

-- ============ 工具函数：切换内容页 ============
local pages = {}

local function switchPage(pageName)
	for name, page in pairs(pages) do
		page.Visible = (name == pageName)
	end
end

local function createPage(name)
	local page = Instance.new("Frame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	pages[name] = page
	return page
end

-- ============ 创建页面 ============
local pageMain = createPage("主功能")
local pageTeleport = createPage("传送")
local pagePlayer = createPage("玩家")
local pageMisc = createPage("杂项")

-- ============ 主功能页按钮 ============
createGlassButton(pageMain, "无敌模式", 1)
createGlassButton(pageMain, "自动砍树", 2)
createGlassButton(pageMain, "自动进食", 3)
createGlassButton(pageMain, "杀戮光环", 4)
createGlassButton(pageMain, "自动治疗", 5)
createGlassButton(pageMain, "自动采花", 6)
createGlassButton(pageMain, "自动收集金币", 7)

-- ============ 传送页按钮 ============
createGlassButton(pageTeleport, "传送到营地", 1)
createGlassButton(pageTeleport, "传送到商人", 2)
createGlassButton(pageTeleport, "传送到军事基地", 3)
createGlassButton(pageTeleport, "传送到要塞", 4)
createGlassButton(pageTeleport, "传送到国王宫殿", 5)

-- ============ 玩家页按钮 ============
createGlassButton(pagePlayer, "移动速度", 1)
createGlassButton(pagePlayer, "跳跃力", 2)
createGlassButton(pagePlayer, "飞行", 3)
createGlassButton(pagePlayer, "穿墙", 4)
createGlassButton(pagePlayer, "无限跳跃", 5)

-- ============ 杂项页按钮 ============
createGlassButton(pageMisc, "全亮", 1)
createGlassButton(pageMisc, "夜晚转白天", 2)
createGlassButton(pageMisc, "去除雾", 3)
createGlassButton(pageMisc, "梦幻紫天空", 4)

-- ============ 侧边栏标签 ============
createSidebarTab(sidebar, "主功能", 1, function() switchPage("主功能") end)
createSidebarTab(sidebar, "传送", 2, function() switchPage("传送") end)
createSidebarTab(sidebar, "玩家", 3, function() switchPage("玩家") end)
createSidebarTab(sidebar, "杂项", 4, function() switchPage("杂项") end)

-- 默认显示主功能
switchPage("主功能")

-- ============ 拖拽窗口 ============
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ============ 开关窗口 ============
local isOpen = false

local function openWindow()
	isOpen = true
	main.Visible = true
	main.Size = UDim2.new(0, 0, 0, 0)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 620, 0, 380),
		Position = UDim2.new(0.5, -310, 0.5, -190),
	}):Play()
end

local function closeWindow()
	isOpen = false
	local tween = TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Wait()
	main.Visible = false
end

openBtn.MouseButton1Click:Connect(function()
	if isOpen then closeWindow() else openWindow() end
end)

closeBtn.MouseButton1Click:Connect(function()
	closeWindow()
end)

-- ============ 鼠标悬停开启按钮（放大反馈） ============
openBtn.MouseEnter:Connect(function()
	TweenService:Create(openBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 148, 0, 50)}):Play()
end)

openBtn.MouseLeave:Connect(function()
	TweenService:Create(openBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 140, 0, 46)}):Play()
end)

-- ============ 通知函数（供你调用） ============
local function notify(text)
	local n = Instance.new("TextLabel")
	n.Size = UDim2.new(0, 260, 0, 48)
	n.Position = UDim2.new(0.5, -130, 0, -60)
	n.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	n.BackgroundTransparency = 0.2
	n.Text = text
	n.TextColor3 = Color3.fromRGB(255, 255, 255)
	n.Font = Enum.Font.GothamMedium
	n.TextSize = 14
	n.Parent = gui

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 16)
	c.Parent = n

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Thickness = 1
	s.Transparency = 0.75
	s.Parent = n

	TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -130, 0, 24),
	}):Play()

	task.wait(2)

	TweenService:Create(n, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, -130, 0, -60),
		BackgroundTransparency = 1,
		TextTransparency = 1,
	}):Play()

	task.wait(0.3)
	n:Destroy()
end

-- 示例：打开窗口时通知
openWindow()
notify("KU HUB 已加载")