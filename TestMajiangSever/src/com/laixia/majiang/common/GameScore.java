package com.laixia.majiang.common;


// 游戏得分计算
public class GameScore {

    // 每一番得低分 可配置
    private int difen = 200;

    // 根据番数获得分数
    public int getScoreInFan( int fanshu ) {
        int allscore = 0;
        allscore = fanshu * difen;
        return allscore;
    }
}