-- =================================================================
-- SCRIPT LOADER CHÍNH - NÚT THU NHỎ BIẾN THÀNH LOGO TRÒN "agg2"
-- =================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("GameLoaderGUI") then playerGui.GameLoaderGUI:Destroy() end
if CoreGui:FindFirstChild("GameLoaderGUI") then CoreGui.GameLoaderGUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameLoaderGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Khung chính của Loader
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 400)
frame.Position = UDim2.new(0.5, -130, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "  🚀 SCRIPT LOADER MENU"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- =================================================================
-- NÚT THU NHỎ BIẾN THÀNH LOGO TRÒN HÌNH "agg2"
-- =================================================================
local logoBtn = Instance.new("TextButton")
logoBtn.Size = UDim2.new(0, 28, 0, 28)
logoBtn.Position = UDim2.new(1, -32, 0, 4)
logoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
logoBtn.Text = "agg2"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
logoBtn.TextSize = 9
logoBtn.Font = Enum.Font.GothamBold
logoBtn.Parent = frame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0) -- Bo tròn 100% thành hình tròn
logoBtn.Parent = frame

-- Viền sáng cho logo tròn
local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Thickness = 1.5
logoStroke.Parent = logoBtn

local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = frame

-- 1. HUG TOWER TROLL
local hugTitle = Instance.new("TextLabel")
hugTitle.Size = UDim2.new(0.9, 0, 0, 18)
hugTitle.Position = UDim2.new(0.05, 0, 0, 42)
hugTitle.BackgroundTransparency = 1
hugTitle.Text = "🏰 Hug Tower Troll:"
hugTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
hugTitle.TextSize = 11
hugTitle.Font = Enum.Font.GothamBold
hugTitle.TextXAlignment = Enum.TextXAlignment.Left
hugTitle.Parent = contentContainer

local loadHugBtn = Instance.new("TextButton")
loadHugBtn.Size = UDim2.new(0.9, 0, 0, 26)
loadHugBtn.Position = UDim2.new(0.05, 0, 0, 62)
loadHugBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
loadHugBtn.Text = "▶ Tải Script Hug Tower"
loadHugBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadHugBtn.TextSize = 10
loadHugBtn.Font = Enum.Font.GothamBold
loadHugBtn.Parent = contentContainer

local hugBtnCorner = Instance.new("UICorner")
hugBtnCorner.CornerRadius = UDim.new(0, 6)
hugBtnCorner.Parent = loadHugBtn

local hugNote = Instance.new("TextLabel")
hugNote.Size = UDim2.new(0.9, 0, 0, 42)
hugNote.Position = UDim2.new(0.05, 0, 0, 90)
hugNote.BackgroundTransparency = 1
hugNote.Text = "📌 Lưu ý: Auto Kill All khi bật sẽ không tự động thả vì đang lỗi. Xin phép ấn thủ công nút thả nhé!"
hugNote.TextColor3 = Color3.fromRGB(200, 200, 200)
hugNote.TextSize = 9
hugNote.Font = Enum.Font.Gotham
hugNote.TextWrapped = true
hugNote.TextXAlignment = Enum.TextXAlignment.Left
hugNote.Parent = contentContainer

local divider1 = Instance.new("Frame")
divider1.Size = UDim2.new(0.9, 0, 0, 1)
divider1.Position = UDim2.new(0.05, 0, 0, 134)
divider1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider1.BorderSizePixel = 0
divider1.Parent = contentContainer

-- 2. SLAPPER (SLAP)
local slapTitle = Instance.new("TextLabel")
slapTitle.Size = UDim2.new(0.9, 0, 0, 18)
slapTitle.Position = UDim2.new(0.05, 0, 0, 140)
slapTitle.BackgroundTransparency = 1
slapTitle.Text = "👋 Slapper (Slap):"
slapTitle.TextColor3 = Color3.fromRGB(255, 150, 0)
slapTitle.TextSize = 11
slapTitle.Font = Enum.Font.GothamBold
slapTitle.TextXAlignment = Enum.TextXAlignment.Left
slapTitle.Parent = contentContainer

local loadSlapBtn = Instance.new("TextButton")
loadSlapBtn.Size = UDim2.new(0.9, 0, 0, 26)
loadSlapBtn.Position = UDim2.new(0.05, 0, 0, 160)
loadSlapBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
loadSlapBtn.Text = "▶ Tải Script Slap"
loadSlapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadSlapBtn.TextSize = 10
loadSlapBtn.Font = Enum.Font.GothamBold
loadSlapBtn.Parent = contentContainer

local slapBtnCorner = Instance.new("UICorner")
slapBtnCorner.CornerRadius = UDim.new(0, 6)
slapBtnCorner.Parent = loadSlapBtn

local slapNote = Instance.new("TextLabel")
slapNote.Size = UDim2.new(0.9, 0, 0, 42)
slapNote.Position = UDim2.new(0.05, 0, 0, 188)
slapNote.BackgroundTransparency = 1
slapNote.Text = "📌 Lưu ý: Tính năng Dò Phía Sau phải bật, nếu không tính năng Auto Đoán sẽ không hoạt động."
slapNote.TextColor3 = Color3.fromRGB(200, 200, 200)
slapNote.TextSize = 9
slapNote.Font = Enum.Font.Gotham
slapNote.TextWrapped = true
slapNote.TextXAlignment = Enum.TextXAlignment.Left
slapNote.Parent = contentContainer

