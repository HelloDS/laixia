package com.laixia.majiang.vo;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.common.GameScore;
import com.laixia.majiang.common.MahjongFanNumOp;
import com.laixia.majiang.vo.sc.SCEndMyData;
import com.laixia.majiang.vo.sc.SCEndOneData;

import java.io.Serializable;
import java.util.*;


public class GameSettlement implements Serializable
{

    private List<SCEndOneData> playerGameSettlement = new ArrayList<>();

    private List<SCEndMyData> MyGameSettlement = new ArrayList<>();

    // 引用对象
    private MahjongFanNumOp op = new  MahjongFanNumOp();
    private GameScore score = new GameScore();

    // 保存牌桌的4个玩家对象
    private Map<Integer,TablePlayers> players = new HashMap<>();
    // 构造函数
    GameSettlement( Map<Integer,TablePlayers> player )
    {
        players = player;
    }

    private void setMyEndData( TablePlayers player )
    {
        // 算出玩家胡牌分数
        JSONArray hupaiarr = player.getHupai();
        for(int i=0;i<hupaiarr.size();i++){
            SCEndMyData  mydata = new SCEndMyData();
            JSONObject job = hupaiarr.getJSONObject(i);
            int type = job.getIntValue("hupaitype");
            int fanshu = op.getFanshuInType(type);
            int addcoinnum = this.setOtherInHupaitype( type );
            mydata.setaddcoinNum(addcoinnum);
            mydata.setEndtype(type);
            mydata.setFanshu(fanshu);
            MyGameSettlement.add(mydata);
        }

        // 算出玩家点炮的分数
        JSONArray dianpaoarr = player.getDianPaos();
        for(int i=0;i<dianpaoarr.size();i++){
            JSONObject job = dianpaoarr.getJSONObject(i);
            SCEndMyData  mydata = new SCEndMyData();
            int type = job.getIntValue("dianpaotype");
            int fanshu = op.getFanshuInType(type);
            int addcoinnum = this.setOtherInHupaitype( type );
            mydata.setaddcoinNum(-addcoinnum);
            mydata.setEndtype(type);
            mydata.setFanshu(fanshu);
            MyGameSettlement.add(mydata);
        }

        // 算出玩家点杠的分数
        JSONArray diangangarr = player.getDiangangs();
        for(int i=0;i<diangangarr.size();i++){
            JSONObject job = diangangarr.getJSONObject(i);
            SCEndMyData  mydata = new SCEndMyData();
            int type = job.getIntValue("diangangtype");
            int fanshu = 0;
            int addcoinnum = op.setOtherInDianGtype( type );
            mydata.setaddcoinNum(-addcoinnum);
            mydata.setEndtype(type);
            mydata.setFanshu(fanshu);
            MyGameSettlement.add(mydata);
        }

        // 算出玩家杠牌的分数
        JSONArray gangpaiarr = player.getGangpai();
        for(int i=0;i<gangpaiarr.size();i++){
            JSONObject job = gangpaiarr.getJSONObject(i);
            SCEndMyData  mydata = new SCEndMyData();
            int type = job.getIntValue("gangpaitype");
            int fanshu = 0;
            int addcoinnum = op.setOtherInDianGtype( type );
            mydata.setaddcoinNum(addcoinnum);
            mydata.setEndtype(type);
            mydata.setFanshu(fanshu);
            MyGameSettlement.add(mydata);
        }
    }



    private void setThreeEndData( int roleUid )
    {
        if( roleUid <= 0 )return;
        String uid = String.valueOf(roleUid);
        TablePlayers player = new TablePlayers();

        Iterator entries = players.entrySet().iterator();
        while (entries.hasNext())
        {
            Map.Entry entry = (Map.Entry) entries.next();
            String key = (String)entry.getKey();
            player = (TablePlayers)entry.getValue();
            if(false == uid.equals(key))
            {
                setOtherOneData( player );
            }
            else
            {
                setMyEndData( player  );
            }
        }
    }

    // 算一个玩家的番数和分数
    private SCEndOneData setOtherOneData( TablePlayers player )
    {

        SCEndOneData playerone = new SCEndOneData();
        playerone.setPlayerid(player.getUid());

        int scoresum = 0;
        // 算出玩家胡牌分数
        JSONArray hupaiarr = player.getHupai();
        for(int i=0;i<hupaiarr.size();i++){
            JSONObject job = hupaiarr.getJSONObject(i);
            scoresum = this.setOtherInHupaitype( job.getIntValue("hupaitype") ) + scoresum;
        }

        // 算出玩家点炮的分数
        JSONArray dianpaoarr = player.getDianPaos();
        for(int i=0;i<dianpaoarr.size();i++){
            JSONObject job = dianpaoarr.getJSONObject(i);
            scoresum = scoresum - this.setOtherInHupaitype( job.getIntValue("dianpaotype") );
        }

        // 算出玩家点杠的分数
        JSONArray diangangarr = player.getDiangangs();
        for(int i=0;i<diangangarr.size();i++){
            JSONObject job = diangangarr.getJSONObject(i);
            scoresum = scoresum - op.setOtherInDianGtype( job.getIntValue("diangangtype") );
        }

        // 算出玩家杠牌的分数
        JSONArray gangpaiarr = player.getGangpai();
        for(int i=0;i<gangpaiarr.size();i++){
            JSONObject job = gangpaiarr.getJSONObject(i);
            scoresum = scoresum + op.setOtherInDianGtype( job.getIntValue("gangpaitype") );
        }
        playerone.setaddcoinNum(scoresum);

        playerGameSettlement.add(playerone);
        return playerone;
    }

    // 根据胡牌类型获得分数
    private int setOtherInHupaitype( int hupaitype )
    {
        if(hupaitype <= 0 )return 0 ;
        int fanshu  = op.getFanshuInType(hupaitype);
        int scsum = score.getScoreInFan(fanshu);
        return  scsum;
    }



}