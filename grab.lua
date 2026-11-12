-- =================================================================
-- SCRIPT GRAB.LUA - CÓ CHỌN MỤC TIÊU, AUTO KILL, AUTO GRAB & FREE CAM
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

if playerGui:FindFirstChild("GrabMenuGUI") then playerGui.GrabMenuGUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrabMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tăng chiều cao khung chính để chứa các nút mới
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 310)
frame.Position = UDim2.new(0.72, 0, 0.42, 0)
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
title.Text = "  🪝 GRAB, KILL & FREE CAM"
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
floatingLogo.Position = UDim2.new(0.72, 0, 0.42, 0)
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

-- Khung nhập tên Player / Mục tiêu
local playerInputBox = Instance.new("TextBox")
playerInputBox.Size = UDim2.new(0.9, 0, 0, 24)
playerInputBox.Position = UDim2.new(0.05, 0, 0, 38)
playerInputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
playerInputBox.Text = ""
playerInputBox.PlaceholderText = "Nhập tên hoặc chọn mục tiêu bên dưới..."
playerInputBox.TextColor3 = Color3.fromRGB(0, 255, 150)
playerInputBox.TextSize = 10
playerInputBox.Font = Enum.Font.GothamBold
playerInputBox.ClearTextOnFocus = false
playerInputBox.Parent = contentContainer

local boxCornerGrab = Instance.new("UICorner")
boxCornerGrab.CornerRadius = UDim.new(0, 6)
boxCornerGrab.Parent = playerInputBox

-- Nút cuộn danh sách chọn Player nhanh
local selectTargetBtn = Instance.new("TextButton")
selectTargetBtn.Size = UDim2.new(0.9, 0, 0, 24)
selectTargetBtn.Position = UDim2.new(0.05, 0, 0, 67)
selectTargetBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
selectTargetBtn.Text = "👥 Chọn người chơi tiếp theo (Đổi mục tiêu)"
selectTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectTargetBtn.TextSize = 9
selectTargetBtn.Font = Enum.Font.GothamBold
selectTargetBtn.Parent = contentContainer

local btnCornerTarget = Instance.new("UICorner")
btnCornerTarget.CornerRadius = UDim.new(0, 6)
btnCornerTarget.Parent = selectTargetBtn

-- Nút Grab đơn & Auto Grab Mục tiêu
local grabBtn = Instance.new("TextButton")
grabBtn.Size = UDim2.new(0.43, 0, 0, 26)
grabBtn.Position = UDim2.new(0.05, 0, 0, 96)
grabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
grabBtn.Text = "🪝 Grab Mục Tiêu"
grabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
grabBtn.TextSize = 10
grabBtn.Font = Enum.Font.GothamBold
grabBtn.Parent = contentContainer

local btnCornerG1 = Instance.new("UICorner")
btnCornerG1.CornerRadius = UDim.new(0, 6)
btnCornerG1.Parent = grabBtn

local autoGrabTargetBtn = Instance.new("TextButton")
autoGrabTargetBtn.Size = UDim2.new(0.43, 0, 0, 26)
autoGrabTargetBtn.Position = UDim2.new(0.52, 0, 0, 96)
autoGrabTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoGrabTargetBtn.Text = "🤖 Auto Grab Mục Tiêu: TẮT"
autoGrabTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGrabTargetBtn.TextSize = 8
autoGrabTargetBtn.Font = Enum.Font.GothamBold
autoGrabTargetBtn.Parent = contentContainer

local btnCornerG2 = Instance.new("UICorner")
btnCornerG2.CornerRadius = UDim.new(0, 6)
btnCornerG2.Parent = autoGrabTargetBtn

-- Nút Auto Kill Mục Tiêu (Có bục TP)
local autoKillTargetBtn = Instance.new("TextButton")
autoKillTargetBtn.Size = UDim2.new(0.9, 0, 0, 26)
autoKillTargetBtn.Position = UDim2.new(0.05, 0, 0, 127)
autoKillTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoKillTargetBtn.Text = "🎯 Auto Kill Mục Tiêu (TP Bục + Grab): TẮT"
autoKillTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKillTargetBtn.TextSize = 9
autoKillTargetBtn.Font = Enum.Font.GothamBold
autoKillTargetBtn.Parent = contentContainer

local btnCornerKillTarget = Instance.new("UICorner")
btnCornerKillTarget.CornerRadius = UDim.new(0, 6)
btnCornerKillTarget.Parent = autoKillTargetBtn

-- Nút Auto Kill All
local autoKillAllBtn = Instance.new("TextButton")
autoKillAllBtn.Size = UDim2.new(0.9, 0, 0, 26)
autoKillAllBtn.Position = UDim2.new(0.05, 0, 0, 158)
autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoKillAllBtn.Text = "⚔️ Auto Kill All: TẮT"
autoKillAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKillAllBtn.TextSize = 9
autoKillAllBtn.Font = Enum.Font.GothamBold
autoKillAllBtn.Parent = contentContainer

