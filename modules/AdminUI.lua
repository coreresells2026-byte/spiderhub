local AdminUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
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
    
    local MovementPage = Instance.new("Frame")
    MovementPage.Name = "Movement Mods"
    MovementPage.Size = UDim2.new(1, 0, 1, 0)
    MovementPage.BackgroundTransparency = 1
    MovementPage.Visible = true
    MovementPage.Parent = PageContainer
    
    local ItemPage = Instance.new("Frame")
    ItemPage.Name = "Item Dupe"
    ItemPage.Size = UDim2.new(1, 0, 1, 0)
    ItemPage.BackgroundTransparency = 1
    ItemPage.Visible = false
    ItemPage.Parent = PageContainer
    
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
    
    CreateTab("Movement Mods", MovementPage)
    CreateTab("Item Dupe", ItemPage)
    
    local function CreateButton(text, parent, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 40)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Text = text
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 16
        Btn.Parent = parent
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Btn
        
        local PageLayout = parent:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = parent
        
        Btn.MouseButton1Click:Connect(callback)
    end
    
    local isStealing = false
    CreateButton("Humanized Insta-Steal", MovementPage, function()
        if isStealing then return end
        local character = Player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local targetZone = Workspace:FindFirstChild("Bases") 
            and Workspace.Bases:FindFirstChild("RedBase") 
            and Workspace.Bases.RedBase:FindFirstChild("DepositZone")
            
        if rootPart and targetZone then
            isStealing = true
            local distance = (targetZone.CFrame.Position - rootPart.CFrame.Position).Magnitude
            local duration = distance / 15.5
            local tween = TweenService:Create(rootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetZone.CFrame})
            tween:Play()
            tween.Completed:Connect(function() isStealing = false end)
        end
    end)
    
    local noclipConnection = nil
    CreateButton("Toggle Phasing (NoClip)", MovementPage, function()
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
            return
        end
        noclipConnection = RunService.PreSimulation:Connect(function()
            local character = Player.Character
            local torso = character and (character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if torso and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {character}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local result = Workspace:Raycast(torso.Position, humanoid.MoveDirection * 3, params)
                if result and result.Instance and result.Instance:IsA("BasePart") and result.Instance.CanCollide then
                    local part = result.Instance
                    part.CanCollide = false
                    task.delay(0.5, function() if part and part.Parent then part.CanCollide = true end end)
                end
            end
        end)
    end)
    
    CreateButton("Safe Dupe (Simulation)", ItemPage, function()
        local character = Player.Character
        local targetItem = Workspace:FindFirstChild("BrainrotItem")
        if character and targetItem then
            task.wait(0.25)
            local clonedItem = targetItem:Clone()
            if clonedItem:IsA("Model") then clonedItem:PivotTo(character:GetPivot() * CFrame.new(0, -2.5, 0))
            elseif clonedItem:IsA("BasePart") then clonedItem.CFrame = character:GetPivot() * CFrame.new(0, -2.5, 0) clonedItem.Anchored = true end
            clonedItem.Parent = Workspace
        end
    end)
    
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
