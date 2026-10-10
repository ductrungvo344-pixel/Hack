-- =================================================================
-- MODULE TRUNG GIAN: LƯU TRỮ VÀ XỬ LÝ GỬI WEBHOOK (game_keyword.lua)
-- =================================================================
local HttpService = game:GetService("HttpService")

local GameStore = {}

-- Bộ nhớ tạm lưu trữ dữ liệu nhận được từ tp.lua
GameStore.Storage = {
    OriginalName = "Unknown Game",
    VietnameseInfo = "",
    PlaceId = 0
}

-- Hàm nhận và lưu thông tin trực tiếp do Script CHÍNH truyền sang
function GameStore.SaveData(originalName, vietnameseInfo, placeId)
    GameStore.Storage.OriginalName = originalName or "Unknown Game"
    GameStore.Storage.VietnameseInfo = vietnameseInfo or ""
    GameStore.Storage.PlaceId = placeId or game.PlaceId
end

-- Hàm thực thi gửi Webhook Discord dựa trên dữ liệu đang lưu trong bộ nhớ
function GameStore.SendWebhook(webhookUrl, actionName, details)
    task.spawn(function()
        pcall(function()
            local data = GameStore.Storage
            local payload = {
                ["content"] = string.format(
                    "[ScriptBlox Bot Trigger]\n🗺️ **Game Name:** `%s`\n🇻🇳 **Thông tin Việt:** `%s`\n🆔 **PlaceId:** `%d`\n📌 **Hành động:** `%s`\n💬 **Data:** `%s`", 
                    data.OriginalName, 
                    (data.VietnameseInfo ~= "" and data.VietnameseInfo or "N/A"), 
                    data.PlaceId, 
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

return GameStore
