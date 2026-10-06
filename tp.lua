-- Tạo GUI Teleport tích hợp Dịch thuật (Có ô hiển thị kết quả & nút Copy)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")

-- Xóa GUI cũ nếu lỡ chạy nhiều lần
if playerGui:FindFirstChild("TeleportGUI") then
    playerGui.TeleportGUI:Destroy()
end

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.Parent = playerGui

-- Khung chính gọn gàng (Tăng chiều cao lên 410px để vừa phần dịch và copy)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 410)
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
title.Text = "⚡ MENU VIP & DỊCH CHAT"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 12
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

-- ScrollingFrame chứa các nút để cuộn mượt mà
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0, 365)
scroll.Position = UDim2.new(0.025, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 530) -- Tăng chiều cao nội dung bên trong
scroll.ScrollBarThickness = 4
scroll.Parent = frame

-- Biến lưu tọa độ vị trí cũ
local oldPosition = nil

-- Hàm tạo nút bấm
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

-- --- KHU VỰC DỊCH CHAT & COPY ---
createSubLabel("🌐 DỊCH ANH - VIỆT", 2)

local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(0.95, 0, 0, 28)
chatBox.Position = UDim2.new(0.02, 0, 0, 22)
chatBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
chatBox.PlaceholderText = "Nhập tiếng Việt..."
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

local translateBtn = createButton("TransBtn", "🔍 Dịch sang English", 54, Color3.fromRGB(0, 120, 255))

-- Ô hiển thị kết quả sau khi dịch
local resultBox = Instance.new("TextBox")
resultBox.Size = UDim2.new(0.95, 0, 0, 28)
resultBox.Position = UDim2.new(0.02, 0, 0, 84)
resultBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
resultBox.PlaceholderText = "Bản dịch sẽ hiện ở đây..."
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

local copyBtn = createButton("CopyBtn", "📋 Copy Bản Dịch", 116, Color3.fromRGB(0, 180, 90))

-- --- SẮP XẾP CÁC NÚT KHÁC ---
createSubLabel("🛠️ SCRIPT KHÁC", 154)
local adminBtn = createButton("Admin", "👑 Nameless Admin", 174, Color3.fromRGB(255, 140, 0))

createSubLabel("🔥 SUPER MEGA VIP", 208)
local smv1 = createButton("SMV1", "1. (-95, 17633, 9039)", 228, Color3.fromRGB(0, 150, 230))
local smv2 = createButton("SMV2", "2. (-124, 17633, 9043)", 256, Color3.fromRGB(0, 150, 230))
local smv3 = createButton("SMV3", "3. (-82, 17633, 9044)", 284, Color3.fromRGB(0, 150, 230))

createSubLabel("💎 VIP", 314)
local vip1 = createButton("VIP1", "1. (-94, 17633, 9357)", 334, Color3.fromRGB(0, 180, 90))

createSubLabel("⭐ MEGA VIP", 364)
local mv1 = createButton("MV1", "1. (-88, 17633, 9224)", 384, Color3.fromRGB(150, 0, 230))
local mv2 = createButton("MV2", "2. (-112, 17633, 9224)", 412, Color3.fromRGB(150, 0, 230))

createSubLabel("⚙️ ĐIỀU HƯỚNG", 442)
local backBtn = createButton("Back", "🔄 Quay lại chỗ cũ", 462, Color3.fromRGB(230, 70, 70))

-- Logic ẩn/hiện bảng khi bấm nút (-)
local isOpen = true
minBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    scroll.Visible = isOpen
    if isOpen then
        frame.Size = UDim2.new(0, 220, 0, 410)
        minBtn.Text = "-"
    else
        frame.Size = UDim2.new(0, 220, 0, 35)
        minBtn.Text = "+"
    end
end)

-- Xử lý nút Dịch thuật
translateBtn.MouseButton1Click:Connect(function()
    local input = chatBox.Text
    if input == "" then return end
    
    local translated = input
    local lowerInput = string.lower(input)
    
    -- Từ điển nhanh
    if string.find(lowerInput, "xin chào") or string.find(lowerInput, "chào") then
        translated = "Hello everyone!"
    elseif string.find(lowerInput, "giúp tôi") or string.find(lowerInput, "cứu") then
        translated = "Help me please!"
    elseif string.find(lowerInput, "cảm ơn") then
        translated = "Thank you so much!"
    elseif string.find(lowerInput, "tạm biệt") then
        translated = "Goodbye!"
    elseif string.find(lowerInput, "đẹp quá") or string.find(lowerInput, "xịn quá") then
        translated = "So cool!"
    elseif string.find(lowerInput, "mọi người") then
        translated = "Hey guys!"
    else
        translated = input -- Giữ nguyên hoặc xử lý hiển thị
    end
    
    resultBox.Text = translated
end)

-- Xử lý nút Copy vào Clipboard
copyBtn.MouseButton1Click:Connect(function()
    local textToCopy = resultBox.Text
    if textToCopy ~= "" then
        pcall(function()
            setclipboard(textToCopy) -- Hàm hỗ trợ copy trên executor Delta
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

-- Gắn sự kiện click các tọa độ
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
    else
        warn("Chưa có lịch sử vị trí cũ!")
    end
end)
