


local pkcf = xzmj.layer.PokerDeskConfig

local PokerDeskMypl =  class("PokerDeskLeftpl", xzmj.layer.PokerDeskBasepl)
 
local pkModel = xzmj.Model.PokerDeskModel

--[[
]]--
 function PokerDeskMypl:ctor( layer )
    PokerDeskMypl.super.ctor(self,layer)

    self.mGameState = 0
    self.mPengPTb = {}
    self.mOpcard = nil
end

function PokerDeskMypl:onExit(  )
    PokerDeskMypl.super.onExit(self)
    self.mGameState = 0
    self.mPengPTb = {}
end 


--[[

]]--
function PokerDeskMypl:SetGameState( _Style )
    self.mGameState = _Style
end

function PokerDeskMypl:GetGameState(  )
    return self.mGameState  
end

function PokerDeskMypl:SetDQType( _Style )
    self.mDQType = _Style
    self:UpdateSPData()
end

function PokerDeskMypl:GetDQType(  )
    return self.mDQType  
end

--[[
 被点击的时候把别的牌放回去
]]--
function PokerDeskMypl:UpdateMySPTbpos( ... )
    for k,v in pairs(self.mMySPTb) do
        if k then
            self.mMySPTb[k]:setPositionY(self.mMySPpoY)
        end
    end
end


--[[
    初始化我得手牌数据
]]--
function PokerDeskMypl:initSP( _data )

    local testptable = _data
    self.mMySPValTb = testptable

    local sptbt,sptbti,sptbw = pkModel:Sortdata(testptable)

    for k,v in pairs(sptbti) do
        table.insert(sptbt,v)
    end
    for k,v in pairs(sptbw) do
        table.insert(sptbt,v)
    end
    self.mMySPValTb = sptbt
    self:InitSP( self.mMySPValTb )


   self:ShowDingQuePai()
end


--[[
    显示手牌
]]--
function PokerDeskMypl:InitSP( _datatb )

    local pox  = self.mLayer.zheng_Copy:getPositionX()
    local poy  = self.mLayer.zheng_Copy:getPositionY()
    self.mMySPpoY = poy

    print("显示玩家自己的手牌----")

    local datatblen = #_datatb
    
    local index = 14
    for i = 1,14 do
        local _pox = pox- (index-1) * pkcf.SPJIANJU
        table.insert(self.mMySPTbPos,  _pox)
        index = index - 1
    end


    for i = 1,datatblen do
        local menutips = xzmj.layer.MahjongNodeSP.new(delete)
        menutips:UpdateDate( _datatb[i] )
        menutips:setPosition( self.mMySPTbPos[i] ,poy)
        table.insert(self.mMySPTb,  menutips)
        self.mLayer.Node_7:addChild(menutips)
    end

    self:initZhuaPai()
end

function PokerDeskMypl:initZhuaPai( ... )
    local pox  = self.mLayer.zheng_zpwz:getPositionX()
    local poy  = self.mLayer.zheng_zpwz:getPositionY()
    local menutips = xzmj.layer.MahjongNodeSP.new(delete)
    menutips:UpdateDate( 2 )
    menutips:setPosition(pox,poy)
    self.mLayer.Node_7:addChild(menutips)
    self.mZhuaPaiNode = menutips
    self.mZhuaPaiNode.y = poy
    self.mZhuaPaiNode:setVisible(false)
end


function PokerDeskMypl:SetHuanPanTb( _tb )
    if #_tb <3 then
        print("========error===SetHuanPanTb==")
        return
    end
    self.hptb = _tb
    table.insert( self.mMySPValTb,self.hptb[1] )
    table.insert( self.mMySPValTb,self.hptb[2] )
    table.insert( self.mMySPValTb,self.hptb[3] )
    self:UpdateSPData()
end

function PokerDeskMypl:ShowSP(  )

    PokerDeskMypl.super.ShowSP( self )

    local pox  = self.mLayer.zheng_Copy:getPositionX()
    local poy  = self.mLayer.zheng_Copy:getPositionY()
    local datatblen = #self.mMySPValTb
    print("手牌========"..datatblen)
    local index = #self.mMySPTbPos
    for i = datatblen ,1,-1 do
        local menutips = xzmj.layer.MahjongNodeSXDP.new()
        menutips:setScale(0.95)
        menutips:UpdateDate( self.mMySPValTb[i] )
        menutips:setPosition( self.mMySPTbPos[index] ,poy)
        table.insert(self.mMySPTb,  menutips)
        self.mLayer.Node_7:addChild(menutips)
        index = index - 1
    end
