-- =================================================================
-- SCRIPT GRAB.LUA - GỘP 1 NÚT DANH SÁCH PLAYER DÙNG CHUNG & BLACK/WHITE LIST
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

if playerGui:FindFirstChild("GrabMenuGUI") then playerGui.GrabMenuGUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrabMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 415)
frame.Position = UDim2.new(0.70, 0, 0.34, 0)
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
title.Text = "  🪝 GRAB, TARGET LIST & VIEW"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 10
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Logo nổi độc lập khi thu nhỏ (agg2)
local floatingLogo = Instance.new("TextButton")
floatingLogo.Size = UDim2.new(0, 35, 0, 35)
floatingLogo.Position = UDim2.new(0.70, 0, 0.34, 0)
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
logoCorner.Parent = logoBtn

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Thickness = 1.5
logoStroke.Parent = logoBtn

local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = frame

-- HÀNG 1: Ô nhập tên + 1 Nút Danh Sách Player dùng chung
local playerInputBox = Instance.new("TextBox")
playerInputBox.Size = UDim2.new(0.56, 0, 0, 25)
playerInputBox.Position = UDim2.new(0.05, 0, 0, 38)
playerInputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
playerInputBox.Text = ""
playerInputBox.PlaceholderText = "Tên mục tiêu..."
playerInputBox.TextColor3 = Color3.fromRGB(0, 255, 150)
playerInputBox.TextSize = 10
playerInputBox.Font = Enum.Font.GothamBold
playerInputBox.ClearTextOnFocus = false
playerInputBox.Parent = contentContainer

local boxCornerGrab = Instance.new("UICorner")
boxCornerGrab.CornerRadius = UDim.new(0, 6)
boxCornerGrab.Parent = playerInputBox

local selectListBtn = Instance.new("TextButton")
selectListBtn.Size = UDim2.new(0.32, 0, 0, 25)
selectListBtn.Position = UDim2.new(0.63, 0, 0, 38)
selectListBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
selectListBtn.Text = "👥 Danh Sách"
selectListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectListBtn.TextSize = 9
selectListBtn.Font = Enum.Font.GothamBold
selectListBtn.Parent = contentContainer

local btnCornerList = Instance.new("UICorner")
btnCornerList.CornerRadius = UDim.new(0, 6)
btnCornerList.Parent = selectListBtn

-- HÀNG 2: Thêm Whitelist / Blacklist
local addWhiteBtn = Instance.new("TextButton")
addWhiteBtn.Size = UDim2.new(0.43, 0, 0, 24)
addWhiteBtn.Position = UDim2.new(0.05, 0, 0, 68)
addWhiteBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
addWhiteBtn.Text = "🛡️ + Whitelist"
addWhiteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addWhiteBtn.TextSize = 9
addWhiteBtn.Font = Enum.Font.GothamBold
addWhiteBtn.Parent = contentContainer

local btnCornerW = Instance.new("UICorner")
btnCornerW.CornerRadius = UDim.new(0, 6)
btnCornerW.Parent = addWhiteBtn

local addBlackBtn = Instance.new("TextButton")
addBlackBtn.Size = UDim2.new(0.43, 0, 0, 24)
addBlackBtn.Position = UDim2.new(0.52, 0, 0, 68)
addBlackBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
addBlackBtn.Text = "🎯 + Blacklist"
addBlackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addBlackBtn.TextSize = 9
addBlackBtn.Font = Enum.Font.GothamBold
addBlackBtn.Parent = contentContainer

local btnCornerB = Instance.new("UICorner")
btnCornerB.CornerRadius = UDim.new(0, 6)
btnCornerB.Parent = addBlackBtn

-- HÀNG 3: Grab Mục Tiêu & Auto Grab Mục Tiêu
local grabBtn = Instance.new("TextButton")
grabBtn.Size = UDim2.new(0.43, 0, 0, 26)
grabBtn.Position = UDim2.new(0.05, 0, 0, 97)
grabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
grabBtn.Text = "🪝 Grab Mục Tiêu"
grabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
grabBtn.TextSize = 9
grabBtn.Font = Enum.Font.GothamBold
grabBtn.Parent = contentContainer

local btnCornerG1 = Instance.new("UICorner")
btnCornerG1.CornerRadius = UDim.new(0, 6)
btnCornerG1.Parent = grabBtn

