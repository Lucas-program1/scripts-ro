local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

local flying = false
local flySpeed = 50
local moveVector = Vector3.new(0,0,0)
local verticalMove = 0

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyJoystickGui"

-- Fondo para la interfaz
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0, 10, 1, -170)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0,1)
frame.ClipsDescendants = true
frame.BackgroundTransparency = 0.15
frame.Name = "MainFrame"

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Fly & Settings"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Center

-- Input Speed
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 80, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", frame)
speedInput.Size = UDim2.new(0, 70, 0, 25)
speedInput.Position = UDim2.new(0, 90, 0, 40)
speedInput.PlaceholderText = tostring(flySpeed)
speedInput.ClearTextOnFocus = false
speedInput.Text = ""
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 16
speedInput.TextColor3 = Color3.fromRGB(255,255,255)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.BorderSizePixel = 0
speedInput.TextWrapped = true

-- Input JumpPower
local jumpLabel = Instance.new("TextLabel", frame)
jumpLabel.Size = UDim2.new(0, 80, 0, 25)
jumpLabel.Position = UDim2.new(0, 10, 0, 70)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "JumpPower:"
jumpLabel.TextColor3 = Color3.fromRGB(255,255,255)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 16
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left

local jumpInput = Instance.new("TextBox", frame)
jumpInput.Size = UDim2.new(0, 70, 0, 25)
jumpInput.Position = UDim2.new(0, 90, 0, 70)
jumpInput.PlaceholderText = tostring(humanoid.JumpPower)
jumpInput.ClearTextOnFocus = false
jumpInput.Text = ""
jumpInput.Font = Enum.Font.Gotham
jumpInput.TextSize = 16
jumpInput.TextColor3 = Color3.fromRGB(255,255,255)
jumpInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpInput.BorderSizePixel = 0
jumpInput.TextWrapped = true

-- Botón para aplicar Speed y JumpPower
local applyButton = Instance.new("TextButton", frame)
applyButton.Size = UDim2.new(0, 80, 0, 30)
applyButton.Position = UDim2.new(0, 10, 0, 105)
applyButton.Text = "Apply"
applyButton.Font = Enum.Font.GothamBold
applyButton.TextSize = 18
applyButton.TextColor3 = Color3.fromRGB(255,255,255)
applyButton.BackgroundColor3 = Color3.fromRGB(70,130,180)
applyButton.BorderSizePixel = 0
applyButton.AutoButtonColor = true

applyButton.MouseButton1Click:Connect(function()
	local spd = tonumber(speedInput.Text)
	local jmp = tonumber(jumpInput.Text)
	if spd and spd > 0 then
		flySpeed = spd
	end
	if jmp and jmp > 0 then
		humanoid.JumpPower = jmp
	end
	speedInput.Text = ""
	jumpInput.Text = ""
end)

-- Botón Fly ON/OFF
local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(0, 80, 0, 30)
flyButton.Position = UDim2.new(0, 180, 0, 105)
flyButton.Text = "Fly OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 18
flyButton.TextColor3 = Color3.fromRGB(255,255,255)
flyButton.BackgroundColor3 = Color3.fromRGB(220,20,60)
flyButton.BorderSizePixel = 0
flyButton.AutoButtonColor = true

-- Joystick (simple, bonito)
local joystickFrame = Instance.new("Frame", screenGui)
joystickFrame.Size = UDim2.new(0, 120, 0, 120)
joystickFrame.Position = UDim2.new(0, 10, 1, -310)
joystickFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
joystickFrame.BackgroundTransparency = 0.15
joystickFrame.BorderSizePixel = 0
joystickFrame.AnchorPoint = Vector2.new(0,1)
joystickFrame.Name = "JoystickFrame"
joystickFrame.ClipsDescendants = true
joystickFrame.Visible = true

local outerCircle = Instance.new("ImageLabel", joystickFrame)
outerCircle.Size = UDim2.new(0, 120, 0, 120)
outerCircle.Position = UDim2.new(0, 0, 0, 0)
outerCircle.BackgroundTransparency = 1
outerCircle.Image = "rbxassetid://3570695787" -- círculo transparente con borde
outerCircle.ImageColor3 = Color3.fromRGB(80,80,80)

local innerCircle = Instance.new("ImageLabel", outerCircle)
innerCircle.Size = UDim2.new(0, 60, 0, 60)
innerCircle.Position = UDim2.new(0.5, -30, 0.5, -30)
innerCircle.BackgroundTransparency = 1
innerCircle.Image = "rbxassetid://3570695787"
innerCircle.ImageColor3 = Color3.fromRGB(150,150,150)

-- Manejo del joystick para móvil
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStartPos = nil
local innerStartPos = nil
local maxRadius = 50

outerCircle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStartPos = input.Position
		innerStartPos = innerCircle.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				moveVector = Vector3.new(0,0,0)
				innerCircle.Position = UDim2.new(0.5, -30, 0.5, -30)
			end
		end)
	end
end)

outerCircle.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStartPos
		local clampedDelta = Vector2.new(math.clamp(delta.X, -maxRadius, maxRadius), math.clamp(delta.Y, -maxRadius, maxRadius))
		innerCircle.Position = UDim2.new(0.5, clampedDelta.X - 30, 0.5, clampedDelta.Y - 30)

		-- joystick arriba es Z negativo, abajo es Z positivo, izquierda es X negativo, derecha X positivo
		moveVector = Vector3.new(clampedDelta.X / maxRadius, 0, -clampedDelta.Y / maxRadius)
	end
end)

-- Volar: agregar BodyVelocity al rootPart
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(0,0,0)
bodyVelocity.Velocity = Vector3.new(0,0,0)
bodyVelocity.Parent = rootPart

local function toggleFly()
	if flying == false then
		flying = true
		flyButton.Text = "Fly ON"
		flyButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34) -- verde
		humanoid.PlatformStand = true
		bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
	else
		flying = false
		flyButton.Text = "Fly OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(220,20,60) -- rojo
		humanoid.PlatformStand = false
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.MaxForce = Vector3.new(0,0,0)
		moveVector = Vector3.new(0,0,0)
		verticalMove = 0
	end
end

flyButton.MouseButton1Click:Connect(toggleFly)
flyButton.TouchTap:Connect(toggleFly)

-- Volar verticalmente con botones o teclas (para móvil dejamos vacío o podrías hacer botones para arriba/abajo)
-- Por ahora solo volar con joystick horizontal y velocidad fija vertical 0

-- Actualizar vuelo cada frame
runService.RenderStepped:Connect(function()
	if flying then
		local camera = workspace.CurrentCamera
		local camCFrame = camera.CFrame

		local dir = Vector3.new(moveVector.X, 0, moveVector.Z)
		if dir.Magnitude > 0 then
			dir = (camCFrame.RightVector * moveVector.X + camCFrame.LookVector * moveVector.Z).Unit
		else
			dir = Vector3.new(0,0,0)
		end

		local vel = dir * flySpeed + Vector3.new(0, verticalMove * flySpeed, 0)
		bodyVelocity.Velocity = vel
	else
		bodyVelocity.Velocity = Vector3.new(0,0,0)
	end
end)
