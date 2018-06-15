--自定义数据类型
local CDataTypeObj = { };
CDataTypeObj.Int = 0
CDataTypeObj.Byte = 1
CDataTypeObj.Short = 2
CDataTypeObj.Float = 3
CDataTypeObj.Double = 4
CDataTypeObj.LuaNumber = 5   -- 代替long 吧
CDataTypeObj.UTF8 = 6
CDataTypeObj.TypeArrayType = 7
CDataTypeObj.Array = 8
CDataTypeObj.ByteArray = 9

CDataTypeObj.Default =
    {
        [CDataTypeObj.Int] = 0,
        [CDataTypeObj.Byte] = 0,
        [CDataTypeObj.Short] = 0,
        [CDataTypeObj.Float] = 0.0,
        [CDataTypeObj.Double] = 0.0,
        [CDataTypeObj.LuaNumber] = 0,
        [CDataTypeObj.UTF8] = "",
        [CDataTypeObj.TypeArrayType] = { },
        [CDataTypeObj.Array] = { },
        [CDataTypeObj.ByteArray] = "",
    }

CDataTypeObj.TypeArray = { };
local TypeArray = CDataTypeObj.TypeArray;

-- 说明，用这种结构，而不是直接

-- 是出于方便序列化的理由，这样子是顺序下来的
-- 以后会不会改掉，看情况


TypeArray.Card =
    {
        {"CardValue",CDataTypeObj.Int},
    }

TypeArray.ClearCard =
    {
        {"ClearPokers",CDataTypeObj.Array,TypeArray.Card},
        {"Seat",CDataTypeObj.Byte},

    }

TypeArray.Task =
    {
        {"TypeId",CDataTypeObj.Short}, --任务类型
        {"TaskID",CDataTypeObj.Short}, --任务ID
        {"Num",CDataTypeObj.Int}, --任务完成度
    }

TypeArray.RoomList =   --房间列表   ****
    {
        {"RoomID",CDataTypeObj.Byte}, --房间ID
        {"Cound",CDataTypeObj.Int},--指定局数奖励
        {"ItemId",CDataTypeObj.Int},--奖励物品Id
        {"ItemCount",CDataTypeObj.Int}, --奖励物品数量
        {"OnlineNumber",CDataTypeObj.Int},--在线人数
        ------------------------------------------------------------
        {"BaseScore",CDataTypeObj.Int},--底分
        {"MinGold",CDataTypeObj.Int},--最小携带
        {"MaxGold",CDataTypeObj.Int},--房间上限
        {"JpqID",CDataTypeObj.Int},--记牌器ID
        {"RoomName",CDataTypeObj.UTF8},--房间名称
------------------------------------------------------------
}

--个人账单
TypeArray.PersonBills = 
{
    {"Time",CDataTypeObj.UTF8}, -- 时间
    {"Num",CDataTypeObj.UTF8},
    {"RoomID",CDataTypeObj.UTF8}, --房间ID
}



TypeArray.BureauEndInfo =
    {
        {"PlayerID",CDataTypeObj.Int},
        {"AllFen",CDataTypeObj.Int},
        {"Bureaus",CDataTypeObj.Array, CDataTypeObj.Int }
    }
TypeArray.RewardVo=
    {
        {"ID",CDataTypeObj.Int},
        {"Num",CDataTypeObj.Int},
    }

TypeArray.OptionReward=
    {
        {"Rewards",CDataTypeObj.Array,TypeArray.RewardVo},
    }

TypeArray.SubNetMsg =
    {
        {"OpID",CDataTypeObj.Int},           --房间类型号
        {"Cost",CDataTypeObj.Int},           --消耗金币
        {"ItemID",CDataTypeObj.Int},         --创建需要消耗的物品
        {"ItemCost",CDataTypeObj.Int},       --消耗物品的数量
        {"ItemInn",CDataTypeObj.Int},        --对应的局数
        {"difen",CDataTypeObj.Int},  		--底分数
        {"Rewards",CDataTypeObj.Array,TypeArray.OptionReward} --对应奖励
    }
