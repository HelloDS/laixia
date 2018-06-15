--头像上传

local Type = import("..DataType")

local function SplitLastStr(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local ret = nil
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            ret = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            nSplitArray[nSplitIndex] = ret
            break
        end

        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return ret
end

local function onSCHeadUploadPacket(packet)

    local StatusID = packet:getValue("StatusID")
    local PictureName = packet:getValue("PictureName")

    if StatusID == 0 then
        local temp = SplitLastStr(PictureName, "/")
        local newName = string.sub(temp, 1, string.len(temp)-4)
        laixia.LocalPlayercfg.LaixiaPlayerHeadUse = newName
        laixia.LocalPlayercfg.LaixiaHeadPortraitPath = PictureName
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"恭喜，头像上传成功！")
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_PICTURE_WINDOW)
    end
end

local SCHeadUpload =
    {
        name = "SCHeadUpload",
        ID = _LAIXIA_PACKET_SC_HeadUploadID,
        data_array =
        {
            {"StatusID", Type.Short},
            {"PictureName", Type.UTF8},
        },

        HandlerFunction = onSCHeadUploadPacket,
    }

return SCHeadUpload

--endregion
