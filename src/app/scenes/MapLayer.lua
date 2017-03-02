--
-- Author: Your Name
-- Date: 2017-02-28 15:19:23
--
local MapLayer = class("MapLayer", function()
    return display.newLayer("MapLayer")
end)

AStar = require("app.scenes.AStar").new()

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

	-- 不能连续点击
	self.mIsTouch = true
end
--
-- 创建格子地图 铺满屏幕
function MapLayer:createMapBox()
	local tagVector = {}
	-- 障碍物
	local obstacleVector = ObstacleObj:getVector()

	for i=0,NUM_COL do
		for j=0,NUM_ROW do
			local box = display.newSprite(Road_Box)
			box:setAnchorPoint(cc.p(0, 0))
			box:setPosition(cc.p(0 + j * boxWight ,0 + i * boxHeight))
			self:addChild(box)
			-- 标识
			box:setTag(100 * i + j)
			table.insert(tagVector, 100 * i + j)
		end
	end

	for i,tag in ipairs(obstacleVector) do
		
		local box = display.newSprite("road1.png")
		box:setAnchorPoint(cc.p(0, 0))
		box:setPosition(cc.p(tag % 100 * boxWight ,math.floor(tag / 100) * boxHeight))
		self:addChild(box)

	end

	AStar:newMap(tagVector, obstacleVector)

	local tag = 101
	self.mBall = display.newSprite("ball.png")
	self.mBall:setPosition(cc.p(tag % 100 * boxWight, math.floor(tag / 100) * boxHeight))
	self.mBall.tag = tag
	self.mBall:setAnchorPoint(cc.p(0, 0))
	self:addChild(self.mBall)
end

-- 监听事件
function MapLayer:initTouch()
	self:setTouchEnabled(true)
    self:setTouchCaptureEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
    	if event.name == "began" then

    		if self.mIsTouch == false then
    			return false
    		end
    		self.mIsTouch = false
    		local endTag = self:getTagByPos(event.x,event.y)
    		print(self.mBall.tag)
    		print(endTag)
    		local ret = AStar:start(self.mBall.tag, endTag)
    
    		if ret then
    			
    			local actions = {}

    			for i,tag in ipairs(ret) do
    				local moveAc = cc.MoveTo:create(0.1, cc.p(tag % 100 * boxWight, math.floor(tag / 100) * boxHeight))
	    			local callBack = cc.CallFunc:create(function ()
	    				self.mBall.tag = tag
	    			end)
    				table.insert(actions, moveAc)
    				table.insert(actions, callBack)
    			end

    			local callBack = cc.CallFunc:create(function ()
    				self.mIsTouch = true
    			end)
    			table.insert(actions, callBack)
    			self.mBall:runAction(cc.Sequence:create(actions))

    		else
    			print("点击错误")
    			self.mIsTouch = true
    		end

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

-- 是否为障碍
function MapLayer:checkIsObstacle()
	





end

return MapLayer