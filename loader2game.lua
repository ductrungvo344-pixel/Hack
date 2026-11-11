-- =================================================================
-- SCRIPT TP.LUA - ALL GAME SCRIPT (CÓ LOGO TRÒN "agg2" & US/VN)
-- =================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("TPMenuGUI") then playerGui.TPMenuGUI:Destroy() end
if CoreGui:FindFirstChild("TPMenuGUI") then CoreGui.TPMenuGUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 260)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "  🌐 ALL GAME SCRIPT (TP)"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- LOGO TRÒN "agg2" THU NHỎ / MỞ RỘNG
local logoBtn = Instance.new("TextButton")
logoBtn.Size = UDim2.new(0, 26, 0, 26)
logoBtn.Position = UDim2.new(1, -30, 0, 4)
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

local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = frame

-- Các thành phần bên trong
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(0.9, 0, 0, 45)
descLabel.Position = UDim2.new(0.05, 0, 0, 45)
descLabel.BackgroundTransparency = 1
descLabel.Text = "📌 Script chung hỗ trợ dịch chuyển và các tính năng phụ trợ cho nhiều game."
descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
descLabel.TextSize = 10
descLabel.Font = Enum.Font.Gotham
descLabel.TextWrapped = true
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.Parent = contentContainer

local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(0.9, 0, 0, 32)
actionBtn.Position = UDim2.new(0.05, 0, 0, 100)
actionBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
actionBtn.Text = "⚡ Kích hoạt tính năng TP"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.TextSize = 11
actionBtn.Font = Enum.Font.GothamBold
actionBtn.Parent = contentContainer

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = actionBtn

-- Nút chuyển US/VN
local toggleRegionBtn = Instance.new("TextButton")
toggleRegionBtn.Size = UDim2.new(0.9, 0, 0, 26)
toggleRegionBtn.Position = UDim2.new(0.05, 0, 0, 145)
toggleRegionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleRegionBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
toggleRegionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleRegionBtn.TextSize = 10
toggleRegionBtn.Font = Enum.Font.GothamBold
toggleRegionBtn.Parent = contentContainer

local btnCornerRegion = Instance.new("UICorner")
btnCornerRegion.CornerRadius = UDim.new(0, 6)
btnCornerRegion.Parent = toggleRegionBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0, 185)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Trạng thái: Sẵn sàng..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextWrapped = true
statusLabel.Parent = contentContainer

local isUSMode = false
local isMinimized = false

logoBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        frame.Size = UDim2.new(0, 240, 0, 35)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then child.Visible = false end
        end
    else
        frame.Size = UDim2.new(0, 240, 0, 260)
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") then child.Visible = true end
        end
    end
end)

toggleRegionBtn.MouseButton1Click:Connect(function()
    isUSMode = not isUSMode
    if isUSMode then
        toggleRegionBtn.Text = "🇺🇸 Region: US (English)"
        title.Text = "  🌐 ALL GAME SCRIPT (TP)"
        descLabel.Text = "📌 General script supporting teleportation and utilities for multiple games."
        actionBtn.Text = "⚡ Activate TP Feature"
        statusLabel.Text = "Status: Ready..."
    else
        toggleRegionBtn.Text = "🇻🇳 Khu vực: VN (Tiếng Việt)"
        title.Text = "  🌐 ALL GAME SCRIPT (TP)"
        descLabel.Text = "📌 Script chung hỗ trợ dịch chuyển và các tính năng phụ trợ cho nhiều game."
        actionBtn.Text = "⚡ Kích hoạt tính năng TP"
        statusLabel.Text = "Trạng thái: Sẵn sàng..."
    end
end)

actionBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = isUSMode and "Status: TP Feature executed!" or "Trạng thái: Đã thực thi tính năng TP!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
end)
