-- =================================================================
-- SCRIPT ALL-IN-ONE (FULL): MENU + ĐỒNG BỘ LOG CHAT + DỊCH + BOT
-- =================================================================
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local MarketService = game:GetService("MarketplaceService")

-- Link API log trung gian trên Render của cậu
local API_LOG_URL = "https://hacksuper2.onrender.com/api/logs"

-- 1. Webhook kênh tp-log-2 (Dành cho Bot ScriptBlox & Rscripts)
local rawWebhookBot = "https://discord.com/api/webhooks/1556970046679547924/GYvAH0yk3kFrs1YiO8w485O4Sv3w9ZHDFQ7WYBVoFlCS1Ih9AVGNBICeFxhob1prIbAn"
local WEBHOOK_BOT_URL = "https://cf-discord-proxy.numelon-web-services.workers.dev/?url=" .. rawWebhookBot

-- 2. Webhook kênh tp-log (Dành riêng cho Log Dịch Chat qua Proxy)
local rawWebhookChat = "https://discord.com/api/webhooks/1556960491086155776/qv4XW06rSiS1cvwTYszxAYyBJwrmJ9gBlp-9R4CTgxlxkEYvSLguUG9tQXqxg15tTefP"
local WEBHOOK_CHAT_URL = "https://cf-discord-proxy.numelon-web-services.workers.dev/?url=" .. rawWebhookChat

-- 3. Webhook kênh thông-báo-hoặc-tin-nhắn-từ-script
local rawWebhookNoti = "https://discord.com/api/webhooks/1558110251570696202/QjzNJ-ZVxdysJynSnuBxVY1x8yXcxD3DhK4v6mvP9JEVA0hYbCqBwM1GiO2RhM5JvtCx"
local WEBHOOK_NOTI_URL = "https://cf-discord-proxy.numelon-web-services.workers.dev/?url=" .. rawWebhookNoti

-- Lấy tên game hiện tại an toàn
local successName, gameInfo = pcall(function()
    return MarketService:GetProductInfo(game.PlaceId)
end)
local gameName = (successName and gameInfo and gameInfo.Name) or "Unknown Game"

-- Kiểm tra PlaceId chỉ định (10033751448)
local isTargetGame = (game.PlaceId == 10033751448)

local addLogMessage

