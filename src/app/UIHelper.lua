--
-- Author: wusonglin
-- Date: 2016-09-08 14:50:52
-- UIHelper辅助类
-- 

UIHelper = {}

local shareTextureCache = cc.Director:getInstance():getTextureCache()

-- 根据数字图片创建显示数字的label(0123456789)
--[[
-- 参数
    params = {
        text = "123", -- 需要显示数字
        imgFile = "", -- 数字图片名
        charCount = 10, -- 数字图片上字符个数, 默认 10 个 (0123456789)
        startChar = '0', -- 开始的字符，默认为 '0'（即 48）
    }
 ]]
function UIHelper.newNumberLabel(params)
    local temptexture = shareTextureCache:addImage(params.imgFile)

    local tempSize = temptexture:getContentSize()
    local itemWidth = tempSize.width / (params.charCount or 10)
    local itemHeight = tempSize.height

    local tempLabel = cc.Label:createWithCharMap(temptexture, itemWidth, tempSize.height, params.startChar or 48)
    tempLabel:setString(params.text)
    -- tempLabel:enableOutline(cc.c4b(0, 0, 0, 0), 10)

    return tempLabel
end

function UIHelper.createSprite(path)
    return cc.Sprite:create(path)
end

function UIHelper.dump(tData, hint)
    local tempList = {}
    local lookupTable = {}
    local traceback = string.split(debug.traceback("", 2), "\n")
    print("trace from: " .. string.trim(traceback[3]))

    local function printData(subData, space, name)
        local tempName = (type(name) == "string") and ("\"" .. name .. "\"") or tostring(name)
        if type(subData) == "table" then
            if lookupTable[subData] then
                table.insert(tempList, string.format("%s%s = %s\n", space, tempName, "lookupTable..."))
            else
                lookupTable[subData] = true
                table.insert(tempList, string.format("%s%s = {\n", space, tempName))
                for tempName, tempItem in pairs(subData) do
                    printData(tempItem, space .. "    ", tempName)
                end
                table.insert(tempList, string.format("%s},\n", space))
            end
        else
            local tempValue = (type(subData) == "string") and ("\"" .. subData .. "\"") or tostring(subData)
            table.insert(tempList, string.format("%s%s = %s,\n", space, tempName, tempValue))
        end
    end

    printData(tData, "", hint or "data")
    print(table.concat(tempList, ""))
end

--[[
    params:
    Table params:
    {
        node: 需要屏蔽下层的结点
        allowTouch: 可选参数，是否屏蔽下层触摸
        beganEvent: 可选参数，TOUCH_BEGAN事件回调
        movedEvent: 可选参数，TOUCH_MOVED事件回调
        endedEvent: 可选参数，TOUCH_ENDED事件回调
    }
--]]
function UIHelper.registerSwallowTouch(params)
    local allowTouch = params.allowTouch ~= false

    local  listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(allowTouch)
    listenner:registerScriptHandler(function(touch, event)
        if params.beganEvent then
            return params.beganEvent(touch, event)
        end
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN )
    listenner:registerScriptHandler(function(touch, event)
        if params.movedEvent then
            params.movedEvent(touch, event)
        end
    end,cc.Handler.EVENT_TOUCH_MOVED )
    listenner:registerScriptHandler(function(touch, event)
        if params.endedEvent then
            params.endedEvent(touch, event)
        end
    end,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = params.node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, params.node)
    return listenner
end

-- 全屏屏蔽页
function UIHelper.createSwallowLayer(opacity)
    local layout = display.newLayer(cc.c4b(0, 0, 0, opacity or 0))
    layout:setContentSize(display.width, display.height)
    layout:setAnchorPoint(0, 0)
    layout:setPosition(0, 0)
    UIHelper.registerSwallowTouch({node = layout})
    return layout
end

-- 创建普通按钮
--[[
    params：
    {
        normal      正常状态图片 必须传
        pressed     按下状态图片
        disabled   
        buttonClick 按钮回调
    }
   
--]]
function UIHelper.createButton(params)
    
    local detalScale = params.pressed and 0 or 0.1

    local tempBtn  = cc.ui.UIPushButton.new({
        normal = params.normal,
        pressed = params.pressed or params.normal,
        disabled = params.normal
    })
    tempBtn:onButtonPressed(function(event)
         local scale = event.target:getScale()
         event.target:setScale(scale + detalScale)
        end)
    tempBtn:onButtonRelease(function(event)
            local scale = event.target:getScale()
            event.target:setScale(scale - detalScale)
        end)
    tempBtn:onButtonClicked(params.buttonClick) 

    return tempBtn
end

-- 创建选择状态按钮
--[[
    params：
    {
        on      开启状态
        off     关闭状态
        onButtonStateChanged    按钮状态变化的回调 参数event
    }
--]]
function UIHelper.createCheckButton(params)

    local checkBoxButton = cc.ui.UICheckBoxButton.new(params)
    --处理按钮状态变化
    checkBoxButton:onButtonStateChanged(params.onButtonStateChanged)
    return checkBoxButton
    
end

-- 显示回到首页的对话框 系统对话框
function UIHelper.goHomeAlert()
    NativeHelper.showAlert("Confirm Exit", "Are you sure want to go home?", function (event)
        -- 显示广告 回到home
        NativeHelper:showInterstitialAd()
        display.replaceScene(require("app.scenes.HomeScene").new(), "crossFade" , 0.5)
    end)
end

function javaToLua(param)
    print("java成功调用lua111")
    NativeHelper:showToast("java成功调用lua2222")
    if "success" == param then

        print("java成功调用lua")
        NativeHelper:showToast("java成功调用lua")
    end
end

function UIHelper.showFlashFont(string)
    
    local label = display.newTTFLabel({
        text = string.format(),
        font = "Arial",
        size = 64,
        color = cc.c3b(255, 0, 0), 
    })
    label:setPosition(cc.p(display.cx, display.cy))
    display.getRunningScene():addChild(label, 100)

    local array = {}
    table.insert(array, cc.CallFunc:create(function() label:setVisible(true) end))
    table.insert(array, cc.ScaleTo:create(0.1, 0.5))
    table.insert(array, cc.ScaleTo:create(0.1, 1.0))
    table.insert(array, cc.MoveBy:create(1.5, cc.p(0, 50)))
    table.insert(array, cc.FadeOut:create(0.2))
    table.insert(array, cc.CallFunc:create(function()
    end))

    label:runAction(cc.Sequence:create(array))

end