local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(0.9, 0, 0, 1)
divider2.Position = UDim2.new(0.05, 0, 0, 232)
divider2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider2.BorderSizePixel = 0
divider2.Parent = contentContainer

-- 3. ALL GAME SCRIPT (TP.LUA)
local allTitle = Instance.new("TextLabel")
allTitle.Size = UDim2.new(0.9, 0, 0, 18)
allTitle.Position = UDim2.new(0.05, 0, 0, 238)
allTitle.BackgroundTransparency = 1
allTitle.Text = "🌐 All Game Script:"
allTitle.TextColor3 = Color3.fromRGB(0, 180, 255)
allTitle.TextSize = 11
allTitle.Font = Enum.Font.GothamBold
allTitle.TextXAlignment = Enum.TextXAlignment.Left
allTitle.Parent = contentContainer

local loadAllBtn = Instance.new("TextButton")
loadAllBtn.Size = UDim2.new(0.9, 0, 0, 26)
loadAllBtn.Position = UDim2.new(0.05, 0, 0, 258)
loadAllBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
loadAllBtn.Text = "▶ Tải All Game Script (TP.lua)"
loadAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadAllBtn.TextSize = 10
loadAllBtn.Font = Enum.Font.GothamBold
loadAllBtn.Parent = contentContainer

local allBtnCorner = Instance.new("UICorner")
allBtnCorner.CornerRadius = UDim.new(0, 6)
allBtnCorner.Parent = loadAllBtn

-- Nút chuyển US/VN
local toggleRegionLoaderBtn = Instance.new("TextButton")
toggleRegionLoaderBtn.Size = UDim2.new(0.9, 0, 0, 26)
toggleRegionLoaderBtn.Position = UDim2.new(0.05, 0, 0, 328)
toggleRegionLoaderBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleRegionLoaderBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
toggleRegionLoaderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleRegionLoaderBtn.TextSize = 10
toggleRegionLoaderBtn.Font = Enum.Font.GothamBold
toggleRegionLoaderBtn.Parent = contentContainer

local btnCornerRegionLoader = Instance.new("UICorner")
btnCornerRegionLoader.CornerRadius = UDim.new(0, 6)
btnCornerRegionLoader.Parent = toggleRegionLoaderBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 22)
statusLabel.Position = UDim2.new(0.05, 0, 0, 362)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Trạng thái: Sẵn sàng..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentContainer

local isUSModeLoader = false
local isMinimized = false

-- LOGIC THU NHỎ / MỞ RỘNG BẰNG LOGO TRÒN "agg2"
logoBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        -- Thu nhỏ thành khung chỉ hiển thị thanh tiêu đề và logo tròn
        frame.Size = UDim2.new(0, 260, 0, 35)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then child.Visible = false end
        end
    else
        -- Mở rộng đầy đủ menu
        frame.Size = UDim2.new(0, 260, 0, 400)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then child.Visible = true end
        end
    end
end)

toggleRegionLoaderBtn.MouseButton1Click:Connect(function()
    isUSModeLoader = not isUSModeLoader
    if isUSModeLoader then
        toggleRegionLoaderBtn.Text = "🇺🇸 Region: US (English)"
        loadHugBtn.Text = "▶ Load Hug Tower Script"
        loadSlapBtn.Text = "▶ Load Slap Script"
        loadAllBtn.Text = "▶ Load All Game Script (TP.lua)"
        hugNote.Text = "📌 Note: Auto Kill All will NOT auto-release because of a bug. Please press manually."
        slapNote.Text = "📌 Note: Behind Detector must be ENABLED, otherwise Auto Guess will not work."
        statusLabel.Text = "Status: Ready..."
    else
        toggleRegionLoaderBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        loadHugBtn.Text = "▶ Tải Script Hug Tower"
        loadSlapBtn.Text = "▶ Tải Script Slap"
        loadAllBtn.Text = "▶ Tải All Game Script (TP.lua)"
        hugNote.Text = "📌 Lưu ý: Auto Kill All khi bật sẽ không tự động thả vì đang lỗi. Xin phép ấn thủ công nút thả nhé!"
        slapNote.Text = "📌 Lưu ý: Tính năng Dò Phía Sau phải bật, nếu không tính năng Auto Đoán sẽ không hoạt động."
        statusLabel.Text = "Trạng thái: Sẵn sàng..."
    end
end)

loadHugBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = isUSModeLoader and "Status: Loading Hug Tower..." or "Trạng thái: Đang tải Hug Tower..."
    local success = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/grab.lua"))()
    end)
    statusLabel.Text = success and (isUSModeLoader and "Status: Hug Tower loaded!" or "Trạng thái: Đã tải Hug Tower!") or (isUSModeLoader and "Status: Load failed!" or "Trạng thái: Tải thất bại!")
end)

loadSlapBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = isUSModeLoader and "Status: Loading Slapper..." or "Trạng thái: Đang tải Slap..."
    local success = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/slap.lua"))()
    end)
    statusLabel.Text = success and (isUSModeLoader and "Status: Slapper loaded!" or "Trạng thái: Đã tải Slap!") or (isUSModeLoader and "Status: Load failed!" or "Trạng thái: Tải thất bại!")
end)

loadAllBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = isUSModeLoader and "Status: Loading TP Script..." or "Trạng thái: Đang tải TP Script..."
    local success = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/tp.lua"))()
    end)
    statusLabel.Text = success and (isUSModeLoader and "Status: TP Script loaded!" or "Trạng thái: Đã tải TP Script!") or (isUSModeLoader and "Status: Load failed!" or "Trạng thái: Tải thất bại!")
end)
