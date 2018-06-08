package com.laixia.majiang.redisKey;

import cn.laixia.module.cache.redis.IRedisKey;
import cn.laixia.module.cache.redis.RedisKeyUtil;
import com.laixia.majiang.common.RedisMoudleKey;
import com.laixia.majiang.vo.TableInstance;

import java.util.List;

public class TableKeys {

    //牌桌实体
    public static final IRedisKey tableIns = RedisKeyUtil.delayExpirationKeyDefaltDay(RedisMoudleKey.XUEZHAN, "TABLE_INS",
            1, 1, TableInstance.class);
    //牌桌实体keys集合
    public static final IRedisKey tableSet = RedisKeyUtil.delayExpirationKeyDefaltDay(RedisMoudleKey.XUEZHAN, "TABLE_INS_SET",
            1, 1, List.class);

    //牌桌实体keys集合
    public static final IRedisKey tableThink = RedisKeyUtil.delayExpirationKeyDefaltDay(RedisMoudleKey.XUEZHAN, "TABLE_THINK",
            1, 1, List.class);
}
