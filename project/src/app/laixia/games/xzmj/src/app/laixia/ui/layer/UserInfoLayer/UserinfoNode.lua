



local UserinfoNode = class("UserinfoNode", import("...BaseView"))

function UserinfoNode:ctor(...)
  	UserinfoNode.super.ctor(self)

    self:InjectView("jinbi")
    self:InjectView("laidouText")
  	self:InjectView("JinbiBtn")

  	self:AddWidgetEventListenerFunction(self.JinbiBtn, handler(self, self.JinbiBtnf) )

    self:UpdateDate(...)

end

function UserinfoNode:UpdateDate(...)

    local modle = xzmj.Model.GameLayerModel.mInfo
    self.jinbi:setString(modle.mJinbi)
    self.laidouText:setString(modle.mLaidou)

end

function UserinfoNode:JinbiBtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
		print("UserinfoNode____exit====")
    end
end 


function UserinfoNode:GetCsbName()
    return "UserinfoNode"
end 

function UserinfoNode:resetData()

end 


return UserinfoNode

