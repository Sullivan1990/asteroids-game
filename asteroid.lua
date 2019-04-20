ph = love.physics
local asteroid = {}

function asteroid:new(world, x, y, size, speed, spin)
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
	new_asteroid.b:setLinearVelocity(love.math.random(-speed, speed), love.math.random(-speed, speed))
	new_asteroid.b:setAngularVelocity(math.rad(love.math.random(-spin, spin)))

	return new_asteroid
end

return asteroid
