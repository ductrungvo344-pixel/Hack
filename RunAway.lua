local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("NewGameGui") then CoreGui.NewGameGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NewGameGui"
ScreenGui.ResetOnSpawn = false

-- Thông báo nổi Whitelist
local NotifLabel = Instance.new("TextLabel", ScreenGui)
NotifLabel.Size = UDim2.new(0, 260, 0, 30)
NotifLabel.Position = UDim2.new(0.5, -130, 0, 10)
NotifLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NotifLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
NotifLabel.TextSize = 10
NotifLabel.Font = Enum.Font.GothamBold
NotifLabel.Text = ""
NotifLabel.Visible = false
Instance.new("UICorner", NotifLabel).CornerRadius = UDim.new(0, 5)

local function showNotif(msg)
    NotifLabel.Text = msg
    NotifLabel.Visible = true
    task.delay(2, function()
        if NotifLabel.Text == msg then
            NotifLabel.Visible = false
        end
    end)
end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 190, 0, 420)
MainFrame.Position = UDim2.new(0.5, -95, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 24)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 5)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -28, 1, 0)
Title.Position = UDim2.new(0, 6, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.Text = "🎁 Menu Game"
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Position = UDim2.new(1, -22, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 10
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 3)

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -24)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 24)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1550)
ScrollingFrame.ScrollBarThickness = 3

-- Kéo thả Menu chính
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, MainFrame.Position
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ScrollingFrame.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 24) or UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 420)
    MinimizeBtn.Text = minimized and "+" or "-"
end)

