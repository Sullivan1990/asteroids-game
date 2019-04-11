gr = love.graphics
ph = love.physics

function makeColours(r, g, b)
	return r / 255, g / 255, b / 255
end

local play = {
	assets = {
		score = gr.newFont(20),
		default = gr.getFont(),
		laser = gr.newImage("laser.png"),
		-- Add sounds effects later
		spawn = love.audio.newSource("spawn.wav", "static"),
--		died = love.audio.newSource("died.wav", "static"),
--		ball = love.audio.newSource("ball.wav", "static")
	},
	asteroids = {},
	asteroid_speed = 10,
	asteroid_spin = 10,
	player = {
		speed = 10
	},
	world = ph.newWorld(0, 0, true),
	difficulty = 2,
	volume = 1.0,
	game_time = 0,
	score = 0
}

function play:change_volume(level)
	if level >= 0 or level <= 1 then
		self.volume = level
	end
end

function loop_object(object, window_width, window_height)
	local object_points = {object.b:getWorldPoints(object.s:getPoints())}
	local outside_window_x = true
	local outside_window_y = true

	for i = 1, #object_points / 2, 2 do
		if object_points[i] > 0 and object_points[i] < window_width then
			outside_window_x = false
		end
		if object_points[i + 1] > 0 and object_points[i + 1] < window_height then
			outside_window_y = false
		end
	end

	if outside_window_x then
		local distance = 0
		if object.b:getX() > window_width then
			distance = object.b:getX() - window_width
		else
			distance = math.abs(object.b:getX())
		end

		print(distance)

		object.b:setX(object.b:getX() % (window_width + distance))
	end
	if outside_window_y then
		local distance = 0
		if object.b:getY() > window_height then
			distance = object.b:getY() - window_height
		else
			distance = math.abs(object.b:getY())
		end

		print(distance)

		object.b:setY(object.b:getY() % (window_height + distance))
	end

	return object
end

function play:entered()
	local window_width, window_height = gr.getDimensions()

	self.world = ph.newWorld(0, 0, true)

	--local player_x = window_width / 2 -- self.player.width / 2
	--local player_y = window_height / 2 -- self.player.height / 2
	local player_x = 0
        local player_y = 0

	self.player.b = ph.newBody(self.world, player_x, player_y, "dynamic")
	self.player.s = ph.newPolygonShape(player_x + 5, player_y, player_x - 5, player_y + 3, player_x - 5, player_y - 3)
	self.player.f = ph.newFixture(self.player.b, self.player.s)
	self.player.b:setPosition(window_width / 2, window_height / 2)
	self.player.b:setLinearVelocity(0, 0)

	self.asteroids = {}
	
	self.game_time = 0;
	self.score = 0;

	love.audio.setVolume(self.volume)
	self.assets.spawn:play()
end

function play:update(dt)
	local window_width, window_height = gr.getDimensions()

	-- Update game score timer
	self.game_time = self.game_time + dt

	-- Apply player movement
	if love.keyboard.isDown("w", "up") then
		self.player.b:applyForce(0, -self.player.speed)
	end
	if love.keyboard.isDown("a", "left") then
		self.player.b:applyForce(-self.player.speed, 0)
	end
	if love.keyboard.isDown("s", "down") then
		self.player.b:applyForce(0, self.player.speed)
	end
	if love.keyboard.isDown("d", "right") then
		self.player.b:applyForce(self.player.speed, 0)
	end
	if love.keyboard.isDown("escape") then
		game:change_state("menu")
	end

	-- Spawn more asteroids if the time permits
	asteroids_amount = love.math.random(#self.asteroids, (self.game_time / 8) * self.difficulty + 3)
	while #self.asteroids < asteroids_amount do
		local x = love.math.random(0, window_width)
		local y = love.math.random(0, window_height)

		local asteroid_distance_to_player = ((self.player.b:getX() - x)^2 + (self.player.b:getY() - y)^2)^0.5

		if asteroid_distance_to_player > 200 then
			size = love.math.random(50, 60)
			--speed = love.math.random(50, 300),

			local asteroid_vertices = {}

			vertices_amount = math.ceil(love.math.random(10, 16) / 2)
			for i = 1, vertices_amount do
				local temp_vertice_x = math.floor(size * math.cos(math.rad(365 / vertices_amount * i)))
				local temp_vertice_y = math.floor(size * math.sin(math.rad(365 / vertices_amount * i)))

				local vertice_x = love.math.random(temp_vertice_x - 15, temp_vertice_x + 15)
				local vertice_y = love.math.random(temp_vertice_y - 15, temp_vertice_y + 15)

				table.insert(asteroid_vertices, vertice_x)
				table.insert(asteroid_vertices, vertice_y)
			end

			local asteroid = {}
			asteroid.b = ph.newBody(self.world, 0, 0, "dynamic")
			asteroid.s = ph.newPolygonShape(asteroid_vertices)
			asteroid.f = ph.newFixture(asteroid.b, asteroid.s)
			asteroid.f:setCategory(2)
			asteroid.f:setMask(2)

			asteroid.b:setPosition(x, y)
			asteroid.b:setLinearVelocity(love.math.random(-self.asteroid_speed, self.asteroid_speed), love.math.random(-self.asteroid_speed, self.asteroid_speed))
			asteroid.b:setAngularVelocity(math.rad(love.math.random(-self.asteroid_spin, self.asteroid_spin)))

			table.insert(self.asteroids, asteroid)
		end
	end --me

	self.player = loop_object(self.player, window_width, window_height)

	for i, asteroid in ipairs(self.asteroids) do
		asteroid = loop_object(asteroid, window_width, window_height)
	end

	-- Apply ball movement
--[[	for k, ball in pairs(self.balls) do
--		ball.y = ball.y + ball.speed * dt
--	end

	-- Remove balls that have left the screen 
--	for i, ball in ipairs(self.balls) do
--		if ball.y > window_height + ball.size then
--			table.remove(self.balls, i)
--		end
--	end

	-- Check collisions
	for k, ball in pairs(self.balls) do
		local ball_distance_to_player = (((self.player.x + self.player.width / 2) - ball.x)^2 + ((self.player.y + self.player.height / 2) - ball.y)^2)^0.5

		if (ball_distance_to_player - self.player.width / 2) < ball.size then
			game.states.scoreboard:add_score(self.game_time_score)
			if self.sound then
				self.assets.died:play()
			end
			game:change_state("scoreboard")
		end
	end
	--]]
	self.world:update(dt)
end

function play:draw()
	gr.polygon("line", self.player.b:getWorldPoints(self.player.s:getPoints()))

	for k, asteroid in pairs(self.asteroids) do
		gr.polygon("line", asteroid.b:getWorldPoints(asteroid.s:getPoints()))
	end
end

return play
