-- Cross-platform applications
PCMOD_APPS = {}

-- OS-specific applications
PCMOD_APPS_LINUX = {}
PCMOD_APPS_WINDOWS = {}

-- Terminal commands
PCMOD_COMMANDS_LINUX = {}
PCMOD_COMMANDS_WINDOWS = {}

local function IncludeCS(dir)
    if SERVER then
        AddCSLuaFile(dir)
    end
    include(dir)
    print("[Lambda's PCMod] Module loaded! " .. dir)
end
   
local files, _ = file.Find("lbpc/apps/*.lua", "LUA")
for k, shitFile in ipairs(files) do
    IncludeCS("lbpc/apps/" .. shitFile)
end
