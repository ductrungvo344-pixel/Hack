-- =================================================================
-- SCRIPT SLAP.LUA - CÓ NÚT CHUYỂN US/VN
-- =================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu đã tồn tại
if playerGui:FindFirstChild("BehindDetectorGUI") then
    playerGui.BehindDetectorGUI:Destroy()
end

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BehindDetectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tạo khung chính (tăng chiều cao một chút để chứa nút mới)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 310)
frame.Position = UDim2.new(0.72, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "  👀 DÒ SAU & AUTO SLAP"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- NÚT THU NHỎ / MỞ RỘNG (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 26, 0, 22)
minimizeBtn.Position = UDim2.new(1, -28, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = frame

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 4)
minBtnCorner.Parent = minimizeBtn

-- Container chứa các thành phần để ẩn/hiện khi thu nhỏ
local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = frame

-- Nhãn trạng thái dò người phía sau
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 28)
statusLabel.Position = UDim2.new(0.05, 0, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Đang quét người phía sau..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextWrapped = true
statusLabel.Parent = contentContainer

-- 1. Nút Bật/Tắt Dò Phía Sau
local toggleBehindBtn = Instance.new("TextButton")
toggleBehindBtn.Size = UDim2.new(0.9, 0, 0, 24)
toggleBehindBtn.Position = UDim2.new(0.05, 0, 0, 68)
toggleBehindBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
toggleBehindBtn.Text = "Dò Phía Sau: BẬT"
toggleBehindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBehindBtn.TextSize = 11
toggleBehindBtn.Font = Enum.Font.GothamBold
toggleBehindBtn.Parent = contentContainer

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 6)
btnCorner1.Parent = toggleBehindBtn

-- 2. Nút Bật/Tắt Auto Slap
local toggleSlapBtn = Instance.new("TextButton")
toggleSlapBtn.Size = UDim2.new(0.9, 0, 0, 24)
toggleSlapBtn.Position = UDim2.new(0.05, 0, 0, 96)
toggleSlapBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleSlapBtn.Text = "Auto Slap: TẮT"
toggleSlapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleSlapBtn.TextSize = 11
toggleSlapBtn.Font = Enum.Font.GothamBold
toggleSlapBtn.Parent = contentContainer

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = toggleSlapBtn

-- 3. Nút Bật/Tắt Auto Đoán
local toggleAutoGuessBtn = Instance.new("TextButton")
toggleAutoGuessBtn.Size = UDim2.new(0.9, 0, 0, 24)
toggleAutoGuessBtn.Position = UDim2.new(0.05, 0, 0, 124)
toggleAutoGuessBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleAutoGuessBtn.Text = "Auto Đoán: TẮT"
toggleAutoGuessBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAutoGuessBtn.TextSize = 11
toggleAutoGuessBtn.Font = Enum.Font.GothamBold
toggleAutoGuessBtn.Parent = contentContainer

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 6)
btnCorner3.Parent = toggleAutoGuessBtn

-- 4. Ô nhập giá trị Auto Đo
local customMeterInput = Instance.new("TextBox")
customMeterInput.Size = UDim2.new(0.55, 0, 0, 24)
customMeterInput.Position = UDim2.new(0.05, 0, 0, 152)
customMeterInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
customMeterInput.Text = "1"
customMeterInput.TextColor3 = Color3.fromRGB(255, 255, 255)
customMeterInput.TextSize = 11
customMeterInput.Font = Enum.Font.GothamBold
customMeterInput.PlaceholderText = "Nhập giá trị..."
customMeterInput.ClearTextOnFocus = false
customMeterInput.Parent = contentContainer

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = customMeterInput

-- Nút Bật/Tắt Auto Đo
local toggleAutoMeterBtn = Instance.new("TextButton")
toggleAutoMeterBtn.Size = UDim2.new(0.32, 0, 0, 24)
toggleAutoMeterBtn.Position = UDim2.new(0.63, 0, 0, 152)
toggleAutoMeterBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleAutoMeterBtn.Text = "Đo: TẮT"
toggleAutoMeterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAutoMeterBtn.TextSize = 11
toggleAutoMeterBtn.Font = Enum.Font.GothamBold
toggleAutoMeterBtn.Parent = contentContainer

local btnCorner4 = Instance.new("UICorner")
btnCorner4.CornerRadius = UDim.new(0, 6)
btnCorner4.Parent = toggleAutoMeterBtn

