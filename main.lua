-- Master Loader Engine for SpiderHub Framework
local success, moduleSource = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and moduleSource then
    -- Check if GitHub returned an invalid raw path or a 404 error page
    if string.find(moduleSource, "404: Not Found") or string.len(moduleSource) < 10 then
        warn("[SpiderHub Error]: GitHub file path is invalid or folder capitalization is wrong.")
        return
    end

    -- Compile the raw text string into executable bytecode
    local loader, compileError = loadstring(moduleSource)
    if loader then
        local status, runtimeError = pcall(function()
            local AdminUI = loader()
            -- Confirm the module returned the operational framework setup table
            if AdminUI and typeof(AdminUI) == "table" and AdminUI.CreateMenu then
                AdminUI.CreateMenu()
                print("[SpiderHub]: System successfully initialized!")
            else
                warn("[SpiderHub Error]: Loaded module did not return a valid layout table.")
            end
        end)
        if not status then
            warn("[SpiderHub Runtime Failure]: " .. tostring(runtimeError))
        end
    else
        warn("[SpiderHub Compilation Failure]: " .. tostring(compileError))
    end
else
    warn("[SpiderHub Network Error]: Target assets could not be resolved from external GitHub links.")
end
