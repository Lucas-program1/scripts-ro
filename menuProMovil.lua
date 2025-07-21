local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ControlModule para móvil
local controlModule = require(player:WaitForChild("PlayerScripts")
	:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 140)
frame.Position = UDim2.new(0, 10, 1, -160)
frame.AnchorPoint = Vector2.new(0, 1)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

-- Inputs
local speedInput = Instance.new("TextBox", frame)
speedInput.PlaceholderText = "Speed"
speedInput.Size = UDim2.new(0, 80, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 10)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.TextColor3 = Color3.new(1, 1, 1)

local jumpInput = Instance.new("TextBox", frame)
jumpInput.PlaceholderText = "JumpPower"
jumpInput.Size = UDim2.new(0, 80, 0, 30)
jumpInput.Position = UDim2.new(0, 100, 0, 10)
jumpInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpInput.TextColor3 = Color3.new(1, 1, 1)

local applyButton = Instance.new("TextButton", frame)
applyButton.Text = "Aplicar"
applyButton.Size = UDim2.new(0, 60, 0, 30)
applyButton.Position = UDim2.new(0, 190, 0, 10)
applyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
applyButton.TextColor3 = Color3.new(1, 1, 1)

-- Fly toggle
local flyButton = Instance.new("TextButton", frame)
flyButton.Text = "Fly OFF"
flyButton.Size = UDim2.new(0, 100, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 60)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)

-- Minimizar
local minButton = Instance.new("TextButton", frame)
minButton.Text = "-"
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -35, 0, 5)
minButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minButton.TextColor3 = Color3.new(1, 1, 1)

-- Variables de vuelo
local flying = false
local flySpeed = 50
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new()
bodyVelocity.P = 1250
bodyVelocity.Velocity = Vector3.new()
bodyVelocity.Parent = rootPart

-- Funciones
local function updateStats()
	local speed = tonumber(speedInput.Text)
	local jump = tonumber(jumpInput.Text)
	if speed and speed > 0 then flySpeed = speed end
	if jump and jump > 0 then humanoid.JumpPower = jump end
end

local function toggleFly()
	flying = not flying
	flyButton.Text = flying and "Fly ON" or "Fly OFF"
	humanoid.PlatformStand = flying
	bodyVelocity.MaxForce = flying and Vector3.new(1e5, 1e5, 1e5) or Vector3.zero
end

applyButton.MouseButton1Click:Connect(updateStats)
flyButton.MouseButton1Click:Connect(toggleFly)

-- Minimizar
minButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	local openButton = Instance.new("TextButton", gui)
	openButton.Text = "🐧"
	openButton.Size = UDim2.new(0, 40, 0, 40)
	openButton.Position = UDim2.new(0, 15, 0, 15)
	openButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	openButton.TextColor3 = Color3.new(1, 1, 1)

	openButton.MouseButton1Click:Connect(function()
		frame.Visible = true
		openButton:Destroy()
	end)
end)

-- Movimiento en vuelo
RunService.RenderStepped:Connect(function()
	if flying then
		local move = controlModule:GetMoveVector()
		local cam = workspace.CurrentCamera.CFrame
		local direction = (cam.LookVector * move.Z + cam.RightVector * move.X).Unit
		if move.Magnitude > 0 then
			bodyVelocity.Velocity = direction * flySpeed
		else
			bodyVelocity.Velocity = Vector3.zero
		end
	end
end)
