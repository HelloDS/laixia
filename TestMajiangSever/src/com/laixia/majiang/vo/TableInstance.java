package com.laixia.majiang.vo;

import java.io.Serializable;
import java.util.*;

/**
 * 牌桌集合1
 */
public class TableInstance implements Serializable{
    //牌桌id
    private String tableId;
    //比赛id
    private String matchId;
    //房间id
    private String roomId;
    //比赛实例id
    private String matchInsId;

    private int[] uids;
    //当前出牌位置
    private int curSeat;
    //上一家位置
    private int upSeat;
    //剩余的牌
    private List<Integer> cards;
    //牌桌总人数
    private int totalNum;

    //用户Map<Integer,TablePlayers> key uid
    private Map<Integer,TablePlayers> players = new HashMap<>();

    private int uidsarr[] ;

    // 牌桌类型 1 普通场 2是好友场 3是比赛场
    private int poker_type  ;

    // 那一uid是庄家
    private  int zhuang_uid;
    // 庄家的牌值
    private int zhuang_val;
    //庄家位置
    private int zhunagSeat;
    //庄家打了几次
    private int zhuangNum;

    //日志字符串
    private StringBuffer logStr = new StringBuffer();

    public TableInstance(){//初始化牌桌使用
        this.tableId = "0";
        this.roomId = "0";
        this.matchId = "0";
        this.initCards(2);//血战类型
        Collections.shuffle(cards);//随机cards
        this.setTotalNum(4);
        this.SetPlayerCradsVal(totalNum);
        this.RandPlayerIdInZhuang();
        this.RandRoomid();

    }
    //----------------------------------------------------------------
    public String getTableId() {
        return tableId;
    }

    public void setTableId(String tableId) {
        this.tableId = tableId;
    }

    public String getMatchId() {
        return matchId;
    }

    public void setMatchId(String matchId) {
        this.matchId = matchId;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getMatchInsId() {
        return matchInsId;
    }

    public void setMatchInsId(String matchInsId) {
        this.matchInsId = matchInsId;
    }

    public int[] getUids() {
        return uids;
    }

    public void setUids(int[] uids) {
        this.uids = uids;
    }

    public int getCurSeat() {
        return curSeat;
    }

    public void setCurSeat(int curSeat) {
        this.curSeat = curSeat;
    }

    public StringBuffer getLogStr() {
        return logStr;
    }

    public void setLogStr(StringBuffer logStr) {
        this.logStr = logStr;
    }

    public Map<Integer, TablePlayers> getPlayers() {
        return players;
    }

    public void setPlayers(Map<Integer, TablePlayers> players) {
        this.players = players;
    }

    public List<Integer> getCards() {
        return cards;
    }

    public void setCards(List<Integer> cards) {
        this.cards = cards;
    }

    public int getTotalNum() {
        return totalNum;
    }

    public void setTotalNum(int totalNum) {
        this.totalNum = totalNum;
        uids = new int[totalNum];
    }

    public int getUpSeat() {
        return upSeat;
    }

    public void setUpSeat(int upSeat) {
        this.upSeat = upSeat;
    }

    public int getZhunagSeat() {
        return zhunagSeat;
    }

    public void setZhunagSeat(int zhunagSeat) {
        this.zhunagSeat = zhunagSeat;
    }

    public int getZhuangNum() {
        return zhuangNum;
    }

    public void setZhuangNum(int zhuangNum) {
        this.zhuangNum = this.zhuangNum + zhuangNum;
    }

    //-------------------------------------------------------------------
    private void initCards(int type){
        poker_type = type;
        if (cards != null) cards.clear();
        cards = new ArrayList<>();
        for(int j = 1;j <=9;j++){
            for(int i = 0;i < 4;i++){
                cards.add(j);
            }
        }
        for(int j = 10;j <= 18;j++){
            for(int i = 0;i < 4;i++){
                cards.add(j);
            }
        }
        for(int j = 19;j <=27;j++){
            for(int i = 0;i < 4;i++){
                cards.add(j);
            }
        }
        int a = 0;
    }

    // 给开始的4个玩家赋牌值
    public void SetPlayerCradsVal( int totalNum ) {

        if ( totalNum <= 0 )
        {
            return;
        }
        int uid = 10000; // 暂定UID 为10001 开始
        int last = 0;
        int endst = 13;
        for (int a = 0; a < totalNum; a++) {
            uid = uid + 1;
            TablePlayers player = new TablePlayers();
            player.setUserSeat( a+1 );

            List<Integer> ls = new ArrayList<Integer>();
            for (int j = last; j < endst; j++){
                ls.add(cards.get(j));
            }
            player.setCards(ls);
            player.setUid(uid);
            uids[a] = uid;
            players.put(uid, player);
            for (int j = endst - 1; j >= 0; j--) {
                cards.remove(j);
            }
            int ga = 0;
        }
    }

    // 随机算出谁是庄家
    public void RandPlayerIdInZhuang(  ) {
        Random r = new Random();
        int id = r.nextInt(totalNum) + 1;
        int a = 0;
        for(Integer key : players.keySet()){
            a++;
            if ( id == a ) {
                zhuang_uid = key;
                break;
            }
        }
        setZhuang_Val(getCardsInFrist());
    }

    // 根据时间戳生成唯一房间ID
    public  void  RandRoomid() {
        long time = new Date().getTime();
        roomId = "0";
    }


    // 从牌堆里面拿取一张牌 摸牌
    public int getCardsInFrist(){
        if( cards.size() <= 0  ) {
            System.out.print("牌堆里面现在已经没有牌了,游戏结束");
            return  -1;
        }
        int pokerval = cards.get(0);
        cards.remove(0);
        return  pokerval;
    }

    public int getPokertype() { return poker_type; }

    public void setPokertype(int pokertype) { this.poker_type = pokertype; }

    public int getZhuang_Uid() { return zhuang_uid; }

    public void setZhuang_Uid(int zhuanguid) { this.zhuang_uid = zhuanguid; }

    public int getZhuang_Val() { return zhuang_val; }

    public void setZhuang_Val(int zhuangval) { this.zhuang_val = zhuangval; }


}



