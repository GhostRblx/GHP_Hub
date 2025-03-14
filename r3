local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:Notify({
   Title = "Executoed",
   Content = "Loading GHP Hub",
   Duration = 6.5,
   Image = 4483362458,
})

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

---------------------------------------------------------------------------------------------------------------------------------------


Rayfield:Notify({
   Title = "Loaded",
   Content = "Loaded with no issues (Hopefully xD)",
   Duration = 6.5,
   Image = nil,
})

---------------------------------------------------------------------------------------------------------------------------------------

local WelcomeT = Window:CreateTab("Welcome", nil) -- Title, Image
local AimbotT = Window:CreateTab("Aimbot", nil) -- Title, Image
local ESPT = Window:CreateTab("ESPs", nil) -- Title, Image

---------------------------------------------------------------------------------------------------------------------------------------

local GreetingS = WelcomeT:CreateSection("Greetings")
local AimbotS = AimbotT:CreateSection("Aimbot")
local SilentAimS = AimbotT:CreateSection("Silent Aim")
local NESPS = ESPT:CreateSection("Normal")


---------------------------------------------------------------------------------------------------------------------------------------

local Welcome1L = WelcomeT:CreateLabel("--Thank you for choosing This exploiting UI-- ", nil, Color3.fromRGB(55, 55, 55), true)
local Welcome2L = WelcomeT:CreateLabel("-if there are any issues/wishes DM: ghstgmr ", nil, Color3.fromRGB(55, 55, 55), true)

---------------------------------------------------------------------------------------------------------------------------------------

local Paragraph1 = WelcomeT:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph Example"})

---------------------------------------------------------------------------------------------------------------------------------------
--Tracer--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local TracerEnabled = false -- Standardmäßig aus
local TracerLines = {} -- Speichert die Linien für spätere Löschung

function DrawTracer(player)
    if not player.Character then return end
    local RootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    local Line = Drawing.new("Line")
    Line.Thickness = 2
    Line.Color = Color3.fromRGB(255, 0, 0)
    Line.Transparency = 1
    TracerLines[player] = Line -- Speichert die Linie für den Spieler

    RunService.RenderStepped:Connect(function()
        if not TracerEnabled then
            Line.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(RootPart.Position)
            if onScreen then
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- Startpunkt unten Mitte
                Line.To = Vector2.new(screenPos.X, screenPos.Y) -- Endpunkt bei Gegner
                Line.Visible = true
            else
                Line.Visible = false
            end
        else
            Line.Visible = false
        end
    end)
end

function ToggleTracer(state)
    TracerEnabled = state
    if not state then
        for _, line in pairs(TracerLines) do
            line.Visible = false
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                DrawTracer(player)
            end
        end
    end
end

-- UI Toggle für Tracer ESP
local TracerTog = ESPT:CreateToggle({
    Name = "Tracer ESP",
    CurrentValue = false,
    Flag = "Tracer",
    Callback = function(Value)
        ToggleTracer(Value)
    end,
})

-- Fügt Tracer zu existierenden Spielern hinzu
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        DrawTracer(v)
    end
end

-- Fügt Tracer für neue Spieler hinzu
Players.PlayerAdded:Connect(function(player)
    DrawTracer(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------

--health--
-- Health ESP --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local HealthESPEnabled = false -- Standardmäßig deaktiviert
local HealthBars = {} -- Speichert die Health-Bars für spätere Löschung

function DrawHealthBar(player)
    if not player.Character then return end
    local Head = player.Character:FindFirstChild("Head")
    local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not Head or not Humanoid then return end

    local Bar = Drawing.new("Square")
    Bar.Size = Vector2.new(40, 5) -- Breite & Höhe der Leiste
    Bar.Filled = true
    Bar.Thickness = 1
    Bar.Color = Color3.fromRGB(0, 255, 0) -- Standardmäßig grün
    Bar.Transparency = 1
    HealthBars[player] = Bar -- Speichert die Leiste für den Spieler

    RunService.RenderStepped:Connect(function()
        if not HealthESPEnabled then
            Bar.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("Head") and Humanoid then
            local screenPos, onScreen = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 1, 0)) -- Über dem Kopf
            if onScreen then
                local healthPercent = Humanoid.Health / Humanoid.MaxHealth
                Bar.Size = Vector2.new(40 * healthPercent, 5) -- Skaliert mit der Health
                Bar.Position = Vector2.new(screenPos.X - 20, screenPos.Y - 20) -- Zentriert über dem Kopf
                Bar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0) -- Von Grün zu Rot
                Bar.Visible = true
            else
                Bar.Visible = false
            end
        else
            Bar.Visible = false
        end
    end)
