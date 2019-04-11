lg = love.graphics

function makeColours(r, g, b)
	return r / 255, g / 255, b / 255
end

local menu = {
	assets = {
		titleFont = lg.newFont(40),
		menuFont = lg.newFont(20),
		defaultFont = lg.getFont(),
	},
	items = {
		"Play",
		"Scores",
		"Settings",
		"Help",
		"Quit"
	},
	selected_item = 1
}

function menu:entered()
	-- reset to first when entered
	
	self.selected_item = 1
end

function menu:draw()
	-- Calculate positions
	local window_width, window_height = love.graphics.getDimensions()
	local window_width_center, window_height_center = window_width / 2, window_height / 2

	local text_width = self.assets.titleFont:getWidth("ASTEROIDS")
	local text_x = window_width_center - text_width / 2
	local text_y = window_height_center - self.assets.menuFont:getHeight() / 2

	-- Draw menu
	lg.setBackgroundColor(makeColours(10, 10, 10))
	lg.setColor(makeColours(232, 232, 232))

	lg.setFont(self.assets.titleFont)
	lg.printf("ASTEROIDS", text_x, (text_y - lg.getFont():getHeight() * 1.5), text_width, "center")

	lg.setFont(self.assets.menuFont)
	for i, item in ipairs(self.items) do
		yPos = text_y + (lg.getFont():getHeight() + lg.getFont():getHeight() / 3) * i
		if i == self.selected_item then
			lg.printf("> " .. item .. " <", text_x, yPos, text_width, "center")
		else
			lg.printf(item, text_x, yPos, text_width, "center")
		end
	end

	lg.setFont(self.assets.defaultFont)
end

function menu:keypressed(key)
	if key == "w" or key == "up" then
		self.selected_item = self.selected_item - 1

		if self.selected_item < 1 then
			self.selected_item = #self.items
		end
	end

	if key == "s" or key == "down" then
		self.selected_item = self.selected_item + 1

		if self.selected_item > #self.items then
			self.selected_item = 1
		end
	end

	if key == "space" or key == "return" then
		if self.selected_item == 1 then
			game:change_state("play")
		elseif self.selected_item == 2 then
			game:change_state("scoreboard")
		elseif self.selected_item == 3 then
			game:change_state("settings")
		elseif self.selected_item == 4 then
			game:change_state("help")
		elseif self.selected_item == 5 then
			love.event.quit(0)
		end
	end
end

return menu
