module(..., package.seeall)
require ('bacteria')

function createColony( params )
-- self
-- types: generator, defensive
-- owner: own, neutral, enemy1, enemy2...
-- with no params created 1-level neutral generator with no defense and generation = 1.5 with 5-50 army.
-- generation values allowed (0.25, 0.50, 0.75, 1 ..etc)
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
        if( params.parent ) then colony.parent = params.parent end -- ������ �� ������ ���� ������� (���������� ��� ��������� �������)
        
    -- special
        if( params.generation ) then colony.generation = params.generation end
        if( params.defense ) then colony.defense = params.defense end
        if( params.bacteries ) then colony.bacteries = params.bacteries end
        
    end
    
    if( not colony.parent ) then
        print("Error creating colony. Colony parent required")
        return nil
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
    if( not colony.generation) then colony.generation = 1.5 end --per second
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
    colony.image.colony = colony --������ �� ���� �������
    
-- text
    colony.text = display.newText(colony.bacteries.count, colony.coordinates.x, colony.coordinates.y)
    colony.text:setTextColor(0, 0, 0)
    
    local newGeneration = 0
    local updateGeneration = function( event )
        --����������� ������� �� ����� ������������ ������
        if colony.owner ~= "neutral" then
            newGeneration = newGeneration + colony.generation
            if(newGeneration % 1 == 0) then
                colony.bacteries.count = colony.bacteries.count + newGeneration
                colony:updateText()
                newGeneration = 0
            end
        end
    end
    
    timer.performWithDelay(1000, updateGeneration, 0 )
    
    local touchListener = function( event )
    
        local temp_colony = event.target.colony --�������� ������ �� ������� � ������� ����� ��������
        local temp_array = temp_colony.parent -- ������ �� ������ ���� �������
        
        if event.phase == "began" then
            if temp_colony.owner == "own" then
                --temp_colony.selected = true --���� ������� ���� - �������� ��
                current_touch = temp_colony
            else
            
                --������ ���� �� ���� ��������� ������� � ������� ����������
                for i=1,#temp_array do
                    if temp_array[i] ~= temp_colony and temp_array[i].selected == true then
                        line = display.newLine( temp_array[i].coordinates.x, temp_array[i].coordinates.y, temp_colony.coordinates.x, temp_colony.coordinates.y)
                    end
                end
                
            end
        elseif event.phase == "moved" then
            --������ ���� �� ���� ��������� ������� � ������
            for i=1,#temp_array do
                if temp_array[i] ~= temp_colony and temp_array[i].selected == true then
                    line = display.newLine( temp_array[i].coordinates.x, temp_array[i].coordinates.y, temp_colony.coordinates.x, temp_colony.coordinates.y)
                end
            end
        elseif event.phase == "ended" then
            --[[
                ���� ������� ����, �� ���������, ���� �� ��� ���� ���������� �������, ���� ����,
                �� �������� ������ �� ������� � ��� �������. ���� ��������� ������� ����, �� �������� 
                ������ �������.
                ���� ��� ������� ���������� - �������� �� ���� ��������� ����� ������� ������ � ������.
            ]]--
            if temp_colony.owner == "own" then
                if current_touch == temp_colony then
                    --���� �� �������� - ��������
                    if temp_colony.selected == false then
                        temp_colony.selected = true
                    else
                        --���� ���� ���������� �������, �� ��� ������ ������� ��������� ���������.
                        --���� ���� ���������, �� ��� ������ ������� ���������� ��� �������.                        
                        local num_selected = 0
                        for i=1,#temp_array do
                            if temp_array[i].selected == true then
                                num_selected = num_selected + 1
                            end
                        end
                        if num_selected > 1 then
                            temp_colony.selected = false
                        else
                            for i=1,#temp_array do
                                if temp_array[i].owner == "own" then
                                    temp_array[i].selected = true
                                end
                            end                            
                        end
                    end
                else
                    --������ ������ � �������
                     current_touch.selected = true
                     
                     for i=1,#temp_array do
                        if temp_array[i] ~= temp_colony and temp_array[i].selected == true then
                        
                            temp_array[i].bacteries:sendArmy(50, temp_array[i], temp_colony) -- �������� ����� � �������
                            
                            temp_array[i].selected = false -- ������� ��������� ����� �������� �����
                        end
                    end                   
                end
            else
                --�������� ������ � ������
                if current_touch ~= nil then
                    current_touch.selected = true
                end
                     for i=1,#temp_array do
                        if temp_array[i] ~= temp_colony and temp_array[i].selected == true then
                        
                            temp_array[i].bacteries:sendArmy(50, temp_array[i], temp_colony) -- �������� ����� � �����
                            
                            temp_array[i].selected = false -- ������� ��������� ����� �������� �����
                        end
                    end
            end
            
            current_touch = nil -- ������� �����������
            
        else -- event.phase == "cancelled" ������� �������� ��������� �������.
            --Add smth
        end
    end
    
    colony.image:addEventListener("touch", touchListener)
    
-- public functions
    function colony:updateText()
        colony.text.text = colony.bacteries.count
    end
    
    return colony
end