-- ===============================================
-- ROBLOX ONLINE DICTIONARY GUI (FREE API)
-- ===============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- 1. TẠO GIAO DIỆN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OnlineDictionaryGui"
ScreenGui.ResetOnSpawn = false

if syn or setclipboard or Identifyexecutor then
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể kéo bảng đi khắp màn hình
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
Title.Text = "🌐 TỪ ĐIỂN ONLINE (FREE API)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Ô Nhập Từ Cần Tra
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.7, 0, 0, 38)
SearchBox.Position = UDim2.new(0.05, 0, 0, 55)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
SearchBox.PlaceholderText = "Nhập từ tiếng Anh (VD: hello, cat)..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.SourceSans
SearchBox.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBox

-- Nút Tìm Kiếm (Search Button)
local SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0.2, 0, 0, 38)
SearchBtn.Position = UDim2.new(0.77, 0, 0, 55)
SearchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SearchBtn.Text = "Tra Cứu"
SearchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBtn.TextSize = 14
SearchBtn.Font = Enum.Font.SourceSansBold
SearchBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = SearchBtn

-- Khung Hiển Thị Kết Quả (Scrolling Frame)
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(0.9, 0, 0, 320)
ScrollList.Position = UDim2.new(0.05, 0, 0, 105)
ScrollList.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ScrollList.ScrollBarThickness = 6
ScrollList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollList

-- Hàm Copy vào Clipboard
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif syn and syn.write_clipboard then
        syn.write_clipboard(text)
    end
end

-- Hàm Thêm Kết Quả Lên UI
local function addResultCard(word, partOfSpeech, definition)
    -- Xóa các kết quả cũ trước đó
    for _, child in pairs(ScrollList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -10, 0, 120)
    Card.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Card.Parent = ScrollList

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 6)
    CardCorner.Parent = Card

    -- Từ và Loại từ
    local WordTitle = Instance.new("TextLabel")
    WordTitle.Size = UDim2.new(0.9, 0, 0, 30)
    WordTitle.Position = UDim2.new(0.05, 0, 0, 10)
    WordTitle.BackgroundTransparency = 1
    WordTitle.Text = string.format("🔤 %s (%s)", word, partOfSpeech)
    WordTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
    WordTitle.TextSize = 16
    WordTitle.Font = Enum.Font.SourceSansBold
    WordTitle.TextXAlignment = Enum.TextXAlignment.Left
    WordTitle.Parent = Card

    -- Định nghĩa nghĩa của từ
    local DefLabel = Instance.new("TextLabel")
    DefLabel.Size = UDim2.new(0.9, 0, 0, 45)
    DefLabel.Position = UDim2.new(0.05, 0, 0, 40)
    DefLabel.BackgroundTransparency = 1
    DefLabel.Text = "📖 " .. definition
    DefLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    DefLabel.TextSize = 14
    DefLabel.Font = Enum.Font.SourceSans
    DefLabel.TextXAlignment = Enum.TextXAlignment.Left
    DefLabel.TextWrapped = true
    DefLabel.Parent = Card

    -- Nút Copy kết quả
    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0.4, 0, 0, 25)
    CopyBtn.Position = UDim2.new(0.05, 0, 0, 85)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    CopyBtn.Text = "📋 Copy Nghĩa"
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.TextSize = 12
    CopyBtn.Font = Enum.Font.SourceSansBold
    CopyBtn.Parent = Card

    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 4)
    CopyCorner.Parent = CopyBtn

    CopyBtn.MouseButton1Click:Connect(function()
        copyToClipboard(word .. ": " .. definition)
        CopyBtn.Text = "✅ Đã Copy!"
        task.wait(1)
        CopyBtn.Text = "📋 Copy Nghĩa"
    end)

    ScrollList.CanvasSize = UDim2.new(0, 0, 0, 130)
end

-- Hàm Gọi Free API Tra Từ
local function searchWord()
    local keyword = SearchBox.Text:lower():gsub("%s+", "")
    if keyword == "" then return end

    SearchBtn.Text = "⏳..."
    local url = "https://api.dictionaryapi.dev/api/v2/entries/en/" .. keyword

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    SearchBtn.Text = "Tra Cứu"

    if success then
        local data = HttpService:JSONDecode(response)
        if data and data[1] then
            local word = data[1].word or keyword
            local meaning = data[1].meanings[1]
            local partOfSpeech = meaning.partOfSpeech or "noun"
            local definition = meaning.definitions[1].definition or "Không có định nghĩa."
            
            addResultCard(word, partOfSpeech, definition)
        else
            addResultCard(keyword, "error", "Không tìm thấy từ này trên hệ thống!")
        end
    else
        addResultCard(keyword, "error", "Lỗi kết nối mạng hoặc không tìm thấy từ!")
    end
end

-- Gắn sự kiện khi bấm nút hoặc nhấn Enter
SearchBtn.MouseButton1Click:Connect(searchWord)
SearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        searchWord()
    end
end)
