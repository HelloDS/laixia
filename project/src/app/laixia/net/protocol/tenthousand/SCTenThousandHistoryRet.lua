local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function TenThousandHistoryRetCallBack(packet)
    if StatusCode.new(packet.data.StatID):isOK() then
        local packData =  packet.data

        local BeishuArray = {}

        local OneResult     = {}
        local TwoResult     = {}
        local ThreeResult   = {}
        local FourResult    = {}

        local OneType       = {}
        local TwoType       = {}
        local ThreeType     = {}
        local FourType      = {}
        local BankerType    = {}

        for i = 1, 10  do
            local key = "Niu" ..  i
            table.insert(BeishuArray,packData[key])
        end


        for i= 1, # packData.TrendInfoList do
            table.insert(OneResult  ,packData.TrendInfoList[i]["ResultOne"])
            table.insert(TwoResult  ,packData.TrendInfoList[i]["ResultTwo"])
            table.insert(ThreeResult,packData.TrendInfoList[i]["ResultThree"])
            table.insert(FourResult ,packData.TrendInfoList[i]["ResultFour"])
            table.insert(OneType   ,packData.TrendInfoList[i]["TypeOne"])
            table.insert(TwoType   ,packData.TrendInfoList[i]["TypeTwo"])
            table.insert(ThreeType ,packData.TrendInfoList[i]["TypeThree"])
            table.insert(FourType  ,packData.TrendInfoList[i]["TypeFour"])
            table.insert(BankerType,packData.TrendInfoList[i]["BankerType"])
        end

        local HistoryArry = {}
        table.insert(HistoryArry, OneResult    )
        table.insert(HistoryArry, TwoResult    )
        table.insert(HistoryArry, ThreeResult  )
        table.insert(HistoryArry, FourResult   )

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENNIUNIU_INITHISTORY ,HistoryArry)
    end
end

local SCTenThousandHistoryRet =
    {
        ID = _LAIXIA_PACKET_SC_TenThousandHistoryRetID,
        name = "SCTenThousandHistoryRet",
        data_array =
        {

            { "StatID", Type.Short },

            { "Niu10", Type.Int }, -- 牛牛
            { "Niu9", Type.Int }, -- 牛9
            { "Niu8", Type.Int }, -- 牛8
            { "Niu7", Type.Int }, -- 牛7
            { "Niu6", Type.Int }, -- 牛6
            { "Niu5", Type.Int }, -- 牛5
            { "Niu4", Type.Int }, -- 牛4
            { "Niu3", Type.Int }, -- 牛3
            { "Niu2", Type.Int }, -- 牛2
            { "Niu1", Type.Int }, -- 牛1

            { "TrendInfoList", Type.Array, Type.TypeArray.TrendInfo }

        },
        HandlerFunction = TenThousandHistoryRetCallBack
    }
return SCTenThousandHistoryRet
 