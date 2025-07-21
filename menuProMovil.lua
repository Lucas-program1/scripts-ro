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
local noclipActive = false
local speedValue = 16
local jumpPowerValue = 50
local flySpeed = 50

local bodyVelocity, bodyGyro

local flyMove = {forward=false, backward=false, left=false, right=false, up=false, down=false, jump=false}

-- UI Base
local frameMenu = Instance.new("Frame", gui)
frameMenu.Size = UDim2.new(0, 150, 0.5, 0)
frameMenu.Position = UDim2.new(1, -160, 0.25, 0)
frameMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frameMenu.BorderSizePixel = 0
frameMenu.Active = true
frameMenu.Draggable = true

local titleBar = Instance.new("Frame", frameMenu)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Menú Pro Móvil"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local btnMinimize = Instance.new("TextButton", titleBar)
btnMinimize.Size = UDim2.new(0, 30, 1, 0)
btnMinimize.Position = UDim2.new(1, -30, 0, 0)
btnMinimize.Text = "—"
btnMinimize.Font = Enum.Font.SourceSansBold
btnMinimize.TextSize = 22
btnMinimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMinimize.BorderSizePixel = 0

-- Botones menú
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

local btnSpeed = createButton("Speed: "..speedValue, 40)
local btnJump = createButton("Salto: "..jumpPowerValue, 90)
local btnFly = createButton("Vuelo (OFF)", 140)
local btnGod = createButton("Godmode (OFF)", 190)
local btnInvisible = createButton("Invisible (OFF)", 240)
local btnNoclip = createButton("NoClip (OFF)", 290)

-- Panel control desplegable
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

local function closePanel()
    panel.Visible = false
    inputBox.Text = ""
    currentPanel = ""
end
btnClose.MouseButton1Click:Connect(closePanel)

-- Funciones actualizar
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

-- NoClip: activar/desactivar partes para pasar por objetos
local function toggleNoclip()
    noclipActive = not noclipActive
    if noclipActive and flyActive then
        btnNoclip.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        btnNoclip.Text = "NoClip (ON)"
    else
        btnNoclip.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btnNoclip.Text = "NoClip (OFF)"
    end
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
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if flyMove.down then
            moveDir = moveDir - Vector3.new(0,1,0)
        end

        moveDir = moveDir.Unit * flySpeed
        if moveDir.Magnitude == 0 then
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        else
            bodyVelocity.Velocity = moveDir
        end

        bodyGyro.CFrame = camCF

        -- Aplicar NoClip si está activo y vuelo activo
        if noclipActive and flyActive then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        else
            -- Si no, restaurar colisión
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and not part.CanCollide then
                    part.CanCollide = true
                end
            end
        end
    end)
end

local function stopFly()
    if not flyActive then return end
    flyActive = false
    btnFly.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btnFly.Text = "Vuelo (OFF)"
    hum.PlatformStand = false
    workspace.Gravity = 196.2 -- Valor normal

    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end

    -- Restaurar colisiones al parar vuelo
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end

    RunService:UnbindFromRenderStep("FlyMovement")

    -- Si NoClip estaba activado, desactivarlo
    if noclipActive then
        toggleNoclip()
    end
end

-- Otros toggles
local function toggleGodMode()
    godModeActive = not godModeActive
    if godModeActive then
        btnGod.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        btnGod.Text = "Godmode (ON)"
        hum.MaxHealth = math.huge
        hum.Health = hum.MaxHealth
    else
        btnGod.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btnGod.Text = "Godmode (OFF)"
        hum.MaxHealth = 100
        hum.Health = 100
    end
end

local function toggleInvisible()
    invisibleActive = not invisibleActive
    if invisibleActive then
        btnInvisible.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        btnInvisible.Text = "Invisible (ON)"
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1
                for _, d in pairs(part:GetChildren()) do
                    if d:IsA("Decal") then
                        d.Transparency = 1
                    end
                end
            end
        end
    else
        btnInvisible.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btnInvisible.Text = "Invisible (OFF)"
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
                for _, d in pairs(part:GetChildren()) do
                    if d:IsA("Decal") then
                        d.Transparency = 0
                    end
                end
            end
        end
    end
end

-- Cambiar velocidad y salto desde panel
btnSpeed.MouseButton1Click:Connect(function()
    currentPanel = "speed"
    panelTitle.Text = "Cambiar velocidad"
    inputBox.PlaceholderText = "Escribe la velocidad (ej: 16)"
    panel.Visible = true
end)

btnJump.MouseButton1Click:Connect(function()
    currentPanel = "jump"
    panelTitle.Text = "Cambiar salto"
    inputBox.PlaceholderText = "Escribe el salto (ej: 50)"
    panel.Visible = true
end)

