local Type = import("..DataType")

local CSReceiveExtension =
    {
        ID = _LAIXIA_PACKET_CS_ReceiveExtensionID ,

        name = "CSReceiveExtension" ,
        data_array=
        {

            {"Code",Type.Short,},   --验证码

        }

    }

return CSReceiveExtension
