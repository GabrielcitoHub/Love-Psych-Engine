local state = {}
local self = state
self.goToState = "menu"
self.debug = false

local function continue()
    stateManager:loadState(self.goToState)
end

function self:load()
    self.gf = CharactersLib:getGF()
    local offset = 250
    sprm:setObjectPosition(self.gf, love.graphics:getWidth() / 2 - offset, love.graphics:getHeight() / 2 - offset)
    soundManager:playMusic("freakyMenu")
    if self.debug then
        continue()
    end
end

function self:draw()
    love.graphics.print("Friday Night Funkin: Love2D Player")
    love.graphics.print("Press enter to play!", love.graphics:getWidth() / 2, love.graphics:getHeight() / 1.5)
end

function self:keypressed(key)
    continue()
end

return state