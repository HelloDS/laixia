--region 牌型类型


-- 牌型类型
local CardType = { --如果没有拍值得话，默认为0
    AUTO_CARD = 0,        --随便出（只是标记，不是牌型）
    SINGLE_CARD = 1, -- 单牌-
    DOUBLE_CARD = 2, -- 对子-
    THREE_CARD = 3,    -- 3不带-
    THREE_ONE_CARD = 4,    -- 3带1-
    THREE_TWO_CARD = 5,    -- 3带2-
    BOMB_TWO_CARD = 6,    -- 四个带2张单牌
    BOMB_TWOOO_CARD = 7,    -- 四个带2对
    CONNECT_CARD = 8,    -- 连牌-
    COMPANY_CARD = 9,    -- 连队-
    AIRCRAFT_CARD = 10,    -- 飞机不带-
    AIRCRAFT_SINGLE_CARD = 11,    -- 飞机带单牌-
    AIRCRAFT_DOBULE_CARD = 12,    -- 飞机带对子-
    SOFT_BOMB_CARD =13,  -- 软炸
    BOMB_CARD = 14,    -- 炸弹
    LAIZI_BOMB_CARD=15, --纯癞子炸弹
    ROCKET_CARD =16,    --火箭（王炸）--
    ERROR_CARD = 99-- 错误的牌型
}
return CardType

--endregion
