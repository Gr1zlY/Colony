require ('bacteria')
require ('colony')

local colonys = {}

colonys[#colonys + 1] = colony.createColony({owner = "enemy1", parent = colonys, type = "defensive"})
colonys[#colonys + 1] = colony.createColony({owner = "own", parent = colonys})

for i = 2, 7 do
    colonys[#colonys + 1] = colony.createColony({owner = "neutral", parent = colonys})
end