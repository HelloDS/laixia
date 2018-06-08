--region NewFile_1.lua
--Author : guilong3
--Date   : 2017/4/12
--此文件由[BabeLua]插件自动生成
--BASIC_ID + 505

local StatusCode = import("...StatusCode")
local Type = import("...DataType")

local function onSCDragonPresentRetPacket(packet)
    if StatusCode.new(packet.data.Status):isOK() then
        laixia.LocalPlayercfg.LaixiaPlayerGold  = packet.data.Coin  --laixia.LocalPlayercfg.LaixiaPlayerGold
        if packet.data.AcceptID == laixia.LocalPlayercfg.LaixiaPlayerID then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"收到好友桃李卡")
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_TAOLIKA_MESG)
        end

        --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_HIDE_TAOLIKA )
    end
end

local SCDragonPresentRet =
    {
        name = "SCDragonPresentRet",
        ID = _LAIXIA_PACKET_SC_DragonPresentRetID,
        data_array =
        {
            {"Status",Type.Short},
            {"ItemID",Type.Int},
            {"AcceptID",Type.Int},
            {"Time",Type.Int},
            {"Coin",Type.Double},
            {"Items", Type.Array,Type.TypeArray.Items},
        },
        HandlerFunction = onSCDragonPresentRetPacket,
    }

return SCDragonPresentRet

--endregion
