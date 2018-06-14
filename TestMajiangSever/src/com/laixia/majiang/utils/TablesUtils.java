package com.laixia.majiang.utils;

import cn.laixia.module.cache.redis.IRedisClient;
import cn.laixia.module.cache.redis.RedisFactory;
import cn.laixia.module.cache.redis.RedisKey;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.common.HuOp;
import com.laixia.majiang.common.MahjongOp;
import com.laixia.majiang.redisKey.TableKeys;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;
import com.laixia.majiang.vo.sc.SCGetCard;
import com.laixia.majiang.vo.sc.SCThinking;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class TablesUtils {

    private static IRedisClient redis = RedisFactory.getRedisClient();
    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    public static TableInstance getTable(String roomId, String tableId) {
        RedisKey table = TableKeys.tableIns.create(roomId, tableId);
        TableInstance tableIns = redis.get(table);
        return tableIns;
    }

    public static void setTable(String roomId, String tableId, TableInstance tableIns) {
        RedisKey table = TableKeys.tableIns.create(roomId, tableId);
        redis.set(table, tableIns);//存入实体
        RedisKey tableSet = TableKeys.tableSet.create();
        redis.set(tableSet, table.toString());//存入集合
    }

    /**
     * 判断思考
     *
     * @param card
     * @param tableIns
     * @param type     0 出牌 1 摸牌
     */
    public static void checkThinking(int card, TableInstance tableIns, int type) {
        boolean isThinking = false;
        SCThinking scThinking = new SCThinking();
        scThinking.setRoom_id(tableIns.getRoomId());
        scThinking.setTable_id(tableIns.getTableId());
        List<Integer> op = new ArrayList<>();
        scThinking.setCard(card);
        for (int i = 0; i < tableIns.getTotalNum(); i++) {
            int uid = tableIns.getUids()[i];
            TablePlayers player = tableIns.getPlayers().get(uid);
            scThinking.setUid(String.valueOf(uid));
            List<Integer> newLst = new ArrayList<>();//手牌
            newLst.addAll(player.getCards());
            newLst.add(card);
            List<Integer> newChiLst = new ArrayList<>();//吃的牌
            newChiLst.addAll(player.getOutCards());
            newChiLst.add(card);
            if (tableIns.getCurSeat() == i && type == 1) {//摸牌 并且当前位置等于自己 判断自摸 杠等操作
//                if(IsCanHU(newLst,card)){
//                    isThinking = true;
//                    op.add(MahjongOp.hu);
//                }
                if (checkGangOrPeng(newLst, 4)) {//可以杠
                    isThinking = true;
                    op.add(MahjongOp.angang);
                }
                if (checkGangOrPeng(newChiLst, 4)) {//回头杠
                    isThinking = true;
                    op.add(MahjongOp.huitougang);
                }
            } else {
                if (checkPeng(newLst, card)) {//可以碰
                    isThinking = true;
                    op.add(MahjongOp.peng);
                }
                if (checkGangOrPeng(newLst, 4)) {//可以杠
                    isThinking = true;
                    op.add(MahjongOp.minggang);
                }
//                if(IsCanHU(newLst,card)){
//                    isThinking = true;
//                    op.add(MahjongOp.hu);
//                }
            }
        }
        if (!isThinking) {
            mopai(tableIns, false);
            return;
        }
        RedisKey thinkIng = TableKeys.tableThink.create();
        JSONObject thinkIngObj = new JSONObject();
        thinkIngObj.put("time",System.currentTimeMillis()/1000);
        thinkIngObj.put("roomId",tableIns.getRoomId());
        thinkIngObj.put("tableId",tableIns.getTableId());
        redis.lpush(thinkIng,thinkIngObj);
        scThinking.setOperation(op);
        HttpUtils.pushMessagecl(JSONObject.toJSONString(scThinking), tableIns.getUids(), tableIns.getMatchInsId());
    }

    public static void doIt(TableInstance tableIns, int op, JSONArray cards,String uid) {
        if (op == MahjongOp.huitougang || op == MahjongOp.angang || op == MahjongOp.minggang || op == MahjongOp.peng) {
            mopai(tableIns, true);
        }
        if (op == MahjongOp.pass) {
            mopai(tableIns, false);
        }
        if(op == MahjongOp.hu){
            TablePlayers player = tableIns.getPlayers().get(Integer.parseInt(uid));
            List<Integer> shouCards = new ArrayList<>();
            List<Integer> chiCards = new ArrayList<>();
            chiCards = player.getCards();
            if(tableIns.getCurSeat() == player.getUserSeat()){//当前操作位置是自己  属于自摸
                shouCards = player.getCards();
            }else{
                shouCards = player.getCards();
                shouCards.add(cards.getInteger(0));
            }
            List<Integer> hu = checkHu(shouCards,chiCards);
            if(tableIns.getCurSeat() == player.getUserSeat()){
                hu.add(HuOp.zimo);
            }
            if(player.getUserSeat() != tableIns.getZhunagSeat()){
                if(tableIns.getZhuangNum() == 1){
                    hu.add(HuOp.dihu);
                }
            }
            if(tableIns.getCards().size() == 107){
                hu.add(HuOp.tianhu);
            }
        }
    }

    /**
     * 摸牌
     *
     * @param tableIns
     * @param isCur    是否是当前位置摸牌
     */
    public static void mopai(TableInstance tableIns, boolean isCur) {
        if (tableIns.getCards().size() == 0) {
            logger.error("没有牌了");
            return;
        }
        int card = tableIns.getCards().remove(0);
        SCGetCard scGetCard = new SCGetCard();
        scGetCard.setCard(card);
        if (!isCur) {
            tableIns.setCurSeat(tableIns.getCurSeat() % tableIns.getTotalNum() + 1);
        }
        scGetCard.setCutSeat(tableIns.getCurSeat());
        int uid = tableIns.getUids()[tableIns.getCurSeat() - 1];
        scGetCard.setUid(String.valueOf(uid));
        TablePlayers player = tableIns.getPlayers().get(uid);
        player.getCards().add(card);
        try {
            Thread.sleep(1000);
        } catch (Exception e) {
            e.printStackTrace();
        }
        HttpUtils.pushMessagecl(JSONObject.toJSONString(scGetCard), tableIns.getUids(), tableIns.getMatchInsId());
        // TablesUtils.checkThinking(card, tableIns, 0);
    }

    /**
     * 判断是否有三个 是否有两个的
     *
     * @param in
     * @param num
     * @return
     */
    private static boolean checkGangOrPeng(List<Integer> in, int num) {
        boolean ret = false;
        Collections.sort(in);
        int total = 1;
        for (int i = 0; i < in.size() - 1; i++) {
            if (in.get(i) == in.get(i + 1)) {
                total = total + 1;
            }
            else
            {
                total = 1;
            }
            if (total == num) {
                ret = true;
                break;
            }
        }
        return ret;
    }


    private static boolean checkPeng(List<Integer> in, int card) {
        boolean ret = false;
        Collections.sort(in);
        int total = 0;
        for (int i = 0; i < in.size() - 1; i++) {
            if (in.get(i) == card) {
                total = total + 1;
            }
            if (total == 3) {
                ret = true;
                break;
            }
        }
        return ret;
    }



    private static List<Integer> checkHu(List<Integer> shouCards, List<Integer> chiCards) {
        List<Integer> lst = new ArrayList<>();
        List<Integer> allCards = new ArrayList<>();
        allCards.addAll(shouCards);
        allCards.addAll(chiCards);
        Collections.sort(allCards);
        //清一色的判断
        boolean isQingyise = true;
        int obj1 = getMin(allCards.get(0));//取出第一个
        for (int i = 1; i < allCards.size(); i++) {
            int obj2 = getMin(allCards.get(i));//取出第一个
            if (obj2 > 29) { // 大于29  可能是东南西北  就是清一色了
                isQingyise = false;
            }
            if ((obj2 - obj1) >= 10 || (obj1 - obj2) >= 10) {
                isQingyise = false;
            }
        }
        if (isQingyise) {
            lst.add(HuOp.qingyise);
        }
        //清一色end
        //碰碰胡
        boolean pengpengyidui = false;//判断是否是一个对子
        boolean isPengpeng = true;
        for(int i = 0;i < allCards.size();i++){
            List<Integer> pengpengObj1 = new ArrayList<>();
            pengpengObj1.addAll(allCards);
            List<Integer> ds = findAll(allCards.get(i),allCards);
            if(ds.size() >= 2){
                i += ds.size();
                if(ds.size() == 2 && pengpengyidui){
                    isPengpeng = false;
                    break;
                }else{
                    pengpengyidui = true;
                }
            }else{
                isPengpeng = false;
                break;
            }
        }
        if (isPengpeng) {
            lst.add(HuOp.duiduihu);
        }
        //碰碰胡end
        //七对
        boolean isTidui = true;
        for(int i = 0;i < allCards.size();i++){
            List<Integer> obj = new ArrayList<>();
            obj.addAll(shouCards);//手牌
            Collections.sort(obj);
            List<Integer> ds = findAll(allCards.get(i),allCards);
            if(ds.size() != 2 || ds.size() != 4){
                isTidui = false;
                break;
            }else{
                i += ds.size();
            }
        }
        if (isTidui) {
            lst.add(HuOp.qingyise);
        }
        //七对end
        //幺九
        List<Integer> yaojiuObj = new ArrayList<>();
        boolean isYaojiu = true;
        for(int i = 0;i < allCards.size();i++){
            yaojiuObj.addAll(allCards);
            List<Integer> obj =  findAll(allCards.get(i),allCards);
            if(obj.size() >= 3){
                if(!checkIsYaojiu(obj.get(i))){
                    isYaojiu = false;
                    break;
                }
                yaojiuObj.remove(obj.get(i));
                yaojiuObj.remove(obj.get(i));
                yaojiuObj.remove(obj.get(i));
                i += allCards.size();
            }
        }
        if(yaojiuObj.size() < 14){
            for(int i = 0;i < yaojiuObj.size() - 3;i++){
                if(yaojiuObj.contains(yaojiuObj.get(i) + 1) && yaojiuObj.contains(yaojiuObj.get(i) + 2)){
                    if(checkIsYaojiu(yaojiuObj.get(i)) || checkIsYaojiu(yaojiuObj.get(i) + 1) || checkIsYaojiu(yaojiuObj.get(i) + 2)){
                        i += 3;
                    }else{
                        isYaojiu = false;
                        break;
                    }
                }else{
                    isYaojiu = false;
                    break;
                }
            }
        }else{
            isYaojiu = false;
        }
        if (isYaojiu) {
            lst.add(HuOp.yaojiu);
        }
        //幺九end
        //全球人
        if(shouCards.size() == 2){
            lst.add(HuOp.quanqiuren);
        }
        //全球人end
        return lst;
    }

    private static int getMin(int i) {
        if (i >= 1 && i <= 9) {
            return 1;
        }
        if (i >= 11 && i <= 19) {
            return 11;
        }
        if (i >= 21 && i <= 29) {
            return 21;
        }
        return i;
    }


    public static boolean IsCanHU(List<Integer> mah, int ID) {
        List<Integer> pais = new ArrayList<>();
        pais.addAll(mah);
        pais.add(ID);
        //只有两张牌
        if (pais.size() == 2) {
            return pais.get(0) == pais.get(1);
        }
        //先排序
        Collections.sort(pais);
        //依据牌的顺序从左到右依次分出将牌
        for (int i = 0; i < pais.size(); i++) {
            List<Integer> paiT = new ArrayList<>();
            paiT.addAll(pais);
            List<Integer> ds = findAll(pais.get(i),pais);
            //判断是否能做将牌
            if (ds.size() >= 2) {
                //移除两张将牌
                paiT.remove(pais.get(i));
                paiT.remove(pais.get(i));
                //避免重复运算 将光标移到其他牌上
                i += ds.size();
                if (HuPaiPanDin(paiT)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static Boolean HuPaiPanDin(List<Integer> mahs) {
        if (mahs.size() == 0) {
            return true;
        }
        List<Integer> fs = findAll(mahs.get(0),mahs);
        //组成克子
        if (fs.size() == 3) {
            mahs.remove(mahs.get(0));
            mahs.remove(mahs.get(0));
            mahs.remove(mahs.get(0));
            return HuPaiPanDin(mahs);
        } else { //组成顺子
            if (mahs.contains(mahs.get(0) + 1) && mahs.contains(mahs.get(0) + 2)) {
                mahs.remove(mahs.get(0) + 2);
                mahs.remove(mahs.get(0) + 1);
                mahs.remove(mahs.get(0));
                return HuPaiPanDin(mahs);
            }
            return false;
        }
    }

    private static List<Integer> findAll(int d,List<Integer> lst){
        List<Integer> ret = new ArrayList<>();
        for(int i = 0;i < lst.size();i++){
            if(lst.get(i) == d){
                ret.add(d);
            }
        }
        return ret;
    }

    /**
     * 判断是不是幺九
     * @param i
     * @return
     */
    private static boolean checkIsYaojiu(int i){
        if(i == 1 || i == 9 || i == 11 || i == 19 || i == 21 || i == 29){
            return true;
        }
        return false;
    }
}
