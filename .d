--[[
    IncognoL's Convenient Menu
    v1.0
    Roblox-style Luau command menu

    Main sections:
        All Commands
        Player
        Client-Sided
        Server-Sided

    CLI:
        /help
        /clear
        ;command
        /command
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    Name = "IncognoL's Convenient Menu",
    Version = "v1.0",

    Width = 720,
    Height = 430,

    Background = Color3.fromRGB(11, 11, 11),
    Panel = Color3.fromRGB(17, 17, 17),
    PanelHover = Color3.fromRGB(27, 27, 27),

    Border = Color3.fromRGB(55, 55, 55),
    BorderHover = Color3.fromRGB(82, 82, 82),

    Text = Color3.fromRGB(225, 225, 225),
    SubText = Color3.fromRGB(145, 145, 145),

    Accent = Color3.fromRGB(105, 170, 255),
}

--==================================================
-- STATE
--==================================================

local MenuOpen = true
local MenuMinimized = false

local FlyEnabled = false
local NoclipEnabled = false
local SpinEnabled = false

local FlyConnection
local NoclipConnection
local SpinConnection

local SavedWalkSpeed = 16
local SavedJumpPower = 50
local SavedGravity = workspace.Gravity

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IncognolsConvenientMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- MAIN WINDOW
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = CONFIG.Background
Main.BorderSizePixel = 1
Main.BorderColor3 = CONFIG.Border
Main.Visible = true
Main.Parent = ScreenGui

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = CONFIG.Panel
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopBarLine = Instance.new("Frame")
TopBarLine.Size = UDim2.new(1, 0, 0, 1)
TopBarLine.Position = UDim2.new(0, 0, 1, -1)
TopBarLine.BackgroundColor3 = CONFIG.Border
TopBarLine.BorderSizePixel = 0
TopBarLine.Parent = TopBar

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -115, 1, 0)
Title.Position = UDim2.fromOffset(9, 0)
Title.BackgroundTransparency = 1
Title.Text = CONFIG.Name
Title.TextColor3 = CONFIG.Text
Title.TextSize = 14
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

--==================================================
-- VERSION
--==================================================

local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Size = UDim2.fromOffset(42, 36)
Version.Position = UDim2.new(1, -112, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = CONFIG.Version
Version.TextColor3 = CONFIG.SubText
Version.TextSize = 11
Version.Font = Enum.Font.Code
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.Parent = TopBar

--==================================================
-- MINIMIZE BUTTON
--==================================================

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.fromOffset(27, 27)
Minimize.Position = UDim2.new(1, -65, 0, 4)
Minimize.BackgroundColor3 = CONFIG.Panel
Minimize.BorderSizePixel = 1
Minimize.BorderColor3 = CONFIG.Border
Minimize.Text = "_"
Minimize.TextColor3 = CONFIG.SubText
Minimize.TextSize = 13
Minimize.Font = Enum.Font.Code
Minimize.AutoButtonColor = false
Minimize.Parent = TopBar

Minimize.MouseEnter:Connect(function()
    Minimize.BackgroundColor3 = CONFIG.PanelHover
    Minimize.BorderColor3 = CONFIG.BorderHover
end)

Minimize.MouseLeave:Connect(function()
    Minimize.BackgroundColor3 = CONFIG.Panel
    Minimize.BorderColor3 = CONFIG.Border
end)

--==================================================
-- CLOSE BUTTON
--==================================================

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.fromOffset(27, 27)
Close.Position = UDim2.new(1, -33, 0, 4)
Close.BackgroundColor3 = CONFIG.Panel
Close.BorderSizePixel = 1
Close.BorderColor3 = CONFIG.Border
Close.Text = "X"
Close.TextColor3 = CONFIG.SubText
Close.TextSize = 12
Close.Font = Enum.Font.Code
Close.AutoButtonColor = false
Close.Parent = TopBar

Close.MouseEnter:Connect(function()
    Close.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
    Close.BorderColor3 = Color3.fromRGB(110, 55, 55)
    Close.TextColor3 = Color3.fromRGB(255, 120, 120)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = CONFIG.Panel
    Close.BorderColor3 = CONFIG.Border
    Close.TextColor3 = CONFIG.SubText
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--==================================================
-- SCREEN TOGGLE BUTTON
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.fromOffset(76, 28)
ToggleButton.Position = UDim2.fromOffset(10, 10)
ToggleButton.BackgroundColor3 = CONFIG.Panel
ToggleButton.BorderSizePixel = 1
ToggleButton.BorderColor3 = CONFIG.Border
ToggleButton.Text = "MENU"
ToggleButton.TextColor3 = CONFIG.Text
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.Code
ToggleButton.AutoButtonColor = false
ToggleButton.Visible = true
ToggleButton.Parent = ScreenGui

ToggleButton.MouseEnter:Connect(function()
    ToggleButton.BackgroundColor3 = CONFIG.PanelHover
    ToggleButton.BorderColor3 = CONFIG.BorderHover
end)

ToggleButton.MouseLeave:Connect(function()
    ToggleButton.BackgroundColor3 = CONFIG.Panel
    ToggleButton.BorderColor3 = CONFIG.Border
end)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

TopBar.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )

end)

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -48)
Content.Position = UDim2.fromOffset(10, 44)
Content.BackgroundTransparency = 1
Content.Parent = Main

