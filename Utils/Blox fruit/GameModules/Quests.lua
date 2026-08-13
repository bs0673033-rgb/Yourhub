-- ====================== AUTO QUEST ======================
local AutoQuest = false
local QuestConnection = nil

local function GetNPC(name)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == name and npc:FindFirstChild("HumanoidRootPart") then
            return npc
        end
    end
    return nil
end

local function TalkTo(npc)
    if not npc then return end
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    char.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    task.wait(0.4)

    for _, v in pairs(npc:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

local function GetBestQuestNPC(level)
    if level < 15 then
        return GetNPC("Bandit Quest Giver") or GetNPC("Marine Leader")
    elseif level < 30 then
        return GetNPC("Adventurer")
    elseif level < 60 then
        return GetNPC("Pirate Adventurer")
    elseif level < 100 then
        return GetNPC("Desert Adventurer")
    elseif level < 150 then
        return GetNPC("Villager")
    elseif level < 300 then
        return GetNPC("Colosseum Quest Giver")
    elseif level < 375 then
        return GetNPC("The Mayor")
    elseif level < 450 then
        return GetNPC("King Neptune")
    elseif level < 700 then
        return GetNPC("Freezeburg Quest Giver")
    elseif level < 1500 then
        return GetNPC("Area 1 Quest Giver") or GetNPC("Area 2 Quest Giver")
    else
        return GetNPC("Pirate Port Quest Giver") 
            or GetNPC("Deep Forest Quest Giver")
            or GetNPC("Cake Quest Giver 1")
    end
end

CreateButton("Toggle Auto Quest", function()
    AutoQuest = not AutoQuest

    if AutoQuest then
        print("[Yourhub] Auto Quest Enabled")

        QuestConnection = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local level = player.Data.Level.Value
                local questGui = player.PlayerGui:FindFirstChild("Main")
                local hasQuest = false

                if questGui and questGui:FindFirstChild("Quest") then
                    hasQuest = questGui.Quest.Visible
                end

                if not hasQuest then
                    -- Take a new quest
                    local npc = GetBestQuestNPC(level)
                    if npc then
                        TalkTo(npc)
                    end
                else
                    -- Farm enemies
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                            if enemyRoot then
                                char.HumanoidRootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 4)

                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool:Activate()
                                end
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
