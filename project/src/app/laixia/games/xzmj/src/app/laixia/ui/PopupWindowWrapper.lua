

--[[
    这里面写2级界面的弹窗口效果
]]--


local PopupWindowWrapper = class("PopupWindowWrapper", import(".BaseView"))

function PopupWindowWrapper:ctor()
    PopupWindowWrapper.super.ctor(self)

    self.mask = ccui.Layout:create()
    self.mask:setContentSize(xzmj.winSize.width, xzmj.winSize.height)
    self.mask:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    --self.mask:setBackGroundColorType(1)              -- 填充方式
    self.mask:setBackGroundColorOpacity(100)         -- 颜色透明度
    self:addChild(self.mask,-9999)
    self.mask:setSwallowTouches(true)

    self:OnClick(self.mask, function()
        print(self.__cname,self.isCanceledOnTouchOutside)
        if self.isCanceledOnTouchOutside then
            self:dismiss()
        end
    end,{["isScale"] = false, ["hasAudio"] = false})
end



function PopupWindowWrapper:onEnterFinish()
    -- local mask = ccui.Layout:create()
    -- mask:setContentSize(xzmj.winSize.width, xzmj.winSize.height)
    -- mask:setBackGroundColor(cc.c3b(0, 0, 0))    
    -- --mask:setBackGroundColorType(1)              
    -- mask:setBackGroundColorOpacity(0)         
    -- self:addChild(mask)
    -- mask:setTouchEnabled(true)
    -- -- mask:setSwallowTouches(true)
    
    -- mask:addTouchEventListener(function(sender, eventType)
    -- end)

    -- if mask and tolua.cast(mask,"cc.Node") then
    --     self:removeChild(mask)
    -- end
end


--[[
    弹框效果 style 参数
    1 牌桌内二级弹窗
    2 弹窗放大缩小效果 跟斗地主种效果
]]--
function PopupWindowWrapper:toShowPopupEffert( style )

    if style == 1 then
        self:setScale(0.3)
        local s1 = cc.ScaleTo:create(0.18, 1.1)
        local s2= cc.ScaleTo:create(0.1, 1)
        local seq = cc.Sequence:create(s1,s2)
        self:runAction( seq )
    elseif style == 2 then 
        self:setAnchorPoint(0.5, 0.5)
        self:setPosition(xzmj.winSize.width / 2, xzmj.winSize.height / 2)
        self:setScale(0.3)
        local actionTo = cc.EaseBackOut:create(cc.ScaleTo:create(0.28, 1.02))
        local actionTo2 = cc.EaseSineIn:create(cc.ScaleTo:create(0.1, 1.0))
        local seq = cc.Sequence:create(actionTo,actionTo2)
        self:runAction(seq)
    end


    -- self.mask:setOpacity(0)
    -- self.mask:runAction(cc.Sequence:create(cc.DelayTime:create(0.15), cc.FadeTo:create(0.1, 255)))

    -- local act1 = cc.MoveTo:create(0.01,cc.p(px2,py2)) -- 匀速
    -- local act1 = cc.EaseElasticInOut:create(cc.ScaleTo:create(0.5,1)) -- 弹性缓冲
    -- local act1 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 指数缓冲
    -- local act1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- sine缓冲
    -- local act1 = cc.EaseBackInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 回震缓冲
    -- local act1 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- 跳跃缓冲

    -- local act2 = cc.MoveTo:create(0.5,cc.p(px1,py1)) -- 匀速
    -- local act2 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 弹性缓冲
    -- local act2 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 指数缓冲
    -- local act2 = cc.EaseSineOut:create(cc.MoveTo:create(1,cc.p(px1,py1))) -- sine缓冲
    -- local act2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 回震缓冲
    -- local act2 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 跳跃缓冲

    -- self:runAction(act1)
end



function PopupWindowWrapper:setCanceledOnTouchOutside(cancel)
    self.isCanceledOnTouchOutside = cancel
end

--设置背景透明度
function PopupWindowWrapper:setBGOpacity(opacity)
    self.mask:setOpacity(opacity)
end

function PopupWindowWrapper:dismiss()
    xzmj.runningScene:dismissDialog()
end



return PopupWindowWrapper