-- 5. NÚT CHUYỂN US/VN
local toggleRegionBtn = Instance.new("TextButton")
toggleRegionBtn.Size = UDim2.new(0.9, 0, 0, 26)
toggleRegionBtn.Position = UDim2.new(0.05, 0, 0, 182)
toggleRegionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleRegionBtn.Text = "🌍 Khu vực: VN (Tiếng Việt)"
toggleRegionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleRegionBtn.TextSize = 10
toggleRegionBtn.Font = Enum.Font.GothamBold
toggleRegionBtn.Parent = contentContainer

local btnCornerRegion = Instance.new("UICorner")
btnCornerRegion.CornerRadius = UDim.new(0, 6)
btnCornerRegion.Parent = toggleRegionBtn

-- Thông báo trạng thái chi tiết
local infoStatusLabel = Instance.new("TextLabel")
infoStatusLabel.Size = UDim2.new(0.9, 0, 0, 65)
infoStatusLabel.Position = UDim2.new(0.05, 0, 0, 214)
infoStatusLabel.BackgroundTransparency = 1
infoStatusLabel.Text = "Trạng thái: Sẵn sàng"
infoStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoStatusLabel.TextSize = 10
infoStatusLabel.Font = Enum.Font.Gotham
infoStatusLabel.TextWrapped = true
infoStatusLabel.Parent = contentContainer

-- LOGIC THU NHỎ / MỞ RỘNG
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        minimizeBtn.Text = "+"
        frame.Size = UDim2.new(0, 240, 0, 30)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = false
            end
        end
    else
        minimizeBtn.Text = "-"
        frame.Size = UDim2.new(0, 240, 0, 310)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = true
            end
        end
    end
end)

-- HỆ THỐNG CHÍNH
math.randomseed(tick())
local isBehindRunning = true
local isAutoSlapRunning = false
local isAutoGuessRunning = false
local isAutoMeterRunning = false
local isUSMode = false

local detectedPlayerName = nil
local lastGuessFiredTime = 0
local meterStartTime = nil
local hasFiredMeter = false

