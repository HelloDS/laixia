


local xzmj = xzmj;
local sch  = require "framework.scheduler"
local GameLayer = class("GameLayer", import("...BaseView"))
function GameLayer:ctor(...)
    GameLayer.super.ctor(self)
    self:init()

    audio.setMusicVolume(0.5)
   -- self:PlayMusic( xzmj.soundEnum.BUTTON_BACKGROUND_1 )
end

function GameLayer:init()
    self.mPathArray = 
    {
        "games/xzmj/mainview/qqunfuli_guanggao.png",
        "games/xzmj/mainview/rechargefuli_guanggao.png",
        "games/xzmj/mainview/yuanxiaojiehuodong_guanggao.png",
    }

    self:onShow()





end

function GameLayer:GetCsbName()
    return "GameLayer"
end
local pageIdx = 1

function GameLayer:onShow(data) 
    -----------------------
    --获取本层节点
    -----------------------
    self:InjectView("Panel_2")
    self:InjectView("LanternPanel")
    self:InjectView("Image_1")
    self:InjectView("Image_2")
    self:InjectView("PageView_1")
    self:InjectView("Image_3")
    self:InjectView("Panel_1")
    self.PageView_1:addEventListener(handler(self, self.onPageViewEvent))

    self:AddWidgetEventListenerFunction(self.Image_1, handler(self, self.youxichangf) )
    self:AddWidgetEventListenerFunction(self.Image_2, handler(self, self.bisaichangf) )

    self:updatePageView()


    -----------------------
    --外部节点
    -----------------------
    -- 加载顶部退出框
    local ExitNode = xzmj.layer.ExitNode
    self.mExitNode = ExitNode.new()
    self.mExitNode:SetCloseBtn( false )
    self.mExitNode:setAnchorPoint(0,1)
    self.mExitNode:setPosition(cc.p( 0, 635))
    self:addChild( self.mExitNode );

    -- 加载底部用户数据层
    local UserInfoLayer = xzmj.layer.UserInfoLayer
    self.mUserInfoLayer = UserInfoLayer.new()
    self.mUserInfoLayer:setAnchorPoint(0,1)
    self.mUserInfoLayer:UpdateDate()
    self.mUserInfoLayer:setPosition(cc.p( 0, -15))
    self:addChild( self.mUserInfoLayer );


    -- 跑马灯层
    local FriendLayerPanel = self.LanternPanel
    local RunLanternLayer = xzmj.layer.RunLanternLayer
    self.mRunLanternLayer = RunLanternLayer.new()
    self.mRunLanternLayer:setAnchorPoint(0.5,0.5)
    self.mRunLanternLayer:setPositionX(-400)
    FriendLayerPanel:addChild( self.mRunLanternLayer );


end 

--当前显示的页码(1 ~ pages)
local pageIdx = 1

function GameLayer:addPage(pIdx, iIdx, bClone)
    local newPage = nil
    if not bClone then
        newPage = self.PageView_1:getPage(0)
    else
        newPage = self.PageView_1:getPage(0):clone()
    end
    newPage:setTag(pIdx)
    local adImg = newPage:getChildByName("Image_3")
    adImg:loadTexture(self.mPathArray[pIdx])
    adImg:setSwallowTouches(false)
    adImg:setTouchEnabled(true)
    self.PageView_1:insertPage(newPage, iIdx)
 
end
 
--
function GameLayer:updatePageView()

    --删除原来的页面(第一页保留用于clone)
    for i = #self.PageView_1:getPages() - 1, 1, -1 do
        self.PageView_1:removePageAtIndex(i) 
    end
    --添加新的页面(每页显示6个)
    local pages = #self.mPathArray
 
    pageIdx = 1
 
    if 1 == pages then
        self:addPage(1, 0, false)
        self.PageView_1:scrollToPage(1)

    elseif 2 == pages then
        self:addPage(2, 0, false)
        self:addPage(1, 1, true)
        self:addPage(2, 2, true)
        self.PageView_1:scrollToPage(1)
    elseif pages >= 3 then
        self:addPage(pages, 0, false)
        self:addPage(1, 1, true)
        self:addPage(2, 2, true)
        self.PageView_1:scrollToPage(1)
    end
end


