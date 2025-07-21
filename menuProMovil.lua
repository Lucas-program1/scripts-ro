local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Variables fly
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local moveVector = Vector3.new(0,0,0)
local up = false
local down = false

-- Crear GUI para móvil
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "FlyGUI"

-- Función para crear botones grandes para móvil
local function createButton(text, position, size)
    local btn = Instance.new("TextButton", screenGui)
    btn.Text = text
    btn.Size = size or UDim2.new(0, 80, 0, 80)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.AutoButtonColor = true
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    return btn
end

-- Crear botones de control para móvil
local btnForward = createButton("↑", UDim2.new(0.5, -40, 0.8, -170))
local btnBack = createButton("↓", UDim2.new(0.5, -40, 0.8, -80))
local btnLeft = createButton("←", UDim2.new(0.5, -130, 0.8, -125))
local btnRight = createButton("→", UDim2.new(0.5, 50, 0.8, -125))
local btnUp = createButton("⇧", UDim2.new(0.85, 0, 0.7, 0), UDim2.new(0, 60, 0, 60))
local btnDown = createButton("⇩", UDim2.new(0.85, 0, 0.8, 0), UDim2.new(0, 60, 0, 60))
local btnFly = createButton("Fly OFF", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0, 120, 0, 60))

-- Variables para detectar toque (activo o no)
local function bindButton(btn)
    btn.Active = false
    btn.TouchStarted:Connect(function()
        btn.Active = true
    end)
    btn.TouchEnded:Connect(function()
        btn.Active = false
    end)
end

for _, btn in pairs({btnForward, btnBack, btnLeft, btnRight, btnUp, btnDown}) do
    bindButton(btn)
end

local function updateMoveVector()
    local x, y, z = 0, 0, 0
    if btnForward.Active then z = z + 1 end
    if btnBack.Active then z = z - 1 end
    if btnRight.Active then x = x + 1 end
    if btnLeft.Active then x = x - 1 end
    moveVector = Vector3.new(x,0,z)
    if moveVector.Magnitude > 1 then
        moveVector = moveVector.Unit
    end
end

local function startFly()
    if flying then return end
    flying = true
    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)

    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bodyGyro.CFrame = hrp.CFrame

    hum.PlatformStand = true
    workspace.Gravity = 0

    RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value, function()
        if not flying then return end
        updateMoveVector()

        local cam = workspace.CurrentCamera
        local direction = (cam.CFrame.LookVector * moveVector.Z) + (cam.CFrame.RightVector * moveVector.X)
        direction = Vector3.new(direction.X, 0, direction.Z)
        if direction.Magnitude > 0 then
            direction = direction.Unit * flySpeed
        end

        local yVel = 0
        if btnUp.Active then yVel = flySpeed end
        if btnDown.Active then yVel = -flySpeed end

        bodyVelocity.Velocity = Vector3.new(direction.X, yVel, direction.Z)
        bodyGyro.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    RunService:UnbindFromRenderStep("FlyMovement")
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    hum.PlatformStand = false
    workspace.Gravity = 196.2
end

btnFly.MouseButton1Click:Connect(function()
    if flying then
        btnFly.Text = "Fly OFF"
        stopFly()
    else
        btnFly.Text = "Fly ON"
        startFly()
    end
end)
