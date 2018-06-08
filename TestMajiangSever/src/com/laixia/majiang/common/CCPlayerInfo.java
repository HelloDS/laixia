
package com.laixia.majiang.common;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.util.ArrayList;
import java.util.List;



// 牌桌创建得玩家数据结构体
public class CCPlayerInfo {
    private int uid;
    private int seat;
    private int add;
    private List<Integer> pokerinfo = new ArrayList<>();

    public CCPlayerInfo(){

    }

    public void setUid( int uid ) { this.uid = uid; }
    public int getUid() { return  uid; }

    public int getSeat() {
        return seat;
    }

    public void setSeat(int seat) {
        this.seat = seat;
    }

    public List<Integer> getPokerinfo() {
        return pokerinfo;
    }

    public void setPokerinfo(List<Integer> pokerinfo) {
        this.pokerinfo = pokerinfo;
    }
}