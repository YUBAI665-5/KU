local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 清理旧界面
if playerGui:FindFirstChild("InTextUI") then playerGui.InTextUI:Destroy() end

-- 背景模糊 (液态玻璃)
local blur = Lighting:FindFirstChild("UIBlur") or Instance.new("BlurEffect")
blur.Name = "UIBlur"
blur.Size = 12
blur.Parent = Lighting

-- ==================== 配置 ====================
local Config = {
    WindowSize = UDim2.new(0, 650, 0, 420),
    Theme = {
        GlassBg = Color3.fromRGB(30, 30, 40),
        TopBar = Color3.fromRGB(20, 20, 25),
        GlassTransparency = 0.45,
        Accent = Color3.fromRGB(0, 255, 180),
        GlassBtn = Color3.fromRGB(255, 255, 255),
        GlassBtnTrans = 0.85
    }
}

-- ==================== 主窗口 ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InTextUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = Config.WindowSize
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Config.Theme.GlassBg
MainFrame.BackgroundTransparency = Config.Theme.GlassTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

-- 液态玻璃质感：白色高光边缘
local GlassStroke = Instance.new("UIStroke", MainFrame)
GlassStroke.Color = Color3.fromRGB(255, 255, 255)
GlassStroke.Thickness = 1.5
GlassStroke.Transparency = 0.3
GlassStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ==================== 彩色跑马灯边框 ====================
local MarqueeStroke = Instance.new("UIStroke", MainFrame)
MarqueeStroke.Color = Color3.fromRGB(255, 255, 255)
MarqueeStroke.Thickness = 3
MarqueeStroke.Transparency = 0.2
MarqueeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MarqueeGradient = Instance.new("UIGradient", MarqueeStroke)
MarqueeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 128)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 200, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 128))
})
MarqueeGradient.Rotation = 0

-- 动画：持续旋转渐变，形成跑马灯效果
RunService.RenderStepped:Connect(function(dt)
    MarqueeGradient.Rotation = (MarqueeGradient.Rotation + (dt * 90)) % 360
end)

-- ==================== 顶部栏 (无文字) ====================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Config.Theme.TopBar
TopBar.BackgroundTransparency = 0.4
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 14)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 20)
TopFix.Position = UDim2.new(0, 0, 1, -20)
TopFix.BackgroundColor3 = Config.Theme.TopBar
TopFix.BackgroundTransparency = 0.4
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- 关闭按钮 (保留图标，但不写文字)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BackgroundTransparency = 0.7
CloseBtn.Text = "✕" -- 纯符号，不算文字内容
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
    blur:Destroy()
end)

-- ==================== 拖拽 ====================
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
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== 左侧导航栏 (无文字，纯色块) ====================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Sidebar.BackgroundTransparency = 0.93
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 8)
SidebarList.Parent = Sidebar
local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 12)
SidebarPad.PaddingLeft = UDim.new(0, 10)
SidebarPad.PaddingRight = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

-- ==================== 右侧内容区 ====================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -140, 1, -45)
ContentArea.Position = UDim2.new(0, 140, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingTop = UDim.new(0, 12)
ContentPad.PaddingLeft = UDim.new(0, 12)
ContentPad.PaddingRight = UDim.new(0, 12)
ContentPad.Parent = ContentArea

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 145, 0, 40)
GridLayout.CellPadding = UDim.new(0, 8, 0, 8)
GridLayout.Parent = ContentArea

-- ==================== 页面数据 (仅为数量占位，界面上不显示) ====================
local Pages = {
    ["Tab1"] = {1, 2, 3, 4, 5, 6, 7, 8},
    ["Tab2"] = {1, 2, 3, 4, 5, 6, 7},
    ["Tab3"] = {1, 2, 3, 4, 5, 6, 7},
    ["Tab4"] = {1, 2, 3, 4, 5, 6}
}

-- ==================== 标签与开关逻辑 ====================
local TabButtons = {}
local ToggleStates = {}
local CurrentTab = nil
local ContentObjects = {}

local function SwitchTab(tabName)
    if CurrentTab == tabName then return end
    CurrentTab = tabName

    -- 更新左侧按钮外观 (无文字)
    for name, btn in pairs(TabButtons) do
        local isActive = (name == tabName)
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = isActive and 0.85 or 1,
        }):Play()
    end

    for _, obj in ipairs(ContentObjects) do obj:Destroy() end
    ContentObjects = {}

    local functions = Pages[tabName]
    if not functions then return end
    for i, funcName in ipairs(functions) do
        -- 玻璃按钮 (无文字，纯色块)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.88
        btn.Text = "" -- 清空文字
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = ContentArea

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(255, 255, 255)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.6
        
        -- 状态指示灯
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(1, -16, 0.5, -4)
        dot.BackgroundColor3 = ToggleStates[funcName] and Config.Theme.Accent or Color3.fromRGB(120, 120, 120)
        dot.BorderSizePixel = 0
        dot.Parent = btn
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        -- 悬停与点击
        btn.MouseEnter:Connect(function()
            if not ToggleStates[funcName] then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.75}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not ToggleStates[funcName] then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.88}):Play()
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            local newState = not ToggleStates[funcName]
            ToggleStates[funcName] = newState

            TweenService:Create(dot, TweenInfo.new(0.2), {
                BackgroundColor3 = newState and Config.Theme.Accent or Color3.fromRGB(120, 120, 120)
            }):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = newState and 0.7 or 0.88
            }):Play()
            -- 不再 print 文字，保持无文字输出
        end)

        table.insert(ContentObjects, btn)
    end
end

-- 创建左侧标签 (无文字，纯色块)
for tabName, _ in pairs(Pages) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = "" -- 清空文字
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = Sidebar

    Instance.new("UICorner", tabBtn).Co