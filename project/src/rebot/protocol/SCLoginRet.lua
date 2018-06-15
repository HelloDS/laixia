local Type = require("rebot.DataType")

local function onSCLoginRetPacket(packet)
    _G.EventDispatch:pushEvent("Resp_Rebot_Login", packet)
end

local SCLoginRet =
    {
        name = "SCLoginRet",
        ID = _LAIXIA_PACKET_SC_Login_ID,
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "HttpCode", Type.Short },-- 校验码
            { "Account", Type.UTF8 },-- 帐号
            { "Password", Type.UTF8 },-- 密码
            { "PlatformID", Type.Byte },-- 平台类型
            { "Address", Type.UTF8 },-- 地址
            { "Name", Type.UTF8 },-- 昵称
            { "Gender", Type.Byte },-- 性别 0男 1女
            { "HeadImgPath", Type.UTF8 },-- 头像路径
            { "Maintenance", Type.UTF8 },-- 维护公告
            { "weChatServer",Type.UTF8 },--微信服务号
            { "PhoneNum",Type.UTF8},
        },
        HandlerFunction = onSCLoginRetPacket,
    }

return SCLoginRet