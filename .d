--[[
    IncognoL's Convenient Menu
    v1.0

    Square / old-school Roblox-inspired UI
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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
    Panel = Color3.fromRGB(16, 16, 16),
    PanelHover = Color3.fromRGB(25, 25, 25),

    Border = Color3.fromRGB(52, 52, 52),
    BorderHover = Color3.fromRGB(78, 78, 78),

    Text = Color3.fromRGB(225, 225, 225),
    SubText = Color3.fromRGB(145, 145, 145),

    Accent = Color3.fromRGB(105, 170, 255),
}

--==================================================
-- COMMAND DATABASE
--==================================================

-- Put your real commands here.
--
-- Category:
--     Player
--
-- Side:
--     Client-Sided
--     Server-Sided

local Commands = {

    {
        Name = "example",
        Description = "Example command.",
        Category = "Player",
        Side = "Client-Sided",

        Execute = function(args)
            print("Example executed", args)
        end,
    },

}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IncognolsConvenientMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- MAIN
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = CONFIG.Background
Main.BorderSizePixel = 1
Main.BorderColor3 = CONFIG.Border
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
Title.Size = UDim2.new(1, -180, 1, 0)
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
Version.Size = UDim2.fromOffset(45, 36)
Version.Position = UDim2.new(1, -105, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = CONFIG.Version
Version.TextColor3 = CONFIG.SubText
Version.TextSize = 11
Version.Font = Enum.Font.Code
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.Parent = TopBar

--==================================================
-- NEON STATUS DOT
--==================================================

local StatusHolder = Instance.new("Frame")
StatusHolder.Name = "Status"
StatusHolder.Size = UDim2.fromOffset(18, 18)
StatusHolder.Position = UDim2.new(1, -58, 0, 9)
StatusHolder.BackgroundTransparency = 1
StatusHolder.Parent = TopBar

local StatusDot = Instance.new("Frame")
StatusDot.Name = "Dot"
StatusDot.Size = UDim2.fromOffset(8, 8)
StatusDot.Position = UDim2.fromScale(0.5, 0.5)
StatusDot.AnchorPoint = Vector2.new(0.5, 0.5)
StatusDot.BackgroundColor3 = Color3.fromRGB(40, 255, 100)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusHolder

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local DotStroke = Instance.new("UIStroke")
DotStroke.Thickness = 2
DotStroke.Transparency = 0.15
DotStroke.Color = StatusDot.BackgroundColor3
DotStroke.Parent = StatusDot

-- Smooth green -> purple -> green
task.spawn(function()

    local green = Color3.fromRGB(40, 255, 100)
    local purple = Color3.fromRGB(190, 70, 255)

    while ScreenGui.Parent do

        local toPurple = TweenService:Create(
            StatusDot,
            TweenInfo.new(
                2.4,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                BackgroundColor3 = purple
            }
        )

        local strokePurple = TweenService:Create(
            DotStroke,
            TweenInfo.new(
                2.4,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Color = purple
            }
        )

        toPurple:Play()
        strokePurple:Play()

        toPurple.Completed:Wait()

        if not ScreenGui.Parent then
            break
        end

        local toGreen = TweenService:Create(
            StatusDot,
            TweenInfo.new(
                2.4,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                BackgroundColor3 = green
            }
        )

        local strokeGreen = TweenService:Create(
            DotStroke,
            TweenInfo.new(
                2.4,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Color = green
            }
        )

        toGreen:Play()
        strokeGreen:Play()

        toGreen.Completed:Wait()
    end
end)

--==================================================
-- CLOSE
--==================================================

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.fromOffset(27, 27)
Close.Position = UDim2.new(1, -31, 0, 4)
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
    Close.TextColor3 = Color3.fromRGB(255, 115, 115)
end)

Close.MouseLeave:Connect(function()
    Close.BackgroundColor3 = CONFIG.Panel
    Close.TextColor3 = CONFIG.SubText
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
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
-- FUNCTION DECLARATIONS
--==================================================

local showHome
local showCategories
local showCommands
local showCLI

--==================================================
-- BUTTON FACTORY
--==================================================

local function createButton(parent, text, size, position)

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

--==================================================
-- CLEAR CONTENT
--==================================================

local function clearContent()

    for _, child in ipairs(Content:GetChildren()) do
        child:Destroy()
    end

end

--==================================================
-- PAGE TITLE
--==================================================

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
-- HOME
--==================================================

showHome = function()

    clearContent()

    local help = createButton(
        Content,
        "HELP",
        UDim2.fromOffset(190, 48),
        UDim2.new(0.5, -195, 0.5, -24)
    )

    local cli = createButton(
        Content,
        "COMMAND LINE INTERFACE",
        UDim2.fromOffset(190, 48),
        UDim2.new(0.5, 5, 0.5, -24)
    )

    help.MouseButton1Click:Connect(function()
        showCategories()
    end)

    cli.MouseButton1Click:Connect(function()
        showCLI()
    end)

end

--==================================================
-- HELP / CATEGORIES
--==================================================

showCategories = function()

    clearContent()

    createTitle("HELP")

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -10, 0, 20)
    info.Position = UDim2.fromOffset(5, 30)
    info.BackgroundTransparency = 1
    info.Text = "Select a command category."
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

    local startY = 60

    for index, category in ipairs(categories) do

        local button = createButton(
            Content,
            category,
            UDim2.new(1, -10, 0, 38),
            UDim2.fromOffset(5, startY + ((index - 1) * 43))
        )

        button.MouseButton1Click:Connect(function()
            showCommands(category)
        end)

    end

    local back = createButton(
        Content,
        "< Back",
        UDim2.fromOffset(70, 30),
        UDim2.fromOffset(5, 252)
    )

    back.MouseButton1Click:Connect(function()
        showHome()
    end)

end

--==================================================
-- COMMANDS
--==================================================

showCommands = function(category)

    clearContent()

    local back = createButton(
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

    local search

    if category == "All Commands" then

        search = Instance.new("TextBox")
        search.Size = UDim2.new(1, -10, 0, 30)
        search.Position = UDim2.fromOffset(5, 36)
        search.BackgroundColor3 = CONFIG.Panel
        search.BorderSizePixel = 1
        search.BorderColor3 = CONFIG.Border
        search.Text = ""
        search.PlaceholderText = "Search commands..."
        search.PlaceholderColor3 = CONFIG.SubText
        search.TextColor3 = CONFIG.Text
        search.TextSize = 12
        search.Font = Enum.Font.Code
        search.ClearTextOnFocus = false
        search.TextXAlignment = Enum.TextXAlignment.Left
        search.Parent = Content

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 8)
        padding.Parent = search
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

        if search then
            query = search.Text:lower()
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

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, -5, 0, 48)
                button.BackgroundColor3 = CONFIG.Panel
                button.BorderSizePixel = 1
                button.BorderColor3 = CONFIG.Border
                button.Text = ""
                button.AutoButtonColor = false
                button.Parent = list

                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(1, -14, 0, 20)
                name.Position = UDim2.fromOffset(7, 3)
                name.BackgroundTransparency = 1
                name.Text = "/" .. command.Name
                name.TextColor3 = CONFIG.Accent
                name.TextSize = 13
                name.Font = Enum.Font.Code
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.Parent = button

                local description = Instance.new("TextLabel")
                description.Size = UDim2.new(1, -14, 0, 19)
                description.Position = UDim2.fromOffset(7, 24)
                description.BackgroundTransparency = 1
                description.Text = command.Description or ""
                description.TextColor3 = CONFIG.SubText
                description.TextSize = 11
                description.Font = Enum.Font.Code
                description.TextXAlignment = Enum.TextXAlignment.Left
                description.Parent = button

                button.MouseEnter:Connect(function()
                    button.BackgroundColor3 = CONFIG.PanelHover
                end)

                button.MouseLeave:Connect(function()
                    button.BackgroundColor3 = CONFIG.Panel
                end)

                button.MouseButton1Click:Connect(function()

                    if not command.Execute then
                        return
                    end

                    local success, result = pcall(function()
                        return command.Execute({})
                    end)

                    if not success then
                        warn(result)
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

    if search then
        search:GetPropertyChangedSignal("Text"):Connect(refresh)
    end

end

--==================================================
-- COMMAND LINE INTERFACE
--==================================================

showCLI = function()

    clearContent()

    local back = createButton(
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

    -- Console

    local console = Instance.new("ScrollingFrame")
    console.Size = UDim2.new(1, -10, 1, -102)
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
    end

    -- Input

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -90, 0, 38)
    input.Position = UDim2.new(0, 5, 1, -43)
    input.BackgroundColor3 = CONFIG.Panel
    input.BorderSizePixel = 1
    input.BorderColor3 = CONFIG.Border
    input.Text = ""
    input.PlaceholderText = "Enter command..."
    input.PlaceholderColor3 = CONFIG.SubText
    input.TextColor3 = CONFIG.Text
    input.TextSize = 12
    input.Font = Enum.Font.Code
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = Content

    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 8)
    input.Parent = Content
    inputPadding.Parent = input

    -- Execute

    local execute = createButton(
        Content,
        "EXECUTE",
        UDim2.fromOffset(80, 38),
        UDim2.new(1, -85, 1, -43)
    )

    local function executeCommand(text)

        if text == "" then
            return
        end

        printLine("> " .. text)

        local clean = text

        if clean:sub(1, 1) == "/" then
            clean = clean:sub(2)
        end

        local args = {}

        for value in clean:gmatch("%S+") do
            table.insert(args, value)
        end

        local commandName = args[1]

        if not commandName then
            return
        end

        table.remove(args, 1)

        local found

        for _, command in ipairs(Commands) do

            if command.Name:lower() == commandName:lower() then
                found = command
                break
            end

        end

        if not found then
            printLine("Unknown command: " .. commandName)
            return
        end

        if not found.Execute then
            printLine("Command has no implementation.")
            return
        end

        local success, result = pcall(function()
            return found.Execute(args)
        end)

        if not success then
            printLine("Error: " .. tostring(result))
        elseif result ~= nil then
            printLine(tostring(result))
        else
            printLine("Executed /" .. found.Name)
        end
    end

    execute.MouseButton1Click:Connect(function()

        local text = input.Text
        input.Text = ""

        executeCommand(text)

    end)

    input.FocusLost:Connect(function(enterPressed)

        if enterPressed then

            local text = input.Text
            input.Text = ""

            executeCommand(text)
        end

    end)

    printLine("IncognoL's Convenient Menu")
    printLine("Command Line Interface ready.")
    printLine("Type a command and press ENTER.")

end

--==================================================
-- START
--==================================================

showHome()

return {
    GUI = ScreenGui,
    Commands = Commands,
    ShowHome = showHome,
    ShowCategories = showCategories,
    ShowCLI = showCLI,
}
