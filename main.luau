‎--[[
‎    YourHub - Main Loader
‎    Made by:  bs0673033-rgb
‎]]
‎
‎local _ENV = (getgenv or getrenv or getfenv)()
‎local BETA_VERSION = BETA_VERSION or _ENV.BETA_VERSION
‎
‎-- ====================== YOUR CONFIG ======================
‎local Config = {
‎    DebounceTime = 4,
‎    Owner = "https://raw.githubusercontent.com/bs0673033-rgb/",  -- ← CHANGE THIS
‎    Repo  = "YourHub/refs/heads/main/",                         -- ← CHANGE THIS
‎}
‎
‎Config.Repository = Config.Owner .. Config.Repo
‎Config.Utils      = Config.Repository .. "Utils/"
‎Config.Translator = Config.Repository .. "Translator/"
‎
‎-- Games your hub supports
‎local Scripts = {
‎    {
‎        Name = "Blox Fruits",
‎        GameId = 994732206,
‎        UrlPath = BETA_VERSION and "BloxFruits-BETA.luau" or "BloxFruits.luau"
‎    },
‎    {
‎        Name = "Meme Sea",
‎        PlacesIds = {10260193230},
‎        UrlPath = "MemeSea.luau"
‎    },
‎    -- Add more games here
‎}
‎-- ========================================================
‎
‎local fetcher, urls = {}, Config
‎
‎-- Debounce
‎do
‎    local last = _ENV.YourHub_Debounce
‎    if last and (tick() - last) <= Config.DebounceTime then return end
‎    _ENV.YourHub_Debounce = tick()
‎end
‎
‎-- Queue on teleport
‎do
‎    local queue = queue_on_teleport
‎        or (syn and syn.queue_on_teleport)
‎        or (fluxus and fluxus.queue_on_teleport)
‎
‎    if type(queue) == "function" and not _ENV.YourHub_TeleportQueued then
‎        _ENV.YourHub_TeleportQueued = true
‎
‎        local args = {...}
‎        local settingsCode = ""
‎
‎        local ok, encoded = pcall(function()
‎            return game:GetService("HttpService"):JSONEncode(args)
‎        end)
‎
‎        if ok and encoded and encoded ~= "[]" then
‎            settingsCode = "unpack(game:GetService('HttpService'):JSONDecode('" .. encoded .. "'))"
‎        end
‎
‎        local source = ("loadstring(game:HttpGet('%smain.luau'))(%s)"):format(Config.Repository, settingsCode)
‎        if BETA_VERSION then
‎            source = "getgenv().BETA_VERSION=true;" .. source
‎        end
‎
‎        pcall(queue, source)
‎    end
‎end
‎
‎-- Error system
‎do
‎    if _ENV.YourHub_Error then
‎        pcall(function() _ENV.YourHub_Error:Destroy() end)
‎    end
‎
‎    local identify = identifyexecutor or function() return "Unknown" end
‎
‎    local function fail(text)
‎        _ENV.loadedFarm = nil
‎        _ENV.OnFarm = false
‎
‎        local msg = Instance.new("Message")
‎        msg.Parent = workspace
‎        msg.Text = tostring(text):gsub(Config.Owner, "")
‎        _ENV.YourHub_Error = msg
‎
‎        error(text, 2)
‎    end
‎
‎    local function formatUrl(url)
‎        for key, path in pairs(urls) do
‎            if type(path) == "string" and url:find("{" .. key .. "}") then
‎                return url:gsub("{" .. key .. "}", path)
‎            end
‎        end
‎        return url
‎    end
‎
‎    function fetcher.get(url)
‎        local success, response = pcall(function()
‎            return game:HttpGet(formatUrl(url), true)
‎        end)
‎
‎        if success then
‎            return response
‎        else
‎            fail(("[1] [%s] Failed to get:\n%s\n>> %s <<"):format(identify(), url, tostring(response)))
‎        end
‎    end
‎
‎    function fetcher.load(url, extra)
‎        local raw = fetcher.get(url) .. (extra or "")
‎        local fn, err = loadstring(raw)
‎
‎        if type(fn) ~= "function" then
‎            fail(("[2] [%s] Syntax error:\n%s\n>> %s <<"):format(identify(), url, tostring(err)))
‎        end
‎        return fn
‎    end
‎end
‎
‎-- Place checker
‎local function IsPlace(data)
‎    if data.PlacesIds and table.find(data.PlacesIds, game.PlaceId) then
‎        return true
‎    end
‎    if data.GameId and data.GameId == game.GameId then
‎        return true
‎    end
‎    return false
‎end
‎
‎-- Load matching script
‎for _, data in ipairs(Scripts) do
‎    if IsPlace(data) then
‎        return fetcher.load("{Repository}Games/" .. data.UrlPath)(fetcher, ...)
‎    end
‎end
