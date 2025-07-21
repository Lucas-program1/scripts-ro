local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Configuración
local config = {
    fly = false,
    noclipEnabled = false,
    speed = 16,
    jumpPower = 50,
    godmode = false,
    invisible = false,
    flySpeed = 50,
    flyUp = false,
    flyDown = false,
}

-- Variables para fly
local bodyVelocity
local bodyGyro

-- Actualizar noclip (solo si fly y noclip están activos)
local function updateNoclip()
    local noclip = config.fly and config.noclipEnabled
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end

-- Iniciar vuelo
local function startFly()
    if bodyVelocity or bodyGyro then return end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
end

-- Detener vuelo
local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    hrp.Velocity = Vector3.new(0,0,0)
end

-- Actualizar invisibilidad completa
local function updateInvisibility()
    if config.invisible then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Accessory") then
                part.Transparency = 1
                -- Si es accesorio, ocultar partes internas (casco, pelo...)
                if part:IsA("Accessory") then
                    local handle = part:FindFirstChild("Handle")
                    if handle then
                        handle.Transparency = 1
                    end
                end
            elseif part:IsA("CharacterMesh") then
                part:Destroy() -- Opcional para que no molesten
            end
        end
    else
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Accessory") then
                part.Transparency = 0
                if part:IsA("Accessory") then
                    local handle = part:FindFirstChild("Handle")
                    if handle then
                        handle.Transparency = 0
                    end
                end
            end
        end
    end
end

-- Activar o desactivar Godmode
local function updateGodmode()
    if config.godmode then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.HealthChanged:Connect(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        hum.MaxHealth = 100
        if hum.Health > 100 then hum.Health = 100 end
    end
end

-- Joystick para móvil (igual que en fly)
local joystickVector = Vector3.new(0,0,0)
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MenuHacksGui"
screenGui.ResetOnSpawn = false

-- Frame principal (movible y minimizable)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "MENU HACKS MÓVIL"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)

local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -45, 0, 0)
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 24
minimizeButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
minimizeButton.TextColor3 = Color3.new(1,1,1)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1

minimizeButton.MouseButton1Click:Connect(function()
    if contentFrame.Visible then
        contentFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 350, 0, 40)
        minimizeButton.Text = "+"
    else
        contentFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 350, 0, 500)
        minimizeButton.Text = "_"
    end
end)

-- Fly buttons y joystick
local flyButton = Instance.new("TextButton", contentFrame)
flyButton.Size = UDim2.new(0, 150, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Fly OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 20
flyButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
flyButton.TextColor3 = Color3.new(1,1,1)

local noclipToggle = Instance.new("TextButton", contentFrame)
noclipToggle.Size = UDim2.new(0, 150, 0, 50)
noclipToggle.Position = UDim2.new(0, 180, 0, 10)
noclipToggle.Text = "NoClip OFF"
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.TextSize = 20
noclipToggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
noclipToggle.TextColor3 = Color3.new(1,1,1)

-- Fly subir y bajar
local flyUpButton = Instance.new("TextButton", contentFrame)
flyUpButton.Size = UDim2.new(0, 70, 0, 40)
flyUpButton.Position = UDim2.new(0, 10, 0, 70)
flyUpButton.Text = "Subir"
flyUpButton.Font = Enum.Font.GothamBold
flyUpButton.TextSize = 18
flyUpButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyUpButton.TextColor3 = Color3.new(1,1,1)

local flyDownButton = Instance.new("TextButton", contentFrame)
flyDownButton.Size = UDim2.new(0, 70, 0, 40)
flyDownButton.Position = UDim2.new(0, 90, 0, 70)
flyDownButton.Text = "Bajar"
flyDownButton.Font = Enum.Font.GothamBold
flyDownButton.TextSize = 18
flyDownButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyDownButton.TextColor3 = Color3.new(1,1,1)

-- Input velocidad
local speedLabel = Instance.new("TextLabel", contentFrame)
speedLabel.Size = UDim2.new(0, 150, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 120)
speedLabel.Text = "Velocidad (speed):"
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1

local speedInput = Instance.new("TextBox", contentFrame)
speedInput.Size = UDim2.new(0, 150, 0, 30)
speedInput.Position = UDim2.new(0, 180, 0, 120)
speedInput.Text = tostring(config.speed)
speedInput.Font = Enum.Font.GothamBold
speedInput.TextSize = 18
speedInput.ClearTextOnFocus = false
speedInput.TextColor3 = Color3.new(0,0,0)
speedInput.BackgroundColor3 = Color3.new(1,1,1)
speedInput.TextEditable = true

-- Input salto
local jumpLabel = Instance.new("TextLabel", contentFrame)
jumpLabel.Size = UDim2.new(0, 150, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, 160)
jumpLabel.Text = "Salto (jumpPower):"
jumpLabel.Font = Enum.Font.GothamBold
jumpLabel.TextSize = 18
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.BackgroundTransparency = 1

local jumpInput = Instance.new("TextBox", contentFrame)
jumpInput.Size = UDim2.new(0, 150, 0, 30)
jumpInput.Position = UDim2.new(0, 180, 0, 160)
jumpInput.Text = tostring(config.jumpPower)
jumpInput.Font = Enum.Font.GothamBold
jumpInput.TextSize = 18
jumpInput.ClearTextOnFocus = false
jumpInput.TextColor3 = Color3.new(0,0,0)
jumpInput.BackgroundColor3 = Color3.new(1,1,1)
jumpInput.TextEditable = true

-- Godmode toggle
local godmodeButton = Instance.new("TextButton", contentFrame)
godmodeButton.Size = UDim2.new(0, 150, 0, 50)
godmodeButton.Position = UDim2.new(0, 10, 0, 210)
godmodeButton.Text = "GodMode OFF"
godmodeButton.Font = Enum.Font.GothamBold
godmodeButton.TextSize = 20
godmodeButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
godmodeButton.TextColor3 = Color3.new(1,1,1)

-- Invisibilidad toggle
local invisButton = Instance.new("TextButton", contentFrame)
invisButton.Size = UDim2.new(0, 150, 0, 50)
invisButton.Position = UDim2.new(0, 180, 0, 210)
invisButton.Text = "Invisible OFF"
invisButton.Font = Enum.Font.GothamBold
invisButton.TextSize = 20
invisButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
invisButton.TextColor3 = Color3.new(1,1,1)

-- Joystick para fly
local joystickFrame = Instance.new("Frame", screenGui)
joystickFrame.Size = UDim2.new(0,150,0,150)
joystickFrame.Position = UDim2.new(0,20,1,-170)
joystickFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
joystickFrame.BackgroundTransparency = 0.5
joystickFrame.AnchorPoint = Vector2.new(0,0)

local joystickKnob = Instance.new("Frame", joystickFrame)
joystickKnob.Size = UDim2.new(0,60,0,60)
joystickKnob.Position = UDim2.new(0.5, -30, 0.5, -30)
joystickKnob.BackgroundColor3 = Color3.fromRGB(150,150,150)
joystickKnob.BackgroundTransparency = 0.2
joystickKnob.AnchorPoint = Vector2.new(0.5,0.5)
joystickKnob.Active = true
joystickKnob.Draggable = false

-- Lógica del joystick
local dragging = false
local startPos = Vector2.new()

joystickKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPos = input.Position
    end
end)

joystickKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        joystickKnob.Position = UDim2.new(0.5, -30, 0.5, -30)
        joystickVector = Vector3.new(0,0,0)
    end
end)

joystickKnob.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragging then
        local delta = input.Position - startPos
        local maxDist = 50
        if delta.Magnitude > maxDist then
            delta = delta.Unit * maxDist
        end
        joystickKnob.Position = UDim2.new(0, 75 + delta.X, 0, 75 + delta.Y)
        local x = delta.X / maxDist
        local y = delta.Y / maxDist
        joystickVector = Vector3.new(x,0,-y)
    end
end)

-- Conexiones botones

flyButton.MouseButton1Click:Connect(function()
    config.fly = not config.fly
    if config.fly then
        flyButton.Text = "Fly ON"
        startFly()
        config.noclipEnabled = true
        noclipToggle.Text = "NoClip ON"
        updateNoclip()
    else
        flyButton.Text = "Fly OFF"
        stopFly()
        config.noclipEnabled = false
        noclipToggle.Text = "NoClip OFF"
        updateNoclip()
    end
end)

noclipToggle.MouseButton1Click:Connect(function()
    config.noclipEnabled = not config.noclipEnabled
    if config.noclipEnabled then
        noclipToggle.Text = "NoClip ON"
    else
        noclipToggle.Text = "NoClip OFF"
    end
    updateNoclip()
end)

flyUpButton.MouseButton1Click:Connect(function()
    if config.fly then
        hrp.CFrame = hrp.CFrame + Vector3.new(0,5,0)
    end
end)

flyDownButton.MouseButton1Click:Connect(function()
    if config.fly then
        hrp.CFrame = hrp.CFrame - Vector3.new(0,5,0)
    end
end)

speedInput.FocusLost:Connect(function(enterPressed)
    local num = tonumber(speedInput.Text)
    if num and num > 0 and num <= 200 then
        config.speed = num
        hum.WalkSpeed = config.speed
    else
        speedInput.Text = tostring(config.speed)
    end
end)

jumpInput.FocusLost:Connect(function(enterPressed)
    local num = tonumber(jumpInput.Text)
    if num and num >= 50 and num <= 500 then
        config.jumpPower = num
        hum.JumpPower = config.jumpPower
    else
        jumpInput.Text = tostring(config.jumpPower)
    end
end)

godmodeButton.MouseButton1Click:Connect(function()
    config.godmode = not config.godmode
    if config.godmode then
        godmodeButton.Text = "GodMode ON"
        updateGodmode()
    else
        godmodeButton.Text = "GodMode OFF"
        updateGodmode()
    end
end)

invisButton.MouseButton1Click:Connect(function()
    config.invisible = not config.invisible
    if config.invisible then
        invisButton.Text = "Invisible ON"
        updateInvisibility()
    else
        invisButton.Text = "Invisible OFF"
        updateInvisibility()
    end
end)

-- Actualizar estado inicial
hum.WalkSpeed = config.speed
hum.JumpPower = config.jumpPower

-- Actualizar fly en RunService
RunService.Heartbeat:Connect(function()
    if config.fly then
        local cam = workspace.CurrentCamera
        if bodyVelocity and bodyGyro then
            local moveDir = joystickVector
            local lookVector = cam.CFrame.LookVector
            local rightVector = cam.CFrame.RightVector

            local move = (lookVector * moveDir.Z + rightVector * moveDir.X).Unit * config.flySpeed
            if moveDir.Magnitude < 0.1 then
                bodyVelocity.Velocity = Vector3.new(0,0,0)
            else
                bodyVelocity.Velocity = Vector3.new(move.X, 0, move.Z)
            end

            bodyGyro.CFrame = cam.CFrame

            -- Subir y bajar con botones ya hecho, pero también con variables para mantener velocidad vertical si quieres
        end
    end
end)

-- También fijar WalkSpeed y JumpPower por si alguien cambia valores por otros medios
RunService.Stepped:Connect(function()
    hum.WalkSpeed = config.speed
    hum.JumpPower = config.jumpPower
end)