end

function ToggleHealthESP(state)
    HealthESPEnabled = state
    if not state then
        for _, bar in pairs(HealthBars) do
            bar.Visible = false
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                DrawHealthBar(player)
            end
        end
    end
end

-- UI Toggle für Health ESP
local HealthTog = ESPT:CreateToggle({
    Name = "Health ESP",
    CurrentValue = false,
    Flag = "Health",
    Callback = function(Value)
        ToggleHealthESP(Value)
    end,
})

-- Fügt Health ESP zu existierenden Spielern hinzu
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        DrawHealthBar(v)
    end
end

-- Fügt Health ESP für neue Spieler hinzu
Players.PlayerAdded:Connect(function(player)
    DrawHealthBar(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------

-- Name ESP --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local NameESPEnabled = false -- Standardmäßig deaktiviert
local NameLabels = {} -- Speichert die Namenstexte für spätere Löschung

function DrawNameESP(player)
    if not player.Character then return end
    local Head = player.Character:FindFirstChild("Head")
    if not Head then return end

    local NameTag = Drawing.new("Text")
    NameTag.Text = player.Name
    NameTag.Size = 18
    NameTag.Color = Color3.fromRGB(255, 255, 255) -- Weißer Text
    NameTag.Center = true
    NameTag.Outline = true
    NameTag.OutlineColor = Color3.fromRGB(0, 0, 0) -- Schwarze Umrandung für bessere Sichtbarkeit
    NameTag.Visible = false
    NameLabels[player] = NameTag -- Speichert den Namenstext für den Spieler

    RunService.RenderStepped:Connect(function()
        if not NameESPEnabled then
            NameTag.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("Head") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 1.5, 0)) -- Über dem Kopf
            if onScreen then
                NameTag.Position = Vector2.new(screenPos.X, screenPos.Y)
                NameTag.Visible = true
            else
                NameTag.Visible = false
            end
        else
            NameTag.Visible = false
        end
    end)
end

function ToggleNameESP(state)
    NameESPEnabled = state
    if not state then
        for _, label in pairs(NameLabels) do
            label.Visible = false
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                DrawNameESP(player)
            end
        end
    end
end

-- UI Toggle für Name ESP
local NameTog = ESPT:CreateToggle({
    Name = "Name ESP",
    CurrentValue = false,
    Flag = "Name",
    Callback = function(Value)
        ToggleNameESP(Value)
    end,
})

-- Fügt Name ESP zu existierenden Spielern hinzu
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        DrawNameESP(v)
    end
end

-- Fügt Name ESP für neue Spieler hinzu
Players.PlayerAdded:Connect(function(player)
    DrawNameESP(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------
-- Distance ESP --
---------------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local DistanceESPEnabled = false -- Standardmäßig deaktiviert
local DistanceLabels = {} -- Speichert die Distanztexte für spätere Löschung

function DrawDistanceESP(player)
    if not player.Character then return end
    local Head = player.Character:FindFirstChild("Head")
    if not Head then return end

    local DistanceTag = Drawing.new("Text")
    DistanceTag.Size = 18
    DistanceTag.Color = Color3.fromRGB(0, 255, 255) -- Cyanfarbener Text
    DistanceTag.Center = true
    DistanceTag.Outline = true
    DistanceTag.OutlineColor = Color3.fromRGB(0, 0, 0) -- Schwarze Umrandung
    DistanceTag.Visible = false
    DistanceLabels[player] = DistanceTag -- Speichert den Distanztext für den Spieler

    RunService.RenderStepped:Connect(function()
        if not DistanceESPEnabled then
            DistanceTag.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("Head") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 2, 0)) -- Unter dem Namen ESP
            if onScreen then
                local distance = (LocalPlayer.Character.Head.Position - Head.Position).Magnitude
                DistanceTag.Text = string.format("%.1f Studs", distance) -- Zeigt Distanz mit einer Nachkommastelle
                DistanceTag.Position = Vector2.new(screenPos.X, screenPos.Y + 15) -- Direkt unter dem Namen
                DistanceTag.Visible = true
            else
                DistanceTag.Visible = false
            end
        else
            DistanceTag.Visible = false
        end
    end)
