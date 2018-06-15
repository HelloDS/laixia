
local Type = import("..DataType")

local CSExchange =
    {
        ID = _LAIXIA_PACKET_CS_ExchangeID ,

        name = "CSExchange" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
            {"ExchangeID",Type.Int},
            {"ExchangePos",Type.Byte},  --兑换位置0兑换商城，1背包
            {"ItemObjID",Type.Double},  --道具ID
            {"ReceiveName",Type.UTF8},      --收件人姓名
            {"Number",Type.UTF8},           --收件人手机号
            {"Address",Type.UTF8},     --收件人地址
            {"PlayerQQ",Type.UTF8}, --QQ号
            {"PlayerBankID",Type.UTF8},  --银行卡号
            {"PlayerBankName",Type.UTF8},  --开户银行
            {"BankPerson",Type.UTF8},  --持卡人
        }

    }

return CSExchange
