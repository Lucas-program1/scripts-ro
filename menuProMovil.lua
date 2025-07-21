local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Detectar controles móviles
local controlModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyGui"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = true

-- Label Speed
local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Text = "Velocidad:"
speedLabel.Size = UDim2.new(0, 100, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1

local speedInput = Instance.new("TextBox", mainFrame)
speedInput.Text = "50"
speedInput.Size = UDim2.new(0, 50, 0, 30)
speedInput.Position = UDim2.new(0, 110, 0, 10)
speedInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.ClearTextOnFocus = false

-- Label JumpPower
local jumpLabel = Instance.new("TextLabel", mainFrame)
jumpLabel.Text = "JumpPower:"
jumpLabel.Size = UDim2.new(0, 100, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, 50)
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.BackgroundTransparency = 1

local jumpInput = Instance.new("TextBox", mainFrame)
jumpInput.Text = tostring(humanoid.JumpPower)
jumpInput.Size = UDim2.new(0, 50, 0, 30)
jumpInput.Position = UDim2.new(0, 110, 0, 50)
jumpInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
jumpInput.TextColor3 = Color3.new(1,1,1)
jumpInput.ClearTextOnFocus = false

-- Botón Fly
local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Text = "Fly OFF"
flyButton.Size = UDim2.new(0, 100, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 100)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1,1,1)

-- Minimizar
local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Text = "-"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
minimizeButton.TextColor3 = Color3.new(1,1,1)

-- Variables
local flying = false
local flySpeed = 50
local bodyVelocity = Instance.new("BodyVelocity", root)
bodyVelocity.MaxForce = Vector3.new()
bodyVelocity.Velocity = Vector3.new()

-- Función actualizar velocidad y salto
local function updateStats()
	local spd = tonumber(speedInput.Text)
	local jmp = tonumber(jumpInput.Text)
	if spd then
		flySpeed = spd
	end
	if jmp then
		humanoid.JumpPower = jmp
	end
end

-- Activar vuelo
local function toggleFly()
	updateStats()
	flying = not flying
	flyButton.Text = flying and "Fly ON" or "Fly OFF"
	humanoid.PlatformStand = flying
	bodyVelocity.MaxForce = flying and Vector3.new(1e5,1e5,1e5) or Vector3.new()
	bodyVelocity.Velocity = Vector3.zero
end

-- Botones
flyButton.MouseButton1Click:Connect(toggleFly)

minimizeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	local openBtn = Instance.new("TextButton", gui)
	openBtn.Text = "🐧"
	openBtn.Size = UDim2.new(0, 40, 0, 40)
	openBtn.Position = UDim2.new(0, 20, 0, 20)
	openBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	openBtn.TextColor3 = Color3.new(1,1,1)
	openBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = true
		openBtn:Destroy()
	end)
end)

-- Movimiento vuelo
RunService.RenderStepped:Connect(function()
	if flying then
		local moveVec = controlModule:GetMoveVector()
		local cam = workspace.CurrentCamera.CFrame
		if moveVec.Magnitude > 0 then
			local direction = (cam.LookVector * moveVec.Z + cam.RightVector * moveVec.X).Unit
			bodyVelocity.Velocity = direction * flySpeed
		else
			bodyVelocity.Velocity = Vector3.zero
		end
	end
end)
