--[[
    Yourhub - Blox Fruits
    Clean Version
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ====================== GUI ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Yourhub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 370)
Main.Position = UDim2.new(0.5, -160, 0.5, -185)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Yourhub | Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -36, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -24, 1, -55)
Container.Position = UDim2.new(0, 12, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Container

local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Parent = Container

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- ====================== FEATURES ======================
local AutoFarm = false
local AutoQuest = false
local FarmConnection = nil
local QuestConnection = nil

-- Auto Farm
CreateButton("Toggle Auto Farm", function()
    AutoFarm = not AutoFarm
    if AutoFarm then
        print("[Yourhub] Auto Farm Enabled")
        FarmConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not root or not humanoid or humanoid.Health <= 0 then return end

                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyRoot then
                            root.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 4)
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                            break
                        end
                    end
                end
            end)
        end)
    else
        print("[Yourhub] Auto Farm Disabled")
        if FarmConnection then
            FarmConnection:Disconnect()
            FarmConnection = nil
        end
    end
end)

-- Auto Quest
local function GetNPC(name)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == name and npc:FindFirstChild("HumanoidRootPart") then
            return npc
        end
    end
end

local function TalkTo(npc)
    if not npc then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    task.wait(0.35)
    for _, v in pairs(npc:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

local function GetBestNPC(level)
    if level < 15 then return GetNPC("Bandit Quest Giver") or GetNPC("Marine Leader")
    elseif level < 30 then return GetNPC("Adventurer")
    elseif level < 60 then return GetNPC("Pirate Adventurer")
    elseif level < 100 then return GetNPC("Desert Adventurer")
    elseif level < 150 then return GetNPC("Villager")
    elseif level < 300 then return GetNPC("Colosseum Quest Giver")
    elseif level < 375 then return GetNPC("The Mayor")
    elseif level < 450 then return GetNPC("King Neptune")
    elseif level < 700 then return GetNPC("Freezeburg Quest Giver")
    elseif level < 1500 then return GetNPC("Area 1 Quest Giver") or GetNPC("Area 2 Quest Giver")
    else return GetNPC("Pirate Port Quest Giver") or GetNPC("Deep Forest Quest Giver")
    end
end

CreateButton("Toggle Auto Quest", function()
    AutoQuest = not AutoQuest
    if AutoQuest then
        print("[Yourhub] Auto Quest Enabled")
        QuestConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local level = LocalPlayer.Data.Level.Value
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                local hasQuest = questGui and questGui:FindFirstChild("Quest") and questGui.Quest.Visible

                if not hasQuest then
                    local npc = GetBestNPC(level)
                    if npc then TalkTo(npc) end
                else
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                            if enemyRoot then
                                char.HumanoidRootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 4)
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                                break
                            end
                        end
                    end
                end
            end)
        end)
    else
        print("[Yourhub] Auto Quest Disabled")
        if QuestConnection then
            QuestConnection:Disconnect()
            QuestConnection = nil
        end
    end
end)

-- Collect Nearest Fruit
CreateButton("Collect Nearest Fruit", function()
    pcall(function()
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit:IsA("Model") and fruit:FindFirstChild("Handle") and fruit.Name:lower():find("fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                print("[Yourhub] Teleported to fruit")
                break
            end
        end
    end)
end)

-- Server Hop
CreateButton("Server Hop", function()
    local PlaceId = game.PlaceId
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and servers and servers.data then
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
end)

print("[Yourhub] Loaded successfully!")
