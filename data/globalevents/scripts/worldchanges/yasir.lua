local config = {
	[1] = { -- Ankrahmun
		removeItems = {
			{position = Position(33096, 32882, 6), itemId = 4978},
			{position = Position(33096, 32883, 6), itemId = 4978},
			{position = Position(33096, 32883, 6), itemId = 4922},
			{position = Position(33096, 32884, 6), itemId = 4922},
			{position = Position(33096, 32885, 6), itemId = 4922}
		},
		fromPosition = Position(33099, 32875, 7),
		toPosition = Position(33106, 32893, 7),
		mapName = 'ankrahmun',
		yasirPosition = Position(33102, 32884, 6)
	},
	[2] = { -- Carlin
		removeItems = {
			{position = Position(32393, 31814, 6), itemId = 10408},
			{position = Position(32393, 31815, 6), itemId = 10408},
			{position = Position(32393, 31816, 6), itemId = 10408}
		},
		fromPosition = Position(32397, 31806, 7),
		toPosition = Position(32403, 31824, 7),
		mapName = 'carlin',
		yasirPosition = Position(32400, 31815, 6)
	},
	[3] = { -- Liberty Bay
		fromPosition = Position(32311, 32884, 1),
		toPosition = Position(32318, 32904, 7),
		mapName = 'libertybay',
		yasirPosition = Position(32314, 32895, 6)
	}
}

local yasirEnabled = true
local yasirChance = 33

local function spawnYasir(position)
	local npc = Game.createNpc('Yasir', position)
	if npc then
		npc:setMasterPos(position)
	end
end

function onStartup()
	if yasirEnabled then
		math.randomseed(os.time())
		if math.random(100) <= yasirChance then
			local randTown, tile, items, ground = config[math.random(#config)]
			iterateArea(
				function(position)
					tile = Tile(position)
					if tile then
						items = tile:getItems()
						for i = 1, #items do
							items[i]:remove()
						end

						ground = tile:getGround()
						if ground then
							ground:remove()
						end
					end
				end,
				randTown.fromPosition,
				randTown.toPosition
			)

			if randTown.removeItems then
				local item
				for i = 1, #randTown.removeItems do
					item = Tile(randTown.removeItems[i].position):getItemById(randTown.removeItems[i].itemId)
					if item then
						item:remove()
					end
				end
			end

			Game.loadMap('data/world/yasir/' .. randTown.mapName .. '.otbm')
			addEvent(spawnYasir, 5000, randTown.yasirPosition)
		end
	end
end