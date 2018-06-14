package com.laixia.majiang.handler;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.ClientMsg;
import com.laixia.majiang.common.MahjongOp;
import com.laixia.majiang.common.ResponseResult;
import com.laixia.majiang.common.StatusCode;
import com.laixia.majiang.utils.ClassUtils;
import com.laixia.majiang.utils.HttpUtils;
import com.laixia.majiang.utils.StringUtils;
import com.laixia.majiang.utils.TablesUtils;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;
import com.laixia.majiang.vo.sc.SCPlayCard;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.List;

/**
 * 操作接口
 */
public class OperationHandler extends ClientMsg
{
    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());
    @Override
    public void businessProcess(JSONObject msg)
    {
        String roomId = msg.getString("room_id");
        String tableId = msg.getString("table_id");
        int operation = msg.getInteger("operation");
        String uid = msg.getString("uid");
        TableInstance tableIns = null;
        try {
            tableIns = TablesUtils.getTable(roomId, tableId);//获取房间实体
            TablePlayers player = tableIns.getPlayers().get(Integer.parseInt(uid));
//            if(operation != MahjongOp.dingque)//定缺不看位置是否正确
//            {
//                if (tableIns.getCurSeat() != player.getUserSeat())
//                {
//                    logger.error("当前操作位置不正确，应该" + tableIns.getCurSeat() + "。不是:" +player.getUserSeat());
//                    sendResponse(new ResponseResult(StatusCode.FAILURE, StatusCode.FAILURE_MSG));
//                    return;
//                }
//            }
            JSONArray cards = msg.getJSONArray("card");
            if (operation == MahjongOp.chupai || operation == MahjongOp.huitougang || operation == MahjongOp.angang ||
                    operation == MahjongOp.minggang || operation == MahjongOp.peng || operation == MahjongOp.dingque ||
                    operation == MahjongOp.huansaizhang)
            {
                SCPlayCard scPlayCard = new SCPlayCard();
                scPlayCard.setOperation(operation);
                scPlayCard.setUid(uid);
                scPlayCard.setCard(StringUtils.jsonAryToAry(cards));
                scPlayCard.setRoom_id(roomId);
                scPlayCard.setTable_id(tableId);
                // 通知全部玩家当前得操作
                HttpUtils.pushMessage(JSONObject.toJSONString(scPlayCard), tableIns.getUids(), tableIns.getMatchInsId());
                TablesUtils.doIt(tableIns,operation,cards,uid);
            }
            if (operation == MahjongOp.chupai)
            {//2出牌
                player.getCards().remove((Integer) cards.get(0));
                player.getOutCards().add((Integer) cards.get(0));
                if(player.getUserSeat() == tableIns.getZhunagSeat())
                {
                    tableIns.setZhuangNum(1);
                }
                TablesUtils.checkThinking((Integer) cards.get(0), tableIns,0);//判断是否需要Thinking
            }
            if (operation == MahjongOp.peng)
            {
                player.getCards().remove((Integer) cards.get(0));
                player.getCards().remove((Integer) cards.get(0));
                player.getPeng().add((Integer) cards.get(0));
                TablesUtils.checkThinking((Integer) cards.get(0), tableIns,1);//判断是否需要Thinking
            }
            if (operation == MahjongOp.angang || operation == MahjongOp.huitougang)
            {
                for (int j = 0; j < 4 ;j++){
                    player.getCards().remove((Integer) cards.get(0));
                }
                player.getGang().add((Integer) cards.get(0));
                TablesUtils.checkThinking((Integer) cards.get(0), tableIns,1);//判断是否需要Thinking
            }
            if (operation == MahjongOp.minggang)
            {
                for (int j = 0; j < 3 ;j++){
                    player.getCards().remove((Integer) cards.get(0));
                }
                player.getGang().add((Integer) cards.get(0));
                TablesUtils.checkThinking((Integer) cards.get(0), tableIns,1);//判断是否需要Thinking
            }


            if(operation == MahjongOp.dingque)//定缺
            {
                player.setQuedehuase((Integer) cards.get(0));
            }
            if(operation == MahjongOp.huansaizhang)//换三张
            {
                JSONArray changemjArr = msg.getJSONArray("huansaizhang");
                List<Integer> li = new ArrayList();
                for(int i=0;i< changemjArr.size();i++)
                {
                    JSONObject job = changemjArr.getJSONObject(i);
                    li.add(job.getInteger("huansaizhang"));
                }
                if(li.size() >= 3)
                {
                    player.setChangeCards(li);
                }
                else
                {
                    // .....
                }
            }
            //sendResponse(new ResponseResult(StatusCode.SUCCESS, StatusCode.SUCCESS_MSG));
        }
        catch (Exception e) {
            e.printStackTrace();
            logger.error(e);
        }
        finally {
            if (tableIns != null) {
                TablesUtils.setTable(roomId, tableId, tableIns);
            }
        }
    }

    @Override
    public void logicEndDBOperation() throws Exception {
    }
}
