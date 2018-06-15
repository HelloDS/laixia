

--[[
  ]]--


local PokerDeskModel =  class("PokerDeskModel")
local pkcf = xzmj.layer.PokerDeskConfig


--[[
    服务器初始化数据在这里赋值
    牌桌里面得数据
]]--
function PokerDeskModel:InitData( data )
    self.mPlayPoptyTb = {}       -- 玩家属性的数据
    self.mPlChupaiVal = nil      -- 保存出牌的最后一张牌
 
    self.mMjsdpath = nil
    self.mMjsdTypath = nil
    self.m_self_x = 640
    self.m_self_y = 200

    self.m_you_x  = 950
    self.m_you_y  = 360

    self.m_zuo_x  = 390
    self.m_zuo_y  = 357

    self.m_shang_x = 640
    self.m_shang_y = 500

    -- 玩家的方位
    self.mPlayerSeat = {
                        {4,1,2,3},
                        {1,2,3,4},
                        {2,3,4,1},
                        {3,4,1,2},  
                        }
    self.mSYGbValTb  = {}
    self.mIsJianChe = true
    self.mRunActMjNode =  nil     --正在做出牌动作的那张麻将
    self.Pldata = {}
    self.mPokertype = nil
    self.mZhuangval = nil
    self.mZhuangid = nil
    self.mTable_id = nil
    self.mRoom_id = nil
    self.mSurplusSum = 0
    self:GetSeverIconData()
    self.mUid = xzmj.Model.GameLayerModel:GetInfo():GetUid()
end

--[[
    根据玩家性别获取音效获取路径
]]-- 
function PokerDeskModel:GetPlayerMjSoundPath( ... )
    
    local sex = xzmj.Model.GameLayerModel:GetInfo():GetSex()
    if sex == 1 then
        self.mMjsdpath = pkcf.MJSOUNDFTPATH[1]
        self.mMjsdTypath = pkcf.MJTYPESOUNDPATH[1]
    else 
        self.mMjsdpath = pkcf.MJSOUNDFTPATH[2]
        self.mMjsdTypath = pkcf.MJTYPESOUNDPATH[2]
    end
end

function PokerDeskModel:GetSeverData(  )
        local URL = string.format("http://127.0.0.1:9401")
        local tb = {
            ["b"] = {["ev"] = "create_poker" },
            ["liveid"] = "1501748382962273",
            ["gid"] = "gid",
            ["mc"] = {{["gid"] = "gid",["gid"] = "gid"}},
            ["userid"] = 16678751,
            ["server_ip"] =  "10.111.7.213",
        }
        local tb1 = xzmj.json.encode(tb)
        xzmj.net.http.SetCode( xzmj.net.http.new( URL,tb1 )):sendPost(function ( d1,d2 )
            if d1 == 200 then
               print("ssssss====")
            end            
        end)
end

---===================================服务器处理数据逻辑区域======================
--[[
    打开游戏场
]]--
function PokerDeskModel:OpenMJLayer( data )
    xzmj.MainCommand:InTypeJumpView(12)
    self:SetPlayerMJPval( data )
end


--[[
    收到牌桌换三张数据操作
]]--
function PokerDeskModel:ChangeMJInfo( data )
    self.mLayer:ChangeMJInfo( data )

    self.mPokerdata = data.pokerinfo

    self:InitPlData()
end

--[[
    收到玩家三个定缺类型
]]--
function PokerDeskModel:DingQueInfo( data )
    for k,v in pairs(data) do
        --if v.uid ~= self.mUid then
            local pl = self:getPlayerInID( v.uid )
            if pl then
                pl:DingQue( v.dingquetype )
            end
        --end
    end
end

--[[
    托管信息
]]--
function PokerDeskModel:TuoGuanInfo( data )
    for k,v in pairs(data) do
        local pl = self:getPlayerInID( v.uid )
        if pl then
            pl:setTuoGuan( v.dingquetype )
        end
    end
end

--[[
    游戏结束
]]--
function PokerDeskModel:GameEnd( data )
    xzmj.MainCommand:InTypeJumpView(13)
end


