local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

if game.GameId ~= 9644061244 and game.PlaceId ~= 9644061244 then
    LocalPlayer:Kick("Xin hãy vào Đúng Game")
    return
end

if CoreGui:FindFirstChild("FullGameGui") then CoreGui.FullGameGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FullGameGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 440)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Text = "🚢 Menu Tổng Hợp [All Checkpoints]"
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 2.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -35)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 3300)
ScrollingFrame.ScrollBarThickness = 4

-- Kéo thả GUI
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
    MainFrame.Size = minimized and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 440)
    MinimizeBtn.Text = minimized and "+" or "-"
end)

local function createBtn(parent, text, yPos, color, textColor)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(52, 152, 219)
    btn.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local function createBox(parent, placeholder, defaultText, yPos)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(1, -20, 0, 35)
    box.Position = UDim2.new(0, 10, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    box.Font = Enum.Font.GothamBold
    box.PlaceholderText = placeholder
    box.Text = defaultText
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    return box
end

local function createTitle(parent, text, yPos)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Position = UDim2.new(0, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    return lbl
end

-- Tạo các nút chính
local FlyBtn = createBtn(ScrollingFrame, "✈️ Bật Chức Năng Bay", 15)
local SpawnBtn1 = createBtn(ScrollingFrame, "Spawn Thuyền Cao Cấp", 60, Color3.fromRGB(0, 170, 255))
local SpawnBtn2 = createBtn(ScrollingFrame, "🛡️ Thuyền An Toàn 90%", 104, Color3.fromRGB(46, 204, 113))
local SpawnBtn3 = createBtn(ScrollingFrame, "👥 Thuyền Nhiều Người 65%", 148, Color3.fromRGB(52, 73, 94))
local SpawnBtn4 = createBtn(ScrollingFrame, "🔥 Thuyền Nhiều Nitro (Không An Toàn)", 192, Color3.fromRGB(231, 76, 60))

createTitle(ScrollingFrame, "--- Tăng Cường Thuyền (Vô Hạn Beta) ---", 240)
local BoostBox = createBox(ScrollingFrame, "Nhập số lượng vô hạn...", "4", 270)
local BoostBtn = createBtn(ScrollingFrame, "🚀 Áp Dụng Tăng Cường", 312, Color3.fromRGB(231, 76, 60))
local LoopBoostBtn = createBtn(ScrollingFrame, "🔄 Lặp Lại Tăng Cường (Tắt)", 354, Color3.fromRGB(192, 57, 43))
local TestBillionBtn = createBtn(ScrollingFrame, "⚡ Test Nhanh: 1 -> 1 Tỷ Boost", 399, Color3.fromRGB(142, 68, 173))

createTitle(ScrollingFrame, "--- Tiền & Tên Lửa ---", 444)
local CashBox = createBox(ScrollingFrame, "Nhập tiền (1 - 19999)...", "402", 474)
local CashBtn = createBtn(ScrollingFrame, "💰 Nhận Tiền", 516, Color3.fromRGB(39, 174, 96))
local LoopCashBtn = createBtn(ScrollingFrame, "🔄 Lặp Lại Nhận Tiền (Tắt)", 559, Color3.fromRGB(211, 84, 0))
local RocketBtn = createBtn(ScrollingFrame, "🚀 Tặng Máy Phóng Tên Lửa", 604, Color3.fromRGB(192, 57, 43))

-- Hàm tạo danh sách Checkpoints tự động rút gọn
local function renderCheckpoints(titleText, startY, list, colorWin, colorNormal)
    createTitle(ScrollingFrame, titleText, startY - 30)
    for i, cp in ipairs(list) do
        local isWin = (i == #list)
        local btn = createBtn(ScrollingFrame, cp.name, startY + (i - 1) * 40, isWin and colorWin or colorNormal, isWin and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(255, 255, 255))
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.MouseButton1Click:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(cp.pos)
                    btn.Text = "✅ Đã TP!"
                    task.wait(1.5)
                    btn.Text = cp.name
                end
            end)
        end)
    end
end

renderCheckpoints("--- Checkpoint Thế Giới 1 ---", 675, {
    {name = "🏁 Thế Giới 1 - CP 1", pos = Vector3.new(41, 2998, -1372)},
    {name = "🏁 Thế Giới 1 - CP 2", pos = Vector3.new(40, 2320, -4449)},
    {name = "🏁 Thế Giới 1 - CP 3", pos = Vector3.new(40, 1608, -6682)},
    {name = "🏁 Thế Giới 1 - CP 4", pos = Vector3.new(38, 1289, -9093)},
    {name = "🏁 Thế Giới 1 - CP 5", pos = Vector3.new(38, 1063, -11029)},
    {name = "🏁 Thế Giới 1 - CP 6", pos = Vector3.new(38, 903, -13868)},
    {name = "🏁 Thế Giới 1 - CP 7", pos = Vector3.new(38, 267, -15736)},
    {name = "🏁 Thế Giới 1 - CP 8", pos = Vector3.new(38, 262, -16386)},
    {name = "🏆 Thế Giới 1 - CP 9 (Win)", pos = Vector3.new(37, 20, -17998)},
}, Color3.fromRGB(241, 196, 15), Color3.fromRGB(142, 68, 173))

renderCheckpoints("--- Checkpoint Thế Giới 2 ---", 1075, {
    {name = "🏁 Thế Giới 2 - CP 1", pos = Vector3.new(-710, 2992, -1258)},
    {name = "🏁 Thế Giới 2 - CP 2", pos = Vector3.new(-710, 2906, -2277)},
    {name = "🏁 Thế Giới 2 - CP 3", pos = Vector3.new(-710, 1713, -6224)},
    {name = "🏁 Thế Giới 2 - CP 4", pos = Vector3.new(-1176, 1463, -7127)},
    {name = "🏁 Thế Giới 2 - CP 5", pos = Vector3.new(-1152, 1255, -8566)},
    {name = "🏁 Thế Giới 2 - CP 6", pos = Vector3.new(-1152, 1046, -9793)},
    {name = "🏁 Thế Giới 2 - CP 7", pos = Vector3.new(-1152, 836, -11675)},
    {name = "🏁 Thế Giới 2 - CP 8", pos = Vector3.new(-1152, 446, -13839)},
    {name = "🏁 Thế Giới 2 - CP 9", pos = Vector3.new(-1152, 442, -14643)},
    {name = "🏆 Thế Giới 2 - CP 10 (Win)", pos = Vector3.new(-1157, 18, -15072)},
}, Color3.fromRGB(241, 196, 15), Color3.fromRGB(41, 128, 185))

renderCheckpoints("--- Checkpoint Thế Giới 3 ---", 1525, {
    {name = "🏁 Thế Giới 3 - CP 1", pos = Vector3.new(-2413, 2970, -755)},
    {name = "🏁 Thế Giới 3 - CP 2", pos = Vector3.new(-2413, 2887, -1546)},
    {name = "🏁 Thế Giới 3 - CP 3", pos = Vector3.new(-2416, 2704, -2761)},
    {name = "🏁 Thế Giới 3 - CP 4", pos = Vector3.new(-2421, 2593, -4073)},
    {name = "🏁 Thế Giới 3 - CP 5", pos = Vector3.new(-2443, 2382, -4993)},
    {name = "🏁 Thế Giới 3 - CP 6", pos = Vector3.new(-2444, 2115, -6136)},
    {name = "🏁 Thế Giới 3 - CP 7", pos = Vector3.new(-2443, 1745, -6977)},
    {name = "🏁 Thế Giới 3 - CP 8", pos = Vector3.new(-2443, 973, -8439)},
    {name = "🏁 Thế Giới 3 - CP 9", pos = Vector3.new(-2444, 973, -9554)},
    {name = "🏁 Thế Giới 3 - CP 10", pos = Vector3.new(-2463, 906, -10560)},
    {name = "🏁 Thế Giới 3 - CP 11", pos = Vector3.new(-2456, 888, -11082)},
    {name = "🏁 Thế Giới 3 - CP 12", pos = Vector3.new(-2456, 863, -11717)},
    {name = "🏆 Thế Giới 3 - CP 13 (Win)", pos = Vector3.new(-2456, 293, -12340)},
}, Color3.fromRGB(241, 196, 15), Color3.fromRGB(39, 174, 96))

createTitle(ScrollingFrame, "--- Nhóm & Quà Nhóm ---", 2075)
local JoinGroupBtn = createBtn(ScrollingFrame, "👥 Tham Gia Nhóm", 2105)
local GroupRewardBtn = createBtn(ScrollingFrame, "🎁 Nhận Quà Nhóm Mỗi Ngày", 2150, Color3.fromRGB(241, 196, 15), Color3.fromRGB(50, 50, 50))

-- Xử lý sự kiện game
local Events = RS:WaitForChild("Events")
local LaunchEvent = Events:WaitForChild("Launch")
local BoostEvent = Events:WaitForChild("ApplyBoost")
local CashEvent = Events:WaitForChild("CashEvent")
local RocketEvent = Events:WaitForChild("AwardRocket")
local GroupEvent = Events:WaitForChild("Group")

SpawnBtn1.MouseButton1Click:Connect(function()
    LaunchEvent:FireServer({["53"] = "rail", ["43"] = "brake", ["51"] = "rail", ["41"] = "second", ["47"] = "rail", ["37"] = "seat", ["45"] = "nitro", ["35"] = "brake", ["59"] = "second", ["49"] = "second", ["39"] = "rail", ["29"] = "seat", ["10"] = "rail", ["63"] = "second", ["12"] = "rail", ["42"] = "rail", ["1"] = "second", ["40"] = "second", ["3"] = "second", ["2"] = "second", ["5"] = "second", ["4"] = "second", ["7"] = "second", ["6"] = "second", ["9"] = "second", ["8"] = "second", ["27"] = "brake", ["17"] = "second", ["31"] = "rail", ["21"] = "nitro", ["11"] = "rail", ["23"] = "rail", ["60"] = "second", ["52"] = "rail", ["62"] = "second", ["50"] = "rail", ["36"] = "seat", ["64"] = "second", ["34"] = "rail", ["44"] = "nitro", ["48"] = "second", ["58"] = "second", ["28"] = "seat", ["38"] = "brake", ["57"] = "second", ["56"] = "second", ["55"] = "rail", ["25"] = "second", ["19"] = "nitro", ["33"] = "second", ["15"] = "rail", ["61"] = "second", ["13"] = "rail", ["18"] = "rail", ["46"] = "brake", ["54"] = "rail", ["14"] = "rail", ["24"] = "second", ["16"] = "second", ["26"] = "rail", ["20"] = "nitro", ["30"] = "brake", ["22"] = "nitro", ["32"] = "second"}, Color3.new(0.545, 0.27, 0.07))
end)

SpawnBtn2.MouseButton1Click:Connect(function()
    LaunchEvent:FireServer({["53"] = "rail", ["43"] = "brake", ["51"] = "default", ["41"] = "second", ["47"] = "default", ["37"] = "seat", ["45"] = "nitro", ["35"] = "nitro", ["59"] = "second", ["49"] = "second", ["39"] = "rail", ["29"] = "seat", ["32"] = "rail", ["63"] = "second", ["30"] = "nitro", ["60"] = "rail", ["1"] = "rail", ["62"] = "second", ["3"] = "second", ["2"] = "second", ["5"] = "rail", ["4"] = "rail", ["7"] = "second", ["6"] = "second", ["9"] = "second", ["8"] = "rail", ["27"] = "nitro", ["17"] = "second", ["31"] = "rail", ["21"] = "nitro", ["11"] = "default", ["23"] = "default", ["42"] = "default", ["52"] = "rail", ["40"] = "rail", ["50"] = "rail", ["36"] = "seat", ["64"] = "rail", ["34"] = "rail", ["44"] = "nitro", ["48"] = "second", ["58"] = "second", ["28"] = "seat", ["38"] = "nitro", ["57"] = "rail", ["56"] = "second", ["55"] = "rail", ["54"] = "default", ["46"] = "brake", ["33"] = "rail", ["13"] = "rail", ["61"] = "rail", ["15"] = "rail", ["18"] = "default", ["19"] = "brake", ["25"] = "rail", ["14"] = "default", ["24"] = "second", ["16"] = "second", ["26"] = "rail", ["20"] = "nitro", ["12"] = "rail", ["22"] = "brake", ["10"] = "rail"}, Color3.new(0.545, 0.27, 0.07))
end)

SpawnBtn3.MouseButton1Click:Connect(function()
    LaunchEvent:FireServer({["53"] = "seat", ["43"] = "brake", ["51"] = "seat", ["41"] = "rail", ["47"] = "seat", ["37"] = "seat", ["45"] = "nitro", ["35"] = "nitro", ["59"] = "rail", ["49"] = "second", ["39"] = "seat", ["29"] = "seat", ["10"] = "seat", ["63"] = "second", ["12"] = "seat", ["42"] = "seat", ["1"] = "rail", ["40"] = "default", ["3"] = "rail", ["2"] = "second", ["5"] = "default", ["4"] = "default", ["7"] = "second", ["6"] = "rail", ["9"] = "second", ["8"] = "rail", ["27"] = "nitro", ["17"] = "rail", ["31"] = "seat", ["21"] = "nitro", ["11"] = "seat", ["23"] = "seat", ["60"] = "default", ["52"] = "seat", ["62"] = "rail", ["50"] = "seat", ["36"] = "seat", ["64"] = "rail", ["34"] = "seat", ["44"] = "nitro", ["48"] = "rail", ["58"] = "second", ["28"] = "seat", ["38"] = "nitro", ["57"] = "rail", ["56"] = "second", ["55"] = "seat", ["25"] = "default", ["19"] = "brake", ["33"] = "default", ["15"] = "seat", ["61"] = "default", ["13"] = "seat", ["18"] = "seat", ["46"] = "brake", ["54"] = "seat", ["14"] = "seat", ["24"] = "rail", ["16"] = "second", ["26"] = "seat", ["20"] = "nitro", ["30"] = "nitro", ["22"] = "brake", ["32"] = "default"}, Color3.new(0, 0.3, 1))
end)

SpawnBtn4.MouseButton1Click:Connect(function()
    LaunchEvent:FireServer({
        ["53"] = "nitro", ["43"] = "nitro", ["51"] = "nitro", ["41"] = "nitro", ["47"] = "nitro", ["37"] = "seat", ["45"] = "rail", ["35"] = "rail", ["59"] = "nitro", ["49"] = "nitro", ["39"] = "nitro", ["29"] = "seat", ["10"] = "nitro", ["63"] = "nitro", ["12"] = "nitro", ["42"] = "nitro", ["1"] = "nitro", ["40"] = "nitro", ["3"] = "nitro", ["2"] = "nitro", ["5"] = "nitro", ["4"] = "nitro", ["7"] = "rail", ["6"] = "nitro", ["9"] = "nitro", ["8"] = "nitro", ["27"] = "rail", ["17"] = "nitro", ["31"] = "nitro", ["21"] = "rail", ["11"] = "nitro", ["23"] = "nitro", ["60"] = "nitro", ["52"] = "nitro", ["62"] = "nitro", ["50"] = "nitro", ["36"] = "seat", ["64"] = "nitro", ["34"] = "nitro", ["44"] = "rail", ["48"] = "nitro", ["58"] = "nitro", ["28"] = "seat", ["38"] = "rail", ["57"] = "nitro", ["56"] = "nitro", ["55"] = "nitro", ["25"] = "nitro", ["19"] = "nitro", ["33"] = "nitro", ["15"] = "nitro", ["61"] = "nitro", ["13"] = "nitro", ["18"] = "nitro", ["46"] = "nitro", ["54"] = "nitro", ["14"] = "nitro", ["24"] = "rail", ["16"] = "rail", ["26"] = "nitro", ["20"] = "rail", ["30"] = "rail", ["22"] = "nitro", ["32"] = "nitro"
    }, Color3.new(0.545098, 0.270588, 0.0745098))
end)

local flying, flySpeed = false, 50
local bv, bg
FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if flying then
        FlyBtn.Text, FlyBtn.BackgroundColor3 = "✅ Đang Bay", Color3.fromRGB(46, 204, 113)
        if hrp and hum then
            hum.PlatformStand = true
            bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            RunService.RenderStepped:Connect(function()
                if not flying or not hrp.Parent then return end
                local cam = workspace.CurrentCamera
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                bv.Velocity = move * flySpeed
                bg.CFrame = cam.CFrame
            end)
        end
    else
        FlyBtn.Text, FlyBtn.BackgroundColor3 = "✈️ Bật Chức Năng Bay", Color3.fromRGB(52, 152, 219)
        if hum then hum.PlatformStand = false end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

BoostBtn.MouseButton1Click:Connect(function()
    local val = tonumber(BoostBox.Text)
    if val then BoostEvent:FireServer(math.max(1, val)) end
end)

local isLoopingBoost = false
LoopBoostBtn.MouseButton1Click:Connect(function()
    isLoopingBoost = not isLoopingBoost
    LoopBoostBtn.Text = isLoopingBoost and "🔄 Đang Lặp Lại Tăng Cường (Bật)" or "🔄 Lặp Lại Tăng Cường (Tắt)"
    LoopBoostBtn.BackgroundColor3 = isLoopingBoost and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(192, 57, 43)
    if isLoopingBoost then
        task.spawn(function()
            while isLoopingBoost do
                pcall(function() BoostEvent:FireServer(tonumber(BoostBox.Text) or 4) end)
                task.wait(0.2)
            end
        end)
    end
end)

TestBillionBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        for _, v in ipairs({1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000}) do
            BoostEvent:FireServer(v)
            task.wait(0.05)
        end
    end)
end)

CashBtn.MouseButton1Click:Connect(function()
    local val = tonumber(CashBox.Text)
    if val then CashEvent:FireServer(math.clamp(val, 1, 19999)) end
end)

local isLoopingCash = false
LoopCashBtn.MouseButton1Click:Connect(function()
    isLoopingCash = not isLoopingCash
    LoopCashBtn.Text = isLoopingCash and "🔄 Đang Lặp Lại Nhận Tiền (Bật)" or "🔄 Lặp Lại Nhận Tiền (Tắt)"
    LoopCashBtn.BackgroundColor3 = isLoopingCash and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(211, 84, 0)
    if isLoopingCash then
        task.spawn(function()
            while isLoopingCash do
                pcall(function() CashEvent:FireServer(tonumber(CashBox.Text) or 402) end)
                task.wait(0.2)
            end
        end)
    end
end)

RocketBtn.MouseButton1Click:Connect(function() RocketEvent:FireServer() end)
JoinGroupBtn.MouseButton1Click:Connect(function() pcall(function() firesignal(GroupEvent.OnClientEvent) end) end)
GroupRewardBtn.MouseButton1Click:Connect(function() GroupEvent:FireServer() end)