end


--[[
    出牌
]]--
function PokerDeskMypl:ChuPai( _node  )
    if _node == nil  or type(_node) == "number" then
        print("------PokerDeskMypl:ChuPai----error--")
        return
    end
    
    self.mLayer:UpdateAcStyle( pkcf.POSTB.XIA )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    pkModel.mIsJianChe = true
    self.mZhuaPaiNode:setVisible(false)

    local val = _node:GetVal() 
    pkModel:SetPlChuPaiVal( val )
    
    for k,v in pairs(self.mMySPValTb) do
        if v == val then
            table.remove( self.mMySPValTb,k )
            break
        end
    end

    if self.mZhuaPaiNode and  _node == self.mZhuaPaiNode then
        self:ChuPaiAct(_node, val )
        return
    end
    for k,v in pairs(self.mMySPTb) do
        if v == _node then
            table.remove( self.mMySPTb,k )
            break
        end
    end

    xzmj.net.PokerHttp:SendOperation( val,pkcf.MJOPERATE.chupai )

    -- 执行出牌动作 ---
    self:ChuPaiAct(_node, val )
    self:UpdateSPData()
end

--[[
    胡牌
]]--
function PokerDeskMypl:HuPai( _Num )
    PokerDeskMypl.super.HuPai( self,_Num )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
   
end

--[[
    抓牌 等于摸牌
]]--
function PokerDeskMypl:ZhuaPai( _Num )
    if _Num == nil or _Num <= 0 then
        return
    end
    if self.mZhuaPaiNode:isVisible() == true then
        return
    end
    self.mLayer:UpdateAcStyle( pkcf.POSTB.XIA )
    pkModel:SetMySt( pkcf.MYSTATE.KECAOZUO )
    pkModel.mIsJianChe = false

    table.insert( self.mMySPValTb, _Num )
    self.mZhuaPaiNode:UpdateDate( _Num )
    self.mZhuaPaiNode:ZhiHui( self.mDQType )
    self.mZhuaPaiNode:setVisible(true)
    self.mZhuaPaiNode:setPositionY( self.mZhuaPaiNode.y )

    -- 托管中
    if self.mIsTuoGuan == true then
        self:ChuPai( self.mZhuaPaiNode )
        return
    end
end


function PokerDeskMypl:ChuPaiAct(node, _Num )
    local _pox  = node:getPositionX()
    local _poy  = node:getPositionY()
    local da = {
                    num = _Num,
                    pox = _pox,
                    poy = _poy,
                    fun = function ( ... )
                        self:PushChuPaiNode( ... )
                    end
                }
    pkModel:initCPAction(self.mLayer.zheng_zpwz,self.mLayer.Node_7,
        "MahjongNodeSP",0.45,0,da)

    if node ~= self.mZhuaPaiNode  then
        node:removeFromParent(true)
        node = nil
    end
    self:PushChuPaiNode( _Num )
end


--[[
    杠牌
    1 明杠
    2 暗杠
]]--
function PokerDeskMypl:GangPai( _Num, _gang )
    self:PlaySound( pkModel.mMjsdTypath.."gang")

    self.mLayer:UpdateAcStyle( pkcf.POSTB.XIA )
    self.mLayer.mDeskTopNode:ShowGangAct( pkcf.POSTB.XIA )
    pkModel:SetMySt( pkcf.MYSTATE.NOT )
    self.mZhuaPaiNode:setVisible(false)

    local sum = 0
    local count = 3
    for i = #self.mMySPValTb ,1,-1 do
        if self.mMySPValTb[i] == _Num then
            table.remove( self.mMySPValTb,i )
            sum = sum + 1
            if sum >= count then
                break
            end
        end    
    end

    for i = 1,count do
        for k,v in pairs(self.mMySPTb) do
            if k then
                table.remove( self.mMySPTb,k )
                v:removeFromParent()
                break
            end
        end        
    end

    self:UpdateSPData()
    self:PushPengPaiNode( _Num, _gang )
