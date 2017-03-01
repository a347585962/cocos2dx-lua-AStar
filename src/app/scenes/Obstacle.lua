--
-- Author: Your Name
-- Date: 2017-03-01 15:14:36
--
local Obstacle = class("Obstacle", {})

-- 初始化地图
function Obstacle:ctor()
	self.mObstacle = {}
end

-- 清空列表
function Obstacle:clear()
	self.mObstacle = {}
end

-- 添加障碍物tag
function Obstacle:addTag(tag)
	if self:tagIsInVector(tag) == -1 then
		
		table.insert(self.mObstacle, tag)
		
	end
end

-- 删除障碍物
function Obstacle:removeTag(tag)
	
	for i,v in ipairs(self.mObstacle) do
		if v == tag then
			table.remove(self.mObstacle, i)
		end
	end

end

function Obstacle:getVector()
	return self.mObstacle
end

-- 是否存在
function Obstacle:tagIsInVector(tag)
	
	local find = -1
	for k,v in pairs(self.mObstacle) do
		if v == tag then
			find = 1
			break
		end
	end
	return find

end

return Obstacle

