local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local flyActive = false
local godmodeActive = false
local invisibleActive = false

local flySpeed = 50
local jumpPower = hum.JumpPower
local walkSpeed = hum.WalkSpeed

-- Estado de botones para vuelo móvil
local flyMove = {
    forward = false,
    backward = false,
    left = false,
    right = false,
    up = false,
    down = false,
}

-- Crear GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "AdminPanelMobile"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 280, 0.9, 0)
frame.Position = UDim2.new(1, -290, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.ClipsDescendants = true

local UIListLayout = Instance.new("UIListLayout", frame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Función para crear etiquetas
local function createLabel(text)
    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Size = UDim2.new(1, -20, 0, 30)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = #frame:GetChildren() + 1
    return label
end

-- Función para crear botones toggle
local function createToggleButton(text, initialState)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, -20, 0, 45)
    button.BackgroundColor3 = initialState and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Text = text .. (initialState and " (ON)" or " (OFF)")
    button.LayoutOrder = #frame:GetChildren() + 1
    return button
end

-- Función para crear inputs numéricos
local function createNumberInput(labelText, initialValue)
    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, -20, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #frame:GetChildren() + 1

    local label = Instance.new("TextLabel", container)
    label.Text = labelText
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox", container)
    input.Size = UDim2.new(0.5, -10, 1, 0)
    input.Position = UDim2.new(0.5, 10, 0, 0)
    input.Text = tostring(initialValue)
    input.ClearTextOnFocus = false
    input.TextColor3 = Color3.new(1,1,1)
    input.BackgroundColor3 = Color3.fromRGB(60,60,60)
    input.Font = Enum.Font.SourceSansBold
    input.TextSize = 18
    input.TextXAlignment = Enum.TextXAlignment.Center
    input.PlaceholderText = "Número"

    return input
end

-- Inputs y botones
local speedInput = createNumberInput("Velocidad (WalkSpeed):", walkSpeed)
local jumpInput = createNumberInput("Salto (JumpPower):", jumpPower)
local flyButton = createToggleButton("Vuelo", flyActive)
local godmodeButton = createToggleButton("Godmode", godmodeActive)
local invisibleButton = createToggleButton("Invisible", invisibleActive)

-- Botones de control de vuelo para móvil
local flyControlsFrame = Instance.new("Frame", screenGui)
flyControlsFrame.Size = UDim2.new(0, 220, 0, 220)
flyControlsFrame.Position = UDim2.new(0, 20, 1, -250)
flyControlsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
flyControlsFrame.BackgroundTransparency = 0.1
flyControlsFrame.BorderSizePixel = 0
flyControlsFrame.Visible = false -- solo visible si vuelo activo

-- Crear botones direccionales para vuelo móvil
local function createFlyControlButton(text, position)
    local btn = Instance.new("TextButton", flyControlsFrame)
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 22
    btn.Text = text
    return btn
end

local btnForward = createFlyControlButton("↑", UDim2.new(0.33, 0, 0, 0))
local btnLeft = createFlyControlButton("←", UDim2.new(0, 0, 0.33, 0))
local btnRight = createFlyControlButton("→", UDim2.new(0.66, 0, 0.33, 0))
local btnBackward = createFlyControlButton("↓", UDim2.new(0.33, 0, 0.66, 0))
local btnUp = createFlyControlButton("▲", UDim2.new(0.66, 0, 0, 0))
local btnDown = createFlyControlButton("▼", UDim2.new(0.66, 0, 0.66, 0))
local btnJump = createFlyControlButton("Jump", UDim2.new(0, 0, 0.66, 0))

-- Detectar presionar y soltar botones de vuelo
local function buttonEvents(button, key)
    button.MouseButton1Down:Connect(function()
        flyMove[key] = true
    end)
    button.MouseButton1Up:Connect(function()
        flyMove[key] = false
    end)
    -- También para táctil fuera del botón
    button.TouchStarted:Connect(function()
        flyMove[key] = true
    end)
    button.TouchEnded:Connect(function()
        flyMove[key] = false
    end)
end

buttonEvents(btnForward, "forward")
buttonEvents(btnBackward, "backward")
buttonEvents(btnLeft, "left")
buttonEvents(btnRight, "right")
buttonEvents(btnUp, "up")
buttonEvents(btnDown, "down")
buttonEvents(btnJump, "jump")

-- Aplicar velocidad y salto desde inputs
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val >= 0 and val <= 500 then
        hum.WalkSpeed = val
    else
        speedInput.Text = tostring(hum.WalkSpeed)
    end
end)

jumpInput.FocusLost:Connect(function()
    local val = tonumber(jumpInput.Text)
    if val and val >= 0 and val <= 200 then
        hum.JumpPower = val
    else
        jumpInput.Text = tostring(hum.JumpPower)
    end
end)

-- Funciones de vuelo
local bodyVelocity, bodyGyro

local function startFly()
    if flyActive then return end
    flyActive = true
    flyButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
    flyButton.Text = "Vuelo (ON)"
    flyControlsFrame.Visible = true

    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)

    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bodyGyro.CFrame = hrp.CFrame

    hum.PlatformStand = true
    workspace.Gravity = 0

    RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value, function()
        if not flyActive then return end

        local moveDir = Vector3.new()
        local cam = workspace.CurrentCamera
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
        if moveDir ~= moveDir then -- NaN check
            moveDir = Vector3.new(0,0,0)
        end

        bodyVelocity.Velocity = moveDir
        bodyGyro.CFrame = camCF

        -- Salto (físicamente simulado como impulso hacia arriba)
        if flyMove.jump then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPower/2, hrp.Velocity.Z)
            flyMove.jump = false
        end
    end)
end

local function stopFly()
    if not flyActive then return end
    flyActive = false
    flyButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
    flyButton.Text = "Vuelo (OFF)"
    flyControlsFrame.Visible = false

    RunService:UnbindFromRenderStep("FlyMovement")
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    hum.PlatformStand = false
    workspace.Gravity = 196.2
end

flyButton.MouseButton1Click:Connect(function()
    if flyActive then
        stopFly()
    else
        startFly()
    end
end)

-- Godmode toggle
godmodeButton.MouseButton1Click:Connect(function()
    godmodeActive = not godmodeActive
    if godmodeActive then
        godmodeButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
        godmodeButton.Text = "Godmode (ON)"
        hum.MaxHealth = math.huge
        hum.Health = hum.MaxHealth
        hum.HealthChanged:Connect(function()
            if godmodeActive and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        godmodeButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
        godmodeButton.Text = "Godmode (OFF)"
        hum.MaxHealth = 100
    end
end)

-- Invisible toggle
invisibleButton.MouseButton1Click:Connect(function()
    invisibleActive = not invisibleActive
    if invisibleActive then
        invisibleButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
        invisibleButton.Text = "Invisible (ON)"
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
    else
        invisibleButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
        invisibleButton.Text = "Invisible (OFF)"
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 0
            end
        end
    end
end)

-- Actualizar referencias cuando cambia el personaje
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
end)
