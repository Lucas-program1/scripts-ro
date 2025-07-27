-- GUI PARA KRNL ANDROID - HECHO POR LUCAS
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Crear GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AndroidFlyGUI"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local function createButton(name, posY, text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

-- Variables
local flyEnabled = false
local flySpeed = 2
local jumpPower = 50
local bv, bg

-- FLY FUNCIONES
local function startFly()
    local root = character:WaitForChild("HumanoidRootPart")
    bg = Instance.new("BodyGyro", root)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = root.CFrame

    bv = Instance.new("BodyVelocity", root)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    humanoid.PlatformStand = true

    spawn(function()
        while flyEnabled and character and humanoid and humanoid.Health > 0 do
            game.RunService.RenderStepped:Wait()
            local move = humanoid.MoveDirection
            bv.velocity = move * flySpeed + Vector3.new(0,0.1,0)
            bg.cframe = workspace.CurrentCamera.CFrame
        end
    end)
end

local function stopFly()
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    humanoid.PlatformStand = false
end

-- BOTONES
createButton("Fly", 10, "🔄 Activar/Desactivar Fly", function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        startFly()
    else
        stopFly()
    end
end)

createButton("Speed+", 50, "🏃‍♂️ + Velocidad", function()
    flySpeed = flySpeed + 1
    player.Character.Humanoid.WalkSpeed = flySpeed * 8
end)

createButton("Speed-", 90, "🏃‍♂️ - Velocidad", function()
    flySpeed = math.max(1, flySpeed - 1)
    player.Character.Humanoid.WalkSpeed = flySpeed * 8
end)

createButton("Jump+", 130, "🦘 + JumpPower", function()
    jumpPower = jumpPower + 10
    player.Character.Humanoid.JumpPower = jumpPower
end)

createButton("Jump-", 170, "🦘 - JumpPower", function()
    jumpPower = math.max(10, jumpPower - 10)
    player.Character.Humanoid.JumpPower = jumpPower
end)

-- Asegurar que valores iniciales estén bien
humanoid.WalkSpeed = flySpeed * 8
humanoid.JumpPower = jumpPower
