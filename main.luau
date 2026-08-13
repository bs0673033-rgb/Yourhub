--[[
    Yourhub - Advanced Version
    Features: Auto Farm, Auto Quest, Fruit Sniper, ESP, Noclip, Speed, Boss Farm, Teleports
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ====================== SETTINGS ======================
local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    AutoBoss = false,
    FruitSniper = false,
    ESP = false,
    Noclip = false,
    Speed = false,
    SpeedValue = 50,
}

local Connections = {}

-- ====================== GUI ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Yourhub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 20, 1, 0)
SidebarFix.Position = UDim2.new(1, -20, 0, 0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.BackgroundTransparency = 1
Logo.Text = "Yourhub"
Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 22
Logo.Parent = Sidebar

local Categories = Instance.new("Frame")
Categories.Size = UDim2.new(1, -10, 1, -60)
Categories.Position = UDim2.new(0, 5, 0, 55)
Categories.BackgroundTransparency = 1
Categories.Parent = Sidebar

local CatList = Instance.new("UIListLayout")
CatList.Padding = UDim.new(0, 6)
CatList.Parent = Categories

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -20)
Content.Position = UDim2.new(0, 155, 0, 10)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Pages = {}

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 140, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = page

    Pages[name] = page
    return page
end

local function CreateCategory(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Categories
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, page in pairs(Pages) do page.Visible = false end
        if Pages[name] then Pages[name].Visible = true end

        for _, child in pairs(Categories:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
                child.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

local function CreateToggle(parent, text, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 42, 0, 22)
    toggle.Position = UDim2.new(1, -52, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggle.Text = ""
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggle
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    toggle.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        if Settings[flag] then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 140, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
    end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(0, 130, 240)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
end

-- Create Pages
local FarmPage = CreatePage("Farm")
local QuestPage = CreatePage("Quest")
local FruitPage = CreatePage("Fruit")
local BossPage = CreatePage("Boss")
local TeleportPage = CreatePage("Teleport")
local VisualPage = CreatePage("Visual")
local MiscPage = CreatePage("Misc")

CreateCategory("Farm")
CreateCategory("Quest")
CreateCategory("Fruit")
CreateCategory("Boss")
CreateCategory("Teleport")
CreateCategory("Visual")
CreateCategory("Misc")

Pages["Farm"].Visible = true

-- ====================== FEATURES ======================

-- Auto Farm
CreateToggle(FarmPage, "Auto Farm (Nearest Enemy)", "AutoFarm")

-- Auto Quest
CreateToggle(QuestPage, "Auto Quest", "AutoQuest")

-- Fruit
CreateToggle(FruitPage, "Fruit Sniper (Auto Collect)", "FruitSniper")
CreateButton(FruitPage, "Teleport to Nearest Fruit", function()
    pcall(function()
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Handle") and v.Name:lower():find("fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                break
            end
        end
    end)
end)

-- Boss
CreateToggle(BossPage, "Auto Boss Farm", "AutoBoss")

-- Teleports
local Islands = {
    ["Pirate Starter"] = CFrame.new(1107, 16, 1423),
    ["Jungle"] = CFrame.new(-1618, 37, 149),
    ["Pirate Village"] = CFrame.new(-1146, 20, 1878),
    ["Desert"] = CFrame.new(1095, 20, 4285),
    ["Frozen Village"] = CFrame.new(1196, 20, 6045),
    ["Middle Town"] = CFrame.new(-655, 20, 1580),
    ["Colosseum"] = CFrame.new(-1575, 20, 2950),
    ["Kingdom of Rose"] = CFrame.new(-300, 20, 300),
}

for name, cf in pairs(Islands) do
    CreateButton(TeleportPage, name, function()
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end)
    end)
end

-- Visual
CreateToggle(VisualPage, "ESP (Players + Fruits)", "ESP")

-- Misc
CreateToggle(MiscPage, "Noclip", "Noclip")
CreateToggle(MiscPage, "Speed Boost", "Speed")

CreateButton(MiscPage, "Server Hop", function()
    local PlaceId = game.PlaceId
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and data and data.data then
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
end)

CreateButton(MiscPage, "Rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- ====================== LOOPS ======================
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        -- Auto Farm
        if Settings.AutoFarm then
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                    if eRoot then
                        root.CFrame = eRoot.CFrame * CFrame.new(0, 0, 4)
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                        break
                    end
                end
            end
        end

        -- Fruit Sniper
        if Settings.FruitSniper then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Handle") and v.Name:lower():find("fruit") then
                    root.CFrame = v.Handle.CFrame
                    break
                end
            end
        end

        -- Noclip
        if Settings.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        -- Speed
        if Settings.Speed then
            humanoid.WalkSpeed = Settings.SpeedValue
        end
    end)
end)

-- Simple ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "YourhubESP"
ESPFolder.Parent = game:GetService("CoreGui")

RunService.RenderStepped:Connect(function()
    if not Settings.ESP then
        ESPFolder:ClearAllChildren()
        return
    end

    pcall(function()
        -- Player ESP
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local name = "ESP_" .. player.Name
                if not ESPFolder:FindFirstChild(name) then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = name
                    billboard.Adornee = player.Character.HumanoidRootPart
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = ESPFolder

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = player.Name
                    label.TextColor3 = Color3.fromRGB(0, 255, 100)
                    label.TextStrokeTransparency = 0.5
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 12
                    label.Parent = billboard
                end
            end
        end
    end)
end)

print("[Yourhub] Advanced Version Loaded!")
