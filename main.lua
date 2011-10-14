require ('bacteria')
require ('colony')

local enemyColony = colony.createColony({owner = "enemy1"})
local myColonys = {}

for i = 1, 10 do
    myColonys[i] = colony.createColony({owner = "own"})
    myColonys[i].bacteries:sendArmy(50, myColonys[i], enemyColony)
end