package com.laixia.majiang.handler;

import cn.laixia.module.cache.redis.IRedisClient;
import cn.laixia.module.cache.redis.RedisFactory;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.ClientMsg;
import com.laixia.majiang.common.CCPlayerInfo;
import com.laixia.majiang.utils.HttpUtils;
import com.laixia.majiang.utils.TablesUtils;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;
import com.laixia.majiang.vo.sc.SCCreatePoker;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;


public class ChangeMJInfoHandler extends ClientMsg {

    private final IRedisClient redis = RedisFactory.getRedisClient();

    // 记住牌桌里面得map
    Map<Integer, TablePlayers> map;

    @Override
    public void businessProcess(JSONObject msg) throws Exception {
        String roomId = msg.getString("room_id");
        String tableId = msg.getString("table_id");

        Random r = new Random();
        int id = r.nextInt(3) + 1;
        int operation = id;
        TableInstance tableIns = null;
        try {
            tableIns = TablesUtils.getTable(roomId, tableId);//获取房间实体

            int glarr[];
            map = tableIns.getPlayers();
            for (Integer key : map.keySet()) {
                TablePlayers player = map.get(key);
            }
            if (operation == 1) // 顺时针
            {
                int arr[] = {2, 3, 4, 1};
                glarr = arr;
            } else if (operation == 2) { // 逆时针
                int arr[] = {4, 1, 2, 3};
                glarr = arr;
            } else// 对家换
            {
                int arr[] = {3, 4, 1, 2};
                glarr = arr;
            }
            int num = 0;
            for (Integer key : map.keySet())
            {
                TablePlayers player = map.get(key);
                player.addChangeCards(this.GetLinSeat(glarr[num]));
                num++;
            }
        } catch (Exception e) {

        }
        tableIns.setPlayers(map);


        // 这里是换牌插入完毕后  将牌又发送到前端 tp 参数不一样暂时没写
        SCCreatePoker createPoker = new SCCreatePoker();
        TableInstance pokerinfo = tableIns;
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
        createPoker.setPokertype(pokerinfo.getPokertype());
        createPoker.setRoom_id(pokerinfo.getRoomId());
        createPoker.setZhuangval(pokerinfo.getZhuang_Val());
        createPoker.setTable_id(pokerinfo.getTableId());
        createPoker.setTp("changemjinfo");



        int[] aa = new int[1];
        aa[0] = 53915;
//        pokerinfo.setUids(aa);
       // HttpUtils.pushMessage(All_ls.toJSONString(),aa,"");
    //    sendResponse(new ResponseResult(StatusCode.SUCCESS,StatusCode.SUCCESS_MSG));
        HttpUtils.pushMessagecl(JSONObject.toJSONString(createPoker) ,pokerinfo.getUids(),pokerinfo.getMatchInsId());
    }

    @Override
    public void logicEndDBOperation() throws Exception {

    }

    public void RandPlayers() {

    }

    // 根据方位获取一个玩家得换牌
    private List<Integer> GetLinSeat(int seat) {

        if (seat <= 0 && seat > 4) {
            return null;
        }
        List<Integer> lt = new ArrayList<>();
        for (Integer key : map.keySet())
        {
            TablePlayers player = map.get(key);
            if(player.getUserSeat() == seat)
            {
                lt =  player.getChangeCards();
                break;
            }
        }
        return lt;
    }
}
