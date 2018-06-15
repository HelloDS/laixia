--
-- Author: peter
-- Date: 2018-04-10 17:26:15
--

local BroadcastWindow = class("BroadcastWindow", import("..CBaseDialog"):new())--, import("...CBaseDialog"):new()

local laixia = laixia

function BroadcastWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_INNER_DIALOG

    --self:setNodeEventEnabled(true)
    --self:setPosition(cc.p(0,display.height))
    self.mMsgNum = 0    --消息数量
    self.mMsgData = {}  --消息内容
    self.delayTime = 0 
    self.isFinish = true
   -- self:setTouchEnabled(false)
    self.currentShowType = nil  
    -- self:setPosition(cc.p(display.cx-150,display.height-180))
end

function BroadcastWindow:dtor(...)
end 

function BroadcastWindow:getName()
    return "BroadcastWindow"
end

function BroadcastWindow:onInit()
    self.super:onInit(self)
    -- ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BROADCAST_WINDOW, handler(self, self.show)) 
end

function BroadcastWindow:onShow(data) 
    self.panelBg=self:getChildByName("Image_Bg")
    self.panel=self:getChildByName("Panel_quyu")
    --self.size_quyu = self.panel:getContentSize()
    self.panelBg:setVisible(false)
    self:CutNode(data)
end 

function BroadcastWindow:resetData()
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom = {} 
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon = {} 
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch = {} 
    laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall = {}
end 

function BroadcastWindow:CutNode(data)
    if self.isFinish == false then
        return
    else
        self.isFinish = false
    end
    local info = self:getCurrentMsgData()
    if info == nil then
        self.panelBg:setVisible(false)
        self.isFinish = true
        return 
    end
    self.panelBg:setVisible(true)
    self.panel:removeAllChildren()
    --裁剪节点
    local txt = display.newTTFLabel({text = info,font = "Airal",size = 12,align = cc.TEXT_ALIGNMENT_CENTER});
    --txt:setColor(cc.);
    local clip = cc.ClippingNode:create();

    --local sp = display.newSprite("res/HelloWorld.png");  --裁剪模板
    -- --local sp = cc.Layer:create()
    -- sp:setContentSize()
    -- sp:setScaleX(0.2);
    -- sp:setAnchorPoint(cc.p(0.5,0.5));
    --sp:setPosition(cc.p(240,400))
    clip:setStencil(sp);

    txt:setAnchorPoint(cc.p(0.5,0.5));
    clip:addChild(txt);

    clip:setInverted(false);    --设置裁剪区域可见还是非裁剪区域可见  这里为裁剪区域可见
    clip:setAlphaThreshold(0);   
    clip:setPosition(320,800);
    self.panel:addChild(clip);
    local function onCompleteCallback()
        self.isFinish = true
        self.panel:removeAllChildren()
        self:ani()
    end
    local funcall= cc.CallFunc:create(onCompleteCallback)

    txt:setPositionX(clip:getContentSize().width+400);
    local time = 15
    local timeW = math.floor(size.width / 100)
    local seq = cc.Sequence:create(cc.MoveTo:create((time + timeW),cc.p(-size.width-100, 0)),
                                    cc.DelayTime:create(self.delayTime),
                                    funcall);
    txt:runAction(seq)

end

function BroadcastWindow:getCurrentMsgData()
    local info = nil 
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

function BroadcastWindow:destroy()
    self:hide();
end 

return BroadcastWindow

