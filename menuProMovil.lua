local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Crear interfaz
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SpeedJumpUI"

-- Cuadro de velocidad
local speedBox = Instance.new("TextBox")
speedBox.Parent = screenGui
speedBox.Position = UDim2.new(0.05, 0, 0.1, 0)
speedBox.Size = UDim2.new(0, 200, 0, 50)
speedBox.PlaceholderText = "Velocidad"
speedBox.TextScaled = true
speedBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Cuadro de salto
local jumpBox = Instance.new("TextBox")
jumpBox.Parent = screenGui
jumpBox.Position = UDim2.new(0.05, 0, 0.2, 0)
jumpBox.Size = UDim2.new(0, 200, 0, 50)
jumpBox.PlaceholderText = "JumpPower"
jumpBox.TextScaled = true
jumpBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Botón de aplicar
local applyButton = Instance.new("TextButton")
applyButton.Parent = screenGui
applyButton.Position = UDim2.new(0.05, 0, 0.3, 0)
applyButton.Size = UDim2.new(0, 200, 0, 50)
applyButton.Text = "Aplicar"
applyButton.TextScaled = true
applyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)

-- Función al hacer clic
applyButton.MouseButton1Click:Connect(function()
	local speed = tonumber(speedBox.Text)
	local jump = tonumber(jumpBox.Text)

	if speed and jump then
		humanoid.WalkSpeed = speed
		humanoid.JumpPower = jump
	else
		warn("Por favor ingresa números válidos.")
	end
end)
