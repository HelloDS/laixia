

--[[
    游戏内聊天的itemnode
]]--

local talk_info = class("talk_info", import("...BaseView"))

function talk_info:ctor(...)
 	talk_info.super.ctor(self)

    self:InjectView("MiaoShu")
    self:InjectView("Button_info")
    self:InjectView("Text_info")

end



function talk_info:render( data )
    self.Text_info:setString(data)
end

function talk_info:GetCsbName()
    return "talk_info"
end 

return talk_info

