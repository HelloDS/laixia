--
-- @Author: shegnli
-- @Date:   2018-05-11 22:24:43
-- 

local UserInfo = {}
function UserInfo:updateInfo(data)
    if data then
    	-- 金币
    	self.gCoin = data.gold_coin or 0
    	-- 来豆
    	self.lCoin = data.laidou_coin or 0
    	-- 芝士币
    	self.zCoin = data.zscoin or 0
    end
end

function UserInfo:getGCoin()
	return self.gCoin
end

function UserInfo:getLCoin()
	return self.lCoin
end

function UserInfo:getZCoin()
	return self.zCoin
end

return UserInfo