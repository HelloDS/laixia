--
-- Author: peter
-- Date: 2017-11-14 14:01:40
--


--local Packet = import("...net.Packet")
local BroadcastWindows = class("BroadcastWindows", import("..CBaseDialog"):new())

local laixia = laixia;
local db2 = laixiaddz.JsonTxtData;
 local commonDBM 

function BroadcastWindows:ctor(...)
	self.hDialogType = DialogTypeDef.DEFINE_INNER_DIALOG

    --self:setNodeEventEnabled(true)
   -- self:setPosition(cc.p(0,display.height))
    self.mMsgNum = 0    --消息数量
    self.mMsgData = {}  --消息内容
    self.delayTime = 0 
    self.isFinish = true
   -- self:setTouchEnabled(false)
    self.currentShowType = nil  
    -- self:setPosition(cc.p(display.cx-150,display.height-180))
end

function BroadcastWindows:dtor(...)
end 

function BroadcastWindows:getName()
    return "BroadcastWindows"
end

function BroadcastWindows:onInit()
    self.super:onInit(self)
    -- if laixia.config.isAudit then
--    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BROADCASTS_WINDOW, handler(self, self.show))  
    -- else
        ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BROADCASTS_WINDOW, handler(self, self.show)) 
    -- end
end

function BroadcastWindows:onShow(data) 
    dump(data,"BroadcastWindows:onShow")
    self.panelBg=self:GetWidgetByName("Image_Bg")
    self.panel=self:GetWidgetByName("Panel_quyu")
    --self.size_quyu = self.panel:getContentSize()
    commonDBM = commonDBM or db2:queryTable("common");
    self.BG = ccui.ImageView:create("new_ui/lobbywindow/gundongtiao.png")
    self.BG:setAnchorPoint(0,0)
    self.BG:addTo(self.panelBg)
    self.BG:setVisible(false)
    self.panelBg:setVisible(false)
    self:CutNode(data)
end 

function BroadcastWindows:resetData()
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom = {} 
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon = {} 
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch = {} 
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall = {}
end 

function BroadcastWindows:CutNode(data)
    if self.isFinish == false then
        return
    else
        self.isFinish = false
    end
    --修改信息
    local info = self:getCurrentMsgData()

    dump(info,"info--data")
    if info == nil then
        self.panelBg:setVisible(false)
        self.BG:setVisible(false)
        self.isFinish = true
        return 
    end
    --这里看一下数据格式 然后推送给转盘 --TODO
    local delayTime = 0
    if info.show == 100 then
        delayTime = 7
    end
    
    local function showPaomadeng()
            self.panelBg:setVisible(true)
            self.BG:setVisible(true)
            if info.show == 100 then
                local data = {}
                data.text = info.BroadCastMsg[2]
                data.award = info.BroadCastMsg[4]
                
                laixiaddz.LocalPlayercfg.TurnWindow_NickName = data.text
                laixiaddz.LocalPlayercfg.TurnWindow_Award = data.award

                cc.UserDefault:getInstance():setStringForKey("turn_name", laixiaddz.LocalPlayercfg.TurnWindow_NickName)
                cc.UserDefault:getInstance():setStringForKey("turn_award", laixiaddz.LocalPlayercfg.TurnWindow_Award)
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REFRESH_TOTURNTABLE_PRICEINFO,data)
            end

            local layer = self:getMessageNode(info)   
            local size = self.panel:getContentSize()
            
            --裁剪节点
            -- local txt = display.newTTFLabel({text = "恭喜，来下斗地主在线人数突破10万人",font = "res/fonts/arial.ttf",size = 24,align = cc.TEXT_ALIGNMENT_CENTER});
            --txt:setColor(Color3B::RED);
            local clip = cc.ClippingNode:create()

            local sp = display.newSprite("new_ui/lobbywindow/paomadeng.png");  --裁剪模板
            -- sp:setContentSize(cc.size(size.width,size.height))
            sp:setScaleX(0.6);
            --sp:setScaleY()
            sp:setAnchorPoint(cc.p(0.5,0.5));
            --sp:setPosition(cc.p(240,400))
            clip:setStencil(sp);
            layer:setAnchorPoint(cc.p(0,0))
            layer:setPosition(cc.p(500,-15))
            clip:addChild(layer)
            local sizelayer = layer:getContentSize()
            -- txt:setAnchorPoint(cc.p(0.5,0.5));
            -- clip:addChild(txt);
            clip:setInverted(false);    --设置裁剪区域可见还是非裁剪区域可见  这里为裁剪区域可见
            clip:setAlphaThreshold(0); 
            clip:setAnchorPoint(0,-0.5)  
            clip:setPosition(160,15);
            self.panel:addChild(clip);
           -- txt:setPositionX(clip:getContentSize().width+600);
            local function removeAlll() 
            self.panelBg:setVisible(false)
            self.BG:setVisible(false)
            --clip:removeAllChildren()
            self.panel:removeAllChildren()
            self.isFinish = true
            end
            local callfun = cc.CallFunc:create(removeAlll)
            local to2 = cc.MoveTo:create(12, cc.p(-sizelayer.width-400, -15));
            layer:runAction(cc.Sequence:create(to2,callfun,NULL));
    end

    self.root:performWithDelay(handler(self,showPaomadeng),delayTime);
    --裁剪节点 --微软雅黑
    -- local txt = display.newTTFLabel({text = "",font = "Airal",size = 12,align = cc.TEXT_ALIGNMENT_CENTER});
    -- -- txt:setAnchorPoint(cc.p(0,-0.5))
    -- -- txt:setPosition(cc.p(0,0))