local function createBtn(parent, text, yPos, color, textColor)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -12, 0, 24)
    btn.Position = UDim2.new(0, 6, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(52, 152, 219)
    btn.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
    return btn
end

local function createTitle(parent, text, yPos)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.Position = UDim2.new(0, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    return lbl
end

local SavedTargetUserIds = {}
local SelectedPlayers = {}
local WhitelistUserIds = {}
_G.autoSelectAllNew = false 
local SavedWaypoints = {}
local spawnCFrame = nil

createTitle(ScrollingFrame, "--- GiveReward ---", 6)
local GiveRewardBtn = createBtn(ScrollingFrame, "📦 GiveReward", 24, Color3.fromRGB(41, 128, 185))

createTitle(ScrollingFrame, "--- Donate & Money ---", 52)
local DonateMoneyBtn = createBtn(ScrollingFrame, "💸 Thả 5000", 70, Color3.fromRGB(231, 76, 60))
local LoopDonateBtn = createBtn(ScrollingFrame, "🔄 Lặp Thả Tiền", 98, Color3.fromRGB(211, 84, 0))
local AutoTPMoneyBtn = createBtn(ScrollingFrame, "⚡ Auto TP Đến MoneyCoin", 126, Color3.fromRGB(39, 174, 96))

createTitle(ScrollingFrame, "--- SuperGlove (Danger Zone) ---", 154)
local KillAllBtn = createBtn(ScrollingFrame, "💀 Kill All (Godly)", 172, Color3.fromRGB(192, 57, 43))
local LoopKillAllBtn = createBtn(ScrollingFrame, "🔄 Lặp Kill All", 200, Color3.fromRGB(211, 84, 0))
local FlingBtn = createBtn(ScrollingFrame, "🌀 Fling All (-10)", 228, Color3.fromRGB(155, 89, 182))
local LoopFlingBtn = createBtn(ScrollingFrame, "🔄 Lặp Fling All", 256, Color3.fromRGB(211, 84, 0))
local OverkillFlingBtn = createBtn(ScrollingFrame, "💥 Overkill Fling", 284, Color3.fromRGB(192, 57, 43))
local LoopOverkillBtn = createBtn(ScrollingFrame, "🔄 Lặp Overkill", 312, Color3.fromRGB(211, 84, 0))
local TrollDonateBtn = createBtn(ScrollingFrame, "⚠️ [Danger] Thả Tiền -math.huge (Troll)", 340, Color3.fromRGB(120, 0, 0))
local LoopTrollDonateBtn = createBtn(ScrollingFrame, "⚠️ [Danger] Lặp Thả Tiền -math.huge", 368, Color3.fromRGB(100, 0, 0))

createTitle(ScrollingFrame, "--- Chọn Mục Tiêu (Bấm để chọn) ---", 396)
local AutoSelectAllBtn = createBtn(ScrollingFrame, "☑ Auto Chọn Tất Cả Mục Tiêu Mới", 414, Color3.fromRGB(127, 140, 141))
local OpenWhitelistGuiBtn = createBtn(ScrollingFrame, "📋 Bảng danh sách trắng", 442, Color3.fromRGB(142, 68, 173))

local PlayerListFrame = Instance.new("ScrollingFrame", ScrollingFrame)
PlayerListFrame.Size = UDim2.new(1, -12, 0, 100)
PlayerListFrame.Position = UDim2.new(0, 6, 0, 470)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.ScrollBarThickness = 3
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 3)

local UIListLayout = Instance.new("UIListLayout", PlayerListFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

local ServerCountLabel = createTitle(ScrollingFrame, "👥 Server: Đang quét...", 574)
ServerCountLabel.TextColor3 = Color3.fromRGB(46, 204, 113)

local TargetTitle = createTitle(ScrollingFrame, "--- Hành Động Mục Tiêu ---", 598)
local ViewCamBtn = createBtn(ScrollingFrame, "👁️ View Cam Mục Tiêu", 616, Color3.fromRGB(52, 152, 219))
local TPToTargetBtn = createBtn(ScrollingFrame, "📍 TP Mục Tiêu", 644, Color3.fromRGB(39, 174, 96))
local LoopTPTargetBtn = createBtn(ScrollingFrame, "🔄 Lặp Auto TP Mục Tiêu", 672, Color3.fromRGB(211, 84, 0))
local AutoTPAllBtn = createBtn(ScrollingFrame, "⚡ Auto TP Tất Cả Mọi Người", 700, Color3.fromRGB(46, 204, 113))
local TargetKillBtn = createBtn(ScrollingFrame, "🎯 Kill Mục Tiêu", 728, Color3.fromRGB(230, 126, 34))
local LoopTargetKillBtn = createBtn(ScrollingFrame, "🔄 Lặp Kill MT", 756, Color3.fromRGB(211, 84, 0))
local TargetFlingBtn = createBtn(ScrollingFrame, "🌀 Fling Mục Tiêu", 784, Color3.fromRGB(142, 68, 173))
local LoopTargetFlingBtn = createBtn(ScrollingFrame, "🔄 Lặp Fling MT", 812, Color3.fromRGB(211, 84, 0))
local TargetOverkillBtn = createBtn(ScrollingFrame, "🎯 Overkill MT", 840, Color3.fromRGB(230, 126, 34))
local LoopTargetOverkillBtn = createBtn(ScrollingFrame, "🔄 Lặp Overkill MT", 868, Color3.fromRGB(211, 84, 0))

createTitle(ScrollingFrame, "--- Dịch Chuyển & Điểm Spawn ---", 896)
local SaveWaypointBtn = createBtn(ScrollingFrame, "📍 Lưu Điểm Dịch Chuyển", 914, Color3.fromRGB(39, 174, 96))
local OpenWaypointGuiBtn = createBtn(ScrollingFrame, "🗺️ Quản Lý Điểm Dịch Chuyển", 942, Color3.fromRGB(41, 128, 185))
local SetSpawnBtn = createBtn(ScrollingFrame, "🏠 Lưu Điểm Spawn", 970, Color3.fromRGB(230, 126, 34))

createTitle(ScrollingFrame, "--- Khác ---", 1004)
local CobaltScriptBtn = createBtn(ScrollingFrame, "🚀 Chạy Script Cobalt", 1022, Color3.fromRGB(142, 68, 173))
local AntiLagBtn = createBtn(ScrollingFrame, "⚡ Auto Xóa Lag", 1050, Color3.fromRGB(127, 140, 141))
local AutoDelKillBlockBtn = createBtn(ScrollingFrame, "🗑️ Auto Xóa Khối Kill Chặn ([142])", 1078, Color3.fromRGB(192, 57, 43))
local AutoPromptBtn = createBtn(ScrollingFrame, "⚡ Auto Prompt", 1106, Color3.fromRGB(41, 128, 185))
local AutoDelSoundBtn = createBtn(ScrollingFrame, "🔇 Xóa Âm Thanh", 1134, Color3.fromRGB(142, 68, 173))
local FPSGuiBtn = createBtn(ScrollingFrame, "⏱️ Hiện Bảng Thông Số", 1162, Color3.fromRGB(52, 73, 94))
local ServerHopBtn = createBtn(ScrollingFrame, "🔄 Chuyển Server Khác", 1190, Color3.fromRGB(211, 84, 0))
local FreeGamePassBtn = createBtn(ScrollingFrame, "🎟️ Chạy Script Free GamePass", 1218, Color3.fromRGB(230, 126, 34))
local EmoteScriptBtn = createBtn(ScrollingFrame, "💃 Chạy Script Emote", 1246, Color3.fromRGB(155, 89, 182))
local InfiniteYieldBtn = createBtn(ScrollingFrame, "⚙️ Chạy Script Infinite Yield", 1274, Color3.fromRGB(52, 152, 219))

local FreeRewardTitle = createTitle(ScrollingFrame, "--- Free Rewards ---", 1318)
local AutoRewardBtn = createBtn(ScrollingFrame, "🎁 Nhận 3x Quà", 1336, Color3.fromRGB(241, 196, 15), Color3.fromRGB(30, 30, 30))

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1450)

local PasswordGui = Instance.new("Frame", ScreenGui)
PasswordGui.Size = UDim2.new(0, 220, 0, 110)
PasswordGui.Position = UDim2.new(0.5, -110, 0.5, -55)
PasswordGui.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
PasswordGui.BorderSizePixel = 0
PasswordGui.Visible = false
Instance.new("UICorner", PasswordGui).CornerRadius = UDim.new(0, 6)

local PWTitle = Instance.new("TextLabel", PasswordGui)
PWTitle.Size = UDim2.new(1, 0, 0, 26)
PWTitle.BackgroundTransparency = 1
PWTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
PWTitle.TextSize = 9
PWTitle.Font = Enum.Font.GothamBold
PWTitle.Text = "⚠️ NHẬP MẬT KHẨU: Danger"

local PWBox = Instance.new("TextBox", PasswordGui)
PWBox.Size = UDim2.new(1, -20, 0, 28)
PWBox.Position = UDim2.new(0, 10, 0, 32)
PWBox.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
PWBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PWBox.PlaceholderText = "Nhập mật khẩu..."
PWBox.Text = ""
PWBox.TextSize = 9
PWBox.Font = Enum.Font.GothamBold
Instance.new("UICorner", PWBox).CornerRadius = UDim.new(0, 4)

local PWConfirmBtn = Instance.new("TextButton", PasswordGui)
PWConfirmBtn.Size = UDim2.new(0.48, 0, 0, 26)
PWConfirmBtn.Position = UDim2.new(0, 10, 0, 72)
PWConfirmBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
PWConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PWConfirmBtn.TextSize = 9
PWConfirmBtn.Font = Enum.Font.GothamBold
PWConfirmBtn.Text = "Xác Nhận"
Instance.new("UICorner", PWConfirmBtn).CornerRadius = UDim.new(0, 4)

local PWCancelBtn = Instance.new("TextButton", PasswordGui)
PWCancelBtn.Size = UDim2.new(0.48, 0, 0, 26)
PWCancelBtn.Position = UDim2.new(0.52, 2, 0, 72)
PWCancelBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PWCancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PWCancelBtn.TextSize = 9
PWCancelBtn.Font = Enum.Font.GothamBold
PWCancelBtn.Text = "Hủy"
Instance.new("UICorner", PWCancelBtn).CornerRadius = UDim.new(0, 4)

local pendingAction = nil
PWCancelBtn.MouseButton1Click:Connect(function()
    PasswordGui.Visible = false
    PWBox.Text = ""
    pendingAction = nil
end)

PWConfirmBtn.MouseButton1Click:Connect(function()
    if PWBox.Text == "Danger" then
        PasswordGui.Visible = false
        showNotif("Mật khẩu chính xác! Đang thực thi...")
        if pendingAction then pendingAction() end
        PWBox.Text = ""
        pendingAction = nil
    else
        showNotif("Mật khẩu sai! Vui lòng nhập 'Danger'")
    end
end)

local DonateEvent = RS:WaitForChild("Donate_Money_Remotes"):WaitForChild("Give")

TrollDonateBtn.MouseButton1Click:Connect(function()
    pendingAction = function()
        pcall(function() DonateEvent:FireServer(-math.huge) end)
    end
    PasswordGui.Visible = true
end)

_G.th = false
LoopTrollDonateBtn.MouseButton1Click:Connect(function()
    if not _G.th then
        pendingAction = function()
            _G.th = true
            LoopTrollDonateBtn.Text = "⚠️ [Danger] Đang Lặp Troll (Bật)"
            LoopTrollDonateBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
            task.spawn(function()
                while _G.th do
                    pcall(function() DonateEvent:FireServer(-math.huge) end)
                    task.wait()
                end
            end)
        end
        PasswordGui.Visible = true
    else
        _G.th = false
        LoopTrollDonateBtn.Text = "⚠️ [Danger] Lặp Thả Tiền -math.huge"
        LoopTrollDonateBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        showNotif("Đã tắt lặp Troll -math.huge!")
    end
end)

CobaltScriptBtn.MouseButton1Click:Connect(function()
    pcall(function()
        showNotif("Đang chạy Script Cobalt...")
        loadstring(game:HttpGet("https://gitlab.com/upio/cobalt/-/releases/permalink/latest/downloads/Cobalt.luau"))()
    end)
end)

ServerHopBtn.MouseButton1Click:Connect(function()
    showNotif("Đang chuyển server...")
    pcall(function()
        local servers = {}
        local success, res = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success and res then
            local req = HttpService:JSONDecode(res)
            if req and req.data then
                for _, s in ipairs(req.data) do
                    if type(s) == "table" and s.playing and s.maxPlayers and s.id and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        table.insert(servers, s.id)
                    end
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end)

SaveWaypointBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.CFrame
            local name = "Điểm " .. (#SavedWaypoints + 1)
            table.insert(SavedWaypoints, {Name = name, CFrame = pos})
            showNotif("Đã lưu " .. name .. " thành công!")
        else
            showNotif("Không tìm thấy nhân vật để lưu điểm!")
        end
    end)
end)

local WaypointGui = Instance.new("Frame", ScreenGui)
WaypointGui.Size = UDim2.new(0, 240, 0, 260)
WaypointGui.Position = UDim2.new(0.5, -120, 0.5, -130)
WaypointGui.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
WaypointGui.BorderSizePixel = 0
WaypointGui.Visible = false
Instance.new("UICorner", WaypointGui).CornerRadius = UDim.new(0, 6)

local WPTopBar = Instance.new("Frame", WaypointGui)
WPTopBar.Size = UDim2.new(1, 0, 0, 26)
WPTopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
WPTopBar.BorderSizePixel = 0
Instance.new("UICorner", WPTopBar).CornerRadius = UDim.new(0, 6)

local WPTitle = Instance.new("TextLabel", WPTopBar)
WPTitle.Size = UDim2.new(1, -28, 1, 0)
WPTitle.Position = UDim2.new(0, 8, 0, 0)
WPTitle.BackgroundTransparency = 1
WPTitle.TextColor3 = Color3.fromRGB(52, 152, 219)
WPTitle.TextSize = 9
WPTitle.Font = Enum.Font.GothamBold
WPTitle.Text = "🗺️ Danh Sách Điểm Dịch Chuyển"
WPTitle.TextXAlignment = Enum.TextXAlignment.Left

local WPCancelBtn = Instance.new("TextButton", WPTopBar)
WPCancelBtn.Size = UDim2.new(0, 20, 0, 20)
WPCancelBtn.Position = UDim2.new(1, -22, 0, 3)
WPCancelBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
WPCancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WPCancelBtn.TextSize = 10
WPCancelBtn.Font = Enum.Font.GothamBold
WPCancelBtn.Text = "X"
Instance.new("UICorner", WPCancelBtn).CornerRadius = UDim.new(0, 3)

local WPScrolling = Instance.new("ScrollingFrame", WaypointGui)
WPScrolling.Size = UDim2.new(1, -12, 1, -36)
WPScrolling.Position = UDim2.new(0, 6, 0, 30)
WPScrolling.BackgroundTransparency = 1
WPScrolling.BorderSizePixel = 0
WPScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
WPScrolling.ScrollBarThickness = 3

local WPListLayout = Instance.new("UIListLayout", WPScrolling)
WPListLayout.SortOrder = Enum.SortOrder.LayoutOrder
WPListLayout.Padding = UDim.new(0, 3)

local wpDragging, wpDragInput, wpDragStart, wpStartPos
WPTopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wpDragging, wpDragStart, wpStartPos = true, input.Position, WaypointGui.Position
    end
end)
WPTopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then wpDragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == wpDragInput and wpDragging then
        local delta = input.Position - wpDragStart
        WaypointGui.Position = UDim2.new(wpStartPos.X.Scale, wpStartPos.X.Offset + delta.X, wpStartPos.Y.Scale, wpStartPos.Y.Offset + delta.Y)
    end
