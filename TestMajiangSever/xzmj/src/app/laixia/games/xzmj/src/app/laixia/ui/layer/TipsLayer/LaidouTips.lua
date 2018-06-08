--
-- Author: Feng
-- Date: 2018-04-19 15:14:13
--
--
-- Author: Feng
-- Date: 2018-04-17 17:44:04
--
local LaidouTips = class("LaidouTips", import("...BaseView"))

function LaidouTips:GetCsbName()
    return "LaidouTips"
end 

function LaidouTips:ctor(...)
   LaidouTips.super.ctor(self)

   self:InjectView("Text_des")
   self.Text_des:setString(xzmj.langauto.langTable[1])

end

function LaidouTips:CutNode(data)

end

return LaidouTips

