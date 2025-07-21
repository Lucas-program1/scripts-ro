local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- Variables
local flying = false
local flySpeed = 50
local moveVec = Vector3.zero
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.zero
bv.P = 1250
bv.Parent = rootPart

-- Interfaz principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 150)
frame.Position = UDim2.new(0, 10, 1, -170)
frame.AnchorPoint = Vector2.new(0, 1)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.05

-- Input Speed
local speedInput = Instance.new("TextBox", frame)
speedInput.PlaceholderText = "Speed (50)"
speedInput.Size = UDim2.new(0, 80, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 10)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.ClearTextOnFocus = true

-- Input JumpPower
local jumpInput = Instance.new("TextBox", frame)
jumpInput.PlaceholderText = "Jump (50)"
jumpInput.Size = UDim2.new(0, 80, 0, 30)
jumpInput.Position = UDim2.new(0, 100, 0, 10)
jumpInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpInput.ClearTextOnFocus = true

-- Botón aplicar
local applyBtn = Instance.new("TextButton", frame)
applyBtn.Text = "Aplicar"
applyBtn.Size = UDim2.new(0, 70, 0, 30)
applyBtn.Position = UDim2.new(0, 190, 0, 10)
applyBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 200)
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

applyBtn.MouseButton1Click:Connect(function()
	local s = tonumber(speedInput.Text)
	local j = tonumber(jumpInput.Text)
	if s and s > 0 then flySpeed = s end
	if j and j > 0 then humanoid.JumpPower = j end
end)

-- Botón de vuelo
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Text = "Fly OFF"
flyBtn.Size = UDim2.new(0, 100, 0, 35)
flyBtn.Position = UDim2.new(0, 10, 0, 50)
flyBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local function toggleFly()
	flying = not flying
	if flying then
		flyBtn.Text = "Fly ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
		humanoid.PlatformStand = true
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	else
		flyBtn.Text = "Fly OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		humanoid.PlatformStand = false
		bv.MaxForce = Vector3.zero
		bv.Velocity = Vector3.zero
		moveVec = Vector3.zero
	end
end

flyBtn.MouseButton1Click:Connect(toggleFly)
flyBtn.TouchTap:Connect(toggleFly)

-- Joystick móvil
local joyFrame = Instance.new("Frame", gui)
joyFrame.Size = UDim2.new(0, 120, 0, 120)
joyFrame.Position = UDim2.new(0, 15, 1, -280)
joyFrame.AnchorPoint = Vector2.new(0, 1)
joyFrame.BackgroundTransparency = 1

local outer = Instance.new("ImageLabel", joyFrame)
outer.Size = UDim2.new(1, 0, 1, 0)
outer.Image = "rbxassetid://3570695787"
outer.ImageColor3 = Color3.fromRGB(80, 80, 80)
outer.BackgroundTransparency = 1

local inner = Instance.new("ImageLabel", outer)
inner.Size = UDim2.new(0, 50, 0, 50)
inner.Position = UDim2.new(0.5, 0, 0.5, 0)
inner.AnchorPoint = Vector2.new(0.5, 0.5)
inner.Image = "rbxassetid://3570695787"
inner.ImageColor3 = Color3.fromRGB(150, 150, 150)
inner.BackgroundTransparency = 1

local dragging, startPos
local radius = 50

outer.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		startPos = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				inner.Position = UDim2.new(0.5, 0, 0.5, 0)
				moveVec = Vector3.zero
			end
		end)
	end
end)

outer.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - startPos
		local dx = math.clamp(delta.X, -radius, radius)
		local dy = math.clamp(delta.Y, -radius, radius)
		inner.Position = UDim2.new(0.5, dx, 0.5, dy)
		moveVec = Vector3.new(dx / radius, 0, -dy / radius)
	end
end)

-- Movimiento de vuelo
RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera.CFrame
		local dir = cam.RightVector * moveVec.X + cam.LookVector * moveVec.Z
		if dir.Magnitude > 0 then dir = dir.Unit end
		bv.Velocity = dir * flySpeed
	end
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- Variables
local flying = false
local flySpeed = 50
local moveVec = Vector3.zero
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.zero
bv.P = 1250
bv.Parent = rootPart

