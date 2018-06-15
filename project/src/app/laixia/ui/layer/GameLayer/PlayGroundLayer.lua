--
-- Author: Feng
-- Date: 2018-04-13 10:14:49
--


local PlayGroundLayer = class("PlayGroundLayer", import("...BaseView"))

function PlayGroundLayer:ctor(...)
    PlayGroundLayer.super.ctor(self)
    self:init()
end

function PlayGroundLayer:init()
	self:onShow()
    self:UpdateDate()
end

function PlayGroundLayer:GetCsbName(  )
    return "PlayGroundLayer"
end

function PlayGroundLayer:onShow(data) 
    print(" ===============youxichang============== ")
    -----------------------
    --获取本层节点
    -----------------------
    self:InjectView("Image_junior")
    self:InjectView("Image_middle")
    self:InjectView("Image_high")
    self:InjectView("Button_start")
    self:InjectView("Node_1")
    self:InjectView("Node_2")

    self:AddWidgetEventListenerFunction(self.Image_junior,handler(self,self.chujichang))
    self:AddWidgetEventListenerFunction(self.Image_middle,handler(self,self.zhongjichang))
    self:AddWidgetEventListenerFunction(self.Image_high,handler(self,self.gaojichang))
    self:AddWidgetEventListenerFunction(self.Button_start,handler(self,self.Button_startf))


    for i=0,3 do
    	self:InjectView("Text_difen_" .. i)
    	self:InjectView("Text_zr_" .. i)
   	 	self:InjectView("Text_peopnum_" .. i)
    end

    -----------------------
    --外部节点
    -----------------------

    local playNode = xzmj.layer.ExitNode
    self.playNode = playNode.new()
    self.playNode:setAnchorPoint(0,1)
    self.playNode:setPosition(self.Node_1:getPosition())
    self:addChild(self.playNode)

    -- 加载底部用户数据层
    local UserInfoLayer = xzmj.layer.UserInfoLayer
    self.mUserInfoLayer = UserInfoLayer.new()
    self.mUserInfoLayer:setAnchorPoint(0,1)
    self.mUserInfoLayer:setPosition(self.Node_2:getPosition())
    self:addChild( self.mUserInfoLayer )

end 

function PlayGroundLayer:chujichang(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		print("chujichang")
	end
end

function PlayGroundLayer:zhongjichang(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		print("zhongjichang")
	end
end

function PlayGroundLayer:Button_startf( sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("Button_startf===")
    end
end


function PlayGroundLayer:gaojichang(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
        print("gaojichang===")
	end
end





function PlayGroundLayer:UpdateDate( data )

    local modle = xzmj.Model.PlayGroundModle.mInfo
    self.Text_difen_1:setString("底分：" .. modle.difen1)
    self.Text_difen_2:setString("底分：" .. modle.difen2)
    self.Text_difen_3:setString("底分：" .. modle.difen3)
    self.Text_zr_1:setString("准入：" .. modle.jinru1)
    self.Text_zr_2:setString("准入：" .. modle.jinru2)
    self.Text_zr_3:setString("准入：" .. modle.jinru3)
    self.Text_peopnum_1:setString("人数：" .. modle.nownum1)
    self.Text_peopnum_2:setString("人数：" .. modle.nownum2)
    self.Text_peopnum_3:setString("人数：" .. modle.nownum3)
end

return PlayGroundLayer

