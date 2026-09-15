--[[
    IncognoL's Convenient Menu
    Version: 1.0

    Roblox-style Luau GUI
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Menu = {}

Menu.Name = "IncognoL's Convenient Menu"
Menu.Version = "v1.0"

--==================================================
-- COMMAND DATABASE
--==================================================

Menu.Commands = {

    -- Example structure.
    -- Replace/add your actual commands here.

    {
        Name = "example",
        Description = "Example player command.",
        Category = "Player",
        Side = "Client-Sided",
    },

}

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IncognolsConvenientMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

Menu.GUI = ScreenGui

--==================================================
-- MAIN WINDOW
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(760, 500)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 52)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

-- Cover bottom corners of top bar
local TopBarBottom = Instance.new("Frame")
TopBarBottom.Size = UDim2.new(1, 0, 0, 8)
TopBarBottom.Position = UDim2.new(0, 0, 1, -8)
TopBarBottom.BackgroundColor3 = TopBar.BackgroundColor3
TopBarBottom.BorderSizePixel = 0
TopBarBottom.Parent = TopBar

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = Menu.Name
Title.TextColor3 = Color3.fromRGB(235, 235, 240)
Title.TextSize = 15
Title.Font = Enum.Font.GothamMedium
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

--==================================================
-- VERSION
--==================================================

local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Size = UDim2.fromOffset(45, 42)
Version.Position = UDim2.new(1, -92, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = Menu.Version
Version.TextColor3 = Color3.fromRGB(115, 115, 125)
Version.TextSize = 11
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.Parent = TopBar

--==================================================
-- CLOSE BUTTON
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.fromOffset(34, 34)
CloseButton.Position = UDim2.new(1, -40, 0, 4)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(170, 170, 175)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.Gotham
CloseButton.Parent = TopBar

CloseButton.MouseEnter:Connect(function()
    CloseButton.TextColor3 = Color3.fromRGB(255, 90, 90)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.TextColor3 = Color3.fromRGB(170, 170, 175)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 185, 1, -52)
Sidebar.Position = UDim2.fromOffset(8, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 6)
SidebarCorner.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 7)
SidebarPadding.PaddingRight = UDim.new(0, 7)
SidebarPadding.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 3)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -205, 1, -52)
Content.Position = UDim2.fromOffset(197, 48)
Content.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
Content.BorderSizePixel = 0
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = Content

--==================================================
-- PAGE DEFINITIONS
--==================================================

local PageNames = {
    "All Commands",
    "Player",
    "Client-Sided",
    "Server-Sided",
    "Command Line Interface",
}

Menu.Pages = {}
Menu.CurrentPage = nil

--==================================================
-- PAGE CREATION
--==================================================

local function createPage(name)

    local page = Instance.new("Frame")
    page.Name = name:gsub("%W", "")
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = Content

    Menu.Pages[name] = page

    return page
end

for _, name in ipairs(PageNames) do
    createPage(name)
end

--==================================================
-- PAGE HEADER
--==================================================

local function createHeader(parent, text)

    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, -24, 0, 35)
    header.Position = UDim2.fromOffset(12, 8)
    header.BackgroundTransparency = 1
    header.Text = text
    header.TextColor3 = Color3.fromRGB(240, 240, 245)
    header.TextSize = 16
    header.Font = Enum.Font.GothamMedium
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = parent

    return header
end

--==================================================
-- SIDEBAR BUTTON
--==================================================

local SidebarButtons = {}

local function updateSidebar()

    for name, button in pairs(SidebarButtons) do

        if name == Menu.CurrentPage then

            button.BackgroundColor3 = Color3.fromRGB(28, 55, 82)
            button.TextColor3 = Color3.fromRGB(80, 175, 255)

        else

            button.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
            button.TextColor3 = Color3.fromRGB(160, 160, 168)

        end

    end
end

local function switchPage(name)

    if not Menu.Pages[name] then
        return
    end

    Menu.CurrentPage = name

    for pageName, page in pairs(Menu.Pages) do
        page.Visible = pageName == name
    end

    updateSidebar()
