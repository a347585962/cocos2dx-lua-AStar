
local MapLayer = require("app.scenes.MapLayer")
local ObstacleLayer = require("app.scenes.ObstacleLayer")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)

    self:addChild(ObstacleLayer.new(function ()
    	
    	self:addChild(MapLayer.new())

    end))
end

function MainScene:onEnter()
	
end

function MainScene:onExit()

end

return MainScene