end

--[[
    碰
]]--
function PokerDeskMypl:PengPai( _Num )
    self:PlaySound( pkModel.mMjsdTypath.."peng")

    self.mLayer:UpdateAcStyle( pkcf.POSTB.XIA )
    self.mLayer.mDeskTopNode:ShowPengAct( pkcf.POSTB.XIA )
    pkModel:SetMySt( pkcf.MYSTATE.KECAOZUO )
    self.mZhuaPaiNode:setVisible(false)

    local sum = 0
    local count = 2
    for i = #self.mMySPValTb ,1,-1 do
        if self.mMySPValTb[i] == _Num then
            table.remove( self.mMySPValTb,i )
            sum = sum + 1
            if sum >= count then
                break
            end
        end    
    end
    for i = 1,count do
        for k,v in pairs(self.mMySPTb) do
            if k then
                table.remove( self.mMySPTb,k )
                v:removeFromParent()
                break
            end
        end        
    end

    self:UpdateSPData()
    self:PushPengPaiNode( _Num )
end

--[[
    创建玩家自己对牌节点  
]]--
function PokerDeskMypl:PushPengPaiNode( num, gang )

    -- 如果有杠 但是原来有碰的 把碰变成杠
    if gang then
        for k,v in pairs(self.mMyDPTb) do
            if v:GetVal() == num then
                v:UpdateDate( num, gang )
                table.remove( self.mMyDPTb,k )
                return
            end
        end
    end

    local node  = xzmj.layer.MahjongNodeMYDP.new()
    self.mLayer.MyDPNode.mCounter = self.mLayer.MyDPNode.mCounter + 1
    node:setScale(0.90)
    node:UpdateDate(num,gang) 
    node:setPosition(-125 + pkcf.MyDPJIANJU * ( self.mLayer.MyDPNode.mCounter - 1),-125)
    self.mLayer.MyDPNode:addChild( node )
    table.insert( self.mMyDPTb,node )

    -- 用来检测你再次摸到这个牌 就变成杠的提示
    if gang == nil or gang > 3 then
        table.insert( self.mPengPTb,num )
    end

end


--[[
    我出的牌
]]--
function PokerDeskMypl:PushChuPaiNode( _Num )

    local pox  = self.mLayer.MyChuPaiNode1:getPositionX()
    local poy  = self.mLayer.MyChuPaiNode1:getPositionY()
    local PentNode = nil
    local MychuPiaNum = #self.mMyCPTb
    
    if MychuPiaNum >= pkcf.CPMAX*2 then
        pox = self.mLayer.MyChuPaiNode3:getPositionX()
        poy = self.mLayer.MyChuPaiNode3:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX*2
    elseif MychuPiaNum >= pkcf.CPMAX then
        pox = self.mLayer.MyChuPaiNode2:getPositionX()
        poy = self.mLayer.MyChuPaiNode2:getPositionY()
        MychuPiaNum = MychuPiaNum - pkcf.CPMAX
    end
    local menutips = xzmj.layer.MahjongNodeSXDP.new(delete)
    menutips:setScale(pkcf.SCALE)
    menutips:UpdateDate(_Num)
    menutips:setPosition(pox+ ((MychuPiaNum)*pkcf.CPJIANJU),poy)
    table.insert(self.mMyCPTb,  menutips)
    self.mLayer.MyChuPaiNode:addChild(menutips)
end

function PokerDeskMypl:GetSPnode(  )
    local menutips = xzmj.layer.MahjongNodeSP.new(delete)
    self.mLayer.Node_7:addChild(menutips)
    return menutips
end

function PokerDeskMypl:UpdateSPData(  )


    self:PaiLie()

    local pox  = self.mLayer.zheng_Copy:getPositionX()
    local poy  = self.mLayer.zheng_Copy:getPositionY()

    local datatblen = #self.mMySPValTb    
    print("手牌========"..datatblen)
    local index = #self.mMySPTbPos
    for i = datatblen ,1,-1 do
        if self.mMySPTb[i] == nil then
            self.mMySPTb[i] = self:GetSPnode()
        end
        self.mMySPTb[i]:UpdateDate( self.mMySPValTb[i] )
        self.mMySPTb[i]:setPosition( self.mMySPTbPos[index] ,poy)
        self.mMySPTb[i]:ZhiHui( self.mDQType )
        index = index - 1
    end
