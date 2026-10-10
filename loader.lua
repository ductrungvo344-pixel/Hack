-- =================================================================
-- LOADER CHÍNH (DÁN VÀO DELTA EXECUTOR)
-- =================================================================
local success, errorMessage = pcall(function()
    local scriptUrl = "https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/tp.lua"
    
    local scriptContent = game:HttpGet(scriptUrl)
    if scriptContent and scriptContent ~= "" then
        loadstring(scriptContent)()
    else
        warn("❌ Không thể tải được nội dung script từ GitHub!")
    end
end)

if not success then
    warn("❌ Lỗi Loader: " .. tostring(errorMessage))
end
