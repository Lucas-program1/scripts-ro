local Rayfield = loadstring(game:HttpGet('https://[Log in to view URL]'))()

local Window = Rayfield:CreateWindow({
   Name = "Speed JumpPower Fly | Script",
   LoadingTitle = "Speed JumpPower Fly Script",
   LoadingSubtitle = "By Mr.Shadow",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Example Hub"
   },
   Discord = {
      Enabled = enable,
      Invite = "MyGb57Xpyb", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key | Speed JumPower Fly Script Hub",
      Subtitle = "Key System",
      Note = "Key In Discord Server",
      FileName = "Key In Discord Server", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hacks"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Main", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "You executed the script",
   Content = "Did You Like This?",
   Duration = 5,
   Image = 13047715178,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Yes!",
         Callback = function()
         print("He Is Like This")
      end
   },
},
})

local Button = MainTab:CreateButton({
   Name = "Infinite Jump Hack",
   Callback = function()
       -- Toggles the infinite jump between on or off on every script run
       _G.infinjump = not _G.infinjump

       if _G.infinJumpStarted == nil then
           -- Ensures this only runs once to save resources
           _G.infinJumpStarted = true
           
           -- Notifies readiness
           game.StarterGui:SetCore("SendNotification", {Title="Youtube Hub"; Text="Infinite Jump Activated!"; Duration=5;})

           -- The actual infinite jump
           local plr = game:GetService('Players').LocalPlayer
           local m = plr:GetMouse()
           m.KeyDown:connect(function(k)
               if _G.infinjump then
                   if k:byte() == 32 then
                   humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                   humanoid:ChangeState('Jumping')
                   wait()
                   humanoid:ChangeState('Seated')
                   end
               end
           end)
       end
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "WalkSpeed Hack",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderws", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "JumpPower Hack",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "sliderjp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- Fly toggle function
local flying = false
local flySpeed = 1
local flyDirection = Vector3.new(0, 0, 0) -- Başlangıçta hareket etmeyen bir yön

local function toggleFly()
    flying = not flying
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")

    if flying then
        local bg = Instance.new("BodyGyro", torso)
        local bv = Instance.new("BodyVelocity", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        -- Klavye girişini dinlemek ve hareket yönünü ayarlamak
        local userInputService = game:GetService("UserInputService")

        function onInputBegan(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W then
                    flyDirection = workspace.CurrentCamera.CFrame.lookVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.A then
                    flyDirection = -workspace.CurrentCamera.CFrame.rightVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.S then
                    flyDirection = -workspace.CurrentCamera.CFrame.lookVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.D then
                    flyDirection = workspace.CurrentCamera.CFrame.rightVector * flySpeed
                end
            end
        end

        function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or
                   input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
                    flyDirection = Vector3.new(0, 0, 0)
                end
            end
        end

        userInputService.InputBegan:Connect(onInputBegan)
        userInputService.InputEnded:Connect(onInputEnded)

        repeat
            wait()
            hum.PlatformStand = true
            bv.velocity = flyDirection + Vector3.new(0, 0.1, 0)
            bg.cframe = workspace.CurrentCamera.CFrame
        until not flying

        hum.PlatformStand = false
        bg:Destroy()
        bv:Destroy()

        userInputService.InputBegan:Disconnect(onInputBegan)
        userInputService.InputEnded:Disconnect(onInputEnded)
    end
end

-- Fly speed slider
local FlySpeedSlider = MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = flySpeed,
    Flag = "flyspeedslider",
    Callback = function(Value)
        flySpeed = Value
    end,
})

-- Fly button
local Button = MainTab:CreateButton({
    Name = "Toggle Fly",
    Callback = function()
        toggleFly()
    end,
})

local OtherTab = Window:CreateTab("Other", nil) -- Title, Image
local OtherSection = OtherTab:CreateSection("Other")

local Toggle = OtherTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       local noclip = Value
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()

       if noclip then
           character.Humanoid:ChangeState(11)
           game:GetService('RunService').Stepped:Connect(function()
               if noclip then
                   character.Humanoid:ChangeState(11)
               end
           end)
       else
           character.Humanoid:ChangeState(0)
       end
   end,
})
