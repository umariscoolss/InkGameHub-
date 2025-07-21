local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "InkGameHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 330)
frame.Position = UDim2.new(0.5, -250, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
topBar.BorderSizePixel = 0

local buttonHolder = Instance.new("Frame", topBar)
buttonHolder.Size = UDim2.new(1, 0, 1, 0)
buttonHolder.BackgroundTransparency = 1

local tabNames = {
	"Minigames", "Movement", "Utility", "Anti", "ESP", 
	"SafeZone", "Attach", "Theme", "Dev"
}
local tabFrames = {}

local layout = Instance.new("UIListLayout", buttonHolder)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)

for _, name in ipairs(tabNames) do
	local button = Instance.new("TextButton", buttonHolder)
	button.Size = UDim2.new(0, 90, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = name
	button.BorderSizePixel = 0
	button.Font = Enum.Font.Gotham
	button.TextSize = 14

	local tab = Instance.new("Frame", frame)
	tab.Name = name.."Tab"
	tab.Position = UDim2.new(0, 0, 0, 40)
	tab.Size = UDim2.new(1, 0, 1, -40)
	tab.BackgroundColor3 = Color3.fromRGB(25, 0, 35)
	tab.Visible = false

	tabFrames[name] = tab

	button.MouseButton1Click:Connect(function()
		for _, f in pairs(tabFrames) do f.Visible = false end
		tab.Visible = true
	end)
end

tabFrames["Minigames"].Visible = true
local tab = game.Players.LocalPlayer.PlayerGui.InkGameHub:FindFirstChild("MinigamesTab")
local plr = game.Players.LocalPlayer
local tab = plr.PlayerGui.InkGameHub:FindFirstChild("MinigamesTab")

function makeButton(name, callback)
	local btn = Instance.new("TextButton", tab)
	btn.Size = UDim2.new(0, 160, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(70, 0, 100)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = name
	btn.MouseButton1Click:Connect(callback)
	return btn
end

Instance.new("UIListLayout", tab).Padding = UDim.new(0, 4)

makeButton("Auto Win RLGL", function()
	if plr.Character then
		plr.Character:SetPrimaryPartCFrame(CFrame.new(0,0,300))
	end
end)

makeButton("Reveal Glass Bridge", function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") and v.Name:lower():find("glass") then
			v.Transparency = 0.5
			v.Material = Enum.Material.Neon
			v.Color = Color3.fromRGB(0,255,0)
		end
	end
end)

makeButton("Auto Walk Glass", function()
	if plr.Character then
		plr.Character:SetPrimaryPartCFrame(CFrame.new(0,0,300))
	end
end)

makeButton("Auto Dalgona", function()
	for _,v in pairs(plr.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.Name:lower():find("shape") then
			v.Transparency = 1
		end
	end
end)

makeButton("Auto Jump Rope", function()
	if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
		plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

makeButton("Auto Mingle Pair", function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ClickDetector") and v.Parent:IsA("Model") then
			fireclickdetector(v)
		end
	end
end)

makeButton("Hide&Seek Kill Hiders", function()
	for _,p in pairs(game.Players:GetPlayers()) do
		if p ~= plr and p.Team and tostring(p.Team):lower():find("hider") and p.Character and p.Character:FindFirstChild("Humanoid") then
			p.Character.Humanoid.Health = 0
		end
	end
end)

makeButton("Rebellion Kill Guards", function()
	for _,p in pairs(game.Players:GetPlayers()) do
		if p ~= plr and p.Team and tostring(p.Team):lower():find("guard") and p.Character and p.Character:FindFirstChild("Humanoid") then
			p.Character.Humanoid.Health = 0
		end
	end
end)
local RunService = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = plr:GetMouse()

local function getNearestGuard()
	local closest = nil
	local dist = math.huge
	for _,v in pairs(game.Players:GetPlayers()) do
		if v ~= plr and v.Team and tostring(v.Team):lower():find("guard") and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local pos = v.Character.HumanoidRootPart.Position
			local screenPos, visible = camera:WorldToViewportPoint(pos)
			if visible then
				local d = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
				if d < dist then
					dist = d
					closest = v
				end
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	local guard = getNearestGuard()
	if guard and guard.Character and guard.Character:FindFirstChild("HumanoidRootPart") then
		mouse.Target = guard.Character.HumanoidRootPart
	end
end)
local tab = plr.PlayerGui.InkGameHub:FindFirstChild("MovementTab")

function makeSlider(name, min, max, default, onChange)
	local label = Instance.new("TextLabel", tab)
	label.Size = UDim2.new(0, 160, 0, 20)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Text = name..": "..default

	local slider = Instance.new("TextBox", tab)
	slider.Size = UDim2.new(0, 160, 0, 25)
	slider.BackgroundColor3 = Color3.fromRGB(50, 0, 90)
	slider.TextColor3 = Color3.new(1,1,1)
	slider.Font = Enum.Font.Gotham
	slider.TextSize = 14
	slider.Text = tostring(default)

	slider.FocusLost:Connect(function()
		local value = tonumber(slider.Text)
		if value then
			if value < min then value = min end
			if value > max then value = max end
			label.Text = name..": "..value
			onChange(value)
		end
	end)
end

Instance.new("UIListLayout", tab).Padding = UDim.new(0, 5)

makeSlider("WalkSpeed", 16, 200, 50, function(v)
	if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
		plr.Character.Humanoid.WalkSpeed = v
	end
end)

makeSlider("JumpPower", 50, 300, 100, function(v)
	if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
		plr.Character.Humanoid.JumpPower = v
	end
end)

local noclip = false
local noclipBtn = Instance.new("TextButton", tab)
noclipBtn.Size = UDim2.new(0, 160, 0, 30)
noclipBtn.Text = "Toggle Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 130)
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Toggle Noclip: "..(noclip and "ON" or "OFF")
end)

game:GetService("RunService").Stepped:Connect(function()
	if noclip and plr.Character then
		for _,v in pairs(plr.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)
local plr = game.Players.LocalPlayer
local tab = plr.PlayerGui.InkGameHub:FindFirstChild("UtilityTab")

Instance.new("UIListLayout", tab).Padding = UDim.new(0, 5)

function makeButton(name, callback)
	local btn = Instance.new("TextButton", tab)
	btn.Size = UDim2.new(0, 160, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = name
	btn.MouseButton1Click:Connect(callback)
	return btn
end

makeButton("Auto Vote: Keep Playing", function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ClickDetector") and v.Parent:IsA("Model") and v.Parent.Name:lower():find("keep") then
			fireclickdetector(v)
		end
	end
end)

makeButton("Auto Vote: Stop Game", function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ClickDetector") and v.Parent:IsA("Model") and v.Parent.Name:lower():find("stop") then
			fireclickdetector(v)
		end
	end
end)

makeButton("Anti Void", function()
	game:GetService("RunService").Heartbeat:Connect(function()
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if plr.Character.HumanoidRootPart.Position.Y < -50 then
				plr.Character:SetPrimaryPartCFrame(CFrame.new(0,10,0))
			end
		end
	end)
end)

makeButton("Return to Spawn", function()
	if plr.Character then
		plr.Character:SetPrimaryPartCFrame(CFrame.new(0,10,0))
	end
end)

makeButton("Godmode RLGL", function()
	game:GetService("RunService").Heartbeat:Connect(function()
		if plr.Character and plr.Character:FindFirstChild("Humanoid") then
			plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
			plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		end
	end)
end)

makeButton("Reveal Glass Bridge", function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") and v.Name:lower():find("glass") then
			v.Transparency = 0.5
			v.Material = Enum.Material.Neon
			v.Color = Color3.fromRGB(0,255,0)
		end
	end
end)

makeButton("Auto Complete Glass", function()
	if plr.Character then
		plr.Character:SetPrimaryPartCFrame(CFrame.new(0,0,300))
	end
end)
local plr = game.Players.LocalPlayer
local tab = plr.PlayerGui.InkGameHub:FindFirstChild("AntiTab")

Instance.new("UIListLayout", tab).Padding = UDim.new(0, 5)

local safeEnabled = false
local returnOriginal = false
local savedPos = nil
local threshold = 30

local function makeToggle(name, stateFunc)
	local btn = Instance.new("TextButton", tab)
	btn.Size = UDim2.new(0, 160, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(100, 0, 120)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = name..": OFF"
	local on = false
	btn.MouseButton1Click:Connect(function()
		on = not on
		btn.Text = name..": "..(on and "ON" or "OFF")
		stateFunc(on)
	end)
end

makeToggle("Anti Ragdoll + Stun", function(on)
	if on then
		game:GetService("RunService").Heartbeat:Connect(function()
			if plr.Character and plr.Character:FindFirstChild("Humanoid") then
				plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			end
		end)
	end
end)

makeToggle("Anti Fling", function(on)
	if on then
		game:GetService("RunService").Stepped:Connect(function()
			for _,v in pairs(game.Players:GetPlayers()) do
				if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
					local root = v.Character.HumanoidRootPart
					if root.Velocity.Magnitude > 1000 then
						root.Velocity = Vector3.new()
					end
				end
			end
		end)
	end
end)

makeToggle("Anti Death", function(on)
	safeEnabled = on
end)

local label = Instance.new("TextLabel", tab)
label.Text = "Death Threshold: "..threshold
label.Size = UDim2.new(0, 160, 0, 20)
label.TextColor3 = Color3.fromRGB(255,255,255)
label.BackgroundTransparency = 1

local box = Instance.new("TextBox", tab)
box.Size = UDim2.new(0, 160, 0, 25)
box.BackgroundColor3 = Color3.fromRGB(50,0,60)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.Text = tostring(threshold)

box.FocusLost:Connect(function()
	local val = tonumber(box.Text)
	if val then
		threshold = val
		label.Text = "Death Threshold: "..val
	end
end)

makeToggle("Go To Safe Place", function(on)
	safeEnabled = on
end)

makeToggle("Return to Original", function(on)
	returnOriginal = on
end)

local btn = Instance.new("TextButton", tab)
btn.Size = UDim2.new(0, 160, 0, 30)
btn.BackgroundColor3 = Color3.fromRGB(80,0,100)
btn.TextColor3 = Color3.new(1,1,1)
btn.Text = "Return to Original"
btn.MouseButton1Click:Connect(function()
	if savedPos and plr.Character then
		plr.Character:SetPrimaryPartCFrame(CFrame.new(savedPos))
	end
end)
btn.Parent = tab

game:GetService("RunService").Heartbeat:Connect(function()
	if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then return end
	local hp = plr.Character.Humanoid.Health
	if safeEnabled and hp < threshold then
		if not savedPos then
			savedPos = plr.Character.HumanoidRootPart.Position
		end
		plr.Character:SetPrimaryPartCFrame(CFrame.new(0,150,0))
	elseif returnOriginal and hp >= threshold and savedPos then
		plr.Character:SetPrimaryPartCFrame(CFrame.new(savedPos))
		savedPos = nil
	end
end)
local function flingTarget(char)
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	local targetHRP = char and char:FindFirstChild("HumanoidRootPart")
	if hrp and targetHRP then
		local bv = Instance.new("BodyVelocity", hrp)
		bv.Velocity = (targetHRP.Position - hrp.Position).Unit * 150
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		game.Debris:AddItem(bv, 0.2)
	end
end

function addFlingButton(text, action)
	local b = Instance.new("TextButton", tab)
	b.Size = UDim2.new(0, 160, 0, 30)
	b.BackgroundColor3 = Color3.fromRGB(120, 0, 130)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.Text = text
	b.MouseButton1Click:Connect(action)
end

addFlingButton("Fling Nearest Player", function()
	local closest, dist = nil, math.huge
	for _,v in pairs(game.Players:GetPlayers()) do
		if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local d = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				closest = v
			end
		end
	end
	if closest then flingTarget(closest.Character) end
end)

addFlingButton("Fling All Players", function()
	for _,v in pairs(game.Players:GetPlayers()) do
		if v ~= plr and v.Character then
			flingTarget(v.Character)
		end
	end
end)

addFlingButton("Fling All Guards", function()
	for _,v in pairs(game.Players:GetPlayers()) do
		if v ~= plr and tostring(v.Team):lower():find("guard") and v.Character then
			flingTarget(v.Character)
		end
	end
end)
local plr = game.Players.LocalPlayer
local tab = plr.PlayerGui.InkGameHub:FindFirstChild("ESPTab")

Instance.new("UIListLayout", tab).Padding = UDim.new(0, 5)

function makeESPButton(name, filter)
	local btn = Instance.new("TextButton", tab)
	btn.Size = UDim2.new(0, 160, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = "ESP: "..name
	btn.MouseButton1Click:Connect(function()
		for _,obj in pairs(workspace:GetDescendants()) do
			if filter(obj) then
				local billboard = Instance.new("BillboardGui", obj)
				billboard.Size = UDim2.new(0,100,0,30)
				billboard.AlwaysOnTop = true
				local label = Instance.new("TextLabel", billboard)
				label.Size = UDim2.new(1,0,1,0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.new(1,1,1)
				label.TextStrokeTransparency = 0
				label.TextScaled = true
				label.Font = Enum.Font.Gotham
				label.Text = name
			end
		end
	end)
end

makeESPButton("Hiders", function(obj)
	return obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") and obj.Parent == workspace and obj.Name ~= plr.Name and tostring(game.Players:GetPlayerFromCharacter(obj)):lower():find("hider")
end)

makeESPButton("Seekers", function(obj)
	return obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") and obj.Parent == workspace and obj.Name ~= plr.Name and tostring(game.Players:GetPlayerFromCharacter(obj)):lower():find("seeker")
end)

makeESPButton("Guards", function(obj)
	return obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") and obj.Parent == workspace and obj.Name ~= plr.Name and tostring(game.Players:GetPlayerFromCharacter(obj)):lower():find("guard")
end)

makeESPButton("Escape Doors", function(obj)
	return obj:IsA("BasePart") and obj.Name:lower():find("escape")
end)

makeESPButton("Doors", function(obj)
	return obj:IsA("BasePart") and obj.Name:lower():find("door")
end)
local plr = game.Players.LocalPlayer
local tab = plr.PlayerGui.InkGameHub:FindFirstChild("SafeZoneTab")

Instance.new("UIListLayout", tab).Padding = UDim.new(0, 5)

local threshold = 30
local useSafe = false
local useReturn = false
local originalPosition = nil

function makeToggle(name, callback)
	local b = Instance.new("TextButton", tab)
	b.Size = UDim2.new(0,160,0,30)
	b.BackgroundColor3 = Color3.fromRGB(60,0,90)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.Text = name..": OFF"
	local on = false
	b.MouseButton1Click:Connect(function()
		on = not on
		b.Text = name..": "..(on and "ON" or "OFF")
		callback(on)
	end)
end

function makeSlider(labelText, min, max, default, onChange)
	local label = Instance.new("TextLabel", tab)
	label.Text = labelText..": "..default
	label.Size = UDim2.new(0,160,0,20)
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.BackgroundTransparency = 1

	local box = Instance.new("TextBox", tab)
	box.Text = tostring(default)
	box.Size = UDim2.new(0,160,0,25)
	box.BackgroundColor3 = Color3.fromRGB(40,0,60)
	box.TextColor3 = Color3.new(1,1,1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 14

	box.FocusLost:Connect(function()
		local val = tonumber(box.Text)
		if val then
			val = math.clamp(val, min, max)
			label.Text = labelText..": "..val
			onChange(val)
		end
	end)
end

makeSlider("Health Threshold", 1, 100, threshold, function(v)
	threshold = v
end)

makeToggle("Move To Safe Place", function(v)
	useSafe = v
end)

makeToggle("Return to Original", function(v)
	useReturn = v
end)

local returnBtn = Instance.new("TextButton", tab)
returnBtn.Size = UDim2.new(0,160,0,30)
returnBtn.BackgroundColor3 = Color3.fromRGB(80,0,100)
returnBtn.TextColor3 = Color3.new(1,1,1)
returnBtn.Font = Enum.Font.Gotham
returnBtn.TextSize = 14
returnBtn.Text = "Return to Original"
returnBtn.MouseButton1Click:Connect(function()
	if originalPosition and plr.Character then
		plr.Character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
	end
end)

returnBtn.Parent = tab

game:GetService("RunService").Heartbeat:Connect(function()
	local char = plr.Character
	if not char or not char:FindFirstChild("Humanoid") then return end

	local health = char.Humanoid.Health
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if useSafe and health < threshold then
		if not originalPosition then
			originalPosition = hrp.Position
		end
		hrp.CFrame = CFrame.new(0, 100, 0)
	elseif useReturn and health >= threshold and originalPosition then
		hrp.CFrame = CFrame.new(originalPosition)
		originalPosition = nil
	end
end)
local plr = game.Players.LocalPlayer
local tab = plr.PlayerGui.InkGameHub:FindFirstChild("AttachTab")

Instance.new("UIListLayout", tab).Padding = UDim.new(0, 5)

local attachMethod = "Tween"
local attachDist = 5
local tweenTime = 0.5
local stayBehind = false

function makeDropdown(name, options, default, onChange)
	local btn = Instance.new("TextButton", tab)
	btn.Size = UDim2.new(0,160,0,30)
	btn.BackgroundColor3 = Color3.fromRGB(80,0,110)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = name..": "..default
	local index = table.find(options, default)
	btn.MouseButton1Click:Connect(function()
		index = (index % #options) + 1
		btn.Text = name..": "..options[index]
		onChange(options[index])
	end)
end

function makeSlider(labelText, min, max, default, onChange)
	local label = Instance.new("TextLabel", tab)
	label.Text = labelText..": "..default
	label.Size = UDim2.new(0,160,0,20)
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.BackgroundTransparency = 1

	local box = Instance.new("TextBox", tab)
	box.Text = tostring(default)
	box.Size = UDim2.new(0,160,0,25)
	box.BackgroundColor3 = Color3.fromRGB(40,0,60)
	box.TextColor3 = Color3.new(1,1,1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 14

	box.FocusLost:Connect(function()
		local val = tonumber(box.Text)
		if val then
			val = math.clamp(val, min, max)
			label.Text = labelText..": "..val
			onChange(val)
		end
	end)
end

function makeToggle(name, callback)
	local b = Instance.new("TextButton", tab)
	b.Size = UDim2.new(0,160,0,30)
	b.BackgroundColor3 = Color3.fromRGB(60,0,90)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.Text = name..": OFF"
	local on = false
	b.MouseButton1Click:C
