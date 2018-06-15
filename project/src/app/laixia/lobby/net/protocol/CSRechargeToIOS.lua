--ios充值回调消息
local Type = import("..DataType")

CSRechargeToIOS =
    {
        ID=_LAIXIA_PACKET_CS_RechargeToIOS ,
        name = "CSRechargeToIOS",
        data_array =
        {
            {"Code",Type.Short,},   --验证码
            { "AppID",Type.Short}, --游戏应用ID
            { "IOSResult", Type.UTF8 }, --ios返回客户端消息
            { "OrderID", Type.UTF8 }, --订单号
        },

    };
return  CSRechargeToIOS


