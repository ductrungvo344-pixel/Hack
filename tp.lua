-- =================================================================
-- SCRIPT CHÍNH TỔNG HỢP (tp.lua) - ĐẦY ĐỦ 100% KHÔNG BỊ CẮT
-- =================================================================
print("⏳ Đang khởi chạy tp.lua...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketService = game:GetService("MarketplaceService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local successName, gameInfo = pcall(function()
    return MarketService:GetProductInfo(game.PlaceId)
end)
local isTargetGame = (game.PlaceId == 10033751448)

-- =================================================================
-- KHỞI TẠO GIAO DIỆN (GUI)
-- =================================================================
if playerGui:FindFirstChild("TeleportGUI") then
    playerGui.TeleportGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = screenGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 465)
frame.Position = UDim2.new(0.05, 0, 0.18, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 0, 32)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ MENU TELEPORT & TIỆN ÍCH"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- =================================================================
-- NÚT THU NHỎ / MỞ RỘNG BIẾN THÀNH LOGO TRÒN "agg2"
-- =================================================================
local logoBtn = Instance.new("TextButton")
logoBtn.Size = UDim2.new(0, 26, 0, 26)
logoBtn.Position = UDim2.new(1, -30, 0, 3)
logoBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
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

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0, 420)
scroll.Position = UDim2.new(0.025, 0, 0, 38)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
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

local currentY = 2

-- 0. NÚT CHUYỂN NGÔN NGỮ US/VN TRONG MENU TP
local toggleRegionTPBtn = createButton("RegionBtn", "🇻🇳 Khu vực: VN (Tiếng Việt)", currentY, Color3.fromRGB(0, 100, 200))
currentY = currentY + 32

-- 1. TELEPORT SECTION
local tpSectionLbl = createSubLabel("⚡ HỆ THỐNG TELEPORT", currentY)
currentY = currentY + 20

local oldPosition = nil
local isTeleported = false
local isUSModeTP = false

local function executeTeleport(targetCFrame)
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        if not isTeleported then
            oldPosition = rootPart.CFrame
            isTeleported = true
        end
        
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
    currentY = currentY + 108

    createSubLabel("💎 VIP", currentY)
    local vip1 = createButton("VIP1", "1. (-94, 17633, 9357)", currentY + 20, Color3.fromRGB(0, 180, 90))
    currentY = currentY + 52

    createSubLabel("⭐ MEGA VIP", currentY)
    local mv1 = createButton("MV1", "1. (-88, 17633, 9224)", currentY + 20, Color3.fromRGB(150, 0, 230))
    local mv2 = createButton("MV2", "2. (-112, 17633, 9224)", currentY + 48, Color3.fromRGB(150, 0, 230))
    currentY = currentY + 80

    smv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-95, 17633, 9039)) end)
    smv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-124, 17633, 9043)) end)
    smv3.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-82, 17633, 9044)) end)
    vip1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-94, 17633, 9357)) end)
    mv1.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-88, 17633, 9224)) end)
    mv2.MouseButton1Click:Connect(function() executeTeleport(CFrame.new(-112, 17633, 9224)) end)
end

local backBtn = createButton("Back", "🔄 Quay lại vị trí cũ", currentY, Color3.fromRGB(230, 70, 70))
currentY = currentY + 32

backBtn.MouseButton1Click:Connect(function()
    if oldPosition then
        local character = localPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.Anchored = true
            rootPart.CFrame = oldPosition
            task.wait(0.2)
            rootPart.Anchored = false
            oldPosition = nil
            isTeleported = false
        end
    end
end)

-- 2. DỊCH CHAT
local chatSectionLbl = createSubLabel("🌐 DỊCH CHAT (MYMEMORY API)", currentY)
local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(0.95, 0, 0, 26)
chatBox.Position = UDim2.new(0.02, 0, 0, currentY + 20)
chatBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
chatBox.PlaceholderText = "Nhập tiếng Việt cần dịch..."
chatBox.Text = ""
chatBox.TextColor3 = Color3.fromRGB(255, 255, 255)
chatBox.TextSize = 11
chatBox.Font = Enum.Font.Gotham
chatBox.ClearTextOnFocus = false
chatBox.Parent = scroll

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = chatBox

