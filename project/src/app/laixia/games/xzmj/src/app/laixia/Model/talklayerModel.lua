

--[[
--------------------------
	玩家聊天数据类
	
--------------------------
]]--

local talklayerModel =  class("talklayerModel")
--[[
    
]]--
function talklayerModel:Init(  )

    self.mDailyTextTb = {}
    self:InitData()
    self.mEnjoySum = 52
end


function talklayerModel:InitData(  )

    self.mDailyTextTb = 
    {
        "啊实打实大苏打实",
        "今天真高兴",
        "今天真搞笑",
        "今天真(｡･∀･)ﾉﾞ嗨",
        "今天真乐",
        "今天真搞笑",
        "今天真搞笑",
    }
end


talklayerModel:Init()
return talklayerModel
