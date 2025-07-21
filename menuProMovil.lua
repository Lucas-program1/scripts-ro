local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local flying = false
local flySpeed = 50
local moveVector = Vector3.new(0,0,0)
local verticalMove = 0

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyJoystickGui"

-- --- JOYSTICK BASE ---
local joystickBase = Instance.new("Frame", screenGui)
joystickBase.Name = "JoystickBase"
joystickBase.Size = UDim2.new(0, 120, 0, 120)
joystickBase.Position = UDim2.new(0, 20, 1, -150)
joystickBase.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
joystickBase.BackgroundTransparency = 0.5
joystickBase.AnchorPoint = Vector2.new(0, 1)
joystickBase.ClipsDescendants = true
local baseCorner = Instance.new("UICorner", joystickBase)
baseCorner.CornerRadius = UDim.new(1, 0)

-- JOYSTICK knob
local joystickKnob = Instance.new("Frame", joystickBase)
joystickKnob.Name = "JoystickKnob"
joystickKnob.Size = UDim2.new(0, 60, 0, 60)
joystickKnob.Position = UDim2.new(0.5, -30, 0.5, -30)
joystickKnob.BackgroundColor3 = Color3.fromRGB(120, 120, 160)
local knobCorner = Instance.new("UICorner", joystickKnob)
knobCorner.CornerRadius = UDim.new(1, 0)

-- BOTÓN SUBIR
local upButton = Instance.new("TextButton", screenGui)
upButton.Name = "UpButton"
upButton.Size = UDim2.new(0, 60, 0, 60)
upButton.Position = UDim2.new(1, -90, 1, -220)
upButton.AnchorPoint = Vector2.new(1, 1)
upButton.BackgroundColor3 = Color3.fromRGB(100, 150, 230)
upButton.Text = "↑"
upButton.TextScaled = true
upButton.TextColor3 = Color3.fromRGB(240, 240, 240)
local upCorner = Instance.new("UICorner", upButton)
upCorner.CornerRadius = UDim.new(0, 15)

-- BOTÓN BAJAR
local downButton = Instance.new("TextButton", screenGui)
downButton.Name = "DownButton"
downButton.Size = UDim2.new(0, 60, 0, 60)
downButton.Position = UDim2.new(1, -90, 1, -140)
downButton.AnchorPoint = Vector2.new(1, 1)
downButton.BackgroundColor3 = Color3.fromRGB(100, 150, 230)
downButton.Text = "↓"
downButton.TextScaled = true
downButton.TextColor3 = Color3.fromRGB(240, 240, 240)
local downCorner = Instance.new("UICorner", downButton)
downCorner.CornerRadius = UDim.new(0, 15)

-- BOTÓN FLY ON/OFF
local flyButton = Instance.new("TextButton", screenGui)
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(1, -120, 1, -70)
flyButton.AnchorPoint = Vector2.new(1, 1)
flyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
flyButton.Text = "Fly OFF"
flyButton.TextScaled = true
flyButton.TextColor3 = Color3.fromRGB(230, 230, 230)
local flyCorner = Instance.new("UICorner", flyButton)
flyCorner.CornerRadius = UDim.new(0, 12)

-- -- INPUT SPEED --
local speedLabel = Instance.new("TextLabel", screenGui)
speedLabel.Text = "Speed:"
speedLabel.Size = UDim2.new(0, 70, 0, 30)
speedLabel.Position = UDim2.new(0, 20, 0, 20)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSansBold

local speedInput = Instance.new("TextBox", screenGui)
speedInput.Size = UDim2.new(0, 100, 0, 30)
speedInput.Position = UDim2.new(0, 100, 0, 20)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
speedInput.TextColor3 = Color3.fromRGB(255,255,255)
speedInput.Text = tostring(humanoid.WalkSpeed)
speedInput.ClearTextOnFocus = false
speedInput.TextScaled = true
local speedCorner = Instance.new("UICorner", speedInput)
speedCorner.CornerRadius = UDim.new(0, 5)

-- -- INPUT JUMPPOWER --
local jumpLabel = Instance.new("TextLabel", screenGui)
jumpLabel.Text = "JumpPower:"
jumpLabel.Size = UDim2.new(0, 100, 0, 30)
jumpLabel.Position = UDim2.new(0, 20, 0, 60)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.TextScaled = true
jumpLabel.Font = Enum.Font.SourceSansBold