end

function ToggleDistanceESP(state)
    DistanceESPEnabled = state
    if not state then
        for _, label in pairs(DistanceLabels) do
            label.Visible = false
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                DrawDistanceESP(player)
            end
        end
    end
end

-- UI Toggle für Distance ESP
local DistanceTog = ESPT:CreateToggle({
    Name = "Distance ESP",
    CurrentValue = false,
    Flag = "Distance",
    Callback = function(Value)
        ToggleDistanceESP(Value)
    end,
})

-- Fügt Distance ESP zu existierenden Spielern hinzu
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        DrawDistanceESP(v)
    end
end

-- Fügt Distance ESP für neue Spieler hinzu
Players.PlayerAdded:Connect(function(player)
    DrawDistanceESP(player)
end)

---------------------------------------------------------------------------------------
local AESPS = ESPT:CreateSection("Advanced")
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------
-- Glow ESP (Durch Wände Sichtbar) --
---------------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local GlowESPEnabled = false
local GlowColor = Color3.fromRGB(255, 0, 0) -- Standard: Rot
local RainbowMode = false
local Highlights = {}

local function GetRainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

local function ApplyGlow(player)
    if not player.Character then return end

    -- Entfernt vorherige Highlights, falls vorhanden
    if Highlights[player] then
        Highlights[player]:Destroy()
    end

    -- Neues Highlight erstellen
    local highlight = Instance.new("Highlight")
    highlight.Parent = game:GetService("CoreGui")
    highlight.FillColor = GlowColor
    highlight.OutlineColor = Color3.new(1, 1, 1) -- Weiße Umrandung für besseren Effekt
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character

    Highlights[player] = highlight
end

local function ToggleGlowESP(state)
    GlowESPEnabled = state

    if not state then
        -- Löscht alle Highlights, wenn der ESP ausgeschaltet wird
        for _, highlight in pairs(Highlights) do
            highlight:Destroy()
        end
        Highlights = {}
    else
        -- Füge Highlights für alle Spieler hinzu
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                ApplyGlow(player)
            end
        end
    end
end

local function UpdateGlowColor(color)
    GlowColor = color
    for _, highlight in pairs(Highlights) do
        highlight.FillColor = color
    end
end

-- UI Toggle für Glow ESP
local GlowTog = ESPT:CreateToggle({
    Name = "Glow ESP",
    CurrentValue = false,
    Flag = "GlowESP",
    Callback = function(Value)
        ToggleGlowESP(Value)
    end,
})

-- Dropdown für Farbeinstellung
local GlowDropdown = ESPT:CreateDropdown({
    Name = "Glow Color",
    Options = {"Red", "Green", "Blue", "Yellow", "Purple", "Cyan", "Rainbow"},
    CurrentOption = {"Red"},
    MultipleOptions = false,
    Flag = "GlowColor",
    Callback = function(Option)
        if Option[1] == "Red" then
            UpdateGlowColor(Color3.fromRGB(255, 0, 0))
            RainbowMode = false
        elseif Option[1] == "Green" then
            UpdateGlowColor(Color3.fromRGB(0, 255, 0))
            RainbowMode = false
        elseif Option[1] == "Blue" then
            UpdateGlowColor(Color3.fromRGB(0, 0, 255))
            RainbowMode = false
        elseif Option[1] == "Yellow" then
            UpdateGlowColor(Color3.fromRGB(255, 255, 0))
            RainbowMode = false
        elseif Option[1] == "Purple" then
            UpdateGlowColor(Color3.fromRGB(128, 0, 128))
            RainbowMode = false
        elseif Option[1] == "Cyan" then
            UpdateGlowColor(Color3.fromRGB(0, 255, 255))
            RainbowMode = false
        elseif Option[1] == "Rainbow" then
            RainbowMode = true
        end
    end,
})