TypeArray.SelfBuilRooms =   --自建房房间列表   ****
    {
        {"RoomType",CDataTypeObj.Byte}, --房间   0 欢乐场，1癞子场，5经典场
        {"RoomName",CDataTypeObj.UTF8},  --房间名
        {"Options",CDataTypeObj.Array,TypeArray.SubNetMsg} --条件
}
TypeArray.SelfBuilPlayers =   --自建房玩家消息
    {
        {"Pid",CDataTypeObj.Int}, --玩家id
        {"Nickname",CDataTypeObj.UTF8},  --玩家昵称
        {"Icon",CDataTypeObj.UTF8},         --头像
        {"Seat",CDataTypeObj.Byte},         --座位号
        {"Coin",CDataTypeObj.Double},          --金币数量
        {"Sex",CDataTypeObj.Byte},         --性别
        {"IsReady",CDataTypeObj.Byte},         --0表示正常 1表示准备
}

TypeArray.CardArray = --底牌***
    {
        {"Poker_1",CDataTypeObj.Byte},
}

TypeArray.CSBalance= --结算***
    {
        {"PID",CDataTypeObj.Int},
        {"Inning",CDataTypeObj.Int},        --机器人用？
        {"Chip",CDataTypeObj.Double},          --变化数量
        {"CurrentGold",CDataTypeObj.Double},   --当前玩家剩余金数量
}
--房间基本信息
TypeArray.RoomInfo = --房间信息
    {
        {"RoomID",CDataTypeObj.Byte},   --房间ID
        {"Name",CDataTypeObj.UTF8},     --房间标题
        {"MinCoin",CDataTypeObj.Int},   --进入房间下限金数
        {"MaxCoin",CDataTypeObj.Int},   --进入房间上限金数
}

TypeArray.Attribute=    --属性****
    {

        {"value",CDataTypeObj.Double},
        {"attType",CDataTypeObj.Short},

}

TypeArray.BottomCards =  --地主底牌（3张）&&&&
    {
        {"Card_1",CDataTypeObj.Int},

}

TypeArray.Players =  --牌桌同步玩家信息
    {
        {"PID",CDataTypeObj.Int},           --玩家id
        {"Nickname",CDataTypeObj.UTF8},     --昵称
        {"Icon",CDataTypeObj.UTF8},         --头像
        {"Seat",CDataTypeObj.Byte},         --座位号
        {"Coin",CDataTypeObj.Double},       --金币
        {"Trust",CDataTypeObj.Byte},        --1托管0非托管
        {"Sex",CDataTypeObj.Byte},          --性别
        {"PlayerCards",CDataTypeObj.Array,TypeArray.Card},      --手牌牌值
        {"MaxCard",CDataTypeObj.Byte},      --手牌数
        {"PlayCards",CDataTypeObj.Array,TypeArray.Card},         --所有玩家已经出的牌（只有自己有值）
        {"ReplaceCardss",CDataTypeObj.Array,TypeArray.Card},      --癞子 --被替换的牌值
        {"Inning",CDataTypeObj.Int},        --房间内进行N局游戏
        {"CardCountTime",CDataTypeObj.Double},              --记牌器时间（只用自己的值） 0 没有； -1 短线重连时候当局有效； >0 时效记牌器
        {"DeskCards",CDataTypeObj.Array,TypeArray.Card},        --当前回合出牌牌值

}

TypeArray.RelinkSyncPlayer = --重新连接玩家基本信息
    {
        {"isTrust",CDataTypeObj.Byte},          --是否托管
        {"PlayerCards",CDataTypeObj.Array,TypeArray.Card},  --玩家手牌值
        {"CardNum",CDataTypeObj.Byte},          --当前手牌数
        {"ReplaceCardss",CDataTypeObj.Array,TypeArray.Card},  --被替换的牌值 -- 癞子
        {"PlayerPlayCards",CDataTypeObj.Array,TypeArray.Card},  --当前出牌牌值
        {"Seat",CDataTypeObj.Byte},
}

TypeArray.Color =
    {
        {"color1",CDataTypeObj.Int},
        {"color2",CDataTypeObj.Int},
        {"color3",CDataTypeObj.Int},
    }

TypeArray.Rds =  -- 参加比赛第一名奖励
    {
        {"ItemId",CDataTypeObj.Int},
        {"ItemCT",CDataTypeObj.Int},
}

