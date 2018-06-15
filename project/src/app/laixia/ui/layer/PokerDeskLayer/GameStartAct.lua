


--[[
	游戏开场动画
]]--

local GameStartAct = class("GameStartAct", import("...BaseView"))
--local pkcf = xzmj.layer.PokerDeskConfig
function GameStartAct:ctor(...)
    GameStartAct.super.ctor(self)

    self:Star()
end


function GameStartAct:Star()
	local node = cc.Node:create()
	node:setPosition( 640,360 )
	self:addChild( node )

    local arr = {}
    table.insert(arr, cc.DelayTime:create(0.4))
    table.insert(arr,cc.CallFunc:create(function()
       

    	self:dismiss()
        xzmj.MainCommand:InTypeJumpView(12)


    end))
    self:runAction(cc.Sequence:create(arr))

    self:playAnimationAt( node,pkcf.STARACT,"Default Timeline",function (  )
    end )
end


return GameStartAct

