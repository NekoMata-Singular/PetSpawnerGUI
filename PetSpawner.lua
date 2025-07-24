return function()
    local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetSpawnerGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

-- Main container frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 50)
title.Position = UDim2.new(0, 20, 0, 10)
title.Text = "PET SPAWNER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 28
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Input fields container
local inputsFrame = Instance.new("Frame")
inputsFrame.Size = UDim2.new(1, -40, 0, 200)
inputsFrame.Position = UDim2.new(0, 20, 0, 70)
inputsFrame.BackgroundTransparency = 1
inputsFrame.Parent = mainFrame

-- Function to create input fields with number restrictions
local function createInput(labelText, placeholder, yPosition, isNumber)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 50)
	frame.Position = UDim2.new(0, 0, 0, yPosition)
	frame.BackgroundTransparency = 1
	frame.Parent = inputsFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Text = labelText
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 18
	label.Font = Enum.Font.SourceSansSemibold
	label.BackgroundTransparency = 1
	label.Parent = frame

	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.6, 0, 0.8, 0)
	textBox.Position = UDim2.new(0.4, 0, 0.1, 0)
	textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.PlaceholderText = placeholder
	textBox.Text = ""
	textBox.TextSize = 16
	textBox.ClearTextOnFocus = false

	if isNumber then
		textBox:GetPropertyChangedSignal("Text"):Connect(function()
			local text = textBox.Text
			if text == "" then return end

			-- Remove non-numeric characters (allows decimals)
			local numericText = text:gsub("[^%d.]", "")
			-- Ensure only one decimal point
			local decimalCount = select(2, numericText:gsub("%.", ""))
			if decimalCount > 1 then
				numericText = numericText:reverse():gsub("%.", "", 1):reverse()
			end
			textBox.Text = numericText
		end)
	end

	local textBoxCorner = Instance.new("UICorner")
	textBoxCorner.CornerRadius = UDim.new(0, 4)
	textBoxCorner.Parent = textBox

	textBox.Parent = frame

	return textBox
end

-- Create input fields
local nameInput = createInput("Pet Name:", "Enter pet name", 0, false)
local weightInput = createInput("Weight (kg):", "Enter weight", 60, true)
local ageInput = createInput("Age:", "Enter age", 120, true)

-- Spawn button
local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0.6, 0, 0, 60)
spawnButton.Position = UDim2.new(0.2, 0, 0, 280)
spawnButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
spawnButton.Text = "SPAWN PET"
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.TextSize = 20
spawnButton.Font = Enum.Font.SourceSansBold
spawnButton.Parent = mainFrame

-- Add rounded corners to button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = spawnButton

-- Button hover effects
spawnButton.MouseEnter:Connect(function()
	spawnButton.BackgroundColor3 = Color3.fromRGB(70, 220, 70)
end)

spawnButton.MouseLeave:Connect(function()
	spawnButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
end)

-- Button click functionality (error-free with limits)
spawnButton.MouseButton1Click:Connect(function()
	-- Get inputs
	local petName = nameInput.Text
	local petWeightText = weightInput.Text
	local petAgeText = ageInput.Text

	-- Validate name
	if string.len(petName) < 2 then
		warn("Pet name must be at least 2 characters!")
		return
	end

	-- Validate weight (0.1-40 kg)
	local petWeight = tonumber(petWeightText)
	if not petWeight then
		warn("Please enter a valid weight number!")
		return
	elseif petWeight < 0.1 then
		warn("Weight must be at least 0.1 kg!")
		return
	elseif petWeight > 40 then
		warn("Weight cannot exceed 40 kg!")
		return
	end

	-- Validate age (1-100 years)
	local petAge = tonumber(petAgeText)
	if not petAge then
		warn("Please enter a valid age number!")
		return
	elseif petAge < 1 then
		warn("Age must be at least 1 year!")
		return
	elseif petAge > 100 then
		warn("Age cannot exceed 100 years!")
		return
	end

	-- All validations passed - spawn pet
	print("Spawning pet:")
	print("Name:", petName)
	print("Weight:", string.format("%.1f kg", petWeight))
	print("Age:", math.floor(petAge).." years")

	-- Visual feedback
	spawnButton.Text = "SPAWNING..."
	task.wait(1)
	spawnButton.Text = "SPAWN PET"
end)
end