end)

WPCancelBtn.MouseButton1Click:Connect(function()
    WaypointGui.Visible = false
end)

local function refreshWaypointGui()
    for _, child in ipairs(WPScrolling:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for i, wp in ipairs(SavedWaypoints) do
        local row = Instance.new("Frame", WPScrolling)
        row.Size = UDim2.new(1, -4, 0, 26)
        row.BackgroundTransparency = 1
        
        local tpBtn = Instance.new("TextButton", row)
        tpBtn.Size = UDim2.new(1, -30, 1, 0)
        tpBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpBtn.TextSize = 8
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.Text = "📍 TP Đến " .. wp.Name
        tpBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 3)
        
        tpBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = wp.CFrame
                    showNotif("Đã dịch chuyển đến " .. wp.Name)
                end
            end)
        end)
        
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0, 26, 1, 0)
        delBtn.Position = UDim2.new(1, -26, 0, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.TextSize = 9
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Text = "X"
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 3)
        
        delBtn.MouseButton1Click:Connect(function()
            table.remove(SavedWaypoints, i)
            showNotif("Đã xóa " .. wp.Name)
            refreshWaypointGui()
        end)
    end
    WPScrolling.CanvasSize = UDim2.new(0, 0, 0, #SavedWaypoints * 29)
end

OpenWaypointGuiBtn.MouseButton1Click:Connect(function()
    WaypointGui.Visible = not WaypointGui.Visible
    if WaypointGui.Visible then refreshWaypointGui() end
end)

SetSpawnBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            spawnCFrame = char.HumanoidRootPart.CFrame
            showNotif("Đã đặt điểm Spawn thành công!")
            SetSpawnBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            SetSpawnBtn.Text = "🏠 Đã Lưu Điểm Spawn"
        else
            showNotif("Không tìm thấy nhân vật để đặt Spawn!")
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if spawnCFrame then
        task.spawn(function()
            pcall(function()
                local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
                if hrp then
                    task.wait(0.2)
                    hrp.CFrame = spawnCFrame
                    showNotif("Đã hồi sinh về điểm Spawn đã lưu!")
                end
            end)
        end)
    end
end)