end

function BroadcastWindows:getCurrentMsgData()
    local info = nil 

    dump(ui.CardTableDialog.mPokerDeskType,"ui.CardTableDialog.mPokerDeskType")
    dump(laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow,"laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow")


    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" then 
        local data =  commonDBM:query("key","roomTime");
        if ui.CardTableDialog.mPokerDeskType == 1 then  
            if self.currentShowType ~= 2 and self.currentShowType ~= nil then 
                self.currentShowType = nil 
                self:resetData()
                return nil 
            end
            if #laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom >0 then 
                self.currentShowType=2
                info = laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom[1] 
                table.remove(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom,1)
                self.delayTime = data.Num 
            end
        elseif ui.CardTableDialog.mPokerDeskType == 2 then 
            if self.currentShowType ~= 3 and self.currentShowType ~= nil then 
                self.currentShowType = nil 
                self:resetData()
                return nil 
            end
            if #laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon >0 then 
                self.currentShowType=3
                info = laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon[1] 
                table.remove(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon,1)
                self.delayTime = data.Num 
            end
        elseif ui.CardTableDialog.mPokerDeskType == 3 then  
            if self.currentShowType ~= 4 and self.currentShowType ~= nil then 
                self.currentShowType = nil 
                self:resetData()
                return nil 
            end
            if #laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch >0 then
                self.currentShowType= 4
                info = laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch[1] 
                table.remove(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch,1)
                self.delayTime = data.Num 
            end
        else 
            return nil 
        end
    else
        local data = commonDBM:query("key","lobbyTime"); 
        if self.currentShowType ~= 6 and self.currentShowType ~= nil then 
            self.currentShowType = nil 
            self:resetData()
            return nil 
        end
        if #laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall >0 then 
           self.currentShowType = 6 
           info = laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall[1] 
           table.remove(laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall,1)           
           self.delayTime = data.Num 
        end
    end 
    return info 
end   

function BroadcastWindows:getMessageNode(info)
    local layer = cc.Layer:create()
    layer:setTouchEnabled(false)
    local allLength = 0
    local height = 0
    local widthList = {}
    local ttfList   = {}

    for k,v in ipairs(info.BroadCastMsg) do
        local dt = v:gsub("金币",laixia.utilscfg.CoinType());
        local ttf = cc.LabelTTF:create(dt, "Arial", 24)
        ttf:setColor(cc.c3b(info.Color[k].color1,info.Color[k].color2,info.Color[k].color3))
        ttf:setAnchorPoint(0,0)
        ttf:addTo(layer)
        local wid = ttf:getContentSize().width
        table.insert(ttfList,ttf)
        table.insert(widthList,wid)
        allLength = allLength + wid
        height = ttf:getContentSize().height
    end
    local beginX = 0
    for k,v in ipairs(ttfList) do
        v:setPosition(cc.p(beginX,0))
        beginX = beginX + widthList[k]
    end
    layer:setContentSize(cc.size(allLength,height))
    
    return layer 
end

function BroadcastWindows:destroy()
end 

return BroadcastWindows.new()

