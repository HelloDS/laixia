package com.laixia.majiang.vo.sc;



// 玩家自己的结算数据
public class SCEndMyData {

    //data类型   胡牌 还 被杠 等
    private int SettlementOptype;
    //番数
    private int fanshu;
    //输赢多少金币
    private  int addcoinnum;

    public void setEndtype(int endtype) {
        this.SettlementOptype = endtype;
    }

    public int getEndtype() {
        return SettlementOptype;
    }

    public void setFanshu(int fanShu) {
        this.fanshu = fanShu;
    }

    public int getFanshu() {
        return fanshu;
    }

    public void setaddcoinNum(int addcoinNum) {
        this.addcoinnum = addcoinNum;
    }

    public int getaddcoinNum() {
        return addcoinnum;
    }
}
