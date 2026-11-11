-- =================================================================
-- SCRIPT SLAP.LUA - CẬP NHẬT ĐƯỜNG DẪN HUGBUTTONS CHUẨN XÁC
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

-- Tạo khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 545)
frame.Position = UDim2.new(0.72, 0, 0.1, 0)
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
title.Text = "  👀 DÒ SAU & KILL ALL MENU"
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

-- 5. Nút Auto Quay Hộp Fast
local toggleFastCaseBtn = Instance.new("TextButton")
toggleFastCaseBtn.Size = UDim2.new(0.9, 0, 0, 26)
toggleFastCaseBtn.Position = UDim2.new(0.05, 0, 0, 182)
toggleFastCaseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleFastCaseBtn.Text = "⚡ Auto Quay Hộp: TẮT"
toggleFastCaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFastCaseBtn.TextSize = 11
toggleFastCaseBtn.Font = Enum.Font.GothamBold
toggleFastCaseBtn.Parent = contentContainer

local btnCorner5 = Instance.new("UICorner")
btnCorner5.CornerRadius = UDim.new(0, 6)
btnCorner5.Parent = toggleFastCaseBtn

-- =================================================================
-- PHẦN GRAB & AUTO KILL ALL SECTION
-- =================================================================
local grabTitle = Instance.new("TextLabel")
grabTitle.Size = UDim2.new(0.9, 0, 0, 18)
grabTitle.Position = UDim2.new(0.05, 0, 0, 215)
grabTitle.BackgroundTransparency = 1
grabTitle.Text = "🪝 HỆ THỐNG GRAB & KILL ALL:"
grabTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
grabTitle.TextSize = 10
grabTitle.Font = Enum.Font.GothamBold
grabTitle.TextXAlignment = Enum.TextXAlignment.Left
grabTitle.Parent = contentContainer

-- Ô nhập tên Player chọn riêng
local playerInputBox = Instance.new("TextBox")
playerInputBox.Size = UDim2.new(0.9, 0, 0, 24)
playerInputBox.Position = UDim2.new(0.05, 0, 0, 235)
playerInputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
playerInputBox.Text = ""
playerInputBox.PlaceholderText = "Nhập tên Player cần Grab..."
playerInputBox.TextColor3 = Color3.fromRGB(0, 255, 150)
playerInputBox.TextSize = 10
playerInputBox.Font = Enum.Font.GothamBold
playerInputBox.ClearTextOnFocus = false
playerInputBox.Parent = contentContainer

local boxCornerGrab = Instance.new("UICorner")
boxCornerGrab.CornerRadius = UDim.new(0, 6)
boxCornerGrab.Parent = playerInputBox

-- Nút Grab Đơn Player Đã Chọn
local grabBtn = Instance.new("TextButton")
grabBtn.Size = UDim2.new(0.43, 0, 0, 26)
grabBtn.Position = UDim2.new(0.05, 0, 0, 265)
grabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
grabBtn.Text = "🪝 Grab Người Này"
grabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
grabBtn.TextSize = 10
grabBtn.Font = Enum.Font.GothamBold
grabBtn.Parent = contentContainer

local btnCornerG1 = Instance.new("UICorner")
btnCornerG1.CornerRadius = UDim.new(0, 6)
btnCornerG1.Parent = grabBtn

-- Nút Auto Grab All
local autoGrabAllBtn = Instance.new("TextButton")
autoGrabAllBtn.Size = UDim2.new(0.43, 0, 0, 26)
autoGrabAllBtn.Position = UDim2.new(0.52, 0, 0, 265)
autoGrabAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoGrabAllBtn.Text = "🤖 Auto Grab ALL: TẮT"
autoGrabAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGrabAllBtn.TextSize = 9
autoGrabAllBtn.Font = Enum.Font.GothamBold
autoGrabAllBtn.Parent = contentContainer

local btnCornerG2 = Instance.new("UICorner")
btnCornerG2.CornerRadius = UDim.new(0, 6)
btnCornerG2.Parent = autoGrabAllBtn

