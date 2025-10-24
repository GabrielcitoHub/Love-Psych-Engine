local state = {}
local self = state

function self:load()
    self.bf = CharactersLib:getBF()
end

function self:keypressed(key)
    if key == "escape" then
        Utils:goBack("menu")
    end

    if key ~= "left" and key ~= "down" and key ~= "up" and key ~= "right" then return end
    CharactersLib:playBFAnimation(key)
end

return self