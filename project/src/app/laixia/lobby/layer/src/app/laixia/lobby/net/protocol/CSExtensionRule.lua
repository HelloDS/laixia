local Type = import("..DataType")

local CSExtensionRule =
    {
        ID = _LAIXIA_PACKET_CS_ExtensionRuleID ,

        name = "CSExtensionRule" ,
        data_array=
        {
            {"Code",Type.Short,},   --验证码

        }

    }

return CSExtensionRule