local autoGrabTargetBtn = Instance.new("TextButton")
autoGrabTargetBtn.Size = UDim2.new(0.43, 0, 0, 26)
autoGrabTargetBtn.Position = UDim2.new(0.52, 0, 0, 97)
autoGrabTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoGrabTargetBtn.Text = "🤖 Auto Grab: TẮT"
autoGrabTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGrabTargetBtn.TextSize = 9
autoGrabTargetBtn.Font = Enum.Font.GothamBold
autoGrabTargetBtn.Parent = contentContainer

local btnCornerAGT = Instance.new("UICorner")
btnCornerAGT.CornerRadius = UDim.new(0, 6)
btnCornerAGT.Parent = autoGrabTargetBtn

-- HÀNG 4: Auto Kill Mục Tiêu (Có Bục TP)
local autoKillTargetBtn = Instance.new("TextButton")
autoKillTargetBtn.Size = UDim2.new(0.9, 0, 0, 26)
autoKillTargetBtn.Position = UDim2.new(0.05, 0, 0, 128)
autoKillTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoKillTargetBtn.Text = "🎯 Auto Kill Mục Tiêu (TP Bục): TẮT"
autoKillTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKillTargetBtn.TextSize = 9
autoKillTargetBtn.Font = Enum.Font.GothamBold
autoKillTargetBtn.Parent = contentContainer

local btnCornerAKT = Instance.new("UICorner")
btnCornerAKT.CornerRadius = UDim.new(0, 6)
btnCornerAKT.Parent = autoKillTargetBtn

-- HÀNG 5: Grab Random Danh Sách Đen
local grabRandomBlackBtn = Instance.new("TextButton")
grabRandomBlackBtn.Size = UDim2.new(0.9, 0, 0, 26)
grabRandomBlackBtn.Position = UDim2.new(0.05, 0, 0, 159)
grabRandomBlackBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
grabRandomBlackBtn.Text = "🎲 Grab Random Danh Sách Đen"
grabRandomBlackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
grabRandomBlackBtn.TextSize = 9
grabRandomBlackBtn.Font = Enum.Font.GothamBold
grabRandomBlackBtn.Parent = contentContainer

local btnCornerGRB = Instance.new("UICorner")
btnCornerGRB.CornerRadius = UDim.new(0, 6)
btnCornerGRB.Parent = grabRandomBlackBtn

-- HÀNG 6: Auto Kill All (Trừ Whitelist)
local autoKillAllBtn = Instance.new("TextButton")
autoKillAllBtn.Size = UDim2.new(0.9, 0, 0, 26)
autoKillAllBtn.Position = UDim2.new(0.05, 0, 0, 190)
autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoKillAllBtn.Text = "⚔️ Auto Kill All (Trừ Whitelist): TẮT"
autoKillAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKillAllBtn.TextSize = 9
autoKillAllBtn.Font = Enum.Font.GothamBold
autoKillAllBtn.Parent = contentContainer

local btnCornerAKAll = Instance.new("UICorner")
btnCornerAKAll.CornerRadius = UDim.new(0, 6)
btnCornerAKAll.Parent = autoKillAllBtn

-- HÀNG 7: View Player (Soi mục tiêu đã chọn)
local viewPlayerBtn = Instance.new("TextButton")
viewPlayerBtn.Size = UDim2.new(0.9, 0, 0, 26)
viewPlayerBtn.Position = UDim2.new(0.05, 0, 0, 221)
viewPlayerBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
viewPlayerBtn.Text = "👁️ View Player (Mục Tiêu): TẮT"
viewPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
viewPlayerBtn.TextSize = 9
viewPlayerBtn.Font = Enum.Font.GothamBold
viewPlayerBtn.Parent = contentContainer

local btnCornerVP = Instance.new("UICorner")
btnCornerVP.CornerRadius = UDim.new(0, 6)
btnCornerVP.Parent = viewPlayerBtn

-- HÀNG 8: Nút chuyển US/VN
local toggleRegionGrabBtn = Instance.new("TextButton")
toggleRegionGrabBtn.Size = UDim2.new(0.9, 0, 0, 24)
toggleRegionGrabBtn.Position = UDim2.new(0.05, 0, 0, 253)
toggleRegionGrabBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleRegionGrabBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
toggleRegionGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleRegionGrabBtn.TextSize = 10
toggleRegionGrabBtn.Font = Enum.Font.GothamBold
toggleRegionGrabBtn.Parent = contentContainer

