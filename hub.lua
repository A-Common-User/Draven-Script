-- ================== Draven Hub FINAL ==================
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

pcall(function()
    player.PlayerGui.SimpleHub:Destroy()
end)

-- ================== GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- ================== MAIN FRAME ==================
local frame = Instance.new("Frame", gui)
frame.Size = isMobile and UDim2.new(0,260,0,360) or UDim2.new(0,340,0,460)
frame.Position = UDim2.new(0.5,-frame.Size.X.Offset/2,0.5,-frame.Size.Y.Offset/2)
frame.BackgroundColor3 = Color3.fromRGB(38,38,65)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(90,90,140)
stroke.Thickness = 2

-- ================== TITLE ==================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-90,0,45)
title.Position = UDim2.new(0,15,0,5)
title.BackgroundTransparency = 1
title.Text = "Draven's Script Storage"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- ================== CLOSE BUTTON ==================
local close = Instance.new("TextButton", frame)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-40,0,8)
close.BackgroundColor3 = Color3.fromRGB(90,40,40)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ================== TAB BAR (SCROLL) ==================
local tabScroll = Instance.new("ScrollingFrame", frame)
tabScroll.Size = UDim2.new(1,-20,0,38)
tabScroll.Position = UDim2.new(0,10,0,55)
tabScroll.CanvasSize = UDim2.new(0,0,0,0)
tabScroll.ScrollBarThickness = 4
tabScroll.BackgroundTransparency = 1
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X

local tabLayout = Instance.new("UIListLayout", tabScroll)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,8)

-- ================== SEARCH ==================
local search = Instance.new("TextBox", frame)
search.PlaceholderText = "Search..."
search.Size = UDim2.new(1,-20,0,32)
search.Position = UDim2.new(0,10,0,98)
search.Text = ""
search.ClearTextOnFocus = false
search.Font = Enum.Font.Gotham
search.TextScaled = true
search.TextColor3 = Color3.new(1,1,1)
search.BackgroundColor3 = Color3.fromRGB(30,30,55)
Instance.new("UICorner", search)

-- ================== PAGES ==================
local pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", frame)
    page.Name = name
    page.Position = UDim2.new(0,0,0,140)
    page.Size = UDim2.new(1,0,1,-140)
    page.ScrollBarThickness = 6
    page.Visible = false
    page.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
    end)

    pages[name] = page
    return page
end

local currentTab
local function switchTab(name)
    for n,p in pairs(pages) do
        p.Visible = (n == name)
    end
    currentTab = name
    search.Text = ""
end

local function createTab(name)
    local b = Instance.new("TextButton", tabScroll)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Size = UDim2.new(0,95,1,0)
    b.BackgroundColor3 = Color3.fromRGB(70,60,120)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ================== BUTTON FX ==================
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9118828561"
clickSound.Volume = 0.5
clickSound.Parent = SoundService

local function ripple(btn, x, y)
    local r = Instance.new("Frame", btn)
    r.BackgroundColor3 = Color3.fromRGB(255,255,255)
    r.BackgroundTransparency = 0.7
    r.Size = UDim2.new(0,0,0,0)
    r.Position = UDim2.new(0,x,0,y)
    Instance.new("UICorner", r).CornerRadius = UDim.new(1,0)

    TweenService:Create(r, TweenInfo.new(0.4), {
        Size = UDim2.new(0,300,0,300),
        Position = UDim2.new(0,x-150,0,y-150),
        BackgroundTransparency = 1
    }):Play()

    task.delay(0.4, function()
        r:Destroy()
    end)
end

-- ================== CREATE BUTTON ==================
local function createButton(page, text, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0.9,0,0,50)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(55,55,90)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function(x,y)
        clickSound:Play()
        ripple(btn, btn.AbsoluteSize.X/2, btn.AbsoluteSize.Y/2)

        btn:TweenSize(UDim2.new(0.88,0,0,46),"Out","Back",0.12,true)
        task.wait(0.12)
        btn:TweenSize(UDim2.new(0.9,0,0,50),"Out","Back",0.15,true)

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
createTab("Other")

local Universal = createPage("Universal")
local TSB = createPage("TSB")
local Night99 = createPage("Night99")
local Other = createPage("Other")

switchTab("Universal")

-- ================== YOUR BUTTONS (UNTOUCHED) ==================
createButton(Universal,"Fly Script",function()
	loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)

createButton(Universal,"Jerk off R6",function()
	loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
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

createButton(TSB,"TSB Sukuna", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/damir512/whendoesbrickdie/main/tspno.txt",true))()
end)

createButton(TSB,"TSB Trashcan", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan%20Man", true))()
end)
-- ================== END ==================
