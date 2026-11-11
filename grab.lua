-- =================================================================
-- SCRIPT GRAB.LUA - CÓ TÍNH NĂNG TP TRẢ LẠI VỊ TRÍ CŨ KHI TẮT AUTO KILL
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("GrabMenuGUI") then playerGui.GrabMenuGUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrabMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 235)
frame.Position = UDim2.new(0.72, 0, 0.48, 0)
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

-- Logo nổi độc lập khi thu nhỏ
local floatingLogo = Instance.new("TextButton")
floatingLogo.Size = UDim2.new(0, 35, 0, 35)
floatingLogo.Position = UDim2.new(0.72, 0, 0.48, 0)
floatingLogo.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
floatingLogo.Text = "agg2"
floatingLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingLogo.TextSize = 10
floatingLogo.Font = Enum.Font.GothamBold
floatingLogo.Visible = false
floatingLogo.Active = true
floatingLogo.Draggable = true
floatingLogo.Parent = screenGui

local fLogoCorner = Instance.new("UICorner")
fLogoCorner.CornerRadius = UDim.new(1, 0)
fLogoCorner.Parent = floatingLogo

local fLogoStroke = Instance.new("UIStroke")
fLogoStroke.Color = Color3.fromRGB(255, 255, 255)
fLogoStroke.Thickness = 2
fLogoStroke.Parent = floatingLogo

local logoBtn = Instance.new("TextButton")
logoBtn.Size = UDim2.new(0, 26, 0, 26)
logoBtn.Position = UDim2.new(1, -28, 0, 2)
logoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
logoBtn.Text = "agg2"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
logoBtn.TextSize = 8
logoBtn.Font = Enum.Font.GothamBold
logoBtn.Parent = frame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoBtn.Parent = frame

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Thickness = 1.5
logoStroke.Parent = logoBtn

local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = frame

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
playerInputBox.Parent = contentContainer

local boxCornerGrab = Instance.new("UICorner")
boxCornerGrab.CornerRadius = UDim.new(0, 6)
boxCornerGrab.Parent = playerInputBox

local grabBtn = Instance.new("TextButton")
grabBtn.Size = UDim2.new(0.43, 0, 0, 26)
grabBtn.Position = UDim2.new(0.05, 0, 0, 72)
grabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
grabBtn.Text = "🪝 Grab Người Này"
grabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
grabBtn.TextSize = 10
grabBtn.Font = Enum.Font.GothamBold
grabBtn.Parent = contentContainer

local btnCornerG1 = Instance.new("UICorner")
btnCornerG1.CornerRadius = UDim.new(0, 6)
btnCornerG1.Parent = grabBtn

local autoGrabAllBtn = Instance.new("TextButton")
autoGrabAllBtn.Size = UDim2.new(0.43, 0, 0, 26)
autoGrabAllBtn.Position = UDim2.new(0.52, 0, 0, 72)
autoGrabAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoGrabAllBtn.Text = "🤖 Auto Grab ALL: TẮT"
autoGrabAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGrabAllBtn.TextSize = 9
autoGrabAllBtn.Font = Enum.Font.GothamBold
autoGrabAllBtn.Parent = contentContainer

local btnCornerG2 = Instance.new("UICorner")
btnCornerG2.CornerRadius = UDim.new(0, 6)
btnCornerG2.Parent = autoGrabAllBtn

local autoKillAllBtn = Instance.new("TextButton")
autoKillAllBtn.Size = UDim2.new(0.9, 0, 0, 28)
autoKillAllBtn.Position = UDim2.new(0.05, 0, 0, 105)
autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoKillAllBtn.Text = "⚔️ Auto Kill All (TP Bục + Grab & Thả): TẮT"
autoKillAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKillAllBtn.TextSize = 10
autoKillAllBtn.Font = Enum.Font.GothamBold
autoKillAllBtn.Parent = contentContainer

local btnCornerKillAll = Instance.new("UICorner")
btnCornerKillAll.CornerRadius = UDim.new(0, 6)
btnCornerKillAll.Parent = autoKillAllBtn

local toggleRegionGrabBtn = Instance.new("TextButton")
toggleRegionGrabBtn.Size = UDim2.new(0.9, 0, 0, 26)
toggleRegionGrabBtn.Position = UDim2.new(0.05, 0, 0, 140)
toggleRegionGrabBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleRegionGrabBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
toggleRegionGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleRegionGrabBtn.TextSize = 10
toggleRegionGrabBtn.Font = Enum.Font.GothamBold
toggleRegionGrabBtn.Parent = contentContainer

local btnCornerRegionGrab = Instance.new("UICorner")
btnCornerRegionGrab.CornerRadius = UDim.new(0, 6)
btnCornerRegionGrab.Parent = toggleRegionGrabBtn

local infoStatusLabel = Instance.new("TextLabel")
infoStatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
infoStatusLabel.Position = UDim2.new(0.05, 0, 0, 172)
infoStatusLabel.BackgroundTransparency = 1
infoStatusLabel.Text = "Trạng thái Grab: Sẵn sàng"
infoStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoStatusLabel.TextSize = 10
infoStatusLabel.Font = Enum.Font.Gotham
infoStatusLabel.TextWrapped = true
infoStatusLabel.Parent = contentContainer

logoBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    floatingLogo.Position = frame.Position
    floatingLogo.Visible = true
end)

floatingLogo.MouseButton1Click:Connect(function()
    frame.Position = floatingLogo.Position
    floatingLogo.Visible = false
    frame.Visible = true
end)

local isAutoGrabAllRunning = false
local isAutoKillAllRunning = false
local isUSModeGrab = false
local platformPart = nil
local savedOldPosition = nil -- Lưu vị trí cũ trước khi bật Auto Kill All

local hugRequestRemote = ReplicatedStorage:FindFirstChild("HugRemotes") and ReplicatedStorage.HugRemotes:FindFirstChild("HugRequest")

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
    if platformPart then pcall(function() platformPart:Destroy() end); platformPart = nil end
end

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
        infoStatusLabel.Text = isUSModeGrab and ("Grabbed: " .. targetP.Name) or ("Đã Grab & Thả: " .. targetP.Name)
    else
        infoStatusLabel.Text = isUSModeGrab and "Invalid player name!" or "Vui lòng nhập tên Player hợp lệ!"
    end
end)

autoGrabAllBtn.MouseButton1Click:Connect(function()
    isAutoGrabAllRunning = not isAutoGrabAllRunning
    if isAutoGrabAllRunning then
        autoGrabAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoGrabAllBtn.Text = isUSModeGrab and "Auto Grab ALL: ON" or "Auto Grab ALL: BẬT"
    else
        autoGrabAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoGrabAllBtn.Text = isUSModeGrab and "Auto Grab ALL: OFF" or "Auto Grab ALL: TẮT"
    end
end)

autoKillAllBtn.MouseButton1Click:Connect(function()
    isAutoKillAllRunning = not isAutoKillAllRunning
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if isAutoKillAllRunning then
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoKillAllBtn.Text = isUSModeGrab and "Auto Kill All (TP + Grab): ON" or "Auto Kill All (TP Bục + Grab & Thả): BẬT"
        
        if root then
            savedOldPosition = root.CFrame -- Lưu vị trí hiện tại trước khi TP
        end
        
        createPlatform()
        pcall(function()
            if root then root.CFrame = CFrame.new(-3.050, -54.182, 98.073) end
        end)
    else
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoKillAllBtn.Text = isUSModeGrab and "Auto Kill All (TP + Grab): OFF" or "Auto Kill All (TP Bục + Grab & Thả): TẮT"
        
        removePlatform()
        
        -- TP trả lại vị trí cũ khi tắt Auto Kill All
        if savedOldPosition and root then
            pcall(function()
                root.Anchored = true
                root.CFrame = savedOldPosition
                task.wait(0.2)
                root.Anchored = false
            end)
        end
    end
end)

toggleRegionGrabBtn.MouseButton1Click:Connect(function()
    isUSModeGrab = not isUSModeGrab
    if isUSModeGrab then
        toggleRegionGrabBtn.Text = "🇺🇸 Region: US (English)"
        title.Text = "  🪝 GRAB & KILL ALL MENU"
        grabBtn.Text = "Grab Player"
        autoGrabAllBtn.Text = isAutoGrabAllRunning and "Auto Grab ALL: ON" or "Auto Grab ALL: OFF"
        autoKillAllBtn.Text = isAutoKillAllRunning and "Auto Kill All (TP + Grab): ON" or "Auto Kill All (TP + Grab): OFF"
        playerInputBox.PlaceholderText = "Enter player name..."
        infoStatusLabel.Text = "Status: Ready"
    else
        toggleRegionGrabBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        title.Text = "  🪝 GRAB & KILL ALL MENU"
        grabBtn.Text = "🪝 Grab Người Này"
        autoGrabAllBtn.Text = isAutoGrabAllRunning and "Auto Grab ALL: BẬT" or "Auto Grab ALL: TẮT"
        autoKillAllBtn.Text = isAutoKillAllRunning and "Auto Kill All (TP Bục + Grab & Thả): BẬT" or "Auto Kill All (TP Bục + Grab & Thả): TẮT"
        playerInputBox.PlaceholderText = "Nhập tên Player cần Grab..."
        infoStatusLabel.Text = "Trạng thái Grab: Sẵn sàng"
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoKillAllRunning then
            pcall(function()
                local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local targetPos = Vector3.new(-3.050, -54.182, 98.073)
                    if (root.Position - targetPos).Magnitude > 5 then root.CFrame = CFrame.new(targetPos) end
                end
                for _, p in ipairs(Players:GetPlayers()) do
                    if not isAutoKillAllRunning then break end
                    if p ~= localPlayer and p.Character then
                        local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if pHum and pHum.Health > 0 then grabTargetChar(p.Character); task.wait(0.3) end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoGrabAllRunning and not isAutoKillAllRunning then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if not isAutoGrabAllRunning then break end
                    if p ~= localPlayer and p.Character then
                        local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if pHum and pHum.Health > 0 then grabTargetChar(p.Character); task.wait(0.3) end
                    end
                end
            end)
        end
    end
end)
