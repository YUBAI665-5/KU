local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("InTextUI") then
    playerGui.InTextUI:Destroy()
end

local Config = {
    WindowSize = UDim2.new(0, 650, 0, 420),
    Theme = {
        Background = Color3.fromRGB(25, 25, 30),
        TopBar = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(22, 22, 27),
        Content = Color3.fromRGB(30, 30, 36),
        ButtonNormal = Color3.fromRGB(45, 45, 55),
        ButtonHover = Color3.fromRGB(60, 60, 72),
        Accent = Color3.fromRGB(0, 255, 160), -- 亮绿色
        Text = Color3.fromRGB(220, 220, 220),
        TextDim = Color3.fromRGB(140, 140, 150),
        Off = Color3.fromRGB(90, 90, 100)
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InTextUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = Config.WindowSize
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Config.Theme.Background
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Config.Theme.TopBar
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame") -- 覆盖底部圆角
TopFix.Size = UDim2.new(1, 0, 0, 15)
TopFix.Position = UDim2.new(0, 0, 1, -15)
TopFix.BackgroundColor3 = Config.Theme.TopBar
TopFix.BackgroundTransparency = 0.2
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "InText - 功能列表"
TitleLabel.TextColor3 = Config.Theme.Text
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 15
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Config.Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    wait(0.2)
    ScreenGui:Destroy()
end)

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Config.Theme.Sidebar
Sidebar.BackgroundTransparency = 0.15
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -140, 1, -40)
ContentArea.Position = UDim2.new(0, 140, 0, 40)
ContentArea.BackgroundColor3 = Config.Theme.Content
ContentArea.BackgroundTransparency = 0.3
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 12)
ContentPadding.PaddingLeft = UDim.new(0, 12)
ContentPadding.PaddingRight = UDim.new(0, 12)
ContentPadding.PaddingBottom = UDim.new(0, 12)
ContentPadding.Parent = ContentArea

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 145, 0, 38)
GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.Parent = ContentArea

local Pages = {
    ["战斗"] = {"暴力杀戮", "自动瞄准", "穿墙", "无限跳跃", "无冷却", "子弹追踪", "快速射击", "锁血"},
    ["移动"] = {"飞行", "加速", "超级跳", "瞬移", "自动奔跑", "无限耐力", "水上行走"},
    ["视觉"] = {"ESP 透视", "显示血量", "显示名字", "夜视", "去雾", "全图发光", "距离显示"},
    ["杂项"] = {"自动拾取", "无限金钱", "解锁全部", "服务器跳转", "反挂机", "自动重生"}
}

local TabButtons = {}
local ToggleStates = {} -- 存储开关状态
local CurrentTab = nil
local ContentObjects = {}

local function SwitchTab(tabName)
    if CurrentTab == tabName then return end
    CurrentTab = tabName

    
    for name, btn in pairs(TabButtons) do
        local isActive = (name == tabName)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = isActive and Config.Theme.ButtonHover or Config.Theme.ButtonNormal,
            BackgroundTransparency = isActive and 0.3 or 0.5
        }):Play()
        btn.TextColor3 = isActive and Config.Theme.Accent or Config.Theme.TextDim
    end

    -- 清空内容区
    for _, obj in ipairs(ContentObjects) do obj:Destroy() end
    ContentObjects = {}

    -- 生成新内容
    local functions = Pages[tabName]
    if not functions then return end
    for i, funcName in ipairs(functions) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 0, 0) -- 由 GridLayout 控制
        btn.BackgroundColor3 = Config.Theme.ButtonNormal
        btn.Text = "   " .. funcName
        btn.TextColor3 = Config.Theme.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = ContentArea

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        -- 状态指示灯
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(1, -16, 0.5, -4)
        dot.BackgroundColor3 = ToggleStates[funcName] and Config.Theme.Accent or Config.Theme.Off
        dot.BorderSizePixel = 0
        dot.Parent = btn
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        -- 悬停效果
        btn.MouseEnter:Connect(function()
            if not ToggleStates[funcName] then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Config.Theme.ButtonHover}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not ToggleStates[funcName] then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Config.Theme.ButtonNormal}):Play()
            end
        end)

        -- 点击开关
        btn.MouseButton1Click:Connect(function()
            local newState = not ToggleStates[funcName]
            ToggleStates[funcName] = newState

            TweenService:Create(dot, TweenInfo.new(0.2), {
                BackgroundColor3 = newState and Config.Theme.Accent or Config.Theme.Off
            }):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = newState and Color3.fromRGB(30, 50, 40) or Config.Theme.ButtonNormal,
                TextColor3 = newState and Config.Theme.Accent or Config.Theme.Text
            }):Play()

            print(("功能 [%s] 状态: %s"):format(funcName, tostring(newState)))
        end)

        table.insert(ContentObjects, btn)
    end
end

-- 创建左侧标签
for tabName, _ in pairs(Pages) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 34)
    tabBtn.BackgroundColor3 = Config.Theme.ButtonNormal
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Config.Theme.TextDim
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabBtn

    TabButtons[tabName] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)
end

-- 默认选中第一个标签
local firstTab = nil
for name, _ in pairs(Pages) do firstTab = name; break end
if firstTab then SwitchTab(firstTab) end