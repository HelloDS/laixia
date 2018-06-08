
--[[
 麻将桌面
]]--

local PokerDeskLayer = class("PokerDeskLayer", import("...BaseView"))
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig

function PokerDeskLayer:ctor(...)
    PokerDeskLayer.super.ctor(self)
    pkModel:onEnter( self )

    self:InjectView("shangicon")

    self:InjectView("xiaicon")

    self:InjectView("zuoicon")
    
    self:InjectView("youicon")
    
    self:InjectView("xpz")
    self.xpz:setVisible(false)

    self.mIconArr = 
    {
        [1] = self.zuoicon,
        [2] = self.xiaicon,
        [3] = self.youicon,
        [4] = self.shangicon,
    }


    -----------------------
    --获取本层节点
    -----------------------
    --返回按钮
    self:InjectView("Button_back")
    --菜单按钮
    self:InjectView("Button_menu")

    --语音按钮
    self:InjectView("Button_voice")

    --聊天按钮
    self:InjectView("Button_info")
    self:AddWidgetEventListenerFunction(self.Button_back,handler(self,self.backFront))
    self:AddWidgetEventListenerFunction(self.Button_menu,handler(self,self.showmenu))
    self:AddWidgetEventListenerFunction(self.Button_info,handler(self,self.showinfo))
    self:AddWidgetEventListenerFunction(self.Button_voice,handler(self,self.Button_voicef))

    self:init()

end

function PokerDeskLayer:init()

    local node = cc.Node:create()
    node:setPosition( 640,360 )
    self:addChild( node )
    local arr = {}
    table.insert(arr, cc.DelayTime:create(0.6))
    table.insert(arr,cc.CallFunc:create(function()
        self:initGameplayerIcon()
        self:initPokerDeskNode()
        ObjectEventDispatch:addEventListener(xzmj.evt[4], handler(self, self.UpdateDateIcon));
        node:removeFromParent()

    end))-- 打开游戏场
    self:runAction(cc.Sequence:create(arr))
    self:playAnimationAt( node,pkcf.STARACT,"Default Timeline",function (  )
    end )
end

--[[
    初始化玩家icon
]]--
function PokerDeskLayer:initGameplayerIcon()
    local count = 4 -- 麻将暂时4个
    self.mGpIconNode = {}

    local icdata = pkModel.mIcondata

    self.mUserUid = xzmj.Model.GameLayerModel:GetUid()

    self.mUserSeat = nil
    for k,v in pairs(icdata) do
        if v.uid == self.mUserUid then
            self.mUserSeat = v.seat
            break
        end
    end
    if self.mUserSeat == nil then
        print("initGameplayerIcon=====error=====")
        return
    end

    local pid = nil
    local playrTb = nil
    playrTb = pkModel.mPlayerSeat[self.mUserSeat]

    for i = 1,4 do
        pid = playrTb[i] 
        local da = pkModel:GetPlayerIconData(pid)
        local menutips = xzmj.layer.Poker_icon.new(da)
        self.mGpIconNode[pid] = menutips
        self.mIconArr[i]:addChild( menutips )
    end
end



function PokerDeskLayer:UpdateDateIcon( _data )
    local da = _data.data
    if da.id and da.stype then
        self.mGpIconNode[da.id]:UpdateDateIcon( da.stype )
    else
        print("=====error====PokerDeskLayer:UpdateDateIcon===")
    end
end
function PokerDeskLayer:UpdateDateZhuangTx( _id )
    if _id == nil or _id <=0 then
        print("error=====UpdateDateZhuangTx====")
        return
    end

    self.mGpIconNode[_id]:ShowZhuangText( )


end

function PokerDeskLayer:initPokerDeskNode( ... )
    
    local DeskNode = xzmj.layer.PokerDeskNode
    self.DeskNode = DeskNode.new() 
    self.DeskNode:setPosition(640,360)
    self.DeskNode:setAnchorPoint(0.5,0.5)
    self:addChild( self.DeskNode )
end

--[[ 执行麻将换牌动画入口 ]]
function PokerDeskLayer:ChangeMJInfo( data )
    self.node = xzmj.layer.MahjongChangeCardAct.new(data)
    self:addChild( self.node )
end

function PokerDeskLayer:GetCsbName(  )
    return "PokerDeskLayer"
end

function PokerDeskLayer:backFront(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		print("fanhuishangceng")
		self:dismissAll()
		self:dismiss()
	end
end

function PokerDeskLayer:showmenu(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		print("xianshi menu")
         
         xzmj.MainCommand:InTypeJumpView(6)
	end
end
--[[ 聊天按钮 ]]
function PokerDeskLayer:showinfo(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		print("聊天按钮")
        
        local data = {
            [1] = {  ["seat"] = 1, uid = 10001, dingquetype = 2 },
            [2] = {  ["seat"] = 2, uid = 10002, dingquetype = 2 },
            [3] = {  ["seat"] = 3, uid = 10003, dingquetype = 2 },
            [4] = {  ["seat"] = 4, uid = 10004, dingquetype = 2 },
        }



        -- xzmj.Model.PokerDeskModel:ChangeMJInfo( data )
        -- xzmj.Model.PokerDeskModel:DingQueInfo(data)
--
        xzmj.Model.PokerDeskModel.mPlayPoptyTb[3]:ChuPai(1)

        xzmj.MainCommand:InTypeJumpView(7)
	end
end

--[[ 语音按钮 ]]
function PokerDeskLayer:Button_voicef(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("语音按钮")
    end
end

function PokerDeskLayer:onExit(  )
    -- ObjectEventDispatch:rmoveEvent(xzmj.evt[4])
end
return PokerDeskLayer

