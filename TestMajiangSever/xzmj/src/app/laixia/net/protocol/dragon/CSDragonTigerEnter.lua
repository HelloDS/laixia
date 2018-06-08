-- 进入龙虎斗游戏申请

local Type = import("...DataType")
-- 进入对应游戏逻辑
laixia.LocalPlayercfg.LHD =
    {
        state = 1,
        restTime = 0,
        arrTotalChips = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 0, [11] = 0 },
        detayArrTotalChips = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 0, [11] = 0 },
        arrMyChips = { },
        remain = 0,
        banker = "",
        details = "",
        Cards = 1234,
        selfWinGold = 0,
        bankerWinGold = 0,
        winRanks = { },
        nResult = 0,
        myAddType = 0,
        myAddChip = 1000,
        arrHistoryDetails = { },
        isRepeat = false,
        repeatBats =
        {
            [0] = 0,
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0,
            [8] = 0,
            [9] = 0,
            [10] = 0
        },
        lastRepeatBats =
        {
            [0] = 0,
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0,
            [8] = 0,
            [9] = 0,
            [10] = 0
        },
        arrWinDetails =
        {
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0,
            [8] = 0,
            [9] = 0,
            [10] = 0,
            [11] = 0
        },
        arrTime = { [1] = 0, [2] = 0, [3] = 0 },
        arrChip = { [1] = 1000, [2] = 10000, [3] = 100000, [4] = 500000, [5] = 1000000 },
        rate = { [1] = "0", [2] = "0", [3] = "0", [4] = "0", [5] = "0", [6] = "0", [7] = "0", [8] = "0", [9] = "0", [10] = "0", [11] = "0" },
        fSysChargeRate = 0.0,
        bFirstTime = 0,
        BetConfigPerRound = { },
        DefaultChipList = { },
        m_IsTriggerGuide = false,
        iPlayerMinChip = 999999,
        listBetMax =
        {
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0,
            [8] = 0,
            [9] = 0,
            [10] = 0,
            [11] = 0
        },
    }
local CSDragonTigerEnter =
    {
        ID = _LAIXIA_PACKET_CS_DragonTigerEnterID,

        name = "CSDragonTigerEnter",
        data_array =
        {

        }
    }

return CSDragonTigerEnter