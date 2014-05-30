require("scripts/lib/utils")
local scheduler = require("framework.scheduler")
local CUR_MODULE = ...
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local gap = 20
local tileWidth = 100
local posx
local posy
local t = {}
local gameLayer
function MainScene:ctor()
    gameLayer = display.newLayer()
    gameLayer:setTouchEnabled(true)
    self.touchHandler = handler(self, self.onTouch)
    gameLayer:addTouchEventListener(self.touchHandler)
    self:addChild(gameLayer)
    posx = (display.width - 460) / 2
    posy = (display.height - 460) / 2
    self:createBg()
    self:start()
end

function MainScene:start()
    for i = 1, 16 do
        local tile = t[i]
        t[i] = nil
    end
    if tile ~= nil then
        tile:removeFromParentAndCleanup(true)
    end
    self.generator(2)
    self.generator(2)
end

function MainScene:onRight()
    for i = 3 , 1 , -1 do
        for j = 0 , 3 do
            local index = j * 4 + i
            moveTile(index , "right")
        end
    end
end

function MainScene:onLeft()
    for i = 2 , 4 do
        for j = 0 , 3 do
            local index = j * 4 + i
            moveTile(index , "left")
        end
    end
end

function MainScene:onUp()
    for i = 2 , 4 do
        for j = 1 , 4 do
           local index = (i - 1) * 4 + j
           moveTile(index , "up") 
        end
    end
end

function MainScene:onDown()
    for i = 3 , 1 , -1 do
        for j = 1 , 4 do
            local index = (i - 1) * 4 + j
            moveTile(index , "down")
        end
    end
end

function moveTile(tileIndex , direction)
    local nextIndex
    if direction == "right" then
        nextIndex = tileIndex + 1
    elseif direction == "left" then
        nextIndex = tileIndex - 1
    elseif direction == "up" then
        nextIndex = tileIndex - 4
    elseif direction == "down" then
        nextIndex = tileIndex + 4
    end
    local tile = t[tileIndex]
    if tile == nil then
        return
    end
    local nextTile = t[nextIndex]
    --下一个格子是空的
    if nextTile == nil then
        print(tileIndex.."->"..nextIndex..direction)
        t[tileIndex] = nil
        t[nextIndex] = tile
        local row , colum = getRowAndColumByIndex(nextIndex)
        local p1 = getTilePosByIndex(nextIndex)
        --transition.moveTo(tile, {x = p1.x , y = p1.y , time = 0.1})
        tile:setPosition(p1)
        if canMoveToNext(nextIndex , direction, row , colum) then 
            moveTile(nextIndex, direction) --可以继续移动
        end
        --下一个格子有并且数字一样
    elseif nextTile.data == tile.data then
        print("合体:"..tileIndex.."->"..nextIndex)
        t[tileIndex] = nil
        tile:removeFromParentAndCleanup(true)
        nextTile:setData(nextTile.data * 2)
    end
end

--是否能继续往下一格移动
function canMoveToNext(tileIndex , direction , row , colum)
    if (direction == "right" and colum < 4) or
       (direction == "left" and colum > 1) or
       (direction == "up" and row > 1) or
       (direction == "down" and row < 4) then return true
    else
        return false
    end
end

function getTilePosByIndex(index)
    local row , colum = getRowAndColumByIndex(index)
    return ccp(posx + (colum - 1) * (tileWidth + gap), display.height - (posy + row * (tileWidth + gap)) + 20)
end

function getRowAndColumByIndex(index)
    local row = math.ceil(index / 4)
    local colum = index % 4
    if colum == 0 then
        colum = 4
    end
    return row , colum
end