local btnCornerKillAll = Instance.new("UICorner")
btnCornerKillAll.CornerRadius = UDim.new(0, 6)
btnCornerKillAll.Parent = autoKillAllBtn

-- Nút Free Cam
local freeCamBtn = Instance.new("TextButton")
freeCamBtn.Size = UDim2.new(0.9, 0, 0, 26)
freeCamBtn.Position = UDim2.new(0.05, 0, 0, 189)
freeCamBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
freeCamBtn.Text = "🎥 Free Cam (Bay tự do): TẮT"
freeCamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freeCamBtn.TextSize = 9
freeCamBtn.Font = Enum.Font.GothamBold
freeCamBtn.Parent = contentContainer

local btnCornerFreeCam = Instance.new("UICorner")
btnCornerFreeCam.CornerRadius = UDim.new(0, 6)
btnCornerFreeCam.Parent = freeCamBtn

-- Nút chuyển US/VN
local toggleRegionGrabBtn = Instance.new("TextButton")
toggleRegionGrabBtn.Size = UDim2.new(0.9, 0, 0, 24)
toggleRegionGrabBtn.Position = UDim2.new(0.05, 0, 0, 220)
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
infoStatusLabel.Size = UDim2.new(0.9, 0, 0, 45)
infoStatusLabel.Position = UDim2.new(0.05, 0, 0, 249)
infoStatusLabel.BackgroundTransparency = 1
infoStatusLabel.Text = "Trạng thái: Sẵn sàng"
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

local isAutoGrabTargetRunning = false
local isAutoKillTargetRunning = false
local isAutoKillAllRunning = false
local isFreeCamRunning = false
local isUSModeGrab = false
local platformPart = nil
local savedOldPosition = nil
local freeCamConnection = nil

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

-- Lấy player mục tiêu từ ô nhập
local function getTargetPlayer()
    local nameText = playerInputBox.Text
    if nameText == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and (string.find(string.lower(p.Name), string.lower(nameText)) or string.find(string.lower(p.DisplayName), string.lower(nameText))) then
            return p
        end
    end
    return nil
end

-- Nút xoay vòng chọn danh sách Player
local playerListIndex = 1
selectTargetBtn.MouseButton1Click:Connect(function()
    local otherPlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then table.insert(otherPlayers, p) end
    end
    if #otherPlayers > 0 then
        if playerListIndex > #otherPlayers then playerListIndex = 1 end
        local selected = otherPlayers[playerListIndex]
        playerInputBox.Text = selected.Name
        infoStatusLabel.Text = isUSModeGrab and ("Target: " .. selected.Name) or ("Đã chọn mục tiêu: " .. selected.Name)
        playerListIndex = playerListIndex + 1
    else
        infoStatusLabel.Text = isUSModeGrab and "No other players!" or "Không có người chơi nào khác!"
    end
end)

-- Grab mục tiêu đơn lẻ
grabBtn.MouseButton1Click:Connect(function()
    local targetP = getTargetPlayer()
    if targetP and targetP.Character then
        grabTargetChar(targetP.Character)
        infoStatusLabel.Text = isUSModeGrab and ("Grabbed: " .. targetP.Name) or ("Đã Grab & Thả: " .. targetP.Name)
    else
        infoStatusLabel.Text = isUSModeGrab and "Select a valid target!" or "Vui lòng chọn mục tiêu hợp lệ!"
    end
end)

-- Auto Grab Mục Tiêu
autoGrabTargetBtn.MouseButton1Click:Connect(function()
    isAutoGrabTargetRunning = not isAutoGrabTargetRunning
    if isAutoGrabTargetRunning then
        autoGrabTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoGrabTargetBtn.Text = isUSModeGrab and "Auto Grab Target: ON" or "Auto Grab Mục Tiêu: BẬT"
    else
        autoGrabTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoGrabTargetBtn.Text = isUSModeGrab and "Auto Grab Target: OFF" or "Auto Grab Mục Tiêu: TẮT"
    end
end)

