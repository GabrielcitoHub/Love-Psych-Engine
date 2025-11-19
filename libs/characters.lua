local characters = {}
local self = characters
self.characters = {}

function self:newCharacter(name, json)
    local char = {}
    char.json = json
    char.name = name
    char.standTimer = char.json.sing_duration or 0
    char.standed = true

    self.characters[name] = char
end

function self:getcharacter(name)
    return self.characters[name]
end

function self:playBFAnimation(anim, miss)
    local bf = self:getcharacter("boyfriend")
    if not miss then
        sprm:playAnim(bf.name, anim)
    else
        sprm:playAnim(bf.name, anim .. "_miss")
    end
    bf.standTimer = bf.json.sing_duration
    bf.standed = false
end

function self:playDadAnimation(anim)
    local dad = self:getcharacter("dad")
    sprm:playAnim(dad.name, anim)
    dad.standTimer = dad.json.sing_duration
    dad.standed = false
end

function self:playOpponentAnimation(tag, anim)
    local opponent = self:getcharacter(tag)
    sprm:playAnim(opponent.name, anim)
    opponent.standTimer = opponent.json.sing_duration
    opponent.standed = false
end

function self:getCharacterData(path, mod)
    return Utils:loadJson(Utils:getPath("mods") .. mod.modName .. "/characters/" .. path .. ".json")
end

function self:getBF()
    local bf = "boyfriend"
    
    local charJson = Utils:loadJson(Utils:getPath("shared") .. "characters/bf.json")
    self:newCharacter(bf, charJson)

    sprm:makeLuaSprite(bf, Utils:getPath("images") .. "characters/BOYFRIEND", love.graphics:getWidth() - 700, love.graphics:getHeight() - 700)
    sprm:setObjectOrder(bf, 2)
    sprm:addLuaAnimation(bf, "idle", "BF idle dance", "xml")

    sprm:addLuaAnimation(bf, "left", "BF NOTE LEFT", "xml")
    sprm:addLuaAnimation(bf, "down", "BF NOTE DOWN", "xml")
    sprm:addLuaAnimation(bf, "up", "BF NOTE UP", "xml")
    sprm:addLuaAnimation(bf, "right", "BF NOTE RIGHT", "xml")

    sprm:addLuaAnimation(bf, "left_miss", "BF NOTE LEFT MISS", "xml")
    sprm:addLuaAnimation(bf, "down_miss", "BF NOTE DOWN MISS", "xml")
    sprm:addLuaAnimation(bf, "up_miss", "BF NOTE UP MISS", "xml")
    sprm:addLuaAnimation(bf, "right_miss", "BF NOTE RIGHT MISS", "xml")

    sprm:playAnim(bf, "idle")
    return bf
end

function self:getOpponent(optName, mod, path, extra)
    extra = extra or {}
    optName = optName or path

    local charJson = extra.json or self:getCharacterData(path, mod)
    self:newCharacter(optName, charJson)

    local oppSprPath = charJson.image
    sprm:makeLuaSprite(optName, Utils:getPath("mods") .. mod.modName .. "/images/" .. oppSprPath, 0, love.graphics:getHeight() - 700)
    sprm:setObjectOrder(optName, 2)
    for _, anim in pairs(charJson.animations) do
        local animation = anim.anim
        local name = anim.name
        if animation == "singLEFT" then
            animation = "left"
        elseif animation == "singDOWN" then
            animation = "down"
        elseif animation == "singUP" then
            animation = "up"
        elseif animation == "singRIGHT" then
            animation = "right"
        end
        sprm:addLuaAnimation(optName, animation, name, "xml")
    end
    
    sprm:playAnim(optName, "idle")
    self.defaultOpponent = optName
    return optName
end

function self:getOldOpponent(mod, path)
    print("MOD: " .. mod.modName)
    local charJson = self:getCharacterData(path, mod)

    local dadAnims = {
        ["Dad sing note LEFT"] = true,
        ["Dad sing note DOWN"] = true,
        ["Dad sing note UP"] = true,
        ["Dad sing note RIGHT"] = true,
        ["Dad idle dance"] = true
    }
    local dadFound = false
    for name,anim in pairs(charJson.animations) do
        if dadAnims[anim.name] then
            dadFound = true
        end
    end
    if not dadFound then
        return self:getOpponent(path, mod, path, {json = charJson})
    end

    local dad = "dad"

    self:newCharacter(dad, charJson)

    local oppSprPath = charJson.image
    print("imagePath: " .. oppSprPath)

    sprm:makeLuaSprite(dad, Utils:getPath("mods") .. mod.modName .. "/images/" .. oppSprPath, 0, love.graphics:getHeight() - 1400)
    sprm:setObjectOrder(dad, 2)
    sprm:addLuaAnimation(dad, "idle", "Dad idle dance", "xml")

    sprm:addLuaAnimation(dad, "left", "Dad Sing Note LEFT", "xml")
    sprm:addLuaAnimation(dad, "down", "Dad Sing Note DOWN", "xml")
    sprm:addLuaAnimation(dad, "up", "Dad Sing Note UP", "xml")
    sprm:addLuaAnimation(dad, "right", "Dad Sing Note RIGHT", "xml")

    sprm:playAnim(dad, "idle")
    self.defaultOpponent = dad
    return dad
end

-- Utils

function self:getDefaultOpponent()
    return self:getcharacter(self.defaultOpponent)
end

function self:clearCharacters()
    self.characters = {}
end

function self:update(dt)
    if not self.characters then return end

    for name,char in pairs(self.characters) do
        if not char.standed then
            if char.standTimer > 0 then
                char.standTimer = char.standTimer - 10 * dt
            else
                sprm:playAnim(name, "idle")
                char.standed = true
            end
        end
    end
end

return characters