

--[[
    牌桌的第二层界面
]]--


local PokerDeskTopNode = class("PokerDeskTopNode", import("...BaseView"))
local pkcf = xzmj.layer.PokerDeskConfig
local pkModel = xzmj.Model.PokerDeskModel

function PokerDeskTopNode:ctor( data )
    PokerDeskTopNode.super.ctor(self)


    self:InjectView("QueDingBtn")

    --万条同
    self:InjectView("Button_wan")
    self:InjectView("Button_tiao")
    self:InjectView("Button_tong")
    self.WTTNodeTb = {self.Button_tong,self.Button_tiao,self.Button_wan}


    --选牌中节点
    self:InjectView("XPZS")
    self:InjectView("XPZX")
    self:InjectView("XPZZ")
    self:InjectView("XPZY")
    self.mXZPtable = 
                {
                    self.XPZS,
                    self.XPZX,
                    self.XPZZ,
                    self.XPZY
                }

     --碰节点
    self:InjectView("PengS")
    self:InjectView("PengX")
    self:InjectView("PengZ")
    self:InjectView("PengY")
    self.mPengtable = 
                {
                    self.PengS,
                    self.PengX,
                    self.PengZ,
                    self.PengY
                }

     --胡节点
    self:InjectView("HuS")
    self:InjectView("HuX")
    self:InjectView("HuZ")
    self:InjectView("HuY")
    self.mHutable = 
                {
                    self.HuZ,
                    self.HuX,
                    self.HuY,
                    self.HuS,
                    
                }


    self:InjectView("NodeTip")
    self.NodeTip:setVisible(false)

    self:InjectView("QXTGbtn")
    self:InjectView("QxtgTip")
    self.QxtgTip:setVisible(false)

    self:InjectView("WTTNode")


    self:InjectView("XpDjsText")



    self:OnClick(self.Button_wan, function()
        print("Button_wan")
        self:ShowTTWBtn(false)
        pkModel.mPlayPoptyTb[2]:SetDQType( pkcf.MJSTYLE.WAN )
    end,{["isScale"] = false, ["hasAudio"] = false})


    self:OnClick(self.Button_tiao, function()
        print("Button_tiao")
        self:ShowTTWBtn(false)
        pkModel.mPlayPoptyTb[2]:SetDQType( pkcf.MJSTYLE.TIAO )
    end,{["isScale"] = false, ["hasAudio"] = false})
    


    self:OnClick(self.Button_tong, function()
        print("Button_tong")
        self:ShowTTWBtn(false)
        pkModel.mPlayPoptyTb[2]:SetDQType( pkcf.MJSTYLE.TONG )
    end,{["isScale"] = false, ["hasAudio"] = false})


    self:OnClick(self.QueDingBtn, function()
        print("QueDingBtn")
        self.NodeTip.func()
    end,{["isScale"] = false, ["hasAudio"] = false})


    -- 去消托管按钮
    self:OnClick(self.QXTGbtn, function()
        print("Button_wan")
        self.QxtgTip:setVisible(false)
        pkModel.mPlayPoptyTb[2]:setTuoGuan( false )
    end,{["isScale"] = false, ["hasAudio"] = false})
    self:init()

end

function PokerDeskTopNode:GetCsbName()
    return "PokerDeskTopNode"
end

function PokerDeskTopNode:init(  )
    
    ObjectEventDispatch:addEventListener(xzmj.evt[3], handler(self, self.ShowQxtgTips));

end


--[[
    显示选牌中得动画
]]--
function PokerDeskTopNode:ShowXpzAct( _stye )
    if _stye == nil or _stye > 4 then
        print("errror------PokerDeskTopNode:ShowPengAct----")
        return
    end
    self.mXZPtable[_stye].mXpzAct = self:playAnimationAt( self.mXZPtable[_stye],pkcf.XPZACT )
end

function PokerDeskTopNode:RemoveXpzAct( _stye )
    if _stye == nil or _stye > 4 then
        print("errror------PokerDeskTopNode:ShowPengAct----")
        return
    end
    self.mXZPtable[_stye].mXpzAct:removeFromParent()
    self.mXZPtable[_stye].mXpzAct = nil
end