-- Rainbow Mode Update Loop
RunService.RenderStepped:Connect(function()
    if GlowESPEnabled and RainbowMode then
        UpdateGlowColor(GetRainbowColor())
    end
end)

-- Fügt Glow ESP zu existierenden Spielern hinzu
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        ApplyGlow(v)
    end
end

-- Fügt Glow ESP für neue Spieler hinzu
Players.PlayerAdded:Connect(function(player)
    ApplyGlow(player)
end)
---------------------------------------------------------------------------------------------------------------------------------------
-- Box ESP mit Farbauswahl & Rainbow-Modus (Feste Größe) --
---------------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local BoxESPEnabled = false
local Boxes = {}
local BoxColor = Color3.fromRGB(0, 255, 0) -- Standardfarbe: Grün
local RainbowMode = false
local BoxWidth = 50
local BoxHeight = 100

local function GetRainbowColor()
    local hue = tick() % 5 / 5 -- Farbe rotiert alle 5 Sekunden
    return Color3.fromHSV(hue, 1, 1)
end

local function CreateBox(player)
    if not player.Character then return end
    local RootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Color = BoxColor
    Box.Transparency = 1
    Box.Filled = false
    Boxes[player] = Box

    RunService.RenderStepped:Connect(function()
        if not BoxESPEnabled then
            Box.Visible = false
            return
        end

        if RainbowMode then
            Box.Color = GetRainbowColor()
        end

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(RootPart.Position)
            if onScreen then
                -- Die Box behält immer die gleiche Größe bei
                Box.Size = Vector2.new(BoxWidth, BoxHeight)
                Box.Position = Vector2.new(screenPos.X - BoxWidth / 2, screenPos.Y - BoxHeight / 2)
                Box.Visible = true
            else
                Box.Visible = false
            end
        else
            Box.Visible = false
        end
    end)
end

local function ToggleBoxESP(state)
    BoxESPEnabled = state
    if not state then
        for _, box in pairs(Boxes) do
            box.Visible = false
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateBox(player)
            end
        end
    end
end

-- UI Toggle für Box ESP
local BoxTog = ESPT:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(Value)
        ToggleBoxESP(Value)
    end,
})

-- Dropdown für Farbwahl
local BoxColorDropdown = ESPT:CreateDropdown({
    Name = "Box ESP Color",
    Options = {"Rot", "Grün", "Blau", "Gelb", "Rainbow"},
    CurrentOption = {"Grün"},
    MultipleOptions = false,
    Flag = "BoxColor",
    Callback = function(Option)
        if Option[1] == "Red" then
            BoxColor = Color3.fromRGB(255, 0, 0)
            RainbowMode = false
        elseif Option[1] == "Green" then
            BoxColor = Color3.fromRGB(0, 255, 0)
            RainbowMode = false
        elseif Option[1] == "Blue" then
            BoxColor = Color3.fromRGB(0, 0, 255)
            RainbowMode = false
        elseif Option[1] == "Yellow" then
            BoxColor = Color3.fromRGB(255, 255, 0)
            RainbowMode = false
        elseif Option[1] == "Rainbow" then
            RainbowMode = true
        end
    end,
})

-- Fügt Box ESP zu existierenden Spielern hinzu
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        CreateBox(v)
    end
end

