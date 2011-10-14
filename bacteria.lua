module(..., package.seeall)

function createBacteries( count )
    local bacteria = {}
    bacteria.count = count
    bacteria.speed = 10
    bacteria.bacteriesInGroup = 10
    
    -- public functions
    function bacteria:sendArmy(persent, sourceColony, destColony)
        local groups = math.ceil((bacteria.count * persent / 100) / bacteria.bacteriesInGroup)
        local army = math.ceil(bacteria.count * persent / 100)
        bacteria.count = bacteria.count - army
        sourceColony:updateText()
        
        local distance = math.sqrt(math.pow((sourceColony.coordinates.x - destColony.coordinates.x),2) + 
                                   math.pow((sourceColony.coordinates.y - destColony.coordinates.y),2))

        if(not bacteria.attackBacteries) then bacteria.attackBacteries = {} end

        for i = #bacteria.attackBacteries + 1, #bacteria.attackBacteries + groups do
            bacteria.attackBacteries[i] = {}
            bacteria.attackBacteries[i].image = display.newImageRect("images/bacteria.png", 20, 20)
            bacteria.attackBacteries[i].image.x = sourceColony.coordinates.x
            bacteria.attackBacteries[i].image.y = sourceColony.coordinates.y
            --bacteria.attackBacteries[i].source = sourceColony
            --bacteria.attackBacteries[i].destination = destColony
            
            if( army >= bacteria.bacteriesInGroup ) then
                bacteria.attackBacteries[i].count = bacteria.bacteriesInGroup
                army = army - bacteria.bacteriesInGroup
            else
                bacteria.attackBacteries[i].count = army
            end
            
            local function transListener( obj )
                obj:removeSelf()
                
                if( sourceColony.owner == destColony.owner ) then
                    destColony.bacteries.count = destColony.bacteries.count + bacteria.attackBacteries[i].count
                else        
                    if( destColony.bacteries.count - bacteria.attackBacteries[i].count < 0 ) then
                        destColony.owner = sourceColony.owner
                        destColony.bacteries.count = bacteria.attackBacteries[i].count - destColony.bacteries.count
                        -- colony is captured, change image
                    else
                        destColony.bacteries.count = destColony.bacteries.count - bacteria.attackBacteries[i].count
                    end
                end
                destColony:updateText()
            end
                
            transition.to(bacteria.attackBacteries[i].image, {delay = math.random(1000), time = distance/bacteria.speed * 100, x = destColony.coordinates.x, y = destColony.coordinates.y, onComplete = transListener })
        end
    end
    
    return bacteria
end