-- 从服务器数据获取玩家的icon数据
function PokerDeskModel:GetPlayerIconData( id )
    if self.mIcondata then
        for k,v in pairs(self.mIcondata) do
            if v.seat == id then
                return v
            end
        end
    end
    return nil
end


function PokerDeskModel:SetPlayerSP( id )
    
    if id <= 0 or id >= 5 then
        print("传入位置ID 错误")
        return
    end

    local playrTb = nil
    local pid = nil
    playrTb = self.mPlayerSeat[id]
    -- 根据牌桌位置直接赋值
    for i = 1 ,4 do
        pid = playrTb[ i]
        local data = self:GetPlayerDataInSever(  pid )
        local player = self.mPlayPoptyTb[i]
        if player then
            if player.mMySPValTb and #player.mMySPValTb > 0 then
                player.mMySPValTb = data.pokerinfo
                player:UpdateSPData()
            else
                player:initSP(data.pokerinfo)
            end
            player.mUserInfo:SetUid( data.uid )
        else
            print("获取玩家牌数据出现致命error=======")
        end
    end
end

--[[
    设置玩家的麻将牌
]]--
function PokerDeskModel:SetPlayerMJPval( _Data )
    if _Data == nil then
        return
    end 
    local data = _Data
    self.mZhuangid  = data.zhuangid
    self.mPokertype = data.pokertype
    self.mZhuangval = data.zhuangval
    self.mPokerdata = data.pokerinfo
    self.mTable_id  = data.table_id
    self.mRoom_id   = data.room_id
    self.mSurplusSum= data.surplusSum
end

--获取玩家icon的数据
function PokerDeskModel:GetSeverIconData(  )
    self.mIcondata = {
                [1] = {  uid = 10001, icon = 7, jinbi = 8899, seat = 1},
                [2] = {  uid = 10002, icon = 6, jinbi = 9988, seat = 2},
                [3] = {  uid = 10003, icon = 5, jinbi = 6677, seat = 3},
                [4] = {  uid = 10004, icon = 4, jinbi = 7766, seat = 4},
        }

    self:GetPlayerMjSoundPath()
end

-- 从服务器数据获取玩家的手牌
function PokerDeskModel:GetPlayerDataInSever( id )
    if self.mPokerdata then
        for k,v in pairs(self.mPokerdata) do
            if v.seat == id then
                return v
            end
        end
    end
    return nil
end

-- 赋值手牌给玩家
function PokerDeskModel:InitPlData(  )
    local uid = xzmj.Model.GameLayerModel:GetUid()
    for k,v in pairs(self.mPokerdata) do
        if v and v.uid == uid then
            self:SetPlayerSP( v.seat )
        end
    end
end

--[[  吃胡听杠操作
    根据服务器数据 和 类型来 推动前端操作
    playerID 玩家id
    _val 操作牌值
    _type 操作类型
]]--
function PokerDeskModel:OperationInType( data )
    if data == nil then
        return
    end
    local playerID = tonumber(data.uid)
    local _val = data.card[1]
    local _type = data.operation

    if playerID == nil or playerID == 0 then
        return
    end
    if _val == nil or _val == 0 then
        return
    end
    if _type == nil or _type == 0 then
        return
    end
    local Type = _type
    local player = self:getPlayerInID(playerID)
    if playerID == nil then
        print("OperationInType=====playerID==error")
        return
    end 

    local mjtype = pkcf.MJOPERATE

    if Type == mjtype.mopai then
        player:ZhuaPai( _val )
    elseif Type == mjtype.chupai then
        player:ChuPai( _val )

    elseif Type == mjtype.hu then
        player:HuPai( _val )

    elseif Type == mjtype.peng then
        player:PengPai( _val )

    elseif Type == mjtype.angang then
        player:GangPai( _val,2 )

    elseif Type == mjtype.guo then
        player:Guo( _val,2 )

    elseif Type == mjtype.minggang then
        player:GangPai( _val,1 )

    elseif Type == mjtype.dingque then
        player:DingQueZhong( _val )

    elseif Type == mjtype.huansaizhang then
        player:XuanPaiZhong( _val,2 )

    end