FreeGamePassBtn.MouseButton1Click:Connect(function()
    pcall(function()
        showNotif("Đang chạy Script Free GamePass...")
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Gamepass-Product-212343"))()
    end)
end)

EmoteScriptBtn.MouseButton1Click:Connect(function()
    pcall(function()
        showNotif("Đang chạy Script Emote...")
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-Emote-Animation-Script-UGC-140678"))()
    end)
end)

InfiniteYieldBtn.MouseButton1Click:Connect(function()
    pcall(function()
        showNotif("Đang chạy Script Infinite Yield...")
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Infinite-Yield-FE-239454"))()
    end)
end)

local WhitelistGui = Instance.new("Frame", ScreenGui)
WhitelistGui.Size = UDim2.new(0, 240, 0, 280)
WhitelistGui.Position = UDim2.new(0.5, -120, 0.5, -140)
WhitelistGui.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
WhitelistGui.BorderSizePixel = 0
WhitelistGui.Visible = false
Instance.new("UICorner", WhitelistGui).CornerRadius = UDim.new(0, 6)

local WLTopBar = Instance.new("Frame", WhitelistGui)
WLTopBar.Size = UDim2.new(1, 0, 0, 26)
WLTopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
WLTopBar.BorderSizePixel = 0
Instance.new("UICorner", WLTopBar).CornerRadius = UDim.new(0, 6)

local WLTitle = Instance.new("TextLabel", WLTopBar)
WLTitle.Size = UDim2.new(1, -28, 1, 0)
WLTitle.Position = UDim2.new(0, 8, 0, 0)
WLTitle.BackgroundTransparency = 1
WLTitle.TextColor3 = Color3.fromRGB(241, 196, 15)
WLTitle.TextSize = 9
WLTitle.Font = Enum.Font.GothamBold
WLTitle.Text = "🛡️ Danh Sách Trắng (Tên Thật & Tên Ngoài)"
WLTitle.TextXAlignment = Enum.TextXAlignment.Left

local WLCancelBtn = Instance.new("TextButton", WLTopBar)
WLCancelBtn.Size = UDim2.new(0, 20, 0, 20)
WLCancelBtn.Position = UDim2.new(1, -22, 0, 3)
WLCancelBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
WLCancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WLCancelBtn.TextSize = 10
WLCancelBtn.Font = Enum.Font.GothamBold
WLCancelBtn.Text = "X"
Instance.new("UICorner", WLCancelBtn).CornerRadius = UDim.new(0, 3)

local WLScrolling = Instance.new("ScrollingFrame", WhitelistGui)
WLScrolling.Size = UDim2.new(1, -12, 1, -36)
WLScrolling.Position = UDim2.new(0, 6, 0, 30)
WLScrolling.BackgroundTransparency = 1
WLScrolling.BorderSizePixel = 0
WLScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
WLScrolling.ScrollBarThickness = 3

local WLListLayout = Instance.new("UIListLayout", WLScrolling)
WLListLayout.SortOrder = Enum.SortOrder.LayoutOrder
WLListLayout.Padding = UDim.new(0, 3)

local wlDragging, wlDragInput, wlDragStart, wlStartPos
WLTopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wlDragging, wlDragStart, wlStartPos = true, input.Position, WhitelistGui.Position
    end
end)
WLTopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then wlDragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == wlDragInput and wlDragging then
        local delta = input.Position - wlDragStart
        WhitelistGui.Position = UDim2.new(wlStartPos.X.Scale, wlStartPos.X.Offset + delta.X, wlStartPos.Y.Scale, wlStartPos.Y.Offset + delta.Y)
    end
end)

WLCancelBtn.MouseButton1Click:Connect(function()
    WhitelistGui.Visible = false
end)

