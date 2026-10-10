-- =================================================================
-- MODULE LƯU TRỮ VÀ XỬ LÝ (game_keyword.lua)
-- =================================================================
print("⏳ Đang tải module game_keyword.lua...")

local HttpService = game:GetService("HttpService")
local GameStore = {}

GameStore.Storage = {
    OriginalName = "Unknown Game",
    VietnameseInfo = "",
    PlaceId = 0
}

function GameStore.SaveData(originalName, vietnameseInfo, placeId)
    GameStore.Storage.OriginalName = originalName or "Unknown Game"
    GameStore.Storage.VietnameseInfo = vietnameseInfo or ""
    GameStore.Storage.PlaceId = placeId or game.PlaceId
    print("📦 [GameStore] Đã lưu dữ liệu game:", originalName)
end

function GameStore.SendWebhook(webhookUrl, actionName, details)
    task.spawn(function()
        pcall(function()
            local data = GameStore.Storage
            local payload = {
                ["content"] = string.format(
                    "[ScriptBlox Bot Trigger]\n🗺️ **Game Name:** `%s`\n🇻🇳 **Data/Từ khóa:** `%s`\n🆔 **PlaceId:** `%d`\n📌 **Hành động:** `%s`\n💬 **Chi tiết:** `%s`", 
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
                print("🚀 [GameStore] Đã gửi Webhook thành công!")
            end
        end)
    end)
end

print("✅ [GameStore] Đã sẵn sàng!")
return GameStore