end
function PokerDeskModel:OperationMoPaiInType( data )
    if data == nil then
        return
    end
    print("收到牌得炒作========================")
    local playerID = tonumber(data.uid)
    local _val = data.card

    if playerID == nil or playerID == 0 then
        return
    end
    if _val == nil or _val == 0 then
        return
    end
    local Type = _type
    local player = self:getPlayerInID(playerID)

    if playerID == nil then
        print("OperationInType=====playerID==error")
        return
    end 
    player:ZhuaPai( _val )
end

function PokerDeskModel:ShowOperation( data )
    if data == nil then
        return
    end
    print("收到碰杠胡检测标记")
    local playerID = tonumber(data.uid)
    if playerID ~= self.mUid then
        return
    end
    local player = self:getPlayerInID(playerID)
    local optb = data.operation
    if player then
        player.mLayer:ShowPGHGui( optb )
        player.mOpcard = data.card
    end

end



---===================================玩家操作逻辑区域======================
--[[
  被点击的时候把别的牌放回去
]]--
function PokerDeskModel:UpdateMySPTbpos( ... )
    self.mPlayPoptyTb[2]:UpdateMySPTbpos(  )
end

--[[
    玩家自己出牌
]]--
function PokerDeskModel:ChuPai( _node )
     self.mPlayPoptyTb[2]:ChuPai( _node )
end

--[[
    设置玩家的游戏状态
    SetSelfGameState 简写成 SetMySt
]]--
function PokerDeskModel:SetMySt( _state )
    if _state then
        self.mPlayPoptyTb[2]:SetGameState( _state )
    end
end

function PokerDeskModel:GetMySt(  ) 
    return self.mPlayPoptyTb[2]:GetGameState(  )
end



--[[
    每个玩家出牌都会在这个函数一次
]]--
function PokerDeskModel:SetPlChuPaiVal( _Num )
     if _Num then
        self.mPlChupaiVal = _Num
        if self.mMjsdpath then
            audio.playSound(self.mMjsdpath.._Num..".mp3")
        end
     end
end


--初始化四家的出牌前半段的动画
--[[
    1.搭建的位置节点
    2.父节点
    4.创建的节点类的名称 (节点类要放在前面的路径下)
    5.缩放比例
    6.播放动画的类型
    7.牌值
    上
    1.self.PLShang_zpwz 
    2.self.PLShangPNode
    3.pkModel.mPLSCPTb
    4.MahjongNodeSP
    5.0.45
    6.3
]]
function PokerDeskModel:initCPAction(posnode,parentnode,lujing,sca,type,data)
    local pox  = posnode:getPositionX()
    local poy  = posnode:getPositionY()
    local ps = parentnode:convertToWorldSpace(cc.p(pox,poy))


    if self.mRunActMjNode == nil then
        local menutips = xzmj.layer.MahjongNodeSP.new()
        self.mRunActMjNode = menutips
        self.mLayer:addChild(self.mRunActMjNode)
    end
    self.mRunActMjNode:setPosition(ps.x,ps.y)
    self.mRunActMjNode:SetTouchEnabled(false)
    self.mRunActMjNode:setScale(sca)
    if data and data.num then
        self.mRunActMjNode:UpdateDate(data.num)
    end
    if data.pox and data.poy then
        local po = parentnode:convertToWorldSpace(cc.p(data.pox,data.poy))
        self.mRunActMjNode:setPosition(po.x,po.y)
    end

    self:ChuPaiActionC(self.mRunActMjNode,type)
    return self.mRunActMjNode
end



--出牌动画
function PokerDeskModel:ChuPaiActionC(node ,stype)
    if node == nil then
        print("error---- chupaiactionC node == nil")
        return
    end
    local pox = node:getPositionX()
    local poy = node:getPositionY()
    local time = 0.3
    local act = nil
    local scase = 0.95
    --从手牌到停留位置
    --[[
        0 玩家 1 左家 2 右家 3 上家
        移动到的位置是相对于父节点的 因为创建完对象添加到了父节点上 而不是父节点相对于父节点的位置
      ]]
    if stype == 0 then
        act = cc.MoveTo:create(time,cc.p(self.m_self_x,self.m_self_y))
    elseif stype == 1 then
        act = cc.MoveTo:create(time,cc.p(self.m_zuo_x,self.m_zuo_y))
    elseif stype == 2 then
        act = cc.MoveTo:create(time,cc.p(self.m_you_x,self.m_you_y))
    elseif stype == 3 then
        act = cc.MoveTo:create(time,cc.p(self.m_shang_x,self.m_shang_y))
    end
    local act1 = cc.ScaleTo:create(time,scase)
    local span = cc.Spawn:create(act,act1)
    node:runAction(span)
