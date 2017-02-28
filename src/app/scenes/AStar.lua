--
-- Author: Your Name
-- Date: 2017-02-28 19:34:42
--

AStar = {} or AStar

-- 初始化地图
function AStar.newMap(mapNodeTagVector, obstacleNodeTagVector)
	
	-- 开列表
	self.mOpenQueue = {}

	-- 闭列表
	self.mCloseQueue = {}

	-- map node tag
	self.mMapNodeTagVector = mapNodeTagVector

	-- Obstacle 障碍物tag
	self.mObstacleNodeTagVector = obstacleNodeTagVector

end

-- 开始寻路
-- 参数 开始tag 结束tag 
function AStar.start(startTag, endTag)
	
	self.mStartTag = startTag
	self.mEndTag   = endTag

	self.mOrder = 1  -- 节点放入队列的顺序，用于排序比较

	-- 容错
	if startTag == endTag then
		return nil
	end

	-- 目标TAG不符合条件（障碍物）
	if self:checkIsObstacle(endTag) then
		return nil
	end

	-- 将起始节点放入开队列
	-- 每个节点的数据类型
	local startNodeData = {
		tag = startTag,
		F   = 0 ,
		G   = 0 , 
		H   = 0 ,
		order = 0,
	}

	table.insert(self.mOpenQueue, startNodeData)

	while (table.nums(self.mOpenQueue) > 0)
	do
		local currentNode = self.mOpenQueue[1]

		-- 得到第一个四周的方块，加入开列表





	end

end

-- 判断是否为地图点
function AStar:checkIsMap()
	-- body
end

-- 判断是否为障碍物
function AStar:checkIsObstacle(tag)
	
	local isObstacle = false
	for k,v in pairs(self.mObstacleNodeTagVector) do
		
		if v == tag then
			isObstacle = true
			break	
		end

	end
	return isObstacle

end

-- 得到周围方块
function AStar:getAroundNode(tag)
	
	-- 根据tag获取方向
	local nodeW = tag % 100
	local nodeH = math.floor(tag / 100)

	--下
	local downTag  = (nodeH - 1) * 100 + nodeW
	local leftTag  = nodeH * 100 + ( nodeW - 1 )
	local topTag   = (nodeH + 1) * 100 + nodeW
	local rightTag = nodeH * 100 + nodeW

	-- 下
	local ret = {}
	function getData(tempTag)
		if self:checkIsMap(tempTag) and checkIsObstacle(tempTag) then
			local temp = self:getNodeData(tempTag)
			table.insert(ret, temp)
		end
	end
	getData(downTag)
	getData(leftTag)
	getData(topTag)
	getData(rightTag)

	return ret

end

-- 获取节点数据 数据格式如下
--[[ 
data = {
	tag = tag,   tag值
	F   = 0 ,    F 评估值 F = G + H
	G   = 0 ,    当前node到开始节点的距离
	H   = 0 ,    当前node到结束节点的距离
	order = 0,   加入
}
]]--
function AStar:getNodeData(tag)
	-- 根据tag获取方向
	local nodeW = tag % 100
	local nodeH = math.floor(tag / 100)

	local GValue = self:getLengh(tag, self.mStartTag)
	local HValue = self:getLengh(tag, self.mEndTag )

	self.mOrder = self.mOrder + 1

	local ret = {
		tag = tag,  
		F   = HValue + GValue,   
		G   = GValue ,   
		H   = HValue ,   
		order = self.mOrder,
	}

	return ret
end

-- 获取两个节点的距离
function AStar:getLengh(currentTag, targetTAG)
	return math.abs(currentTag % 100 - targetTAG % 100 ) + math.abs(math.floor(currentTag / 100) - math.floor(targetTAG / 100))
end
