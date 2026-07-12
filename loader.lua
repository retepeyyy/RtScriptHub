local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local function getChar() return player.Character end
local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getHRP()
    local c = getChar()
    return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
end

local gui = Instance.new("ScreenGui")
gui.Name = "r00guı"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 520) 
frame.Position = UDim2.new(0.05, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(0, 255, 0)
outline.Thickness = 3
outline.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
title.Text = "R00GUİ"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local function createButton(text, order, widthMod)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(widthMod or 1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 50 + (order - 1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = frame
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 180, 0)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local function createTextBox(placeholder, order)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 70, 0, 35)
    box.Position = UDim2.new(1, -85, 0, 50 + (order - 1) * 40)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Code
    box.TextSize = 14
    box.Parent = frame
    Instance.new("UIStroke", box).Color = Color3.fromRGB(0, 255, 0)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    return box
end

local speedActive, jumpActive, flyActive = false, false, false
local noclipActive, halkaActive = false, false
local angle = 0

local speedBtn = createButton("HIZ MODU", 1, 0.7)
local speedInput = createTextBox("100", 1)

local jumpBtn = createButton("ZIPLAMA MODU", 2, 0.7)
local jumpInput = createTextBox("150", 2)

local flyBtn = createButton("UÇMA MODU", 3, 1)
local noclipBtn = createButton("NO CLIP", 4, 1)
local halkaBtn = createButton("İNANILMAZ HALKA: KAPALI", 5, 1)
local tpFwd = createButton("50 METRE İLERİ IŞINLAN", 6, 1)
local resetBtn = createButton("KARAKTERİ SIFIRLA", 7, 1)
local hideBtn = createButton("MENÜYÜ GİZLE (U)", 8, 1)

local loadR6Btn = createButton("R6 Script Çalıştır", 9, 1)
local loadR15Btn = createButton("R15 Script Çalıştır", 10, 1)

local flingInput = createTextBox("Oyuncu İsmi", 11)
local flingButton = createButton("Fling Yap", 12, 1)

local function effect()
    local s = Instance.new("Sound", player.PlayerGui)
    s.SoundId = "rbxassetid://18435246"
    s:Play()
    Debris:AddItem(s, 2)
end

RunService.Heartbeat:Connect(function(dt)
    local char = getChar()
    local hrp = getHRP()
    local hum = getHumanoid()

    if hum then
        if speedActive then hum.WalkSpeed = tonumber(speedInput.Text) or 100 end
        if jumpActive then 
            hum.UseJumpPower = true 
            hum.JumpPower = tonumber(jumpInput.Text) or 150 
        end
    end

    if noclipActive and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if halkaActive and hrp then
        angle = angle + dt * 20
        local radius = 10
        
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(char) then
                local dist = (part.Position - hrp.Position).Magnitude
                if dist < 25 then
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    part.Velocity = Vector3.new(0, 5, 0)
                    part.CFrame = part.CFrame:Lerp(CFrame.new(hrp.Position + Vector3.new(x, 2, z)), 0.1)
                end
            end
        end
    end
end)

-- Butonların fonksiyonelliği
halkaBtn.MouseButton1Click:Connect(function()
    halkaActive = not halkaActive
    halkaBtn.Text = halkaActive and "İNANILMAZ HALKA: AKTİF" or "İNANILMAZ HALKA: KAPALI"
    halkaBtn.BackgroundColor3 = halkaActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(0, 30, 0)
    effect()
end)

speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.Text = speedActive and "HIZ: AKTİF" or "HIZ MODU"
    effect()
end)

jumpBtn.MouseButton1Click:Connect(function()
    jumpActive = not jumpActive
    jumpBtn.Text = jumpActive and "ZIPLAMA: AKTİF" or "ZIPLAMA MODU"
    effect()
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    noclipBtn.Text = noclipActive and "NO CLIP: AKTİF" or "NO CLIP"
    effect()
end)

local flyBV, flyBG
flyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    local hrp = getHRP()
    if flyActive and hrp then
        flyBtn.Text = "UÇMA: AKTİF"
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBG = Instance.new("BodyGyro", hrp)
        flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        task.spawn(function()
            while flyActive and getHRP() do
                local move = Vector3.zero
                local cam = workspace.CurrentCamera.CFrame
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
                flyBV.Velocity = move.Magnitude > 0 and move.Unit * 100 or Vector3.zero
                flyBG.CFrame = cam
                task.wait()
            end
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
        end)
    else
        flyActive = false
        flyBtn.Text = "UÇMA: KAPALI"
    end
end)

tpFwd.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -50) end
end)

resetBtn.MouseButton1Click:Connect(function()
    local hum = getHumanoid()
    if hum then hum.Health = 0 end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.U then
        frame.Visible = not frame.Visible
    end
end)

print("R00GUI Modu Yuklendi! 'U' ile gizle.")

local function flingPlayer(targetName)
    local targetPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower() == targetName:lower() then
            targetPlayer = plr
            break
        end
    end
    if targetPlayer and targetPlayer.Character then
        local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local flingForce = Instance.new("BodyVelocity")
            flingForce.Velocity = Vector3.new(math.random(-50,50), math.random(50,100), math.random(-50,50))
            flingForce.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flingForce.Parent = hrp
            game:GetService("Debris"):AddItem(flingForce, 1)
        end
    end
end

local flingBtn = createButton("Fling Yap", 12, 1)

flingBtn.MouseButton1Click:Connect(function()
    local targetName = flingInput.Text
    if targetName == "" then
        warn("Lütfen oyuncu ismi girin.")
        return
    end
    flingPlayer(targetName)
end)
