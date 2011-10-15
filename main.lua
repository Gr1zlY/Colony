require ('bacteria')
require ('colony')

local colonys = {}
colonys[#colonys + 1] = colony.createColony({list = colonys, owner = "enemy1"})

for i = 1, 10 do
    colonys[#colonys + 1] = colony.createColony({list = colonys, owner = "own"})
end


