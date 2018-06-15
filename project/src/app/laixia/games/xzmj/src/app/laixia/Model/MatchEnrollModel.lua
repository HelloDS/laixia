--
-- Author: Feng
-- Date: 2018-04-13 18:34:44
--
--[[
--------------------------
	比赛界面数据和刷新
	
--------------------------
  ]]--

local MatchEnrollModel =  class("MatchEnrollModel")


--[[
	服务器初始化数据在这里赋值
]]--
function MatchEnrollModel:SetUserData( data )
	self.mUserData = data
end

function MatchEnrollModel:GetUserData( ... )
	return self.mUserData
end


--[[
	打开比赛界面
]]--
function MatchEnrollModel:OpenMaEnLayer( ... )
	
end

return MatchEnrollModel