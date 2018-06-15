


local NoticeLayer = class("NoticeLayer" , import("common.base.BaseDialog"))
local scene = cc.Director:getInstance():getRunningScene()
local isshow = false

function NoticeLayer:ctor()
    if isshow == true then
        return
    end
    NoticeLayer.super.ctor(self, "new_ui/NoticeLayer.csb")
    self:init()
    local function onNodeEvent(event)
        if "enter" == event then
            isshow = true
        elseif "exit" == event then
            isshow = false
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function NoticeLayer:init()
    
    self.Panel_root = _G.seekNodeByName(self.rootNode,"Panel_root")
    self.Text_content = _G.seekNodeByName(self.rootNode,"Text_content")

    self.Button_back = _G.seekNodeByName(self.Panel_root,"Button_back")
    self.Button_back:addTouchEventListener(handler(self, self.onback))

    self.Button_know = _G.seekNodeByName(self.Panel_root,"Button_know")
    self.Button_know:addTouchEventListener(handler(self, self.onback))

    self.Text_content:setString("")
    self:SetNoticeText()

end
 
function NoticeLayer:onback(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:removeFromParent()
    end
end

function NoticeLayer:SetNoticeText(  )
    local stream =  laixia.Packet.new("notice", "LXG_NOTICE_GET")
    stream:setReqType("get")
    stream:setValue("type", 2)
    stream:setValue("query_type", 1)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        local notStr = ""
        if data1.dm_error == 0 then
            for k,v in pairs(data1.data) do
                notStr = notStr .. v.content.."\n"
            end
            if self.Text_content then
                -- 报错!
                self.Text_content:setString( notStr )
            end
        else
            scene:popUpTips(data1.error_msg)
        end 
    end) 
end

return NoticeLayer


















