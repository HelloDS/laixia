

--[[
--------------------------
	游戏场数据
--------------------------
]]--

local PlayGroundModle =  class("PlayGroundModle")

function PlayGroundModle:Init( data )

    if data == nil then
        data = 
        {
            difen1   = 888,
            difen2   = 888,
            difen3   = 888,

            jinru1   = 888,
            jinru2   = 888,
            jinru3   = 888,
            
            nownum1   = 888,
            nownum2   = 888,
            nownum3   = 888,
        }
    end
    self.mInfo = data
end

function PlayGroundModle:InitData( Date )

end
PlayGroundModle:Init()
return PlayGroundModle



