


--[[
    玩家的属性基类
]]--
-- local PokerDeskBasePl =  class("PokerDeskBasePl", function ( ... )
--     return cc.Node:create()  
-- end)


local PokerDeskBasePl = class("PokerDeskBasePl",xzmj.ui.BaseView)

local pkcf = xzmj.layer.PokerDeskConfig
local pkModel = xzmj.Model.PokerDeskModel

 function PokerDeskBasePl:ctor( layer ) 
    if layer == nil then
        return;
    end
    PokerDeskBasePl.super.ctor(self)
    self.mMySPTb = {}                -- 我的手牌
    self.mMySPValTb = {}             -- 我的手牌副本
    self.mMyCPTb = {}                -- 我的出牌的对象
    self.mMyDPTb = {}                -- 我的出牌的对象
    self.mMoPaiNodePox = {}          --玩家摸得牌得节点
    self.mUserInfo = xzmj.Model.UserInfoModel.new()
    self.mLayer = layer
    self.mMySPTbPos = {}
    self.mZhuaPaiNode = nil          -- 保存我抓的牌
    self.mZoder = 30
    self.mIsXuanPai = true
    self.mDQType = 0                 --你的定缺类型
    self.mIsZhuang = false           -- 是不是庄家
    self.mIsTuoGuan = false
    self.mReady =  false             --是否已经准备

end

function PokerDeskBasePl:UpdateInfoDate( data )
    self.mUserInfo:update( data )
end

function PokerDeskBasePl:setTuoGuan( _is )
    if _is == nil then
        print( "setTuoGuan=======error===="  )
        return
    end
    self.mIsTuoGuan = _is
end

function PokerDeskBasePl:getTuoGuan(  )
    return self.mIsTuoGuan
end

function PokerDeskBasePl:onExit( layer )
    self.mMySPTb = nil
    self.mMySPValTb = nil
    self.mMyCPTb = nil
    self.mMyDPTb = nil
    self.mMoPaiNodePox = nil
    self.mUserInfoModel = nil
    self.mLayer = nil
    self.mMySPTbPos = nil
    self.mZhuaPaiNode = nil 
    self.mZoder = nil
    self.mUserInfo = nil
end





function PokerDeskBasePl:GetSeat(  )
    if self.mUserInfo then
        return self.mUserInfo:GetSeat()
    end
    return nil
end

function PokerDeskBasePl:ShowSP(  )
    for k,v in pairs(self.mMySPTb) do
        if v then 
            v:removeFromParent()
            v = nil
        end
    end
end

--[[
    胡
]]--
function PokerDeskBasePl:HuPai( _Num )
   
 
    local delete = {1}
    self.mLayer.mDeskTopNode:ShowHuAct( delete )
end


--[[
    过
]]--
function PokerDeskBasePl:Guo( _Num )
   print("=====Guo==========")
   self.mLayer:HidePGHGui(  )

end



--[[
    抓
]]--
function PokerDeskBasePl:ZhuaPai( _Num )
    if _Num == nil or _Num <= 0 then
        return
    end
    pkModel.mIsJianChe = false
    table.insert(self.mMySPValTb,_Num)
    self.mZhuaPaiNode:setVisible(true)
    self.mZhuaPaiNode:UpdateDate(_Num)
end

--出牌
function PokerDeskBasePl:ChuPai( _Num )
    if _Num == nil or _Num <= 0 then
        return
    end    
    pkModel:SetPlChuPaiVal( _Num )
    pkModel.mIsJianChe = true
    self.mZhuaPaiNode:setVisible(false)
    local val = _Num
    for k,v in pairs(self.mMySPValTb) do
        if v and v == val then
            table.remove( self.mMySPValTb,k )
            break
        end
    end

    for k,v in pairs(self.mMySPTb) do
        if k then
            v:removeFromParent()
            table.remove( self.mMySPTb,k )
            break
        end
    end
    self:UpdateSPData()
end

function PokerDeskBasePl:PushPengPaiNode( num, gang )

    if gang then
        for k,v in pairs(self.mMyDPTb) do
            if v:GetVal() == num then
                v:UpdateDate( num, gang )
                table.remove( self.mMyDPTb,k )
                return 1
            end
        end
    end
    return 0
end

--[[
    杠牌
    1 明杠
    2 暗杠
]]--
function PokerDeskBasePl:GangPai( _Num, _gang )
    local sum = 0
    local count = 3
    self:PlaySound( pkModel.mMjsdTypath.."gang")

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
end

--[[
    碰
]]--
function PokerDeskBasePl:PengPai( _Num )
    self:PlaySound( pkModel.mMjsdTypath.."peng")
    
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
end

--[[
    
]]--
function PokerDeskBasePl:XuanPaiZhong( num, gang )

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




    local arr = {}
    table.insert(arr, cc.DelayTime:create(2))
    table.insert(arr,cc.CallFunc:create(function()

        for j = 1,3 do
            for i = #self.mMySPValTb ,1,-1 do
                table.remove( self.mMySPValTb,i )
                break
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

        self.mLayer.mDeskTopNode:RemoveXpzAct( self.mUserInfo.mSeat )
        self.mLayer.mDeskTopNode.node:UpdatePoker( self.mUserInfo.mSeat )
    end))
    self:runAction(cc.Sequence:create(arr))

end


function PokerDeskBasePl:UpdateDateIcon( _id, _stye )
    local d = { id = _id, stype = _stye}
    ObjectEventDispatch:dispatchEvent( { name = xzmj.evt[4], data = d })
end


function PokerDeskBasePl:SetHuanPanTb( _tb )
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

function PokerDeskBasePl:DingQue( sum )
    if sum == nil then
        return
    end

    self:UpdateDateIcon( self.mUserInfo.mSeat, sum)
    --self.mLayer.mDeskTopNode:RemoveDqzAct( self.mUserInfo.mSeat ) 

end

--[[
    
]]--
function PokerDeskBasePl:DingQueZhong(  )
    

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
    self.mDQType = sum

   
    local arr = {}
    table.insert(arr, cc.DelayTime:create(2))
    table.insert(arr,cc.CallFunc:create(function()
        self:UpdateDateIcon( self.mUserInfo.mSeat, sum)
        self.mLayer.mDeskTopNode:RemoveDqzAct( self.mUserInfo.mSeat )
    end))
    self:runAction(cc.Sequence:create(arr))



end

return PokerDeskBasePl