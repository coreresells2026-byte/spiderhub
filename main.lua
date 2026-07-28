-- =============================================================================
-- SPIDERHUB PREMIUM PRODUCTION LAYOUT V4.0 (FIXED REPOSITORY FILE)
-- =============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player and (Player:FindFirstChild("PlayerGui") or game:GetService("CoreGui"))

if PlayerGui then
    -- Clean up any stuck interface nodes cleanly using your exact path
    local oldUI = PlayerGui:FindFirstChild("SpiderAirWalkUI")
    if oldUI then oldUI:Destroy() end

    -- 1. Main Core ScreenGui Construction
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpiderAirWalkUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- 2. Your Working Top Center Status Banner Box
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 320, 0, 95)
    MainFrame.Position = UDim2.new(0.5, -160, 0, 15)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 35)
    StatusLabel.Position = UDim2.new(0, 10, 0, 5)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    StatusLabel.Text = "SpiderHub Console: Ready.\nN = NoClip | J = InfJump | L = Speed Dial | F = LagFix"
    StatusLabel.Font = Enum.Font.SourceSansBold
    StatusLabel.TextSize = 13
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = MainFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, -20, 0, 35)
    ToggleBtn.Position = UDim2.new(0, 10, 0, 45)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "HOTKEYS ENGAGED"
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.TextSize = 13
    ToggleBtn.Parent = MainFrame

    -- Tracking Variables for Features
    local noclipActive = false
    local infiniteJumpActive = false
    local currentSpeedDialValue = 16
    local airPlatformPart = nil
    local customHeightTrackingValue = 0
    local noclipConnection = nil
    local flightConnection = nil
    local jumpConnection = nil

    local function UpdateConsoleBanner(msg)
        StatusLabel.Text = "SpiderHub Status: " .. tostring(msg) .. "\nN=NoClip | J=InfJump | L=Speed Dial | F=LagFix"
    end

    -- =============================================================================
    -- HOTKEY LOGIC STREAM (No complex buttons to crash your renderer)
    -- =============================================================================
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        -- FEATURE 1: Press N to Toggle "ACTIVATE" NoClip (With W to climb smoothly)
        if input.KeyCode == Enum.KeyCode.N then
            noclipActive = not noclipActive
            if noclipActive then
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                UpdateConsoleBanner("NoClip [ACTIVE]")
                
                local character = Player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then customHeightTrackingValue = rootPart.Position.Y end

                noclipConnection = RunService.Stepped:Connect(function()
                    local char = Player.Character
                    if char and noclipActive then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end)
                
                flightConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    local char = Player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    
                    if root and humanoid and noclipActive then
                        root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            customHeightTrackingValue = customHeightTrackingValue + (5 * deltaTime)
                        end
                        root.CFrame = CFrame.new(root.Position.X, customHeightTrackingValue, root.Position.Z)
                    end
                end)
            else
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                UpdateConsoleBanner("NoClip [OFF]")
                if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
                if flightConnection then flightConnection:Disconnect() flightConnection = nil end
                local character = Player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
            end

        -- FEATURE 2: Press B to "FIX" NoClips Not Working?
        elseif input.KeyCode == Enum.KeyCode.B then
            UpdateConsoleBanner("Flushing Physics Collision States...")
            local character = Player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            task.wait(0.4)
            UpdateConsoleBanner("System Normal.")

        -- FEATURE 3: Press J to Toggle "ACTIVATE" Infinite Jump
        elseif input.KeyCode == Enum.KeyCode.J then
            infiniteJumpActive = not infiniteJumpActive
            if infiniteJumpActive then
                UpdateConsoleBanner("Infinite Jump [ACTIVE]")
                jumpConnection = UserInputService.JumpRequest:Connect(function()
                    local character = Player.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if rootPart and infiniteJumpActive then
                        pcall(function()
                            if not airPlatformPart or not airPlatformPart.Parent then
                                airPlatformPart = Instance.new("Part")
                                airPlatformPart.Size = Vector3.new(5, 0.5, 5)
                                airPlatformPart.Transparency = 1
                                airPlatformPart.Anchored = true
                                airPlatformPart.Parent = Workspace
                            end
                            airPlatformPart.CFrame = CFrame.new(rootPart.Position.X, rootPart.Position.Y - 3.2, rootPart.Position.Z)
                            task.delay(0.3, function() if airPlatformPart then airPlatformPart:Destroy() end end)
                        end)
                    end
                end)
            else
                UpdateConsoleBanner("Infinite Jump [OFF]")
                if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
                if airPlatformPart then airPlatformPart:Destroy() end
            end

        -- FEATURE 4: Press L to Cycle "Speed Dial" (16 -> 45 -> 90 -> 150)
        elseif input.KeyCode == Enum.KeyCode.L then
            if currentSpeedDialValue == 16 then
                currentSpeedDialValue = 45
            elseif currentSpeedDialValue == 45 then
                currentSpeedDialValue = 90
            elseif currentSpeedDialValue == 90 then
                currentSpeedDialValue = 150
            else
                currentSpeedDialValue = 16
            end
            UpdateConsoleBanner("Speed Dial Value Shifted: " .. tostring(currentSpeedDialValue))

        -- FEATURE 5: Press F to "FIX" Rubber Band Lag?
        elseif input.KeyCode == Enum.KeyCode.F then
            UpdateConsoleBanner("Clearing Velocity Buffers...")
            local character = Player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Velocity = Vector3.zero
                rootPart.RotVelocity = Vector3.zero
            end
            task.wait(0.4)
            UpdateConsoleBanner("Velocity Flushed.")

        -- Toggle UI banner visibility via ALT key
        elseif input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- Speed locking frame controller
    RunService.RenderStepped:Connect(function()
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= currentSpeedDialValue then
            humanoid.WalkSpeed = currentSpeedDialValue
        end
    end)
end
