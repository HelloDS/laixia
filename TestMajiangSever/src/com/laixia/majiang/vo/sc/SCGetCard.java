package com.laixia.majiang.vo.sc;

public class SCGetCard {

    private String tp;

    private int card;


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
