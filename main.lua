-- Pure Client-Side Loader for SpiderHub Architecture
local success, moduleSource = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and moduleSource then
    -- Safety Check: Ensure GitHub didn't return a 404 page
    if string.find(moduleSource, "404: Not Found") or string.len(moduleSource) < 10 then
        warn("[SpiderHub Error]: AdminUI.lua path is invalid or misspelled on GitHub.")
        return
    end

    -- Compile and invoke the user interface directly into client memory
    local loader, compileError = loadstring(moduleSource)
    if loader then
        local status, runtimeError = pcall(function()
            local AdminUI = loader()
            if AdminUI and typeof(AdminUI) == "table" and AdminUI.CreateMenu then
                AdminUI.CreateMenu()
                print("[SpiderHub]: UI successfully launched via main link execution.")
            else
                warn("[SpiderHub Error]: AdminUI did not return a valid layout table.")
            end
        end)
        if not status then
            warn("[SpiderHub Runtime Error]: " .. tostring(runtimeError))
        end
    else
        warn("[SpiderHub Compilation Error]: " .. tostring(compileError))
    end
else
    warn("[SpiderHub Network Error]: Failed to reach GitHub module directory.")
end
