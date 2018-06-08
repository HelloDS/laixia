 


local pkcf = xzmj.layer.PokerDeskConfig
local pkModel = xzmj.Model.PokerDeskModel
local PokerDeskToppl =  class("PokerDeskToppl", xzmj.layer.PokerDeskBasepl)

--初始化上玩家的手牌
function PokerDeskToppl:initSP( _data )
    self.mMySPValTb = _data
    local pox  = self.mLayer.PLShangPNode1:getPositionX()
    local poy  = self.mLayer.PLShangPNode1:getPositionY() 
    for i=1,#_data do
        local menutips = xzmj.layer.MahjongNodeZP.new()
        menutips:loadPStyde(2)
        menutips:setScale(pkcf.TIPSPSCALE)
        local X = pox + (i-1)*pkcf.SSPJIANJU 
        menutips:setPosition( X , poy)
        table.insert( self.mMySPTbPos, X )
        table.insert(self.mMySPTb,  menutips)
        self.mLayer.PLShangPNode:addChild(menutips,i)
    end

    local pox  = self.mLayer.PLShang_zpwz:getPositionX()
    local poy  = self.mLayer.PLShang_zpwz:getPositionY()
    local menutips = xzmj.layer.MahjongNodeZP.new(delete)
    menutips:loadPStyde(2)
    menutips:setScale(pkcf.TIPSPSCALE)
    menutips:setPosition(pox,poy)
    self.mLayer.PLShangPNode:addChild(menutips,14)
    self.mZhuaPaiNode = menutips
    menutips:setVisible(false)

end
function PokerDeskToppl:ShowSP(  )
    PokerDeskToppl.super.ShowSP( self )

    local pox  = -300
    local poy  = 110

    local len = #self.mMySPValTb
    for i=1,len do
        local menutips = xzmj.layer.MahjongNodeSXDP.new()
        menutips:setScale(0.55)
        local X = pox + (i-1)*45

        menutips:UpdateDate(self.mMySPValTb[i])
        menutips:setPosition(X,poy)
        menutips:setStyde(1)
        self.mLayer.PLShangPNode:addChild(menutips,i)
    end

end

--[[
    胡
]]--
function PokerDeskToppl:HuPai( _Num )
   
end

--[[
    抓
]]--
function PokerDeskToppl:ZhuaPai( _Num )
    if self.mZhuaPaiNode:isVisible() == true then
        return
    end
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
   
    self.mLayer:UpdateAcStyle( pkcf.POSTB.SHANG )

    PokerDeskToppl.super.ZhuaPai(self,_Num)
end

--出牌
function PokerDeskToppl:ChuPai( _Num )

    local val = _Num
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    self.mLayer:UpdateAcStyle( pkcf.POSTB.SHANG )


    PokerDeskToppl.super.ChuPai(self,_Num)

    pkModel:initCPAction(self.mLayer.PLShang_zpwz,self.mLayer.PLShangPNode,"MahjongNodeSP",0.45,3,{num = _Num})
    

    -- 暂时延迟2秒
    local arr = {}
    table.insert(arr, cc.DelayTime:create(2))
    table.insert(arr,cc.CallFunc:create(function()
        self:PushChuPaiNode(_Num)
    end))
    self.mLayer.PLShangPNode:runAction(cc.Sequence:create(arr))
end




--[[
    杠牌
    1 明杠
    2 暗杠
]]--
function PokerDeskToppl:GangPai( _Num, _gang )

    self.mLayer:UpdateAcStyle( pkcf.POSTB.SHANG )
    self.mLayer.mDeskTopNode:ShowGangAct( pkcf.POSTB.SHANG )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )

    PokerDeskToppl.super.GangPai(self, _Num, _gang )

    self:PushPengPaiNode( _Num, _gang )
end


--[[
    碰
]]--
function PokerDeskToppl:PengPai( _Num )
        
    self.mLayer:UpdateAcStyle( pkcf.POSTB.SHANG )
    self.mLayer.mDeskTopNode:ShowPengAct( pkcf.POSTB.SHANG )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )

    PokerDeskToppl.super.PengPai(self,_Num )
    self:PushPengPaiNode( _Num )
end



--[[
    创建对牌的节点 
]]--
function PokerDeskToppl:PushPengPaiNode( num, gang )

    if gang then
        if 1 == PokerDeskLeftpl.super.PushPengPaiNode(self,_Num,gang ) then
            return
        end
    end

    local node  = xzmj.layer.MahjongNodeMYDP.new()
    self.mLayer.DJDPNode.mCounter = self.mLayer.DJDPNode.mCounter + 1
    node:setScale(0.55)
    node:setStyde( 2 )
    node:UpdateDate(num, gang )
    node:setPosition( pkcf.DJDPJIANJU * ( self.mLayer.DJDPNode.mCounter - 1) + 25 ,0)
    self.mLayer.DJDPNode:addChild( node )
    table.insert( self.mMyDPTb,node )

end


--[[
    出牌节点
]]--
function PokerDeskToppl:PushChuPaiNode( _Num )


    local pox  = self.mLayer.ShangPaiNode1:getPositionX()
    local poy  = self.mLayer.ShangPaiNode1:getPositionY()
    local PentNode = nil
    local MychuPiaNum = #self.mMyCPTb
    if MychuPiaNum >= pkcf.CPMAX*2 then
        pox = self.mLayer.ShangPaiNode3:getPositionX()
        poy = self.mLayer.ShangPaiNode3:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX*2
    elseif MychuPiaNum >= pkcf.CPMAX then
        pox = self.mLayer.ShangPaiNode2:getPositionX()
        poy = self.mLayer.ShangPaiNode2:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX
    end

    local menutips = xzmj.layer.MahjongNodeSXDP.new(delete)
    menutips:setScale(pkcf.SCALE)
    menutips:UpdateDate( _Num )
    menutips:setStyde(1)
    self.mZoder = self.mZoder - 1
    menutips:setLocalZOrder(self.mZoder)
    menutips:setPosition(pox- ((MychuPiaNum)*pkcf.CPJIANJU),poy)
    table.insert(self.mMyCPTb,  menutips)
    self.mLayer.ShangPaiNode:addChild(menutips)

end
function PokerDeskToppl:GetSPnode(  )
    local menutips = xzmj.layer.MahjongNodeZP.new()
    menutips:loadPStyde(2)
    menutips:setScale(pkcf.TIPSPSCALE)
    self.mLayer.PLShangPNode:addChild(menutips)
    return menutips
end
--[[
    刷新自己的手牌
]]--
function PokerDeskToppl:UpdateSPData(   )


    local poy  = self.mLayer.PLShangPNode1:getPositionY()
    local len = #self.mMySPValTb
    if len >= 14 then
        len = 13
    end
    for i=1,len do
        if self.mMySPTb[i] == nil then
            self.mMySPTb[i] = self:GetSPnode()
        end
        self.mMySPTb[i]:setPosition( self.mMySPTbPos[i] ,poy)
        self.mMySPTb[i]:setLocalZOrder(i)
    end
end

function PokerDeskToppl:Inspect(  )

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

function PokerDeskToppl:XuanPaiZhong()
    self.mLayer.mDeskTopNode:ShowXpzAct( pkcf.POSTB.SHANG )
    PokerDeskToppl.super.XuanPaiZhong(self)
end


function PokerDeskToppl:DingQueZhong()
    self.mLayer.mDeskTopNode:ShowDqzAct( pkcf.POSTB.SHANG )
    PokerDeskToppl.super.DingQueZhong( self )
    
end

return PokerDeskToppl