-- 1. Toggle Dò Phía Sau
toggleBehindBtn.MouseButton1Click:Connect(function()
    isBehindRunning = not isBehindRunning
    if isBehindRunning then
        toggleBehindBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleBehindBtn.Text = isUSMode and "Behind Detector: ON" or "Dò Phía Sau: BẬT"
    else
        toggleBehindBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleBehindBtn.Text = isUSMode and "Behind Detector: OFF" or "Dò Phía Sau: TẮT"
        statusLabel.Text = isUSMode and "Scanning stopped." or "Đã dừng dò tìm."
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- 2. Toggle Auto Slap
toggleSlapBtn.MouseButton1Click:Connect(function()
    isAutoSlapRunning = not isAutoSlapRunning
    if isAutoSlapRunning then
        toggleSlapBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleSlapBtn.Text = isUSMode and "Auto Slap: ON" or "Auto Slap: BẬT"
    else
        toggleSlapBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleSlapBtn.Text = isUSMode and "Auto Slap: OFF" or "Auto Slap: TẮT"
    end
end)

-- 3. Toggle Auto Đoán
toggleAutoGuessBtn.MouseButton1Click:Connect(function()
    isAutoGuessRunning = not isAutoGuessRunning
    if isAutoGuessRunning then
        toggleAutoGuessBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleAutoGuessBtn.Text = isUSMode and "Auto Guess: ON" or "Auto Đoán: BẬT"
    else
        toggleAutoGuessBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleAutoGuessBtn.Text = isUSMode and "Auto Guess: OFF" or "Auto Đoán: TẮT"
    end
end)

-- 4. Toggle Auto Đo
toggleAutoMeterBtn.MouseButton1Click:Connect(function()
    isAutoMeterRunning = not isAutoMeterRunning
    if isAutoMeterRunning then
        toggleAutoMeterBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleAutoMeterBtn.Text = isUSMode and "Meter: ON" or "Đo: BẬT"
        meterStartTime = nil
        hasFiredMeter = false
    else
        toggleAutoMeterBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleAutoMeterBtn.Text = isUSMode and "Meter: OFF" or "Đo: TẮT"
        meterStartTime = nil
        hasFiredMeter = false
    end
end)

-- 5. LOGIC CHUYỂN US/VN
toggleRegionBtn.MouseButton1Click:Connect(function()
    isUSMode = not isUSMode
    if isUSMode then
        toggleRegionBtn.Text = "🇺🇸 Region: US (English)"
        title.Text = "  👀 BEHIND & AUTO SLAP"
        infoStatusLabel.Text = "Status: Switched to English (US)"
    else
        toggleRegionBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        title.Text = "  👀 DÒ SAU & AUTO SLAP"
        infoStatusLabel.Text = "Trạng thái: Đã chuyển sang Tiếng Việt (VN)"
    end
end)

-- LOOP 1: DÒ NGƯỜI PHÍA SAU
RunService.RenderStepped:Connect(function()
    if not isBehindRunning then return end
    
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then
        statusLabel.Text = isUSMode and "Character not found!" or "Không tìm thấy nhân vật!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        detectedPlayerName = nil
        return
    end
    
    local myPos = rootPart.Position
    local myLookVec = rootPart.CFrame.LookVector
    local closestPlayer = nil
    local minDistance = 35
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local otherHumanoid = player.Character:FindFirstChild("Humanoid")
            
            if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                local otherPos = otherRoot.Position
                local dirToOther = (otherPos - myPos).Unit
                local dotProduct = myLookVec:Dot(dirToOther)
                local distance = (otherPos - myPos).Magnitude
                
                if dotProduct < -0.2 and distance < minDistance then
                    minDistance = distance
                    closestPlayer = player.Name
                end
            end
        end
    end
    
    if closestPlayer then
        detectedPlayerName = closestPlayer
        if isUSMode then
            statusLabel.Text = string.format("⚠️ [%s] is behind you!\nDistance: %.1f studs", closestPlayer, minDistance)
        else
            statusLabel.Text = string.format("⚠️ Có [%s] phía sau!\nKhoảng cách: %.1f studs", closestPlayer, minDistance)
        end
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        detectedPlayerName = nil
        statusLabel.Text = isUSMode and "✅ Safe: Behind is clear." or "✅ An toàn: Phía sau trống."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    end
end)

-- LOOP 2: AUTO SLAP
task.spawn(function()
    while true do
        local randomDelay = math.random(200, 400) / 1000
        task.wait(randomDelay)
        
        if isAutoSlapRunning then
            pcall(function()
                local pGui = localPlayer:FindFirstChild("PlayerGui")
                local sGui = pGui and pGui:FindFirstChild("ScreenGui")
                local slapBtn = sGui and sGui:FindFirstChild("slapbut")
                
                if slapBtn and slapBtn:IsA("GuiObject") and slapBtn.Visible and slapBtn.AbsoluteSize.X > 0 then
                    if getconnections then
                        for _, connection in pairs(getconnections(slapBtn.MouseButton1Click)) do
                            connection:Fire()
                        end
                    else
                        slapBtn:Activate()
                    end
                end
            end)
        end
    end
end)

-- LOOP 3: AUTO ĐOÁN
task.spawn(function()
    while true do
        task.wait(0.05)
        if isAutoGuessRunning then
            pcall(function()
                local pGui = localPlayer:FindFirstChild("PlayerGui")
                local sGui = pGui and pGui:FindFirstChild("ScreenGui")
                local suspectsGui = sGui and sGui:FindFirstChild("suspects")
                
                if suspectsGui and (tick() - lastGuessFiredTime > 1.0) then
                    if detectedPlayerName then
                        lastGuessFiredTime = tick()
                        local guessEvent = ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("Guess")
                        if guessEvent then guessEvent:FireServer(detectedPlayerName) end
                    end
                end
            end)
        end
    end
end)

-- LOOP 4: AUTO ĐO
task.spawn(function()
    while true do
        task.wait(0.05)
        if isAutoMeterRunning then
            pcall(function()
                local pGui = localPlayer:FindFirstChild("PlayerGui")
                local sGui = pGui and pGui:FindFirstChild("ScreenGui")
                local meterGui = sGui and sGui:FindFirstChild("meter")
                
                if meterGui then
                    if not hasFiredMeter then
                        if not meterStartTime then
                            meterStartTime = tick()
                        elseif tick() - meterStartTime >= 1.89 then
                            hasFiredMeter = true
                            local customVal = tonumber(customMeterInput.Text) or 1
                            local sendSlapEvent = ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("SendSlap")
                            if sendSlapEvent then sendSlapEvent:FireServer(customVal) end
                        end
                    end
                else
                    meterStartTime = nil
                    hasFiredMeter = false
                end
            end)
        else
            meterStartTime = nil
            hasFiredMeter = false
        end
    end
end)

print("✅ slap.lua loaded with US/VN toggle!")
