--
-- Author: AStar
-- Date: 2017-02-28 19:34:42
--

local AStar = class("AStar", {})

-- 初始化地图
function AStar:ctor()

end

function AStar:newMap(mapNodeTagVector, obstacleNodeTagVector)
	
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
function AStar:start(startTag, endTag)
	
	self.mStartTag = startTag
	self.mEndTag   = endTag

	-- 开列表
	self.mOpenQueue = {}

	-- 闭列表
	self.mCloseQueue = {}

	local stepList = {}

	-- 容错
	if self.mStartTag == self.mEndTag  then
		return nil
	end

	-- 目标TAG不符合条件（障碍物）
	if self:checkIsInQueue(self.mEndTag , self.mObstacleNodeTagVector) ~= -1 then
		return nil
	end

	-- 插入
	self:insertOpenQueue(self:getNodeData(self.mStartTag))

	while (#self.mOpenQueue > 0)
	do
		local currentNode = self.mOpenQueue[1]

		-- 加入闭列表
		table.insert(self.mCloseQueue, currentNode)

		--将当前步骤从open列表里面移除
        table.remove(self.mOpenQueue, 1)

        -- 判断当前节点 为终点结束循环
        --如果当前步骤已经是目标步骤,那么完成循环
        if currentNode.tag == self.mEndTag then
            while(currentNode)
            do
                table.insert(stepList, 1, currentNode.tag)
                currentNode = currentNode.parent or nil
            end
            self.mOpenQueue = {}
            self.mCloseQueue = {}
            break
        end

		-- 得到第一个四周的方块，加入开列表
		local tempArroundNode = self:getAroundNode(currentNode.tag)
		for i,step in ipairs(tempArroundNode) do
			-- print("tempArroundNode")
			-- 判断是否在闭列表
			local isInCloseQueue = self:checkIsInQueue(step, self.mCloseQueue)

			-- 判断是否在开列表
			local inOpenQueueIndex  = self:checkIsInQueue(step, self.mOpenQueue)

			if isInCloseQueue == -1 then
				
				if inOpenQueueIndex == -1 then
					
					step.parent = currentNode
					step.G = currentNode.G + 1
                    step.F = step.G + step.H
					--顺序添加到open列表
                    self:insertOpenQueue(step)

                else
                	step = self.mOpenQueue[inOpenQueueIndex]
                	if ((currentNode.G + 1) < step.G) then   --检查G值是否低于当前步骤
                        step.setGScore(currentNode.G + 1)
                        step.G = currentNode.G + 1
                        step.F = step.G + step.H
                        table.remove(self.mOpenQueue, inOpenQueueIndex)
                        self:insertOpenQueue(step)      --值发生了变化,F值也会变, 为了列表有序，需要将此步骤移除，再重新按序插入
                    end

				end

			end

		end
	end

	if #stepList == 0 then
        self.mOpenQueue = {}
        self.mCloseQueue = {}
    end

	return stepList
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
	local rightTag = nodeH * 100 + nodeW + 1

	-- 下
	local ret = {}
	function getData(tempTag)
		if self:checkIsInQueue(tempTag, self.mMapNodeTagVector) ~= -1  and self:checkIsInQueue(tempTag, self.mObstacleNodeTagVector) == -1 then
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

	local ret = {
		tag = tag,  
		F   = HValue + GValue,   
		G   = GValue ,   
		H   = HValue ,   
		order = self.mOrder,
	}

	return ret
end

-- 插入有序开队列
function AStar:insertOpenQueue(step)
	local index = #self.mOpenQueue + 1
    for i, v in ipairs(self.mOpenQueue) do
        if step.F <= v.F then
            index = i
            break
        end
    end

	table.insert(self.mOpenQueue, index, step)
end

-- 检查是否在列表中
function AStar:checkIsInQueue(tag, list)
	local find = -1
    for i, v in ipairs(list) do
    	if type(v) == "table" and v.tag then
    		if v.tag == tag then
	            find = i
	            break
        	end
        else
        	if v == tag then
	            find = i
	            break
        	end
    	end
        
    end
    return find
end

-- 获取两个节点的距离
function AStar:getLengh(currentTag, targetTAG)
	return math.abs(currentTag % 100 - targetTAG % 100 ) + math.abs(math.floor(currentTag / 100) - math.floor(targetTAG / 100))
end

return AStar