-- =================================================================
-- SCRIPT GRAB.LUA - ĐỘC LẬP (TP BỤC, BỎ CHECK, AUTO GRAB & THẢ)
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Xóa GUI Grab cũ nếu đã tồn tại
if playerGui:FindFirstChild("GrabMenuGUI") then
    playerGui.GrabMenuGUI:Destroy()
end

-- Tạo ScreenGui riêng cho Grab
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrabMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 200)
frame.Position = UDim2.new(0.72, 0, 0.45, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "  🪝 GRAB & KILL ALL MENU"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Ô nhập tên Player chọn riêng
local playerInputBox = Instance.new("TextBox")
playerInputBox.Size = UDim2.new(0.9, 0, 0, 24)
playerInputBox.Position = UDim2.new(0.05, 0, 0, 40)
playerInputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
playerInputBox.Text = ""
playerInputBox.PlaceholderText = "Nhập tên Player cần Grab..."
playerInputBox.TextColor3 = Color3.fromRGB(0, 255, 150)
playerInputBox.TextSize = 10
playerInputBox.Font = Enum.Font.GothamBold
playerInputBox.ClearTextOnFocus = false
playerInputBox.Parent = frame

local boxCornerGrab = Instance.new("UICorner")
boxCornerGrab.CornerRadius = UDim.new(0, 6)
boxCornerGrab.Parent = playerInputBox

-- Nút Grab Đơn Player Đã Chọn
local grabBtn = Instance.new("TextButton")
grabBtn.Size = UDim2.new(0.43, 0, 0, 26)
grabBtn.Position = UDim2.new(0.05, 0, 0, 72)
grabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
grabBtn.Text = "🪝 Grab Người Này"
grabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
grabBtn.TextSize = 10
grabBtn.Font = Enum.Font.GothamBold
grabBtn.Parent = frame

local btnCornerG1 = Instance.new("UICorner")
btnCornerG1.CornerRadius = UDim.new(0, 6)
btnCornerG1.Parent = grabBtn

-- Nút Auto Grab All
local autoGrabAllBtn = Instance.new("TextButton")
autoGrabAllBtn.Size = UDim2.new(0.43, 0, 0, 26)
autoGrabAllBtn.Position = UDim2.new(0.52, 0, 0, 72)
autoGrabAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoGrabAllBtn.Text = "🤖 Auto Grab ALL: TẮT"
autoGrabAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGrabAllBtn.TextSize = 9
autoGrabAllBtn.Font = Enum.Font.GothamBold
autoGrabAllBtn.Parent = frame

local btnCornerG2 = Instance.new("UICorner")
btnCornerG2.CornerRadius = UDim.new(0, 6)
btnCornerG2.Parent = autoGrabAllBtn

-- Nút Auto Kill All (TP Bục + Grab & Thả)
local autoKillAllBtn = Instance.new("TextButton")
autoKillAllBtn.Size = UDim2.new(0.9, 0, 0, 28)
autoKillAllBtn.Position = UDim2.new(0.05, 0, 0, 105)
autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoKillAllBtn.Text = "⚔️ Auto Kill All (TP Bục + Grab & Thả): TẮT"
autoKillAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKillAllBtn.TextSize = 10
autoKillAllBtn.Font = Enum.Font.GothamBold
autoKillAllBtn.Parent = frame

local btnCornerKillAll = Instance.new("UICorner")
btnCornerKillAll.CornerRadius = UDim.new(0, 6)
btnCornerKillAll.Parent = autoKillAllBtn

-- Thông báo trạng thái
local infoStatusLabel = Instance.new("TextLabel")
infoStatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
infoStatusLabel.Position = UDim2.new(0.05, 0, 0, 140)
infoStatusLabel.BackgroundTransparency = 1
infoStatusLabel.Text = "Trạng thái Grab: Sẵn sàng"
infoStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoStatusLabel.TextSize = 10
infoStatusLabel.Font = Enum.Font.Gotham
infoStatusLabel.TextWrapped = true
infoStatusLabel.Parent = frame

-- HỆ THỐNG GRAB
local isAutoGrabAllRunning = false
local isAutoKillAllRunning = false
local platformPart = nil

local hugRequestRemote = ReplicatedStorage:FindFirstChild("HugRemotes") 
    and ReplicatedStorage.HugRemotes:FindFirstChild("HugRequest")

-- Tạo bục tại tọa độ chỉ định (-3.050, -54.182, 98.073)
local function createPlatform()
    if platformPart then pcall(function() platformPart:Destroy() end) end
    platformPart = Instance.new("Part")
    platformPart.Size = Vector3.new(10, 1, 10)
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

-- Hàm Grab và Thả trực tiếp (Đã bỏ check rườm rà)
local function grabTargetChar(targetChar)
    if not targetChar then return false end
    return pcall(function()
        if hugRequestRemote then
            hugRequestRemote:FireServer("tryGrab", targetChar)
            task.wait(0.5)
            hugRequestRemote:FireServer("release")
        end
    end)
end

-- Nút Grab Đơn
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
        grabTargetChar(targetP.Character)
        infoStatusLabel.Text = "🪝 Đã Grab & Thả: " .. targetP.Name
        infoStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        infoStatusLabel.Text = "⚠️ Vui lòng nhập tên Player hợp lệ!"
        infoStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Toggle Auto Grab All
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

-- Toggle Auto Kill All (TP Bục + Grab & Thả)
autoKillAllBtn.MouseButton1Click:Connect(function()
    isAutoKillAllRunning = not isAutoKillAllRunning
    if isAutoKillAllRunning then
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoKillAllBtn.Text = "⚔️ Auto Kill All (TP Bục + Grab & Thả): BẬT"
        infoStatusLabel.Text = "⚔️ Đã TP tới bục & bắt đầu Auto Kill All..."
        infoStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
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
        infoStatusLabel.Text = "Đã dừng Auto Kill All."
        infoStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        removePlatform()
    end
end)

-- Loop Auto Kill All
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

                if isAutoKillAllRunning then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if not isAutoKillAllRunning then break end
                        if p ~= localPlayer and p.Character then
                            local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                            if pHum and pHum.Health > 0 then
                                infoStatusLabel.Text = "⚔️ Đang Kill All: " .. p.Name
                                infoStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                                grabTargetChar(p.Character)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Loop Auto Grab All
task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoGrabAllRunning and not isAutoKillAllRunning then
            pcall(function()
                if isAutoGrabAllRunning then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if not isAutoGrabAllRunning then break end
                        if p ~= localPlayer and p.Character then
                            local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                            if pHum and pHum.Health > 0 then
                                grabTargetChar(p.Character)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

print("✅ Đã tải xong script grab.lua độc lập (Không có check rườm rà)!")