btnFly.MouseButton1Click:Connect(function()
    if flyActive then
        stopFly()
    else
        startFly()
    end
end)

btnGod.MouseButton1Click:Connect(toggleGodMode)
btnInvisible.MouseButton1Click:Connect(toggleInvisible)
btnNoclip.MouseButton1Click:Connect(toggleNoclip)

btnActivate.MouseButton1Click:Connect(function()
    local val = tonumber(inputBox.Text)
    if currentPanel == "speed" and val and val > 0 and val <= 500 then
        updateSpeed(val)
    elseif currentPanel == "jump" and val and val > 0 and val <= 500 then
        updateJump(val)
    else
        inputBox.Text = ""
        inputBox.PlaceholderText = "Número inválido"
        return
    end
    closePanel()
end)

btnMinimize.MouseButton1Click:Connect(function()
    if frameMenu.Size.Y.Offset > 50 then
        frameMenu.Size = UDim2.new(0, 150, 0, 30)
        for _, child in pairs(frameMenu:GetChildren()) do
            if (child:IsA("TextButton") or child:IsA("TextLabel")) and child ~= titleLabel then
                child.Visible = false
            end
        end
    else
        frameMenu.Size = UDim2.new(0, 150, 0.5, 0)
        for _, child in pairs(frameMenu:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child.Visible = true
            end
        end
    end
    titleLabel.Visible = true
end)

-- Input teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then flyMove.forward = true end
        if input.KeyCode == Enum.KeyCode.S then flyMove.backward = true end
        if input.KeyCode == Enum.KeyCode.A then flyMove.left = true end
        if input.KeyCode == Enum.KeyCode.D then flyMove.right = true end
        if input.KeyCode == Enum.KeyCode.E then flyMove.up = true end
        if input.KeyCode == Enum.KeyCode.Q then flyMove.down = true end
        if input.KeyCode == Enum.KeyCode.Space then flyMove.jump = true end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then flyMove.forward = false end
        if input.KeyCode == Enum.KeyCode.S then flyMove.backward = false end
        if input.KeyCode == Enum.KeyCode.A then flyMove.left = false end
        if input.KeyCode == Enum.KeyCode.D then flyMove.right = false end
        if input.KeyCode == Enum.KeyCode.E then flyMove.up = false end
        if input.KeyCode == Enum.KeyCode.Q then flyMove.down = false end
    end
end)

-- Crear botones táctiles de vuelo en pantalla para móvil
local function createFlyButton(name, text, position)
    local btn = Instance.new("TextButton", gui)
    btn.Name = name
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = position
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 24
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.AutoButtonColor = true
    btn.BorderSizePixel = 0
    btn.Visible = false -- Oculto por defecto, solo móvil
    return btn
end

local btnForward = createFlyButton("FlyForward", "W", UDim2.new(0.5, -25, 0.85, -60))
local btnBackward = createFlyButton("FlyBackward", "S", UDim2.new(0.5, -25, 0.85, 0))
local btnLeft = createFlyButton("FlyLeft", "A", UDim2.new(0.5, -90, 0.85, 0))
local btnRight = createFlyButton("FlyRight", "D", UDim2.new(0.5, 40, 0.85, 0))
local btnUp = createFlyButton("FlyUp", "E", UDim2.new(0.9, 0, 0.85, 0))
local btnDown = createFlyButton("FlyDown", "Q", UDim2.new(0.9, 0, 0.85, 60))

-- Mostrar botones solo en móvil
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    btnForward.Visible = true
    btnBackward.Visible = true
    btnLeft.Visible = true
    btnRight.Visible = true
    btnUp.Visible = true
    btnDown.Visible = true
end

-- Conectar botones táctiles con movimiento de vuelo
btnForward.MouseButton1Down:Connect(function() flyMove.forward = true end)
btnForward.MouseButton1Up:Connect(function() flyMove.forward = false end)

btnBackward.MouseButton1Down:Connect(function() flyMove.backward = true end)
btnBackward.MouseButton1Up:Connect(function() flyMove.backward = false end)

btnLeft.MouseButton1Down:Connect(function() flyMove.left = true end)
btnLeft.MouseButton1Up:Connect(function() flyMove.left = false end)

btnRight.MouseButton1Down:Connect(function() flyMove.right = true end)
btnRight.MouseButton1Up:Connect(function() flyMove.right = false end)

btnUp.MouseButton1Down:Connect(function() flyMove.up = true end)
btnUp.MouseButton1Up:Connect(function() flyMove.up = false end)

btnDown.MouseButton1Down:Connect(function() flyMove.down = true end)
btnDown.MouseButton1Up:Connect(function() flyMove.down = false end)

return gui
