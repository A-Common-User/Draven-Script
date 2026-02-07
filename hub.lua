local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ================= Cleanup =================
pcall(function()
    player.PlayerGui.SimpleHub:Destroy()
end)

-- ================= Save State =================
local minimized = false

-- ================= ScreenGui =================
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- ================= Main Frame =================
local frame = Instance.new("Frame", gui)
frame.Size = isMobile and UDim2.new(0,270,0,380) or UDim2.new(0,360,0,480)
frame.Position = UDim2.new(0.5,-frame.Size.X.Offset/2,0.5,-frame.Size.Y.Offset/2)
frame.BackgroundColor3 = Color3.fromRGB(25,20,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- Gradient
local bgGrad = Instance.new("UIGradient", frame)
bgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,30,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,30))
}

-- ================= Title =================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-90,0,45)
title.Position = UDim2.new(0,12,0,6)
title.BackgroundTransparency = 1
title.Text = "Draven's Script Storage"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Left
title.TextColor3 = Color3.new(1,1,1)

-- ================= Close Button =================
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,32,0,32)
close.Position = UDim2.new(1,-40,0,10)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.TextColor3 = Color3.fromRGB(255,90,90)
close.BackgroundColor3 = Color3.fromRGB(30,20,25)
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ================= Minimize =================
local mini = Instance.new("TextButton", frame)
mini.Size = UDim2.new(0,32,0,32)
mini.Position = UDim2.new(1,-80,0,10)
mini.Text = "—"
mini.Font = Enum.Font.GothamBold
mini.TextScaled = true
mini.TextColor3 = Color3.new(1,1,1)
mini.BackgroundColor3 = Color3.fromRGB(30,20,25)
Instance.new("UICorner", mini)

-- ================= Floating Icon =================
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0,20,0.5,-25)
icon.Text = "D"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.fromRGB(120,30,40)
icon.Visible = false
icon.Active = true
icon.Draggable = true
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

mini.MouseButton1Click:Connect(function()
    frame.Visible = false
    icon.Visible = true
    minimized = true
end)

icon.MouseButton1Click:Connect(function()
    frame.Visible = true
    icon.Visible = false
    minimized = false
end)

-- ================= Tabs Scroll =================
local tabScroll = Instance.new("ScrollingFrame", frame)
tabScroll.Size = UDim2.new(1,-20,0,36)
tabScroll.Position = UDim2.new(0,10,0,55)
tabScroll.CanvasSize = UDim2.new()
tabScroll.ScrollBarThickness = 0
tabScroll.BackgroundTransparency = 1
tabScroll.AutomaticCanvasSize = X

local tabLayout = Instance.new("UIListLayout", tabScroll)
tabLayout.FillDirection = Horizontal
tabLayout.Padding = UDim.new(0,8)

-- ================= Search =================
local search = Instance.new("TextBox", frame)
search.PlaceholderText = "Search..."
search.Size = UDim2.new(1,-20,0,32)
search.Position = UDim2.new(0,10,0,98)
search.Font = Enum.Font.Gotham
search.TextScaled = true
search.TextColor3 = Color3.new(1,1,1)
search.BackgroundColor3 = Color3.fromRGB(30,20,25)
search.ClearTextOnFocus = false
Instance.new("UICorner", search)

-- ================= Pages =================
local pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", frame)
    page.Position = UDim2.new(0,0,0,140)
    page.Size = UDim2.new(1,0,1,-140)
    page.CanvasSize = UDim2.new()
    page.ScrollBarThickness = 4
    page.Visible = false
    page.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,10)
    layout.HorizontalAlignment = Center
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)

    pages[name] = page
    return page
end

local function switchTab(name)
    for n,p in pairs(pages) do
        p.Visible = (n == name)
    end
    search.Text = ""
end

local function createTab(name)
    local b = Instance.new("TextButton", tabScroll)
    b.Size = UDim2.new(0,90,1,0)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,25,35)
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ================= Button FX =================
local function ripple(btn)
    local c = Instance.new("Frame", btn)
    c.Size = UDim2.new(0,0,0,0)
    c.Position = UDim2.new(0.5,0,0.5,0)
    c.AnchorPoint = Vector2.new(0.5,0.5)
    c.BackgroundColor3 = Color3.new(1,1,1)
    c.BackgroundTransparency = 0.6
    Instance.new("UICorner", c).CornerRadius = UDim.new(1,0)

    TweenService:Create(c, TweenInfo.new(0.4), {
        Size = UDim2.new(1.5,0,3,0),
        BackgroundTransparency = 1
    }):Play()

    task.delay(0.4, function()
        c:Destroy()
    end)
end

-- ================= Create Button =================
local function createButton(page, text, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0.92,0,0,50)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50,25,35)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        ripple(btn)
        callback()
    end)

    search:GetPropertyChangedSignal("Text"):Connect(function()
        btn.Visible = btn.Text:lower():find(search.Text:lower(),1,true) ~= nil
    end)
end

-- ================== TABS / PAGES ==================
createTab("Universal")
createTab("TSB")
createTab("Night99")
createTab("Aotr")
createTab("Demonology")
createTab("Other")

local Universal = createPage("Universal")
local TSB = createPage("TSB")
local Night99 = createPage("Night99")
local Aotr = createPage("Aotr")
local Demonology = createPage("Demonology")
local Other = createPage("Other")

switchTab("Universal")

-- ================== YOUR BUTTONS (UNTOUCHED) ==================
createButton(Universal,"Fly Script",function()
	loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)

createButton(Universal,"Jerk off R6",function()
	loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
end)

createButton(Aotr,"TekkitAotr",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/zerunquist/TekkitAotr/refs/heads/main/main"))()
end)

createButton(Demonology,"Demon UI",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RelkzzRebranded/THEGHOSTISAMOLESTER/refs/heads/main/script.lua"))()
end)

createButton(Demonology,"Demon Detect",function()
	loadstring(game:HttpGet("https://pastebin.com/raw/87GTQwtw"))()
end)

createButton(Universal,"Jerk off R15",function()
	loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end)

createButton(Universal,"Ghostplayer",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/A-Common-User/Draven-Script/main/ghostplayer.lua"))()
end)

createButton(Night99,"VapeVoidware",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua"))()
end)

createButton(Other,"The Lost Front",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/TheLostFront.lua"))()
end)

createButton(TSB,"Phantasm",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ATrainz/Phantasm/main/Games/TSB.lua"))()
end)

createButton(TSB,"Hub",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/A-Common-User/Draven-Script/main/TSB%20Hub.lua"))()
end)

createButton(TSB,"Trashcan", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan%20Man", true))()
end)
-- ================== END ==================
