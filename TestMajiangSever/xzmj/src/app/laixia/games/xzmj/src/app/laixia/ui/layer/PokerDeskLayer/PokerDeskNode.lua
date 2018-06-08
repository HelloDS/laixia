

--[[
    牌桌的第二层界面
]]--


local PokerDeskNode = class("PokerDeskNode", import("...BaseView"))
local pkcf = xzmj.layer.PokerDeskConfig
local pkModel = xzmj.Model.PokerDeskModel
function PokerDeskNode:ctor( data )
    PokerDeskNode.super.ctor(self)


    --胡杠碰过
    self:InjectView("Image_hu")
    self:InjectView("Image_gang")
    self:InjectView("Image_peng")
    self:InjectView("Image_guo")

    --玩家手牌节点
    self:InjectView("Node_7")

    --玩家出牌节点
    self:InjectView("MyChuPaiNode")
    --第一排添加节点
    self:InjectView("MyChuPaiNode1")
    --第二排添加节点
    self:InjectView("MyChuPaiNode2")
    --第三排添加节点
    self:InjectView("MyChuPaiNode3")

    --右边玩家出牌节点
    self:InjectView("YouPaiNode")
    self:InjectView("YouPaiNode1")
    self:InjectView("YouPaiNode2")
    self:InjectView("YouPaiNode3")

    --上边玩家出牌节点
    self:InjectView("ShangPaiNode")
    self:InjectView("ShangPaiNode1")
    self:InjectView("ShangPaiNode2")
    self:InjectView("ShangPaiNode3")

    --左边玩家出牌节点
    self:InjectView("ZuoPaiNode")
    self:InjectView("ZuoPaiNode1")
    self:InjectView("ZuoPaiNode2")
    self:InjectView("ZuoPaiNode3")

    --玩家手牌花色精灵
    self:InjectView("PLZuoPNode")
    self:InjectView("PLZuoPNode1")

    self:InjectView("PLYouPNode")
    self:InjectView("PLYouPNode1")

    self:InjectView("PLShangPNode")
    self:InjectView("PLShangPNode1")

    --四个玩家的抓到的牌的节点(用节点的位置)
    self:InjectView("zheng_zpwz")
    self:InjectView("PLShang_zpwz")
    self:InjectView("PLZuoPNode1_zpwz")
    self:InjectView("PLYouPNode1_zpwz")


    self.PLShangPNode1:setVisible(false)
    self.PLShang_zpwz:setVisible(false)
    self.ShangPaiNode1:setVisible(false)
    self.ShangPaiNode2:setVisible(false)
    self.ShangPaiNode3:setVisible(false)

    self.ZuoPaiNode1:setVisible(false)
    self.ZuoPaiNode2:setVisible(false)
    self.ZuoPaiNode3:setVisible(false)

    self.MyChuPaiNode3:setVisible(false)
    self.MyChuPaiNode2:setVisible(false)
    self.MyChuPaiNode1:setVisible(false)

    self.YouPaiNode3:setVisible(false)
    self.YouPaiNode2:setVisible(false)
    self.YouPaiNode1:setVisible(false)

    self.PLYouPNode1_zpwz:setVisible(false)
    self.PLYouPNode1:setVisible(false)

    self.MyChuPaiNode3:setVisible(false)
    self.MyChuPaiNode2:setVisible(false)
    self.MyChuPaiNode1:setVisible(false)

    self.PLZuoPNode1_zpwz:setVisible(false)
    self.PLZuoPNode1:setVisible(false)

    self:HidePGHGui()


    self:InjectView("Node")

    self:InjectView("zheng_Copy")

    local sum = 2
    self:OnClick(self.Image_hu, function()
        print("Image_hu")

    end,{["isScale"] = false, ["hasAudio"] = false})

    local ind = 2
    self:OnClick(self.Image_gang, function()
        print("Image_gang")
        self:HidePGHGui()

       pkModel.mPlayPoptyTb[sum]:GangPai( pkModel.mPlChupaiVal,1 )
       pkModel.mPlayPoptyTb[sum]:ZhuaPai( pkModel:GetSYGbValTb() )



    end,{["isScale"] = false, ["hasAudio"] = false})
    


    self:OnClick(self.Image_peng, function()
        print("Image_peng")
        self:HidePGHGui()


        pkModel.mPlayPoptyTb[sum]:PengPai(  pkModel.mPlChupaiVal )


    end,{["isScale"] = false, ["hasAudio"] = false})


    self:OnClick(self.Image_guo, function()
        print("Image_guo")
        self:HidePGHGui()
       local a = math.random(1,25)


    end,{["isScale"] = false, ["hasAudio"] = false})    


    self:initSeat()

    self:initDeskTopNode()
    self:InjectView("hgpg")
    self:InjectView("beijing")
    self.beijing:setVisible(false)


    self.hgpg:setVisible(false)

    self:InjectView("MyDPNode")
    self.MyDPNode.mCounter = 0

    self:InjectView("DJDPNode")
    self.DJDPNode.mCounter = 0


    self:InjectView("YouDPNode")
    self.YouDPNode.mCounter = 0


    self:InjectView("ZuoDPNode")
    self.ZuoDPNode.mCounter = 0

    self:initPlayerProperty()
