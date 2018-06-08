local Type = import("..DataType")

local CSExtensionBinding =
    {
        ID = _LAIXIA_PACKET_CS_ExtensionBindingID ,

        name = "CSExtensionBinding" ,
        data_array=
        {
            {"Code",Type.Short,},   --��֤��
            {"BuindID",Type.Int},

        }

    }

return CSExtensionBinding
