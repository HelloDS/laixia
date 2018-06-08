



local UserInfoLayer = class("UserInfoLayer", import("...BaseView"))

function UserInfoLayer:ctor(...)
    UserInfoLayer.super.ctor(self)
    self:InjectView("UserNameTxt")
  	self:InjectView("JinbiBtn")
    self:InjectView("jinbi")
    self:InjectView("laidouText")
    self:InjectView("ProjectNode_1")
  	self:AddWidgetEventListenerFunction(self.JinbiBtn, handler(self, self.GotoShop))
  	self:InjectView("laidou")
  	self:AddWidgetEventListenerFunction(self.laidou, handler(self, self.LaidouTips))
    --头像
    self:InjectView("Image_1")
    self:AddWidgetEventListenerFunction(self.Image_1, handler(self, self.GotoPersonCenter))

    

    self:UpdateDate(...)
    self:onShow(...)
end

function UserInfoLayer:UpdateDate( ... ) 

    local modle = xzmj.Model.GameLayerModel.mInfo
    self.UserNameTxt:setString(modle.mName)

    local modle = xzmj.Model.GameLayerModel.mInfo
    self.jinbi:setString(modle.mJinbi)
    self.laidouText:setString(modle.mLaidou)

end

function UserInfoLayer:onShow( ... )
end

function UserInfoLayer:LaidouTips(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
    xzmj.soundManager.playEffect(xzmj.soundEnum.BUTTON_CHUPAI,false)
    self.laidou:setTouchEnabled(false)
		print("显示来豆的小弹窗 dianjilaidou")
    local LaidouTips = xzmj.layer.LaidouTips.new()
    local ProjectNode_1_x = self.ProjectNode_1:getPositionX()
    LaidouTips:setPosition(cc.p(ProjectNode_1_x+self.laidou:getPositionX(),self.laidou:getPositionY()+self.laidou:getContentSize().height))
    self:addChild(LaidouTips)
    local dela = cc.DelayTime:create(2)
    local fun = function()
      LaidouTips:removeFromParent()
      self.laidou:setTouchEnabled(true)
    end
    local func = cc.CallFunc:create(fun)
    local seq = cc.Sequence:create(dela,func)
    LaidouTips:runAction(seq)
	end
end

function UserInfoLayer:GotoPersonCenter(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
    xzmj.soundManager.playEffect(xzmj.soundEnum.BUTTON_CHUPAI,false)
		print("点击头像")
     local PersonCenterTips = xzmj.layer.PersonCenterTips.new()
     PersonCenterTips:Show()
	end
end

function UserInfoLayer:GotoShop(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
		print("点击金币按钮,前往商城")
    xzmj.soundManager.playEffect(xzmj.soundEnum.BUTTON_CHUPAI,false)
    end
end 

function UserInfoLayer:GetCsbName()
    return "UserInfoLayer"
end 


return UserInfoLayer

