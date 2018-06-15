local Type = import("..DataType")

local CSPresent =
    {
        ID = _LAIXIA_PACKET_CS_PresentID ,

        name = "CSPresent" ,
        data_array=
        {

            {"Code",Type.Short,},     --验证码
            {"AppID",Type.Short},     --游戏应用ID
            {"ItemID",Type.Int},      --物品ID
            {"ItemCount",Type.Int},   --道具数量
            {"DoneeID",Type.Int},     --受赠人ID
            {"ItemObjID",Type.Double},--道具objid
        }

    }

return CSPresent
