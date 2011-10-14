module(..., package.seeall)
require ('bacteria')

function createColony( params )
-- self
-- types: generator, defensive
-- owner: own, neutral, enemy1, enemy2...
-- with no params created 1-level neutral generator with no defense or generation with 5-50 army.
    local colony = {}

-- flags
    colony.selected = false
    
    if(params) then
    -- general
        if( params.coordinates ) then colony.coordinates = params.coordinates end
        if( params.level ) then colony.level = params.level end
        if( params.type ) then colony.type = params.type end
        if( params.size ) then colony.size = params.size end
        if( params.owner ) then colony.owner = params.owner end
        if( params.tapListener) then colony.tapListener = params.tapListener end
        
    -- special
        if( params.generation ) then colony.generation = params.generation end
        if( params.defense ) then colony.defense = params.defense end
        if( params.bacteries ) then colony.bacteries = params.bacteries end
    end
    
-- random fields as we don't fill them
    if( not colony.coordinates ) then
        colony.coordinates = {}
        colony.coordinates.x = math.random(30, display.contentWidth - 30)
        colony.coordinates.y = math.random(30, display.contentHeight - 30)
    end
    
    if( not colony.bacteries ) then colony.bacteries = bacteria.createBacteries(math.random(5, 50)) end
    
    if( not colony.size ) then colony.size = math.random(30, 60) end
    if( not colony.level ) then colony.level = 1 end
    if( not colony.type ) then colony.type = "generator" end
    if( not colony.owner) then colony.owner = "neutral" end
    if( not colony.generation) then colony.generation = 0 end
    if( not colony.defense) then colony.defense = 0 end
    
-- graphics
-- depend on colony size, type and owner choose right image
    if(colony.type == "generator") then
        colony.image = display.newImageRect("images/generator_colony.png", 83, 83)
    else if (colony.type == "defensive") then
        colony.image = display.newImageRect("images/defensive_colony.png", 83, 83)
    end
    end
    
    colony.image.x = colony.coordinates.x
    colony.image.y = colony.coordinates.y
    
-- text
    colony.text = display.newText(colony.bacteries.count, colony.coordinates.x, colony.coordinates.y)
    colony.text:setTextColor(0, 0, 0)
    
-- public functions
    function colony:setTapListener(func)
        colony.image:addEventListener("tap", func)
    end
    
    function colony:updateText()
        colony.text.text = colony.bacteries.count
    end
    
    return colony
end