package com.laixia.majiang.common;

/**
 * 麻将番数 配置
 */
public class MahjongFanNumOp {

    //平胡
    public static int pinghu = 1;
    //清一色
    public static int qingyise = 1;
    //对对胡
    public static int duiduihu = 2;
    //七对
    public static int qidui = 3;
    //幺九
    public static int yaojiu = 4;
    //根
    public static int gen = 5;
    //全球人
    public static int quanqiuren = 6;
    //自摸
    public static int zimo = 7;
    //天胡
    public static int tianhu = 8;
    //地胡
    public static int dihu = 9;


    int[][] FanShuArr = {
                    {pinghu},{2},
                    {qingyise},{2},
                    {duiduihu},{2},
                    {qidui},{2},
                    {yaojiu},{2},
                    {gen},{2},
                    {quanqiuren},{2},
                    {zimo},{2},
                    {tianhu},{2},
                    {dihu},{2},
                };

    // 根据麻将胡牌类型获取番数
    public int getFanshuInType( int type )
    {
        if( type <= 0 || type > 20 )
        {
            return  0;
        }

        return FanShuArr[type-1][0];
    }


    // 根据杠获取分数
    public int setOtherInDianGtype( int gangtype )
    {
        if(gangtype <= 0 )return 0 ;
        return  1;
    }

}