end

for index, name in ipairs(PageNames) do

    local button = Instance.new("TextButton")
    button.Name = name:gsub("%W", "")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(160, 160, 168)
    button.TextSize = 13
    button.Font = Enum.Font.Gotham
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = index
    button.AutoButtonColor = false
    button.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 11)
    padding.Parent = button

    button.MouseEnter:Connect(function()

        if Menu.CurrentPage ~= name then
            button.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
        end

    end)

    button.MouseLeave:Connect(function()

        if Menu.CurrentPage ~= name then
            button.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
        end

    end)

    button.MouseButton1Click:Connect(function()
        switchPage(name)
    end)

    SidebarButtons[name] = button
end

--==================================================
-- COMMAND ENTRY
--==================================================

local function createCommandEntry(parent, command)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 62)
    button.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -20, 0, 24)
    name.Position = UDim2.fromOffset(10, 5)
    name.BackgroundTransparency = 1
    name.Text = "/" .. command.Name
    name.TextColor3 = Color3.fromRGB(80, 175, 255)
    name.TextSize = 14
    name.Font = Enum.Font.Code
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = button

    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -20, 0, 22)
    description.Position = UDim2.fromOffset(10, 30)
    description.BackgroundTransparency = 1
    description.Text = command.Description or "No description."
    description.TextColor3 = Color3.fromRGB(125, 125, 135)
    description.TextSize = 12
    description.Font = Enum.Font.Gotham
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    end)

    button.MouseButton1Click:Connect(function()

        if command.Execute then
            command.Execute()
        end

    end)

    return button
end

--==================================================
-- COMMAND PAGE
--==================================================

local function populateCommandPage(pageName)

    local page = Menu.Pages[pageName]

    if not page then
        return
    end

    createHeader(page, pageName)

    local list = Instance.new("ScrollingFrame")
    list.Name = "CommandList"
    list.Size = UDim2.new(1, -20, 1, -53)
    list.Position = UDim2.fromOffset(10, 45)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 80)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local shown = 0

    for _, command in ipairs(Menu.Commands) do

        local show = false

        if pageName == "All Commands" then

            show = true

        elseif pageName == "Player" then

            show = command.Category == "Player"

        elseif pageName == "Client-Sided" then

            show = command.Side == "Client-Sided"

        elseif pageName == "Server-Sided" then

            show = command.Side == "Server-Sided"

        end

        if show then

            createCommandEntry(list, command)
            shown += 1

        end
    end

    if shown == 0 then

        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, -20, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text = "No commands available."
        empty.TextColor3 = Color3.fromRGB(100, 100, 108)
        empty.TextSize = 13
        empty.Font = Enum.Font.Gotham
        empty.Parent = list
    end

    local function updateCanvas()
        list.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    updateCanvas()
end

populateCommandPage("All Commands")
populateCommandPage("Player")
populateCommandPage("Client-Sided")
populateCommandPage("Server-Sided")

--==================================================
-- COMMAND LINE INTERFACE
--==================================================

