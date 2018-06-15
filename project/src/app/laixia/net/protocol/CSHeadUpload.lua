--上传个人头像

local Type = import("..DataType")

local CSHeadUpload =
    {
        ID = _LAIXIA_PACKET_CS_HeadUploadID,
        name = "CSHeadUpload",
        data_array =
        {
            {"Code",Type.Short},
            {"Data", Type.ByteArray},
        }
    }

return CSHeadUpload
