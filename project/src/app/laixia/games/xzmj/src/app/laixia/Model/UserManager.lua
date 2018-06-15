--
-- @Author: ding
-- @Date:   2018-04-24 14:58:29
-- 

local UserManager =  class("UserManager")
local PlayerVO = import(".PlayerInfoVO")

function UserManager:ctor()
   self.playerVOArray = {}
end

--[[
 * 更新
 * @param  data {pid,name,headUrl,gold,coin..}
--]]
function UserManager:updatePlayer(data)
    if not self.playerVo then
        self.playerVo = PlayerVO.new()
    end
    self.playerVo:update(data)
end

--[[
 * 获取 个人信息数据
 * @return  playerVo
--]]
function UserManager:getPlayerVO()
    return self.playerVo
end

--[[
 * 设置游戏场信息
 * @param data = {"1"=data {pid,name,headUrl,gold,coin})
--]] 
function UserManager:setPlayerVOArray(data)
    self.playerVOArray = {}
    local playerVO
    for k,vo in pairs(data) do
        playerVO = PlayerVO.new()
        playerVO:update(vo)
        self.playerVOArray[vo.pid] = playerVO
    end
end 

--[[
 * 获取信息通过标识
 * @param id 标识
--]] 
function UserManager:getPlayerVOByPid(pid)
    return self.playerVOArray[pid]
end 

--[[
 * 移除信息通过标识
 * @param pid 标识
--]] 
function UserManager:removePlayerVOByPid(pid)
    local playerVO = self.playerVOArray[pid]
    if playerVO and playerVO["destroy"] then
        playerVO:destroy()
    end
    table.remove(self.playerVOArray,pid)
end 

--[[
 * 获取信息数组
 * @param id 标识
--]] 
function UserManager:getPlayerVOArray()
    return self.playerVOArray
end 

--[[
 * 注销
--]]
function UserManager:destroy()
    for k,v in pairs(self.playerVOArray) do
        v:destroy()
    end
    self.playerVOArray = nil
    if self.playerVo then
        self.playerVo:destroy()
        self.playerVo = nil
    end
end

return UserManager