local function refreshWhitelistGui()
    for _, child in ipairs(WLScrolling:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local btn = Instance.new("TextButton", WLScrolling)
            btn.Size = UDim2.new(1, -4, 0, 26)
            
            local isWhite = WhitelistUserIds[p.UserId]
            if isWhite then
                btn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
                btn.TextColor3 = Color3.fromRGB(30, 30, 30)
                btn.Text = "🛡️ " .. p.DisplayName .. " (@" .. p.Name .. ")"
            else
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Text = "☐ " .. p.DisplayName .. " (@" .. p.Name .. ")"
            end
            
            btn.TextSize = 8
            btn.Font = Enum.Font.GothamBold
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
            
            btn.MouseButton1Click:Connect(function()
                if WhitelistUserIds[p.UserId] then
                    WhitelistUserIds[p.UserId] = nil
                    showNotif("Đã gỡ " .. p.Name .. " khỏi Whitelist")
                else
                    WhitelistUserIds[p.UserId] = true
                    SelectedPlayers[p] = nil
                    SavedTargetUserIds[p.UserId] = nil
                    showNotif("Đã thêm " .. p.Name .. " vào Whitelist!")
                end
                refreshWhitelistGui()
            end)
        end
    end
    WLScrolling.CanvasSize = UDim2.new(0, 0, 0, count * 29)
end

OpenWhitelistGuiBtn.MouseButton1Click:Connect(function()
    WhitelistGui.Visible = not WhitelistGui.Visible
    if WhitelistGui.Visible then refreshWhitelistGui() end
end)

local function refreshPlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton", PlayerListFrame)
            pBtn.Size = UDim2.new(1, -4, 0, 22)
            
            local isWhite = WhitelistUserIds[p.UserId]
            if isWhite then
                pBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
                pBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
            else
                pBtn.BackgroundColor3 = SelectedPlayers[p] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
                pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            pBtn.TextSize = 8
            pBtn.Font = Enum.Font.GothamBold
            
            local prefix = isWhite and "🛡️ [Safe] " or (SelectedPlayers[p] and "☑ " or "☐ ")
            pBtn.Text = prefix .. p.DisplayName .. " (@" .. p.Name .. ")"
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 3)
            
            pBtn.MouseButton1Click:Connect(function()
                if WhitelistUserIds[p.UserId] then
                    showNotif(p.Name .. " đang ở danh sách trắng!")
                else
                    SelectedPlayers[p] = not SelectedPlayers[p]
                    if SelectedPlayers[p] then
                        SavedTargetUserIds[p.UserId] = true
                    else
                        SavedTargetUserIds[p.UserId] = nil
                    end
                end
                refreshPlayerList()
            end)
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 24)
    ServerCountLabel.Text = "👥 Server hiện tại: " .. (#Players:GetPlayers()) .. " người chơi"
end

AutoSelectAllBtn.MouseButton1Click:Connect(function()
    _G.autoSelectAllNew = not _G.autoSelectAllNew
    if _G.autoSelectAllNew then
        AutoSelectAllBtn.Text = "☑ Auto Chọn Tất Cả Mục Tiêu Mới (Đang Bật)"
        AutoSelectAllBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not WhitelistUserIds[p.UserId] then
                SelectedPlayers[p] = true
                SavedTargetUserIds[p.UserId] = true
            end
        end
        refreshPlayerList()
    else
        AutoSelectAllBtn.Text = "☐ Auto Chọn Tất Cả Mục Tiêu Mới (Đang Tắt)"
        AutoSelectAllBtn.BackgroundColor3 = Color3.fromRGB(127, 140, 141)
    end
end)

Players.PlayerAdded:Connect(function(p)
    if not WhitelistUserIds[p.UserId] then
        if _G.autoSelectAllNew and p ~= LocalPlayer then
            SelectedPlayers[p] = true
            SavedTargetUserIds[p.UserId] = true
        elseif SavedTargetUserIds[p.UserId] then
            SelectedPlayers[p] = true
        end
    end
    refreshPlayerList()
    if WhitelistGui.Visible then refreshWhitelistGui() end
end)

Players.PlayerRemoving:Connect(function(p)
    SelectedPlayers[p] = nil
    refreshPlayerList()
    if WhitelistGui.Visible then refreshWhitelistGui() end
end)

task.spawn(refreshPlayerList)

local function getTargetPlayers()
    local list = {}
    for p, selected in pairs(SelectedPlayers) do
        if selected and p and p.Parent and not WhitelistUserIds[p.UserId] then
            table.insert(list, p)
        end
    end
    return list
end

local viewing = false
ViewCamBtn.MouseButton1Click:Connect(function()
    viewing = not viewing
    if viewing then
        ViewCamBtn.Text = "👁️ Đang View (Bật)"
        ViewCamBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        task.spawn(function()
            while viewing do
                pcall(function()
                    local targets = getTargetPlayers()
                    if #targets > 0 and targets[1].Character and targets[1].Character:FindFirstChild("HumanoidRootPart") then
                        Camera.CameraSubject = targets[1].Character.Humanoid
                    end
                end)
                task.wait(0.1)
            end
        end)
    else
        ViewCamBtn.Text = "👁️ View Cam Mục Tiêu"
        ViewCamBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end)
    end
end)

TPToTargetBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local targets = getTargetPlayers()
        if #targets > 0 and targets[1].Character and targets[1].Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targets[1].Character.HumanoidRootPart
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
end)

