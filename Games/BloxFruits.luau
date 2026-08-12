--[[
    YourHub - Blox Fruits
]]

return function(fetcher, ...)
    local args = {...}
    local Settings = args[1] or {}

    -- Load utils
    local Services = fetcher.load("{Utils}Services.luau")()
    local Functions = fetcher.load("{Utils}Functions.luau")()

    local Players = Services.Players
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    print("[YourHub] Blox Fruits loaded!")

    -- ====================== YOUR SCRIPT HERE ======================

    -- Example: Simple GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "YourHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 200)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.Text = "YourHub | Blox Fruits"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.8, 0, 0, 40)
    Button.Position = UDim2.new(0.1, 0, 0.4, 0)
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Button.Text = "Test Button"
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = Frame

    Button.MouseButton1Click:Connect(function()
        print("Button clicked!")
        -- Your feature here
    end)

    -- ==============================================================

    return true
end