end




function PokerDeskMypl:XuanPaiZhong()
    pkModel:SetMySt( pkcf.MYSTATE.XPZ )
end


--[[
    显示定缺牌
]]--
function PokerDeskMypl:ShowDingQuePai( ... )

   
   local tong,tiao,wan = pkModel:Sortdata( self.mMySPValTb )
   tong.len = #tong
   tiao.len = #tiao
   wan.len = #wan

   local GlTB = {}
   table.insert( GlTB,tong )
   table.insert( GlTB,tiao )
   table.insert( GlTB,wan )

   if tiao.len >= 3 then
       tiao.r = 1
   end
   
   if tong.len >= 3 then
       tong.r = 1  
   end
   
   if wan.len >= 3 then
      wan.r = 1
   end

   local tb2 = {}
   for k,v in pairs(GlTB) do
       if v and v.r then
         table.insert( tb2,v )
       end
   end

    table.sort(tb2, function(a, b)
        return a.len < b.len
    end)

        
    local hptb = tb2[1]
    self.hptb = hptb

    self.mLayer.mDeskTopNode:ShowNodeTips( true, function ()
        for j = 1,3 do
            for i = #self.mMySPValTb ,1,-1 do
                if self.mMySPValTb[i] == hptb[j] then
                    table.remove( self.mMySPValTb,i )
                    break
                end    
            end            
        end

        local sum = 1
        for i = #self.mMySPTb, 1,-1  do
            self.mMySPTb[i]:removeFromParent()
            table.remove( self.mMySPTb,i )
            sum = sum + 1
            if sum > 3 then
                break
            end
        end
        self:UpdateSPData()

        local tb = {}
        for i = 1,3 do
            tb[i] = self.hptb[i]
        end
        --[[ 换牌结束 发送到服务器 ]]--
         xzmj.net.PokerHttp:SendHsz( tb )
    end )


    for i = 1 ,3 do
        for k,v in pairs(self.mMySPTb) do
            if v and v:GetVal() == hptb[i] and v.mIsXuanPai == false then
                v:ChickXuanPai()
                break
            end
        end
    end
end

function PokerDeskMypl:DingQueZhong()

   pkModel:SetMySt( pkcf.MYSTATE.DQZ )
   
   local tong,tiao,wan = pkModel:Sortdata( self.mMySPValTb )
   tong.len = #tong
   tong.ty = pkcf.MJSTYLE.TONG
   
   tiao.len = #tiao
   tiao.ty = pkcf.MJSTYLE.TIAO

   wan.len = #wan
   wan.ty = pkcf.MJSTYLE.WAN


   local GlTB = {}
   table.insert( GlTB,tong )
   table.insert( GlTB,tiao )
   table.insert( GlTB,wan )

    table.sort(GlTB, function(a, b)
        return a.len < b.len
    end)

    local sum = 1
    for k,v in pairs(GlTB) do
        if v then
            sum = v.ty
            break
        end
    end
    self.mLayer.mDeskTopNode:ShowTTWBtn( true,sum )
end


function PokerDeskMypl:PaiLie()

   local tong,tiao,wan = pkModel:Sortdata( self.mMySPValTb )
   tong.len = #tong
   tong.ty = pkcf.MJSTYLE.TONG
   
   tiao.len = #tiao
   tiao.ty = pkcf.MJSTYLE.TIAO

   wan.len = #wan
   wan.ty = pkcf.MJSTYLE.WAN



   local GlTB = {}
   table.insert( GlTB,tong )
   table.insert( GlTB,tiao )
   table.insert( GlTB,wan )

   local moweitb = nil
   for k,v in pairs(GlTB) do
       if v and v.ty == self.mDQType then
            moweitb = v
            table.remove( GlTB,k )
       end
   end

    table.sort(GlTB, function(a, b)
        return a.len > b.len
    end)    

    table.insert( GlTB,moweitb )
    local tb = {}
    for i,v in pairs(GlTB) do
        if v then
            for i = 1,#v do
                if v[i] then
                    table.insert(tb, v[i] )
                end
            end
        end
    end

    self.mMySPValTb = tb

end


return PokerDeskMypl