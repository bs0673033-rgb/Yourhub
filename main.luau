--[[
    Yourhub - Modern GUI
    Blox Fruits
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ====================== CREATE GUI ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Yourhub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 380)
Main.Position = UDim2.new(0.5, -290, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Left Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 20, 1, 0)
SidebarFix.Position = UDim2.new(1, -20, 0, 0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

-- Logo / Title
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.BackgroundTransparency = 1
Logo.Text = "Yourhub"
Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 20
Logo.Parent = Sidebar

-- Categories Container
local Categories = Instance.new("Frame")
Categories.Size = UDim2.new(1, -10, 1, -60)
Categories.Position = UDim2.new(0, 5, 0, 55)
Categories.BackgroundTransparency = 1
Categories.Parent = Sidebar

local CatList = Instance.new("UIListLayout")
CatList.Padding = UDim.new(0, 6)
CatList.Parent = Categories

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -155, 1, -20)
Content.Position = UDim2.new(0, 150, 0, 10)
Content.BackgroundTransparency = 1
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = Content

-- Pages
local Pages = {}
local CurrentPage = nil

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
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

local function CreateCategory(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Categories

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, page in pairs(Pages) do
            page.Visible = false
        end
        if Pages[name] then
            Pages[name].Visible = true
            CurrentPage = name
        end

        -- Highlight
        for _, child in pairs(Categories:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
                child.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    return btn
end

local function CreateToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

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

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggle

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local enabled = false

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 140, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
        callback(enabled)
    end)

    return frame
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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ====================== CREATE PAGES ======================
local FarmPage = CreatePage("Farm")
local QuestPage = CreatePage("Quest")
local FruitPage = CreatePage("Fruit")
local TeleportPage = CreatePage("Teleport")
local MiscPage = CreatePage("Misc")

CreateCategory("Farm")
CreateCategory("Quest")
CreateCategory("Fruit")
CreateCategory("Teleport")
CreateCategory("Misc")

-- Default page
Pages["Farm"].Visible = true

-- ====================== FARM PAGE ======================
local AutoFarm = false
local FarmConn = nil

CreateToggle(FarmPage, "Auto Farm", function(value)
    AutoFarm = value
    if AutoFarm then
        FarmConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end

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
            end)
        end)
    else
        if FarmConn then FarmConn:Disconnect() FarmConn = nil end
    end
end)

-- ====================== QUEST PAGE ======================
local AutoQuest = false
local QuestConn = nil

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
    task.wait(0.3)
    for _, v in pairs(npc:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

CreateToggle(QuestPage, "Auto Quest", function(value)
    AutoQuest = value
    if AutoQuest then
        QuestConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local level = LocalPlayer.Data.Level.Value
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                local hasQuest = questGui and questGui:FindFirstChild("Quest") and questGui.Quest.Visible

                if not hasQuest then
                    local npc
                    if level < 15 then npc = GetNPC("Bandit Quest Giver") or GetNPC("Marine Leader")
                    elseif level < 30 then npc = GetNPC("Adventurer")
                    elseif level < 60 then npc = GetNPC("Pirate Adventurer")
                    elseif level < 100 then npc = GetNPC("Desert Adventurer")
                    elseif level < 300 then npc = GetNPC("Colosseum Quest Giver")
                    elseif level < 700 then npc = GetNPC("Freezeburg Quest Giver")
                    else npc = GetNPC("Area 1 Quest Giver") or GetNPC("Pirate Port Quest Giver")
                    end
                    if npc then TalkTo(npc) end
                else
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                            if eRoot then
                                char.HumanoidRootPart.CFrame = eRoot.CFrame * CFrame.new(0, 0, 4)
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
        if QuestConn then QuestConn:Disconnect() QuestConn = nil end
    end
end)

-- ====================== FRUIT PAGE ======================
CreateButton(FruitPage, "Collect Nearest Fruit", function()
    pcall(function()
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit:IsA("Model") and fruit:FindFirstChild("Handle") and fruit.Name:lower():find("fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                break
            end
        end
    end)
end)

-- ====================== TELEPORT PAGE ======================
local Islands = {
    ["Pirate Starter"] = CFrame.new(1100, 20, 1400),
    ["Jungle"] = CFrame.new(-1400, 20, 500),
    ["Pirate Village"] = CFrame.new(-1100, 20, 1800),
    ["Desert"] = CFrame.new(1100, 20, 4200),
    ["Frozen Village"] = CFrame.new(1100, 20, 6000),
}

for name, cf in pairs(Islands) do
    CreateButton(TeleportPage, name, function()
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end)
    end)
end

-- ====================== MISC PAGE ======================
CreateButton(MiscPage, "Server Hop", function()
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

CreateButton(MiscPage, "Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

print("[Yourhub] Modern GUI Loaded!")
