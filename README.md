# GHP Hub - Script Loader

This repository contains the script loader for the GHP Hub, which allows you to load various scripts for games like **Rivals**, **Arsenal**, and more.

**List of all current supported games:**

-Arsenal

-A literal Baseplate

-RIVALS

## Loadstring

The following code loads the Hub:

```lua
local scriptURL = "https://raw.githubusercontent.com/GhostRblx/Rivals1/refs/heads/main/main"
local success, response = pcall(function()
    return game:HttpGet(scriptURL)
end)

if success then
    loadstring(response)()
else
    print("Error loading the script from URL: " .. scriptURL)
end
