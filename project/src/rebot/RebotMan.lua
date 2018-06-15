--[[
    参加比赛机器人逻辑
]]
local Packet = require("rebot.Packet")
local RebotMan = class("RebotMan")

function RebotMan:ctor(index, config, isFirstRebot, dif, cb_signUp, cb_joinMatch)
    --配置信息
    self.rebot_config           = config
    --机器人索引
    self.m_index                = index
    --是否输出日志
    self.m_isFirstRebot         = isFirstRebot
    --索引差值 用于计算PID
    self.m_dif                  = dif
    --机器人账户
    self.m_accout               = string.sub(tostring(os.time), -3, string.len(tostring(os.time))) .. config.Account .. "R" .. tostring(math.random(0,10000)) .. "I" .. tostring(self.m_index) 
    --机器人玩家ID
    self.m_playerId             = 0
    --报名回调函数
    self.m_cbSignUp             = cb_signUp
    --参赛回调函数
    self.m_cbJoinMatch          = cb_joinMatch

    self.m_severRequest         = require("rebot/SeverRequest").new(index)

    self.m_httpCode             = ""

    --开启机器人
    self:startRebotMan()
end

function RebotMan:startRebotMan()
--    --请求进入游戏
    _G.EventDispatch:addEventListener("Req_Rebot_EnterGame",     handler(self, self.reqEnterGame))
--    --请求报名比赛
    _G.EventDispatch:addEventListener("Req_Rebot_SignUpMatch",   handler(self, self.reqSignUpMatch))
--    --请求进入比赛
--    _G.EventDispatch:addEventListener("Req_Rebot_JoinMatch",     handler(self, self.reqJoinMatch))
--    --请求托管
--    _G.EventDispatch:addEventListener("Req_Rebot_ColloCation",   handler(self, self.reqColloCation))
--    --响应登录游戏
    _G.EventDispatch:addEventListener("Resp_Rebot_Login",        handler(self, self.respLogin))
--    --响应进入游戏
    _G.EventDispatch:addEventListener("Resp_Rebot_EnterGame",    handler(self, self.respEnterGame))
--    --响应报名比赛
    _G.EventDispatch:addEventListener("Resp_Rebot_SignUpMatch",  handler(self, self.respSignUpMatch))
--    --响应进入比赛
--    _G.EventDispatch:addEventListener("Resp_Rebot_JoinMatch",    handler(self, self.respJoinMatch))
--    --输出错误日志
--    _G.EventDispatch:addEventListener("Rebot_printErrorLog",     handler(self, self.printErrorLog))

    self:reqLogin()
end

--[[
    请求登录游戏
]]
function RebotMan:reqLogin()
    if self.m_isFirstRebot then
        print("------------------------登录游戏---------------------")
    end
    local CS_PacketLogin = Packet.new("CSPacketLogin", _LAIXIA_PACKET_CS_Login_ID)
    CS_PacketLogin:setPacketInfo("Code",         0)
    CS_PacketLogin:setPacketInfo("GameID",       self.rebot_config.GameAppID)
    CS_PacketLogin:setPacketInfo("GameType",     self.rebot_config.GameType)
    CS_PacketLogin:setPacketInfo("GameVersion",  self.rebot_config.GAME_VERSION)
    CS_PacketLogin:setPacketInfo("VersionName",  self.rebot_config.APP_VERSION)
    CS_PacketLogin:setPacketInfo("ChannelID",    self.rebot_config.ChannelID)
    CS_PacketLogin:setPacketInfo("Devices",      self.rebot_config.Devices)
    CS_PacketLogin:setPacketInfo("PlatformID",   self.rebot_config.GamePlatformID)
    CS_PacketLogin:setPacketInfo("Account",      self.m_accout)
    CS_PacketLogin:setPacketInfo("UnionID",      self.rebot_config.UnionID)
    CS_PacketLogin:setPacketInfo("Passwd",       self.rebot_config.PassWord)
    CS_PacketLogin:setPacketInfo("IMEI",         self.rebot_config.Imei)
    CS_PacketLogin:setPacketInfo("Token",        self.rebot_config.Token)
    local str  = "versionName=" .. self.rebot_config.APP_VERSION .. "&channelId=" .. self.rebot_config.ChannelID      ..
                 "&mobileInfo=" .. self.rebot_config.Devices     .. "&platform="  .. self.rebot_config.GamePlatformID .. 
                 "&account="    .. self.m_accout
    local md5msg = crypto.md5(str)
    CS_PacketLogin:setPacketInfo("Md5msg", md5msg)
    self.m_severRequest:sendHttpPacket(CS_PacketLogin)
end

--[[
    响应登录游戏
]]
function RebotMan:respLogin(event)
    if not event or not event.data then
        return
    end
    local data = event.data
    local info = data.m_packetInfo
    if self.m_accout == info.Account then
        local address = info.Address
        self.m_severRequest:setTcpAddress(address)
        self.m_httpCode = info.HttpCode
        self.m_playerId = data.m_playerId
        self.rebot_config.ReLoginRebotNum = self.rebot_config.ReLoginRebotNum + 1
        print("账号 = " .. self.m_accout  .. "  玩家ID = " .. self.m_playerId .. "    响应登录大厅  共计" .. self.rebot_config.ReLoginRebotNum .. "人")
        self.m_severRequest:startTcp(self.m_accout)
    end
