-- =================================================================
-- LOADER CHÍNH (loader.lua) - TẢI VÀ KẾT NỐI 3 FILE
-- =================================================================
local success, errorMessage = pcall(function()
    -- 1. Tải và khởi tạo Module lưu trữ trung gian (game_keyword.lua)
    local keywordUrl = "https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/game_keyword.lua"
    local keywordScript = game:HttpGet(keywordUrl)
    
    if keywordScript and keywordScript ~= "" then
        _G.GameStore = loadstring(keywordScript)()
    else
        warn("⚠️ Không thể tải game_keyword.lua, dùng bộ lưu trữ tạm!")
    end

    -- 2. Tải và chạy Script Giao diện chính (tp.lua)
    local tpUrl = "https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/tp.lua"
    local tpScript = game:HttpGet(tpUrl)
    
    if tpScript and tpScript ~= "" then
        loadstring(tpScript)()
    else
        warn("❌ Không thể tải tp.lua!")
    end
end)

if not success then
    warn("❌ Lỗi Loader: " .. tostring(errorMessage))
end