end


function PokerDeskNode:initPlayerProperty(  )
    

    local function GetUid( id )
        for k,v in pairs(pkModel.mIcondata) do
            if v.seat == id then
                return v
            end
        end
    end

    local data = GetUid(pkcf.POSTB.ZUO)
    local noed1 = xzmj.layer.PokerDeskLeftpl.new(self)
    noed1:UpdateInfoDate( data )
    pkModel.mPlayPoptyTb[ data.seat ] = noed1
    self:addChild(noed1)


    
    local data = GetUid(pkcf.POSTB.SHANG)
    local noed4 = xzmj.layer.PokerDeskToppl.new(self)
    noed4:UpdateInfoDate( data )
    pkModel.mPlayPoptyTb[ data.seat ] = noed4
    self:addChild(noed4)


    local data = GetUid(pkcf.POSTB.XIA)
    local noed2 = xzmj.layer.PokerDeskMypl.new(self)
    noed2:UpdateInfoDate( data )
    pkModel.mPlayPoptyTb[ data.seat ] = noed2
    self:addChild(noed2)

    local data = GetUid(pkcf.POSTB.YOU)
    local noed3 = xzmj.layer.PokerDeskRightpl.new(self)
    noed3:UpdateInfoDate( data )   
    pkModel.mPlayPoptyTb[ data.seat ] = noed3
    self:addChild(noed3)


    pkModel:InitPlData()

end

function PokerDeskNode:GetCsbName()
    return "PokerDeskNode"
end

--[[
    初始化方位节点
    里面有东南西北得动画
]]--
function PokerDeskNode:initSeat()
    
    self.mSeatNode = xzmj.layer.Poker_wind.new()
    self.mSeatNode:setPosition(0,0)
    self:addChild(self.mSeatNode)



end

function PokerDeskNode:UpdateAcStyle(_Style)
    self.mSeatNode:UpdateAcStyle(_Style)
end


--[[
    里面有玩家固定得动画节点
]]--
function PokerDeskNode:initDeskTopNode()
    
    self.mDeskTopNode = xzmj.layer.PokerDeskTopNode.new()
    self.mDeskTopNode:setPosition(0,0)
    self:addChild(self.mDeskTopNode)
end

--[[
    显示胡碰杠过的UI
]]--
function PokerDeskNode:ShowPGHGui( _tab )
    if _tab == nil or #_tab <= 0 then
        print( "===========error====PokerDeskNode:ShowGPHGui=========" )
        return
    end

    self:HidePGHGui()
    for k ,v in pairs(_tab) do
        if v then
            if v == pkcf.MJONGTY.PENG then
                self.Image_peng:setVisible(true)
            end
            if v == pkcf.MJONGTY.MINGGANG  or v == pkcf.MJONGTY.ANGANG then
                self.Image_gang:setVisible(true)
            end
            if v >= pkcf.MJONGTY.LONGQIDUI then
                self.Image_hu:setVisible(true)
            end
            self.Image_guo:setVisible(true)
        end
    end
end

--[[
    隐藏玩家的碰杠胡过UI
]]--
function PokerDeskNode:HidePGHGui(  )
    self.Image_hu:setVisible(false)
    self.Image_gang:setVisible(false)
    self.Image_peng:setVisible(false)
    self.Image_guo:setVisible(false)
end




function PokerDeskNode:onExit()
    
    pkModel:onExit()
    local tbdata  = pkModel.mPlayPoptyTb
    for k,v in pairs(tbdata) do
        if v then
            v:onExit()
        end
    end
end
return PokerDeskNode