end

--[[
    请求进入游戏
]]
function RebotMan:reqEnterGame(event)
    if self.m_accout ~= event.data.account then
        return
    end
    self.rebot_config.ReQInGameRebotNum = self.rebot_config.ReQInGameRebotNum + 1
    print("账号 = " .. self.m_accout  .. "  玩家ID = " .. self.m_playerId .. "    请求进入大厅  共计" .. self.rebot_config.ReQInGameRebotNum .. "人")
    local CSEnterGamePacket = Packet.new("CSEnterGamePacket", _LAIXIA_PACKET_CS_EnterGameID)
    CSEnterGamePacket:setPlayerID(self.m_playerId)
    CSEnterGamePacket:setPacketInfo("GameID", self.rebot_config.GameAppID)
    CSEnterGamePacket:setPacketInfo("Key", self.m_httpCode)
    self.m_severRequest:sendPacket(CSEnterGamePacket)
end

--[[
    响应进入游戏
]]
function RebotMan:respEnterGame(event)
    if self.m_playerId ~= event.data.m_playerId then
        return
    end
    self.rebot_config.ReSInGameRebotNum = self.rebot_config.ReSInGameRebotNum + 1
    print("账号 = " .. self.m_accout .. "  玩家ID = " .. self.m_playerId .. "    响应进入大厅  共计" .. self.rebot_config.ReSInGameRebotNum .. "人")
    if self.rebot_config.ReSInGameRebotNum == self.rebot_config.RebotNum then
        print("------------------------请求报名比赛------------------------")
        _G.EventDispatch:pushEvent("Req_Rebot_SignUpMatch")
    end
end

--[[
    请求报名比赛
]]
function RebotMan:reqSignUpMatch()
    self.rebot_config.ReQSignUpRebotNum = self.rebot_config.ReQSignUpRebotNum + 1
    print("账号 = " .. self.m_accout .. "  玩家ID = " .. self.m_playerId .. "    请求报名比赛  共计" .. self.rebot_config.ReQSignUpRebotNum .. "人")
    local CSMatchRegister = Packet.new("CSMatchRegister", _LAIXIA_PACKET_CS_MatchRegisterID)
    CSMatchRegister:setPlayerID(self.m_playerId)
    CSMatchRegister:setPacketInfo("GameID", self.rebot_config.GameAppID)
    CSMatchRegister:setPacketInfo("PageType", 0)
    CSMatchRegister:setPacketInfo("RoomID", self.rebot_config.RoomId)
    CSMatchRegister:setPacketInfo("ItemID", 1001)
    CSMatchRegister:setPacketInfo("RegisterCode", "")
    self.m_severRequest:sendPacket(CSMatchRegister)
end

--[[
    响应报名比赛
]]
function RebotMan:respSignUpMatch(event)
    if not event or not event.data or not event.data.data then
        return
    end
    local data = event.data.data
    local status = data.Status
    if status == 0 then
        self.m_cbSignUp(self.m_accout, self.m_playerId)
    else
        self.rebot_config.ReSSignUpFailNum = self.rebot_config.ReSSignUpFailNum + 1
        print("账号 = " .. self.m_accout .. "   PID = " .. self.m_playerId .. "   报名失败 状态码 = " .. status .. "  共计" .. self.rebot_config.ReSSignUpFailNum .. "人")
    end
end

--[[
    请求进入比赛
]]
function RebotMan:reqJoinMatch()
    local CGjoinMatch = Packet.new("CGjoinMatch", _LAIXIA_PACKET_CS_MatchJoinInID, self.m_playerId)
    CGjoinMatch:setPacketInfo("GameID", self.rebot_config.GameAppID)
    CGjoinMatch:setPacketInfo("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
    CGjoinMatch:setPacketInfo("RoomID", laixia.LocalPlayercfg.LaixiaMatchLastRoom)
    self.m_severRequest:sendPacket(CGjoinMatch)
end

--[[
    请求托管
]]
function RebotMan:reqColloCation(event)
    if not event or not event.data or not event.data.data then
        return
    end
    local data = event.data.data
    local roomId = data.RoomID
    local tableId = data.TableID
    local packet = Packet.new("CancelHosting", _LAIXIA_PACKET_CS_CancelMandateID, self.m_playerId)
    packet:setPacketInfo("RoomID", roomId)-- 写入包数据
    packet:setPacketInfo("TableID", tableId)-- 写入包数据
    packet:setPacketInfo("isMandate", 1)-- 写入包数据
    self.m_severRequest:sendPacket(packet)

    if self.m_isFirstRebot then
        print("请求托管")
    end
end

--[[
    响应进入比赛
]]
function RebotMan:respJoinMatch()
    self.m_cbJoinMatch(self.m_accout, self.m_playerId)
end

--[[
    输出错误日志
]]
function RebotMan:printErrorLog(msg)
    if not msg or not msg.data or not msg.data._buf then
        return
    end
    if self.m_isFirstRebot then
--        dump(msg.data._buf, "机器人数据日志", 9)
    end
end

return RebotMan