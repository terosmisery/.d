-- IncognoL's Convenient Menu
-- Luau
-- v1.0

local Menu = {}

Menu.Name = "IncognoL's Convenient Menu"
Menu.Version = "v1.0"

-- =========================================================
-- COMMAND DEFINITIONS
-- =========================================================

local Commands = {

    -- Player
    {
        Name = "teleport",
        Description = "Teleport to a player.",
        Category = "Player",
        Side = "Server-Sided"
    },

    {
        Name = "bring",
        Description = "Bring a player to you.",
        Category = "Player",
        Side = "Server-Sided"
    },

    {
        Name = "kill",
        Description = "Kill a player.",
        Category = "Player",
        Side = "Server-Sided"
    },

    -- Client-Sided
    {
        Name = "rejoin",
        Description = "Reconnect to the current game.",
        Category = "Player",
        Side = "Client-Sided"
    },

    -- Server-Sided
    {
        Name = "shutdown",
        Description = "Shut down the current server.",
        Category = "Server",
        Side = "Server-Sided"
    },

}

-- =========================================================
-- GUI
-- =========================================================

local gui = {}

gui.Pages = {
    "All Commands",
    "Player",
    "Client-Sided",
    "Server-Sided",
    "Command Line Interface"
}

gui.CurrentPage = "All Commands"

-- =========================================================
-- BASIC GUI CREATION
-- =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IncognolsConvenientMenu"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(760, 500)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Main.BorderSizePixel = 1
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 4)
MainCorner.Parent = Main

-- =========================================================
-- TITLE BAR
-- =========================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = Menu.Name
Title.TextColor3 = Color3.fromRGB(45, 155, 255)
Title.TextSize = 16
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Size = UDim2.fromOffset(60, 35)
Version.Position = UDim2.new(1, -70, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = Menu.Version
Version.TextColor3 = Color3.fromRGB(130, 130, 130)
Version.TextSize = 13
Version.Font = Enum.Font.Code
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.Parent = Main

-- =========================================================
-- SIDEBAR
-- =========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, -50)
Sidebar.Position = UDim2.fromOffset(10, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
Sidebar.BorderSizePixel = 1
Sidebar.Parent = Main

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 2)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

-- =========================================================
-- CONTENT
-- =========================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -205, 1, -50)
Content.Position = UDim2.fromOffset(195, 40)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- =========================================================
-- PAGE SYSTEM
-- =========================================================

local Pages = {}

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name:gsub("%s+", "")
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = Content

    Pages[name] = page

    return page
end

for _, pageName in ipairs(gui.Pages) do
    createPage(pageName)
end

-- =========================================================
-- SIDEBAR BUTTONS
-- =========================================================

local function setPage(pageName)

    gui.CurrentPage = pageName

    for name, page in pairs(Pages) do
        page.Visible = name == pageName
    end

    for _, child in ipairs(Sidebar:GetChildren()) do
        if child:IsA("TextButton") then

            if child.Name == pageName:gsub("%s+", "") then
                child.TextColor3 = Color3.fromRGB(45, 155, 255)
                child.BackgroundColor3 = Color3.fromRGB(10, 25, 38)
            else
                child.TextColor3 = Color3.fromRGB(175, 175, 175)
                child.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
            end

        end
    end

end

for index, pageName in ipairs(gui.Pages) do

    local button = Instance.new("TextButton")
    button.Name = pageName:gsub("%s+", "")
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    button.BorderSizePixel = 0
    button.Text = pageName
    button.TextColor3 = Color3.fromRGB(175, 175, 175)
    button.TextSize = 14
    button.Font = Enum.Font.Code
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = index
    button.Parent = Sidebar

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = button

    button.MouseButton1Click:Connect(function()
        setPage(pageName)
    end)

end

-- =========================================================
-- COMMAND DISPLAY
-- =========================================================

local function createCommandEntry(parent, command)

    local entry = Instance.new("TextButton")
    entry.Size = UDim2.new(1, -10, 0, 55)
    entry.BackgroundColor3 = Color3.fromRGB(7, 7, 9)
    entry.BorderSizePixel = 1
    entry.BorderColor3 = Color3.fromRGB(25, 25, 30)
    entry.Text = ""
    entry.Parent = parent

    local commandName = Instance.new("TextLabel")
    commandName.Size = UDim2.new(1, -20, 0, 22)
    commandName.Position = UDim2.fromOffset(10, 4)
    commandName.BackgroundTransparency = 1
    commandName.Text = "/" .. command.Name
    commandName.TextColor3 = Color3.fromRGB(45, 155, 255)
    commandName.TextSize = 14
    commandName.Font = Enum.Font.Code
    commandName.TextXAlignment = Enum.TextXAlignment.Left
    commandName.Parent = entry

    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -20, 0, 20)
    description.Position = UDim2.fromOffset(10, 27)
    description.BackgroundTransparency = 1
    description.Text = command.Description
    description.TextColor3 = Color3.fromRGB(125, 125, 125)
    description.TextSize = 12
    description.Font = Enum.Font.Code
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.Parent = entry

    return entry
