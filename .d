--[[
    IncognoL's Convenient Menu
    v1.0
    Square / old-school utility style
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    Name = "IncognoL's Convenient Menu",
    Version = "v1.0",

    MainSize = UDim2.fromOffset(700, 420),

    Background = Color3.fromRGB(12, 12, 12),
    Panel = Color3.fromRGB(17, 17, 17),
    Panel2 = Color3.fromRGB(21, 21, 21),

    Border = Color3.fromRGB(52, 52, 52),
    BorderLight = Color3.fromRGB(70, 70, 70),

    Text = Color3.fromRGB(220, 220, 220),
    SubText = Color3.fromRGB(145, 145, 145),

    Hover = Color3.fromRGB(28, 28, 28),
    Selected = Color3.fromRGB(34, 34, 34),

    Accent = Color3.fromRGB(110, 170, 255),
}

--==================================================
-- COMMAND DATABASE
--==================================================

-- Add your real commands here.
--
-- Category:
--     Player
--     Client-Sided
--     Server-Sided
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
            print("Example command executed", args)
        end,
    },

    -- Add commands below.

}

--==================================================
-- SCREEN GUI
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
Main.Size = CONFIG.MainSize
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
TopBar.Size = UDim2.new(1, 0, 0, 34)
TopBar.BackgroundColor3 = CONFIG.Panel
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 1)
TopLine.Position = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = CONFIG.BorderLight
TopLine.BorderSizePixel = 0
TopLine.Parent = TopBar

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
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
Version.Size = UDim2.fromOffset(40, 34)
Version.Position = UDim2.new(1, -76, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = CONFIG.Version
Version.TextColor3 = CONFIG.SubText
Version.TextSize = 11
Version.Font = Enum.Font.Code
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.Parent = TopBar

--==================================================
-- CLOSE
--==================================================

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.fromOffset(28, 28)
Close.Position = UDim2.new(1, -32, 0, 3)
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
    Close.TextColor3 = Color3.fromRGB(255, 120, 120)
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
-- CONTENT CONTAINER
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -47)
Content.Position = UDim2.fromOffset(10, 42)
Content.BackgroundTransparency = 1
Content.Parent = Main

--==================================================
-- PAGE MANAGEMENT
--==================================================

local CurrentPage = nil

local function clearContent()

    for _, child in ipairs(Content:GetChildren()) do
        child:Destroy()
    end

end

--==================================================
-- GENERIC BUTTON
--==================================================

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

        button.BackgroundColor3 = CONFIG.Hover
        button.BorderColor3 = CONFIG.BorderLight

    end)

    button.MouseLeave:Connect(function()

        button.BackgroundColor3 = CONFIG.Panel
        button.BorderColor3 = CONFIG.Border

    end)

    return button
end

--==================================================
-- PAGE TITLE
--==================================================

local function makePageTitle(parent, text)

    local title = Instance.new("TextLabel")

    title.Size = UDim2.new(1, -10, 0, 25)
    title.Position = UDim2.fromOffset(5, 2)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = CONFIG.Text
    title.TextSize = 14
    title.Font = Enum.Font.Code
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = parent

    return title
end

--==================================================
-- HOME
--==================================================

local function showHome()

    clearContent()
    CurrentPage = "Home"

    local center = Instance.new("Frame")
    center.Size = UDim2.fromScale(1, 1)
    center.BackgroundTransparency = 1
    center.Parent = Content

    local help = makeButton(
        center,
        "HELP",
        UDim2.fromOffset(180, 45),
        UDim2.fromScale(0.5, 0.5)
    )

    help.AnchorPoint = Vector2.new(0.5, 0.5)
    help.MouseButton1Click:Connect(function()
        showCategories()
    end)

end

--==================================================
-- CATEGORY SELECTOR
--==================================================

function showCategories()

    clearContent()
    CurrentPage = "Categories"

    makePageTitle(Content, "HELP")

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -10, 0, 22)
    info.Position = UDim2.fromOffset(5, 28)
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
        "Command Line Interface",
    }

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, -10, 1, -90)
    list.Position = UDim2.fromOffset(5, 58)
    list.BackgroundTransparency = 1
    list.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    for _, category in ipairs(categories) do

        local button = makeButton(
            list,
            category,
            UDim2.new(1, 0, 0, 38),
            UDim2.new()
        )

        button.MouseButton1Click:Connect(function()

            if category == "Command Line Interface" then
                showCLI()
            else
                showCommands(category)
            end

        end)

    end

end

--==================================================
-- COMMAND PAGE
--==================================================

