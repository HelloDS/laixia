package com.laixia.majiang.vo.sc;

import java.util.List;

public class SCThinking {

    private String tp;

    private String table_id;

    private String room_id;

    private List<Integer> operation;

    private int card;

    private String uid ;


    public SCThinking(){
        tp = "thinking";
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

    public List<Integer> getOperation() {
        return operation;
    }

    public void setOperation(List<Integer> operation) {
        this.operation = operation;
    }

    public int getCard() {
        return card;
    }

    public void setCard(int card) {
        this.card = card;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }
}
