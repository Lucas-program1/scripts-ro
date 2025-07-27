local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables de vuelo
local flyEnabled = false
local flySpeed = 2

-- Segunda GUI completa (solo la parte visual y botones, sin funcionalidad de vuelo aun)
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")

main.Name = "main"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.new(0, 0, 0)
up.TextSize = 14

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.49, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.new(0, 0, 0)
down.TextSize = 14

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.7, 0, 0.49, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "Fly"
onof.TextColor3 = Color3.new(0, 0, 0)
onof.TextSize = 14

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.47, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "gui by me_ozoneYT"
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.23, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.new(0, 0, 0)
plus.TextScaled = true
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.47, 0, 0.49, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.new(0, 0, 0)
speed.TextScaled = true
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.23, 0, 0.49, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.new(0, 0, 0)
mine.TextScaled = true
mine.TextWrapped = true

-- Variables para controlar velocidad del vuelo (ejemplo)
local speeds = 1

-- Función para activar/desactivar vuelo con BodyVelocity y BodyGyro (versión simple para R6 y R15)
local function toggleFly()
    flyEnabled = not flyEnabled
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not torso then return end

    if flyEnabled then
        local bg = Instance.new("BodyGyro", torso)
        bg.Name = "FlyBG"
        bg.P = 9000
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame

        local bv = Instance.new("BodyVelocity", torso)
        bv.Name = "FlyBV"
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.velocity = Vector3.new(0, 0, 0)

        humanoid.PlatformStand = true

        spawn(function()
            while flyEnabled and bv.Parent do
                bv.velocity = workspace.CurrentCamera.CFrame.lookVector * flySpeed * speeds
                bg.cframe = workspace.CurrentCamera.CFrame
                wait()
            end
        end)
    else
        humanoid.PlatformStand = false
        local bg = torso:FindFirstChild("FlyBG")
        local bv = torso:FindFirstChild("FlyBV")
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end

-- Conectar el botón 'onof' para activar o desactivar vuelo
onof.MouseButton1Click:Connect(function()
    toggleFly()
end)

-- Conectar los botones '+' y '-' para cambiar la velocidad del vuelo (variable speeds)
plus.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speed.Text = tostring(speeds)
end)

mine.MouseButton1Click:Connect(function()
    if speeds > 1 then
        speeds = speeds - 1
        speed.Text = tostring(speeds)
    end
end)
