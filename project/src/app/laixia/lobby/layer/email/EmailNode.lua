--
-- @Author: shegnli
-- @Date:   2018-05-08 18:26:29
-- 

local EmailNode = class("EmailNode" ,function()
    return ccui.Layout:create() 
end)

--[[
 * 构造函数
--]]
function EmailNode:ctor()
    self:init()
end

--[[
 * 初始化
--]]
function EmailNode:init()
    local pen = ccui.Layout:create() 
    self:addChild(pen)
    local csbNode = cc.CSLoader:createNode("new_ui/EmailNode.csb")
	csbNode:setAnchorPoint(0, 0)
	csbNode:setPosition(0,0)
	pen:addChild(csbNode)
    self.Image_photo = _G.seekNodeByName(csbNode,"Image_photo")
    self.Text_content = _G.seekNodeByName(csbNode,"Text_content")
    self.Text_content:enableOutline(cc.c4b(153, 108, 67, 255), 2)
    self.Text_time = _G.seekNodeByName(csbNode,"Text_time")
    self.Text_time:enableOutline(cc.c4b(153, 108, 67, 255), 2)
    self.Text_year = _G.seekNodeByName(csbNode,"Text_year")
    self.Text_year:enableOutline(cc.c4b(153, 108, 67, 255), 2)
end

--[[
 * 初始化界面
 * @param  data = {content,id,is_del,mail_id,send_time,status,type,uid}
--]]
function EmailNode:loadData(data)
    self.Image_photo:loadTexture("new_ui/email/tubiao.png")
    self.Text_content:setString(str)
    self:setContentSize(cc.size(638,145))
    local time = data.send_time
    local time1 = data.send_time
    local time2 = data.send_time
    time1 = string.sub(time, 1, 10)
    time2 = string.sub(time, 12, string.len(time))
    print("timetiem",time1)
    print("timetiem",time2)
    self.Text_time:setString(time1)
    self.Text_year:setString(time2)
    local content
    if data.content then
        content = data.content
    else
        content = ""
    end
    self.Text_content:setString(content)
end

return EmailNode