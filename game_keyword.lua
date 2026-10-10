-- =================================================================
-- MODULE LƯU TRỮ VÀ XỬ LÝ (game_keyword.lua)
-- =================================================================
print("⏳ Đang tải module game_keyword.lua...")

local HttpService = game:GetService("HttpService")
local GameStore = {}

-- Bộ nhớ lưu trữ dữ liệu nhận từ tp.lua
GameStore.Storage = {
    OriginalName = "Unknown Game",
    SearchQuery = "Unknown Game",
    PlaceId = 0
}

-- Hàm nhận và lưu thông tin tên game trực tiếp từ script chính
function GameStore.SaveData(originalName, details, placeId)
    local rawName = (originalName and originalName ~= "") and originalName or "Unknown Game"
    
    GameStore.Storage.OriginalName = rawName
    GameStore.Storage.SearchQuery = rawName -- Dùng chính tên gốc để tìm kiếm trên ScriptBlox
    GameStore.Storage.PlaceId = placeId or game.PlaceId
    
    print("📦 [GameStore] Đã lưu tên game gốc:", rawName)
end

-- Hàm đóng gói payload và gửi lên Webhook Discord
function GameStore.SendWebhook(webhookUrl, actionName, details)
    task.spawn(function()
        pcall(function()
            local data = GameStore.Storage
            
            -- Payload định dạng chuẩn gửi Tên Game Gốc cho Bot quét
            local payload = {
                ["content"] = string.format(
                    "[ScriptBlox Bot Trigger]\n🗺️ **Game Name (Gốc):** `%s`\n🔍 **Search Query:** `%s`\n🆔 **PlaceId:** `%d`\n📌 **Hành động:** `%s`\n💬 **Chi tiết:** `%s`", 
                    data.OriginalName,
                    data.SearchQuery,
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
                print("🚀 [GameStore] Đã bắn Webhook với tên game gốc thành công!")
            end
        end)
    end)
end

print("✅ [GameStore] Đã sẵn sàng!")
return GameStore
