local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GHP Hub",
   LoadingTitle = "GHP V1",
   LoadingSubtitle = "by GhostGamer",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, 
      FileName = "GHP_Boot"
	     },
   Discord = {
      Enabled = false,
      Invite = "GHP Hub Discord", 
      RememberJoins = true ,
   },
   KeySystem = false, 
   KeySettings = {
      Title = "GHP | Key System ",
      Subtitle = "GHP Hub, The ulitimate multi experience Hub",
      Note = "Please enter your key.",
      FileName = "Key", 
      SaveKey = false, 
      GrabKeyFromSite = true, 
      Key = {"https://pastebin.com/raw/iUDnmCVX"} 
   }
})

local MainTab = Window:CreateTab("Player ⭐", nil) 
local MainSection = MainTab:CreateSection("Player Options")

local Button = MainTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
       
_G.infinjump = not _G.infinjump

if _G.infinJumpStarted == nil then

	_G.infinJumpStarted = true
	
	



	local plr = game:GetService('Players').LocalPlayer
	local m = plr:GetMouse()
	m.KeyDown:connect(function(k)
		if _G.infinjump then
			if k:byte() == 32 then
			humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
			humanoid:ChangeState('Jumping')
			wait()
			humanoid:ChangeState('Seated')
			end
		end
	end)
end
   end,
})

  
local Slider = MainTab:CreateSlider({
   Name = "WalkSpeed Slider",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderws", 
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "JumpPower Slider",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderjp", 
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Value)
   end,
})

local MainTab = Window:CreateTab("PvP 🔫", nil) 
local MainSection = MainTab:CreateSection("Aim Options")

local Button = MainTab:CreateButton({
   Name = "AimBot",
   Callback = function()

_G.AimPart = "Head"
_G.Sensitivity = 0
_G.CircleSides = 75
_G.CircleColor = Color3.fromRGB(255, 255, 255)
_G.CircleTransparency = 0.6
_G.CircleRadius = 75
_G.CircleFilled = false
_G.CircleVisible = true
_G.CircleThickness = 1
_G.RageCheck = true 
_G.RageDistance = 1000 
_G.TeamCheck = false 
local Epitaph = 0 


local Area = game:GetService("Workspace")
local MyView = Area.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MyCharacter = LocalPlayer.Character
local MyRoot = MyCharacter:FindFirstChild("HumanoidRootPart")
local MyHumanoid = MyCharacter:FindFirstChild("Humanoid")
local Mouse = LocalPlayer:GetMouse()
local HoldingM2 = false
local Active = false
local Lock = false
local HeadOffset = Vector3.new(0,.1, 0)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(MyView.ViewportSize.X / 2, MyView.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function CursorLock()
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
end
local function UnLockCursor()
    HoldingM2 = false
    Active = false
    Lock = false
    UIS.MouseBehavior = Enum.MouseBehavior.Default
end

function FindNearestPlayer()
    local Target = nil
    local SecondTarget = nil
    for _, v in pairs(Players:GetPlayers()) do
        if v and v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local TheirCharacter = v.Character
            for _, part in pairs(TheirCharacter:GetChildren()) do
                if part and part:IsA("BasePart") then
                    local CharacterRoot, Visible = MyView:WorldToViewportPoint(part.Position)
                    if Visible then
                        local DistanceFromCircleCenter = (Vector2.new(CharacterRoot.X, CharacterRoot.Y) - FOVCircle.Position).Magnitude
                        if DistanceFromCircleCenter <= FOVCircle.Radius then
                            if RageCheck(TheirCharacter) and TeamCheck(TheirCharacter) then
                                local AimPart = TheirCharacter:FindFirstChild(_G.AimPart)
                                if AimPart then
                                    if Target == nil or DistanceFromCircleCenter <= (Vector2.new(MyView:WorldToViewportPoint(Target[_G.AimPart].Position).X, MyView:WorldToViewportPoint(Target[_G.AimPart].Position).Y) - FOVCircle.Position).Magnitude then
                                        SecondTarget = Target
                                        Target = TheirCharacter
                                    elseif SecondTarget == nil or DistanceFromCircleCenter <= (Vector2.new(MyView:WorldToViewportPoint(SecondTarget[_G.AimPart].Position).X, MyView:WorldToViewportPoint(SecondTarget[_G.AimPart].Position).Y) - FOVCircle.Position).Magnitude then
                                        SecondTarget = TheirCharacter
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if Target == nil then
        return SecondTarget
    else
        return Target
    end
end



function RageCheck(Target)
    if _G.RageCheck then
        local Distance = (MyRoot.Position - Target[_G.AimPart].Position).Magnitude
        if Distance > _G.RageDistance then
            return false
        end
    end
    return true
end

function TeamCheck(Target)
    if _G.TeamCheck then
        if Target and LocalPlayer.Team then
            if game.Players[Target.Name].Team == LocalPlayer.Team then
                return false
            end
        end
    end
    return true
end

UIS.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldingM2 = true
        Active = true
        Lock = true
        if Active then
            local The_Enemy = FindNearestPlayer()
            while HoldingM2 do task.wait()
                if Lock and The_Enemy and The_Enemy:FindFirstChild(_G.AimPart) and RageCheck(The_Enemy) and TeamCheck(The_Enemy) then
                    local Future = The_Enemy[_G.AimPart].CFrame + (The_Enemy[_G.AimPart].Velocity * Epitaph + HeadOffset)
                    MyView.CFrame = CFrame.lookAt(MyView.CFrame.Position, Future.Position)
                    CursorLock()
                end
            end
        end
    end
end)
UIS.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        UnLockCursor()
    end
end)

FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)