-- NÚT AUTO KILL ALL (TP BỤC + GRAB & THẢ + VỀ VỊ TRÍ CŨ KHI TẮT)
local autoKillAllBtn = Instance.new("TextButton")
autoKillAllBtn.Size = UDim2.new(0.9, 0, 0, 28)
autoKillAllBtn.Position = UDim2.new(0.05, 0, 0, 298)
autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoKillAllBtn.Text = "⚔️ Auto Kill All (TP Bục + Grab & Thả): TẮT"
autoKillAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKillAllBtn.TextSize = 10
autoKillAllBtn.Font = Enum.Font.GothamBold
autoKillAllBtn.Parent = contentContainer

local btnCornerKillAll = Instance.new("UICorner")
btnCornerKillAll.CornerRadius = UDim.new(0, 6)
btnCornerKillAll.Parent = autoKillAllBtn

-- Thông báo trạng thái chi tiết
local infoStatusLabel = Instance.new("TextLabel")
infoStatusLabel.Size = UDim2.new(0.9, 0, 0, 75)
infoStatusLabel.Position = UDim2.new(0.05, 0, 0, 335)
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
        frame.Size = UDim2.new(0, 240, 0, 545)
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
local isFastCaseRunning = false
local isAutoGrabAllRunning = false
local isAutoKillAllRunning = false

local originalPosition = nil -- Lưu vị trí cũ trước khi TP đến bục

local detectedPlayerName = nil
local lastGuessFiredTime = 0
local meterStartTime = nil
local hasFiredMeter = false

local openCaseRemote = ReplicatedStorage:FindFirstChild("Remotes") 
    and ReplicatedStorage.Remotes:FindFirstChild("Cases") 
    and ReplicatedStorage.Remotes.Cases:FindFirstChild("OpenCase")

local hugRequestRemote = ReplicatedStorage:FindFirstChild("HugRemotes") 
    and ReplicatedStorage.HugRemotes:FindFirstChild("HugRequest")

-- HÀM TẠO BỤC DƯỚI CHÂN TẠI (-3.050, -54.182, 98.073)
local platformPart = nil
local function createPlatform()
    if platformPart then pcall(function() platformPart:Destroy() end) end
    platformPart = Instance.new("Part")
    platformPart.Size = Vector3.new(12, 1, 12)
    platformPart.Position = Vector3.new(-3.050, -54.182 - 3, 98.073)
    platformPart.Anchored = true
    platformPart.CanCollide = true
    platformPart.Transparency = 0.3
    platformPart.BrickColor = BrickColor.new("Bright blue")
    platformPart.Parent = workspace
end

local function removePlatform()
    if platformPart then
        pcall(function() platformPart:Destroy() end)
        platformPart = nil
    end
end

-- HÀM CHECK HUGBUTTONS (ĐƯỜNG DẪN CHUẨN: NewUI.HugButtons)
local function getHugButtonsGui()
    local pGui = localPlayer:FindFirstChild("PlayerGui")
    local newUI = pGui and pGui:FindFirstChild("NewUI")
    return newUI and newUI:FindFirstChild("HugButtons")
end

local function isHugButtonsVisible()
    local hugButtons = getHugButtonsGui()
    if hugButtons then
        if hugButtons:IsA("GuiObject") and hugButtons.Visible and hugButtons.AbsoluteSize.X > 0 then
            return true
        end
        for _, child in ipairs(hugButtons:GetDescendants()) do
            if child:IsA("GuiObject") and child.Visible and child.AbsoluteSize.X > 0 then
                return true
            end
        end
    end
    return false
end

-- HÀM KÍCH HOẠT NÚT THẢ TRONG HUGBUTTONS
local function triggerReleaseButton()
    pcall(function()
        local hugButtons = getHugButtonsGui()
        if hugButtons then
            for _, btn in ipairs(hugButtons:GetDescendants()) do
                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                    if getconnections then
                        for _, conn in pairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
                        for _, conn in pairs(getconnections(btn.Activated)) do conn:Fire() end
                    else
                        btn:Activate()
                    end
                end
            end
        end
    end)
end

