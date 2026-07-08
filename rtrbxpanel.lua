local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("PanelEvent")

event.OnServerEvent:Connect(function(player, action, targetName, extra)
	if action == "Fling" then
		local target = game.Players:FindFirstChild(targetName)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = target.Character.HumanoidRootPart
			local velocity = Instance.new("BodyAngularVelocity")
			velocity.AngularVelocity = Vector3.new(0, 99999, 0)
			velocity.MaxTorque = Vector3.new(0, 99999, 0)
			velocity.P = 1250
			velocity.Parent = hrp
			task.wait(0.3)
			velocity:Destroy()
			hrp.Velocity = Vector3.new(0, 5000, 0)
		end
		
	elseif action == "Message" then
		for _, p in pairs(game.Players:GetPlayers()) do
			event:FireClient(p, "ShowMessage", extra)
		end
		
	elseif action == "Hell" then
		-- CEHENNEM ÖZELLİĞİ: Haritadaki her şeye ateş ekler
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

local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local event = game:GetService("ReplicatedStorage"):WaitForChild("PanelEvent")

-- TEMA AYARLARI
local BACKGROUND_COLOR = Color3.fromRGB(5, 20, 5)
local BUTTON_COLOR = Color3.fromRGB(0, 120, 0)
local ACCENT_GREEN = Color3.fromRGB(0, 255, 0)
local HELL_COLOR = Color3.fromRGB(200, 0, 0) -- Cehennem butonu için kırmızımsı

-- UI PANEL OLUŞTURMA
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "ChaosPanelV3"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 430) -- Boyut biraz daha büyüdü
mainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
mainFrame.BackgroundColor3 = BACKGROUND_COLOR
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = ACCENT_GREEN
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "HACKER PANEL [V3.0]"
title.TextColor3 = ACCENT_GREEN
title.TextSize = 16
title.Font = Enum.Font.Code
title.BackgroundTransparency = 1

-- YARDIMCI BUTON FONKSİYONU
local function createBtn(name, text, pos, color)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Name = name
	btn.Size = UDim2.new(0, 200, 0, 35)
	btn.Position = pos
	btn.BackgroundColor3 = color or BUTTON_COLOR
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	return btn
end

-- ÖZELLİKLERİ EKLE
local flyBtn = createBtn("Fly", "Uçma: KAPALI", UDim2.new(0.5, -100, 0, 45))
local noclipBtn = createBtn("Noclip", "Noclip: KAPALI", UDim2.new(0.5, -100, 0, 85))
local espBtn = createBtn("ESP", "ESP: KAPALI", UDim2.new(0.5, -100, 0, 125))

local flingInput = Instance.new("TextBox", mainFrame)
flingInput.Size = UDim2.new(0, 200, 0, 30)
flingInput.Position = UDim2.new(0.5, -100, 0, 170)
flingInput.PlaceholderText = "Oyuncu Adı..."
flingInput.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
flingInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", flingInput)

local flingBtn = createBtn("Fling", "FLING YAP", UDim2.new(0.5, -100, 0, 205))

local msgInput = Instance.new("TextBox", mainFrame)
msgInput.Size = UDim2.new(0, 200, 0, 30)
msgInput.Position = UDim2.new(0.5, -100, 0, 250)
msgInput.PlaceholderText = "Ekran Mesajı Yaz..."
msgInput.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
msgInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", msgInput)

local msgBtn = createBtn("Msg", "MESAJ GÖNDER", UDim2.new(0.5, -100, 0, 285))

-- AYIRICI ÇİZGİ
local line = Instance.new("Frame", mainFrame)
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 335)
line.BackgroundColor3 = ACCENT_GREEN
line.BorderSizePixel = 0

-- CEHENNEM BUTONU (ÖZEL)
local hellBtn = createBtn("Hell", "CEHENNEM MODU", UDim2.new(0.5, -100, 0, 355), HELL_COLOR)
hellBtn.TextSize = 18

-- MANTIK (LOGIC)
local flying, noclip, esp = false, false, false
local speed = 70

-- Fly
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Uçma: " .. (flying and "AÇIK" or "KAPALI")
	if flying then
		local bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		task.spawn(function()
			while flying do
				rs.RenderStepped:Wait()
				bv.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * speed
			end
			bv:Destroy()
		end)
	end
end)

-- Noclip
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: " .. (noclip and "AÇIK" or "KAPALI")
end)
rs.Stepped:Connect(function()
	if noclip and player.Character then
		for _, v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

-- ESP
espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP: " .. (esp and "AÇIK" or "KAPALI")
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character then
			local char = p.Character
			local hl = char:FindFirstChild("ESPHL") or Instance.new("Highlight", char)
			hl.Name = "ESPHL"
			hl.Enabled = esp
			hl.FillColor = ACCENT_GREEN
		end
	end
end)

-- Fling & Message
flingBtn.MouseButton1Click:Connect(function() event:FireServer("Fling", flingInput.Text) end)
msgBtn.MouseButton1Click:Connect(function() event:FireServer("Message", nil, msgInput.Text) end)

-- CEHENNEM TETİKLEYİCİ
hellBtn.MouseButton1Click:Connect(function()
	event:FireServer("Hell")
	hellBtn.Text = "YANIYOR!"
	task.wait(2)
	hellBtn.Text = "CEHENNEM MODU"
end)

-- EKRAN MESAJI ALICISI
event.OnClientEvent:Connect(function(type, text)
	if type == "ShowMessage" then
		local m = Instance.new("TextLabel", screenGui)
		m.Size = UDim2.new(1, 0, 0, 100)
		m.Position = UDim2.new(0, 0, 0.4, 0)
		m.BackgroundColor3 = Color3.new(0,0,0)
		m.BackgroundTransparency = 0.5
		m.Text = text
		m.TextColor3 = ACCENT_GREEN
		m.TextSize = 50
		m.Font = Enum.Font.Code
		task.wait(3)
		m:Destroy()
	end
end)