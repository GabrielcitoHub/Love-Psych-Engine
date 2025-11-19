local state = {}
local self = state
self.imagesFolder = Utils:getPath("images")

self.weeks = {}

self.selectedIndex = 1
self.font = nil

function self:loadWeeks()
    local loadedWeeks = {}

    for _, mod in ipairs(self.mods) do
        print(mod.name)
        print(mod.active)
        for _, week in pairs(mod.weeks) do
            week.name = week.weekName
            week.mod = mod
            if week.songs then
                local loadedSongs = {}
                Utils:encodeSongs(loadedSongs, week.songs, mod)
                for _,song in ipairs(loadedSongs) do
                    song.week = week
                end
                week.loadedSongs = loadedSongs
                print("songs: " .. tostring(week.songs))
                print("loadedSongs: " .. tostring(loadedSongs))
            end
            table.insert(loadedWeeks, week)
        end
    end

    return loadedWeeks
end

function self:load()
    sprm:makeLuaSprite("bg", self.imagesFolder .. "menuDesat")
    sprm:centerObject("bg")

    self.mods = Utils:loadMods(true)
    self.weeks = self:loadWeeks()
    self.font = love.graphics.newFont(18)
    love.graphics.setFont(self.font)
end

function self:draw()
    love.graphics.clear(0.1, 0.1, 0.1) -- dark background
    local selectedWeek
    for i, week in ipairs(self.weeks) do
        week.index = i
        if i == self.selectedIndex then
            selectedWeek = week
            break
        end
    end

    selectedWeek = selectedWeek or {}
    local color = selectedWeek.freeplayColor or {255,255,122}

    love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255) -- yellow for selected
    sprm:draw("bg")

    love.graphics.printf("Story Mode", 0, 40, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1)
    
    if #self.weeks > 0 then
        for i, week in ipairs(self.weeks) do
            local y = 100 + (i - 1) * 40
            if i == self.selectedIndex then
                love.graphics.setColor(0.8, 1, 1) -- yellow for selected
            else
                love.graphics.setColor(1, 1, 1)
            end

            week.name = week.name or "???"
            week.storyName = week.storyName or "N/A"

            love.graphics.printf(week.name .. " [" .. week.storyName .. "]", 0, y, love.graphics.getWidth(), "center")
        end
    else
        love.graphics.printf("No weeks loaded!", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center", 0)
    end
end

function self:keypressed(key)
    if key == "escape" then
        Utils:goBack("menu")
    elseif key == "up" then
        self.selectedIndex = self.selectedIndex - 1
        if self.selectedIndex < 1 then
            self.selectedIndex = #self.weeks
        end

    elseif key == "down" then
        self.selectedIndex = self.selectedIndex + 1
        if self.selectedIndex > #self.weeks then
            self.selectedIndex = 1
        end

    elseif key == "return" or key == "space" then
        local selected = self.weeks[self.selectedIndex]
        if selected then
            print("Loading week:", selected.name, "from", selected.mod.name)
            assert(selected.mod)
            Utils:loadWeek(selected)
        else
            print("No songs to load")
        end
    end
end

return self