local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ========= 基础 =========
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
getgenv().HubMinimized = getgenv().HubMinimized or false

pcall(function()
	player.PlayerGui.SimpleHub:Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ========= 主窗口 =========
local frame = Instance.new("Frame", gui)
frame.Size = isMobile and UDim2.new(0,260,0,360) or UDim2.new(0,330,0,450)
frame.Position = UDim2.new(0.5,-frame.Size.X.Offset/2,0.5,-frame.Size.Y.Offset/2)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(60,60,60)
stroke.Thickness = 2

local bgGrad = Instance.new("UIGradient", frame)
bgGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,70)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70,45,100))
}

-- ========= 标题 =========
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "Draven's Script Storage"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local tGrad = Instance.new("UIGradient", title)
tGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,180,180)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,255))
}

task.spawn(function()
	while gui.Parent do
		for i=0,1,0.01 do
			tGrad.Offset = Vector2.new(i,0)
			task.wait(0.02)
		end
	end
end)

-- ========= Tabs =========
local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(1,-20,0,35)
tabBar.Position = UDim2.new(0,10,0,50)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,6)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ========= 搜索栏 =========
local search = Instance.new("TextBox", frame)
search.PlaceholderText = "Search..."
search.Size = UDim2.new(1,-20,0,32)
search.Position = UDim2.new(0,10,0,90)
search.Text = ""
search.ClearTextOnFocus = false
search.Font = Enum.Font.Gotham
search.TextScaled = true
search.TextColor3 = Color3.new(1,1,1)
search.BackgroundColor3 = Color3.fromRGB(35,35,60)
Instance.new("UICorner", search).CornerRadius = UDim.new(0,10)

-- ========= 内容区域 =========
local pages = {}

local function createPage(name)
	local page = Instance.new("ScrollingFrame", frame)
	page.Name = name
	page.Position = UDim2.new(0,0,0,130)
	page.Size = UDim2.new(1,0,1,-130)
	page.CanvasSize = UDim2.new(0,0,0,0)
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
	local b = Instance.new("TextButton", tabBar)
	b.Text = name
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.Size = UDim2.new(0,90,1,0)
	b.BackgroundColor3 = Color3.fromRGB(60,50,90)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
end

-- ========= 按钮函数 =========
local function createButton(page, text, callback)
	local btn = Instance.new("TextButton", page)
	btn.Size = UDim2.new(0.9,0,0,50)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = Color3.fromRGB(45,45,70)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(120,120,120)

	local clicking = false

	btn.MouseButton1Click:Connect(function()
		clicking = true
		btn:TweenSize(UDim2.new(0.88,0,0,45), "Out","Back",0.12,true)
		task.wait(0.12)
		btn:TweenSize(UDim2.new(0.9,0,0,50), "Out","Back",0.15,true)
		clicking = false
		callback()
	end)

	search:GetPropertyChangedSignal("Text"):Connect(function()
		btn.Visible = btn.Text:lower():find(search.Text:lower(),1,true) ~= nil
	end)
end

-- ========= 创建 Tabs / Pages =========
createTab("Universal")
createTab("TSB")
createTab("99_night")
createTab("other_games")

local universal = createPage("Universal")
local games = createPage("Games")

switchTab("Universal")

-- ========= 按钮 =========
createButton(universal,"Fly Script",function()
	loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)

createButton(universal,"Jerk off R6",function()
	loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
end)

createButton(universal,"Jerk off R15",function()
	loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end)

createButton(universal,"Ghostplayer",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/A-Common-User/Draven-Script/main/ghostplayer.lua"))()
end)

createButton(99_night,"VapeVoidware",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua"))()
end)

createButton(other_games,"The Lost Front",function()
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
