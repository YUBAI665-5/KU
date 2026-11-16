local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("InTextUI") then playerGui.InTextUI:Destroy() end

local blur = Lighting:FindFirstChild("UIBlur") or Instance.new("BlurEffect")
blur.Name = "UIBlur"
blur.Size = 12
blur.Parent = Lighting

local Config = {
    WindowSize = UDim2.new(0, 650, 0, 420),
    BallSize = UDim2.new(0, 60, 0, 60), 
    
    Theme = {
        GlassBg = Color3.fromRGB(30, 30, 40),
        TopBar = Color3.fromRGB(20, 20, 25),
        GlassTransparency = 0.45,
        Accent = Color3.fromRGB(0, 255, 180),
        Text = Color3.fromRGB(240, 240, 240),
        TextDim = Color3.fromRGB(160, 160, 170),
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
MainFrame.BackgroundColor3 = Config.Theme.GlassBg
MainFrame.BackgroundTransparency = Config.Theme.GlassTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local GlassStroke = Instance.new("UIStroke", MainFrame)
GlassStroke.Color = Color3.fromRGB(255, 255, 255)
GlassStroke.Thickness = 1.5
GlassStroke.Transparency = 0.3
GlassStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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

local spinConnection
local function startMarquee()
    if spinConnection then return end
    spinConnection = RunService.RenderStepped:Connect(function(dt)
        MarqueeGradient.Rotation = (MarqueeGradient.Rotation + (dt * 90)) % 360
    end)
end
startMarquee()

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

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "InText - Liquid Glass"
TitleLabel.TextColor3 = Config.Theme.Text
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 15
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BackgroundTransparency = 0.7
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Config.Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

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

local Pages = {
    ["测试"] = {"测试", "测试", "测试", "测试", "测试", "测试", "测试", "狗屎ui"},
    ["测试"] = {"飞行", "加速", "超级跳", "瞬移", "自动奔跑", "无限耐力", "水上行走"},
    ["测试"] = {"ESP 透视", "显示血量", "显示名字", "夜视", "去雾", "全图发光", "距离显示"},
    ["测试"] = {"自动拾取", "无限金钱", "解锁全部", "服务器跳转", "反挂机", "自动重生"}
}

local TabButtons = {}
local ToggleStates = {}
local CurrentTab = nil
local ContentObjects = {}

local function SwitchTab(tabName)
    if CurrentTab == tabName then return end
    CurrentTab = tabName

    for name, btn in pairs(TabButtons) do
        local isActive = (name == tabName)
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = isActive and 0.85 or 1,
            TextColor3 = isActive and Color3.fromRGB(0, 0, 0) or Config.Theme.TextDim
        }):Play()
    end

    for _, obj in ipairs(ContentObjects) do obj:Destroy() end
    ContentObjects = {}

    local functions = Pages[tabName]
    if not functions then return end
    for i, funcName in ipairs(functions) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.88
        btn.Text = "   " .. funcName
        btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = ContentArea

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(255, 255, 255)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.6
        
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(1, -16, 0.5, -4)
        dot.BackgroundColor3 = ToggleStates[funcName] and Config.Theme.Accent or Color3.fromRGB(120, 120, 120)
        dot.BorderSizePixel = 0
        dot.Parent = btn
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

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
            print(("功能 [%s] 状态: %s"):format(funcName, tostring(newState)))
        end)

        table.insert(ContentObjects, btn)
    end
end

for tabName, _ in pairs(Pages) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Config.Theme.TextDim
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = Sidebar

    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)
    TabButtons[tabName] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)
end

local firstTab = nil
for name, _ in pairs(Pages) do firstTab = name; break end
if firstTab then SwitchTab(firstTab) end

local isMinimized = false
local rotationConnection = nil
local ballDragging = false
local ballDragStart = nil
local ballStartPos = nil

local function setupDragging(dragTarget, moveTarget)
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            
            if isMinimized and rotationConnection then
                rotationConnection:Disconnect()
                rotationConnection = nil
                moveTarget.Rotation = 0
            end
            ballDragging = true
            ballDragStart = input.Position
            ballStartPos = moveTarget.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    ballDragging = false
                    
                    if isMinimized and not rotationConnection then
                        rotationConnection = RunService.RenderStepped:Connect(function(dt)
                            moveTarget.Rotation = (moveTarget.Rotation + (dt * 90)) % 360
                        end)
                    end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if ballDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - ballDragStart
            moveTarget.Position = UDim2.new(ballStartPos.X.Scale, ballStartPos.X.Offset + delta.X, ballStartPos.Y.Scale, ballStartPos.Y.Offset + delta.Y)
        end
    end)
end


setupDragging(TopBar, MainFrame)

setupDragging(MainFrame, MainFrame)

local function MinimizeToBall()
    isMinimized = true
    
    TopBar.Visible = false
    Sidebar.Visible = false
    ContentArea.Visible = false

    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = Config.BallSize,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0.5, -30, 0.5, -30)
    }):Play()
    TweenService:Create(MainCorner, TweenInfo.new(0.4), { CornerRadius = UDim.new(1, 0) }):Play()
    
    task.delay(0.4, function()
        if isMinimized and not rotationConnection then
            rotationConnection = RunService.RenderStepped:Connect(function(dt)
                MainFrame.Rotation = (MainFrame.Rotation + (dt * 90)) % 360
            end)
        end
    end)
end

local function RestoreFromBall()
    isMinimized = false

    if rotationConnection then
        rotationConnection:Disconnect()
        rotationConnection = nil
    end
    MainFrame.Rotation = 0

    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = Config.WindowSize,
        BackgroundTransparency = Config.Theme.GlassTransparency,
        Position = UDim2.new(0.5, -325, 0.5, -210)
    }):Play()
    TweenService:Create(MainCorner, TweenInfo.new(0.4), { CornerRadius = UDim.new(0, 14) }):Play()

    task.delay(0.4, function()
        if not isMinimized then
            TopBar.Visible = true
            Sidebar.Visible = true
            ContentArea.Visible = true
        end
    end)
end

CloseBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        RestoreFromBall()
    else
        MinimizeToBall()
    end
end)

MainFrame.InputBegan:Connect(function(input)
    if isMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        
        local startTime = tick()
        task.wait(0.1)
        if tick() - startTime < 0.15 and not ballDragging then
            RestoreFromBall()
        end
    end
end)