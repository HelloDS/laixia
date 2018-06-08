package com.laixia.majiang.handler;

import cn.laixia.module.cache.redis.IRedisClient;
import cn.laixia.module.cache.redis.RedisFactory;
import cn.laixia.module.cache.redis.RedisKey;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.ClientMsg;
import com.laixia.majiang.common.ResponseResult;
import com.laixia.majiang.common.StatusCode;
import com.laixia.majiang.redisKey.TestRedisKey;
import com.laixia.majiang.utils.HttpUtils;
import com.laixia.majiang.vo.TableInstance;

public class TestHandler extends ClientMsg {

    private final IRedisClient redis = RedisFactory.getRedisClient();
    @Override
    public void businessProcess(JSONObject msg) throws Exception {
        RedisKey test = TestRedisKey.test.create();

        JSONObject info = new JSONObject();

        info.put("table_id",10001);
        info.put("room_id",10001);
        info.put("pokertype", 2 );
        info.put("tp","get_card");
        info.put("uid",10003);
        info.put("card",1);

        TableInstance pokerinfo = new  TableInstance();
        int[] aa = new int[1];
        aa[0] = 53915;
        pokerinfo.setUids(aa);
        HttpUtils.pushMessage(info.toJSONString(),pokerinfo.getUids(),pokerinfo.getMatchInsId());
        sendResponse(new ResponseResult(StatusCode.SUCCESS,StatusCode.SUCCESS_MSG));
    }

    @Override
    public void logicEndDBOperation() throws Exception {

    }
}
