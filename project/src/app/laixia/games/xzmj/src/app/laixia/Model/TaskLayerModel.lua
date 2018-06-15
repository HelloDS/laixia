

--[[
--------------------------
	游戏主界面数据
--------------------------
]]--

local TaskLayerModel =  class("TaskLayerModel")

function TaskLayerModel:Init(  )
    self.Telie = 
    {
        "日常任务",
        "跳战任务",
    }

    self.MiaoShu = 
    {
        "总对局8局即可获得1000金币",
        "对战中胡5次清一色即可获得200游戏币",
    }
end

function TaskLayerModel:InitData(  )

end

TaskLayerModel:Init()

return TaskLayerModel
