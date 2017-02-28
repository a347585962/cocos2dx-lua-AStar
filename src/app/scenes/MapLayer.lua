--
-- Author: Your Name
-- Date: 2017-02-28 15:19:23
--
local MapLayer = class("MapLayer", function()
    return display.newLayer("MapLayer")
end)

local Road_Box = "road.png"  -- 正常格子
local boxWight  = 50
local boxHeight = 50
local NUM_ROW = math.floor(display.width  / boxWight)    -- 行
local NUM_COL = math.floor(display.height / boxHeight)    -- 列

-------------------[[----------初始化相关-----------]]---------------------------
function MapLayer:ctor()
	
	-- 创建地图格子
	self:createMapBox()

	-- 监听按钮
	self:initTouch()
end

-- 创建格子地图 铺满屏幕
function MapLayer:createMapBox()
	for i=0,NUM_COL do
		for j=0,NUM_ROW do
			local box = display.newSprite(Road_Box)
			box:setAnchorPoint(cc.p(0, 0))
			box:setPosition(cc.p(0 + j * boxWight ,0 + i * boxHeight))
			self:addChild(box)
			-- 标识
			box:setTag(100 * i + j)
		end
	end
end

-- 监听事件
function MapLayer:initTouch()
	self:setTouchEnabled(true)
    self:setTouchCaptureEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
    	if event.name == "began" then

    		print(self:getTagByPos(event.x,event.y))
	        return true
        end

        if event.name == "ended" then
        end
    end)
end

-------------------[[----------功能函数-----------]]---------------------------
-- 根据坐标获取标识
function MapLayer:getTagByPos(x, y)
	
	local w = math.floor(x / boxWight)
	local h = math.floor(y / boxHeight)

	return w + h * 100
end

return MapLayer