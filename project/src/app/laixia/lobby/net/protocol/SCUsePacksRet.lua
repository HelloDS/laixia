local laixia = laixia;

local Type =  import("..DataType")
local StatusCode = import("..StatusCode")

local function onSCUsePacksRetPacket(packet)

    local Status = packet.data.StatusID
    if StatusCode.new(Status):isOK() then

        local Items = packet.data.Items
        local ChangeItems = packet.data.ChangeItem

        for ii, vv in ipairs(laixia.LocalPlayercfg.LaixiaPropsData) do
            if vv.ItemID == ChangeItems then
                vv.ItemCount = vv.ItemCount - 1
            end
        end
        for i, v in ipairs(Items) do
            if v.ItemID==1001 then
                laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + v.ItemCount
            elseif v.ItemID==1002 then
                laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon + v.ItemCount
            elseif v.ItemObjectID == nil or v.ItemObjectID<=0 then

            else
                if laixia.LocalPlayercfg.LaixiaPropsData then
                    local isHas=false
                    for j, k in ipairs(laixia.LocalPlayercfg.LaixiaPropsData) do
                        if k.ItemObjectID == v.ItemObjectID then
                            isHas=true
                            k.ItemCount = v.ItemCount + k.ItemCount
                        end
                    end
                    if isHas==false then
                        table.insert(laixia.LocalPlayercfg.LaixiaPropsData,v)
                    end
                end
            end

        end

        for i = #laixia.LocalPlayercfg.LaixiaPropsData,1,-1 do
            if laixia.LocalPlayercfg.LaixiaPropsData[i].ItemCount<=0 then
                table.remove(laixia.LocalPlayercfg.LaixiaPropsData,i)
            end
        end
        local itemData =laixia.JsonTxtData:queryTable("items"):query("ItemID",ChangeItems);

        if itemData.PresentItemID1 == 1003 then
            local str = "恭喜您获得微信红包"..itemData.BaseCount .."元，请去微信查收。"
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,str)
        else
            --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GETLAIDOU, Items)
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GAIN_WINDOW, Items)
        end
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_TOOLBOX_WINDOW)

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATAGOLD)
    end
end

local SCUsePacksRet =
    {
        ID = _LAIXIA_PACKET_SC_UsePacksID,
        name = "SCUsePacksRet",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "ChangeItem", Type.Int}, --  使用物品id
            { "Items", Type.Array, Type.TypeArray.Items },-- 道具
        },
        HandlerFunction = onSCUsePacksRetPacket,
    }

return SCUsePacksRet