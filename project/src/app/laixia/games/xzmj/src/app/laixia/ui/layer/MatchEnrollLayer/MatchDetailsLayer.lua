
--[[
    比赛详情界面
]]--


local MatchDetailsLayer = class("MatchDetailsLayer", xzmj.ui.BaseDialog)
function MatchDetailsLayer:ctor(...)
    MatchDetailsLayer.super.ctor(self)

    self:InjectView("TablePanel")
    self:InjectView("TimeText")
    self:InjectView("Numtext")
    self:InjectView("NumTextBilie")--"报名人数比例"
    self:InjectView("BisaiJieSaoText")
    self:InjectView("BaomingBtn")
    self:InjectView("Image_10")
    self:AddWidgetEventListenerFunction(self.BaomingBtn,handler(self,self.BaomingBtnf))

    self:init()

    self:InjectView("LoadingBar_1")
    self:InjectView("Node_1")

    -- self.LoadingBar_1:setType(0)
    -- self.LoadingBar_1:setPercentage(0.5)

    local image = display.newSprite("games/xzmj/MatchEnrollLayer/sng_jindutiao.png")
    local progress = cc.ProgressTimer:create(image)
    progress:setType(0)
    progress:setAnchorPoint(0.5,0.5)
    --progress:setPosition(976.54,206.32)
    self.Node_1:addChild( progress,9999 )
    progress:setPercentage(10)
    self.progress = progress
    self.LoadingBar_1:setVisible(false)


end
function MatchDetailsLayer:BaomingBtnf(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("点击返回按钮")
        -- self.progress:setPercentage(self.progress:getPercentage()+10)--100-MAX
        -- self.BisaiJieSaoText:ignoreContentAdaptWithSize(false); 
        self.BisaiJieSaoText:setSize(800,100)
        --self.BisaiJieSaoText:setContentSize(800,100)
        self.BisaiJieSaoText:setString("国际在线消息（记者 肖中仁）：今年第一季度，第三产业增加值对中国国内生产总值增长的贡献率约为６２％，高于第二产业２５个百分点。最终消费支出对经济增长的贡献率约为７８％。中国供给侧结构性改革扎实推进，经济结构继续优化。")
    end
end 
function MatchDetailsLayer:GetCsbName()
    return "MatchDetailsLayer"
end
function MatchDetailsLayer:init()
    
end

function MatchDetailsLayer:UpdateDate( data ) 
    self.TimeText:setString("ssssss")
    self.Numtext:setString("ssssss")
    self.NumTextBilie:setString("ssssss")
    self.BisaiJieSaoText:setString("ssss")
end 


return MatchDetailsLayer

