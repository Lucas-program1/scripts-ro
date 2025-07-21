-- Variables básicas
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MenuProMovil"

-- Estados
local flyActive = false
local godModeActive = false
local invisibleActive = false
local speedValue = 16
local jumpPowerValue = 50
local flySpeed = 50

-- Variables vuelo
local bodyVelocity, bodyGyro

-- Movimiento vuelo
local flyMove = {forward=false, backward=false, left=false, right=false, up=false, down=false, jump=false}

-- UI Base
local frameMenu = Instance.new("Frame", gui)
frameMenu.Size = UDim2.new(0, 150, 1, 0)
frameMenu.Position = UDim2.new(1, -150, 0, 0)
frameMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frameMenu.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", frameMenu)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Menú Pro Móvil"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18

-- Función para crear botones
local function createButton(text, posY)
    local btn = Instance.new("TextButton", frameMenu)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    return btn
end

-- Crear botones menú
local btnSpeed = createButton("Speed: "..speedValue, 50)
local btnJump = createButton("Salto: "..jumpPowerValue, 100)
local btnFly = createButton("Vuelo (OFF)", 150)
local btnGod = createButton("Godmode (OFF)", 200)
local btnInvisible = createButton("Invisible (OFF)", 250)

-- Panel de control desplegable
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 250, 0, 140)
panel.Position = UDim2.new(1, -400, 0, 50)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.Visible = false
panel.BorderSizePixel = 0

local panelTitle = Instance.new("TextLabel", panel)
panelTitle.Size = UDim2.new(1, 0, 0, 30)
panelTitle.BackgroundTransparency = 1
panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
panelTitle.Font = Enum.Font.SourceSansBold
panelTitle.TextSize = 18
panelTitle.Text = ""

local inputBox = Instance.new("TextBox", panel)
inputBox.Size = UDim2.new(1, -20, 0, 40)
inputBox.Position = UDim2.new(0, 10, 0, 40)
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 18
inputBox.ClearTextOnFocus = false
inputBox.PlaceholderText = "Escribe un número"
inputBox.Text = ""

local btnActivate = Instance.new("TextButton", panel)
btnActivate.Size = UDim2.new(0.45, -10, 0, 40)
btnActivate.Position = UDim2.new(0, 10, 0, 90)
btnActivate.Text = "Activar"
btnActivate.Font = Enum.Font.SourceSansBold
btnActivate.TextSize = 18
btnActivate.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btnActivate.TextColor3 = Color3.fromRGB(255,255,255)
btnActivate.BorderSizePixel = 0

local btnClose = Instance.new("TextButton", panel)
btnClose.Size = UDim2.new(0.45, -10, 0, 40)
btnClose.Position = UDim2.new(0.55, 0, 0, 90)
btnClose.Text = "Cerrar"
btnClose.Font = Enum.Font.SourceSansBold
btnClose.TextSize = 18
btnClose.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
btnClose.TextColor3 = Color3.fromRGB(255,255,255)
btnClose.BorderSizePixel = 0

local currentPanel = ""

-- Función para cerrar panel
local function closePanel()
    panel.Visible = false
    inputBox.Text = ""
    currentPanel = ""
end

btnClose.MouseButton1Click:Connect(closePanel)

-- Función para actualizar valores y UI
local function updateSpeed(newSpeed)
    speedValue = tonumber(newSpeed) or speedValue
    hum.WalkSpeed = speedValue
    btnSpeed.Text = "Speed: "..speedValue
end

local function updateJump(newJump)
    jumpPowerValue = tonumber(newJump) or jumpPowerValue
    hum.JumpPower = jumpPowerValue
    btnJump.Text = "Salto: "..jumpPowerValue
end

-- Vuelo funciones

local function startFly()
    if flyActive then return end
    flyActive = true
    btnFly.BackgroundColor3 = Color3.fromRGB(0,170,0)
    btnFly.Text = "Vuelo (ON)"

    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)

    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = hrp.CFrame

    hum.PlatformStand = true
    workspace.Gravity = 0

    RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value, function()
        if not flyActive then return end

        local moveDir = Vector3.new()
        local camCF = cam.CFrame

        if flyMove.forward then
            moveDir = moveDir + camCF.LookVector
        end
        if flyMove.backward then
            moveDir = moveDir - camCF.LookVector
        end
        if flyMove.left then
            moveDir = moveDir - camCF.RightVector
        end
        if flyMove.right then
            moveDir = moveDir + camCF.RightVector
        end
        if flyMove.up then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if flyMove.down then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
        else
            moveDir = Vector3.new(0, 0, 0)
        end

        bodyVelocity.Velocity = moveDir
        bodyGyro.CFrame = camCF

        if flyMove.jump then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPowerValue / 2, hrp.Velocity.Z)
            flyMove.jump = false
        end
    end)