--[[
    显示定缺中得动画
]]--
function PokerDeskTopNode:ShowDqzAct( _stye )
    if _stye == nil or _stye > 4 then
        print("errror------PokerDeskTopNode:ShowDqzAct----")
        return
    end
    self.mXZPtable[_stye].mDqzAct = self:playAnimationAt( self.mXZPtable[_stye],pkcf.DQZACT )
end
function PokerDeskTopNode:RemoveDqzAct( _stye )
    if _stye == nil or _stye > 4 then
        print("errror------PokerDeskTopNode:RemoveDqzAct----")
        return
    end
    self.mXZPtable[_stye].mDqzAct:removeFromParent()
    self.mXZPtable[_stye].mDqzAct = nil
end

--[[
    显示碰动画
    老规矩
    1234 上下左右
]]--
function PokerDeskTopNode:ShowPengAct( _stye )
    if _stye == nil or _stye > 4 then
        print("errror------PokerDeskTopNode:ShowPengAct----")

        return
    end
    self:playAnimationAt( self.mPengtable[_stye],pkcf.PENGACT )
end


--[[ 
    显示杠动画
]]
function PokerDeskTopNode:ShowGangAct( _stye )
    if _stye == nil or _stye > 4 then
        print("errror------PokerDeskTopNode:ShowPengAct----")

        return
    end
    self:playAnimationAt( self.mPengtable[_stye],pkcf.GANGACT )
end

--[[
    显示3家胡动画 按照上下左右得位置传递
    detele = 
    {
        1,
        2,
        3,
        2
    }
]]--
function PokerDeskTopNode:ShowHuAct( detele )
    if detele == nil  then
        print("errror------PokerDeskTopNode:ShowPengAct----")
        return
    end
    for i=1,#self.mHutable do
        if detele[i] == nil then
            self.mHutable[i]:setVisible(false)
        end
        self:playAnimationAt( self.mHutable[i],pkcf.ENDHUPACT[detele[i]] )
    end
end



--[[
    
    visible ture 显示
    visible false 隐藏

]]--
function PokerDeskTopNode:ShowNodeTips( visible, func )

    self.QxtgTip:setVisible( false )
    if self.NodeTip == nil then 
        print("errror------PokerDeskTopNode:ShowNodeTips-----")
        return
    end
    self.NodeTip:setVisible( visible )
    

    local time = 2


    local function EndXpzFun( ... )
            self.XpDjsText:stopAllActions()
            self.node:UpdatePoker(2)
             self.NodeTip:setVisible( false )
            if func then
                func()
            end
    end

    if func then 
        self.NodeTip.func = EndXpzFun
    end
    
    if visible == true then
        local arr = {}
        table.insert(arr, cc.DelayTime:create(1))
        table.insert(arr,cc.CallFunc:create(function()
            if time <= 0 then
                EndXpzFun()
            end
            self.XpDjsText:setString( time )
            time = time - 1
        end))
        self.XpDjsText:runAction(cc.RepeatForever:create(cc.Sequence:create(arr)))
    end



end

--[[
    显示取消托管tip
]]--
function PokerDeskTopNode:ShowQxtgTips( visible )

    --self.NodeTip:setVisible( false )
    if self.QxtgTip == nil then 
        print("errror------PokerDeskTopNode:ShowQxtgTips-----")
        return
    end
    local _vs = visible
    if type(visible) == "table" then
        _vs = visible.data
    end
    self.QxtgTip:setVisible( _vs )

end

--[[
    显示玩家自己的筒条万按钮 定缺
]]--
function PokerDeskTopNode:ShowTTWBtn( visible, _type )

    self.WTTNode:setVisible(visible)
    if visible == true then
        local act1 = cc.ScaleTo:create(0.5,1.2)
        local act2 = cc.ScaleTo:create(0.5,0.9)
        local sequence = cc.Sequence:create(act1,act2)
        self._type = _type
        self.WTTNodeTb[ _type ]:runAction(cc.RepeatForever:create(sequence))
    else
        for k,v in pairs(self.WTTNodeTb) do
            if v then
                v:stopAllActions()
            end
        end
   
        --  if _data.id and _data.type then
        local d = { id = 2, stype = self._type}
        ObjectEventDispatch:dispatchEvent( { name = xzmj.evt[4], data = d })

    end
end

return PokerDeskTopNode

