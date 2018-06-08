package com.laixia.majiang.handler;

import cn.laixia.module.cache.redis.IRedisClient;
import cn.laixia.module.cache.redis.RedisFactory;
import cn.laixia.module.cache.redis.RedisKey;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.ClientMsg;
import com.laixia.majiang.common.CCPlayerInfo;
import com.laixia.majiang.common.ResponseResult;
import com.laixia.majiang.common.StatusCode;
import com.laixia.majiang.redisKey.TestRedisKey;
import com.laixia.majiang.utils.HttpUtils;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;
import com.laixia.majiang.vo.sc.SCCreatePoker;
import java.util.Map;


public class CreatePokerInfoHandler extends ClientMsg
{

    private final IRedisClient redis = RedisFactory.getRedisClient();

    @Override
    public void businessProcess(JSONObject msg) throws Exception {
        RedisKey test = TestRedisKey.test.create();

        SCCreatePoker createPoker = new SCCreatePoker();
        TableInstance pokerinfo = new  TableInstance();
        Map<Integer, TablePlayers> map = pokerinfo.getPlayers();
        map = pokerinfo.getPlayers();
        for(Integer key : map.keySet())
        {
            TablePlayers player = map.get(key);
            CCPlayerInfo cinfo = new CCPlayerInfo();
            cinfo.setUid(player.getUid());
            cinfo.setSeat(player.getUserSeat());
            cinfo.setPokerinfo(player.getCards());
            createPoker.addPlayerInfolist(cinfo);
        }
        createPoker.setRoom_id(pokerinfo.getRoomId());
        createPoker.setZhuangid(pokerinfo.getZhuang_Uid());
        createPoker.setPokertype(pokerinfo.getPokertype());
        createPoker.setRoom_id(pokerinfo.getRoomId());
        createPoker.setZhuangval(pokerinfo.getZhuang_Val());
        createPoker.setTable_id(pokerinfo.getTableId());
        createPoker.setSurplusSum(pokerinfo.getCards().size());

        int[] aa = new int[1];
        aa[0] = 53915;
        pokerinfo.setUids(aa);
        HttpUtils.pushMessage(JSONObject.toJSONString(createPoker) ,pokerinfo.getUids(),pokerinfo.getMatchInsId());
        sendResponse(new ResponseResult(StatusCode.SUCCESS,StatusCode.SUCCESS_MSG));
    }

    @Override
    public void logicEndDBOperation() throws Exception {

    }

    public void RandPlayers() 
    {
    	//Map<Integer,TablePlayers> players = new HashMap<>()
   		
    }
}
