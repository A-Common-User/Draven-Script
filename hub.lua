local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ========= 基础检测 =========
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
getgenv().HubMinimized = getgenv().HubMinimized or false

-- 安全销毁已有 Hub
pcall(function()
    player.PlayerGui.SimpleHub:Destroy()
end)

-- 创建 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- 主窗口
local frame = Instance.new("Frame", gui)
frame.Size = isMobile and UDim2.new(0,260,0,340) or UDim2.new(0,320,0,420)
frame.Position = UDim2.new(0.5,-frame.Size.X.Offset/2,0.5,-frame.Size.Y.Offset/2)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- 圆角 + 描边
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)
local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(60,60,60)
frameStroke.Thickness = 2

-- 背景渐变
local frameGradient = Instance.new("UIGradient", frame)
frameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70,45,100))
}
frameGradient.Rotation = 45

-- 拖动光效
frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        frameGradient.Rotation = 60
        frameStroke.Color = Color3.fromRGB(120,120,180)
    end
end)
frame.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        frameGradient.Rotation = 45
        frameStroke.Color = Color3.fromRGB(60,60,60)
    end
end)

-- 标题
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "Draven's Script Storage"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local titleGradient = Instance.new("UIGradient", title)
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,180,180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,255))
}

task.spawn(function()
    while gui.Parent do
        for i=0,1,0.01 do
            titleGradient.Offset = Vector2.new(i,0)
            task.wait(0.02)
        end
    end
end)

-- ===== 最小化按钮 =====
local minimize = Instance.new("TextButton", frame)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextScaled = true
minimize.Size = UDim2.new(0,40,0,40)
minimize.Position = UDim2.new(1,-45,0,5)
minimize.BackgroundTransparency = 1
minimize.TextColor3 = Color3.new(1,1,1)

-- ===== 悬浮 Icon =====
local icon = Instance.new("ImageButton", gui)
icon.Size = isMobile and UDim2.fromScale(0.13,0.13) or UDim2.fromScale(0.06,0.06)
icon.Position = UDim2.fromScale(0.92,0.5)
icon.BackgroundColor3 = Color3.fromRGB(50,50,90)
icon.Visible = false
icon.AutoButtonColor = false
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", icon).Color = Color3.fromRGB(180,180,255)

-- Icon 拖动 + 吸边
do
	local dragging, dragStart, startPos
	icon.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = icon.Position
		end
	end)
	icon.InputChanged:Connect(function(i)
		if dragging then
			local d = i.Position - dragStart
			icon.Position = UDim2.fromScale(
				math.clamp(startPos.X.Scale + d.X / workspace.CurrentCamera.ViewportSize.X, 0, 0.95),
				math.clamp(startPos.Y.Scale + d.Y / workspace.CurrentCamera.ViewportSize.Y, 0, 0.9)
			)
		end
	end)
	icon.InputEnded:Connect(function()
		if dragging then
			dragging = false
			local snap = icon.Position.X.Scale > 0.5 and 0.92 or 0.02
			TweenService:Create(icon, TweenInfo.new(0.25), {
				Position = UDim2.fromScale(snap, icon.Position.Y.Scale)
			}):Play()
		end
	end)
end

-- ===== 最小化逻辑 =====
local function minimizeHub()
	getgenv().HubMinimized = true
	TweenService:Create(frame, TweenInfo.new(0.25), {Size = UDim2.new(0,0,0,0)}):Play()
	task.wait(0.25)
	frame.Visible = false
	icon.Visible = true
end

local function openHub()
	getgenv().HubMinimized = false
	frame.Visible = true
	icon.Visible = false
	TweenService:Create(frame, TweenInfo.new(0.25), {
		Size = isMobile and UDim2.new(0,260,0,340) or UDim2.new(0,320,0,420)
	}):Play()
end

minimize.MouseButton1Click:Connect(minimizeHub)
icon.MouseButton1Click:Connect(openHub)

-- 手机默认最小化
if isMobile or getgenv().HubMinimized then
	frame.Visible = false
	icon.Visible = true
end

-- =========================
-- 下面：你的原按钮系统（完全没动）
-- =========================

local list = Instance.new("ScrollingFrame", frame)
list.Position = UDim2.new(0,0,0,50)
list.Size = UDim2.new(1,0,1,-50)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end)

local function createButton(text, callback, close)
	local b = Instance.new("TextButton", list)
	b.Size = UDim2.new(0.9,0,0,50)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	if close then
		b.TextColor3 = Color3.fromRGB(255,60,60)
		b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	else
		b.TextColor3 = Color3.new(1,1,1)
		local g = Instance.new("UIGradient", b)
		g.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(80,50,120)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(150,60,160))
		}
	end
	b.MouseButton1Click:Connect(callback)
end

-- 按钮
createButton("v Universal v", function()
    print("What? Why would you click this??")
end)
createButton("Fly Script", function()
    loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)
createButton("Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
createButton("Jerk off R6", function()
    loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
end)
createButton("Jerk off R15", function()
    loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end)
createButton("Ghostplayer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/A-Common-User/Draven-Script/refs/heads/main/ghostplayer.lua"))
end)
createButton("v some other game v", function()
    print("What? Why would you click this??")
end)
createButton("VapeVoidware", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua", true))()
end)
createButton("The Lost Front", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/TheLostFront.lua"))()
end)
createButton("v TSB v", function()
    print("What? Why would you click this??")
end)
createButton("Phantasm", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"))()
end)
createButton("TSB Sukuna", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/damir512/whendoesbrickdie/main/tspno.txt",true))()
end)
createButton("TSB Trashcan", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man", true))()
end)
createButton("Close Hub", function()
    gui:Destroy()
end, true)