--==================================================
-- HELPERS
--==================================================

local function getCharacter(player)
    if not player then
        return nil
    end

    return player.Character
end

local function getHumanoid(player)
    local character = getCharacter(player)

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

local function getRoot(player)
    local character = getCharacter(player)

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function findPlayer(query)

    if not query then
        return nil
    end

    query = tostring(query):lower()

    if query == "me" then
        return LocalPlayer
    end

    for _, player in ipairs(Players:GetPlayers()) do

        if player.Name:lower() == query
            or player.DisplayName:lower() == query then

            return player
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do

        if player.Name:lower():sub(1, #query) == query
            or player.DisplayName:lower():sub(1, #query) == query then

            return player
        end
    end

    return nil
end

local function getTargets(selector)

    selector = selector and tostring(selector):lower() or "me"

    if selector == "me" then
        return {LocalPlayer}
    end

    if selector == "all" then
        return Players:GetPlayers()
    end

    if selector == "others" then

        local targets = {}

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(targets, player)
            end
        end

        return targets
    end

    if selector == "random" then

        local players = Players:GetPlayers()

        if #players == 0 then
            return {}
        end

        return {players[math.random(1, #players)]}
    end

    local player = findPlayer(selector)

    if player then
        return {player}
    end

    return {}
end

local function getNumber(value, default)
    local n = tonumber(value)
    return n or default
end

local function resetCharacter()

    local humanoid = getHumanoid(LocalPlayer)

    if humanoid then
        humanoid.Health = 0
    end

end

--==================================================
-- PLAYER PHYSICS / PLAYER COMMANDS
-- ALL OF THESE ARE IN PLAYER
--==================================================

local Commands = {

    --==================================================
    -- PLAYER
    --==================================================

    {
        Name = "speed",
        Aliases = {"walkspeed", "ws"},
        Description = "Changes walk speed.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])
            local speed = getNumber(args[2], 16)

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid.WalkSpeed = speed
                end

            end

            return "WalkSpeed set to " .. tostring(speed)
        end,
    },

    {
        Name = "jumppower",
        Aliases = {"jp", "jumpheight"},
        Description = "Changes jump power.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])
            local power = getNumber(args[2], 50)

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then

                    if humanoid.UseJumpPower ~= nil then
                        humanoid.UseJumpPower = true
                    end

                    humanoid.JumpPower = power
                end
            end

            return "JumpPower set to " .. tostring(power)
        end,
    },

    {
        Name = "gravity",
        Aliases = {"grav"},
        Description = "Changes workspace gravity.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local gravity = getNumber(args[1], 196.2)

            workspace.Gravity = gravity

            return "Gravity set to " .. tostring(gravity)
        end,
    },

    {
        Name = "jump",
        Aliases = {},
        Description = "Makes a player jump.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid.Jump = true
                end

            end

            return "Jump triggered."
        end,
    },

    {
        Name = "sit",
        Aliases = {},
        Description = "Makes a player sit.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid.Sit = true
                end

            end

            return "Sit triggered."
        end,
    },

    {
        Name = "platformstand",
        Aliases = {"platform"},
        Description = "Enables PlatformStand.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid.PlatformStand = true
                end

            end

            return "PlatformStand enabled."
        end,
    },

    {
        Name = "unplatformstand",
        Aliases = {"unplatform"},
        Description = "Disables PlatformStand.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid.PlatformStand = false
                end

            end

            return "PlatformStand disabled."
        end,
    },

    {
        Name = "freeze",
        Aliases = {},
        Description = "Freezes a player's root part.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local root = getRoot(player)

                if root then
                    root.Anchored = true
                end

            end

            return "Target(s) frozen."
        end,
    },

    {
        Name = "unfreeze",
        Aliases = {},
        Description = "Unfreezes a player's root part.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local root = getRoot(player)

                if root then
                    root.Anchored = false
                end

            end

            return "Target(s) unfrozen."
        end,
    },

    {
        Name = "respawn",
        Aliases = {"reset"},
        Description = "Respawns the target player.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid.Health = 0
                end

            end

            return "Respawn requested."
        end,
    },

    {
        Name = "noclip",
        Aliases = {"nc"},
        Description = "Disables character collisions.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local target = args[1] or "me"

            if target ~= "me" and findPlayer(target) ~= LocalPlayer then
                return "Noclip is local-only."
            end

            NoclipEnabled = true

            if NoclipConnection then
                NoclipConnection:Disconnect()
            end

            NoclipConnection = RunService.Stepped:Connect(function()

                if not NoclipEnabled then
                    return
                end

                local character = LocalPlayer.Character

                if not character then
                    return
                end

                for _, part in ipairs(character:GetDescendants()) do

                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end

                end
            end)

            return "Noclip enabled."
        end,
    },

    {
        Name = "clip",
        Aliases = {},
        Description = "Restores character collisions.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            NoclipEnabled = false

            if NoclipConnection then
                NoclipConnection:Disconnect()
                NoclipConnection = nil
            end

            local character = LocalPlayer.Character

            if character then

                for _, part in ipairs(character:GetDescendants()) do

                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end

                end
            end

            return "Noclip disabled."
        end,
    },

    {
        Name = "fly",
        Aliases = {},
        Description = "Enables flight.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            if FlyEnabled then
                return "Fly is already enabled."
            end

            FlyEnabled = true

            local character = LocalPlayer.Character
            local root = getRoot(LocalPlayer)

            if not character or not root then
                FlyEnabled = false
                return "Character unavailable."
            end

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "IncognolsFlyVelocity"
            bodyVelocity.MaxForce = Vector3.new(
                math.huge,
                math.huge,
                math.huge
            )
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = root

            FlyConnection = RunService.RenderStepped:Connect(function()

                if not FlyEnabled then
                    return
                end

                local currentRoot = getRoot(LocalPlayer)

                if not currentRoot or not bodyVelocity.Parent then
                    return
                end

                local camera = workspace.CurrentCamera

                if not camera then
                    return
                end

                local direction = Vector3.zero

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction += camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction -= camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction += camera.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction -= camera.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction += Vector3.yAxis
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    direction -= Vector3.yAxis
                end

                if direction.Magnitude > 0 then
                    direction = direction.Unit * 50
                else
                    direction = Vector3.zero
                end

                bodyVelocity.Velocity = direction
            end)

            return "Fly enabled."
        end,
    },

    {
        Name = "unfly",
        Aliases = {},
        Description = "Disables flight.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            FlyEnabled = false

            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end

            local root = getRoot(LocalPlayer)

            if root then

                local existing =
                    root:FindFirstChild("IncognolsFlyVelocity")

                if existing then
                    existing:Destroy()
                end
            end

            return "Fly disabled."
        end,
    },

    {
        Name = "spin",
        Aliases = {},
        Description = "Spins the local character.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            if SpinEnabled then
                return "Spin is already enabled."
            end

            SpinEnabled = true

            local speed = getNumber(args[1], 15)

            SpinConnection = RunService.RenderStepped:Connect(function(dt)

                if not SpinEnabled then
                    return
                end

                local root = getRoot(LocalPlayer)

                if root then
                    root.CFrame =
                        root.CFrame
                        * CFrame.Angles(0, math.rad(speed) * dt, 0)
                end
            end)

            return "Spin enabled."
        end,
    },

    {
        Name = "unspin",
        Aliases = {},
        Description = "Stops spinning.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            SpinEnabled = false

            if SpinConnection then
                SpinConnection:Disconnect()
                SpinConnection = nil
            end

            return "Spin disabled."
        end,
    },

    {
        Name = "freefall",
        Aliases = {},
        Description = "Forces the Humanoid into Freefall.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                end

            end

            return "Freefall triggered."
        end,
    },

    {
        Name = "tp",
        Aliases = {"teleport"},
        Description = "Teleports you to a player.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local target = findPlayer(args[1])

            if not target then
                return "Player not found."
            end

            local myRoot = getRoot(LocalPlayer)
            local targetRoot = getRoot(target)

            if not myRoot or not targetRoot then
                return "Character unavailable."
            end

            myRoot.CFrame = targetRoot.CFrame

            return "Teleported to " .. target.Name .. "."
        end,
    },

    {
        Name = "goto",
        Aliases = {},
        Description = "Teleports you to a player.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)

            local target = findPlayer(args[1])

            if not target then
                return "Player not found."
            end

            local myRoot = getRoot(LocalPlayer)
            local targetRoot = getRoot(target)

            if not myRoot or not targetRoot then
                return "Character unavailable."
            end

            myRoot.CFrame = targetRoot.CFrame

            return "Teleported to " .. target.Name .. "."
        end,
    },

    {
        Name = "bring",
        Aliases = {},
        Description = "Attempts to bring a player to you.",
        Category = "Player",
        Side = "Server-Sided",

        Execute = function(args)

            local target = findPlayer(args[1])

            if not target then
                return "Player not found."
            end

            local myRoot = getRoot(LocalPlayer)
            local targetRoot = getRoot(target)

            if not myRoot or not targetRoot then
                return "Character unavailable."
            end

            targetRoot.CFrame = myRoot.CFrame

            return "Bring requested for " .. target.Name .. "."
        end,
    },

    --==================================================
    -- CLIENT-SIDED
    --==================================================

    {
        Name = "rejoin",
        Aliases = {"reconnect"},
        Description = "Reconnects to the current place.",
        Category = "Client-Sided",
        Side = "Client-Sided",

        Execute = function(args)

            local TeleportService = game:GetService("TeleportService")

            local success, err = pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)

            if not success then
                return "Rejoin failed: " .. tostring(err)
            end

            return "Rejoining..."
        end,
    },

    --==================================================
    -- SERVER-SIDED
    --==================================================

    {
        Name = "kill",
        Aliases = {"die"},
        Description = "Kills the target player.",
        Category = "Server-Sided",
        Side = "Server-Sided",

        Execute = function(args)

            local targets = getTargets(args[1])

            for _, player in ipairs(targets) do

                local humanoid = getHumanoid(player)

                if humanoid then
                    humanoid.Health = 0
                end

            end

            return "Kill requested."
        end,
    },

}

--==================================================
-- COMMAND LOOKUP
--==================================================

local function findCommand(name)

    name = tostring(name):lower()

    for _, command in ipairs(Commands) do

        if command.Name:lower() == name then
            return command
        end

        for _, alias in ipairs(command.Aliases or {}) do

            if alias:lower() == name then
                return command
            end

        end
    end

    return nil
end

--==================================================
-- MAIN PAGE SYSTEM
--==================================================

local CurrentPage = nil

local function clearContent()

    for _, child in ipairs(Content:GetChildren()) do
        child:Destroy()
    end

end

local function makeButton(parent, text, size, position)

    local button = Instance.new("TextButton")

    button.Size = size
    button.Position = position
    button.BackgroundColor3 = CONFIG.Panel
    button.BorderSizePixel = 1
    button.BorderColor3 = CONFIG.Border
    button.Text = text
    button.TextColor3 = CONFIG.Text
    button.TextSize = 13
    button.Font = Enum.Font.Code
    button.AutoButtonColor = false
    button.Parent = parent

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = CONFIG.PanelHover
        button.BorderColor3 = CONFIG.BorderHover
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = CONFIG.Panel
        button.BorderColor3 = CONFIG.Border
    end)

    return button
end

local function createTitle(text)

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.fromOffset(5, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.Text
    label.TextSize = 14
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Content

    return label
end

--==================================================
-- CATEGORY BUTTONS
--==================================================

local showHome
local showCategories
local showCommands
local showCLI

showHome = function()

    clearContent()
    CurrentPage = "Home"

    local helpButton = makeButton(
        Content,
        "HELP",
        UDim2.fromOffset(200, 48),
        UDim2.new(0.5, -205, 0.5, -24)
    )

    local cliButton = makeButton(
        Content,
        "COMMAND LINE INTERFACE",
        UDim2.fromOffset(200, 48),
        UDim2.new(0.5, 5, 0.5, -24)
    )

    helpButton.MouseButton1Click:Connect(function()
        showCategories()
    end)

    cliButton.MouseButton1Click:Connect(function()
        showCLI()
    end)

end

--==================================================
-- HELP
--==================================================

showCategories = function()

    clearContent()
    CurrentPage = "Help"

    createTitle("HELP")

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -10, 0, 20)
    info.Position = UDim2.fromOffset(5, 30)
    info.BackgroundTransparency = 1
    info.Text = "Select a command section."
    info.TextColor3 = CONFIG.SubText
    info.TextSize = 11
    info.Font = Enum.Font.Code
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.Parent = Content

    local categories = {
        "All Commands",
        "Player",
        "Client-Sided",
        "Server-Sided",
    }

    local y = 60

    for _, category in ipairs(categories) do

        local button = makeButton(
            Content,
            category,
            UDim2.new(1, -10, 0, 38),
            UDim2.fromOffset(5, y)
        )

        button.MouseButton1Click:Connect(function()
            showCommands(category)
        end)

        y += 43
    end

    local back = makeButton(
        Content,
        "< Back",
        UDim2.fromOffset(70, 30),
        UDim2.fromOffset(5, y + 8)
    )

    back.MouseButton1Click:Connect(function()
        showHome()
    end)

end

--==================================================
-- COMMAND PAGE
--==================================================

showCommands = function(category)

    clearContent()
    CurrentPage = category

    local back = makeButton(
        Content,
        "< Back",
        UDim2.fromOffset(70, 28),
        UDim2.fromOffset(5, 2)
    )

    back.MouseButton1Click:Connect(function()
        showCategories()
    end)

    local heading = Instance.new("TextLabel")
    heading.Size = UDim2.new(1, -90, 0, 28)
    heading.Position = UDim2.fromOffset(85, 2)
    heading.BackgroundTransparency = 1
    heading.Text = category
    heading.TextColor3 = CONFIG.Text
    heading.TextSize = 14
    heading.Font = Enum.Font.Code
    heading.TextXAlignment = Enum.TextXAlignment.Left
    heading.Parent = Content

    local searchBox = nil

    if category == "All Commands" then

        searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -10, 0, 30)
        searchBox.Position = UDim2.fromOffset(5, 36)
        searchBox.BackgroundColor3 = CONFIG.Panel
        searchBox.BorderSizePixel = 1
        searchBox.BorderColor3 = CONFIG.Border
        searchBox.Text = ""
        searchBox.PlaceholderText = "Search commands..."
        searchBox.PlaceholderColor3 = CONFIG.SubText
        searchBox.TextColor3 = CONFIG.Text
        searchBox.TextSize = 12
        searchBox.Font = Enum.Font.Code
        searchBox.ClearTextOnFocus = false
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.Parent = Content

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 8)
        padding.Parent = searchBox
    end

    local listTop = category == "All Commands" and 72 or 38

    local list = Instance.new("ScrollingFrame")
    list.Name = "CommandList"
    list.Size = UDim2.new(1, -10, 1, -(listTop + 5))
    list.Position = UDim2.fromOffset(5, listTop)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = CONFIG.BorderHover
    list.CanvasSize = UDim2.new()
    list.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local function refresh()

        for _, child in ipairs(list:GetChildren()) do

            if not child:IsA("UIListLayout") then
                child:Destroy()
            end

        end

        local query = ""

        if searchBox then
            query = searchBox.Text:lower()
        end

        local shown = 0

        for _, command in ipairs(Commands) do

            local categoryMatch = false

            if category == "All Commands" then
                categoryMatch = true

            elseif category == "Player" then
                categoryMatch = command.Category == "Player"

            elseif category == "Client-Sided" then
                categoryMatch = command.Side == "Client-Sided"

            elseif category == "Server-Sided" then
                categoryMatch = command.Side == "Server-Sided"
            end

            local searchMatch = true

            if query ~= "" then

                searchMatch =
                    command.Name:lower():find(query, 1, true) ~= nil

            end

            if categoryMatch and searchMatch then

                shown += 1

                local entry = Instance.new("TextButton")
                entry.Size = UDim2.new(1, -5, 0, 52)
                entry.BackgroundColor3 = CONFIG.Panel
                entry.BorderSizePixel = 1
                entry.BorderColor3 = CONFIG.Border
                entry.Text = ""
                entry.AutoButtonColor = false
                entry.Parent = list

                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(1, -14, 0, 20)
                name.Position = UDim2.fromOffset(7, 3)
                name.BackgroundTransparency = 1
                name.Text = ";" .. command.Name
                name.TextColor3 = CONFIG.Accent
                name.TextSize = 13
                name.Font = Enum.Font.Code
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.Parent = entry

                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -14, 0, 20)
                desc.Position = UDim2.fromOffset(7, 25)
                desc.BackgroundTransparency = 1
                desc.Text = command.Description or ""
                desc.TextColor3 = CONFIG.SubText
                desc.TextSize = 11
                desc.Font = Enum.Font.Code
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = entry

                entry.MouseEnter:Connect(function()
                    entry.BackgroundColor3 = CONFIG.PanelHover
                end)

                entry.MouseLeave:Connect(function()
                    entry.BackgroundColor3 = CONFIG.Panel
                end)

                entry.MouseButton1Click:Connect(function()
                    if CurrentPage ~= "Command Line Interface" then
                        showCLI()

                        task.defer(function()

                            if _G.IncognoLCLIInput then
                                _G.IncognoLCLIInput.Text = ";" .. command.Name .. " "
                                _G.IncognoLCLIInput:CaptureFocus()
                                _G.IncognoLCLIInput.CursorPosition =
                                    #_G.IncognoLCLIInput.Text + 1
                            end

                        end)
                    end
                end)

            end

        end

        if shown == 0 then

            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, -5, 0, 25)
            empty.BackgroundTransparency = 1
            empty.Text = "No commands found."
            empty.TextColor3 = CONFIG.SubText
            empty.TextSize = 11
            empty.Font = Enum.Font.Code
            empty.TextXAlignment = Enum.TextXAlignment.Left
            empty.Parent = list

        end

        task.defer(function()

            list.CanvasSize = UDim2.fromOffset(
                0,
                layout.AbsoluteContentSize.Y + 5
            )

        end)

    end

    refresh()

    if searchBox then

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            refresh()
        end)

    end

