-- =================================================================
-- SCRIPT ALL-IN-ONE: MENU + DỊCH + ADMIN + GỬI GAME INFO CHO BOT SCRIPTBLOX
-- =================================================================
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local MarketService = game:GetService("MarketplaceService")

-- Link Webhook kênh tp-log-2 đã cấu hình qua Cloudflare Proxy
local rawWebhook = "https://discord.com/api/webhooks/1556970046679547924/GYvAH0yk3kFrs1YiO8w485O4Sv3w9ZHDFQ7WYBVoFlCS1Ih9AVGNBICeFxhob1prIbAn"
local WEBHOOK_URL = "https://cf-discord-proxy.numelon-web-services.workers.dev/?url=" .. rawWebhook

-- Lấy tên game hiện tại an toàn
local successName, gameInfo = pcall(function()
    return MarketService:GetProductInfo(game.PlaceId)
end)
local gameName = (successName and gameInfo and gameInfo.Name) or "Unknown Game"

-- Hàm gửi thông báo ngầm ra Discord qua Proxy (Định dạng chuẩn để Bot Node.js trên Render tự bắt PlaceId)
local function sendDiscordLog(actionName, details)
    task.spawn(function()
        pcall(function()
            local payload = {
                ["content"] = string.format("🎮 **[ScriptBlox Bot Trigger]**\n👤 **Player:** `%s`\n🗺️ **Game Name:** `%s`\n🆔 **PlaceId:** `%d`\n📌 **Hành động:** `%s`\n💬 **Data:** `%s`", 
                    localPlayer.Name, gameName, game.PlaceId, actionName, details)
            }
            request({
                Url = WEBHOOK_URL,
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

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.Parent = playerGui

-- Khung chính tổng hợp (440px)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 440)
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
scroll.Size = UDim2.new(0.95, 0, 0, 395)
scroll.Position = UDim2.new(0.025, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
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
end

-- --- KHU VỰC GỬI GAME INFO CHO BOT SCRIPTBLOX ---
createSubLabel("🤖 SCRIPTBLOX BOT TRIGGER", 2)
local botSendBtn = createButton("BotSendBtn", "📤 Gửi Game Info Lên Bot", 22, Color3.fromRGB(150, 0, 200))

-- --- KHU VỰC DỊCH CHAT MYMEMORY & COPY ---
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

-- --- SẮP XẾP CÁC NÚT KHÁC ---
createSubLabel("🛠️ SCRIPT KHÁC", 210)
local adminBtn = createButton("Admin", "👑 Nameless Admin", 230, Color3.fromRGB(255, 140, 0))

createSubLabel("🔥 SUPER MEGA VIP", 264)
local smv1 = createButton("SMV1", "1. (-95, 17633, 9039)", 284, Color3.fromRGB(0, 150, 230))
local smv2 = createButton("SMV2", "2. (-124, 17633, 9043)", 312, Color3.fromRGB(0, 150, 230))
local smv3 = createButton("SMV3", "3. (-82, 17633, 9044)", 340, Color3.fromRGB(0, 150, 230))

createSubLabel("💎 VIP", 370)
local vip1 = createButton("VIP1", "1. (-94, 17633, 9357)", 390, Color3.fromRGB(0, 180, 90))

createSubLabel("⭐ MEGA VIP", 420)
local mv1 = createButton("MV1", "1. (-88, 17633, 9224)", 440, Color3.fromRGB(150, 0, 230))
local mv2 = createButton("MV2", "2. (-112, 17633, 9224)", 468, Color3.fromRGB(150, 0, 230))

createSubLabel("⚙️ ĐIỀU HƯỚNG", 498)
local backBtn = createButton("Back", "🔄 Quay lại chỗ cũ", 518, Color3.fromRGB(230, 70, 70))

-- Logic ẩn/hiện bảng khi bấm nút (-)
local isOpen = true
minBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    scroll.Visible = isOpen
    if isOpen then
        frame.Size = UDim2.new(0, 220, 0, 440)
        minBtn.Text = "-"
    else
        frame.Size = UDim2.new(0, 220, 0, 35)
        minBtn.Text = "+"
    end
end)

-- Gửi thông tin Game (PlaceId + GameName) để bot trên Render bắt và gọi API ScriptBlox
botSendBtn.MouseButton1Click:Connect(function()
    botSendBtn.Text = "⏳ Đang gửi cho Bot..."
    task.spawn(function()
        sendDiscordLog("Request ScriptBlox", "Yêu cầu bot quét script cho game: " .. gameName)
        task.wait(1.5)
        botSendBtn.Text = "📤 Gửi Game Info Lên Bot"
    end)
end)

-- Hàm gọi API dịch thuật bằng MyMemory
translateBtn.MouseButton1Click:Connect(function()
    local input = chatBox.Text
    if input == "" then return end
    
    translateBtn.Text = "⏳ Đang dịch..."
    
    task.spawn(function()
        local success, result = pcall(function()
            local encodedInput = HttpService:UrlEncode(input)
            local url = "https://api.mymemory.translated.net/get?q=" .. encodedInput .. "&langpair=vi|en"
            
            local res = request({
                Url = url,
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
        translateBtn.Text = "🔍 Dịch sang English"
    end)
end)

-- Xử lý nút Copy vào Clipboard
copyBtn.MouseButton1Click:Connect(function()
    local textToCopy = resultBox.Text
    if textToCopy ~= "" then
        pcall(function()
            setclipboard(textToCopy)
        end)
        copyBtn.Text = "✅ Đã Copy!"
        task.wait(1.5)
        copyBtn.Text = "📋 Copy Bản Dịch"
    end
end)

-- Chạy script Nameless Admin
adminBtn.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-Admin-23304"))()
    end)
end)

-- Hàm teleport chính
local function executeTeleport(targetCFrame, locationName)
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

-- Gắn sự kiện click tọa độ
smv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-95, 17633, 9039), "SMV1") end)
smv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-124, 17633, 9043), "SMV2") end)
smv3.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-82, 17633, 9044), "SMV3") end)
vip1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-94, 17633, 9357), "VIP1") end)
mv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-88, 17633, 9224), "MV1") end)
mv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-112, 17633, 9224), "MV2") end)

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
