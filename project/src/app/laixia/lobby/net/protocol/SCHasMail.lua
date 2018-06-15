-- 是否有站内信
local Type = import("..DataType")

local function onSCHasMailPacket(packet)
    print("站内信"..laixia.LocalPlayercfg.LaixiaIsHaveEmil)
    laixia.LocalPlayercfg.LaixiaIsHaveEmil = packet:getValue("HasMail")
    if packet:getValue("HasBag") ~= 0 then
        laixia.LocalPlayercfg.LaixiaBagisShow = true
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BAGRED_WINDOW)
    end
    if laixia.LocalPlayercfg.LaixiaIsHaveEmil ~= 0 then
        -- if ObjectLocalPlayerData.LaixiaEmailisShow == true then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LETTERRED_WINDOW)
        -- end
    end
end

local SCHasMail =
    {
        ID = _LAIXIA_PACKET_SC_HasMailID,
        name = "SCHasMail",
        data_array =
        {
            { "HasMail", Type.Byte },-- 是否有信
            { "HasBag" , Type.Byte },
        },
        HandlerFunction = onSCHasMailPacket,
    }

return SCHasMail