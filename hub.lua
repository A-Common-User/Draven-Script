local player = game.Players.LocalPlayer

-- 安全销毁已有 Hub
pcall(function()
    player.PlayerGui.SimpleHub:Destroy()
end)

-- 创建 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.Parent = player:WaitForChild("PlayerGui")

-- 主窗口
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 420)
frame.Position = UDim2.new(0.5, -160, 0.5, -210)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- 圆角 + 阴影
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 16)
local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(60, 60, 60)
frameStroke.Thickness = 2

-- 背景渐变
local frameGradient = Instance.new("UIGradient", frame)
frameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 45, 100))
}
frameGradient.Rotation = 45

-- 拖动时光影效果
frame.Draggable = true
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        frameGradient.Rotation = 60
        frameStroke.Color = Color3.fromRGB(100,100,150)
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        frameGradient.Rotation = 45
        frameStroke.Color = Color3.fromRGB(60,60,60)
    end
end)

-- 标题
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Draven's Script Storage"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.BorderSizePixel = 0

-- 标题动态渐变光晕
local titleGradient = Instance.new("UIGradient", title)
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 255))
}
titleGradient.Rotation = 90
-- 光晕动画
spawn(function()
    while gui.Parent do
        for i=0,1,0.01 do
            titleGradient.Offset = Vector2.new(i,0)
            task.wait(0.02)
        end
        for i=1,0,-0.01 do
            titleGradient.Offset = Vector2.new(i,0)
            task.wait(0.02)
        end
    end
end)

-- 按钮容器（滚动）
local list = Instance.new("ScrollingFrame", frame)
list.Position = UDim2.new(0, 0, 0, 50)
list.Size = UDim2.new(1, 0, 1, -50)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- 创建按钮函数（带发光 + 悬停 + 点击 + 粒子）
local function createButton(text, callback, isClose)
    local btn = Instance.new("TextButton", list)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 12)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(120, 120, 120)
    btnStroke.Thickness = 1

    if isClose then
        btn.TextColor3 = Color3.fromRGB(255,50,50)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    else
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        -- 背景渐变
        local gradient = Instance.new("UIGradient", btn)
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 50, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 60, 160))
        }
        gradient.Rotation = 45

        -- 发光效果
        local glow = Instance.new("UIStroke", btn)
        glow.Color = Color3.fromRGB(200,200,255)
        glow.Thickness = 2
        glow.Transparency = 0.5
        glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        -- 悬停效果
        btn.MouseEnter:Connect(function()
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 70, 180)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 80, 220))
            }
            btnStroke.Color = Color3.fromRGB(200,200,255)
            btn:TweenSize(UDim2.new(0.95,0,0,55), "Out", "Quad", 0.15, true)
        end)
        btn.MouseLeave:Connect(function()
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 50, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 60, 160))
            }
            btnStroke.Color = Color3.fromRGB(120,120,120)
            btn:TweenSize(UDim2.new(0.9,0,0,50), "Out", "Quad", 0.15, true)
        end)
    end

    -- 点击动画 + 粒子效果
    btn.MouseButton1Click:Connect(function()
        btn:TweenSize(UDim2.new(btn.Size.X.Scale,btn.Size.X.Offset,0,45), "Out", "Quad", 0.1, true, function()
            btn:TweenSize(UDim2.new(btn.Size.X.Scale,btn.Size.X.Offset,0,50), "Out", "Quad", 0.1, true)
        end)

        -- 粒子模拟（小圆点飞出）
        for i=1,5 do
            local p = Instance.new("Frame", gui)
            p.Size = UDim2.new(0,6,0,6)
            p.Position = UDim2.new(0, btn.AbsolutePosition.X + math.random(0,btn.AbsoluteSize.X), 0, btn.AbsolutePosition.Y + math.random(0,btn.AbsoluteSize.Y))
            p.BackgroundColor3 = Color3.fromRGB(255,255,255)
            local pCorner = Instance.new("UICorner", p)
            pCorner.CornerRadius = UDim.new(0,3)
            spawn(function()
                for t=0,1,0.05 do
                    p.Position = p.Position + UDim2.new(0,math.random(-10,10),0, -20*t)
                    p.BackgroundTransparency = t
                    task.wait(0.02)
                end
                p:Destroy()
            end)
        end

        callback()
    end)
end

-- 整合按钮
createButton("Fly Script", function()
    loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)
createButton("Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
createButton("VapeVoidware", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua", true))()
end)
createButton("Jerk off R6", function()
    loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
end)
createButton("Jerk off R15", function()
    loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end)
createButton("The Lost Front", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/TheLostFront.lua"))()
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
