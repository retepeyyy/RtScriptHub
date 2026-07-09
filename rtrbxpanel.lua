local ReplicatedStorage = game:GetService("ReplicatedStorage")


local event = ReplicatedStorage:FindFirstChild("PanelEvent")
if not event then
	event = Instance.new("RemoteEvent")
	event.Name = "PanelEvent"
	event.Parent = ReplicatedStorage
end


event.OnServerEvent:Connect(function(player, action, targetName, extra)

	if action == "Fling" then
		local target = game.Players:FindFirstChild(targetName)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = target.Character.HumanoidRootPart
			local bv = Instance.new("BodyAngularVelocity")
			bv.AngularVelocity = Vector3.new(0, 99999, 0)
			bv.MaxTorque = Vector3.new(0, 99999, 0)
			bv.P = 1250
			bv.Parent = hrp
			task.wait(0.3)
			bv:Destroy()
			hrp.Velocity = Vector3.new(0, 5000, 0)
		end


	elseif action == "Message" then
		for _, p in pairs(game.Players:GetPlayers()) do
			event:FireClient(p, "ShowMessage", extra)
		end


	elseif action == "Hell" then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
				local fire = Instance.new("Fire")
				fire.Size = 10
				fire.Heat = 10
				fire.Parent = obj
			end
		end
	end
end)

-- LOCAL SCRIPT (StarterGui içinde olmalı)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- 1. EVENTIN OLUSMASINI BEKLE (Sunucu olusturana kadar durur)
local event = ReplicatedStorage:WaitForChild("PanelEvent")

-- 2. YESIL TEMA AYARLARI
local BACKGROUND_COLOR = Color3.fromRGB(10, 25, 10)
local BUTTON_COLOR = Color3.fromRGB(0, 160, 0)
local ACCENT_GREEN = Color3.fromRGB(0, 255, 0)

-- 3. GUI TASARIMI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "AutoChaosPanel"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 440)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = BACKGROUND_COLOR
mainFrame.BorderColor3 = ACCENT_GREEN
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "HACKER PANEL [V4]"
title.TextColor3 = ACCENT_GREEN
title.Font = Enum.Font.Code
title.TextSize = 18
title.BackgroundTransparency = 1

-- BUTON FABRIKASI
local function createBtn(text, pos, color)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Size = UDim2.new(0, 200, 0, 35)
	btn.Position = pos
	btn.BackgroundColor3 = color or BUTTON_COLOR
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	Instance.new("UICorner", btn)
	return btn
end

-- NESNELER
local flyBtn = createBtn("Fly: KAPALI", UDim2.new(0, 20, 0, 50))
local noclipBtn = createBtn("Noclip: KAPALI", UDim2.new(0, 20, 0, 90))
local espBtn = createBtn("ESP: KAPALI", UDim2.new(0, 20, 0, 130))

local flingInput = Instance.new("TextBox", mainFrame)
flingInput.Size = UDim2.new(0, 200, 0, 30)
flingInput.Position = UDim2.new(0, 20, 0, 175)
flingInput.PlaceholderText = "Oyuncu Adi..."
flingInput.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
flingInput.TextColor3 = Color3.new(1,1,1)

local flingBtn = createBtn("FLING YAP", UDim2.new(0, 20, 0, 210))

local msgInput = Instance.new("TextBox", mainFrame)
msgInput.Size = UDim2.new(0, 200, 0, 30)
msgInput.Position = UDim2.new(0, 20, 0, 260)
msgInput.PlaceholderText = "Ekrana Mesaj Yaz..."
msgInput.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
msgInput.TextColor3 = Color3.new(1,1,1)

local msgBtn = createBtn("MESAJI YAYINLA", UDim2.new(0, 20, 0, 295))
local hellBtn = createBtn("CEHENNEM MODU", UDim2.new(0, 20, 0, 360), Color3.fromRGB(180, 0, 0))

-- 4. OZELLIK MANTIKLARI
local flying, noclip, esp = false, false, false

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly: " .. (flying and "ACIK" or "KAPALI")
	if flying then
		local bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		task.spawn(function()
			while flying do
				rs.RenderStepped:Wait()
				bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
			end
			bv:Destroy()
		end)
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: " .. (noclip and "ACIK" or "KAPALI")
end)

rs.Stepped:Connect(function()
	if noclip and player.Character then
		for _, p in pairs(player.Character:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP: " .. (esp and "ACIK" or "KAPALI")
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character then
			local hl = p.Character:FindFirstChild("ESPHL") or Instance.new("Highlight", p.Character)
			hl.Name = "ESPHL"
			hl.Enabled = esp
			hl.FillColor = ACCENT_GREEN
		end
	end
end)

flingBtn.MouseButton1Click:Connect(function() event:FireServer("Fling", flingInput.Text) end)
msgBtn.MouseButton1Click:Connect(function() event:FireServer("Message", nil, msgInput.Text) end)
hellBtn.MouseButton1Click:Connect(function() event:FireServer("Hell") end)

event.OnClientEvent:Connect(function(type, text)
	if type == "ShowMessage" then
		local m = Instance.new("TextLabel", screenGui)
		m.Size = UDim2.new(1, 0, 0, 80)
		m.Position = UDim2.new(0, 0, 0.4, 0)
		m.BackgroundColor3 = Color3.new(0,0,0)
		m.BackgroundTransparency = 0.5
		m.Text = text
		m.TextColor3 = ACCENT_GREEN
		m.TextSize = 40
		m.Font = Enum.Font.Code
		task.wait(3)
		m:Destroy()
	end
end)
