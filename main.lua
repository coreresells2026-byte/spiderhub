-- Master Loader Engine for SpiderHub Framework
local success, moduleSource = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and moduleSource then
    -- Check if GitHub returned a valid script or a 404 page error
    if string.find(moduleSource, "404: Not Found") or string.len(moduleSource) < 10 then
        warn("[SpiderHub Error]: GitHub file path is invalid. Ensure your 'modules' folder and 'AdminUI.lua' names match exactly.")
        return
    end

    -- Compile the raw text string into executable Luau bytecode
    local loader, compileError = loadstring(moduleSource)
    if loader then
        local AdminUI = loader()
        
        -- Validate that the module safely returned its framework setup table
        if AdminUI and typeof(AdminUI) == "table" and AdminUI.CreateMenu then
            AdminUI.CreateMenu()
            print("[SpiderHub]: Framework fully initialized! Press Left/Right Alt or tap the 'Spider' button to toggle.")
        else
            warn("[SpiderHub Verification Error]: AdminUI.lua loaded, but it did not return the menu configuration table.")
        end
    else
        warn("[SpiderHub Compilation Error]: " .. tostring(compileError))
    end
else
    warn("[SpiderHub Network Error]: Failed to fetch module resources from GitHub infrastructure. Check your internet connection.")
end
