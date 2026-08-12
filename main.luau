--[[
    Yourhub - One File Version
    Made by: bs0673033-rgb
]]

local _ENV = (getgenv or getrenv or getfenv)()

-- Debounce
if _ENV.YourHub_Debounce and (tick() - _ENV.YourHub_Debounce) <= 4 then
    return
end
_ENV.YourHub_Debounce = tick()

-- Only run in supported games
local Supported = {
    [994732206] = "Blox Fruits",          -- GameId
    [10260193230] = "Meme Sea",           -- PlaceId
}

local CurrentGame = Supported[game.GameId] or Supported[game.PlaceId]

if not CurrentGame then
    warn("[Yourhub] This game is not supported.")
    return
end

print("[Yourhub] Loading " .. CurrentGame .. "...")

-- ====================== BLOX FRUITS SCRIPT ======================
if CurrentGame == "Blox Fruits" then

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "YourHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 220)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Title.Text = "Yourhub | Blox Fruits"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Frame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.85, 0, 0, 42)
    Button.Position = UDim2.new(0.075, 0, 0.35, 0)
    Button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    Button.Text = "Test Button"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 15
    Button.Parent = Frame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        print("[Yourhub] Button clicked!")
    end)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = Frame

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    print("[Yourhub] Blox Fruits loaded successfully!")

-- ====================== MEME SEA SCRIPT ======================
elseif CurrentGame == "Meme Sea" then

    print("[Yourhub] Meme Sea loaded!")
    -- Put your Meme Sea features here later

end
