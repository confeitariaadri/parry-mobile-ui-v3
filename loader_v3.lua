--[[
Parry Mobile UI v3 — protótipo de treino
Configuração inicial: alcance de referência 30 cm; perfil Tardio.
Somente interface/temporização demonstrativa: não detecta a bola real,
não aciona parry no Death Ball e não contém bypass de anti-cheat.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ParryMobileUI_v3")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(17, 18, 27),
    panel = Color3.fromRGB(29, 31, 45),
    border = Color3.fromRGB(83, 91, 125),
    text = Color3.fromRGB(245, 246, 255),
    muted = Color3.fromRGB(160, 166, 190),
    green = Color3.fromRGB(71, 215, 145),
    yellow = Color3.fromRGB(255, 198, 80),
    red = Color3.fromRGB(255, 91, 112),
    blue = Color3.fromRGB(111, 157, 255),
}
local function create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(parent, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local gui = create("ScreenGui", {
    Name = "ParryMobileUI_v3", ResetOnSpawn = false,
    IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

local panel = create("Frame", {
    Name = "Panel", AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.fromScale(0.5,0.52), Size = UDim2.fromOffset(294,330),
    BackgroundColor3 = C.bg, BorderSizePixel = 0
}, gui)
corner(panel, 14)
create("UIStroke", {Color=C.border, Thickness=1.2}, panel)

local header = create("Frame", {
    Name="Header", Size=UDim2.new(1,0,0,44),
    BackgroundColor3=C.panel, BorderSizePixel=0
}, panel)
corner(header, 14)
create("Frame", {Position=UDim2.new(0,0,1,-12), Size=UDim2.new(1,0,0,12),
    BackgroundColor3=C.panel, BorderSizePixel=0}, header)
create("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(12,0),
    Size=UDim2.new(1,-60,1,0), Font=Enum.Font.GothamBold,
    Text="PARRY  /  TREINO v3", TextColor3=C.text, TextSize=13,
    TextXAlignment=Enum.TextXAlignment.Left}, header)
local minimize = create("TextButton", {Name="Minimize",
    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-8,0.5,0),
    Size=UDim2.fromOffset(28,28), BackgroundColor3=Color3.fromRGB(50,53,72),
    BorderSizePixel=0, Font=Enum.Font.GothamBold, Text="—",
    TextColor3=C.text, TextSize=18}, header)
corner(minimize,8)

local body = create("Frame", {Name="Body", Position=UDim2.fromOffset(10,52),
    Size=UDim2.new(1,-20,1,-62), BackgroundTransparency=1}, panel)
create("UIListLayout", {Padding=UDim.new(0,7), SortOrder=Enum.SortOrder.LayoutOrder}, body)

local function makeToggle(label, color, order)
    local row = create("Frame", {Size=UDim2.new(1,0,0,36),
        BackgroundColor3=C.panel, BorderSizePixel=0, LayoutOrder=order}, body)
    corner(row,9)
    create("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(10,0),
        Size=UDim2.new(1,-78,1,0), Font=Enum.Font.GothamSemibold,
        Text=label, TextColor3=C.text, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left}, row)
    local btn = create("TextButton", {AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-7,0.5,0), Size=UDim2.fromOffset(58,25),
        BackgroundColor3=Color3.fromRGB(60,62,80), BorderSizePixel=0,
        Font=Enum.Font.GothamBold, Text="OFF", TextColor3=C.text, TextSize=10}, row)
    corner(btn,7)
    local on=false
    btn.Activated:Connect(function()
        on=not on
        btn.Text=on and "ON" or "OFF"
        btn.BackgroundColor3=on and color or Color3.fromRGB(60,62,80)
    end)
    return function() return on end
end
local autoOn = makeToggle("Auto Parry • treino", C.green, 1)
local perfectOn = makeToggle("Perfect Parry • treino", C.blue, 2)

local rangeRow = create("Frame", {Size=UDim2.new(1,0,0,65),
    BackgroundColor3=C.panel, BorderSizePixel=0, LayoutOrder=3}, body)
corner(rangeRow,9)
local rangeLabel = create("TextLabel", {BackgroundTransparency=1,
    Position=UDim2.fromOffset(10,4), Size=UDim2.new(1,-20,0,20),
    Font=Enum.Font.GothamSemibold, Text="Alcance de referência: 30 cm",
    TextColor3=C.text, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left}, rangeRow)
