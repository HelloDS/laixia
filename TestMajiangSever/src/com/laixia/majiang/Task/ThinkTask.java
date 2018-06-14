package com.laixia.majiang.Task;

import cn.laixia.module.cache.redis.IRedisClient;
import cn.laixia.module.cache.redis.RedisFactory;
import cn.laixia.module.cache.redis.RedisKey;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.redisKey.TableKeys;
import com.laixia.majiang.utils.TablesUtils;
import com.laixia.majiang.vo.TableInstance;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class ThinkTask implements Runnable{

    private static ThinkTask thinkTask = new ThinkTask();
    public static ThinkTask getInstance() {
        return thinkTask;
    }
    private static IRedisClient redis = RedisFactory.getRedisClient();
    private static ScheduledExecutorService schedule;
    public void init()
    {
        schedule = Executors.newSingleThreadScheduledExecutor();
        schedule.scheduleWithFixedDelay(this, 200,200, TimeUnit.MILLISECONDS);
    }

    // 开启线程检测超时
    @Override
    public void run()
    {
        RedisKey thinkIng = TableKeys.tableThink.create();
        Object obj = redis.rget(thinkIng);
        if(obj != null)
        {
            JSONObject jsonObject = JSONObject.parseObject(obj.toString());
            long time = System.currentTimeMillis()/1000;
            if((time - jsonObject.getLong("time")) > 15)
            {
                TableInstance table = TablesUtils.getTable(jsonObject.getString("roomId"),jsonObject.getString("tableId"));
                //TablesUtils.mopai(table,false);
            }
            else
            {
                redis.lpush(thinkIng,jsonObject);
            }
        }
    }
}
