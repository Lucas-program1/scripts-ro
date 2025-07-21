local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SpeedJumpUI"

-- Frame principal (el panel)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 0)
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 15)

-- Botón para minimizar
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.Text = "–"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
local minBtnCorner = Instance.new("UICorner", minimizeButton)
minBtnCorner.CornerRadius = UDim.new(0, 6)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Ajusta Velocidad y Salto"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

-- Cuadro velocidad
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0.8, 0, 0, 50)
speedBox.Position = UDim2.new(0.1, 0, 0, 50)
speedBox.PlaceholderText = "Velocidad (WalkSpeed)"
speedBox.TextScaled = true
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedBox.TextColor3 = Color3.fromRGB(230, 230, 230)
speedBox.ClearTextOnFocus = false
local speedBoxCorner = Instance.new("UICorner", speedBox)
speedBoxCorner.CornerRadius = UDim.new(0, 10)

-- Cuadro salto
local jumpBox = Instance.new("TextBox", frame)
jumpBox.Size = UDim2.new(0.8, 0, 0, 50)
jumpBox.Position = UDim2.new(0.1, 0, 0, 110)
jumpBox.PlaceholderText = "Salto (JumpPower)"
jumpBox.TextScaled = true
jumpBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
jumpBox.TextColor3 = Color3.fromRGB(230, 230, 230)
jumpBox.ClearTextOnFocus = false
local jumpBoxCorner = Instance.new("UICorner", jumpBox)
jumpBoxCorner.CornerRadius = UDim.new(0, 10)

-- Botón aplicar
local applyButton = Instance.new("TextButton", frame)
applyButton.Size = UDim2.new(0.8, 0, 0, 50)
applyButton.Position = UDim2.new(0.1, 0, 0, 170)
applyButton.Text = "Aplicar"
applyButton.TextScaled = true
applyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 150)
applyButton.TextColor3 = Color3.fromRGB(20, 20, 20)
local applyButtonCorner = Instance.new("UICorner", applyButton)
applyButtonCorner.CornerRadius = UDim.new(0, 15)

-- Texto confirmación
local confirmText = Instance.new("TextLabel", frame)
confirmText.Size = UDim2.new(1, 0, 0, 30)
confirmText.Position = UDim2.new(0, 0, 0, 230)
confirmText.BackgroundTransparency = 1
confirmText.TextColor3 = Color3.fromRGB(0, 255, 0)
confirmText.TextScaled = true
confirmText.Text = ""
confirmText.Font = Enum.Font.GothamBold

-- Botón icono para restaurar panel (invisible al inicio)
local iconButton = Instance.new("TextButton", screenGui)
iconButton.Size = UDim2.new(0, 50, 0, 50)
iconButton.Position = UDim2.new(0.05, 0, 0.1, 0)
iconButton.Text = "🐧"
iconButton.TextScaled = true
iconButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
iconButton.TextColor3 = Color3.fromRGB(220, 220, 220)
iconButton.Visible = false
local iconCorner = Instance.new("UICorner", iconButton)
iconCorner.CornerRadius = UDim.new(0, 15)

-- Minimizar
minimizeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	iconButton.Visible = true
end)

-- Restaurar
iconButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	iconButton.Visible = false
end)

-- Aplicar cambios
applyButton.MouseButton1Click:Connect(function()
	local speed = tonumber(speedBox.Text)
	local jump = tonumber(jumpBox.Text)

	if speed and jump then
		humanoid.WalkSpeed = speed
		humanoid.JumpPower = jump

		confirmText.Text = "¡Parámetros aplicados!"
		wait(2)
		confirmText.Text = ""
	else
		confirmText.Text = "Por favor, ingresa números válidos."
		wait(2)
		confirmText.Text = ""
	end
end)