-- HÀM GRAB VÀ THẢ
local function grabAndReleaseTarget(targetChar)
    if not targetChar then return false end
    return pcall(function()
        if hugRequestRemote then
            hugRequestRemote:FireServer("tryGrab", targetChar)
            task.wait(0.4)
            triggerReleaseButton()
        end
    end)
end

-- NÚT GRAB ĐƠN
grabBtn.MouseButton1Click:Connect(function()
    local nameText = playerInputBox.Text
    local targetP = nil
    if nameText ~= "" then
        for _, p in ipairs(Players:GetPlayers()) do
            if string.find(string.lower(p.Name), string.lower(nameText)) or string.find(string.lower(p.DisplayName), string.lower(nameText)) then
                targetP = p
                break
            end
        end
    end
    
    if targetP and targetP.Character then
        grabAndReleaseTarget(targetP.Character)
        infoStatusLabel.Text = "🪝 Đã Grab & Thả: " .. targetP.Name
        infoStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        infoStatusLabel.Text = "⚠️ Vui lòng nhập tên Player hợp lệ!"
        infoStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- TOGGLE AUTO GRAB ALL
autoGrabAllBtn.MouseButton1Click:Connect(function()
    isAutoGrabAllRunning = not isAutoGrabAllRunning
    if isAutoGrabAllRunning then
        autoGrabAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoGrabAllBtn.Text = "🤖 Auto Grab ALL: BẬT"
        infoStatusLabel.Text = "🤖 Đang Auto Grab ALL..."
        infoStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        autoGrabAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoGrabAllBtn.Text = "🤖 Auto Grab ALL: TẮT"
        infoStatusLabel.Text = "Đã dừng Auto Grab ALL."
        infoStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- TOGGLE AUTO KILL ALL (LƯU VỊ TRÍ CŨ -> TP BỤC -> KHI TẮT TP VỀ VỊ TRÍ CŨ)
autoKillAllBtn.MouseButton1Click:Connect(function()
    isAutoKillAllRunning = not isAutoKillAllRunning
    if isAutoKillAllRunning then
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoKillAllBtn.Text = "⚔️ Auto Kill All (TP Bục + Grab & Thả): BẬT"
        infoStatusLabel.Text = "⚔️ Đã TP tới bục & bắt đầu Auto Kill All..."
        infoStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Lưu lại vị trí cũ trước khi Teleport đến bục
        pcall(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                originalPosition = root.CFrame
            end
        end)
        
        createPlatform()
        pcall(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(-3.050, -54.182, 98.073)
            end
        end)
    else
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoKillAllBtn.Text = "⚔️ Auto Kill All (TP Bục + Grab & Thả): TẮT"
        infoStatusLabel.Text = "Đã dừng Auto Kill All. Đang về vị trí cũ..."
        infoStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        removePlatform()
        
        -- Teleport trả về vị trí cũ khi tắt
        pcall(function()
            if originalPosition then
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = originalPosition
                end
                originalPosition = nil
            end
        end)
    end
end)

-- LOOP AUTO KILL ALL (TP BỤC + GRAB & THẢ LIÊN TỤC)
task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoKillAllRunning then
            pcall(function()
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local targetPos = Vector3.new(-3.050, -54.182, 98.073)
                    if (root.Position - targetPos).Magnitude > 5 then
                        root.CFrame = CFrame.new(targetPos)
                    end
                end

                if isHugButtonsVisible() then
                    while isHugButtonsVisible() and isAutoKillAllRunning do
                        task.wait(0.2)
                    end
                end

                if isAutoKillAllRunning then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if not isAutoKillAllRunning then break end
                        
                        if p ~= localPlayer and p.Character then
                            local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                            if pHum and pHum.Health > 0 then
                                infoStatusLabel.Text = "⚔️ Đang Kill All: " .. p.Name
                                infoStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                                
                                grabAndReleaseTarget(p.Character)
                                task.wait(0.5)
                                
                                if isHugButtonsVisible() then
                                    while isHugButtonsVisible() and isAutoKillAllRunning do
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- LOOP AUTO GRAB ALL THƯỜNG
task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoGrabAllRunning and not isAutoKillAllRunning then
            pcall(function()
                if isHugButtonsVisible() then
                    while isHugButtonsVisible() and isAutoGrabAllRunning do
                        task.wait(0.2)
                    end
                end

                if isAutoGrabAllRunning then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if not isAutoGrabAllRunning then break end
                        if p ~= localPlayer and p.Character then
                            local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                            if pHum and pHum.Health > 0 then
                                grabAndReleaseTarget(p.Character)
                                task.wait(0.4)
                                if isHugButtonsVisible() then
                                    while isHugButtonsVisible() and isAutoGrabAllRunning do
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 1. Toggle Dò Phía Sau
toggleBehindBtn.MouseButton1Click:Connect(function()
    isBehindRunning = not isBehindRunning
    if isBehindRunning then
        toggleBehindBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleBehindBtn.Text = "Dò Phía Sau: BẬT"
    else
        toggleBehindBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleBehindBtn.Text = "Dò Phía Sau: TẮT"
        statusLabel.Text = "Đã dừng dò tìm."
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- 2. Toggle Auto Slap
toggleSlapBtn.MouseButton1Click:Connect(function()
    isAutoSlapRunning = not isAutoSlapRunning
    if isAutoSlapRunning then
        toggleSlapBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleSlapBtn.Text = "Auto Slap: BẬT"
    else
        toggleSlapBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleSlapBtn.Text = "Auto Slap: TẮT"
    end
end)

-- 3. Toggle Auto Đoán
toggleAutoGuessBtn.MouseButton1Click:Connect(function()
    isAutoGuessRunning = not isAutoGuessRunning
    if isAutoGuessRunning then
        toggleAutoGuessBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleAutoGuessBtn.Text = "Auto Đoán: BẬT"
    else
        toggleAutoGuessBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleAutoGuessBtn.Text = "Auto Đoán: TẮT"
    end
end)

-- 4. Toggle Auto Đo
toggleAutoMeterBtn.MouseButton1Click:Connect(function()
    isAutoMeterRunning = not isAutoMeterRunning
    if isAutoMeterRunning then
        toggleAutoMeterBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleAutoMeterBtn.Text = "Đo: BẬT"
        meterStartTime = nil
        hasFiredMeter = false
    else
        toggleAutoMeterBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleAutoMeterBtn.Text = "Đo: TẮT"
        meterStartTime = nil
        hasFiredMeter = false
    end
end)

-- 5. Toggle Auto Quay Hộp Fast
toggleFastCaseBtn.MouseButton1Click:Connect(function()
    isFastCaseRunning = not isFastCaseRunning
    if isFastCaseRunning then
        toggleFastCaseBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        toggleFastCaseBtn.Text = "⚡ Auto Quay Hộp: BẬT"
    else
        toggleFastCaseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleFastCaseBtn.Text = "⚡ Auto Quay Hộp: TẮT"
    end
end)

-- LOOP AUTO QUAY HỘP FAST
task.spawn(function()
    local args = { [1] = "frost", [2] = true }
    while true do
        task.wait(0.01)
        if isFastCaseRunning then
            pcall(function()
                local remote = openCaseRemote or (ReplicatedStorage:FindFirstChild("Remotes") 
                    and ReplicatedStorage.Remotes:FindFirstChild("Cases") 
                    and ReplicatedStorage.Remotes.Cases:FindFirstChild("OpenCase"))
                if remote then remote:FireServer(unpack(args)) end
            end)
        end
    end
end)

-- LOOP 1: DÒ NGƯỜI PHÍA SAU
RunService.RenderStepped:Connect(function()
    if not isBehindRunning then return end
    
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then
        statusLabel.Text = "Không tìm thấy nhân vật!"
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
        statusLabel.Text = string.format("⚠️ Có [%s] phía sau!\nKhoảng cách: %.1f studs", closestPlayer, minDistance)
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        detectedPlayerName = nil
        statusLabel.Text = "✅ An toàn: Phía sau trống."
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

print("✅ Đã cập nhật xong đường dẫn NewUI.HugButtons cho toàn bộ script slap.lua!")