local btnCornerRegionGrab = Instance.new("UICorner")
btnCornerRegionGrab.CornerRadius = UDim.new(0, 6)
btnCornerRegionGrab.Parent = toggleRegionGrabBtn

-- HÀNG 9: Trạng thái
local infoStatusLabel = Instance.new("TextLabel")
infoStatusLabel.Size = UDim2.new(0.9, 0, 0, 115)
infoStatusLabel.Position = UDim2.new(0.05, 0, 0, 282)
infoStatusLabel.BackgroundTransparency = 1
infoStatusLabel.Text = "Trạng thái: Sẵn sàng\nWhitelist: 0 | Blacklist: 0"
infoStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoStatusLabel.TextSize = 9
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

-- Biến quản lý trạng thái
local whitelist = {}
local blacklist = {}
local isAutoGrabTargetRunning = false
local isAutoKillTargetRunning = false
local isAutoKillAllRunning = false
local isViewPlayerRunning = false
local isUSModeGrab = false
local platformPart = nil
local savedOldPosition = nil
local targetListIndex = 1

local hugRequestRemote = ReplicatedStorage:FindFirstChild("HugRemotes") and ReplicatedStorage.HugRemotes:FindFirstChild("HugRequest")

local function updateStatusText(prefix)
    local wCount = 0 for _ in pairs(whitelist) do wCount = wCount + 1 end
    local bCount = 0 for _ in pairs(blacklist) do bCount = bCount + 1 end
    local header = prefix or (isUSModeGrab and "Status: Ready" or "Trạng thái: Sẵn sàng")
    infoStatusLabel.Text = string.format("%s\nWhitelist: %d | Blacklist: %d", header, wCount, bCount)
end

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

local function applyViewCamera(targetP)
    if isViewPlayerRunning and targetP and targetP.Character and targetP.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = targetP.Character.Humanoid
    end
end

-- 1 NÚT DANH SÁCH PLAYER DUY NHẤT DÙNG CHUNG CHO MỌI TÍNH NĂNG
selectListBtn.MouseButton1Click:Connect(function()
    local otherPlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then table.insert(otherPlayers, p) end
    end
    if #otherPlayers > 0 then
        if targetListIndex > #otherPlayers then targetListIndex = 1 end
        local selected = otherPlayers[targetListIndex]
        playerInputBox.Text = selected.Name
        applyViewCamera(selected)
        updateStatusText((isUSModeGrab and "🎯 Target: " or "🎯 Mục tiêu: ") .. selected.Name)
        targetListIndex = targetListIndex + 1
    else
        updateStatusText(isUSModeGrab and "⚠️ No other players!" or "⚠️ Không có người chơi khác!")
    end
end)

-- Thêm/Xóa Whitelist
addWhiteBtn.MouseButton1Click:Connect(function()
    local targetP = getTargetPlayer()
    if targetP then
        whitelist[targetP.Name] = true
        blacklist[targetP.Name] = nil
        updateStatusText((isUSModeGrab and "🛡️ Whitelisted: " or "🛡️ Đã thêm Whitelist: ") .. targetP.Name)
    else
        updateStatusText(isUSModeGrab and "⚠️ Player not found!" or "⚠️ Không tìm thấy người chơi!")
    end
end)

-- Thêm/Xóa Blacklist
addBlackBtn.MouseButton1Click:Connect(function()
    local targetP = getTargetPlayer()
    if targetP then
        blacklist[targetP.Name] = true
        whitelist[targetP.Name] = nil
        updateStatusText((isUSModeGrab and "🎯 Blacklisted: " or "🎯 Đã thêm Blacklist: ") .. targetP.Name)
    else
        updateStatusText(isUSModeGrab and "⚠️ Player not found!" or "⚠️ Không tìm thấy người chơi!")
    end
end)

-- Grab Mục Tiêu đơn lẻ (tôn trọng Whitelist)
grabBtn.MouseButton1Click:Connect(function()
    local targetP = getTargetPlayer()
    if targetP and targetP.Character then
        if whitelist[targetP.Name] then
            updateStatusText((isUSModeGrab and "🛡️ Protected (Whitelist): " or "🛡️ Miễn nhiễm (Whitelist): ") .. targetP.Name)
            return
        end
        grabTargetChar(targetP.Character)
        updateStatusText((isUSModeGrab and "🪝 Grabbed: " or "🪝 Đã Grab: ") .. targetP.Name)
    else
        updateStatusText(isUSModeGrab and "⚠️ Select a target first!" or "⚠️ Vui lòng chọn mục tiêu!")
    end
end)

