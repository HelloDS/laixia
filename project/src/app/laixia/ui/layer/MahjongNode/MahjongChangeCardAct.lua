



--[[
    麻将牌  上下的出牌
]]--
local MahjongChangeCardAct = class("MahjongChangeCardAct", import("...BaseView"))
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig

function MahjongChangeCardAct:ctor( data)
    if data == nil then
        return
    end
    self.mData = data
    MahjongChangeCardAct.super.ctor(self)
    self:InjectView("Text_1")
    self:InjectView("Panel_1")
    self.Text_1:setString("")
    self:SetLayoutOpacity( self.Panel_1 )


    for i = 1,4 do
        self:InjectView("Node_"..i)
        self["Node_"..i].x = self["Node_"..i]:getPositionX()
        self["Node_"..i].y = self["Node_"..i]:getPositionY()
        self["Node_"..i]:setScale(0.6)
        self["Node_"..i]:setVisible(false)
    end	  	

        
    for j=1,4 do
        for i = 1,3 do
            self:InjectView("Image_"..j..i)
        end        
    end

   -- self:init()

   self:StarAtion()

end



function MahjongChangeCardAct:init(  )
    
        local arr = {}
        table.insert(arr, cc.DelayTime:create(1))
        table.insert(arr,cc.CallFunc:create(function()

            local sum = 0;
            for i = 1 ,4 do
                if self["Node_"..i]:isVisible() == true then
                    sum = sum + 1
                end
            end
            if sum >= 4 then
                self:stopAllActions()
                self:Rotate2()
            end
        end))
        self:runAction(cc.RepeatForever:create(cc.Sequence:create(arr)))
end

--[[对家换 ]]
function MahjongChangeCardAct:DuiJiaHuanPan(  )

    local hptb = pkModel.mPlayPoptyTb[2].hptb
    pkModel.mPlayPoptyTb[2]:SetHuanPanTb(pkModel.mPlayPoptyTb[4].hptb)
    pkModel.mPlayPoptyTb[4]:SetHuanPanTb(  hptb )

    local hptb = pkModel.mPlayPoptyTb[1].hptb
    pkModel.mPlayPoptyTb[1]:SetHuanPanTb( pkModel.mPlayPoptyTb[3].hptb)
    pkModel.mPlayPoptyTb[3]:SetHuanPanTb( hptb )


    for i = 1, 4 do
        pkModel.mPlayPoptyTb[i]:DingQueZhong()
    end


end







function MahjongChangeCardAct:Rotate1( ... )
    local path = "games/xzmj/Mahjong/heng_koupai.png"
    local time = 1

    local act = cc.MoveTo:create(time,cc.p(self["Node_"..3].x,self["Node_"..3].y))
    local act1 = cc.RotateTo:create(time, 90)
    local callf = cc.CallFunc:create(function ( ... )
        print("111111111111111")
         local a = "1"
         local b = "3"
         for i = 1,3 do
             self["Image_"..a..i]:loadTexture(path)
             self["Image_"..a..i]:setPosition(  self["Image_"..b..i]:getPosition() )
         end
    end)
    local span = cc.Spawn:create(act,act1,callf)
    self["Node_1"]:runAction( span )       



    -- local act = cc.MoveTo:create(time,cc.p(self["Node_"..4].x,self["Node_"..4].y))
    -- local act1 = cc.RotateTo:create(time, 270)
    -- local callf = cc.CallFunc:create(function ( ... )
    --     print("2222222222222")

    --      local a = "2"
    --      local b = "4" 
    --      for i = 1,3 do
    --         self["Image_"..a..i]:loadTexture(path)
    --         self["Image_"..a..i]:setPosition(  self["Image_"..b..i]:getPosition() )
    --      end
    -- end)
    -- local span = cc.Spawn:create(act,act1,callf)
    -- self["Node_2"]:runAction( span )   


    -- local path = "games/xzmj/Mahjong/koupai.png"
    -- local act = cc.MoveTo:create(time,cc.p(self["Node_"..2].x,self["Node_"..2].y))
    -- local act1 = cc.RotateTo:create(time, -270)
    -- local callf = cc.CallFunc:create(function ( ... )
    --     print("3333333333333")
    --      local a = "2"
    --      for i = 1,3 do
    --          self["Image_"..a..i]:loadTexture(path)
    --         self["Image_"..a..i]:setPosition(  self["Image_"..a..i]:getPosition() )
    --      end
    -- end)
    -- local span = cc.Spawn:create(act,act1,callf)
    -- self["Node_3"]:runAction( span )  


    -- local path = "games/xzmj/Mahjong/koupai.png"
    -- local act = cc.MoveTo:create(time,cc.p(self["Node_"..1].x,self["Node_"..1].y))
    -- local act1 = cc.RotateTo:create(time, 270)
    -- local callf = cc.CallFunc:create(function ( ... )
    --     print("44444444444444")

    --      local a = "2"
    --      local b = "1"
    --      for i = 1,3 do
    --          self["Image_"..a..i]:loadTexture(path)
    --         self["Image_"..a..i]:setPosition(  self["Image_"..b..i]:getPosition() )
    --      end
    -- end)
    -- local span = cc.Spawn:create(act,act1,callf)
    -- self["Node_4"]:runAction( span )  
end

function MahjongChangeCardAct:Rotate2( ... )

    local time = 0.3
    local a = "3"
    local b = "4"
    for i = 1,2 do
        if i == 2 then
            a = "4"
            b = "3"
        end
        local act = cc.MoveTo:create(time,cc.p(self["Node_"..b].x,self["Node_"..b].y))
        local callf = cc.CallFunc:create(function ( ... )
        end)
        local span = cc.Spawn:create(act,callf)
        self["Node_"..a]:runAction( span ) 
    end


    local a = "2"
    local b = "1"
    for i = 1,2 do
        if i == 2 then
            a = "1"
            b = "2"
        end
        local act = cc.MoveTo:create(time,cc.p(self["Node_"..b].x,self["Node_"..b].y))
        local callf = cc.CallFunc:create(function ( ... )
        end)
        local span = cc.Spawn:create(act,callf)
        self["Node_"..a]:runAction( span ) 
    end


        local arr = {}
        table.insert(arr, cc.DelayTime:create(1))
        table.insert(arr,cc.CallFunc:create(function()
            self:DuiJiaHuanPan()
            self:removeFromParent()
        end))
        self:runAction(cc.Sequence:create(arr))

end



function MahjongChangeCardAct:GetCsbName()
    return "MahjongChangeCardAct"
end 


--[[
    开始执行旋转
]]--
function MahjongChangeCardAct:StarAtion(  )

    local data = self.mData
    local name = nil
    if data.changetype == 1 then -- 顺时针
        name = pkcf.CHANGEACNAME[1]
    elseif data.changetype == 2 then -- 逆时针
        name = pkcf.CHANGEACNAME[2]
    else -- 对家换
        name = pkcf.CHANGEACNAME[3]
    end


    local node = cc.Node:create()
    node:setPosition( 640,360 )
    self:addChild( node )


    self:playAnimationAt( node,name,"Default Timeline",function (  )

    end )

end 

return MahjongChangeCardAct

