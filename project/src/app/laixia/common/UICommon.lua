--[[
********************************************************
    @date:       2018-3-14
    @author:     zl
    @version:    1.0
    @describe:   公共方法
********************************************************
]]

--[[
    通用按钮点击事件(放大缩小效果)
]]
function _G.onTouchButton(eventType , eventObj)
    local function setButtonEffect(node, start)
        local small = cc.ScaleTo:create(0.005 , 0.95 , 0.95)
        local big = cc.ScaleTo:create(0.003 , 1.05 , 1.05)
        local normal = cc.ScaleTo:create(0.02 , 1, 1)

        if start then
            node:runAction(small)
        else
            node:runAction(cc.Sequence:create(big , normal))
        end
    end
    if eventType == ccui.TouchEventType.began then
        setButtonEffect(eventObj,true)
--        audio.playSound("src/common/res/effect/buttonclick.mp3" , false)
    elseif eventType == ccui.TouchEventType.ended then
        setButtonEffect(eventObj,false) 
    elseif eventType == ccui.TouchEventType.canceled then
        setButtonEffect(eventObj,false)
    end
end