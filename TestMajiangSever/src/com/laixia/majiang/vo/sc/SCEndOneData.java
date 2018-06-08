package com.laixia.majiang.vo.sc;




// 游戏结算一个玩家的数据
public class SCEndOneData {

    //玩家ID
    private int playerid;
    //番数
    private int fanshu;
    //结束状态
    private int endstate;
    //输赢多少金币
    private  int addcoinnum;

    public void setPlayerid(int playerId) {
        this.playerid = playerId;
    }

    public int getPlayerid() {
        return playerid;
    }

    public void setFanshu(int fanShu) {
        this.fanshu = fanShu;
    }

    public int getFanshu() {
        return fanshu;
    }

    public void setendState(int endState) {
        this.endstate = endState;
    }

    public int getendState() {
        return endstate;
    }

    public void setaddcoinNum(int addcoinNum) {
        this.addcoinnum = addcoinNum;
    }

    public int getaddcoinNum() {
        return addcoinnum;
    }
}
