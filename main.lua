require ('bacteria')
require ('colony')

local colonys = {}
current_touch = nil -- —сылка на планету, с которой началось нажатие.

colonys[#colonys + 1] = colony.createColony({list = colonys, owner = "enemy1", parent = colonys, type = "defensive"})
colonys[#colonys + 1] = colony.createColony({list = colonys, owner = "own", parent = colonys})

for i = 2, 10 do
    colonys[#colonys + 1] = colony.createColony({list = colonys, owner = "neutral", parent = colonys})
end