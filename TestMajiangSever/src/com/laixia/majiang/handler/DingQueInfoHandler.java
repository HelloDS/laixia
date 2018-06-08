package com.laixia.majiang.handler;

import cn.laixia.module.cache.redis.IRedisClient;
import cn.laixia.module.cache.redis.RedisFactory;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.ClientMsg;
import com.laixia.majiang.common.CCPlayerDqInfo;
import com.laixia.majiang.utils.TablesUtils;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;
import com.laixia.majiang.vo.sc.SCDingQueInfo;





// 定缺hander处理
public class DingQueInfoHandler extends ClientMsg
{

    private final IRedisClient redis = RedisFactory.getRedisClient();

    @Override
    public void businessProcess(JSONObject msg) throws Exception {
        String roomId = msg.getString("room_id");
        String tableId = msg.getString("table_id");
        int operation = msg.getInteger("changetype");
        TableInstance tableIns = null;
        SCDingQueInfo dqinfo = new SCDingQueInfo();

        try {
            tableIns = TablesUtils.getTable(roomId, tableId);//获取房间实体

            for(Integer key : tableIns.getPlayers().keySet())
            {
                TablePlayers player = tableIns.getPlayers().get(key);
                CCPlayerDqInfo info = new  CCPlayerDqInfo();
                info.setDingquetype(player.getQuedehuase());
                info.setUid(player.getUid());
                dqinfo.addPlayerDqInfo(info);
            }
            dqinfo.setRoom_id(tableIns.getRoomId());
            dqinfo.setTable_id(tableIns.getTableId());

        } catch (Exception e) { }



//        int[] aa = new int[1];
//        aa[0] = 53915;
//        pokerinfo.setUids(aa);
//        HttpUtils.pushMessage(info.toJSONString(),pokerinfo.getUids(),pokerinfo.getMatchInsId());
//        sendResponse(new ResponseResult(StatusCode.SUCCESS,StatusCode.SUCCESS_MSG));
    }

    @Override
    public void logicEndDBOperation() throws Exception {

    }

    public void RandPlayers() 
    {
   		
    }

}
