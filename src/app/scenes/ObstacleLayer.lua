--
-- Author: Your Name
-- Date: 2017-03-01 14:32:30
--
local ObstacleLayer = class("ObstacleLayer", function()
    return display.newLayer("ObstacleLayer")
end)

local Road_Box = "road.png"  -- 正常格子
local boxWight  = 50
local boxHeight = 50
local NUM_ROW = math.floor(display.width  / boxWight)    -- 行
local NUM_COL = math.floor(display.height / boxHeight)    -- 列

-------------------[[----------初始化相关-----------]]---------------------------
function ObstacleLayer:ctor(callback)
	
	-- 创建地图格子
	self:createMapBox()

	-- 监听按钮
	self:initTouch()

	-- 添加按钮
	local addBtn = UIHelper.createButton({
		normal   = "c_1.png", 
        buttonClick = function (event)
        	callback()
        	self:removeFromParent()
        end
	})
	addBtn:setPosition(cc.p(50, display.height - 20))
	self:addChild(addBtn)
	
end

-- 创建格子地图 铺满屏幕
function ObstacleLayer:createMapBox()
	self.mTagVector = {}

	for i=0,NUM_COL do
		for j=0,NUM_ROW do
			local box = display.newSprite(Road_Box)
			box:setAnchorPoint(cc.p(0, 0))
			box:setPosition(cc.p(0 + j * boxWight ,0 + i * boxHeight))
			self:addChild(box)
			-- 标识
			box:setTag(100 * i + j)
			table.insert(self.mTagVector, box)
		end
	end

end

-- 监听事件
function ObstacleLayer:initTouch()
	self:setTouchEnabled(true)
    self:setTouchCaptureEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
    	if event.name == "began" then

    		local tag = self:getTagByPos(event.x,event.y)
    		local node = self:getNodeByTag(tag)
  			
  			if node.obstacle then
  				node.obstacle:removeFromParent()
  				node.obstacle = nil
  				ObstacleObj:removeTag(tag)
  			else
  				local temp = display.newSprite("road1.png")
				temp:setAnchorPoint(cc.p(0, 0))
				node:addChild(temp)
				node.obstacle = temp
				ObstacleObj:addTag(tag)
  			end
  			
	        return true
        end

        if event.name == "ended" then
        end
    end)
end

-- 找到具体地图点
function ObstacleLayer:getNodeByTag(tag)
	
	local node = nil
	for k,v in pairs(self.mTagVector) do
		if v:getTag() == tag then
			node = v
			break
		end
	end
	return node
end

-------------------[[----------功能函数-----------]]---------------------------
-- 根据坐标获取标识
function ObstacleLayer:getTagByPos(x, y)
	
	local w = math.floor(x / boxWight)
	local h = math.floor(y / boxHeight)

	return w + h * 100
end

return ObstacleLayer