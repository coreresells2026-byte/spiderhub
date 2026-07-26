-- Master Loader Engine & Remote Initializer for custom sandbox game
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Create the network communication folder
local RemoteFolder = ReplicatedStorage:FindFirstChild("SpiderHubRemotes")
if not RemoteFolder then
    RemoteFolder = Instance.new("Folder")
    RemoteFolder.Name = "SpiderHubRemotes"
    RemoteFolder.Parent = ReplicatedStorage
end

local function GetOrCreateRemote(name, className)
    local remote = RemoteFolder:FindFirstChild(name)
    if not remote then
        remote = Instance.new(className)
        remote.Name = name
        remote.Parent = RemoteFolder
    end
    return remote
end

local ActionRemote = GetOrCreateRemote("RequestGameAction", "RemoteEvent")

-- Server-Side Authority Logic (Handles item movement, collision, and cloning)
ActionRemote.OnServerEvent:Connect(function(player, actionType, extraData)
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not character or not rootPart then return end
    
    if actionType == "InstaSteal" and extraData then
        -- Teleport character securely on the server to prevent anti-cheat triggers
        rootPart.CFrame = extraData
        
    elseif actionType == "NoclipOn" then
        -- Temporarily turn off character collisions globally on the server
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
    elseif actionType == "NoclipOff" then
        -- Restore original character collision physics
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        
    elseif actionType == "SafeDupe" then
        -- Clone target item on the server so it replicates to all players safely
        local targetItem = Workspace:FindFirstChild("BrainrotItem")
        if targetItem then
            task.wait(0.25) -- Configured delay simulation
            local clonedItem = targetItem:Clone()
            
            if clonedItem:IsA("Model") then
                clonedItem:PivotTo(character:GetPivot() * CFrame.new(0, -2.5, 0))
            elseif clonedItem:IsA("BasePart") then
                clonedItem.CFrame = character:GetPivot() * CFrame.new(0, -2.5, 0)
                clonedItem.Anchored = true
            end
            
            clonedItem.Parent = Workspace
            print("[SpiderHub Server]: Replicated item spawn for player " .. player.Name)
        end
    end
end)

-- Fetch and construct the user interface elements
local success, moduleSource = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and moduleSource then
    local loader = loadstring(moduleSource)
    if loader then
        local AdminUI = loader()
        AdminUI.CreateMenu()
        print("[SpiderHub]: UI loaded and successfully paired to backend remotes.")
    end
end