end

local function populateCommands(pageName)

    local page = Pages[pageName]

    if not page then
        return
    end

    for _, child in ipairs(page:GetChildren()) do
        child:Destroy()
    end

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.fromScale(1, 1)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll

    for _, command in ipairs(Commands) do

        local include = false

        if pageName == "All Commands" then
            include = true

        elseif pageName == "Player" then
            include = command.Category == "Player"

        elseif pageName == "Client-Sided" then
            include = command.Side == "Client-Sided"

        elseif pageName == "Server-Sided" then
            include = command.Side == "Server-Sided"
        end

        if include then
            createCommandEntry(scroll, command)
        end

    end

end

populateCommands("All Commands")
populateCommands("Player")
populateCommands("Client-Sided")
populateCommands("Server-Sided")

-- =========================================================
-- COMMAND LINE INTERFACE
-- =========================================================

do

    local page = Pages["Command Line Interface"]

    local output = Instance.new("ScrollingFrame")
    output.Name = "Output"
    output.Size = UDim2.new(1, 0, 1, -60)
    output.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
    output.BorderSizePixel = 1
    output.ScrollBarThickness = 4
    output.Parent = page

    local outputLayout = Instance.new("UIListLayout")
    outputLayout.Padding = UDim.new(0, 2)
    outputLayout.Parent = output

    local input = Instance.new("TextBox")
    input.Name = "CommandInput"
    input.Size = UDim2.new(1, -85, 0, 45)
    input.Position = UDim2.new(0, 0, 1, -45)
    input.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
    input.BorderSizePixel = 1
    input.Text = ""
    input.PlaceholderText = "Enter command..."
    input.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
    input.TextColor3 = Color3.fromRGB(220, 220, 220)
    input.TextSize = 14
    input.Font = Enum.Font.Code
    input.ClearTextOnFocus = false
    input.Parent = page

    local execute = Instance.new("TextButton")
    execute.Name = "Execute"
    execute.Size = UDim2.fromOffset(75, 45)
    execute.Position = UDim2.new(1, -75, 1, -45)
    execute.BackgroundColor3 = Color3.fromRGB(10, 30, 48)
    execute.BorderSizePixel = 1
    execute.Text = "Execute"
    execute.TextColor3 = Color3.fromRGB(45, 155, 255)
    execute.TextSize = 13
    execute.Font = Enum.Font.Code
    execute.Parent = page

    local function printCLI(text)

        local line = Instance.new("TextLabel")
        line.Size = UDim2.new(1, -10, 0, 20)
        line.BackgroundTransparency = 1
        line.Text = text
        line.TextColor3 = Color3.fromRGB(170, 170, 170)
        line.TextSize = 13
        line.Font = Enum.Font.Code
        line.TextXAlignment = Enum.TextXAlignment.Left
        line.Parent = output

    end

    local function executeCommand(text)

        text = text:match("^%s*(.-)%s*$")

        if text == "" then
            return
        end

        printCLI("> " .. text)

        local commandName = text:match("^/?([^%s]+)")

        for _, command in ipairs(Commands) do

            if command.Name:lower() == commandName:lower() then

                printCLI("[+] Executing /" .. command.Name)

                -- Actual command implementation goes here.
                -- We will replace this when you give me the real commands.

                return
            end

        end

        printCLI("[-] Unknown command: " .. tostring(commandName))

    end

    execute.MouseButton1Click:Connect(function()

        executeCommand(input.Text)
        input.Text = ""

    end)

    input.FocusLost:Connect(function(enterPressed)

        if enterPressed then
            executeCommand(input.Text)
            input.Text = ""
        end

    end)

    printCLI("IncognoL's Convenient Menu")
    printCLI("Command Line Interface ready.")
    printCLI("Type a command to begin.")

end

-- =========================================================
-- INITIAL PAGE
-- =========================================================

setPage("All Commands")

-- =========================================================
-- RETURN MENU
-- =========================================================

Menu.GUI = ScreenGui
Menu.Pages = Pages
Menu.Commands = Commands

return Menu
