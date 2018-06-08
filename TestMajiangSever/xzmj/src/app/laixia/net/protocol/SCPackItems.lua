local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onSCPackItemsPacket(packet)
    if StatusCode.new(packet.data.StatusID):isOK() then
        local ostime = os.time()
        local tempArray  =  packet:getValue("Items")
        local mItemArray = {}

        local farry ={}
        farry= tempArray[1]

        table.insert(mItemArray,farry)
        for i,v in ipairs(tempArray) do
            farry ={}
            farry= v
            local time = 0
--            if farry.EffTime > 0  then
--                time = math.floor(farry.EffTime/1000) - ostime
--            end

            for ii = i+1 , #tempArray  do
                if tempArray[ii].ItemID == farry.ItemID  then
                    time = math.floor( tempArray[ii].EffTime/1000) - ostime + time
                end
            end

            local count = 0

            for iii , vvv in ipairs(mItemArray) do
                if farry.ItemID ~= vvv.ItemID then
                    count = count +1
                end

                if count == #mItemArray  then
                    --farry.EffTime = time
                    table.insert(mItemArray,farry)
                end
            end
        end

        laixia.LocalPlayercfg.LaixiaPropsData = mItemArray
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_TOOLBOX_WINDOW)
    end
end

local SCPackItems =
    {
        ID = _LAIXIA_PACKET_SC_PackItemsID,
        name = "SCPackItems",
        data_array =
        {
            { "StatusID", Type.Short },
            { "Items", Type.Array, Type.TypeArray.Items },
        },
        HandlerFunction = onSCPackItemsPacket,
    }

return SCPackItems