local translateBtn = createButton("TransBtn", "🔍 Dịch sang English", currentY + 50, Color3.fromRGB(0, 120, 255))
local resultBox = Instance.new("TextBox")
resultBox.Size = UDim2.new(0.95, 0, 0, 26)
resultBox.Position = UDim2.new(0.02, 0, 0, currentY + 78)
resultBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
resultBox.PlaceholderText = "Bản dịch tiếng Anh..."
resultBox.Text = ""
resultBox.TextColor3 = Color3.fromRGB(0, 255, 150)
resultBox.TextSize = 11
resultBox.Font = Enum.Font.GothamBold
resultBox.ClearTextOnFocus = false
resultBox.Parent = scroll

local resCorner = Instance.new("UICorner")
resCorner.CornerRadius = UDim.new(0, 4)
resCorner.Parent = resultBox

local copyBtn = createButton("CopyBtn", "📋 Copy Bản Dịch", currentY + 108, Color3.fromRGB(0, 180, 90))
currentY = currentY + 140

translateBtn.MouseButton1Click:Connect(function()
    local input = chatBox.Text
    if input == "" or input == " " then return end
    translateBtn.Text = isUSModeTP and "⏳ Translating..." or "⏳ Đang dịch..."
    task.spawn(function()
        local success, result = pcall(function()
            local cleanInput = HttpService:UrlEncode(input)
            local url = "https://api.mymemory.translated.net/get?q=" .. cleanInput .. "&langpair=vi|en"
            local reqFunc = request or http_request or (syn and syn.request)
            if not reqFunc then return nil end
            local res = reqFunc({ Url = url, Method = "GET" })
            if res and (res.StatusCode == 200 or res.StatusDescription == "OK") then
                local data = HttpService:JSONDecode(res.Body)
                return data and data.responseData and data.responseData.translatedText
            end
            return nil
        end)
        
        if success and result and result ~= "" then
            resultBox.Text = result
        else
            resultBox.Text = isUSModeTP and "⚠️ Translation error!" or "⚠️ Lỗi dịch thuật!"
        end
        translateBtn.Text = isUSModeTP and "🔍 Translate to English" or "🔍 Dịch sang English"
    end)
end)

copyBtn.MouseButton1Click:Connect(function()
    if resultBox.Text ~= "" and resultBox.Text ~= "⚠️ Lỗi dịch thuật!" and resultBox.Text ~= "⚠️ Translation error!" then
        pcall(function() setclipboard(resultBox.Text) end)
        copyBtn.Text = isUSModeTP and "✅ Copied!" or "✅ Đã Copy!"
        task.wait(1.5)
        copyBtn.Text = isUSModeTP and "📋 Copy Translation" or "📋 Copy Bản Dịch"
    end
end)

-- 3. ADMIN & EXTRA SCRIPTS
local extraSectionLbl = createSubLabel("🛠️ SCRIPT KHÁC", currentY)
local adminBtn = createButton("Admin", "👑 Nameless Admin (New)", currentY + 20, Color3.fromRGB(255, 140, 0))
local invisBtn = createButton("InvisBtn", "👻 Invisible Man", currentY + 48, Color3.fromRGB(130, 80, 220))
currentY = currentY + 80

adminBtn.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-nameless-admin-NEWESTWORKINGBEST-232306"))() end)
end)

invisBtn.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Awesome-Invisible-man-133400"))() end)
end)

-- 4. KURDISH ANIMATIONS SECTION
local animSectionLbl = createSubLabel("💃 KURDISH ANIMATIONS (FULL)", currentY)
currentY = currentY + 20

local fullAnimList = {
    {"Sit", "178130996", true, 1},
    {"Float Sit", "179224234", true, 1},
    {"Head Throw", "35154961", true, 1},
    {"Floating Head", "121572214", false, 1},
    {"Crouch", "182724289", false, 1},
    {"Floor Crawl", "282574440", false, 1},
    {"Dino Walk", "204328711", false, 1},
    {"Jumping Jacks", "429681631", false, 1},
    {"Hero Jump", "184574340", true, 1},
    {"Faint", "181526230", false, 1},
    {"Dab", "183412246", true, 1},
    {"Spinner", "188632011", true, 2},
    {"Spin Dance", "429730430", true, 1},
    {"Moon Dance", "45834924", true, 1},
    {"Crazy Slash", "674871189", true, 1},
    {"Open", "582855105", true, 1},
    {"R15 Spinner", "754658275", true, 1},
    {"Arms Out", "582384156", true, 1},
    {"Float Slash", "717879555", true, 1},
    {"Fling Arms", "754656200", true, 10}
}