_G.ltp = false
LoopTPTargetBtn.MouseButton1Click:Connect(function()
    _G.ltp = not _G.ltp
    LoopTPTargetBtn.Text = _G.ltp and "🔄 Đang Auto TP MT (Bật)" or "🔄 Lặp Auto TP Mục Tiêu"
    LoopTPTargetBtn.BackgroundColor3 = _G.ltp and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.ltp then
        task.spawn(function()
            while _G.ltp do
                pcall(function()
                    local targets = getTargetPlayers()
                    if #targets > 0 and targets[1].Character and targets[1].Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = targets[1].Character.HumanoidRootPart
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            myChar.HumanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

_G.atpAll = false
AutoTPAllBtn.MouseButton1Click:Connect(function()
    _G.atpAll = not _G.atpAll
    AutoTPAllBtn.Text = _G.atpAll and "⚡ Đang Auto TP Tất Cả (Bật)" or "⚡ Auto TP Tất Cả Mọi Người"
    AutoTPAllBtn.BackgroundColor3 = _G.atpAll and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(46, 204, 113)
    if _G.atpAll then
        task.spawn(function()
            while _G.atpAll do
                pcall(function()
                    for _, p in ipairs(Players:GetPlayers()) do
                        if not _G.atpAll then break end
                        if p ~= LocalPlayer and not WhitelistUserIds[p.UserId] and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local targetHRP = p.Character.HumanoidRootPart
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                myChar.HumanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
                            end
                            task.wait(0.3)
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

local RewardEvent = RS:WaitForChild("CratesUtilities"):WaitForChild("Remotes"):WaitForChild("GiveReward")
local FreeGearEvent = RS:WaitForChild("FreeGear_Remotes"):WaitForChild("FreeGearEvent")

GiveRewardBtn.MouseButton1Click:Connect(function()
    pcall(function() RewardEvent:FireServer(math.huge) end)
end)

DonateMoneyBtn.MouseButton1Click:Connect(function()
    pcall(function() DonateEvent:FireServer(5000) end)
end)

_G.h = false
LoopDonateBtn.MouseButton1Click:Connect(function()
    _G.h = not _G.h
    LoopDonateBtn.Text = _G.h and "🔄 Đang Thả (Bật)" or "🔄 Lặp Thả Tiền"
    LoopDonateBtn.BackgroundColor3 = _G.h and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.h then
        task.spawn(function()
            while _G.h do
                pcall(function() DonateEvent:FireServer(5000) end)
                task.wait()
            end
        end)
    end
end)

_G.atpMoney = false
AutoTPMoneyBtn.MouseButton1Click:Connect(function()
    _G.atpMoney = not _G.atpMoney
    AutoTPMoneyBtn.Text = _G.atpMoney and "⚡ Auto TP Money (Bật)" or "⚡ Auto TP Đến MoneyCoin"
    AutoTPMoneyBtn.BackgroundColor3 = _G.atpMoney and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(39, 174, 96)
    if _G.atpMoney then
        task.spawn(function()
            while _G.atpMoney do
                pcall(function()
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if not _G.atpMoney then break end
                            if obj.Name == "MoneyCoin" and obj:IsA("BasePart") then
                                myChar.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                                task.wait(0.15)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

KillAllBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
        if glove then
            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and not WhitelistUserIds[v.UserId] and v.Character then
                    glove.Event:FireServer("slash", v.Character, Vector3.new(-math.huge, -math.huge, -math.huge))
                end
            end
        end
    end)
end)

_G.k = false
LoopKillAllBtn.MouseButton1Click:Connect(function()
    _G.k = not _G.k
    LoopKillAllBtn.Text = _G.k and "🔄 Đang Kill (Bật)" or "🔄 Lặp Kill All"
    LoopKillAllBtn.BackgroundColor3 = _G.k and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.k then
        task.spawn(function()
            while _G.k do
                pcall(function()
                    local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
                    if glove then
                        for _, v in ipairs(Players:GetPlayers()) do
                            if v ~= LocalPlayer and not WhitelistUserIds[v.UserId] and v.Character then
                                glove.Event:FireServer("slash", v.Character, Vector3.new(-math.huge, -math.huge, -math.huge))
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

FlingBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
        if glove then
            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and not WhitelistUserIds[v.UserId] and v.Character then
                    glove.Event:FireServer("slash", v.Character, Vector3.new(-10, -10, -10))
                end
            end
        end
    end)
end)

_G.f = false
LoopFlingBtn.MouseButton1Click:Connect(function()
    _G.f = not _G.f
    LoopFlingBtn.Text = _G.f and "🔄 Đang Fling (Bật)" or "🔄 Lặp Fling All"
    LoopFlingBtn.BackgroundColor3 = _G.f and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.f then
        task.spawn(function()
            while _G.f do
                pcall(function()
                    local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
                    if glove then
                        for _, v in ipairs(Players:GetPlayers()) do
                            if v ~= LocalPlayer and not WhitelistUserIds[v.UserId] and v.Character then
                                glove.Event:FireServer("slash", v.Character, Vector3.new(-10, -10, -10))
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

OverkillFlingBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local overGlove = (LocalPlayer.Backpack:FindFirstChild("OverGlove") or (char and char:FindFirstChild("OverGlove")))
        if overGlove and overGlove:FindFirstChild("Event") then
            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and not WhitelistUserIds[v.UserId] and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    overGlove.Event:FireServer("slash", v.Character, Vector3.new(-59.205745697021, 3.163065898093e-08, -9.7303619384766))
                end
            end
        end
    end)
end)

_G.of = false
LoopOverkillBtn.MouseButton1Click:Connect(function()
    _G.of = not _G.of
    LoopOverkillBtn.Text = _G.of and "🔄 Đang Overkill (Bật)" or "🔄 Lặp Overkill"
    LoopOverkillBtn.BackgroundColor3 = _G.of and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.of then
        task.spawn(function()
            while _G.of do
                pcall(function()
                    local char = LocalPlayer.Character
                    local overGlove = (LocalPlayer.Backpack:FindFirstChild("OverGlove") or (char and char:FindFirstChild("OverGlove")))
                    if overGlove and overGlove:FindFirstChild("Event") then
                        for _, v in ipairs(Players:GetPlayers()) do
                            if v ~= LocalPlayer and not WhitelistUserIds[v.UserId] and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                overGlove.Event:FireServer("slash", v.Character, Vector3.new(-59.205745697021, 3.163065898093e-08, -9.7303619384766))
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

TargetKillBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local targets = getTargetPlayers()
        local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
        if glove then
            for _, target in ipairs(targets) do
                if target and target.Character then
                    glove.Event:FireServer("slash", target.Character, Vector3.new(-math.huge, -math.huge, -math.huge))
                end
            end
        end
    end)
end)

_G.tk = false
LoopTargetKillBtn.MouseButton1Click:Connect(function()
    _G.tk = not _G.tk
    LoopTargetKillBtn.Text = _G.tk and "🔄 Đang Kill MT (Bật)" or "🔄 Lặp Kill MT"
    LoopTargetKillBtn.BackgroundColor3 = _G.tk and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.tk then
        task.spawn(function()
            while _G.tk do
                pcall(function()
                    local targets = getTargetPlayers()
                    local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
                    if glove then
                        for _, target in ipairs(targets) do
                            if target and target.Character then
                                glove.Event:FireServer("slash", target.Character, Vector3.new(-math.huge, -math.huge, -math.huge))
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

TargetFlingBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local targets = getTargetPlayers()
        local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
        if glove then
            for _, target in ipairs(targets) do
                if target and target.Character then
                    glove.Event:FireServer("slash", target.Character, Vector3.new(-10, -10, -10))
                end
            end
        end
    end)
end)

_G.tf = false
LoopTargetFlingBtn.MouseButton1Click:Connect(function()
    _G.tf = not _G.tf
    LoopTargetFlingBtn.Text = _G.tf and "🔄 Đang Fling MT (Bật)" or "🔄 Lặp Fling MT"
    LoopTargetFlingBtn.BackgroundColor3 = _G.tf and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.tf then
        task.spawn(function()
            while _G.tf do
                pcall(function()
                    local targets = getTargetPlayers()
                    local glove = (LocalPlayer.Backpack:FindFirstChild("GodlyGlove") or LocalPlayer.Character:FindFirstChild("GodlyGlove"))
                    if glove then
                        for _, target in ipairs(targets) do
                            if target and target.Character then
                                glove.Event:FireServer("slash", target.Character, Vector3.new(-10, -10, -10))
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

TargetOverkillBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local targets = getTargetPlayers()
        local char = LocalPlayer.Character
        local overGlove = (LocalPlayer.Backpack:FindFirstChild("OverGlove") or (char and char:FindFirstChild("OverGlove")))
        if overGlove and overGlove:FindFirstChild("Event") then
            for _, target in ipairs(targets) do
                if target and target.Character then
                    overGlove.Event:FireServer("slash", target.Character, Vector3.new(2.0424394607544, 2.9838051887054e-06, 59.965229034424))
                end
            end
        end
    end)
end)

_G.tof = false
LoopTargetOverkillBtn.MouseButton1Click:Connect(function()
    _G.tof = not _G.tof
    LoopTargetOverkillBtn.Text = _G.tof and "🔄 Đang Overkill MT (Bật)" or "🔄 Lặp Overkill MT"
    LoopTargetOverkillBtn.BackgroundColor3 = _G.tof and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if _G.tof then
        task.spawn(function()
            while _G.tof do
                pcall(function()
                    local targets = getTargetPlayers()
                    local char = LocalPlayer.Character
                    local overGlove = (LocalPlayer.Backpack:FindFirstChild("OverGlove") or (char and char:FindFirstChild("OverGlove")))
                    if overGlove and overGlove:FindFirstChild("Event") then
                        for _, target in ipairs(targets) do
                            if target and target.Character then
                                overGlove.Event:FireServer("slash", target.Character, Vector3.new(2.0424394607544, 2.9838051887054e-06, 59.965229034424))
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

local function cleanMoneyCoin(moneyCoin)
    if moneyCoin and moneyCoin.Name == "MoneyCoin" then
        pcall(function()
            local textMoney = moneyCoin:FindFirstChild("text_money")
            if textMoney then textMoney:Destroy() end
            local particle = moneyCoin:FindFirstChild("particle")
            if particle then particle:Destroy() end
        end)
    end
end

_G.d = false
AntiLagBtn.MouseButton1Click:Connect(function()
    _G.d = not _G.d
    AntiLagBtn.Text = _G.d and "⚡ Auto Xóa Lag (Bật)" or "⚡ Auto Xóa Lag"
    AntiLagBtn.BackgroundColor3 = _G.d and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(127, 140, 141)
    if _G.d then
        task.spawn(function()
            for _, obj in ipairs(Workspace:GetChildren()) do cleanMoneyCoin(obj) end
            local connection
            connection = Workspace.ChildAdded:Connect(function(child)
                if not _G.d then connection:Disconnect() return end
                if child.Name == "MoneyCoin" then
                    task.spawn(function() task.wait(0.05) cleanMoneyCoin(child) end)
                end
            end)
            while _G.d do
                pcall(function()
                    for _, obj in ipairs(Workspace:GetChildren()) do cleanMoneyCoin(obj) end
                end)
                task.wait(0.5)
            end
            if connection then connection:Disconnect() end
        end)
    end
end)

_G.adc = false
AutoDelKillBlockBtn.MouseButton1Click:Connect(function()
    _G.adc = not _G.adc
    AutoDelKillBlockBtn.Text = _G.adc and "🗑️ Auto Xóa Khối Kill Chặn (Bật)" or "🗑️ Auto Xóa Khối Kill Chặn ([142])"
    AutoDelKillBlockBtn.BackgroundColor3 = _G.adc and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(192, 57, 43)
    if _G.adc then
        task.spawn(function()
            while _G.adc do
                pcall(function()
                    local children = Workspace:GetChildren()
                    if #children >= 142 then
                        local killBlock = children[142]
                        if killBlock then
                            killBlock:Destroy()
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

_G.ap = false
AutoPromptBtn.MouseButton1Click:Connect(function()
    _G.ap = not _G.ap
    AutoPromptBtn.Text = _G.ap and "⚡ Auto Prompt (Bật)" or "⚡ Auto Prompt"
    AutoPromptBtn.BackgroundColor3 = _G.ap and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(41, 128, 185)
    if _G.ap then
        task.spawn(function()
            while _G.ap do
                pcall(function()
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        if obj.Name == "MoneyCoin" then
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then
                                prompt.HoldDuration = 0
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

_G.as = false
AutoDelSoundBtn.MouseButton1Click:Connect(function()
    _G.as = not _G.as
    AutoDelSoundBtn.Text = _G.as and "🔇 Xóa Âm Thanh (Bật)" or "🔇 Xóa Âm Thanh"
    AutoDelSoundBtn.BackgroundColor3 = _G.as and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(142, 68, 173)
    if _G.as then
        task.spawn(function()
            local sound = SoundService:FindFirstChild("SUCESS_PURCHASE")
            if sound then pcall(function() sound:Destroy() end) end
            local soundConnection
            soundConnection = SoundService.ChildAdded:Connect(function(child)
                if not _G.as then soundConnection:Disconnect() return end
                if child.Name == "SUCESS_PURCHASE" then pcall(function() child:Destroy() end) end
            end)
            while _G.as do
                pcall(function()
                    local s = SoundService:FindFirstChild("SUCESS_PURCHased") or SoundService:FindFirstChild("SUCSS_PURCHASE")
                    if s then s:Destroy() end
                end)
                task.wait(0.5)
            end
            if soundConnection then soundConnection:Disconnect() end
        end)
    end
end)

local StatsGui = Instance.new("Frame", ScreenGui)
StatsGui.Size = UDim2.new(0, 215, 0, 22)
StatsGui.Position = UDim2.new(0.5, -107, 0, 10)
StatsGui.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatsGui.BorderSizePixel = 0
StatsGui.Visible = false
Instance.new("UICorner", StatsGui).CornerRadius = UDim.new(0, 4)

local StatsText = Instance.new("TextLabel", StatsGui)
StatsText.Size = UDim2.new(1, -18, 1, 0)
StatsText.Position = UDim2.new(0, 6, 0, 0)
StatsText.BackgroundTransparency = 1
StatsText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsText.TextSize = 8
StatsText.Font = Enum.Font.GothamBold
StatsText.Text = "FPS: 60 | Ping: 0ms | TPS: 60 | Coins: 0"
StatsText.TextXAlignment = Enum.TextXAlignment.Left

local LockStatsBtn = Instance.new("TextButton", StatsGui)
LockStatsBtn.Size = UDim2.new(0, 14, 0, 14)
LockStatsBtn.Position = UDim2.new(1, -15, 0, 4)
LockStatsBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
LockStatsBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
LockStatsBtn.TextSize = 7
LockStatsBtn.Font = Enum.Font.GothamBold
LockStatsBtn.Text = "🔓"
Instance.new("UICorner", LockStatsBtn).CornerRadius = UDim.new(0, 2)

local statsLocked = false
local statsDragging, statsDragInput, statsDragStart, statsStartPos

StatsGui.InputBegan:Connect(function(input)
    if not statsLocked and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        statsDragging, statsDragStart, statsStartPos = true, input.Position, StatsGui.Position
    end
end)

StatsGui.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        statsDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not statsLocked and input == statsDragInput and statsDragging then
        local delta = input.Position - statsDragStart
        StatsGui.Position = UDim2.new(statsStartPos.X.Scale, statsStartPos.X.Offset + delta.X, statsStartPos.Y.Scale, statsStartPos.Y.Offset + delta.Y)
    end
end)

LockStatsBtn.MouseButton1Click:Connect(function()
    statsLocked = not statsLocked
    if statsLocked then
        LockStatsBtn.Text = "🔒"
        LockStatsBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
        LockStatsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        showNotif("Đã khóa vị trí bảng thông số!")
    else
        LockStatsBtn.Text = "🔓"
        LockStatsBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        LockStatsBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
        showNotif("Đã mở khóa vị trí bảng thông số!")
    end
end)

local statsActive = false
FPSGuiBtn.MouseButton1Click:Connect(function()
    statsActive = not statsActive
    StatsGui.Visible = statsActive
    if statsActive then
        FPSGuiBtn.Text = "⏱️ Hiện Bảng Thông Số (Bật)"
        FPSGuiBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        
        task.spawn(function()
            local lastTick = tick()
            local frameCount = 0
            local currentFps = 60
            local currentPing = 0
            local currentTps = 60
            local coinCount = 0
            
            local tpsTick = tick()
            local tpsCount = 0
            
            local heartbeatConnection
            heartbeatConnection = RunService.Heartbeat:Connect(function(step)
                if not statsActive then
                    heartbeatConnection:Disconnect()
                    return
                end
                tpsCount = tpsCount + 1
                local curTick = tick()
                if curTick - tpsTick >= 0.5 then
                    currentTps = math.floor(tpsCount / (curTick - tpsTick) + 0.5)
                    tpsCount = 0
                    tpsTick = curTick
                end
            end)
            
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not statsActive then
                    connection:Disconnect()
                    return
                end
                frameCount = frameCount + 1
                local currentTick = tick()
                if currentTick - lastTick >= 0.5 then
                    currentFps = math.floor(frameCount / (currentTick - lastTick) + 0.5)
                    frameCount = 0
                    lastTick = currentTick
                end
            end)
            
            task.spawn(function()
                while statsActive do
                    pcall(function()
                        local count = 0
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if obj.Name == "MoneyCoin" then
                                count = count + 1
                            end
                        end
                        coinCount = count
                    end)
                    task.wait(0.1)
                end
            end)
            
            while statsActive do
                pcall(function()
                    currentPing = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)
                    StatsText.Text = "FPS: " .. currentFps .. " | Ping: " .. currentPing .. "ms | TPS: " .. currentTps .. " | Coins: " .. coinCount
                end)
                task.wait(0.5)
            end
        end)
    else
        FPSGuiBtn.Text = "⏱️ Hiện Bảng Thông Số"
        FPSGuiBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    end
end)

AutoRewardBtn.MouseButton1Click:Connect(function()
    pcall(function()
        for i = 2, 3 do
            FreeGearEvent:FireServer(LocalPlayer)
            task.wait(0.1)
        end
    end)
end)

showNotif("Đã tải Menu thành công!")
