--
-- Author: Feng
-- Date: 2018-04-19 20:26:05
--
--
-- Author: Feng
-- Date: 2018-04-19 15:14:13
--

local PersonCenterTips = class("PersonCenterTips", xzmj.ui.BaseDialog)

function PersonCenterTips:GetCsbName()
    return "PersonCenterTips"
end 

function PersonCenterTips:ctor(...)
   PersonCenterTips.super.ctor(self)
   self:setCanceledOnTouchOutside(true)

  	self:toShowPopupEffert(2)

   -- self:InjectView("Text_des")
   -- self.Text_des:setString(xzmj.langauto.langTable[1])

end

function PersonCenterTips:CutNode(data)

end

return PersonCenterTips