UIS.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement then
        FOVCircle.Position = UIS:GetMouseLocation()
    end
end)


   end,
})

local MainSection = MainTab:CreateSection("Visual Options")

local Button = MainTab:CreateButton({
   Name = "ESP",
   Callback = function()

-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Cache services
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer and LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalHumanoidRootPart = LocalCharacter:WaitForChild("HumanoidRootPart")

local ESP = {}
ESP.__index = ESP

function ESP.new()
    local self = setmetatable({}, ESP)
    self.espCache = {}
    return self
end

function ESP:createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, val in pairs(properties) do
        drawing[prop] = val
    end
    return drawing
end

function ESP:createComponents()
    return {
        Box = self:createDrawing("Square", {
            Thickness = 1,
            Transparency = 1,
            Color = Color3.fromRGB(255, 255, 255),
            Filled = false
        }),
        Tracer = self:createDrawing("Line", {
            Thickness = 1,
            Transparency = 1,
            Color = Color3.fromRGB(255, 255, 255)
        }),
        DistanceLabel = self:createDrawing("Text", {
            Size = 18,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0)
        }),
        NameLabel = self:createDrawing("Text", {
            Size = 18,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0)
        }),
        HealthBar = {
            Outline = self:createDrawing("Square", {
                Thickness = 1,
                Transparency = 1,
                Color = Color3.fromRGB(0, 0, 0),
                Filled = false
            }),
            Health = self:createDrawing("Square", {
                Thickness = 1,
                Transparency = 1,
Color = Color3.fromRGB(0, 255, 0),
                Filled = true
            })
        },
        ItemLabel = self:createDrawing("Text", {
            Size = 18,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0)
        }),
        SkeletonLines = {}
    }
end

local bodyConnections = {
    R15 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"}
    },
    R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
}

function ESP:updateComponents(components, character, player)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")

    if hrp and humanoid then
        local hrpPosition, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        local mousePosition = Camera:WorldToViewportPoint(LocalPlayer:GetMouse().Hit.p)

        if onScreen then
            local screenWidth, screenHeight = Camera.ViewportSize.X, Camera.ViewportSize.Y
            local factor = 1 / (hrpPosition.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
            local width, height = math.floor(screenHeight / 25 * factor), math.floor(screenWidth / 27 * factor)
            local distanceFromPlayer = math.floor((LocalHumanoidRootPart.Position - hrp.Position).magnitude)
-- Box properties
            components.Box.Size = Vector2.new(width, height)
            components.Box.Position = Vector2.new(hrpPosition.X - width / 2, hrpPosition.Y - height / 2)
            components.Box.Visible = true

            -- Tracer properties
            components.Tracer.From = Vector2.new(mousePosition.X, mousePosition.Y)
            components.Tracer.To = Vector2.new(hrpPosition.X, hrpPosition.Y + height / 2)
            components.Tracer.Visible = true

            -- Distance label properties
            components.DistanceLabel.Text = string.format("[%dM]", distanceFromPlayer)
            components.DistanceLabel.Position = Vector2.new(hrpPosition.X, hrpPosition.Y + height / 2 + 15)
            components.DistanceLabel.Visible = true

           -- Skeleton properties
            local connections = bodyConnections[humanoid.RigType.Name] or {}
            for _, connection in ipairs(connections) do
                local partA = character:FindFirstChild(connection[1])
                local partB = character:FindFirstChild(connection[2])
                if partA and partB then
                    local line = components.SkeletonLines[connection[1] .. "-" .. connection[2]] or self:createDrawing("Line", {Thickness = 1, Color = Color3.fromRGB(255, 255, 255)})
                    local posA, onScreenA = Camera:WorldToViewportPoint(partA.Position)
                    local posB, onScreenB = Camera:WorldToViewportPoint(partB.Position)
                    if onScreenA and onScreenB then
                        line.From = Vector2.new(posA.X, posA.Y)
                        line.To = Vector2.new(posB.X, posB.Y)
                        line.Visible = true
                        components.SkeletonLines[connection[1] .. "-" .. connection[2]] = line
                    else
                        line.Visible = false
                    end
                end
            end
        else
            self:hideComponents(components)
        end
    else
        self:hideComponents(components)
    end
end

function ESP:hideComponents(components)
    components.Box.Visible = false
    components.Tracer.Visible = false
    components.DistanceLabel.Visible = false
    components.NameLabel.Visible = false
    components.HealthBar.Outline.Visible = false
    components.HealthBar.Health.Visible = false
    components.ItemLabel.Visible = false

    for _, line in pairs(components.SkeletonLines) do
        line.Visible = false
    end
end

function ESP:removeEsp(player)
    local components = self.espCache[player]
    if components then
        components.Box:Remove()
        components.Tracer:Remove()
        components.DistanceLabel:Remove()
        components.NameLabel:Remove()
        components.HealthBar.Outline:Remove()
        components.HealthBar.Health:Remove()
        components.ItemLabel:Remove()
        for _, line in pairs(components.SkeletonLines) do
            line:Remove()
        end
        self.espCache[player] = nil
    end
end

local espInstance = ESP.new()

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                if not espInstance.espCache[player] then
                    espInstance.espCache[player] = espInstance:createComponents()
                end
                espInstance:updateComponents(espInstance.espCache[player], character, player)
            else
                if espInstance.espCache[player] then
                    espInstance:hideComponents(espInstance.espCache[player])
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    espInstance:removeEsp(player)
end)
   end,
})
