return function()
    local Functions = {}

    function Functions.Notify(title, text, duration)
        duration = duration or 5
        -- Simple notify (you can replace with better UI later)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration
        })
    end

    function Functions.GetCharacter()
        local lp = game:GetService("Players").LocalPlayer
        return lp.Character or lp.CharacterAdded:Wait()
    end

    function Functions.GetHumanoid()
        local char = Functions.GetCharacter()
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    function Functions.GetRoot()
        local char = Functions.GetCharacter()
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    return Functions
end