function GameLayer:onPageViewEvent(sender, eventType)
    if eventType == ccui.PageViewEventType.turning then
        local pages = #self.mPathArray
        local nextPageIdx = 0
        local curPageIndex = sender:getCurPageIndex()
        if pages >= 3 then
            if curPageIndex == 0 then
                pageIdx = pageIdx - 1
                if pageIdx <= 0 then pageIdx = pages end
 
                nextPageIdx = pageIdx - 1
                if nextPageIdx <= 0 then nextPageIdx = pages end
                sender:removePageAtIndex(2)
                self:addPage(nextPageIdx, 0, true)
                --PageView的当前页索引为0,在0的位置新插入页后原来的页面0变为1;
                --PageView自动显示为新插入的页面0,我们需要显示为页面1,所以强制滑动到1.
                sender:scrollToPage(1)
                --解决强制滑动到1后回弹效果
                sender:update(10)   
            elseif curPageIndex == 2 then
                pageIdx = pageIdx + 1
                if pageIdx > pages then pageIdx = 1 end
                nextPageIdx = pageIdx + 1
                if nextPageIdx > pages then    nextPageIdx = 1 end
                sender:removePageAtIndex(0)
                self:addPage(nextPageIdx, 2, true)
                sender:scrollToPage(1)
                -- sender:update(10)
            end
        elseif pages == 2 then
            if curPageIndex == 0 then
                nextPageIdx = 0
                if 1 == pageIdx then
                    pageIdx = 2
                    nextPageIdx = 1
                else
                    pageIdx = 1
                    nextPageIdx = 2
                end
                sender:removePageAtIndex(2)
                self:addPage(nextPageIdx, 0, true)
                --PageView的当前页索引为0,在0的位置新插入页后原来的页面0变为1;
                --PageView自动显示为新插入的页面0,我们需要显示为页面1,所以强制滑动到1.
                sender:scrollToPage(1)
                --解决强制滑动到1后回弹效果
                -- sender:update(10)   
 
            elseif curPageIndex == 2 then
                nextPageIdx = 0
                if 1 == pageIdx then
                    pageIdx = 2
                    nextPageIdx = 1
                else
                    pageIdx = 1
                    nextPageIdx = 2
                end
                sender:removePageAtIndex(0)
                self:addPage(nextPageIdx, 2, true)
            end
        end
    end
end


function GameLayer:youxichangf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print("youxichangf---------")
         xzmj.MainCommand:InTypeJumpView(10)


    end
end

function GameLayer:bisaichangf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print("bisaichangf---------")
        xzmj.MainCommand:InTypeJumpView(2)

    end

end

function GameLayer:enterPlayGround(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
        print("点击好友房按钮")
	end
end


function GameLayer:UpdateDate()
    if self.mUserInfoLayer then

    end
end




function GameLayer:onEnter()
    self.mScheduler = sch.scheduleGlobal(function ()
           self.PageView_1:scrollToPage(2)
    end, 3)
end 
function GameLayer:onExit()
    if self.mScheduler then
        sch.unscheduleGlobal( self.mScheduler )
        self.mScheduler = nil
    end
end 
return GameLayer




--[[

            local stream = laixiaddz.Packet.new("tableChat", "play_card")
            stream:setValue("room_id", ui.CardTableDialog.mRoomID)
            stream:setValue("table_id", ui.CardTableDialog.hDeskID)
            stream:setValue("type", 1)
            stream:setValue("info", self:GetWidgetByName("Label_TextChat", sender):getString())
            stream:setValue("msg_id","table_chat")
            laixiaddz.net:sendSocketPacket(stream)






    local packet = l_PacketObj.new("CSPlayCards", "play_card")
    packet:setValue("room_id", self.mRoomID)-- 写入包数据
    packet:setValue("table_id", self.hDeskID)
    local send_cards = {}
    for i=1,#self.mDiscardCards do
        send_cards[i] =self.mDiscardCards[i].CardValue
    end
    if #self.mDiscardCards ~= 0 then
        packet:setValue("cards", send_cards )
    end
    local send_mshowPoker = {}
    for i=1,#mshowPoker do
        send_mshowPoker[i] =mshowPoker[i].CardValue
    end
    if #send_mshowPoker ~= 0 then
        packet:setValue("replace_cards", send_mshowPoker )
    end
    packet:setValue("card_type", PoketType )
    packet:setValue("pid",laixiaddz.LocalPlayercfg.LaixiaPlayerID)
    packet:setValue("msg_id","play_card")
    -- laixiaddz.net.sendPacketAndWaiting(packet)
    laixiaddz.net:sendSocketPacket(packet)




]]--
















