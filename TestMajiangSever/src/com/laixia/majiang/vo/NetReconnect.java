package com.laixia.majiang.vo;

import com.alibaba.fastjson.JSONObject;

import java.io.Serializable;
import java.util.*;

 
/*
   短线重新连接数据获取
 */

public class NetReconnect implements Serializable {
    //牌桌id
    private String tableId;
    //比赛id
    private String matchId;
    //房间id
    private String roomId;
    //比赛实例id
    private String matchInsId;
    //当前出牌位置
    private int curSeat;
    //上一家位置
    private int upSeat;
    //牌桌总人数
    private int totalNum;
    // 牌桌类型 1 普通场 2是好友场 3是比赛场
    private int poker_type  ;
    // 那一uid是庄家
    private  int zhuang_uid;
    // 玩家当前的实例  基本信息
    private  TablePlayers player;
    // 当前局数
    private  int nums;
    // 当前操作剩余时间
    private  int surplustime;
    //当前系统时间 补上10毫秒的网络误差
    private  int curtime = 10;


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

    public int getNum() {
        return nums;
    }

    public void setNum(int num) {
        this.nums = num;
    }

    public int getCurSeat() {
        return curSeat;
    }

    public void setCurSeat(int curSeat) {
        this.curSeat = curSeat;
    }

    public TablePlayers getPlayers() {
        return player;
    }

    public void setPlayers( TablePlayers players) {
        this.player = players;
    }

    public int getTotalNum() {
        return totalNum;
    }

    public void setTotalNum(int totalNum) {
        this.totalNum = totalNum;
    }

    public int getUpSeat() {
        return upSeat;
    }

    public void setUpSeat(int upSeat) {
        this.upSeat = upSeat;
    }

    public int getPokertype() { return poker_type; }

    public void setPokertype(int pokertype) { this.poker_type = pokertype; }

    public int getZhuang_Uid() { return zhuang_uid; }

    public void setZhuang_Uid(int zhuanguid) { this.zhuang_uid = zhuanguid; }

    public int getSurplusTime() { return surplustime; }

    public void setSurplusTime(int surplusTime) { this.surplustime = surplusTime; }


}