-- Fügt Box ESP für neue Spieler hinzu
Players.PlayerAdded:Connect(function(player)
    CreateBox(player)
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Einstellungen
local AimbotEnabled = false  -- Aimbot Toggle
local FOVRadius = 100  -- Standardgröße des FOV-Kreises
local LockOnEnabled = false  -- Wird aktiviert, wenn MouseButton2 gedrückt wird
local FOVColor = Color3.fromRGB(255, 255, 255) -- Standardfarbe: Weiß

-- Zeichne den FOV-Kreis
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = FOVColor
FOVCircle.Filled = false
FOVCircle.Visible = false

-- UI Elemente (Falls du ein UI-Framework hast, kannst du das hier einfügen)
local AimbotToggle = AimbotT:CreateToggle({
    Name = "Fov Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
        FOVCircle.Visible = Value -- Zeigt/versteckt den Kreis
    end,
})

local FOVSlider = AimbotT:CreateSlider({
    Name = "FOV Größe",
    Range = {50, 300},  -- Min/Max Größe des Kreises
    Increment = 10,
    Suffix = " px",
    CurrentValue = FOVRadius,
    Flag = "FOVSize",
    Callback = function(Value)
        FOVRadius = Value
    end,
})

local FOVColorDropdown = AimbotT:CreateDropdown({
    Name = "FOV Farbe",
    Options = {"Weiß", "Rot", "Grün", "Blau", "Gelb", "Cyan", "Magenta"},
    CurrentOption = {"Weiß"},
    MultipleOptions = false,
    Flag = "FOVColor",
    Callback = function(Option)
        if Option[1] == "White" then
            FOVColor = Color3.fromRGB(255, 255, 255)
        elseif Option[1] == "Red" then
            FOVColor = Color3.fromRGB(255, 0, 0)
        elseif Option[1] == "Green" then
            FOVColor = Color3.fromRGB(0, 255, 0)
        elseif Option[1] == "Blue" then
            FOVColor = Color3.fromRGB(0, 0, 255)
        elseif Option[1] == "Yellow" then
            FOVColor = Color3.fromRGB(255, 255, 0)
        elseif Option[1] == "Cyan" then
            FOVColor = Color3.fromRGB(0, 255, 255)
        elseif Option[1] == "Magenta" then
            FOVColor = Color3.fromRGB(255, 0, 255)
        end
    end,
})

-- Funktion, um den nächstgelegenen Gegner zu finden
local function GetClosestTarget()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < FOVRadius and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

-- Lock-On Funktion
local function LockOnToTarget()
    local target = GetClosestTarget()

    if target and target.Character and target.Character:FindFirstChild("Head") then
        local targetHead = target.Character.Head
        local headPosition = Camera:WorldToScreenPoint(targetHead.Position)

        mousemoverel((headPosition.X - Mouse.X) / 3, (headPosition.Y - Mouse.Y) / 3)
    end
end

-- Steuerung mit MouseButton2
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        LockOnEnabled = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        LockOnEnabled = false
    end
end)

-- Render-Loop
RunService.RenderStepped:Connect(function()
    -- FOV-Kreisanzeige aktualisieren
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Radius = FOVRadius
    FOVCircle.Color = FOVColor
    FOVCircle.Visible = AimbotEnabled

    -- Aimbot aktivieren, wenn der Toggle an ist und MouseButton2 gedrückt wird
    if AimbotEnabled and LockOnEnabled then
        LockOnToTarget()
    end
end)
--------------------------------------------------------------------------------------------------------------
--Aimbot Tab--
--------------------------------------------------------------------------------------------------------------
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Einstellungen
local AimbotEnabled = false  -- Aimbot Toggle
local LockOnEnabled = false  -- Wird aktiviert, wenn MouseButton2 gedrückt wird

-- UI Toggle für Aimbot
local AimbotToggle = AimbotT:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

-- Funktion, um den nächsten Gegner zu finden (NICHT IM EIGENEN TEAM)
local function GetClosestEnemy()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

-- Lock-On Funktion
local function LockOnToTarget()
    local target = GetClosestEnemy()

    if target and target.Character and target.Character:FindFirstChild("Head") then
        local targetHead = target.Character.Head
        local headPosition = Camera:WorldToScreenPoint(targetHead.Position)

        mousemoverel((headPosition.X - Mouse.X) / 3, (headPosition.Y - Mouse.Y) / 3)
    end
end

-- Steuerung mit MouseButton2
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        LockOnEnabled = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        LockOnEnabled = false
    end
end)

-- Render-Loop
RunService.RenderStepped:Connect(function()
    if AimbotEnabled and LockOnEnabled then
        LockOnToTarget()
    end
end)
