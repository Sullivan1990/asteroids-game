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

function asteroid.split(asteroid, world)
	local amount = love.math.random(2, 3)

	local remaining_size = asteroid.size
	local new_size = 0
	for i = 1, amount do
		print("Asteroid " .. i .. ":")
		-- Code to determine size of new asteroid
		local min_size = math.ceil(asteroid.size / (amount * 1.5))
		local max_size = math.ceil(remaining_size - (min_size * (amount - i)))
		print("min: " .. min_size .. " max: " .. max_size)

		local size = love.math.random(min_size, max_size)
		print("size: " .. size)

		remaining_size = remaining_size - size
		local previous_size = new_size
		new_size = new_size + size
		print()

		-- Find center point of new asteroid within original
		local center_angle = math.rad(365 / asteroid.size * (new_size - size / 2))
		local temp_center_x = math.ceil(asteroid.size / 2 * math.cos(center_angle))
		local temp_center_y = math.ceil(asteroid.size / 2 * math.sin(center_angle))
		print("center angle: " .. math.deg(center_angle) .. "  x: " .. temp_center_x .. " y: " .. temp_center_y)

		local random_area = asteroid.size / 3 * 2
		print("area: " .. random_area)
		local center_x = love.math.random(temp_center_x - random_area, temp_center_x + random_area) + asteroid.b:getX()
		local center_y = love.math.random(temp_center_y - random_area, temp_center_y + random_area) + asteroid.b:getY()

		print()
		-- Find angle of trajectory
		local old_velocity_x, old_velocity_y = asteroid.b:getLinearVelocity()
		local old_angle = math.atan2((0 - old_velocity_y), (0 - old_velocity_x)) 
		print("old angle: " .. math.deg(old_angle))

		local temp_angle = love.math.random(previous_size, new_size) / asteroid.size * 67.5
		local angle = (old_angle + 67.5 / 2) - (previous_size / asteroid.size * 67.5 + temp_angle)
		print("temp angle: " .. math.deg(temp_angle) .. " angle: " .. math.deg(angle))
		print()
		print()
		asteroid.new(world, center_x, center_y, size, old_velocity_x, old_velocity_y, 10)
	end
end

return asteroid
