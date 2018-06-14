package com.laixia.majiang.vo;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


public class TablePlayers implements Serializable {

    //玩家uid
    private int uid;
    //玩家手牌
    private List<Integer> cards = new ArrayList<>();
    //玩家出的牌
    private List<Integer> outCards = new ArrayList<>();

    //玩家换三张的牌
    private List<Integer> changeCards = new ArrayList<>();

    //用户所有的杠
    private List<Integer>  gang = new ArrayList<>();
    //用户所有的碰
    private List<Integer>  peng = new ArrayList<>();
    //用户所有的胡
    private List<Integer>  hu = new ArrayList<>();
    //所有的吃
    private List<Integer>  chi = new ArrayList<>();
    //用户的位置
    private int userSeat;
    //0未托管 1托管
    private int trusteeship;
    //定缺的花色
    private int quedehuase;
    //是不是庄
    private int iszhuang;
    //是不是点炮者
    private boolean isdianPao;

    //点杠的牌 点了谁的杠
    private JSONArray diangangs = new JSONArray();
    //点炮的牌 点了谁的炮
    private JSONArray dianpaos = new JSONArray();
    //用户所有的胡
    private JSONArray hupai = new JSONArray();
    //用户所有的杠牌
    private JSONArray gangpai = new JSONArray();


    public int getUid() {
        return uid;
    }

    public void setUid(int Uid) {
        this.uid = Uid;
    }

    public List<Integer> getCards() { return cards; }

    public void setCards(List<Integer> cards) {
        this.cards = cards;
    }

    public List<Integer> getOutCards() {
        return outCards;
    }

    public void setOutCards(List<Integer> outCards) {
        this.outCards = outCards;
    }
    public void addOutCards( Integer cr ){
        outCards.add(cr);
    }
    public List<Integer> getGang() {
        return gang;
    }

    public void setGang(List<Integer> gang) {
        this.gang = gang;
    }

    public List<Integer> getPeng() {
        return peng;
    }

    public void setPeng(List<Integer> peng) {
        this.peng = peng;
    }

    public List<Integer> getHu() {
        return hu;
    }

    public void setHu(List<Integer> hu) {
        this.hu = hu;
    }

    public List<Integer> getChi() {
        return chi;
    }

    public void setChi(List<Integer> chi) {
        this.chi = chi;
    }

    public List<Integer> getChangeCards() {
        return changeCards;
    }

    public void setChangeCards(List<Integer> changeCards) {
        this.changeCards = changeCards;
    }


    // 把换牌得三张加入到手牌中
    public void addChangeCards(List<Integer> changeCards) {
        for(int i=0;i<changeCards.size();i++){
            cards.add(changeCards.get(i));
        }
    }

    // 从手牌中移除玩家得选中得三张牌
    public void ChangeCards(List<Integer> changeCards) {
       if(cards.size() < 13) {
           return;
       }
        for(int i=0;i<changeCards.size();i++){
            int cval = changeCards.get(i);

            for(int j = 0;i < cards.size();j++) {
                int sval = cards.get(j);
                if ( sval == cval ) {
                    changeCards.remove(sval);
                }
            }
        }
    }




    public int getUserSeat() {
        return userSeat;
    }

    public void setUserSeat(int userSeat) {
        this.userSeat = userSeat;
    }

    public int getTrusteeship() {
        return trusteeship;
    }

    public void setTrusteeship(int trusteeship) {
        this.trusteeship = trusteeship;
    }

    public int getQuedehuase() {
        return quedehuase;
    }

    public void setQuedehuase(int quedehuase) {
        this.quedehuase = quedehuase;
    }

    public int getZhuan() {
        return iszhuang;
    }

    public void setZhuan(int zhuan) { this.iszhuang = zhuan; }

    public JSONArray getDiangangs() {
        return diangangs;
    }

    public void setDiangangs(int uid, int diangangtype, int diangangval, int time){

        JSONObject js = new JSONObject();
        js.put("uid",uid);
        js.put("diangangtype",diangangtype);
        js.put("diangangval",diangangval);
        js.put("time",time);
        diangangs.add(js);
    }

    public JSONArray getDianPaos() {
        return dianpaos;
    }

    public void setDianPaos(int uid, int dianpaotype, int dianpaoval, int time)
    {
        JSONObject js = new JSONObject();
        js.put("uid",uid);
        js.put("dianpaotype",dianpaotype);
        js.put("dianpaoval",dianpaoval);
        js.put("time",time);
        dianpaos.add(js);
    }

    public void setIsDianPao( boolean IsDianPao ) { isdianPao = IsDianPao; }

    public boolean getIsDianPao() { return isdianPao; }


    public void setHupai(int uid, int hupaitype, int hupaival, int time){
        JSONObject js = new JSONObject();
        js.put("uid",uid);
        js.put("hupaitype",hupaitype);
        js.put("hupaival",hupaival);
        js.put("time",time);
        hupai.add(js);
    }

    public JSONArray getHupai() {
        return hupai;
    }

    public void setGangpai(int uid, int gangpaitype, int gangpaival, int time){
        JSONObject js = new JSONObject();
        js.put("uid",uid);
        js.put("gangpaitype",gangpaitype);
        js.put("gangpaival",gangpaival);
        js.put("time",time);
        hupai.add(js);
    }

    public JSONArray getGangpai() {
        return gangpai;
    }
}
