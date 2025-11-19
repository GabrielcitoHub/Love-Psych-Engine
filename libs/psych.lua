local psych = {}
local self = psych

_G.mustHitSection = false

function self:load()
    _G.lowQuality = settings.lowQuality or false
end

_G.makeLuaSprite = function(tag, path, x, y, extra)
    local mod = Utils:getCurrentMod()
    if path then
        local path =  Utils:getPath("mods") .. mod.modName .. "/images/" .. path
        sprm:makeLuaSprite(tag, path, x, y, extra)
    end
end
function _G.makeGraphic()
    return "lmao"
end
function _G.makeLuaBackdrop()
    return "lmao"
end
function _G.runHaxeCode()
    return "lmao"
end
function _G.addLuaBackdrop()
    return "lmao"
end
_G.makeAnimatedLuaSprite = function(tag, path, x, y, extra)
    local mod = Utils:getCurrentMod()
    local path =  Utils:getPath("mods") .. mod.modName .. "/images/" .. path
    sprm:makeLuaSprite(tag, path, x, y, extra)
end
_G.luaSpriteAddAnimationByPrefix = function(tag, anim, name, speed, loop, animtype, extra)
    sprm:addLuaAnimation(tag,anim,name,animtype,extra)
    sprm:playAnim(tag,anim)
end
_G.scaleObject = function(tag, sx, sy)
    sprm:setObjectSize(tag, sx, sy)
end
_G.setLuaSpriteScrollFactor = function(tag, scrollX, scrollY)
    return "lmao"
end
_G.setPropertyLuaSprite = function(...)
    sprm:setProperty(...)
end
_G.setProperty = function(tag, value)
    return "lmao"
end
_G.getProperty = function(tag)
    return "lmao"
end
_G.setTextColor = function(text, color, idk)
    return "lmao"
end
_G.addLuaSprite = function(tag, front)
    sprm:addLuaSprite(tag, front)
end
function _G.addAnimationByPrefix()
    return "lmao"
end
function _G.addLuaBackdrop()
    return "lmao"
end
_G.close = function(close)
    if close then
        -- nothing
    else
        -- nothing but cooler
    end
end
_G.triggerEvent = function(event, val1, val2)
    return "lmao"
end
_G.doTweenColor = function(...)
    return "when the imposter is sus DUN DUN DUN DUUN"
end
_G.setObjectCamera = function(tag, layer)
    sprm:setProperty(tag, "layer", layer)
end
function _G.setObjectOrder()
    return "lmao"
end
function _G.getObjectOrder()
    return 1
end
function _G.setScrollFactor()
    return "lmao"
end

return self