-- Auto Kill Mục Tiêu (Có bục TP)
autoKillTargetBtn.MouseButton1Click:Connect(function()
    isAutoKillTargetRunning = not isAutoKillTargetRunning
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if isAutoKillTargetRunning then
        autoKillTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoKillTargetBtn.Text = isUSModeGrab and "Auto Kill Target: ON" or "Auto Kill Mục Tiêu (TP Bục + Grab): BẬT"
        if root then savedOldPosition = root.CFrame end
        createPlatform()
        pcall(function() if root then root.CFrame = CFrame.new(-3.050, -54.182, 98.073) end end)
    else
        autoKillTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoKillTargetBtn.Text = isUSModeGrab and "Auto Kill Target: OFF" or "Auto Kill Mục Tiêu (TP Bục + Grab): TẮT"
        removePlatform()
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

-- Auto Kill All
autoKillAllBtn.MouseButton1Click:Connect(function()
    isAutoKillAllRunning = not isAutoKillAllRunning
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if isAutoKillAllRunning then
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoKillAllBtn.Text = isUSModeGrab and "Auto Kill All: ON" or "Auto Kill All: BẬT"
        if root then savedOldPosition = root.CFrame end
        createPlatform()
        pcall(function() if root then root.CFrame = CFrame.new(-3.050, -54.182, 98.073) end end)
    else
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoKillAllBtn.Text = isUSModeGrab and "Auto Kill All: OFF" or "Auto Kill All: TẮT"
        removePlatform()
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

-- Tính năng Free Cam (Bay tự do)
freeCamBtn.MouseButton1Click:Connect(function()
    isFreeCamRunning = not isFreeCamRunning
    if isFreeCamRunning then
        freeCamBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        freeCamBtn.Text = isUSModeGrab and "Free Cam: ON" or "🎥 Free Cam (Bay tự do): BẬT"
        camera.CameraType = Enum.CameraType.Scriptable
        
        local camPos = camera.CFrame.Position
        local camRot = camera.CFrame - camPos
        
        freeCamConnection = RunService.RenderStepped:Connect(function(dt)
            local moveVector = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Vector3.new(0, 0, -1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector + Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector + Vector3.new(-1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector + Vector3.new(0, -1, 0) end
            
            camPos = camPos + (camRot * moveVector) * (50 * dt)
            camera.CFrame = CFrame.new(camPos) * camRot
        end)
    else
        freeCamBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
        freeCamBtn.Text = isUSModeGrab and "Free Cam: OFF" or "🎥 Free Cam (Bay tự do): TẮT"
        if freeCamConnection then freeCamConnection:Disconnect() end
        camera.CameraType = Enum.CameraType.Custom
        local char = localPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            camera.CameraSubject = char.Humanoid
        end
    end
end)

toggleRegionGrabBtn.MouseButton1Click:Connect(function()
    isUSModeGrab = not isUSModeGrab
    if isUSModeGrab then
        toggleRegionGrabBtn.Text = "🇺🇸 Region: US (English)"
        title.Text = "  🪝 GRAB, KILL & FREE CAM"
        selectTargetBtn.Text = "👥 Cycle Next Target"
        grabBtn.Text = "Grab Target"
        autoGrabTargetBtn.Text = isAutoGrabTargetRunning and "Auto Grab Target: ON" or "Auto Grab Target: OFF"
        autoKillTargetBtn.Text = isAutoKillTargetRunning and "Auto Kill Target: ON" or "Auto Kill Target: OFF"
        autoKillAllBtn.Text = isAutoKillAllRunning and "Auto Kill All: ON" or "Auto Kill All: OFF"
        freeCamBtn.Text = isFreeCamRunning and "Free Cam: ON" or "Free Cam: OFF"
        playerInputBox.PlaceholderText = "Enter or select target..."
        infoStatusLabel.Text = "Status: Ready"
    else
        toggleRegionGrabBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        title.Text = "  🪝 GRAB, KILL & FREE CAM"
        selectTargetBtn.Text = "👥 Chọn người chơi tiếp theo (Đổi mục tiêu)"
        grabBtn.Text = "🪝 Grab Mục Tiêu"
        autoGrabTargetBtn.Text = isAutoGrabTargetRunning and "Auto Grab Mục Tiêu: BẬT" or "Auto Grab Mục Tiêu: TẮT"
        autoKillTargetBtn.Text = isAutoKillTargetRunning and "Auto Kill Mục Tiêu (TP Bục + Grab): BẬT" or "Auto Kill Mục Tiêu (TP Bục + Grab): TẮT"
        autoKillAllBtn.Text = isAutoKillAllRunning and "Auto Kill All: BẬT" or "Auto Kill All: TẮT"
        freeCamBtn.Text = isFreeCamRunning and "🎥 Free Cam (Bay tự do): BẬT" or "🎥 Free Cam (Bay tự do): TẮT"
        playerInputBox.PlaceholderText = "Nhập tên hoặc chọn mục tiêu bên dưới..."
        infoStatusLabel.Text = "Trạng thái: Sẵn sàng"
    end
end)

-- Loop Auto Grab Mục Tiêu
task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoGrabTargetRunning then
            pcall(function()
                local targetP = getTargetPlayer()
                if targetP and targetP.Character then
                    local pHum = targetP.Character:FindFirstChildOfClass("Humanoid")
                    if pHum and pHum.Health > 0 then
                        grabTargetChar(targetP.Character)
                    end
                end
            end)
        end
    end
end)

-- Loop Auto Kill Mục Tiêu
task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoKillTargetRunning then
            pcall(function()
                local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local targetPos = Vector3.new(-3.050, -54.182, 98.073)
                    if (root.Position - targetPos).Magnitude > 5 then root.CFrame = CFrame.new(targetPos) end
                end
                local targetP = getTargetPlayer()
                if targetP and targetP.Character then
                    local pHum = targetP.Character:FindFirstChildOfClass("Humanoid")
                    if pHum and pHum.Health > 0 then
                        grabTargetChar(targetP.Character)
                    end
                end
            end)
        end
    end
end)

-- Loop Auto Kill All
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