do

    local page = Menu.Pages["Command Line Interface"]

    createHeader(page, "Command Line Interface")

    -- Output console

    local console = Instance.new("ScrollingFrame")
    console.Name = "Console"
    console.Size = UDim2.new(1, -20, 1, -115)
    console.Position = UDim2.fromOffset(10, 45)
    console.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    console.BorderSizePixel = 0
    console.ScrollBarThickness = 3
    console.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 75)
    console.CanvasSize = UDim2.new(0, 0, 0, 0)
    console.Parent = page

    local consoleCorner = Instance.new("UICorner")
    consoleCorner.CornerRadius = UDim.new(0, 6)
    consoleCorner.Parent = console

    local consolePadding = Instance.new("UIPadding")
    consolePadding.PaddingTop = UDim.new(0, 8)
    consolePadding.PaddingLeft = UDim.new(0, 10)
    consolePadding.PaddingRight = UDim.new(0, 10)
    consolePadding.Parent = console

    local consoleLayout = Instance.new("UIListLayout")
    consoleLayout.Padding = UDim.new(0, 2)
    consoleLayout.Parent = console

    -- Input

    local input = Instance.new("TextBox")
    input.Name = "CommandInput"
    input.Size = UDim2.new(1, -90, 0, 45)
    input.Position = UDim2.new(0, 10, 1, -55)
    input.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = "Enter a command..."
    input.PlaceholderColor3 = Color3.fromRGB(85, 85, 95)
    input.TextColor3 = Color3.fromRGB(225, 225, 230)
    input.TextSize = 13
    input.Font = Enum.Font.Code
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = page

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = input

    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 10)
    inputPadding.PaddingRight = UDim.new(0, 10)
    inputPadding.Parent = input

    -- Execute button

    local execute = Instance.new("TextButton")
    execute.Name = "Execute"
    execute.Size = UDim2.fromOffset(72, 45)
    execute.Position = UDim2.new(1, -82, 1, -55)
    execute.BackgroundColor3 = Color3.fromRGB(25, 70, 105)
    execute.BorderSizePixel = 0
    execute.Text = "Execute"
    execute.TextColor3 = Color3.fromRGB(220, 235, 245)
    execute.TextSize = 12
    execute.Font = Enum.Font.GothamMedium
    execute.AutoButtonColor = false
    execute.Parent = page

    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 6)
    executeCorner.Parent = execute

    -- Console printer

    local function printConsole(message)

        local line = Instance.new("TextLabel")
        line.Size = UDim2.new(1, 0, 0, 20)
        line.BackgroundTransparency = 1
        line.Text = tostring(message)
        line.TextColor3 = Color3.fromRGB(170, 170, 180)
        line.TextSize = 12
        line.Font = Enum.Font.Code
        line.TextXAlignment = Enum.TextXAlignment.Left
        line.TextWrapped = false
        line.Parent = console

        task.defer(function()
            console.CanvasPosition = Vector2.new(
                0,
                math.max(0, console.AbsoluteCanvasSize.Y)
            )
        end)

        return line
    end

    Menu.Print = printConsole

    -- Command lookup

    local function findCommand(commandName)

        commandName = commandName:lower()

        for _, command in ipairs(Menu.Commands) do

            if command.Name:lower() == commandName then
                return command
            end

        end

        return nil
    end

    -- Command execution

    function Menu.Execute(commandText)

        commandText = tostring(commandText)

        if commandText == "" then
            return
        end

        printConsole("> " .. commandText)

        -- Remove leading slash if present

        local clean = commandText

        if clean:sub(1, 1) == "/" then
            clean = clean:sub(2)
        end

        -- Split arguments

        local arguments = {}

        for argument in clean:gmatch("%S+") do
            table.insert(arguments, argument)
        end

        local commandName = arguments[1]

        if not commandName then
            return
        end

        table.remove(arguments, 1)

        local command = findCommand(commandName)

        if not command then

            printConsole(
                "<font color=\"#ff6b6b\">Unknown command:</font> "
                .. commandName
            )

            return
        end

        printConsole(
            "[Command] Executing /" .. command.Name
        )

        if command.Execute then

            local success, result = pcall(function()
                return command.Execute(arguments)
            end)

            if not success then
                printConsole("[Error] " .. tostring(result))
            elseif result ~= nil then
                printConsole(tostring(result))
            end

        else

            printConsole(
                "[Info] /" .. command.Name
                .. " has no implementation yet."
            )

        end
    end

    local function executeInput()

        local text = input.Text

        if text == "" then
            return
        end

        input.Text = ""
        Menu.Execute(text)
    end

    execute.MouseButton1Click:Connect(executeInput)

    input.FocusLost:Connect(function(enterPressed)

        if enterPressed then
            executeInput()
        end

    end)

    -- Initial console

    printConsole("IncognoL's Convenient Menu")
    printConsole("Command Line Interface ready.")
    printConsole("Type /help or enter a command.")

end

--==================================================
-- INITIAL PAGE
--==================================================

switchPage("All Commands")

--==================================================
-- RETURN
--==================================================

return Menu
