-- =================================================================
-- SCRIPT LOADER CHÍNH - GAME SELECTOR MENU (FIX ĐỔI TÊN TOÀN BỘ NÚT)
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

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 345)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
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

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 26, 0, 22)
minimizeBtn.Position = UDim2.new(1, -30, 0, 6)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeBtn

local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = frame

-- Hug Tower Section
local hugTitle = Instance.new("TextLabel")
hugTitle.Size = UDim2.new(0.9, 0, 0, 20)
hugTitle.Position = UDim2.new(0.05, 0, 0, 42)
hugTitle.BackgroundTransparency = 1
hugTitle.Text = "🏰 Hug Tower Troll:"
hugTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
hugTitle.TextSize = 11
hugTitle.Font = Enum.Font.GothamBold
hugTitle.TextXAlignment = Enum.TextXAlignment.Left
hugTitle.Parent = contentContainer

local loadHugBtn = Instance.new("TextButton")
loadHugBtn.Size = UDim2.new(0.9, 0, 0, 28)
loadHugBtn.Position = UDim2.new(0.05, 0, 0, 64)
loadHugBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
loadHugBtn.Text = "▶ Tải Script Hug Tower"
loadHugBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadHugBtn.TextSize = 11
loadHugBtn.Font = Enum.Font.GothamBold
loadHugBtn.Parent = contentContainer

local hugBtnCorner = Instance.new("UICorner")
hugBtnCorner.CornerRadius = UDim.new(0, 6)
hugBtnCorner.Parent = loadHugBtn

local hugNote = Instance.new("TextLabel")
hugNote.Size = UDim2.new(0.9, 0, 0, 55)
hugNote.Position = UDim2.new(0.05, 0, 0, 96)
hugNote.BackgroundTransparency = 1
hugNote.Text = "📌 Lưu ý: Auto Kill All khi bật sẽ không tự động thả vì đang lỗi. Xin phép ấn thủ công nút thả nhé!"
hugNote.TextColor3 = Color3.fromRGB(200, 200, 200)
hugNote.TextSize = 9
hugNote.Font = Enum.Font.Gotham
hugNote.TextWrapped = true
hugNote.TextXAlignment = Enum.TextXAlignment.Left
hugNote.Parent = contentContainer

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 1)
divider.Position = UDim2.new(0.05, 0, 0, 156)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BorderSizePixel = 0
divider.Parent = contentContainer

-- Slap Section
local slapTitle = Instance.new("TextLabel")
slapTitle.Size = UDim2.new(0.9, 0, 0, 20)
slapTitle.Position = UDim2.new(0.05, 0, 0, 164)
slapTitle.BackgroundTransparency = 1
slapTitle.Text = "👋 Slapper (Slap):"
slapTitle.TextColor3 = Color3.fromRGB(255, 150, 0)
slapTitle.TextSize = 11
slapTitle.Font = Enum.Font.GothamBold
slapTitle.TextXAlignment = Enum.TextXAlignment.Left
slapTitle.Parent = contentContainer

local loadSlapBtn = Instance.new("TextButton")
loadSlapBtn.Size = UDim2.new(0.9, 0, 0, 28)
loadSlapBtn.Position = UDim2.new(0.05, 0, 0, 186)
loadSlapBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
loadSlapBtn.Text = "▶ Tải Script Slap"
loadSlapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadSlapBtn.TextSize = 11
loadSlapBtn.Font = Enum.Font.GothamBold
loadSlapBtn.Parent = contentContainer

local slapBtnCorner = Instance.new("UICorner")
slapBtnCorner.CornerRadius = UDim.new(0, 6)
slapBtnCorner.Parent = loadSlapBtn

local slapNote = Instance.new("TextLabel")
slapNote.Size = UDim2.new(0.9, 0, 0, 55)
slapNote.Position = UDim2.new(0.05, 0, 0, 218)
slapNote.BackgroundTransparency = 1
slapNote.Text = "📌 Lưu ý: Tính năng Dò Phía Sau phải bật, nếu không tính năng Auto Đoán sẽ không hoạt động."
slapNote.TextColor3 = Color3.fromRGB(200, 200, 200)
slapNote.TextSize = 9
slapNote.Font = Enum.Font.Gotham
slapNote.TextWrapped = true
slapNote.TextXAlignment = Enum.TextXAlignment.Left
slapNote.Parent = contentContainer

-- Nút chuyển US/VN
local toggleRegionLoaderBtn = Instance.new("TextButton")
toggleRegionLoaderBtn.Size = UDim2.new(0.9, 0, 0, 26)
toggleRegionLoaderBtn.Position = UDim2.new(0.05, 0, 0, 275)
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
statusLabel.Position = UDim2.new(0.05, 0, 0, 308)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Trạng thái: Sẵn sàng..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentContainer

local isUSModeLoader = false
local isMinimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        minimizeBtn.Text = "+"
        frame.Size = UDim2.new(0, 260, 0, 35)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then child.Visible = false end
        end
    else
        minimizeBtn.Text = "-"
        frame.Size = UDim2.new(0, 260, 0, 345)
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
        hugNote.Text = "📌 Note: Auto Kill All will NOT auto-release because of a bug. Please press the release button manually."
        slapNote.Text = "📌 Note: Behind Detector must be ENABLED, otherwise Auto Guess will not work."
        statusLabel.Text = "Status: Ready..."
    else
        toggleRegionLoaderBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        loadHugBtn.Text = "▶ Tải Script Hug Tower"
        loadSlapBtn.Text = "▶ Tải Script Slap"
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
