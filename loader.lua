-- =================================================================
-- LOADER CHÍNH (loader.lua)
-- =================================================================
print("🚀 Bắt đầu Loader...")

-- 1. Chạy file game_keyword.lua để lưu sẵn module vào _G.GameStore
task.spawn(function()
    pcall(function()
        _G.GameStore = loadstring(game:HttpGet("https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/game_keyword.lua"))()
    end)
end)

task.wait(0.5)

-- 2. Chạy file chính tp.lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ductrungvo344-pixel/Hack/refs/heads/main/tp.lua"))()