TypeArray.MatchRoom =
    {
        { "RoomType", CDataTypeObj.Byte },-- 房间类型，1人满开始，0 定时开赛
        { "Sate", CDataTypeObj.Byte },-- 当前状态，1报名前，2报名中，3报名结束
        { "SelfJoin", CDataTypeObj.Byte },-- 自己是否报名比赛 1，是0 否
        { "RoomID", CDataTypeObj.Int },-- 房间ID
        { "CurJoinNum", CDataTypeObj.Int },-- 当前报名人数
        { "JoinMinLimit",CDataTypeObj.Int}, --最少开赛人数限制
        { "Time", CDataTypeObj.Int },-- 比赛开始时间
        { "RoomName", CDataTypeObj.UTF8 },-- 房间名称
        { "Icon",CDataTypeObj.UTF8},--图标
        { "BaomingInfo",CDataTypeObj.UTF8},     --报名信息 ---冠军奖励
        {"BeginTime",CDataTypeObj.UTF8},
        {"EndTime",CDataTypeObj.UTF8},
        {"Baomingfei",CDataTypeObj.UTF8},
        {"JoinTimes",CDataTypeObj.Int},
        {"isTop",CDataTypeObj.Int},
    }

TypeArray.PageTypeMessage =  -- 比赛房间列表数据
    {
        {"PageType",CDataTypeObj.Byte}, --页签类型1代表
        {"Sort",CDataTypeObj.Byte},  --
        {"PageName",CDataTypeObj.UTF8}, --页签名称
        {"rooms",CDataTypeObj.Array,TypeArray.MatchRoom}  --房间列表
}


TypeArray.Cost =  -- 参加比赛消耗
    {
        {"ItemID",CDataTypeObj.Int}, --道具配置ID
        {"Count",CDataTypeObj.Int}, --道具个数
        {"Efftm",CDataTypeObj.Double}, --有效期
        {"ItemObjID",CDataTypeObj.Double}, --道具objid

}

TypeArray.DetailInfoPair =
    {
        {"ID",CDataTypeObj.Int},  --11003经验，11004 等级
        {"Num",CDataTypeObj.Int}, --数值
    }

TypeArray.MatchRankRd =
    {
        { "RankStart", CDataTypeObj.Int },-- 排名开始值
        { "RankEnd", CDataTypeObj.Int },-- 排名结束值
        { "Reward", CDataTypeObj.Array, TypeArray.DetailInfoPair },-- 奖励
        { "des", CDataTypeObj.UTF8},
        { "rank_des",CDataTypeObj.UTF8},
    }


TypeArray.ReturnITem =
    {
        { "ItemID", CDataTypeObj.Int },
        { "Count", CDataTypeObj.Int },
        { "ItemOBjID", CDataTypeObj.Double },
        { "Efftm", CDataTypeObj.Double },
    }


TypeArray.MatchRanks =
    {
        { "PlayerID", CDataTypeObj.Int },
        { "NickName", CDataTypeObj.UTF8 },
        { "Coin", CDataTypeObj.Int },

    }


-----------------------------------------------------------------------------------------------------------------



TypeArray.Rank =
    {
        {"UserID",CDataTypeObj.Int},
        {"Level",CDataTypeObj.Int}, --等级
        {"Win",CDataTypeObj.Int}, --赢局数
        {"Loss",CDataTypeObj.Int}, --输局数
        {"Coin",CDataTypeObj.Double},--金数量
        {"Sex",CDataTypeObj.Byte},
        {"NickName",CDataTypeObj.UTF8},
        {"imgPath",CDataTypeObj.UTF8},
        {"Signature",CDataTypeObj.UTF8}, --个性签名

    }
TypeArray.Letter =
    {
        {"sendTime",CDataTypeObj.Int}, --发送时间
        {"Context",CDataTypeObj.UTF8},--发送的文本
    }


TypeArray.ItemsForResurrection =
    {
        {"ItemID",CDataTypeObj.Int}, --道具配置ID
        {"ItemCount",CDataTypeObj.Int}, --道具个数
    }

TypeArray.Items =
    {
        {"ItemID",CDataTypeObj.Int}, --道具配置ID
        {"ItemCount",CDataTypeObj.Int}, --道具个数
        {"ItemObjectID",CDataTypeObj.Double}, --道具objID
        {"EffTime",CDataTypeObj.Double},  --道具有效时间
    }


