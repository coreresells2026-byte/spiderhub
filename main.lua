-- Root Loader Engine for SpiderHub Framework
local success, moduleSource = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and moduleSource then
    -- Verify that the source contains actual data before running loadstring
    if string.find(moduleSource, "404: Not Found") or string.len(moduleSource) < 10 then
        warn("[SpiderHub Error]: GitHub file path is invalid or the repository is private.")
        return
    end

    local loader, compileError = loadstring(moduleSource)
    if loader then
        local AdminUI = loader()
        if AdminUI and typeof(AdminUI) == "table" and AdminUI.CreateMenu then
            AdminUI.CreateMenu()
            print("[SpiderHub]: Engine fully loaded. Press Left/Right Alt or tap 'Spider' to toggle.")
        else
            warn("[SpiderHub Verification Error]: Loaded module did not return a valid configuration table.")
        end
    else
        warn("[SpiderHub Compilation Error]: " .. tostring(compileError))
    end
else
    warn("[SpiderHub Network Error]: Failed to fetch module resources from GitHub infrastructure.")
end
