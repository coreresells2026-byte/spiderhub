local AdminUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

function AdminUI.CreateMenu()
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    
    if PlayerGui:FindFirstChild("SpiderHubUI") then
        PlayerGui.SpiderHubUI:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpiderHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -140, 1, -20)
    PageContainer.Position = UDim2.new(0, 140, 0, 10)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    -- PAGE 1: DIAGNOSTICS
    local DiagnosticsPage = Instance.new("Frame")
    DiagnosticsPage.Name = "Diagnostics"
    DiagnosticsPage.Size = UDim2.new(1, 0, 1, 0)
    DiagnosticsPage.BackgroundTransparency = 1
    DiagnosticsPage.Visible = true
    DiagnosticsPage.Parent = PageContainer
    
    local DiagLayout = Instance.new("UIListLayout")
    DiagLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DiagLayout.Padding = UDim.new(0, 10)
    DiagLayout.Parent = DiagnosticsPage
    
    -- PAGE 2: CAMERA/SETTINGS
    local SettingsPage = Instance.new("Frame")
    SettingsPage.Name = "Visual Settings"
    SettingsPage.Size = UDim2.new(1, 0, 1, 0)
    SettingsPage.BackgroundTransparency = 1
    SettingsPage.Visible = false
    SettingsPage.Parent = PageContainer
    
    local SettingsLayout = Instance.new("UIListLayout")
    SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsLayout.Padding = UDim.new(0, 10)
    SettingsLayout.Parent = SettingsPage
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = Sidebar
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.Parent = Sidebar
    
    local function CreateTab(name, targetPage)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = TabBtn
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, page in ipairs(PageContainer:GetChildren()) do
                if page:IsA("Frame") then page.Visible = false end
            end
            targetPage.Visible = true
        end)
    end
    
    CreateTab("Diagnostics", DiagnosticsPage)
    CreateTab("Visual Settings", SettingsPage)
    
    -- Telemetry Trackers (Diagnostics Page)
    local FpsLabel = Instance.new("TextLabel")
    FpsLabel.Size = UDim2.new(1, 0, 0, 30)
    FpsLabel.BackgroundTransparency = 1
    FpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FpsLabel.Text = "FPS: Calculating..."
    FpsLabel.Font = Enum.Font.SourceSans
    FpsLabel.TextSize = 16
    FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    FpsLabel.Parent = DiagnosticsPage
    
    local PingLabel = FpsLabel:Clone()
    PingLabel.Text = "Ping: Calculating..."
    PingLabel.Parent = DiagnosticsPage
    
    -- Track FPS and Network Ping Safely via Performance Engine
    local lastTime = os.clock()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        if currentTime - lastTime >= 1 then
            FpsLabel.Text = "FPS: " .. tostring(frameCount)
            frameCount = 0
            lastTime = currentTime
            
            -- Grab standard network round-trip ping latency
            local networkPing = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            PingLabel.Text = "Network Ping: " .. tostring(networkPing) .. " ms"
        end
    end)
    
    -- Client-Side FOV Setting Adjustment (Settings Page)
    local FovLabel = Instance.new("TextLabel")
    FovLabel.Size = UDim2.new(1, 0, 0, 20)
    FovLabel.BackgroundTransparency = 1
    FovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FovLabel.Text = "Field of View: 70"
    FovLabel.Font = Enum.Font.SourceSans
    FovLabel.TextSize = 16
    FovLabel.TextXAlignment = Enum.TextXAlignment.Left
    FovLabel.Parent = SettingsPage
    
    local FovButton = Instance.new("TextButton")
    FovButton.Size = UDim2.new(1, 0, 0, 35)
    FovButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    FovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FovButton.Text = "Increase FOV (+5)"
    FovButton.Font = Enum.Font.SourceSansBold
    FovButton.TextSize = 14
    FovButton.Parent = SettingsPage
    
    local FovCorner = Instance.new("UICorner")
    FovCorner.CornerRadius = UDim.new(0, 4)
    FovCorner.Parent = FovButton
    
    FovButton.MouseButton1Click:Connect(function()
        local camera = Workspace.CurrentCamera
        if camera then
            local currentFov = camera.FieldOfView
            local newFov = currentFov + 5
            if newFov > 120 then newFov = 70 end -- Reset loop boundary
            camera.FieldOfView = newFov
            FovLabel.Text = "Field of View: " .. tostring(newFov)
        end
    end)
    
    -- Visibility Tweens
    local menuVisible = true
    local animating = false
    
    local function toggleMenu()
        if animating then return end
        animating = true
        if menuVisible then
            local hide = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 0), BackgroundTransparency = 1})
            hide:Play()
            hide.Completed:Connect(function() MainFrame.Visible = false menuVisible = false animating = false end)
        else
            MainFrame.Size = UDim2.new(0, 450, 0, 0)
            MainFrame.BackgroundTransparency = 0
            MainFrame.Visible = true
            local show = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 300)})
            show:Play()
            show.Completed:Connect(function() menuVisible = true animating = false end)
        end
    end
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            toggleMenu()
        end
    end)
    
    local TouchButton = Instance.new("TextButton")
    TouchButton.Name = "ToggleButton"
    TouchButton.Size = UDim2.new(0, 50, 0, 50)
    TouchButton.Position = UDim2.new(0, 10, 0.5, -25)
    TouchButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    TouchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TouchButton.Text = "Spider"
    TouchButton.Font = Enum.Font.SourceSansBold
    TouchButton.TextSize = 14
    TouchButton.Active = true
    TouchButton.Draggable = true
    TouchButton.Parent = ScreenGui
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = TouchButton
    
    TouchButton.MouseButton1Click:Connect(toggleMenu)
end

return AdminUI
