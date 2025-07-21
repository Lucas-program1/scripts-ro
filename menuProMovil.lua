local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Config
local config = {
    fly = false,
    noclipEnabled = false,
    speed = 16,
    flySpeed = 50,
    flyUp = false,
    flyDown = false,
}

-- Variables para fly
local bodyVelocity
local bodyGyro

local function updateNoclip()
    local noclip = config.fly and config.noclipEnabled
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end

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

local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    hrp.Velocity = Vector3.new(0,0,0)
end

-- Joystick básico para móvil
local joystickVector = Vector3.new(0,0,0)

local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "FlyJoystickGui"

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
        joystickKnob.Position = UDim2.new(0.5,-30,0.5,-30)
        joystickVector = Vector3.new(0,0,0)
    end
end)
joystickKnob.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - startPos
        local maxDist = 60
        local clamped = Vector2.new(
            math.clamp(delta.X, -maxDist, maxDist),
            math.clamp(delta.Y, -maxDist, maxDist)
        )
        joystickKnob.Position = UDim2.new(0.5, clamped.X -30, 0.5, clamped.Y -30)
        joystickVector = Vector3.new(clamped.X/maxDist, 0, -clamped.Y/maxDist)
    end
end)

-- Botones subir/bajar vuelo
local flyUpButton = Instance.new("TextButton", screenGui)
flyUpButton.Size = UDim2.new(0, 70, 0, 50)
flyUpButton.Position = UDim2.new(1, -100, 1, -220)
flyUpButton.Text = "Subir"
flyUpButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
flyUpButton.TextColor3 = Color3.new(1,1,1)
flyUpButton.Font = Enum.Font.GothamBold
flyUpButton.TextSize = 18

local flyDownButton = Instance.new("TextButton", screenGui)
flyDownButton.Size = UDim2.new(0, 70, 0, 50)
flyDownButton.Position = UDim2.new(1, -100, 1, -160)
flyDownButton.Text = "Bajar"
flyDownButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
flyDownButton.TextColor3 = Color3.new(1,1,1)
flyDownButton.Font = Enum.Font.GothamBold
flyDownButton.TextSize = 18

flyUpButton.MouseButton1Down:Connect(function()
    config.flyUp = true
end)
flyUpButton.MouseButton1Up:Connect(function()
    config.flyUp = false
end)

flyDownButton.MouseButton1Down:Connect(function()
    config.flyDown = true
end)
flyDownButton.MouseButton1Up:Connect(function()
    config.flyDown = false
end)

RunService.RenderStepped:Connect(function(delta)
    if config.fly then
        updateNoclip()
        local camera = workspace.CurrentCamera
        local camCF = camera.CFrame

        local moveDir = (camCF.RightVector * joystickVector.X + camCF.LookVector * joystickVector.Z)
        moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        else
            moveDir = Vector3.new(0,0,0)
        end

        local finalVel = moveDir * config.flySpeed

        if config.flyUp then
            finalVel = finalVel + Vector3.new(0, config.flySpeed, 0)
        elseif config.flyDown then
            finalVel = finalVel + Vector3.new(0, -config.flySpeed, 0)
        end

        bodyVelocity.Velocity = finalVel
        bodyGyro.CFrame = camCF
        hum.PlatformStand = true
    else
        hum.PlatformStand = false
        if bodyVelocity then bodyVelocity.Velocity = Vector3.new(0,0,0) end
    end
end)

-- Botones fly y noclip
local flyButton = Instance.new("TextButton", screenGui)
flyButton.Size = UDim2.new(0, 120, 0, 50)
flyButton.Position = UDim2.new(1, -150, 0, 50)
flyButton.Text = "Fly OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 22

local noclipToggle = Instance.new("TextButton", screenGui)
noclipToggle.Size = UDim2.new(0, 120, 0, 50)
noclipToggle.Position = UDim2.new(1, -150, 0, 110)
noclipToggle.Text = "NoClip OFF"
noclipToggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
noclipToggle.TextColor3 = Color3.new(1,1,1)
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.TextSize = 22

flyButton.MouseButton1Click:Connect(function()
    config.fly = not config.fly
    if config.fly then
        startFly()
        flyButton.Text = "Fly ON"
    else
        stopFly()
        flyButton.Text = "Fly OFF"
    end
    updateNoclip()
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

hum.WalkSpeed = config.speed

print("Fly con joystick y noclip integrado listo para móvil")