end



--[[
    根据方位寻找角色实例
]]--
function PokerDeskModel:getPlayerInSeat( _Seat )
    if _Seat <= 0 or _Seat >=5 then
        return
    end
    if self.mPlayPoptyTb == nil or #self.mPlayPoptyTb <= 0 then
        return
    end
    for k,v in pairs(self.mPlayPoptyTb) do
        if v:GetSeat() == _Seat then
            return v
        end
    end
    return nil
end

--[[
    根据角色id寻找角色实例
]]--
function PokerDeskModel:getPlayerInID( playerID )
    if playerID <= 0 then
        return
    end
    if self.mPlayPoptyTb == nil or #self.mPlayPoptyTb <= 0 then
        return
    end
    for k,v in pairs(self.mPlayPoptyTb) do
        if v and v.mUserInfo:GetUid() == playerID then
            return v
        end
    end
    return nil
end



---===================================牌桌公用函数区域======================

--[[
    传入一个数值返回筒条万
]]--
function PokerDeskModel:GetSPaiNum( _Num )

    local data = {}
    data.Num = _Num
    data.mjNum = nil
    data.mjSty = nil

    if _Num >= pkcf.TONGMIN and _Num <= pkcf.TONGMAX then
        data.mjNum = _Num
        data.mjSty = pkcf.MJSTYLE.TONG
    elseif _Num >= pkcf.TIAOMIN and _Num <= pkcf.TIAOMAX then
        data.mjNum = _Num - pkcf.TIAOMIN
        data.mjSty = pkcf.MJSTYLE.TIAO
    elseif _Num >= pkcf.WANMIN and _Num <= pkcf.WANMAX then
        data.mjNum = _Num - pkcf.WANMIN
        data.mjSty = pkcf.MJSTYLE.WAN
    end
    return data
end

function PokerDeskModel:onEnter( _Layer )
    if _Layer then
        self.mLayer = _Layer
    end
end

function PokerDeskModel:onExit( ... )
    self:InitData()
end

--[[
    筒条万大小排序
    -- 1-9 筒子
    -- 10-18 条
    -- 19-27 万
    默认是筒条万
    2 筒万条
    3 万筒条
    4 万条筒
    5 条万筒
    6 条筒万
]]--
function PokerDeskModel:Sortdata( _Tb, _type )

    if _Tb == nil and #_Tb <= 0 then 
        print(" =======error-----PokerDeskModel:Sortdata()===")
        return 
    end
    local tong = {}
    local tiao = {}
    local wan = {}
    for k,v in pairs(_Tb) do
        if v >=1 and v <= 9 then
            table.insert( tong,v )
        elseif v >=10 and v <= 18 then
            table.insert( tiao,v )
        elseif v >=19 and v <= 27 then
            table.insert( wan,v )
        end
    end
    table.sort(tong, function(a, b)
        return a < b
    end)
    table.sort(tiao, function(a, b)
        return a < b
    end)
        table.sort(wan, function(a, b)
        return a < b
    end)
    return tong,tiao,wan
end

--[[
    检测麻将碰杠
]]--
function PokerDeskModel:InspectMj( _Num, _Table )
    if _Num == nil or _Table == nil then
        return
    end
    local sum = 0
    for k ,v in ipairs( _Table ) do
        if v and v == _Num then
            sum = sum  + 1
        end
    end
    local ty = {}
    if sum == 0 then -- 没有
        table.insert(ty, pkcf.MJONGTY.NOT )
    end
    if sum == 2 then -- 碰
        table.insert( ty,pkcf.MJONGTY.PENG )
    end

    if sum == 3 then -- 明杠
        table.insert( ty,pkcf.MJONGTY.MINGGANG )
    end
    
    if sum == 4 then  -- 暗杠
        table.insert( ty,pkcf.MJONGTY.ANGANG )
    end
    return ty
end

PokerDeskModel:InitData()
return PokerDeskModel
