



local pkcf = xzmj.layer.PokerDeskConfig
local pkModel = xzmj.Model.PokerDeskModel
local PokerDeskLeftpl =  class("PokerDeskLeftpl", xzmj.layer.PokerDeskBasepl)

--初始化左玩家的手牌
function PokerDeskLeftpl:initSP( _data )
    self.mMySPValTb = _data
    local pox  = self.mLayer.PLZuoPNode1:getPositionX()
    local poy  = self.mLayer.PLZuoPNode1:getPositionY()
    for i=1,#self.mMySPValTb do
        local menutips = xzmj.layer.MahjongNodeZP.new()
        menutips:setScale(0.6)
        local Y = poy+ (i-1)*pkcf.YSPJIANJU + 30
        menutips:setPosition(pox,Y)
        table.insert(self.mMySPTb,  menutips)
        table.insert( self.mMySPTbPos, Y )
        self.mLayer.PLZuoPNode:addChild(menutips,-i)
    end


    local pox  = self.mLayer.PLZuoPNode1_zpwz:getPositionX()
    local poy  = self.mLayer.PLZuoPNode1_zpwz:getPositionY()
    local menutips = xzmj.layer.MahjongNodeZP.new(delete)
    menutips:loadPStyde(3)
    menutips:setScale(0.6)
    menutips:UpdateDate(1)
    menutips:setPosition(pox,poy)
    self.mLayer.PLZuoPNode:addChild(menutips,14)
    self.mZhuaPaiNode = menutips
    menutips:setVisible( false )

end

function PokerDeskLeftpl:ShowSP(  )
    PokerDeskLeftpl.super.ShowSP( self )

    local pox  = -55
    local poy  = 66
 
    local len = #self.mMySPValTb
    for i=1,len do
        local menutips = xzmj.layer.MahjongNodeZYCP.new()
        menutips:setScale(0.55)
        local Y = poy+ (i-1)*37
        menutips:UpdateDate(self.mMySPValTb[i])
        menutips:setStyde(1)
        menutips:setLocalZOrder(-i)
        menutips:setPosition(pox, Y)
        self.mLayer.PLZuoPNode:addChild(menutips,-i)

    end

end


--[[
    胡
]]--
function PokerDeskLeftpl:HuPai( _Num )
   
end

--[[
    抓
]]--
function PokerDeskLeftpl:ZhuaPai( _Num )
    if self.mZhuaPaiNode:isVisible() == true then
        return
    end
    self.mLayer:UpdateAcStyle( pkcf.POSTB.ZUO )
    PokerDeskLeftpl.super.ZhuaPai(self,_Num)
end

--出牌
function PokerDeskLeftpl:ChuPai( _Num )

    PokerDeskLeftpl.super.ChuPai(self,_Num)
    self.mLayer:UpdateAcStyle( pkcf.POSTB.ZUO )
    pkModel:initCPAction(self.mLayer.PLZuoPNode1_zpwz,self.mLayer.PLZuoPNode,"MahjongNodeSP",0.45,1,{num = _Num})

    local arr = {}
    table.insert(arr, cc.DelayTime:create(2))
    table.insert(arr,cc.CallFunc:create(function()
        self:PushChuPaiNode(_Num)
    end))
    self.mLayer.PLZuoPNode:runAction(cc.Sequence:create(arr))
end

--[[
    杠牌
    1 明杠
    2 暗杠
]]--
function PokerDeskLeftpl:GangPai( _Num, _gang )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    self.mLayer:UpdateAcStyle( pkcf.POSTB.ZUO )
    self.mLayer.mDeskTopNode:ShowGangAct( pkcf.POSTB.ZUO )

    PokerDeskLeftpl.super.GangPai(self, _Num, _gang )
    self:PushPengPaiNode( _Num, _gang )
end

function PokerDeskLeftpl:GetSPnode(  )
    local menutips = xzmj.layer.MahjongNodeZP.new()
    menutips:setScale(0.6)
    self.mLayer.PLZuoPNode:addChild(menutips)
    return menutips
end

