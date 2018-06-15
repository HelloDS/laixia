

--[[
--------------------------
	游戏主界面数据
	这里有玩家得唯一数据
--------------------------
]]--

local GameLayerModel =  class("GameLayerModel")

function GameLayerModel:Init( data )

	if data == nil then
		data = 
		{
			 uid = 10002,
			-- 名称
			 name = "我是王小二",
			-- 头像
			 icon = "games/xzmj/common/headimage/touxiang.png",
			-- 金币
			 jinbi = 888,
			-- 来豆
			 laidou = 9999,
			-- 性别 男 == 1  女= 0
			 sex =  2,
			-- 方位
			 seat = 1,	
		}
	end
	self.mInfo = xzmj.Model.UserInfoModel.new()
	self.mInfo:update(data)
end

function GameLayerModel:InitData( data )

end

function GameLayerModel:GetUid(  )
	return self.mInfo:GetUid()
end

function GameLayerModel:GetInfo( ... )
	return self.mInfo
end


GameLayerModel:Init(  )
return GameLayerModel
