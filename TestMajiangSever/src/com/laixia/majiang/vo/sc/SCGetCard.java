package com.laixia.majiang.vo.sc;

public class SCGetCard {

    private String tp;

    private int card;

    private String uid;

    private int cutSeat;

    public SCGetCard(){
        this.tp = "get_card";
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public int getCard() {
        return card;
    }

    public void setCard(int card) {
        this.card = card;
    }

    public int getCutSeat() {
        return cutSeat;
    }

    public void setCutSeat(int cutSeat) {
        this.cutSeat = cutSeat;
    }
}