function showCommands(category)

    clearContent()
    CurrentPage = category

    local back = makeButton(
        Content,
        "< Back",
        UDim2.fromOffset(70, 25),
        UDim2.fromOffset(5, 2)
    )

    back.MouseButton1Click:Connect(function()
        showCategories()
    end)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 0, 25)
    title.Position = UDim2.fromOffset(85, 2)
    title.BackgroundTransparency = 1
    title.Text = category
    title.TextColor3 = CONFIG.Text
    title.TextSize = 14
    title.Font = Enum.Font.Code
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = Content

    -- Search is only useful on All Commands
    local searchBox

    if category == "All Commands" then

        searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -10, 0, 30)
        searchBox.Position = UDim2.fromOffset(5, 35)
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

    local list = Instance.new("ScrollingFrame")
    list.Name = "Commands"
    list.Size = UDim2.new(
        1,
        -10,
        1,
        category == "All Commands" and -75 or -45
    )
    list.Position = UDim2.fromOffset(
        5,
        category == "All Commands" and 70 or 35
    )
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = CONFIG.BorderLight
    list.CanvasSize = UDim2.new()
    list.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local function refreshCommands()

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

                local commandButton = Instance.new("TextButton")

                commandButton.Size = UDim2.new(1, -5, 0, 48)
                commandButton.BackgroundColor3 = CONFIG.Panel
                commandButton.BorderSizePixel = 1
                commandButton.BorderColor3 = CONFIG.Border
                commandButton.Text = ""
                commandButton.AutoButtonColor = false
                commandButton.Parent = list

                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(1, -15, 0, 20)
                name.Position = UDim2.fromOffset(7, 3)
                name.BackgroundTransparency = 1
                name.Text = "/" .. command.Name
                name.TextColor3 = CONFIG.Accent
                name.TextSize = 13
                name.Font = Enum.Font.Code
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.Parent = commandButton

                local description = Instance.new("TextLabel")
                description.Size = UDim2.new(1, -15, 0, 20)
                description.Position = UDim2.fromOffset(7, 23)
                description.BackgroundTransparency = 1
                description.Text = command.Description or ""
                description.TextColor3 = CONFIG.SubText
                description.TextSize = 11
                description.Font = Enum.Font.Code
                description.TextXAlignment = Enum.TextXAlignment.Left
                description.Parent = commandButton

                commandButton.MouseEnter:Connect(function()
                    commandButton.BackgroundColor3 = CONFIG.Hover
                end)

                commandButton.MouseLeave:Connect(function()
                    commandButton.BackgroundColor3 = CONFIG.Panel
                end)

                commandButton.MouseButton1Click:Connect(function()

                    if command.Execute then

                        local success, result = pcall(function()
                            return command.Execute({})
                        end)

                        if not success then
                            warn(result)
                        end

                    end

                end)

            end

        end

        if shown == 0 then

            local empty = Instance.new("TextLabel")

            empty.Size = UDim2.new(1, -5, 0, 30)
            empty.BackgroundTransparency = 1
            empty.Text = "No commands found."
            empty.TextColor3 = CONFIG.SubText
            empty.TextSize = 12
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

    refreshCommands()

    if searchBox then

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            refreshCommands()
        end)

    end

end

--==================================================
-- COMMAND LINE INTERFACE
--==================================================

function showCLI()

    clearContent()
    CurrentPage = "Command Line Interface"

    local back = makeButton(
        Content,
        "< Back",
        UDim2.fromOffset(70, 25),
        UDim2.fromOffset(5, 2)
    )

    back.MouseButton1Click:Connect(function()
        showCategories()
    end)

    makePageTitle(Content, "Command Line Interface")

    local console = Instance.new("ScrollingFrame")
    console.Name = "Console"
    console.Size = UDim2.new(1, -10, 1, -105)
    console.Position = UDim2.fromOffset(5, 35)
    console.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
    console.BorderSizePixel = 1
    console.BorderColor3 = CONFIG.Border
    console.ScrollBarThickness = 3
    console.ScrollBarImageColor3 = CONFIG.BorderLight
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

        line.Size = UDim2.new(1, -10, 0, 18)
        line.BackgroundTransparency = 1
        line.Text = tostring(text)
        line.TextColor3 = CONFIG.SubText
        line.TextSize = 11
        line.Font = Enum.Font.Code
        line.TextXAlignment = Enum.TextXAlignment.Left
        line.Parent = console

        task.defer(function()
            console.CanvasPosition = Vector2.new(
                0,
                math.max(0, console.AbsoluteCanvasSize.Y)
            )
        end)

    end

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -85, 0, 38)
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
    inputPadding.Parent = input

    local execute = makeButton(
        Content,
        "EXECUTE",
        UDim2.fromOffset(75, 38),
        UDim2.new(1, -80, 1, -43)
    )

    local function executeCommand(text)

        text = tostring(text)

        if text == "" then
            return
        end

        printLine("> " .. text)

        local clean = text

        if clean:sub(1, 1) == "/" then
            clean = clean:sub(2)
        end

        local arguments = {}

        for value in clean:gmatch("%S+") do
            table.insert(arguments, value)
        end

        local commandName = arguments[1]

        if not commandName then
            return
        end

        table.remove(arguments, 1)

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
            return found.Execute(arguments)
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
    printLine("Command Line Interface")
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
}
