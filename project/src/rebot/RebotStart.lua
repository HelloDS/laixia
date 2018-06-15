--[[
    机器人开启
        读取json数据
        启动
]]
local rebot_config = require("rebot/RebotConfig")
local rebotMan = require("rebot/RebotMan")
local RebotStart = class("RebotStart")

--[[
    构造函数
]]
function RebotStart:ctor()
    --报名成功人数
    self.m_arrSignUp    = {}
    --参赛成功人数
    self.m_arrJoinMatch = {}
    --是否开启机器人
    self.m_isOpen       = false
    --初始化
    self:init()
end

--[[
    初始化
]]
function RebotStart:init()
    local data = self:getDataFromJson()
    if not data.isOpen or data.isOpen == 0 then
        return
    end
    self.m_isOpen = true
    local function refreshData(config_key, json_key)
        rebot_config[config_key] = data[json_key] and data[json_key] or rebot_config[config_key]
    end
    refreshData("RoomId", "roomId")
    refreshData("RebotNum", "rebotNum")
    refreshData("Account", "account")

    self:startRebot()
end

--[[
    从Json文件获取数据
]]
function RebotStart:getDataFromJson()
    local rebotConfig = cc.FileUtils:getInstance():getStringFromFile("data/rebotConfig.json")
    if not rebotConfig or rebotConfig == "" then
        return nil
    end
    return json.decode(rebotConfig)
end

--[[
    启动机器人
]]
function RebotStart:startRebot()
    local total = rebot_config.RebotNum
    if total < 1 then
        return
    end
    for i = 1, total do
        local dif = total - i
        local isFirst = i == 1
        rebotMan.new(i,
            rebot_config,
            isFirst,
            dif,
            handler(self, self.cbSignUp_print),
            handler(self, self.cbJoinMatch_print)
            )
    end
end

--[[
    输出报名比赛成功
]]
function RebotStart:cbSignUp_print(account, playerId)
    local isExist = false
    for _,v in ipairs(self.m_arrSignUp) do
        if v == account then
            isExist = true
            break
        end
    end
    if not isExist then
        self.m_arrSignUp[#self.m_arrSignUp+1] = account
--        local accLen = string.len(account)
--        local str_acc = account .. (15 - accLen) * " "
        local str_acc = string.format("账号 = " .. string.sub(tostring(account), 1, 55))
        print(str_acc .. "  玩家 = " .. playerId .. "  报名游戏，共计" .. #self.m_arrSignUp .. "个")
    end
end

--[[
    输出加入比赛成功
]]
function RebotStart:cbJoinMatch_print(account, playerId)
    local isExist = false
    for _,v in ipairs(self.m_arrJoinMatch) do
        if v == account then
            isExist = true
            break
        end
    end
    if not isExist then
        self.m_arrJoinMatch[#self.m_arrJoinMatch+1] = account
        local str_acc = string.format("账号 = " .. string.sub(tostring(account), 1, 55))
        print(str_acc .. "  玩家 = " .. playerId .. "  进入游戏，共计" .. #self.m_arrJoinMatch .. "个")
    end
end

return RebotStart