TypeArray.RewardArray =
    {
        {"ItemID",CDataTypeObj.Int},
        {"ItemCount",CDataTypeObj.Int},
    }

TypeArray.SignInTabel =
    {
        {"Day",CDataTypeObj.Int},
        {"RewardArray",CDataTypeObj.Array,TypeArray.RewardArray},

    }


TypeArray.ShopItems =
    {
        {"ItemID",CDataTypeObj.Int},      --道具ID
        {"Price",CDataTypeObj.Float},     --道具价格
        {"ItemDesc",CDataTypeObj.UTF8},   --道具描述
        {"StartTm",CDataTypeObj.Double},  --开始时间
        {"EndTm",CDataTypeObj.Double},    --结束时间
        {"PayCode",CDataTypeObj.UTF8},
        {"PayID",CDataTypeObj.Int},
        {"hot",CDataTypeObj.Byte},  --默认是0 ，当为1的时候表示热销
        {"Recharge",CDataTypeObj.Byte},  --是否购买过 0没有，1已购买
    }
TypeArray.ShowItem =
    {
        {"ItemID",CDataTypeObj.Int},    --道具ID
        {"ItemCount",CDataTypeObj.Int},--道具个数
        {"ItemObjID",CDataTypeObj.Double},  --道具objID
        {"EffTM",CDataTypeObj.Double},--道具有效时间


    }
TypeArray.ShowExchange =
    {
        {"ItemID",CDataTypeObj.Int},          --物品id
        {"ItemCount",CDataTypeObj.Int},       --兑换需要奖券
        {"DetailAddr",CDataTypeObj.Byte},     --是否需要地址
        {"ItemNum",CDataTypeObj.Short},       --道具库存
    }

--领取物品
TypeArray.ResultItem =
    {
        {"ItemID",CDataTypeObj.Int}, --道具id
        {"ItemCount",CDataTypeObj.Int},--道具数量
        {"ItemObjectID",CDataTypeObj.Double},-- 物品objid
        {"EffTime",CDataTypeObj.Double},--失效时间
    }


--龙虎斗排行榜
TypeArray.LHDRankers =
    {
        {"pid" , CDataTypeObj.Int},
        {"winGold" , CDataTypeObj.Int},
        {"nickname" , CDataTypeObj.UTF8}
    }
TypeArray.BetConfigPerRoundMode =
    {
        {"id" , CDataTypeObj.Int},
        {"minBring" , CDataTypeObj.Int},
        {"maxBring" , CDataTypeObj.Int},
        {"rate" , CDataTypeObj.UTF8},
    }

TypeArray.DefaultChipListMode =
    {
        {"id" , CDataTypeObj.Int},
        {"defautChip" , CDataTypeObj.Int},
        {"minBring" , CDataTypeObj.Int},
        {"maxBring" , CDataTypeObj.Int},
    }

TypeArray.TurnTableRewards =
    {
        {"ID",CDataTypeObj.Int},
        {"ItemID",CDataTypeObj.Int},
        {"Num",CDataTypeObj.Int},
        {"Name",CDataTypeObj.UTF8},
    }

TypeArray.TurnTableInfo =
    {
        {"Type",CDataTypeObj.Int},     -- 大转盘类型
        {"Index",CDataTypeObj.Int},       -- 大转盘索引
        {"ItemID",CDataTypeObj.Int},
        {"Num",CDataTypeObj.Int},


    }
-----------------------------------------------------------
--万人牛牛
TypeArray.TrendInfo  =
    {
        {"ResultOne",CDataTypeObj.Byte},           -- 1 号位置结果 -- -1表示失败 0 表示平，1表示 获胜 -- 从庄家的视角
        {"ResultTwo",CDataTypeObj.Byte},           -- 2 号位置结果 -- -1表示失败 0 表示平，1表示 获胜 -- 从庄家的视角
        {"ResultThree",CDataTypeObj.Byte},         -- 3 号位置结果 -- -1表示失败 0 表示平，1表示 获胜 -- 从庄家的视角
        {"ResultFour",CDataTypeObj.Byte},          -- 4 号位置结果 -- -1表示失败 0 表示平，1表示 获胜 -- 从庄家的视角


        {"TypeOne",CDataTypeObj.Int},              -- 1 号位置类型牛几
        {"TypeTwo",CDataTypeObj.Int},              -- 2 号位置类型牛几
        {"TypeThree",CDataTypeObj.Int},            -- 3 号位置类型牛几
        {"TypeFour",CDataTypeObj.Int},             -- 4 号位置类型牛几
        {"BankerType",CDataTypeObj.Int},           -- 庄家位置类型牛几
    }
