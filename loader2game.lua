-- =================================================================
-- SCRIPT LOADER CHÍNH - GAME SELECTOR MENU
-- =================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Xóa Loader GUI cũ nếu đã tồn tại
if playerGui:FindFirstChild("GameLoaderGUI") then
    playerGui.GameLoaderGUI:Destroy()
end
if CoreGui:FindFirstChild("GameLoaderGUI") then
    CoreGui.GameLoaderGUI:Destroy()
end

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameLoaderGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Khung chính của Loader
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 310)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Tiêu đề Loader
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

-- Nút thu nhỏ / mở rộng (-)
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

-- Container nội dung
local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = frame

-- =================================================================
-- PHẦN 1: HUG TOWER TROLL
-- =================================================================
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
loadHugBtn.Text = "▶ Load Hug Tower Script"
loadHugBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadHugBtn.TextSize = 11
loadHugBtn.Font = Enum.Font.GothamBold
loadHugBtn.Parent = contentContainer

local hugBtnCorner = Instance.new("UICorner")
hugBtnCorner.CornerRadius = UDim.new(0, 6)
hugBtnCorner.Parent = loadHugBtn

-- Ghi chú Hug Tower (Có Anh/Việt & US/VN)
local hugNote = Instance.new("TextLabel")
hugNote.Size = UDim2.new(0.9, 0, 0, 55)
hugNote.Position = UDim2.new(0.05, 0, 0, 96)
hugNote.BackgroundTransparency = 1
hugNote.Text = "📌 Note: Supports US/VN toggle!\n⚠️ Auto Kill All will NOT auto-release because of a bug. Please press the release button manually."
hugNote.TextColor3 = Color3.fromRGB(200, 200, 200)
hugNote.TextSize = 9
hugNote.Font = Enum.Font.Gotham
hugNote.TextWrapped = true
hugNote.TextXAlignment = Enum.TextXAlignment.Left
hugNote.Parent = contentContainer

-- Đường kẻ phân cách
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 1)
divider.Position = UDim2.new(0.05, 0, 0, 156)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BorderSizePixel = 0
divider.Parent = contentContainer

-- =================================================================
-- PHẦN 2: SLAPPER (SLAP)
-- =================================================================
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
loadSlapBtn.Text = "▶ Load Slap Script"
loadSlapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadSlapBtn.TextSize = 11
loadSlapBtn.Font = Enum.Font.GothamBold
loadSlapBtn.Parent = contentContainer

local slapBtnCorner = Instance.new("UICorner")
slapBtnCorner.CornerRadius = UDim.new(0, 6)
slapBtnCorner.Parent = loadSlapBtn

-- Ghi chú Slapper (Đã dịch sang tiếng Anh cho chuẩn, kèm US/VN)
local slapNote = Instance.new("TextLabel")
slapNote.Size = UDim2.new(0.9, 0, 0, 55)
slapNote.Position = UDim2.new(0.05, 0, 0, 218)
slapNote.BackgroundTransparency = 1
slapNote.Text = "📌 Note: Supports US/VN toggle!\n⚠️ Warning: Behind Detector must be ENABLED, otherwise Auto Guess will not work."
slapNote.TextColor3 = Color3.fromRGB(200, 200, 200)
slapNote.TextSize = 9
slapNote.Font = Enum.Font.Gotham
slapNote.TextWrapped = true
slapNote.TextXAlignment = Enum.TextXAlignment.Left
slapNote.Parent = contentContainer

-- Trạng thái thông báo ở đáy Loader
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 22)
statusLabel.Position = UDim2.new(0.05, 0, 0, 278)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready to load..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentContainer

-- =================================================================
-- LOGIC SỰ KIỆN
-- =================================================================

-- Thu nhỏ / Mở rộng Loader
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        minimizeBtn.Text = "+"
        frame.Size = UDim2.new(0, 260, 0, 35)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = false
            end
        end
    else
        minimizeBtn.Text = "-"
        frame.Size = UDim2.new(0, 260, 0, 310)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = true
            end
        end
    end
end)

-- Nút Load Hug Tower Script
loadHugBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Loading Hug Tower..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/grab.lua"))()
    end)
    
    if success then
        statusLabel.Text = "Status: Hug Tower loaded successfully!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        statusLabel.Text = "Status: Load failed!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        warn("Hug Tower Load Error:", err)
    end
end)

-- Nút Load Slapper Script
loadSlapBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Loading Slapper..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/slap.lua"))()
    end)
    
    if success then
        statusLabel.Text = "Status: Slapper loaded successfully!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        statusLabel.Text = "Status: Load failed!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        warn("Slapper Load Error:", err)
    end
end)

print("✅ Game Loader GUI loaded successfully for Trung!")