local isDown = false
local timeout = false
local beganP = ccp(0, 0)
local timeoutHandler
function MainScene:onTouch(event , x , y)
    --print(event)
    if event == "began" then
        isDown = true
        timeout = false
        timeoutHandler = scheduler.scheduleGlobal(onTimeOut, 0.2)
        beganP:setPoint(x, y)
    elseif event == "moved" then
        --print(isDown , timeout)
        if not timeout then
            if math.abs(x - beganP.x) > math.abs(y - beganP.y) then
                if x - beganP.x > 20 then
                    --水平向右
                    timeout = true
                    self:onRight()
                    self:generator()
                elseif beganP.x - x > 20 then
                    --水平向左
                    timeout = true
                    self:onLeft()
                    self:generator()
                end
            else
                if y - beganP.y > 20 then
                    --垂直向上
                    timeout = true
                    self:onUp()
                    self:generator()
                elseif beganP.y - y > 20 then
                    --垂直向下
                    timeout = true
                    self:onDown()
                    self:generator()
                end
            end
        end
    elseif event =="ended" then
        if timeoutHandler ~= nil then
            scheduler.unscheduleGlobal(timeoutHandler)
        end
        isDown = false
    end
    return true
end

function onTimeOut()
    timeout = true
end

--自动检测是否gameover
function cheackValid()
    for i = 1 , 16 do
        local tile = t[i]
        if tile == nil then
            return true
        end
        local nextTile
        local upIndex = i - 4
        local downIndex = i + 4
        local leftIndex = i - 1
        local rightIndex = i + 1
        if upIndex > 0 and upIndex < 17 then
            nextTile = t[upIndex]
            if nextTile ~= nil and tile.data == nextTile.data then
                return true
            end
        end
        if downIndex > 0 and upIndex < 17 then
            nextTile = t[downIndex]
            if nextTile ~= nil and tile.data == nextTile.data then
                return true
            end
        end
        if leftIndex > 0 and leftIndex < 17 then
            nextTile = t[leftIndex]
            if nextTile ~= nil and tile.data == nextTile.data then
                return true
            end
        end
        if rightIndex > 0 and rightIndex < 17 then
            nextTile = t[rightIndex]
            if nextTile ~= nil and tile.data == nextTile.data then
                return true
            end
        end
    end
    return false
end

--随即生成方块 
function MainScene:generator(data)
    local nilPosition = {}
    for i = 1 , 16 do
        if t[i] == nil then
            table.insert(nilPosition , i)
        end
    end
    local pos = math.ceil(math.random(0 , #nilPosition))
    if pos == 0 then
        pos = 1
    end
    local index = nilPosition[pos]
    local rect = import(".Tile", CUR_MODULE):new()
    if data == nil then
        if math.random() > 0.7 then
            data = 4
        else
            data = 2
        end
    end
    rect:setData(data)
    rect:setPosition(getTilePosByIndex(index))
    t[index] = rect
    gameLayer:addChild(rect)
    if not cheackValid() then
        print(gameOver)
        self:start()
    end
end

function MainScene:createBg()
    bg = display.newRect(470, 470)
    bg:setFill(true)
    bg:setLineColor(ccc4FFromccc4B(hexToColor("#FFCCCCCC")))
    bg:setPosition(ccp(display.cx, display.cy))
    gameLayer:addChild(bg)
    for i = 1 , 16 do
        local rect = display.newRect(100, 100)
        rect:setFill(true)
        rect:setLineColor(ccc4FFromccc4B(hexToColor("#FF999999")))
        local row , colum = getRowAndColumByIndex(i)
        rect:setPosition(ccp(posx + (colum - 1) * (tileWidth + gap) + 50, display.height - (posy + row * (tileWidth + gap)) + 70))
        gameLayer:addChild(rect)
    end
end

function MainScene:onEnter()
    if device.platform == "android" then
        -- avoid unmeant back
        self:performWithDelay(function()
            -- keypad layer, for android
            local layer = display.newLayer()
            layer:addKeypadEventListener(function(event)
                if event == "back" then app.exit() end
            end)
            self:addChild(layer)

            layer:setKeypadEnabled(true)
        end, 0.5)
    end
end

function MainScene:onExit()
end

return MainScene
