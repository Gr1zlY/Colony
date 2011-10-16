require ('bacteria')
require ('colony')

local colonys = {}
current_touch = nil -- —сылка на планету, с которой началось нажатие.

colonys[#colonys + 1] = colony.createColony({owner = "enemy1", parent = colonys, type = "defensive"})
colonys[#colonys + 1] = colony.createColony({owner = "own", parent = colonys})

for i = 2, 10 do
    colonys[#colonys + 1] = colony.createColony({owner = "neutral", parent = colonys})
end