local jumpInput = Instance.new("TextBox", screenGui)
jumpInput.Size = UDim2.new(0, 100, 0, 30)
jumpInput.Position = UDim2.new(0, 130, 0, 60)
jumpInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
jumpInput.TextColor3 = Color3.fromRGB(255,255,255)
jumpInput.Text = tostring(humanoid.JumpPower)
jumpInput.ClearTextOnFocus = false
jumpInput.TextScaled = true
local jumpCorner = Instance.new("UICorner", jumpInput)
jumpCorner.CornerRadius = UDim.new(0, 5)

-- Función para validar número positivo
local function isValidNumber(text)
	local num = tonumber(text)
	return num and num > 0
end

-- Cambiar velocidad al perder foco o presionar enter
speedInput.FocusLost:Connect(function(enterPressed)
	local text = speedInput.Text
	if isValidNumber(text) then
		humanoid.WalkSpeed = tonumber(text)
	else
		speedInput.Text = tostring(humanoid.WalkSpeed) -- revertir a valor válido
	end
end)

-- Cambiar jumppower al perder foco o presionar enter
jumpInput.FocusLost:Connect(function(enterPressed)
	local text = jumpInput.Text
	if isValidNumber(text) then
		humanoid.JumpPower = tonumber(text)
	else
		jumpInput.Text = tostring(humanoid.JumpPower)
	end
end)

-- Variables para joystick
local dragging = false
local dragStartPos = nil

-- Limitar posición knob dentro del círculo
local function clampVector(vec, maxLength)
	if vec.Magnitude > maxLength then
		return vec.Unit * maxLength
	else
		return vec
	end
end

-- Eventos joystick táctil
joystickKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStartPos = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				joystickKnob.Position = UDim2.new(0.5, -30, 0.5, -30)
				moveVector = Vector3.new(0,0,0)
			end
		end)
	end
end)

joystickBase.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStartPos = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				joystickKnob.Position = UDim2.new(0.5, -30, 0.5, -30)
				moveVector = Vector3.new(0,0,0)
			end
		end)
	end
end)

joystickBase.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStartPos
		local maxDistance = 50

		local clampedDelta = Vector2.new(math.clamp(delta.X, -maxDistance, maxDistance), math.clamp(delta.Y, -maxDistance, maxDistance))
		joystickKnob.Position = UDim2.new(0.5, clampedDelta.X, 0.5, clampedDelta.Y)

		local x = clampedDelta.X / maxDistance
		local z = clampedDelta.Y / maxDistance
		moveVector = Vector3.new(x, 0, -z)
	end
end)

-- Botones subir y bajar vuelo
upButton.TouchStarted:Connect(function()
	verticalMove = 1
end)
upButton.TouchEnded:Connect(function()
	verticalMove = 0
end)

downButton.TouchStarted:Connect(function()
	verticalMove = -1
end)
downButton.TouchEnded:Connect(function()
	verticalMove = 0
end)

-- Activar/desactivar vuelo
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyButton.Text = "Fly ON"
		humanoid.PlatformStand = true
	else
		flyButton.Text = "Fly OFF"
		humanoid.PlatformStand = false
		moveVector = Vector3.new(0,0,0)
		verticalMove = 0
	end
end)

-- Crear BodyVelocity para vuelo
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(0,0,0)
bodyVelocity.Velocity = Vector3.new(0,0,0)
bodyVelocity.Parent = rootPart

-- Actualizar movimiento cada frame
runService.RenderStepped:Connect(function()
	if flying then
		local camera = workspace.CurrentCamera
		local camCFrame = camera.CFrame

		local horizontalMove = (camCFrame.RightVector * moveVector.X) + (camCFrame.LookVector * moveVector.Z)
		local finalMove = horizontalMove + Vector3.new(0, verticalMove, 0)
		if finalMove.Magnitude > 0 then
			finalMove = finalMove.Unit * flySpeed
			bodyVelocity.Velocity = finalMove
			bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		else
			bodyVelocity.Velocity = Vector3.new(0,0,0)
			bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		end
	else
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.MaxForce = Vector3.new(0,0,0)
	end
end)
