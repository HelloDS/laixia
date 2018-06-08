package com.laixia.majiang.vo.sc;

import com.laixia.majiang.common.CCPlayerInfo;

import java.util.ArrayList;
import java.util.List;





public class SCCreatePoker {

    private String tp;
    private String table_id;
    private String room_id;
    private List<CCPlayerInfo> pokerinfo = new ArrayList<>();
    private int pokertype;
    private int zhuangval;
    private int zhuangid;
    private int surplusSum;



    public SCCreatePoker(){
        tp = "create_poker";
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public String getTable_id() {
        return table_id;
    }

    public void setTable_id(String table_id) {
        this.table_id = table_id;
    }

    public String getRoom_id() {
        return room_id;
    }

    public void setRoom_id(String room_id) {
        this.room_id = room_id;
    }

    public List<CCPlayerInfo> getPokerinfo() {
        return this.pokerinfo;
    }

    public void setPokerinfo(List<CCPlayerInfo> Pokerinfo) {
        this.pokerinfo = Pokerinfo;
    }

    public void addPlayerInfolist(CCPlayerInfo pinfo) {
        this.pokerinfo.add(pinfo);
    }




    public int getPokertype() {
        return pokertype;
    }

    public void setPokertype(int pokertype) {
        this.pokertype = pokertype;
    }

    public int getZhuangval() {
        return zhuangval;
    }

    public void setZhuangval(int zhuangval) {
        this.zhuangval = zhuangval;
    }

    public int getZhuangid() {
        return pokertype;
    }

    public void setZhuangid(int zhuangid) {
        this.zhuangid = zhuangid;
    }

    public int getSurplusSum() {
        return surplusSum;
    }

    public void setSurplusSum(int surplusSum) {
        this.surplusSum = surplusSum;
    }
}
