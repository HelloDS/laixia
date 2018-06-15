


local pkcf = xzmj.layer.PokerDeskConfig
local pkModel = xzmj.Model.PokerDeskModel
local PokerDeskRightpl =  class("PokerDeskRightpl", xzmj.layer.PokerDeskBasepl)

function PokerDeskRightpl:initSP( _Data )
    self.mMySPValTb = _Data
    
    local pox  = self.mLayer.PLYouPNode1:getPositionX()
    local poy  = self.mLayer.PLYouPNode1:getPositionY()

    for i = 1,14 do
        local Y = poy - ((i-1)*pkcf.ZSPJIANJU)
        table.insert(self.mMySPTbPos,Y)        
    end


    for i=1,#_Data do
        local menutips = xzmj.layer.MahjongNodeZP.new(delete)
        menutips:loadPStyde(1)
        menutips:setScale(0.6)
        menutips:setPosition(pox,self.mMySPTbPos[i])
        table.insert(self.mMySPTb,  menutips)
        self.mLayer.PLYouPNode:addChild(menutips,i)
    end

    local pox  = self.mLayer.PLYouPNode1_zpwz:getPositionX()
    local poy  = self.mLayer.PLYouPNode1_zpwz:getPositionY()
    local menutips = xzmj.layer.MahjongNodeZP.new(delete)
    menutips:loadPStyde(1)
    menutips:setScale(0.6)
    menutips:UpdateDate(1)
    menutips:setPosition(pox,poy)
    self.mLayer.PLYouPNode:addChild(menutips,0)
    self.mZhuaPaiNode = menutips
    menutips:setVisible( false )
end

function PokerDeskRightpl:ShowSP(  )
    PokerDeskRightpl.super.ShowSP( self )

    local pox  = -45
    local poy  = 100 

    local len = #self.mMySPValTb
    for i=1,len do
        local menutips = xzmj.layer.MahjongNodeZYCP.new()
        menutips:setScale(0.55)
        local Y = poy - (i-1)*33
        menutips:UpdateDate(self.mMySPValTb[i])
        menutips:setStyde(2)
        menutips:setPosition(pox,Y)
        self.mLayer.PLYouPNode:addChild(menutips)
    end
end



--[[
    出牌
]]--
function PokerDeskRightpl:ChuPai( _Num )

    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    self.mLayer:UpdateAcStyle( pkcf.POSTB.YOU )
    PokerDeskRightpl.super.ChuPai(self,_Num)

    pkModel:initCPAction(self.mLayer.PLYouPNode1_zpwz,self.mLayer.PLYouPNode,"MahjongNodeSP",0.45,2,{num = _Num})

    local arr = {}
    table.insert(arr, cc.DelayTime:create(2))
    table.insert(arr,cc.CallFunc:create(function()
        self:PushChuPaiNode(_Num)
    end))
    self.mLayer.PLYouPNode:runAction(cc.Sequence:create(arr))
end


--[[
    胡
]]--
function PokerDeskRightpl:HuPai( _Num )
   
end
--[[
    抓
]]--
function PokerDeskRightpl:ZhuaPai( _Num )
    if self.mZhuaPaiNode:isVisible() == true then
        return
    end
    self.mLayer:UpdateAcStyle( pkcf.POSTB.YOU )

    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    PokerDeskRightpl.super.ZhuaPai(self,_Num)
end


--[[
    杠牌
    1 明杠
    2 暗杠
]]--
function PokerDeskRightpl:GangPai( _Num, _gang )
    
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    self.mLayer:UpdateAcStyle( pkcf.POSTB.YOU )
    self.mLayer.mDeskTopNode:ShowGangAct( pkcf.POSTB.YOU )
    
    PokerDeskRightpl.super.GangPai(self, _Num, _gang )


    self:PushPengPaiNode( _Num, _gang )
end

function PokerDeskRightpl:GetSPnode(  )
    local menutips = xzmj.layer.MahjongNodeZP.new()
    menutips:loadPStyde(1)
    menutips:setScale(0.6)
    self.mLayer.PLYouPNode:addChild(menutips)
    return menutips
end
--[[
    刷新自己的手牌
]]--
function PokerDeskRightpl:UpdateSPData(  )

    local pox  = self.mLayer.PLYouPNode1:getPositionX()
    local len = #self.mMySPValTb
    for i=1,len do
        if self.mMySPTb[i] == nil then
            self.mMySPTb[i] = self:GetSPnode()
        end
        self.mMySPTb[i]:setLocalZOrder(i)
        self.mMySPTb[i]:setPosition(  pox, self.mMySPTbPos[i])
    end  
end

--[[
    碰
]]--
function PokerDeskRightpl:PengPai( _Num )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )

    self.mLayer:UpdateAcStyle( pkcf.POSTB.YOU )
    self.mLayer.mDeskTopNode:ShowPengAct( pkcf.POSTB.YOU )
    PokerDeskRightpl.super.PengPai(self,_Num )
    self:PushPengPaiNode( _Num, _gang )

end
--[[
    右家也就是对家 放在右家的出牌节点
]]--

function PokerDeskRightpl:PushChuPaiNode( _Num )
    
    local pox  = self.mLayer.YouPaiNode1:getPositionX()
    local poy  = self.mLayer.YouPaiNode1:getPositionY()
    local PentNode = nil
    local MychuPiaNum = #self.mMyCPTb
    if MychuPiaNum >= pkcf.CPMAX*2 then
        pox = self.mLayer.YouPaiNode3:getPositionX()
        poy = self.mLayer.YouPaiNode3:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX*2
    elseif MychuPiaNum >= pkcf.CPMAX then
        pox = self.mLayer.YouPaiNode2:getPositionX()
        poy = self.mLayer.YouPaiNode2:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX
    end

    local menutips = xzmj.layer.MahjongNodeZYCP.new()
    menutips:setScale(pkcf.SCALE)
    self.mZoder = self.mZoder - 1 
    menutips:setLocalZOrder(self.mZoder)
    menutips:UpdateDate(_Num)
    menutips:setStyde(2)
    menutips:setPosition(pox,poy+ ((MychuPiaNum)*pkcf.CPJIANJU_ZUOYOU))
    table.insert(self.mMyCPTb,  menutips)
    self.mLayer.YouPaiNode:addChild(menutips)

end
--[[
    创建碰牌的节点
]]--
function PokerDeskRightpl:PushPengPaiNode( num, gang )

    if gang then
        if 1 == PokerDeskLeftpl.super.PushPengPaiNode(self,_Num,gang ) then
            return
        end
    end

    local node  = xzmj.layer.MahjongNodeZYDP.new()
    self.mLayer.YouDPNode.mCounter = self.mLayer.YouDPNode.mCounter + 1
    node:UpdateDate(num,gang) 
    node:setStyde(2)
    node:setPosition(54,10 + pkcf.YOUDPJIANJU * ( self.mLayer.YouDPNode.mCounter - 1) - 15)
    self.mLayer.YouDPNode:addChild( node )
    table.insert( self.mMyDPTb,node )

end



function PokerDeskRightpl:XuanPaiZhong()
    self.mLayer.mDeskTopNode:ShowXpzAct( pkcf.POSTB.YOU )
    PokerDeskRightpl.super.XuanPaiZhong(self)
    
end
function PokerDeskRightpl:DingQueZhong()
    self.mLayer.mDeskTopNode:ShowDqzAct( pkcf.POSTB.YOU )
    PokerDeskRightpl.super.DingQueZhong( self )
    
end

return PokerDeskRightpl