-- Hàm gửi tin nhắn từ xa đến Discord
local function sendRemoteMessage(customMessage)
    task.spawn(function()
        pcall(function()
            local payload = {
                ["content"] = string.format("💬 **[Nhắn Tin Từ Xa]**\n👤 **Player:** `%s`\n🗺️ **Game:** `%s`\n✉️ **Nội dung:** `%s`", 
                    localPlayer.Name, gameName, customMessage)
            }
            request({
                Url = WEBHOOK_NOTI_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

-- Hàm gửi thông tin cho Bot ScriptBlox
local function sendBotLog(actionName, details)
    task.spawn(function()
        pcall(function()
            local payload = {
                ["content"] = string.format("[ScriptBlox Bot Trigger]\n🗺️ **Game Name:** `%s`\n🆔 **PlaceId:** `%d`\n📌 **Hành động:** `%s`\n💬 **Data:** `%s`", 
                    gameName, game.PlaceId, actionName, details)
            }
            request({
                Url = WEBHOOK_BOT_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
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
            request({
                Url = WEBHOOK_CHAT_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

-- Xóa GUI cũ nếu lỡ chạy nhiều lần
if playerGui:FindFirstChild("TeleportGUI") then
    playerGui.TeleportGUI:Destroy()
end

-- Tạo ScreenGui chính (Chống mất khi chết với ResetOnSpawn = false)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Khung chính tổng hợp (480px)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 480)
frame.Position = UDim2.new(0.05, 0, 0.22, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Tiêu đề bảng
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 0, 25)
title.Position = UDim2.new(0.05, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ MENU & SCRIPTBLOX BOT"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Nút thu nhỏ / mở rộng (-)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(0.82, 0, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

-- ScrollingFrame chứa các tính năng cuộn mượt mà
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0, 435)
scroll.Position = UDim2.new(0.025, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 780)
scroll.ScrollBarThickness = 4
scroll.Parent = frame

-- Biến lưu tọa độ vị trí cũ
local oldPosition = nil

-- Hàm tạo nút bấm chuẩn
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

-- Hàm tạo tiêu đề nhỏ
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

-- --- KHU VỰC NHẮN TIN TỪ XA & LỊCH SỬ CHUNG ---
createSubLabel("💬 NHẮN TIN TỪ XA & LỊCH SỬ CHUNG", 2)

local msgBox = Instance.new("TextBox")
msgBox.Size = UDim2.new(0.95, 0, 0, 28)
msgBox.Position = UDim2.new(0.02, 0, 0, 22)
msgBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
msgBox.PlaceholderText = "Nhập tin nhắn..."
msgBox.Text = ""
msgBox.TextColor3 = Color3.fromRGB(255, 255, 255)
msgBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
msgBox.TextSize = 11
msgBox.Font = Enum.Font.Gotham
msgBox.ClearTextOnFocus = false
msgBox.Parent = scroll

local msgCorner = Instance.new("UICorner")
msgCorner.CornerRadius = UDim.new(0, 4)
msgCorner.Parent = msgBox

local sendMsgBtn = createButton("SendMsgBtn", "📤 Gửi Tin Nhắn", 54, Color3.fromRGB(0, 150, 150))

-- Khung hiển thị lịch sử chat trực tiếp trên GUI
local chatLogFrame = Instance.new("ScrollingFrame")
chatLogFrame.Size = UDim2.new(0.95, 0, 0, 80)
chatLogFrame.Position = UDim2.new(0.02, 0, 0, 84)
chatLogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
chatLogFrame.BorderSizePixel = 0
chatLogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
chatLogFrame.ScrollBarThickness = 3
chatLogFrame.Parent = scroll

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 4)
logCorner.Parent = chatLogFrame

local logLayout = Instance.new("UIListLayout")
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Padding = UDim.new(0, 2)
logLayout.Parent = chatLogFrame

local displayedLogs = {}
addLogMessage = function(text, id)
    if displayedLogs[id] then return end
    displayedLogs[id] = true

    local logItem = Instance.new("TextLabel")
    logItem.Size = UDim2.new(1, 0, 0, 18)
    logItem.BackgroundTransparency = 1
    logItem.Text = text
    logItem.TextColor3 = Color3.fromRGB(0, 255, 200)
    logItem.TextSize = 10
    logItem.Font = Enum.Font.Code
    logItem.TextXAlignment = Enum.TextXAlignment.Left
    logItem.Parent = chatLogFrame
    
    chatLogFrame.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y)
    chatLogFrame.CanvasPosition = Vector2.new(0, chatLogFrame.CanvasSize.Y.Offset)
end

addLogMessage("system: Đã kết nối Script thành công!", "sys_init")

-- Vòng lặp ngầm tự động fetch log từ API bot Render mỗi 4 giây (chống lặp bằng ID)
task.spawn(function()
    while true do
        pcall(function()
            local res = request({
                Url = API_LOG_URL,
                Method = "GET"
            })
            if res and res.StatusCode == 200 then
                local logs = HttpService:JSONDecode(res.Body)
                for _, log in ipairs(logs) do
                    local logId = log.content .. tostring(log.timestamp)
                    addLogMessage(log.content, logId)
                end
            end
        end)
        task.wait(4)
    end
end)

-- --- KHU VỰC GỬI GAME INFO CHO BOT SCRIPTBLOX ---
createSubLabel("🤖 SCRIPTBLOX BOT TRIGGER", 170)
local botSendBtn = createButton("BotSendBtn", "📤 Gửi Game Info Lên Bot", 190, Color3.fromRGB(150, 0, 200))

-- --- KHU VỰC DỊCH CHAT MYMEMORY & COPY ---
createSubLabel("🌐 DỊCH CHAT (MYMEMORY API)", 226)

local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(0.95, 0, 0, 28)
chatBox.Position = UDim2.new(0.02, 0, 0, 246)
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

local translateBtn = createButton("TransBtn", "🔍 Dịch sang English", 278, Color3.fromRGB(0, 120, 255))

local resultBox = Instance.new("TextBox")
resultBox.Size = UDim2.new(0.95, 0, 0, 28)
resultBox.Position = UDim2.new(0.02, 0, 0, 308)
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

local copyBtn = createButton("CopyBtn", "📋 Copy Bản Dịch", 340, Color3.fromRGB(0, 180, 90))

-- --- SẮP XẾP CÁC NÚT KHÁC (ẨN HIỆN THEO PLACEID) ---
local adminLbl = createSubLabel("🛠️ SCRIPT KHÁC", 378)
local adminBtn = createButton("Admin", "👑 Nameless Admin", 398, Color3.fromRGB(255, 140, 0))

local smvLbl = createSubLabel("🔥 SUPER MEGA VIP", 432)
local smv1 = createButton("SMV1", "1. (-95, 17633, 9039)", 452, Color3.fromRGB(0, 150, 230))
local smv2 = createButton("SMV2", "2. (-124, 17633, 9043)", 480, Color3.fromRGB(0, 150, 230))
local smv3 = createButton("SMV3", "3. (-82, 17633, 9044)", 508, Color3.fromRGB(0, 150, 230))

local vipLbl = createSubLabel("💎 VIP", 538)
local vip1 = createButton("VIP1", "1. (-94, 17633, 9357)", 558, Color3.fromRGB(0, 180, 90))

local mvLbl = createSubLabel("⭐ MEGA VIP", 588)
local mv1 = createButton("MV1", "1. (-88, 17633, 9224)", 608, Color3.fromRGB(150, 0, 230))
local mv2 = createButton("MV2", "2. (-112, 17633, 9224)", 636, Color3.fromRGB(150, 0, 230))

local navLbl = createSubLabel("⚙️ ĐIỀU HƯỚNG", 666)
local backBtn = createButton("Back", "🔄 Quay lại chỗ cũ", 686, Color3.fromRGB(230, 70, 70))

-- Tự động ẩn các nút TP và Admin nếu không phải game chỉ định
if not isTargetGame then
    adminLbl.Visible = false
    adminBtn.Visible = false
    smvLbl.Visible = false
    smv1.Visible = false
    smv2.Visible = false
    smv3.Visible = false
    vipLbl.Visible = false
    vip1.Visible = false
    mvLbl.Visible = false
    mv1.Visible = false
    mv2.Visible = false
    navLbl.Visible = false
    backBtn.Visible = false
end

-- Logic ẩn/hiện bảng khi bấm nút (-)
minBtn.MouseButton1Click:Connect(function()
    local isOpen = scroll.Visible
    scroll.Visible = not isOpen
    frame.Size = isOpen and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 480)
    minBtn.Text = isOpen and "+" or "-"
end)

-- Gửi tin nhắn từ xa khi bấm nút
sendMsgBtn.MouseButton1Click:Connect(function()
    local text = msgBox.Text
    if text == "" then return end
    
    sendMsgBtn.Text = "⏳ Đang gửi..."
    task.spawn(function()
        sendRemoteMessage(text)
        task.wait(1.5)
        sendMsgBtn.Text = "📤 Gửi Tin Nhắn"
        msgBox.Text = ""
    end)
end)

-- Gửi thông tin Game vào tp-log-2
botSendBtn.MouseButton1Click:Connect(function()
    botSendBtn.Text = "⏳ Đang gửi..."
    task.spawn(function()
        sendBotLog("Request ScriptBlox & Rscripts", "Yêu cầu quét script cho: " .. gameName)
        task.wait(1.5)
        botSendBtn.Text = "📤 Gửi Game Info Lên Bot"
    end)
end)

-- Hàm dịch chat
translateBtn.MouseButton1Click:Connect(function()
    local input = chatBox.Text
    if input == "" then return end
    
    translateBtn.Text = "⏳ Đang dịch..."
    
    task.spawn(function()
        local success, result = pcall(function()
            local res = request({
                Url = "https://api.mymemory.translated.net/get?q=" .. HttpService:UrlEncode(input) .. "&langpair=vi|en",
                Method = "GET"
            })
            
            if res and res.StatusCode == 200 then
                local data = HttpService:JSONDecode(res.Body)
                if data and data.responseData and data.responseData.translatedText then
                    return data.responseData.translatedText
                end
            end
            return input
        end)
        
        resultBox.Text = (success and result) or input
        sendChatLog(input, resultBox.Text)
        
        translateBtn.Text = "🔍 Dịch sang English"
    end)
end)

-- Copy bản dịch
copyBtn.MouseButton1Click:Connect(function()
    if resultBox.Text ~= "" then
        pcall(function()
            setclipboard(resultBox.Text)
        end)
        copyBtn.Text = "✅ Đã Copy!"
        task.wait(1.5)
        copyBtn.Text = "📋 Copy Bản Dịch"
    end)
end)

-- Nameless Admin
adminBtn.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-Admin-23304"))()
    end)
end)

-- Hàm teleport
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

smv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-95, 17633, 9039)) end)
smv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-124, 17633, 9043)) end)
smv3.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-82, 17633, 9044)) end)
vip1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-94, 17633, 9357)) end)
mv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-88, 17633, 9224)) end)
mv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-112, 17633, 9224)) end)

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
