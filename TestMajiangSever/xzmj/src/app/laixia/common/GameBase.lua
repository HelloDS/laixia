--[[
********************************************************
    @date:       2018-3-1
    @author:     zl
    @version:    1.0
    @describe:   游戏基类
********************************************************
]]

local GameBase = class("GameBase")

function GameBase:ctor(...)

end

--[[
    游戏启动时被调用
    @rootLayer      游戏的根层
]]
function GameBase:onEnter(rootLayer)
    assert(false, "game must be override onEnter function.")
end

--[[
    游戏调用 gameManager:exitGame() 后会被调用，可以在这里释放资源等
]]
function GameBase:onExit()
    assert(false, "game must be override onExit function.")
end

return GameBase