local rangeSlider = create("TextButton", {Name="RangeSlider",
    Position=UDim2.fromOffset(10,34), Size=UDim2.new(1,-20,0,22),
    BackgroundColor3=Color3.fromRGB(52,55,75), BorderSizePixel=0,
    Text="", AutoButtonColor=false}, rangeRow)
corner(rangeSlider,7)
local rangeFill = create("Frame", {Size=UDim2.new(20/90,0,1,0),
    BackgroundColor3=C.blue, BorderSizePixel=0}, rangeSlider)
corner(rangeFill,7)
local range = 30
local function setRange(x)
    local w=math.max(rangeSlider.AbsoluteSize.X,1)
    local a=math.clamp((x-rangeSlider.AbsolutePosition.X)/w,0,1)
    range=math.floor((10+a*90+2.5)/5)*5
    range=math.clamp(range,10,100)
    rangeLabel.Text="Alcance de referência: "..range.." cm"
    rangeFill.Size=UDim2.new((range-10)/90,0,1,0)
end
rangeSlider.Activated:Connect(function()
    setRange(UserInputService:GetMouseLocation().X)
end)
rangeSlider.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then setRange(i.Position.X) end
end)
rangeSlider.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then
        setRange(i.Position.X)
    end
end)

local profileRow=create("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=C.panel,
    BorderSizePixel=0,LayoutOrder=4},body)
corner(profileRow,9)
create("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,0),
    Size=UDim2.new(0.43,0,1,0),Font=Enum.Font.GothamSemibold,
    Text="Perfil",TextColor3=C.text,TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left},profileRow)
local profileBtn=create("TextButton",{Name="Profile",Position=UDim2.new(0.43,0,0,6),
    Size=UDim2.new(0.55,0,1,-12),BackgroundColor3=Color3.fromRGB(91,58,68),
    BorderSizePixel=0,Font=Enum.Font.GothamBold,Text="TARDIO",
    TextColor3=C.text,TextSize=11},profileRow)
corner(profileBtn,7)
local profiles={"ANTECIPADO","EQUILIBRADO","TARDIO"}
local profileIndex=3
local profileValues={ANTECIPADO=0.75,EQUILIBRADO=1,TARDIO=1.2}
profileBtn.Activated:Connect(function()
    profileIndex=profileIndex%#profiles+1
    local name=profiles[profileIndex]
    profileBtn.Text=name
    profileBtn.BackgroundColor3=(name=="TARDIO" and Color3.fromRGB(91,58,68))
        or (name=="ANTECIPADO" and Color3.fromRGB(54,78,66))
        or Color3.fromRGB(58,68,100)
end)

local testBtn=create("TextButton",{Name="TestTiming",Size=UDim2.new(1,0,0,34),
    BackgroundColor3=Color3.fromRGB(42,56,83),BorderSizePixel=0,
    Font=Enum.Font.GothamBold,Text="TESTAR CONFIGURAÇÃO",
    TextColor3=C.text,TextSize=11,LayoutOrder=5},body)
corner(testBtn,9)
local status=create("TextLabel",{Name="Status",Size=UDim2.new(1,0,0,28),
    BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Pronto • treino local",
    TextColor3=C.muted,TextSize=10,TextWrapped=true,LayoutOrder=6},body)
testBtn.Activated:Connect(function()
    local enabled={}
    if autoOn() then table.insert(enabled,"Auto Parry") end
    if perfectOn() then table.insert(enabled,"Perfect Parry") end
    if #enabled==0 then
        status.Text="Ative um modo para testar a interface."
        status.TextColor3=C.yellow
    else
        local profile=profiles[profileIndex]
        status.Text=table.concat(enabled," + ").." • "..range.." cm • "..profile.." (simulação)"
        status.TextColor3=C.green
    end
end)

local minimized=false
minimize.Activated:Connect(function()
    minimized=not minimized
    body.Visible=not minimized
    panel.Size=minimized and UDim2.fromOffset(210,44) or UDim2.fromOffset(294,330)
    minimize.Text=minimized and "+" or "—"
end)

local dragging,dragStart,startPos=false,nil,nil
header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=i.Position; startPos=panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
        local d=i.Position-dragStart
        panel.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
