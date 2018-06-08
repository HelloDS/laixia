package com.laixia.majiang.vo.sc;

import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.common.CCPlayerDqInfo;

import java.util.ArrayList;
import java.util.List;




public class SCDingQueInfo {

    private String tp;
    private String table_id;
    private String room_id;
    private List<CCPlayerDqInfo> PlayerDqInfo;



    public SCDingQueInfo(){
        tp = "dingqueinfo";
        PlayerDqInfo = new ArrayList<>();
    }

    public List<CCPlayerDqInfo> getPlayerDqInfo() {
        return this.PlayerDqInfo;
    }

    public void setPlayerDqInfo(List<CCPlayerDqInfo> PlayerDqInfolist) {
        this.PlayerDqInfo = PlayerDqInfolist;
    }


    public void addPlayerDqInfo( CCPlayerDqInfo info) {
        this.PlayerDqInfo.add(info);
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

}
