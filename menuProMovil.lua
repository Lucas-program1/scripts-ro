local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local flyEnabled = false
local flySpeed = 2
local infiniteJump = false
local jumpConnection

-- Pantalla principal
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "TouchGui"

-- Función para crear botones
function createButton(name, posY, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = UDim2.new(0, 10, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Text = text
    button.Parent = screenGui
    button.MouseButton1Click:Connect(callback)
end

-- Función de vuelo
function toggleFly()
    flyEnabled = not flyEnabled
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not torso then return end

    if flyEnabled then
        local bv = Instance.new("BodyVelocity", torso)
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(1, 1, 1) * 1e6
        bv.Velocity = Vector3.zero

        -- Actualiza velocidad constantemente
        spawn(function()
            while flyEnabled and bv and bv.Parent do
                bv.Velocity = workspace.CurrentCamera.CFrame.lookVector * flySpeed
                humanoid.PlatformStand = true
                wait()
            end
        end)
    else
        humanoid.PlatformStand = false
        local existing = torso:FindFirstChild("FlyBV")
        if existing then
            existing:Destroy()
        end
    end
end

-- Botón: Aumentar velocidad
createButton("Speed+", 10, "🔺 Speed+", function()
    humanoid.WalkSpeed = humanoid.WalkSpeed + 5
end)

-- Botón: Disminuir velocidad
createButton("Speed-", 60, "🔻 Speed-", function()
    humanoid.WalkSpeed = humanoid.WalkSpeed - 5
end)

-- Botón: Aumentar salto
createButton("Jump+", 110, "🔺 Jump+", function()
    humanoid.JumpPower = humanoid.JumpPower + 5
end)

-- Botón: Disminuir salto
createButton("Jump-", 160, "🔻 Jump-", function()
    humanoid.JumpPower = humanoid.JumpPower - 5
end)

-- Botón: Activar vuelo
createButton("Fly", 210, "✈️ Fly", function()
    toggleFly()
end)

-- Botón: Saltos infinitos
createButton("InfJump", 260, "♾️ Saltos Infinitos", function()
    infiniteJump = not infiniteJump

    if infiniteJump then
        jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if infiniteJump and humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end)