-------------------------------------------------------
-- 水果机
TypeArray.FruitStrand =
    {
        {"FruitIndex",     CDataTypeObj.Int},   --编号
        {"FruitType",      CDataTypeObj.Int},   --类型
        {"Multiple",       CDataTypeObj.Int},   --倍数
    }

-- 下注--或者结算的时候获得的
TypeArray.FruitBet =
    {
        {"FruitType",   CDataTypeObj.Int},  --水果类型
        {"BetPool",     CDataTypeObj.Int},  --该水果筹码
    }

-- 默认下注额
TypeArray.DefBet  =
    {
        {"minBet",     CDataTypeObj.Int},
        {"maxBet",    CDataTypeObj.Int},
        {"bet",     CDataTypeObj.Int},
    }

-- 上次赢家
TypeArray.FruitWinner =
    {
        {"winChips",CDataTypeObj.Int},
        {"name",    CDataTypeObj.UTF8},
    }

-- 三张牌玩家信息
TypeArray.MckitPlayerInfo  =
    {
        {"pId", CDataTypeObj.Int},                                  --玩家ID
        {"vipLevel", CDataTypeObj.Int},                             --Vip等级
        {"seatId", CDataTypeObj.Byte},                              --座位号
        {"actionState", CDataTypeObj.Byte},                         --操作状态
        {"cardState", CDataTypeObj.Byte},                           -- 牌状态 0 暗牌1 明牌3 比牌输4 比牌赢5 弃牌
        {"playerState", CDataTypeObj.Byte},                         -- 玩家状态 0空闲；1 游戏中；2 旁观；3 托管；4 断线
        {"playerSex", CDataTypeObj.Byte},                           --性别
        {"isReadCards", CDataTypeObj.Byte},                         -- 是否已经看牌
        {"betChipNum", CDataTypeObj.Double},                        -- 已下筹码
        {"coin", CDataTypeObj.Double},                              -- 玩家金币
        {"nickName", CDataTypeObj.UTF8},                            -- 玩家昵称
        {"photo", CDataTypeObj.UTF8},                               -- 玩家头像
        {"betHistory", CDataTypeObj.Array, CDataTypeObj.Int},       -- 自己每次下注，历史
    }

-- 多人三张牌pk数组定义
TypeArray.TCPKItem  = {
    {"tarSeat",         CDataTypeObj.Byte},                     -- pk目标玩家座位
    {"winSeat",         CDataTypeObj.Byte},                     -- pk赢家玩家座位
}
--新增活动数据包Array类型
TypeArray.ActivityItems =
    {
        {"activityName" , CDataTypeObj.UTF8},
        {"beginTime", CDataTypeObj.Int},
        {"endTime", CDataTypeObj.Int},
        {"isXianshi" , CDataTypeObj.Byte},
--      {"image_url",CDataTypeObj.UTF8},  -- 活动图路径
--      {"turn_url",CDataTypeObj.UTF8},  -- 轮播图路径
    }

TypeArray.AppleDissUserSet =
{
    {"playerId", CDataTypeObj.Int},
    {"status", CDataTypeObj.Int},
}

TypeArray.TaskItems = 
{
    {"taskID",CDataTypeObj.Int},
    {"taskName",CDataTypeObj.UTF8},
    {"beginTime",CDataTypeObj.Double},
    {"endTime",CDataTypeObj.Double},
    {"missionNum",CDataTypeObj.UTF8},--任务
    {"curNum",CDataTypeObj.UTF8},
    {"rewardGoods",CDataTypeObj.UTF8},
    {"taskGoods",CDataTypeObj.UTF8},
    {"maxToday",CDataTypeObj.Int},--今天最大次数
    {"curToday",CDataTypeObj.Int},--今天当前次数
}

return CDataTypeObj

