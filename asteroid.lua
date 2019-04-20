ph = love.physics
local asteroid = {}

function asteroid.new(world, x, y, size, speed_x, speed_y, spin)
	local asteroid_vertices = {}

	local vertices_amount = math.ceil(love.math.random(10, 16) / 2)
	for i = 1, vertices_amount do
		local temp_vertice_x = math.floor(size * math.cos(math.rad(365 / vertices_amount * i)))
		local temp_vertice_y = math.floor(size * math.sin(math.rad(365 / vertices_amount * i)))

		local vertice_x = love.math.random(temp_vertice_x - 15, temp_vertice_x + 15)
		local vertice_y = love.math.random(temp_vertice_y - 15, temp_vertice_y + 15)

		table.insert(asteroid_vertices, vertice_x)
		table.insert(asteroid_vertices, vertice_y)
	end

	local new_asteroid = {}
	new_asteroid.b = ph.newBody(world, 0, 0, "dynamic")
	new_asteroid.s = ph.newPolygonShape(asteroid_vertices)
	new_asteroid.f = ph.newFixture(new_asteroid.b, new_asteroid.s)
	new_asteroid.size = size

	new_asteroid.f:setCategory(2)
	new_asteroid.f:setMask(2)

	new_asteroid.b:setPosition(x, y)
	new_asteroid.b:setLinearVelocity(speed_x, speed_y)
	new_asteroid.b:setAngularVelocity(math.rad(love.math.random(-spin, spin)))

	return new_asteroid
end

function asteroid.split(asteroid)
	local amount = love.math.random(2, 3)

	local remaining_size = asteroid.size
	local total_size = 0
	for i = 1, amount do
		-- Code to determine size of new asteroid
		local min_size = math.ceil(asteroid.size / (amount * 1.5))
		local max_size = math.ceil(remaining_size - (min_size * (amount - i)))

		local size = love.math.random(min_size, max_size)

		remaining_size = remaining_size - size
		new_size = new_size + size

		-- Find center point of new asteroid within original
		local angle = math.rad(365 / asteroid.size * (new_size - size / 2))
		local temp_center_x = math.ceil(asteroid.size / 2 * math.cos(angle))
		local temp_center_y = math.ceil(asteroid.size / 2 * math.sin(angle))

		local random_area = asteroid.size / 3 * 2
		local center_x = love.math.random(temp_center_x - random_area, temp_center_x + random_area) + asteroid.b:getX()
		local center_y = love.math.random(temp_center_y - random_area, temp_center_y + random_area) + asteroid.b:getY()
	end
end

return asteroid
