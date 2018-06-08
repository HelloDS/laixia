package com.laixia.majiang.redisKey;

import cn.laixia.module.cache.redis.IRedisKey;
import cn.laixia.module.cache.redis.RedisKeyUtil;
import cn.laixia.module.cache.redis.RedisMoudleKey;

public class TestRedisKey {

    public static final IRedisKey test = RedisKeyUtil.delayExpirationKeyDefaltDay(RedisMoudleKey.DDZ, "TABLE_CNT",
            1, 3, int.class);


}
