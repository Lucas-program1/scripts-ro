-- Menú PRO móvil por Lucas 💚

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Guardar y cargar configuración con DataStore (para simplificar usamos Variables en memoria)
local config = {
    fly = false,
    speed = 16,
    jump = 50,
    invisible = false,
    godmode = false,
    noclip = false,
    gravity = true,
    colorIndex = 1,
    menuVisible = true,
}

local colors = {
    Color3.fromRGB(35,35,35),
    Color3.fromRGB(30,60,90),
    Color3.fromRGB(50,90,50),
}

-- FUNCIONES AUXILIARES
local function saveConfig()
    -- Aquí podrías usar DataStore para guardar realmente
    -- pero para pruebas lo dejamos así
end

local function loadConfig()
    -- Cargar desde DataStore si quieres
end

-- Crear UI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "LucasHackUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 260, 0, 430)
frame.Position = UDim2.new(1, -270, 1, -440)
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = colors[config.colorIndex]
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true

-- Animación al abrir
frame.Position = UDim2.new(1, 300, 1, -440)
TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -270, 1, -440)}):Play()

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "💚 HACK MENU PRO"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.BorderSizePixel = 0

-- INFO PANEL
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -20, 0, 60)
info.Position = UDim2.new(0, 10, 0, 350)
info.TextColor3 = Color3.new(1, 1, 1)
info.BackgroundTransparency = 0.3
info.BackgroundColor3 = Color3.fromRGB(0,0,0)
info.TextWrapped = true
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.Text = "Estado: Iniciando..."
info.BorderSizePixel = 0

-- Helper para actualizar info
local function updateInfo()
    local txt = ("Fly: %s\nSpeed: %d\nJump: %d\nInvisible: %s\nGodMode: %s\nNoClip: %s\nGravedad: %s\nMenu visible: %s"):format(
        tostring(config.fly), config.speed, config.jump, tostring(config.invisible),
        tostring(config.godmode), tostring(config.noclip), tostring(config.gravity), tostring(config.menuVisible)
    )
    info.Text = txt
end

updateInfo()

-- BOTONES y SLIDERS
local buttons = {}

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createSlider(text, y, min, max, initial, callback)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, -10, 0, 30)
    label.Position = UDim2.new(0, 10, 0, y)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderFrame = Instance.new("Frame", frame)
    sliderFrame.Size = UDim2.new(0.5, -20, 0, 30)
    sliderFrame.Position = UDim2.new(0.5, 10, 0, y)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sliderFrame.BorderSizePixel = 0

    local sliderBar = Instance.new("Frame", sliderFrame)
    sliderBar.Size = UDim2.new((initial - min)/(max - min), 0, 1, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(100,200,100)
    sliderBar.BorderSizePixel = 0

    local dragging = false

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    sliderFrame.InputChanged:Connect(function(input)
        if dragging then
            local pos = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local val = min + (pos / sliderFrame.AbsoluteSize.X) * (max - min)
            sliderBar.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
            callback(math.floor(val))
        end
    end)

    return label, sliderFrame
end

-- FLY
local bv, bg
buttons.fly = createButton("✈️ Fly OFF", 50, function()
    config.fly = not config.fly
    if config.fly then
        buttons.fly.Text = "✈️ Fly ON"
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    else
        buttons.fly.Text = "✈️ Fly OFF"
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
    updateInfo()
end)

RunService.Heartbeat:Connect(function()
    if config.fly and bv and bg then
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * config.speed
        bg.CFrame = workspace.CurrentCamera.CFrame
    end
end)

-- SPEED Slider
local function setSpeed(val)
    config.speed = val
    hum.WalkSpeed = val
    updateInfo()
end
local speedLabel, speedSlider = createSlider("⚡ Velocidad", 100, 16, 100, config.speed, setSpeed)

-- JUMP Slider
local function setJump(val)
    config.jump = val
    hum.JumpPower = val
    updateInfo()
end
local jumpLabel, jumpSlider = createSlider("🦘 Salto", 150, 50, 150, config.jump, setJump)

-- INVISIBLE toggle
buttons.invisible = createButton("👻 Invisible OFF", 200, function()
    config.invisible = not config.invisible
    if config.invisible then
        buttons.invisible.Text = "👻 Invisible ON"
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                if part:FindFirstChild("Decal") then part.Decal.Transparency = 1 end
            end
        end
    else
        buttons.invisible.Text = "👻 Invisible OFF"
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                if part:FindFirstChild("Decal") then part.Decal.Transparency = 0 end
            end
        end
    end
    updateInfo()
end)

-- GODMODE toggle
buttons.godmode = createButton("🛡️ God Mode OFF", 250, function()
    config.godmode = not config.godmode
    if config.godmode then
        buttons.godmode.Text = "🛡️ God Mode ON"
        hum.MaxHealth = math.huge
        hum.Health = hum.MaxHealth
        hum.HealthChanged:Connect(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        buttons.godmode.Text = "🛡️ God Mode OFF"
        hum.MaxHealth = 100
        if hum.Health > 100 then hum.Health = 100 end
    end
    updateInfo()
end)

-- NOCLIP toggle
buttons.noclip = createButton("🚪 NoClip OFF", 300, function()
    config.noclip = not config.noclip
    if config.noclip then
        buttons.noclip.Text = "🚪 NoClip ON"
    else
        buttons.noclip.Text = "🚪 NoClip OFF"
    end
    updateInfo()
end)

RunService.Stepped:Connect(function()
    if config.noclip then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- GRAVITY toggle
buttons.gravity = createButton("🌍 Gravedad ON", 350, function()
    config.gravity = not config.gravity
    if config.gravity then
        buttons.gravity.Text = "🌍 Gravedad ON"
        workspace.Gravity = 196.2
    else
        buttons.gravity.Text = "🌍 Gravedad OFF"
        workspace.Gravity = 0
    end
    updateInfo()
end)

-- COLOR toggle
buttons.color = createButton("🎨 Color 1", 400, function()
    config.colorIndex = config.colorIndex + 1
    if config.colorIndex > #colors then
        config.colorIndex = 1
    end
    frame.BackgroundColor3 = colors[config.colorIndex]
    buttons.color.Text = "🎨 Color "..config.colorIndex
end)

-- MENU TOGGLE con tecla M
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        config.menuVisible = not config.menuVisible
        frame.Visible = config.menuVisible
        updateInfo()
    end
end)

return screenGui