end

local function stopFly()
    if not flyActive then return end
    flyActive = false
    btnFly.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    btnFly.Text = "Vuelo (OFF)"

    RunService:UnbindFromRenderStep("FlyMovement")
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    hum.PlatformStand = false
    workspace.Gravity = 196.2
end

-- Cambiar Godmode (invencible)
local function setGodmode(on)
    godModeActive = on
    if on then
        btnGod.BackgroundColor3 = Color3.fromRGB(0,170,0)
        btnGod.Text = "Godmode (ON)"
        hum.MaxHealth = math.huge
        hum.Health = hum.MaxHealth
    else
        btnGod.BackgroundColor3 = Color3.fromRGB(170,0,0)
        btnGod.Text = "Godmode (OFF)"
        hum.MaxHealth = 100
        if hum.Health > 100 then hum.Health = 100 end
    end
end

-- Cambiar Invisible
local function setInvisible(on)
    invisibleActive = on
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = on and 1 or 0
            part.CanCollide = not on
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = on and 1 or 0
        end
    end
    if on then
        btnInvisible.BackgroundColor3 = Color3.fromRGB(0,170,0)
        btnInvisible.Text = "Invisible (ON)"
    else
        btnInvisible.BackgroundColor3 = Color3.fromRGB(170,0,0)
        btnInvisible.Text = "Invisible (OFF)"
    end
end

-- Conectar botones del menú principal

btnSpeed.MouseButton1Click:Connect(function()
    panelTitle.Text = "Cambiar Velocidad"
    inputBox.PlaceholderText = "Escribe velocidad (ej: 16)"
    inputBox.Text = tostring(speedValue)
    currentPanel = "speed"
    panel.Visible = true
end)

btnJump.MouseButton1Click:Connect(function()
    panelTitle.Text = "Cambiar Salto"
    inputBox.PlaceholderText = "Escribe salto (ej: 50)"
    inputBox.Text = tostring(jumpPowerValue)
    currentPanel = "jump"
    panel.Visible = true
end)

btnFly.MouseButton1Click:Connect(function()
    if flyActive then
        stopFly()
    else
        startFly()
    end
end)

btnGod.MouseButton1Click:Connect(function()
    setGodmode(not godModeActive)
end)

btnInvisible.MouseButton1Click:Connect(function()
    setInvisible(not invisibleActive)
end)

btnActivate.MouseButton1Click:Connect(function()
    local val = tonumber(inputBox.Text)
    if not val or val <= 0 then
        inputBox.Text = ""
        return
    end

    if currentPanel == "speed" then
        updateSpeed(val)
    elseif currentPanel == "jump" then
        updateJump(val)
    end
    panel.Visible = false
end)

-- Config inicial
hum.WalkSpeed = speedValue
hum.JumpPower = jumpPowerValue

-- Controles vuelo táctil (puedes personalizarlos)
-- Vamos a hacer botones para volar arriba, abajo, adelante, atrás, izquierda, derecha, y salto

local flyControlsFrame = Instance.new("Frame", gui)
flyControlsFrame.Size = UDim2.new(0, 250, 0, 200)
flyControlsFrame.Position = UDim2.new(0.5, -125, 1, -210)
flyControlsFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
flyControlsFrame.BorderSizePixel = 0
flyControlsFrame.Visible = false

local function createFlyButton(text, posX, posY)
    local btn = Instance.new("TextButton", flyControlsFrame)
    btn.Size = UDim2.new(0, 60, 0, 40)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    return btn
end

local flyBtnForward = createFlyButton("↑", 95, 10)
local flyBtnBackward = createFlyButton("↓", 95, 100)
local flyBtnLeft = createFlyButton("←", 30, 55)
local flyBtnRight = createFlyButton("→", 160, 55)
local flyBtnUp = createFlyButton("Subir", 30, 150)
local flyBtnDown = createFlyButton("Bajar", 160, 150)
local flyBtnJump = createFlyButton("Saltar", 95, 55)

-- Funciones para actualizar estado vuelo al tocar botones

local function buttonTouchStart(btn, key)
    btn.TouchStarted:Connect(function()
        flyMove[key] = true
    end)
    btn.TouchEnded:Connect(function()
        flyMove[key] = false
    end)
end

buttonTouchStart(flyBtnForward, "forward")
buttonTouchStart(flyBtnBackward, "backward")
buttonTouchStart(flyBtnLeft, "left")
buttonTouchStart(flyBtnRight, "right")
buttonTouchStart(flyBtnUp, "up")
buttonTouchStart(flyBtnDown, "down")

flyBtnJump.TouchTap:Connect(function()
    if flyActive then
        flyMove.jump = true
    else
        hum.Jump = true
    end
end)

return gui -- si quieres devolver gui para debug
