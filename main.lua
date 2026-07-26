-- Root initialization script for SpiderHub environment hierarchy
local success, moduleSource = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and moduleSource then
    local loader, compileError = loadstring(moduleSource)
    if loader then
        local AdminUI = loader()
        if AdminUI and typeof(AdminUI) == "table" and AdminUI.CreateMenu then
            AdminUI.CreateMenu()
            print("[SpiderHub]: Engine fully loaded. Press Left/Right Alt to toggle display interface.")
        else
            warn("[SpiderHub Verification Error]: Loaded module did not return a valid interface builder.")
        end
    else
        warn("[SpiderHub Compilation Error]: " .. tostring(compileError))
    end
else
    warn("[SpiderHub Network Error]: Failed to fetch module resources from GitHub infrastructure.")
end
