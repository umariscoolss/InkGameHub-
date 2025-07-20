local baseURL = "https://raw.githubusercontent.com/umariscoolss/InkGameHub/main/features/"

local featureFiles = {
    "utility.lua",
    "combat.lua",
    "movement.lua",
    "esp.lua",
    "survival.lua",
    "advanced.lua"
}

for _, file in pairs(featureFiles) do
    local success, err = pcall(function()
        loadstring(game:HttpGet(baseURL .. file))()
    end)
    if not success then
        warn("[InkHub] Failed to load " .. file .. ": " .. tostring(err))
    end
end
