--
-- @Author: ding
-- @Date:   2018-04-24 14:51:50
-- 
local PlayerInfoVO = class("PlayerInfoVO")

--[[
 * 更新
 * @param  data {pid,name,headUrl,gold,coin ...}
--]]
function PlayerInfoVO:update(data)
	-- 标识
	self.pid = data.pid or 0
	-- 名称
	self.name = data.name or ""
	-- 头像
	self.headUrl = data.headUrl or ""
	-- 金币
	self.gold = data.gold or 0
	-- 硬币
	self.coin = data.coin or 0
	-- 性别 男 == 1
	self.sex = data.sex or 2
end

--[[
 * 获取 个人信息 标识
 * @return  pid 标识
--]]
function PlayerInfoVO:getPid()
    return self.pid
end

--[[
 * 获取 个人信息 金币
 * @return  gold 金币
--]]
function PlayerInfoVO:getGold()
    return self.gold
end

--[[
 * 获取 个人信息 硬币
 * @return  coin 硬币
--]]
function PlayerInfoVO:getCoin()
    return self.coin
end

--[[
 * 获取 个人信息 名字
 * @return  name 名字
--]]
function PlayerInfoVO:getName()
    return self.name
end

--[[
 * 获取 个人信息 头像
 * @return  headUrl 头像
--]]
function PlayerInfoVO:getHeadUrl()
    return self.headUrl
end


--[[
 * 获取 个人信息 性别
 * @return  sex 性别
--]]
function PlayerInfoVO:getSex()
    return self.sex
end

--[[
 * 注销
--]]
function PlayerInfoVO:destroy()
	-- 标识
	self.pid = nil
	-- 名称
	self.name = nil
	-- 头像
	self.headUrl = nil
	-- 金币
	self.gold = nil
	-- 硬币
	self.coin = nil
	-- 性别
	self.sex = nil
end

return PlayerInfoVO 