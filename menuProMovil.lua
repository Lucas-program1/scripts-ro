local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local flyEnabled = false
local flySpeed = 2
local infiniteJump = false
local jumpConnection

-- Pantalla principal (primera GUI)
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "TouchGui"

-- Función para crear botones (primera GUI)
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

-- Función de vuelo (tu lógica original)
function toggleFly()
    flyEnabled = not flyEnabled
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not torso then return end

    if flyEnabled then
        local bv = Instance.new("BodyVelocity", torso)
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(1, 1, 1) * 1e6
        bv.Velocity = Vector3.new(0,0,0)

        spawn(function()
            while flyEnabled and bv and bv.Parent do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
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

-- Botones básicos (primera GUI)
createButton("Speed+", 10, "🔺 Speed+", function()
    humanoid.WalkSpeed = humanoid.WalkSpeed + 5
end)

createButton("Speed-", 60, "🔻 Speed-", function()
    humanoid.WalkSpeed = math.max(0, humanoid.WalkSpeed - 5)
end)

createButton("Jump+", 110, "🔺 Jump+", function()
    humanoid.JumpPower = humanoid.JumpPower + 5
end)

createButton("Jump-", 160, "🔻 Jump-", function()
    humanoid.JumpPower = math.max(0, humanoid.JumpPower - 5)
end)

createButton("Fly", 210, "✈️ Fly", function()
    toggleFly()
end)

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

-----------------------
-- SEGUNDA GUI INTEGRADA --
-----------------------

local main = Instance.new("ScreenGui")
main.Name = "main"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)
Frame.Active = true
Frame.Draggable = true

local up = Instance.new("TextButton")
up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14

local down = Instance.new("TextButton")
down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.49, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14

local onof = Instance.new("TextButton")
onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.7, 0, 0.49, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.47, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "gui by me_ozoneYT"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

local plus = Instance.new("TextButton")
plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.23, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextWrapped = true

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "speed"
speedLabel.Parent = Frame
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speedLabel.Position = UDim2.new(0.47, 0, 0.49, 0)
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Text = tostring(flySpeed)
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextScaled = true
speedLabel.TextWrapped = true

local mine = Instance.new("TextButton")
mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.23, 0, 0.49, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextWrapped = true

-- Variables para segunda GUI
local nowe = false

-- Funciones para botones de segunda GUI

-- Botón para activar/desactivar vuelo
onof.MouseButton1Down:Connect(function()
    toggleFly()
    nowe = flyEnabled -- sincronizamos variable nowe con flyEnabled para que sirva igual
    onof.Text = flyEnabled and "fly ON" or "fly OFF"
end)

-- Botón para aumentar velocidad de vuelo
plus.MouseButton1Down:Connect(function()
    flySpeed = flySpeed + 1
    speedLabel.Text = tostring(flySpeed)
end)

-- Botón para disminuir velocidad de vuelo
mine.MouseButton1Down:Connect(function()
    flySpeed = math.max(1, flySpeed - 1)
    speedLabel.Text = tostring(flySpeed)
end)

-- Los botones UP y DOWN puedes conectarlos a otras funciones que quieras, por ejemplo:
up.MouseButton1Down:Connect(function()
    humanoid.JumpPower = humanoid.JumpPower + 5
end)

down.MouseButton1Down

