-- =============================================================================
-- SPIDERHUB ADVANCED CATEGORIZED INTERFACE SUITE (GITHUB SOURCE)
-- =============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player and (Player:FindFirstChild("PlayerGui") or game:GetService("CoreGui"))

-- Safely clear out any old ui elements to prevent compilation stutters
if PlayerGui:FindFirstChild("SpiderAirWalkUI") then PlayerGui.SpiderAirWalkUI:Destroy() end

-- Initialize an advanced, lightweight fluid UI engine locally
local MaterialLib = {}
pcall(function()
    -- Directly generates an elegant dark-themed dashboard container natively
    function MaterialLib:LoadWindow(title)
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SpiderAirWalkUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = PlayerGui

        local Main = Instance.new("Frame")
        Main.Size = UDim2.new(0, 420, 0, 280)
        Main.Position = UDim2.new(0.5, -210, 0.3, -140)
        Main.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        Main.BorderSizePixel = 2
        Main.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Neon Red Theme Accent
        Main.Active = true
        Main.Draggable = true
        Main.Parent = ScreenGui

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -20, 0, 30)
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.BackgroundTransparency = 1
        Title.Text = title .. " | Press ALT to Toggle"
        Title.TextColor3 = Color3.fromRGB(255, 0, 0)
        Title.Font = Enum.Font.SourceSansBold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Main

        -- Category Sidebar Navigation Container
        local Sidebar = Instance.new("Frame")
        Sidebar.Size = UDim2.new(0, 110, 1, -40)
        Sidebar.Position = UDim2.new(0, 10, 0, 35)
        Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        Sidebar.BorderSizePixel = 0
        Sidebar.Parent = Main

        local SidebarLayout = Instance.new("UIListLayout")
        SidebarLayout.Padding = UDim.new(0, 4)
        SidebarLayout.Parent = Sidebar

        -- Dynamic Page Content Window
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Size = UDim2.new(1, -140, 1, -40)
        ContentFrame.Position = UDim2.new(0, 130, 0, 35)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Parent = Main

        local windowInstance = {Main = Main, Sidebar = Sidebar, Content = ContentFrame, CurrentPage = nil}

        function windowInstance:CreateCategory(name)
            local TabBtn = Instance.new("TextButton")
            TabBtn.Size = UDim2.new(1, 0, 0, 28)
            TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
            TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            TabBtn.Text = name
            TabBtn.Font = Enum.Font.SourceSansBold
            TabBtn.TextSize = 12
            TabBtn.Parent = Sidebar

            local Page = Instance.new("ScrollingFrame")
            Page.Size = UDim2.new(1, 0, 1, 0)
            Page.BackgroundTransparency = 1
            Page.CanvasSize = UDim2.new(0, 0, 0, 0)
            Page.ScrollBarThickness = 2
            Page.Visible = false
            Page.Parent = ContentFrame

            local PageLayout = Instance.new("UIListLayout")
            PageLayout.Padding = UDim.new(0, 6)
            PageLayout.Parent = Page

            if not windowInstance.CurrentPage then
                windowInstance.CurrentPage = Page
                Page.Visible = true
                TabBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            TabBtn.MouseButton1Click:Connect(function()
                if windowInstance.CurrentPage then windowInstance.CurrentPage.Visible = false end
                for _, btn in ipairs(Sidebar:GetChildren()) do
                    if btn:IsA("TextButton") then 
                        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 28) 
                        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
                TabBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Page.Visible = true
                windowInstance.CurrentPage = Page
            end)

            local pageInstance = {Frame = Page}

            function pageInstance:Button(text, callback)
                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, -10, 0, 32)
                Row.BackgroundTransparency = 1
                Row.Parent = Page

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.Text = text
                Btn.Font = Enum.Font.SourceSansBold
                Btn.TextSize = 13
                Btn.Parent = Row

                Btn.MouseButton1Click:Connect(function() callback(Btn) end)
                Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            end

            function pageInstance:Slider(text, min, max, default, callback)
                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, -10, 0, 45)
                Row.BackgroundTransparency = 1
                Row.Parent = Page

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 18)
                Label.BackgroundTransparency = 1
                Label.TextColor3 = Color3.fromRGB(180, 180, 180)
                Label.Text = text .. ": " .. tostring(default)
                Label.Font = Enum.Font.SourceSansBold
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                local SliderBg = Instance.new("Frame")
                SliderBg.Size = UDim2.new(1, 0, 0, 8)
                SliderBg.Position = UDim2.new(0, 0, 0, 24)
                SliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                SliderBg.BorderSizePixel = 0
                SliderBg.Parent = Row

                local SliderFill = Instance.new("Frame")
                local startRatio = math.clamp((default - min) / (max - min), 0, 1)
                SliderFill.Size = UDim2.new(startRatio, 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBg

                local Dragging = false
                local function UpdateSliderValue(input)
                    local ratio = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                    SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                    local finalValue = math.floor(min + (ratio * (max - min)))
                    Label.Text = text .. ": " .. tostring(finalValue)
                    callback(finalValue)
                end

                SliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSliderValue(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSliderValue(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)
                Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            end

            return pageInstance
        end

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
                Main.Visible = not Main.Visible
            end
        end)

        return windowInstance
    end
end)

-- =============================================================================
-- INTERFACE LAYER DESIGN ARCHITECTURE (Categories Setup)
-- =============================================================================
local HubWindow = MaterialLib:LoadWindow("SPIDERHUB ADAPTER INTERFACE")
local MovementTab = HubWindow:CreateCategory("Movement")
local NetworkTab = HubWindow:CreateCategory("Network Loop")

-- Functional State Registries
local noclipActive = false
local noclipConnection = nil
local flightConnection = nil
local customHeightValue = 0
local currentWalkSpeedSetting = 16

-- 1. CATEGORY: MOVEMENT CONTROLS
MovementTab:Button("NoClip: ACTIVATE", function(btn)
    noclipActive = not noclipActive
    if noclipActive then
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        btn.Text = "NoClip: ACTIVE"
        
        local character = Player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then customHeightValue = rootPart.Position.Y end
