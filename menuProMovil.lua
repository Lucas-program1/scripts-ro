local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ControlModule usado para detectar movimiento móvil correctamente
local controlModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

-- Crear GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

-- Labels e inputs
local speedInput = Instance.new("TextBox", frame)
speedInput.PlaceholderText = "Speed"
speedInput.Position = UDim2.new(0,10,0,10)
speedInput.Size = UDim2.new(0,80,0,30)
speedInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedInput.TextColor3 = Color3.new(1,1,1)

local jumpInput = Instance.new("TextBox", frame)
jumpInput.PlaceholderText = "JumpPower"
jumpInput.Position = UDim2.new(0,100,0,10)
jumpInput.Size = UDim2.new(0,80,0,30)
jumpInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
jumpInput.TextColor3 = Color3.new(1,1,1)

-- Botones
local applyBtn = Instance.new("TextButton", frame)
applyBtn.Text = "Aplicar"
applyBtn.Position = UDim2.new(0,190,0,10)
applyBtn.Size = UDim2.new(0,60,0,30)
applyBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
applyBtn.TextColor3 = Color3.new(1,1,1)

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Text = "Fly OFF"
flyBtn.Position = UDim2.new(0,10,0,50)
flyBtn.Size = UDim2.new(0,100,0,40)
flyBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
flyBtn.TextColor3 = Color3.new(1,1,1)

local minBtn = Instance.new("TextButton", frame)
minBtn.Text = "-"
minBtn.Position = UDim2.new(1,-40,0,5)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
minBtn.TextColor3 = Color3.new(1,1,1)

-- Estado interno
local flying = false
local flySpeed = 50
local bodyVel = Instance.new("BodyVelocity", root)
bodyVel.MaxForce = Vector3.new()
bodyVel.Velocity = Vector3.new()

-- Funciones de control
local function actualizarStats()
	local s = tonumber(speedInput.Text)
	local j = tonumber(jumpInput.Text)
	if s and s > 0 then flySpeed = s end
	if j and j > 0 then humanoid.JumpPower = j end
end

local function toggleFly()
	actualizarStats()
	flying = not flying
	flyBtn.Text = flying and "Fly ON" or "Fly OFF"
	humanoid.PlatformStand = flying
	bodyVel.MaxForce = flying and Vector3.new(1e5,1e5,1e5) or Vector3.new()
	bodyVel.Velocity = Vector3.new()
end

applyBtn.MouseButton1Click:Connect(actualizarStats)
flyBtn.MouseButton1Click:Connect(toggleFly)
flyBtn.TouchTap:Connect(toggleFly)

minBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	local openBtn = Instance.new("TextButton", gui)
	openBtn.Text = "🐧"
	openBtn.Size = UDim2.new(0,40,0,40)
	openBtn.Position = UDim2.new(0,20,0,20)
	openBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	openBtn.TextColor3 = Color3.new(1,1,1)
	openBtn.MouseButton1Click:Connect(function()
		frame.Visible = true
		openBtn:Destroy()
	end)
end)

-- Movimiento suave en vuelo
RunService.RenderStepped:Connect(function()
	if flying then
		local mv = controlModule:GetMoveVector()
		if mv.Magnitude > 0 then
			local cam = workspace.CurrentCamera.CFrame
			local dir = (cam.LookVector * mv.Z + cam.RightVector * mv.X).Unit
			bodyVel.Velocity = dir * flySpeed
		else
			bodyVel.Velocity = Vector3.new()
		end
	end
end)
