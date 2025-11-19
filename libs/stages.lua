local stages = {}
local self = stages
self.stages = {}

function self:getStage(path, mod)
    local stagePath = Utils:getPath("mods") .. mod.modName .. "/images/" .. path
    print(stagePath)
    if love.filesystem.getInfo(stagePath) then
        sprm:makeLuaSprite(path, stagePath)
        sprm:setObjectOrder(path, -2)
    end
    local stageLuaPath = Utils:getPath("mods") .. mod.modName .. "/stages/" .. path .. ".lua"
    print("stageLuaPath = " .. stageLuaPath)

    local env
    if love.filesystem.getInfo(stageLuaPath) then
        -- Create a sandbox environment for the script
        env = setmetatable({}, { __index = _G })

        local chunk, err = love.filesystem.load(stageLuaPath)
        if chunk then
            -- Set environment BEFORE running script!
            setfenv(chunk, env)

            local success, message = pcall(chunk)
            if not success then
                print("[Stage Loader] Error running stage:", message)
            else
                self.loadedStage = env

                if env.onCreate then
                    env.onCreate()
                end
                if env.onCreatePost then
                    env.onCreatePost()
                end
            end
        else
            print("[Stage Loader] Failed to load:", err)
        end
    else
        print("[Stage Loader] Stage file missing:", stageLuaPath)
    end
    local stage = {
        data = Utils:loadJson(Utils:getPath("mods") .. mod.modName .. "/stages/" .. path .. ".json"),
        lua = env,
        id = path
    }
    return stage
end

function self:loadStage(stage, mod)
    if type(stage) == "string" then
        stage = self:getStage(stage, mod)
    end
    for key,value in pairs(stage.data) do
        if key == "boyfriend" then
            local bf = CharactersLib:getcharacter("boyfriend")
            if bf then
                sprm:setObjectPosition(bf.name, value[1], value[2])
            end
        elseif key == "opponent" then
            local opponent = CharactersLib:getDefaultOpponent()
            if opponent then
                print("OPPONENT FOUND!")
                sprm:setObjectPosition(opponent.name, value[1], value[2])
            end
        end
    end

    table.insert(self.stages, stage)
end

function self:updateStage(stage, dt)
    local env = stage.lua
    if not dt or not env then local fuckyou return end
    if env.onUpdate then
        env:onUpdate(dt)
    end
end

function self:clearStages()
    self.stages = {}
end

function self:update(dt)
    for _,stage in pairs(self.stages) do
        self:updateStage(stage, dt)
    end
end

return stages