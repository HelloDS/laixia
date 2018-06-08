package com.laixia.majiang.handler;

import cn.laixia.module.cache.redis.IRedisClient;
import cn.laixia.module.cache.redis.RedisFactory;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.ClientMsg;
import com.laixia.majiang.utils.TablesUtils;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class ChangeMJInfoHandler extends ClientMsg
{

    private final IRedisClient redis = RedisFactory.getRedisClient();

    // 顺序保存所有得换牌数据
    private List<Integer> All_ls = new ArrayList<>();

    // 记住牌桌里面得map
    Map<Integer, TablePlayers> map ;

    @Override
    public void businessProcess(JSONObject msg) throws Exception {
        String roomId = msg.getString("room_id");
        String tableId = msg.getString("table_id");
        int operation = msg.getInteger("changetype");
        TableInstance tableIns = null;
        try {
            tableIns = TablesUtils.getTable(roomId, tableId);//获取房间实体

            int glarr[];
            map = tableIns.getPlayers();
            for(Integer key : map.keySet())
            {
                TablePlayers player = map.get(key);
                All_ls.addAll(player.getChangeCards());
            }
            if(operation == 1) // 顺时针
            {
                int arr[] = {2,3,4,1};
                glarr = arr;
            }
            else if(operation == 2){ // 逆时针
                int arr[] = {4,1,2,3};
                glarr = arr;
            }
            else// 对家换
            {
                int arr[] = {3,4,1,2};
                glarr = arr;
            }
            int num = 0;
            for(Integer key : map.keySet())
            {
                TablePlayers player = map.get(key);
                player.addChangeCards( this.GetLinSeat( glarr[num] )  );
                num++;
            }
            All_ls.clear();
        } catch (Exception e) { }
        tableIns.setPlayers(map);


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

    // 根据方位获取一个玩家得换牌
    private List<Integer> GetLinSeat( int seat ){
        if (seat <=0 && seat >4){
            return null;
        }
        int num = seat * 3;
        List<Integer> li = new ArrayList<>();
        for(int j = num - 3; j < num; j++)
        {
            li.add(All_ls.get(j));
        }
        return li;
    }
}
