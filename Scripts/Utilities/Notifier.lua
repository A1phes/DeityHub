local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Notifier = {
	Collection = {},
}

function Notifier:New(className, properties)
	local instance = Instance.new(className)
	for prop, value in pairs(properties) do
		instance[prop] = value
	end
	table.insert(self.Collection, instance)
	return instance
end

local existing = CoreGui:FindFirstChild("notifier")
if existing then existing:Destroy() end

local notifierGui = Notifier:New("ScreenGui", {
	Name = "notifier",
	Parent = CoreGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local bg = Notifier:New("Frame", {
	Name = "bg",
	Parent = notifierGui,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 1,
	Position = UDim2.new(0.288, 0, 0.321, 0),
	Size = UDim2.new(0.422, 0, 0.359, 0),
	ZIndex = 99,
})

Notifier:New("UIListLayout", {
	Parent = bg,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
})

return function(text, duration)
	local frame = Notifier:New("Frame", {
		Parent = bg,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.177, 0, 0, 0),
	})

	local label = Notifier:New("TextLabel", {
		Parent = bg,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0.066, 0),
		Font = Enum.Font.GothamBold,
		Text = text,
		TextTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 19,
	})

	TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0.177, 0, 0.017, 0)
	}):Play()

	TweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
		TextTransparency = 0
	}):Play()

	task.spawn(function()
		task.wait(duration)
		TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
			Size = UDim2.new(0.177, 0, 0, 0)
		}):Play()
		TweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
			TextTransparency = 1
		}):Play()
		task.wait(0.2)
		frame:Destroy()
		label:Destroy()
	end)

	task.wait()
end
