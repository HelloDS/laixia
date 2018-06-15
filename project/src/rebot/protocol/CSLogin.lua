local Type = require("rebot.DataType")

local CSLogin =
    {
        ID = _LAIXIA_PACKET_CS_Login_ID ,

        name = "CSLogin" ,
        data_array=
        {
            {"Code",Type.Short,},   --验证码
            {"GameID",Type.Short},
            {"GameType", Type.Byte,},   --1：单机线上2：欢乐地主比赛版
            {"GameVersion", Type.UTF8,},   --version号

            {"VersionName",Type.UTF8,},     --name号 --MD5
            {"ChannelID",Type.UTF8},    --渠道ID   --MD5
            {"Devices",Type.UTF8,},--手机设备     --MD5
            {"PlatformID", Type.Byte,},--平台id  --MD5
            {"Account", Type.UTF8}, --uid    --MD5

            {"UnionID",Type.UTF8,},--
            {"Passwd",Type.UTF8,},
            {"IMEI",Type.UTF8}, -- IMEI,查找数据，暂时只有Android用
            {"Token",Type.UTF8}, --
            {"Md5msg",Type.UTF8}, --md5加密
        }

    }

return CSLogin