end

--==================================================
-- CLI
--==================================================

showCLI = function()

    clearContent()
    CurrentPage = "CLI"

    local back = makeButton(
        Content,
        "< Back",
        UDim2.fromOffset(70, 28),
        UDim2.fromOffset(5, 2)
    )

    back.MouseButton1Click:Connect(function()
        showHome()
    end)

    local heading = Instance.new("TextLabel")
    heading.Size = UDim2.new(1, -90, 0, 28)
    heading.Position = UDim2.fromOffset(85, 2)
    heading.BackgroundTransparency = 1
    heading.Text = "Command Line Interface"
    heading.TextColor3 = CONFIG.Text
    heading.TextSize = 14
    heading.Font = Enum.Font.Code
    heading.TextXAlignment = Enum.TextXAlignment.Left
    heading.Parent = Content

    --==================================================
    -- CONSOLE
    --==================================================

    local console = Instance.new("ScrollingFrame")
    console.Name = "Console"
    console.Size = UDim2.new(1, -10, 1, -105)
    console.Position = UDim2.fromOffset(5, 38)
    console.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
    console.BorderSizePixel = 1
    console.BorderColor3 = CONFIG.Border
    console.ScrollBarThickness = 3
    console.ScrollBarImageColor3 = CONFIG.BorderHover
    console.CanvasSize = UDim2.new()
    console.Parent = Content

    local consolePadding = Instance.new("UIPadding")
    consolePadding.PaddingTop = UDim.new(0, 5)
    consolePadding.PaddingLeft = UDim.new(0, 7)
    consolePadding.Parent = console

    local consoleLayout = Instance.new("UIListLayout")
    consoleLayout.Padding = UDim.new(0, 1)
    consoleLayout.Parent = console

    local function printLine(text)

        local line = Instance.new("TextLabel")
        line.Size = UDim2.new(1, -8, 0, 18)
        line.BackgroundTransparency = 1
        line.Text = tostring(text)
        line.TextColor3 = CONFIG.SubText
        line.TextSize = 11
        line.Font = Enum.Font.Code
        line.TextXAlignment = Enum.TextXAlignment.Left
        line.Parent = console

        task.defer(function()

            console.CanvasSize = UDim2.fromOffset(
                0,
                consoleLayout.AbsoluteContentSize.Y + 8
            )

            console.CanvasPosition = Vector2.new(
                0,
                math.max(0, console.AbsoluteCanvasSize.Y)
            )

        end)

        return line
    end

    --==================================================
    -- INPUT
    --==================================================

    local input = Instance.new("TextBox")
    input.Name = "CommandInput"
    input.Size = UDim2.new(1, -175, 0, 38)
    input.Position = UDim2.new(0, 5, 1, -43)
    input.BackgroundColor3 = CONFIG.Panel
    input.BorderSizePixel = 1
    input.BorderColor3 = CONFIG.Border
    input.Text = ""
    input.PlaceholderText = ";command target"
    input.PlaceholderColor3 = CONFIG.SubText
    input.TextColor3 = CONFIG.Text
    input.TextSize = 12
    input.Font = Enum.Font.Code
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = Content

    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 8)
    inputPadding.PaddingRight = UDim.new(0, 8)
    inputPadding.Parent = input

    _G.IncognoLCLIInput = input

    --==================================================
    -- EXECUTE
    --==================================================

    local execute = makeButton(
        Content,
        "EXECUTE",
        UDim2.fromOffset(78, 38),
        UDim2.new(1, -165, 1, -43)
    )

    --==================================================
    -- CLEAR
    --==================================================

    local clear = makeButton(
        Content,
        "CLEAR",
        UDim2.fromOffset(78, 38),
        UDim2.new(1, -82, 1, -43)
    )

    --==================================================
    -- COMMAND EXECUTOR
    --==================================================

    local function executeCommand(text)

        text = tostring(text)

        text = text:match("^%s*(.-)%s*$") or ""

        if text == "" then
            return
        end

        printLine("> " .. text)

        local clean = text

        if clean:sub(1, 1) == ";" or clean:sub(1, 1) == "/" then
            clean = clean:sub(2)
        end

        clean = clean:match("^%s*(.-)%s*$") or ""

        local args = {}

        for value in clean:gmatch("%S+") do
            table.insert(args, value)
        end

        local commandName = args[1]

        if not commandName then
            return
        end

        table.remove(args, 1)

        --==============================================
        -- HELP
        --==============================================

        if commandName:lower() == "help" then

            printLine("")
            printLine("===== ALL COMMANDS =====")

            for _, command in ipairs(Commands) do
                printLine(
                    ";" .. command.Name
                    .. " - "
                    .. (command.Description or "")
                )
            end

            printLine("")
            printLine("===== PLAYER =====")

            for _, command in ipairs(Commands) do

                if command.Category == "Player" then

                    printLine(
                        ";" .. command.Name
                        .. " - "
                        .. (command.Description or "")
                    )

                end
            end

            printLine("")
            printLine("===== CLIENT-SIDED =====")

            for _, command in ipairs(Commands) do

                if command.Side == "Client-Sided" then

                    printLine(
                        ";" .. command.Name
                        .. " - "
                        .. (command.Description or "")
                    )

                end
            end

            printLine("")
            printLine("===== SERVER-SIDED =====")

            for _, command in ipairs(Commands) do

                if command.Side == "Server-Sided" then

                    printLine(
                        ";" .. command.Name
                        .. " - "
                        .. (command.Description or "")
                    )

                end
            end

            return
        end

        --==============================================
        -- CLEAR
        --==============================================

        if commandName:lower() == "clear" then

            for _, child in ipairs(console:GetChildren()) do

                if child:IsA("TextLabel") then
                    child:Destroy()
                end

            end

            return
        end

        --==============================================
        -- COMMAND LOOKUP
        --==============================================

        local command = findCommand(commandName)

        if not command then

            printLine(
                "Unknown command: "
                .. tostring(commandName)
            )

            printLine("Type ;help to see commands.")

            return
        end

        --==============================================
        -- EXECUTE
        --==============================================

        local success, result = pcall(function()

            return command.Execute(args)

        end)

        if not success then

            printLine(
                "Error: "
                .. tostring(result)
            )

        elseif result ~= nil then

            printLine(tostring(result))

        else

            printLine(
                "Executed ;"
                .. command.Name
            )

        end

    end

    --==================================================
    -- BUTTONS
    --==================================================

    execute.MouseButton1Click:Connect(function()

        local text = input.Text

        input.Text = ""

        executeCommand(text)

    end)

    clear.MouseButton1Click:Connect(function()

        for _, child in ipairs(console:GetChildren()) do

            if child:IsA("TextLabel") then
                child:Destroy()
            end

        end

    end)

    --==================================================
    -- ENTER
    --==================================================

    input.FocusLost:Connect(function(enterPressed)

        if enterPressed then

            local text = input.Text

            input.Text = ""

            executeCommand(text)

        end

    end)

    --==================================================
    -- CLI STARTUP
    --==================================================

    printLine("IncognoL's Convenient Menu")
    printLine("Command Line Interface ready.")
    printLine("Type ;help to list all commands.")
    printLine("")

end

--==================================================
-- MINIMIZE
--==================================================

Minimize.MouseButton1Click:Connect(function()

    MenuMinimized = not MenuMinimized

    Content.Visible = not MenuMinimized
    TopBarLine.Visible = not MenuMinimized

    if MenuMinimized then

        Main.Size = UDim2.fromOffset(CONFIG.Width, 36)
        Minimize.Text = "□"

    else

        Main.Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height)
        Minimize.Text = "_"

    end

end)

--==================================================
-- TOGGLE
--==================================================

ToggleButton.MouseButton1Click:Connect(function()

    if not Main.Parent then
        return
    end

    MenuOpen = not MenuOpen
    Main.Visible = MenuOpen

end)

--==================================================
-- START
--==================================================

showHome()
Main.Visible = true
ToggleButton.Visible = true

--==================================================
-- RETURN
--==================================================

return {
    GUI = ScreenGui,
    Main = Main,
    Commands = Commands,
    ShowHome = showHome,
    ShowHelp = showCategories,
    ShowCommands = showCommands,
    ShowCLI = showCLI,
}