--[[
    刷新自己的手牌
]]--
function PokerDeskLeftpl:UpdateSPData( _Num  )

    local pox  = self.mLayer.PLZuoPNode1:getPositionX()
    local len = #self.mMySPValTb
    if len >= 14 then
        len = 13
    end
    for i=1,len do
        if self.mMySPTb[i] == nil then
            self.mMySPTb[i] = self:GetSPnode()
        end
        self.mMySPTb[i]:setLocalZOrder(-i)
        self.mMySPTb[i]:setPosition(pox, self.mMySPTbPos[i])
    end
end

--[[
    碰
]]--
function PokerDeskLeftpl:PengPai( _Num )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    self.mLayer:UpdateAcStyle( pkcf.POSTB.ZUO )
    self.mLayer.mDeskTopNode:ShowPengAct( pkcf.POSTB.ZUO )
    
    PokerDeskLeftpl.super.PengPai(self,_Num )

    self:UpdateSPData()
    self:PushPengPaiNode( _Num )
end


--[[
    对牌的节点
]]--
function PokerDeskLeftpl:PushPengPaiNode( _Num, gang )

    if gang then
        if 1 == PokerDeskLeftpl.super.PushPengPaiNode(self,_Num,gang ) then
            return
        end
    end
    local node  = xzmj.layer.MahjongNodeZYDP.new()
    self.mLayer.ZuoDPNode.mCounter = self.mLayer.ZuoDPNode.mCounter + 1
    node:UpdateDate(_Num,gang) 
    node:setStyde(1)
    node:setPosition(-3, -63 - pkcf.YOUDPJIANJU * ( self.mLayer.ZuoDPNode.mCounter - 1) + 20)
    self.mLayer.ZuoDPNode:addChild( node )
    table.insert( self.mMyDPTb,node )

end

--[[
    
]]--
function PokerDeskLeftpl:PushChuPaiNode( _Num )
    
    local pox  = self.mLayer.ZuoPaiNode1:getPositionX()
    local poy  = self.mLayer.ZuoPaiNode1:getPositionY()
    local PentNode = nil
    local MychuPiaNum = #self.mMyCPTb
    if MychuPiaNum >= pkcf.CPMAX*2 then
        pox = self.mLayer.ZuoPaiNode3:getPositionX()
        poy = self.mLayer.ZuoPaiNode3:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX*2
    elseif MychuPiaNum >= pkcf.CPMAX then
        pox = self.mLayer.ZuoPaiNode2:getPositionX()
        poy = self.mLayer.ZuoPaiNode2:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX
    end

    local menutips = xzmj.layer.MahjongNodeZYCP.new()
    menutips:setScale(pkcf.SCALE)
    menutips:UpdateDate(_Num)
    menutips:setStyde(1)
    menutips:setPosition(pox,poy- ((MychuPiaNum)*pkcf.CPJIANJU_ZUOYOU))
    table.insert(self.mMyCPTb,  menutips)
    self.mLayer.ZuoPaiNode:addChild(menutips)

end

function PokerDeskLeftpl:Inspect(  )

    local tabledata = self.mMySPValTb
    local _val = pkModel.mPlChupaiVal
    
    if tabledata then
       local tb =  pkModel:InspectMj( _val, tabledata)
        local len = #tb
        if len <= 0 or tb[1] == -1 then
            return -1
        end
        for k ,v in pairs(tb) do
            if v then
                if v == pkcf.MJONGTY.PENG then
                    self:PengPai( _val )
                elseif v == pkcf.MJONGTY.GANG then
                    self:GangPai( _val,1 )
                    self:ZhuaPai( pkModel:GetSYGbValTb() )
                elseif v >= pkcf.MJONGTY.LONGQIDUI then
                    -- 没有胡牌
                end

                return self.mUserInfo.mSeat
            end
        end      
    end
    return -1
end



function PokerDeskLeftpl:XuanPaiZhong()
    self.mLayer.mDeskTopNode:ShowXpzAct( pkcf.POSTB.ZUO )
    PokerDeskLeftpl.super.XuanPaiZhong(self)
end


function PokerDeskLeftpl:DingQueZhong()
    self.mLayer.mDeskTopNode:ShowDqzAct( pkcf.POSTB.ZUO )
    PokerDeskLeftpl.super.DingQueZhong( self )
end

return PokerDeskLeftpl