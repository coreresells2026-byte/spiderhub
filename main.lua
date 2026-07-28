-- =============================================================================
-- SPIDERHUB PREMIUM PRODUCTION INTERFACE V4.0 (GITHUB REPOSITORY SOURCE)
-- =============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player and (Player:FindFirstChild("PlayerGui") or game:GetService("CoreGui"))

if PlayerGui then
    -- Clean up any stuck interface nodes cleanly
    local oldUI = PlayerGui:FindFirstChild("SpiderAirWalkUI")
    if oldUI then oldUI:Destroy() end

    -- 1. Main Core ScreenGui Construction (Visible ONLY on your device display canvas)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpiderAirWalkUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    -- 2. Master Balanced Window Container Frame (Matches 580x420 HTML Matrix dimensions)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 580, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -290, 0.4, -210)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- Matches HTML background color code
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- Red Outer Border Stroke (Matches border: 2px solid #ff0000)
    local PanelBorder = Instance.new("UIStroke")
    PanelBorder.Thickness = 2
    PanelBorder.Color = Color3.fromRGB(255, 0, 0)
    PanelBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    PanelBorder.Parent = MainFrame

    -- Round the corners slightly (Matches border-radius: 6px)
    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 6)
    PanelCorner.Parent = MainFrame

    -- =============================================================================
    -- PREALIGNED PANEL HEADER REGISTRY (Houses Title Text + Giant logo.png slot)
    -- =============================================================================
    local PanelHeader = Instance.new("Frame")
    PanelHeader.Size = UDim2.new(1, 0, 0, 95) -- Exact 95px expanded HTML height parameters
    PanelHeader.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
    PanelHeader.BorderSizePixel = 0
    PanelHeader.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = PanelHeader

    local HeaderBottomLine = Instance.new("Frame")
    HeaderBottomLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderBottomLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderBottomLine.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    HeaderBottomLine.BorderSizePixel = 0
    HeaderBottomLine.Parent = PanelHeader

    -- Massive Spider Logo Image Placement Asset (logo.png container space)
    local LogoLabel = Instance.new("ImageLabel")
    LogoLabel.Size = UDim2.new(0, 120, 0, 75) -- Exact HTML box dimension bounds
    LogoLabel.Position = UDim2.new(0, 20, 0.5, -37)
    LogoLabel.BackgroundTransparency = 1
    LogoLabel.Image = "rbxassetid://135899933585094" -- Cloud uploaded red spider emblem asset path
    LogoLabel.ScaleType = Enum.ScaleType.Fit
    LogoLabel.Parent = PanelHeader

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -180, 1, 0)
    TitleText.Position = UDim2.new(0, 164, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.TextColor3 = Color3.fromRGB(255, 0, 0)
    TitleText.Text = "SPIDERHUB PREMIUM V4.0"
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.TextSize = 18 -- Matches HTML bold text font limits
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = PanelHeader

    -- =============================================================================
    -- SIDEBAR NAVIGATION RAIL GRID ARCHITECTURE
    -- =============================================================================
    local PanelBody = Instance.new("Frame")
    PanelBody.Size = UDim2.new(1, 0, 1, -95)
    PanelBody.Position = UDim2.new(0, 0, 0, 95)
    PanelBody.BackgroundTransparency = 1
    PanelBody.Parent = MainFrame

    local PanelSidebar = Instance.new("Frame")
    PanelSidebar.Size = UDim2.new(0, 130, 1, 0)
    PanelSidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 7) -- Matches HTML sidebar layout color
    PanelSidebar.BorderSizePixel = 0
    PanelSidebar.Parent = PanelBody

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = PanelSidebar

    local MovementTab = Instance.new("TextButton")
    MovementTab.Size = UDim2.new(1, -24, 0, 38)
    MovementTab.Position = UDim2.new(0, 12, 0, 12)
    MovementTab.BackgroundColor3 = Color3.fromRGB(128, 0, 0) -- Deep Active Red Gradient Accent
    MovementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    MovementTab.Text = "Movement"
    MovementTab.Font = Enum.Font.SourceSansBold
    MovementTab.TextSize = 13
    MovementTab.Parent = PanelSidebar

    local NetworkTab = MovementTab:Clone()
    NetworkTab.Position = UDim2.new(0, 12, 0, 56)
    NetworkTab.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
    NetworkTab.TextColor3 = Color3.fromRGB(160, 160, 165)
    NetworkTab.Text = "Network Loop"
    NetworkTab.Parent = PanelSidebar

    -- =============================================================================
    -- RIGHT CONTENT CONTAINER ARCHITECTURE PAGES
    -- =============================================================================
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -130, 1, 0)
    ContentFrame.Position = UDim2.new(0, 130, 0, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = PanelBody

    local MovementPage = Instance.new("ScrollingFrame")
    MovementPage.Size = UDim2.new(1, 0, 1, 0)
    MovementPage.BackgroundTransparency = 1
    MovementPage.ScrollBarThickness = 2
    MovementPage.CanvasSize = UDim2.new(0, 0, 0, 320)
    MovementPage.Parent = ContentFrame

    local NetworkPage = MovementPage:Clone()
    NetworkPage.Visible = false
    NetworkPage.Parent = ContentFrame

    -- Row Layout Generator Module
    local function CreateInGameControlRow(targetPage, labelText, buttonText, yPos, callback)
        local RowFrame = Instance.new("Frame")
        RowFrame.Size = UDim2.new(1, -32, 0, 42)
        RowFrame.Position = UDim2.new(0, 16, 0, yPos) -- padding: 16px
        RowFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 21) -- background-color: #111115
        RowFrame.BorderSizePixel = 0
        RowFrame.Parent = targetPage

        local RowBorder = Instance.new("UIStroke")
        RowBorder.Thickness = 1
        RowBorder.Color = Color3.fromRGB(24, 24, 32) -- border: 1px solid #181820
        RowBorder.Parent = RowFrame

        local RowCorner = Instance.new("UICorner")
        RowCorner.CornerRadius = UDim.new(0, 5) -- border-radius: 5px
        RowCorner.Parent = RowFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 200, 1, 0)
        Label.Position = UDim2.new(0, 14, 0, 0) -- padding-left: 14px
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(229, 225, 225) -- color: #e5e5e5
        Label.Text = labelText
        Label.Font = Enum.Font.SourceSansBold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = RowFrame

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 100, 0, 26) -- min-width: 100px
        Btn.Position = UDim2.new(1, -114, 0.5, -13)
        Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34) -- background-color: #1a1a22
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Text = buttonText
        Btn.Font = Enum.Font.SourceSansBold
        Btn.TextSize = 12
        Btn.Parent = RowFrame

        local BtnStroke = Instance.new("UIStroke")
        BtnStroke.Thickness = 1
        BtnStroke.Color = Color3.fromRGB(42, 42, 53) -- border: 1px solid #2a2a35
        BtnStroke.Parent = Btn

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4) -- border-radius: 4px
        BtnCorner.Parent = Btn

        Btn.MouseButton1Click:Connect(function() callback(Btn) end)
    end

    -- Tab Switching Logic Engine
    MovementTab.MouseButton1Click:Connect(function()
        MovementTab.BackgroundColor3 = Color3.fromRGB(128, 0, 0) MovementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        NetworkTab.BackgroundColor3 = Color3.fromRGB(16, 16, 19) NetworkTab.TextColor3 = Color3.fromRGB(160, 160, 165)
        MovementPage.Visible = true NetworkPage.Visible = false
    end)
    NetworkTab.MouseButton1Click:Connect(function()
        NetworkTab.BackgroundColor3 = Color3.fromRGB(128, 0, 0) NetworkTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        MovementTab.BackgroundColor3 = Color3.fromRGB(16, 16, 19) MovementTab.TextColor3 = Color3.fromRGB(160, 160, 165)
        NetworkPage.Visible = true MovementPage.Visible = false
    end)

    -- Tracking Variables for Game Physics Controls
    local noclipActive = false local noclipConnection = nil local flightConnection = nil local customHeightValue = 0
    local currentSpeedDialSetting = 16 local draggingSpeedSliderValue = false local infiniteJumpActive = false local jumpConnection = nil

    -- =============================================================================
    -- ATTACH FUNCTIONAL GAME LOGICS TO PRECISE ROWS
    -- =============================================================================