-- Interfaz principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 150)
frame.Position = UDim2.new(0, 10, 1, -170)
frame.AnchorPoint = Vector2.new(0, 1)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.05

-- Input Speed
local speedInput = Instance.new("TextBox", frame)
speedInput.PlaceholderText = "Speed (50)"
speedInput.Size = UDim2.new(0, 80, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 10)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.ClearTextOnFocus = true

-- Input JumpPower
local jumpInput = Instance.new("TextBox", frame)
jumpInput.PlaceholderText = "Jump (50)"
jumpInput.Size = UDim2.new(0, 80, 0, 30)
jumpInput.Position = UDim2.new(0, 100, 0, 10)
jumpInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpInput.ClearTextOnFocus = true

-- Botón aplicar
local applyBtn = Instance.new("TextButton", frame)
applyBtn.Text = "Aplicar"
applyBtn.Size = UDim2.new(0, 70, 0, 30)
applyBtn.Position = UDim2.new(0, 190, 0, 10)
applyBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 200)
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

applyBtn.MouseButton1Click:Connect(function()
	local s = tonumber(speedInput.Text)
	local j = tonumber(jumpInput.Text)
	if s and s > 0 then flySpeed = s end
	if j and j > 0 then humanoid.JumpPower = j end
end)

-- Botón de vuelo
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Text = "Fly OFF"
flyBtn.Size = UDim2.new(0, 100, 0, 35)
flyBtn.Position = UDim2.new(0, 10, 0, 50)
flyBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local function toggleFly()
	flying = not flying
	if flying then
		flyBtn.Text = "Fly ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
		humanoid.PlatformStand = true
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	else
		flyBtn.Text = "Fly OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		humanoid.PlatformStand = false
		bv.MaxForce = Vector3.zero
		bv.Velocity = Vector3.zero
		moveVec = Vector3.zero
	end
end

flyBtn.MouseButton1Click:Connect(toggleFly)
flyBtn.TouchTap:Connect(toggleFly)

-- Joystick móvil
local joyFrame = Instance.new("Frame", gui)
joyFrame.Size = UDim2.new(0, 120, 0, 120)
joyFrame.Position = UDim2.new(0, 15, 1, -280)
joyFrame.AnchorPoint = Vector2.new(0, 1)
joyFrame.BackgroundTransparency = 1

local outer = Instance.new("ImageLabel", joyFrame)
outer.Size = UDim2.new(1, 0, 1, 0)
outer.Image = "rbxassetid://3570695787"
outer.ImageColor3 = Color3.fromRGB(80, 80, 80)
outer.BackgroundTransparency = 1

local inner = Instance.new("ImageLabel", outer)
inner.Size = UDim2.new(0, 50, 0, 50)
inner.Position = UDim2.new(0.5, 0, 0.5, 0)
inner.AnchorPoint = Vector2.new(0.5, 0.5)
inner.Image = "rbxassetid://3570695787"
inner.ImageColor3 = Color3.fromRGB(150, 150, 150)
inner.BackgroundTransparency = 1

local dragging, startPos
local radius = 50

outer.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		startPos = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				inner.Position = UDim2.new(0.5, 0, 0.5, 0)
				moveVec = Vector3.zero
			end
		end)
	end
end)

outer.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - startPos
		local dx = math.clamp(delta.X, -radius, radius)
		local dy = math.clamp(delta.Y, -radius, radius)
		inner.Position = UDim2.new(0.5, dx, 0.5, dy)
		moveVec = Vector3.new(dx / radius, 0, -dy / radius)
	end
end)

-- Movimiento de vuelo
RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera.CFrame
		local dir = cam.RightVector * moveVec.X + cam.LookVector * moveVec.Z
		if dir.Magnitude > 0 then dir = dir.Unit end
		bv.Velocity = dir * flySpeed
	end
end)
