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
import com.laixia.majiang.utils.TablesUtils;
import com.laixia.majiang.vo.NetReconnect;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;

/*
   短线重新连接数据获取Handler处理
 */
public class NetReconnectHandler extends ClientMsg
{
    private final IRedisClient redis = RedisFactory.getRedisClient();

    @Override
    public void businessProcess(JSONObject msg) throws Exception {
        String roomId = msg.getString("room_id");
        String tableId = msg.getString("table_id");
        int operation = msg.getInteger("operation");
        TableInstance tableIns = null;
        NetReconnect netrconnect = new NetReconnect(); // 短线连接数据类
        try {
            tableIns = TablesUtils.getTable(roomId, tableId);//获取房间实体
            // 根据id 获取玩家的信息
            TablePlayers player = tableIns.getPlayers().get(Integer.parseInt(uid));
            netrconnect.setPlayers(player);
            netrconnect.setMatchId(tableIns.getMatchId());
            //netrconnect.setNum(tableIns.getNum());
            netrconnect.setTableId(tableIns.getTableId());
            netrconnect.setRoomId(tableIns.getRoomId());
            netrconnect.setCurSeat(tableIns.getCurSeat());
            netrconnect.setTotalNum(tableIns.getTotalNum());
            netrconnect.setPokertype(tableIns.getPokertype());

            sendResponse(new ResponseResult(StatusCode.SUCCESS, StatusCode.SUCCESS_MSG));
        }
        catch (Exception e) {
            }
    }

    @Override
    public void logicEndDBOperation() throws Exception {

    }

    public void RandPlayers() 
    {
    	//Map<Integer,TablePlayers> players = new HashMap<>()
   		
    }
}
