--
-- Author: Feng
-- Date: 2018-04-13 18:34:44
--
--[[
--------------------------
	玩家基本信息
	
--------------------------
  ]]--

local UserInfoModel =  class("UserInfoModel")

function UserInfoModel:update(data)

	self.mUid = data.uid or 0
	-- 名称
	self.mName = data.name or ""
	-- 头像
	self.mIcon = data.icon or ""
	-- 金币
	self.mJinbi = data.jinbi or 0
	-- 来豆
	self.mLaidou = data.laidou or 0
	-- 性别 男 == 1
	self.mSex = data.sex or 2
	-- 方位
	self.mSeat = data.seat or 0
end


--[[
	玩家唯一ID uuid
]]--
function UserInfoModel:SetUid( uid )
	self.mUid = uid
end
function UserInfoModel:GetUid( ... )
	return self.mUid
end

--[[
	玩家唯一来豆
]]--
function UserInfoModel:SetLaiDou( laidou )
	self.mLaidou = laidou
end
function UserInfoModel:GetLaiDou( ... )
	return self.mLaidou
end


--[[
	玩家唯一金币
]]--

function UserInfoModel:SetJinbi( jinbi )
	self.mJinbi = jinbi
end
function UserInfoModel:GetJinbi( ... )
	return self.mJinbi
end



--[[
	玩家唯一名字
]]--
function UserInfoModel:SetName( name )
	self.mName = name
end
function UserInfoModel:GetName( ... )
	return self.mName
end


--[[
	玩家icon
]]--
function UserInfoModel:SetIcon( icon )
	self.mIcon = icon
end
function UserInfoModel:GetIcon(  )
	return self.mIcon
end

--[[
	玩家性别
]]--
function UserInfoModel:SetSex( sex )
	self.mSex = sex
end

function UserInfoModel:GetSex(  )
	return self.mSex
end

--[[
	玩家方位     
]]--
function UserInfoModel:SetSeat( seat )
	self.mSeat = seat
end

function UserInfoModel:GetSeat(  )
	return self.mSeat
end


return UserInfoModel