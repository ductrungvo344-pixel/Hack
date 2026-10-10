-- =================================================================
-- MODULE TRUNG GIAN: LƯU TRỮ VÀ XỬ LÝ GỬI WEBHOOK (game_keyword.lua)
-- =================================================================
local HttpService = game:GetService("HttpService")

local GameStorage = {}

-- Bảng lưu trữ thông tin nhận được từ script chính
GameStorage.Data = {
    OriginalName = "Unknown Game",
    VietnameseName = "",
    EnglishQuery = "",
    PlaceId = 0,
    LastUpdated = 0
}

-- Hàm nhận thông tin từ script chính và lưu vào bộ nhớ
function GameStorage.SaveInfo(originalName, vietnameseName, placeId)
    GameStorage.Data.OriginalName = originalName or "Unknown Game"
    GameStorage.Data.VietnameseName = vietnameseName or ""
    GameStorage.Data.PlaceId = placeId or game.PlaceId
    GameStorage.Data.LastUpdated = os.time()
    
    -- Xử lý ghép hoặc dịch từ khóa lưu trữ
    if vietnameseName ~= "" then
        GameStorage.Data.EnglishQuery = originalName .. " (" .. vietnameseName .. ")"
    else
        GameStorage.Data.EnglishQuery = originalName
    end
end

-- Hàm lấy thông tin đã lưu trữ
function GameStorage.GetStoredInfo()
    return GameStorage.Data
end

-- Hàm xử lý đóng gói và gửi lên Webhook Discord
function GameStorage.SendToWebhook(webhookUrl, actionName, details)
    task.spawn(function()
        pcall(function()
            local stored = GameStorage.Data
            local payload = {
                ["content"] = string.format(
                    "[ScriptBlox Bot Trigger]\n🗺️ **Game Name:** `%s`\n🇻🇳 **Tên Tiếng Việt:** `%s`\n🇬🇧 **English Query:** `%s`\n🆔 **PlaceId:** `%d`\n📌 **Hành động:** `%s`\n💬 **Data:** `%s`", 
                    stored.OriginalName, 
                    stored.VietnameseName ~= "" and stored.VietnameseName or "N/A", 
                    stored.EnglishQuery, 
                    stored.PlaceId, 
                    actionName, 
                    details
                )
            }
            
            local reqFunc = request or http_request or (syn and syn.request)
            if reqFunc then
                reqFunc({
                    Url = webhookUrl,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(payload)
                })
            end
        end)
    end)
end

return GameStorage