local animButtons = {}

local function setupAnimations(character)
    local humanoid = character:WaitForChild("Humanoid")
    local normalColor = Color3.fromRGB(180, 140, 60)
    local activeColor = Color3.fromRGB(230, 180, 70)

    for _, btn in pairs(animButtons) do
        btn:Destroy()
    end
    animButtons = {}

    local startY = currentY
    for _, animData in ipairs(fullAnimList) do
        local animName, animId, isLoop, speed = animData[1], animData[2], animData[3], animData[4]
        
        local animObj = Instance.new("Animation")
        animObj.AnimationId = "rbxassetid://" .. animId
        local track = humanoid:LoadAnimation(animObj)
        
        track.Priority = Enum.AnimationPriority.Action4
        
        local btn = createButton("Anim_" .. animName, animName, startY, normalColor)
        table.insert(animButtons, btn)
        startY = startY + 28
        
        local isPlaying = false
        btn.MouseButton1Click:Connect(function()
            isPlaying = not isPlaying
            if isPlaying then
                btn.BackgroundColor3 = activeColor
                if animName == "Sit" then humanoid.Sit = true end
                
                if isLoop then
                    task.spawn(function()
                        while isPlaying and humanoid.Health > 0 do
                            if not track.IsPlaying then track:Play(0.1, 1, speed) end
                            task.wait()
                        end
                    end)
                else
                    track:Play(0.1, 1, speed)
                end
            else
                track:Stop()
                if animName == "Sit" then humanoid.Sit = false end
                btn.BackgroundColor3 = normalColor
            end
        end)
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, startY + 30)
end

if localPlayer.Character then
	setupAnimations(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	setupAnimations(char)
end)

-- LOGIC CHUYỂN NGÔN NGỮ US/VN CHO TP SCRIPT
toggleRegionTPBtn.MouseButton1Click:Connect(function()
    isUSModeTP = not isUSModeTP
    if isUSModeTP then
        toggleRegionTPBtn.Text = "🇺🇸 Region: US (English)"
        title.Text = "  ⚡ TELEPORT & UTILITIES"
        tpSectionLbl.Text = "⚡ TELEPORT SYSTEM"
        backBtn.Text = "🔄 Back to old position"
        chatSectionLbl.Text = "🌐 CHAT TRANSLATOR (MYMEMORY API)"
        chatBox.PlaceholderText = "Type Vietnamese to translate..."
        translateBtn.Text = "🔍 Translate to English"
        resultBox.PlaceholderText = "English translation..."
        copyBtn.Text = "📋 Copy Translation"
        extraSectionLbl.Text = "🛠️ OTHER SCRIPTS"
        animSectionLbl.Text = "💃 KURDISH ANIMATIONS (FULL)"
    else
        toggleRegionTPBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        title.Text = "  ⚡ MENU TELEPORT & TIỆN ÍCH"
        tpSectionLbl.Text = "⚡ HỆ THỐNG TELEPORT"
        backBtn.Text = "🔄 Quay lại vị trí cũ"
        chatSectionLbl.Text = "🌐 DỊCH CHAT (MYMEMORY API)"
        chatBox.PlaceholderText = "Nhập tiếng Việt cần dịch..."
        translateBtn.Text = "🔍 Dịch sang English"
        resultBox.PlaceholderText = "Bản dịch tiếng Anh..."
        copyBtn.Text = "📋 Copy Bản Dịch"
        extraSectionLbl.Text = "🛠️ SCRIPT KHÁC"
        animSectionLbl.Text = "💃 KURDISH ANIMATIONS (FULL)"
    end
end)

-- LOGIC THU NHỎ / MỞ RỘNG BẰNG LOGO TRÒN "agg2"
local isMinimized = false
logoBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        frame.Size = UDim2.new(0, 240, 0, 35)
        scroll.Visible = false
    else
        frame.Size = UDim2.new(0, 240, 0, 465)
        scroll.Visible = true
    end
end)

print("🎉 Khởi chạy thành công tp.lua bản chuẩn có logo tròn agg2 và US/VN!")