-- Grab Random Danh Sách Đen
grabRandomBlackBtn.MouseButton1Click:Connect(function()
    local blackListArray = {}
    for name, _ in pairs(blacklist) do
        local p = Players:FindFirstChild(name)
        if p and p.Character and not whitelist[p.Name] then
            table.insert(blackListArray, p)
        end
    end
    if #blackListArray > 0 then
        local randomTarget = blackListArray[math.random(1, #blackListArray)]
        playerInputBox.Text = randomTarget.Name
        applyViewCamera(randomTarget)
        grabTargetChar(randomTarget.Character)
        updateStatusText((isUSModeGrab and "🎲 Random Blacklist Grab: " or "🎲 Random Grab Blacklist: ") .. randomTarget.Name)
    else
        updateStatusText(isUSModeGrab and "⚠️ Blacklist empty/offline!" or "⚠️ Blacklist trống hoặc offline!")
    end
end)

-- Auto Grab Mục Tiêu
autoGrabTargetBtn.MouseButton1Click:Connect(function()
    isAutoGrabTargetRunning = not isAutoGrabTargetRunning
    if isAutoGrabTargetRunning then
        autoGrabTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoGrabTargetBtn.Text = isUSModeGrab and "🤖 Auto Grab: ON" or "🤖 Auto Grab: BẬT"
    else
        autoGrabTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoGrabTargetBtn.Text = isUSModeGrab and "🤖 Auto Grab: OFF" or "🤖 Auto Grab: TẮT"
    end
end)

-- Auto Kill Mục Tiêu (Có bục TP & tự trả về vị trí cũ)
autoKillTargetBtn.MouseButton1Click:Connect(function()
    isAutoKillTargetRunning = not isAutoKillTargetRunning
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if isAutoKillTargetRunning then
        autoKillTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoKillTargetBtn.Text = isUSModeGrab and "🎯 Auto Kill Target (TP): ON" or "🎯 Auto Kill Mục Tiêu (TP Bục): BẬT"
        if root then savedOldPosition = root.CFrame end
        createPlatform()
        pcall(function() if root then root.CFrame = CFrame.new(-3.050, -54.182, 98.073) end end)
    else
        autoKillTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoKillTargetBtn.Text = isUSModeGrab and "🎯 Auto Kill Target (TP): OFF" or "🎯 Auto Kill Mục Tiêu (TP Bục): TẮT"
        removePlatform()
        if savedOldPosition and root then
            pcall(function() root.Anchored = true; root.CFrame = savedOldPosition; task.wait(0.2); root.Anchored = false end)
        end
    end
end)

-- Auto Kill All (Trừ Whitelist)
autoKillAllBtn.MouseButton1Click:Connect(function()
    isAutoKillAllRunning = not isAutoKillAllRunning
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if isAutoKillAllRunning then
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        autoKillAllBtn.Text = isUSModeGrab and "⚔️ Auto Kill All: ON" or "⚔️ Auto Kill All (Trừ Whitelist): BẬT"
        if root then savedOldPosition = root.CFrame end
        createPlatform()
        pcall(function() if root then root.CFrame = CFrame.new(-3.050, -54.182, 98.073) end end)
    else
        autoKillAllBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoKillAllBtn.Text = isUSModeGrab and "⚔️ Auto Kill All: OFF" or "⚔️ Auto Kill All (Trừ Whitelist): TẮT"
        removePlatform()
        if savedOldPosition and root then
            pcall(function() root.Anchored = true; root.CFrame = savedOldPosition; task.wait(0.2); root.Anchored = false end)
        end
    end
end)

-- View Player (Soi mục tiêu đang chọn)
viewPlayerBtn.MouseButton1Click:Connect(function()
    isViewPlayerRunning = not isViewPlayerRunning
    if isViewPlayerRunning then
        viewPlayerBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        viewPlayerBtn.Text = isUSModeGrab and "👁️ View Target: ON" or "👁️ View Player (Mục Tiêu): BẬT"
        local targetP = getTargetPlayer()
        if targetP then
            applyViewCamera(targetP)
            updateStatusText((isUSModeGrab and "👁️ Viewing: " or "👁️ Đang View: ") .. targetP.Name)
        end
    else
        viewPlayerBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
        viewPlayerBtn.Text = isUSModeGrab and "👁️ View Target: OFF" or "👁️ View Player (Mục Tiêu): TẮT"
        camera.CameraType = Enum.CameraType.Custom
        local char = localPlayer.Character
        if char and char:FindFirstChild("Humanoid") then camera.CameraSubject = char.Humanoid end
        updateStatusText()
    end
end)

-- Chuyển đổi ngôn ngữ US/VN
toggleRegionGrabBtn.MouseButton1Click:Connect(function()
    isUSModeGrab = not isUSModeGrab
    if isUSModeGrab then
        toggleRegionGrabBtn.Text = "🇺🇸 Region: US (English)"
        playerInputBox.PlaceholderText = "Target name..."
        selectListBtn.Text = "👥 Player List"
        addWhiteBtn.Text = "🛡️ + Whitelist"
        addBlackBtn.Text = "🎯 + Blacklist"
        grabBtn.Text = "🪝 Grab Target"
        autoGrabTargetBtn.Text = isAutoGrabTargetRunning and "🤖 Auto Grab: ON" or "🤖 Auto Grab: OFF"
        autoKillTargetBtn.Text = isAutoKillTargetRunning and "🎯 Auto Kill Target (TP): ON" or "🎯 Auto Kill Target (TP): OFF"
        grabRandomBlackBtn.Text = "🎲 Grab Random Blacklist"
        autoKillAllBtn.Text = isAutoKillAllRunning and "⚔️ Auto Kill All: ON" or "⚔️ Auto Kill All: OFF"
        viewPlayerBtn.Text = isViewPlayerRunning and "👁️ View Target: ON" or "👁️ View Target: OFF"
    else
        toggleRegionGrabBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        playerInputBox.PlaceholderText = "Tên mục tiêu..."
        selectListBtn.Text = "👥 Danh Sách"
        addWhiteBtn.Text = "🛡️ + Whitelist"
        addBlackBtn.Text = "🎯 + Blacklist"
        grabBtn.Text = "🪝 Grab Mục Tiêu"
        autoGrabTargetBtn.Text = isAutoGrabTargetRunning and "🤖 Auto Grab: BẬT" or "🤖 Auto Grab: TẮT"
        autoKillTargetBtn.Text = isAutoKillTargetRunning and "🎯 Auto Kill Mục Tiêu (TP Bục): BẬT" or "🎯 Auto Kill Mục Tiêu (TP Bục): TẮT"
        grabRandomBlackBtn.Text = "🎲 Grab Random Danh Sách Đen"
        autoKillAllBtn.Text = isAutoKillAllRunning and "⚔️ Auto Kill All (Trừ Whitelist): BẬT" or "⚔️ Auto Kill All (Trừ Whitelist): TẮT"
        viewPlayerBtn.Text = isViewPlayerRunning and "👁️ View Player (Mục Tiêu): BẬT" or "👁️ View Player (Mục Tiêu): TẮT"
    end
    updateStatusText()
end)

-- Loop Auto Grab Mục Tiêu (Bỏ qua nếu nằm trong Whitelist)
task.spawn(function()
    while true do
        task.wait(0.3)
        if isAutoGrabTargetRunning then
            pcall(function()
                local targetP = getTargetPlayer()
                if targetP and targetP.Character and not whitelist[targetP.Name] then
                    local pHum = targetP.Character:FindFirstChildOfClass("Humanoid")
                    if pHum and pHum.Health > 0 then
                        grabTargetChar(targetP.Character)
                    end
                end
            end)
        end
    end
end)

-- Loop Auto Kill Mục Tiêu (TP Bục + Grab mục tiêu đang chọn, bỏ qua Whitelist)
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
                if targetP and targetP.Character and not whitelist[targetP.Name] then
                    local pHum = targetP.Character:FindFirstChildOfClass("Humanoid")
                    if pHum and pHum.Health > 0 then
                        grabTargetChar(targetP.Character)
                    end
                end
            end)
        end
    end
end)

-- Loop Auto Kill All (Miễn nhiễm Whitelist)
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
                    if p ~= localPlayer and not whitelist[p.Name] and p.Character then
                        local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if pHum and pHum.Health > 0 then grabTargetChar(p.Character); task.wait(0.3) end
                    end
                end
            end)
        end
    end
end)
