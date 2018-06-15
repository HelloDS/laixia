local SoundConfig = {
    SCENE_MUSIC = {
        lobby       =   "sound/music/game_hall.mp3",  --大厅（游戏牌桌以外的界面）            循环
        -- nomal       =   "sound/music/game_table.mp3",  --牌桌                                 循环
        -- boom      =   "sound/music/game_table.mp3",  --牌桌                                循环
        -- desk_3      =   "sound/music/game_table.mp3",  --牌桌                              循环
       -- LHD      =   "sound/music/longhudou.mp3",  --龙虎斗                              循环
       -- WRNN      =   "sound/music/wanrenniuniu.mp3",  --万人牛牛                              循环--
       -- ZJH      =   "sound/music/zhajinhua.mp3",  --炸金花                              循环

    },

    -- 按钮音效
    BUTTON_SOUND = {
        ui_button_open = "sound/effect/dianjinjinru.mp3",  --点击按钮，点击进入
        ui_button_close = "sound/effect/dianjinjinru.mp3",  --点击按钮，点击返回
        ui_button_select_sheet = "sound/effect/xuanpai.mp3",  --点击按钮，选择牌
        ui_button_error = "sound/effect/cuowutishi.mp3",  --点击按钮，错误提示
        ui_button_play = "sound/effect/chupai.mp3",  --点击按钮，出牌


        ui_landlord_w_open_hand = "sound/dubbing/mingpai.mp3",  --明牌
        
        ui_click_woman_fen_1 = "sound/dubbing/woman_jiaofen01.mp3" ,
        ui_click_woman_fen_2 = "sound/dubbing/woman_jiaofen02.mp3" ,
        ui_click_woman_fen_3 = "sound/dubbing/woman_jiaofen03.mp3" ,
        ui_click_man_fen_1 = "sound/dubbing/man_jiaofen01.mp3" ,
        ui_click_man_fen_2 = "sound/dubbing/man_jiaofen02.mp3" ,
        ui_click_man_fen_3 = "sound/dubbing/man_jiaofen03.mp3" ,

        ui_landlord_call_3 = "sound/dubbing/jiaodizhu.mp3",      --叫地主
        ui_landlord_call_grab = "sound/dubbing/qiangdizhu.mp3",     --强地主
        ui_landlord_call_grab_me = "sound/dubbing/woqiang.mp3",     
        ui_landlord_call_no = "sound/dubbing/woman_bujiao.mp3",    --不叫  
        ui_landlord_man_call_no = "sound/dubbing/man_bujiao.mp3",    --不叫      

        ui_landlord_call_grab_no = "sound/dubbing/buqiang.mp3",   --不强
    },
    
    EVENT_SOUND = {
        ui_event_spring =   "sound/effect/chuntian.mp3",  --春天音效
        ui_evevt_bear_palm =   "sound/effect/bisaihuojiang.mp3",  --比赛获奖     
        ui_evevt_deal_card = "sound/effect/fapai.mp3",  --发牌音效
        ui_evevt_landlord_change = "sound/effect/dizhubsheng.mp3",  --地主变身音效
        ui_evevt_open_hand = "sound/effect/dizhubianshen.mp3",  --明牌音效
        ui_evevt_airplane = "sound/effect/feiji.mp3",  --飞机音效
        ui_evevt_bomb = "sound/effect/zhadan.mp3",  --炸弹音效
        ui_evevt_straight = "sound/effect/shunzi.mp3",  --顺子音效
        ui_event_warning = "sound/effect/jiangbaoyin.mp3",  --有人牌少的警报音
        ui_evevt_achieve_gold = "sound/effect/huodejinbi.mp3",  --获得金币     
        ui_evevt_warning_last_one = "sound/dubbing/man_zuihouyizhangle.mp3",   --警告
        ui_evevt_warning_last_two = "sound/dubbing/man_zuihouliangzhangle.mp3",
        ui_evevt_w_warning_last_one = "sound/dubbing/zuihouyizhangle.mp3",
        ui_evevt_w_warning_last_two = "sound/dubbing/zuihouliangzhangle.mp3",  
        ui_event_table_win  = "sound/effect/shengli.mp3",  --牌桌
        ui_event_table_lost  = "sound/effect/shibai.mp3",  --牌桌 
        ui_event_table_count_down  = "sound/effect/chupaidaojishi.mp3",  --出牌倒计时的提示音    
        ui_event_lobby_wheel   = "sound/music/lucky_wheel.mp3",             
    },
    
    --事件音效
    POKER_SOUND = {
        woman_0 = "sound/dubbing/woman_3.mp3",
        woman_1 = "sound/dubbing/woman_4.mp3",
        woman_2 = "sound/dubbing/woman_5.mp3",
        woman_3 = "sound/dubbing/woman_6.mp3",
        woman_4 = "sound/dubbing/woman_7.mp3",
        woman_5 = "sound/dubbing/woman_8.mp3",
        woman_6 = "sound/dubbing/woman_9.mp3",
        woman_7 = "sound/dubbing/woman_10.mp3",
        woman_8 = "sound/dubbing/woman_J.mp3",
        woman_9 = "sound/dubbing/woman_Q.mp3",
        woman_10 = "sound/dubbing/woman_K.mp3",
        woman_11 = "sound/dubbing/woman_A.mp3",
        woman_12 = "sound/dubbing/woman_2.mp3",
        woman_13 = "sound/dubbing/woman_xiaowang.mp3",
        woman_14 = "sound/dubbing/woman_dawang.mp3",

        woman_two_pieces_0 = "sound/dubbing/woman_dui3.mp3",
        woman_two_pieces_1 = "sound/dubbing/woman_dui4.mp3",
        woman_two_pieces_2 = "sound/dubbing/woman_dui5.mp3",
        woman_two_pieces_3 = "sound/dubbing/woman_dui6.mp3",
        woman_two_pieces_4 = "sound/dubbing/woman_dui7.mp3",
        woman_two_pieces_5 = "sound/dubbing/woman_dui8.mp3",
        woman_two_pieces_6 = "sound/dubbing/woman_dui9.mp3",
        woman_two_pieces_7 = "sound/dubbing/woman_dui10.mp3",
        woman_two_pieces_8 = "sound/dubbing/woman_duiJ.mp3",
        woman_two_pieces_9 = "sound/dubbing/woman_duiQ.mp3",
        woman_two_pieces_10 = "sound/dubbing/woman_duiK.mp3",
        woman_two_pieces_11 = "sound/dubbing/woman_duiA.mp3",
        woman_two_pieces_12 = "sound/dubbing/woman_dui2.mp3",

        woman_triplet_0 = "sound/dubbing/woman_sanzhang3.mp3", 
        woman_triplet_1 = "sound/dubbing/woman_sanzhang4.mp3",
        woman_triplet_2 = "sound/dubbing/woman_sanzhang5.mp3",
        woman_triplet_3 = "sound/dubbing/woman_sanzhang6.mp3",
        woman_triplet_4 = "sound/dubbing/woman_sanzhang7.mp3",
        woman_triplet_5 = "sound/dubbing/woman_sanzhang8.mp3",
        woman_triplet_6 = "sound/dubbing/woman_sanzhang9.mp3",
        woman_triplet_7 = "sound/dubbing/woman_sanzhang10.mp3",
        woman_triplet_8 = "sound/dubbing/woman_sanzhangJ.mp3",
        woman_triplet_9 = "sound/dubbing/woman_sanzhangQ.mp3",
        woman_triplet_10 = "sound/dubbing/woman_sanzhangK.mp3",
        woman_triplet_11 = "sound/dubbing/woman_sanzhangA.mp3",
        woman_triplet_12 = "sound/dubbing/woman_sanzhang2.mp3",

        woman_3_with_1 = "sound/dubbing/woman_sandaiyi.mp3", --三带一
        woman_3_with_2 = "sound/dubbing/woman_sandaiyidui.mp3",--三带对
        woman_4_with_2 = "sound/dubbing/woman_sidaier.mp3",--四带二
        woman_4_with_2_2 = "sound/dubbing/woman_sidailiangdui.mp3",--四带俩对
        woman_airplane = "sound/dubbing/woman_feiji.mp3", --飞机
        woman_airplaneDaichibang = "sound/dubbing/woman_feijidaichibang.mp3", --飞机带翅膀
        woman_straight = "sound/dubbing/woman_shunzi.mp3",  --顺子
        woman_even_straight = "sound/dubbing/woman_liandui.mp3", --连对 even_straight
        woman_bomb = "sound/dubbing/woman_zhadan.mp3",    --炸弹
        woman_king_bomb = "sound/dubbing/woman_zhadan.mp3", --王炸

        woman_big_you_1 = "sound/dubbing/woman_guanshang.mp3",--管牌
        woman_big_you_2 = "sound/dubbing/woman_dani.mp3",
        -- woman_big_you_3 = "sound/dubbing/guanshang.mp3",

        -- woman_pass_1 = "sound/dubbing/guo.mp3", --不出
        woman_pass_1 = "sound/dubbing/woman_pass.mp3",
        woman_pass_2 = "sound/dubbing/woman_buyao.mp3",
        --龙虎斗
        -- ui_haudio_count_down    =    "sound/lhd/lhd_haudio_count_down.mp3",
        -- ui_haudio_raise   =          "sound/lhd/lhd_haudio_raise.mp3",
        -- ui_haudio_raise_100w   =     "sound/lhd/lhd_haudio_raise_100w.mp3",
        -- ui_haudio_start  =           "sound/lhd/lhd_haudio_start.mp3",


        man_0 = "sound/dubbing/man_3.mp3",
        man_1 = "sound/dubbing/man_4.mp3",
        man_2 = "sound/dubbing/man_5.mp3",
        man_3 = "sound/dubbing/man_6.mp3",
        man_4 = "sound/dubbing/man_7.mp3",
        man_5 = "sound/dubbing/man_8.mp3",
        man_6 = "sound/dubbing/man_9.mp3",
        man_7 = "sound/dubbing/man_10.mp3",
        man_8 = "sound/dubbing/man_J.mp3",
        man_9 = "sound/dubbing/man_Q.mp3",
        man_10 = "sound/dubbing/man_K.mp3",
        man_11 = "sound/dubbing/man_A.mp3",
        man_12 = "sound/dubbing/man_2.mp3",
        man_13 = "sound/dubbing/man_xiaowang.mp3",
        man_14 = "sound/dubbing/man_dawang.mp3",

        man_two_pieces_0 = "sound/dubbing/man_dui3.mp3",
        man_two_pieces_1 = "sound/dubbing/man_dui4.mp3",
        man_two_pieces_2 = "sound/dubbing/man_dui5.mp3",
        man_two_pieces_3 = "sound/dubbing/man_dui6.mp3",
        man_two_pieces_4 = "sound/dubbing/man_dui7.mp3",
        man_two_pieces_5 = "sound/dubbing/man_dui8.mp3",
        man_two_pieces_6 = "sound/dubbing/man_dui9.mp3",
        man_two_pieces_7 = "sound/dubbing/man_dui10.mp3",
        man_two_pieces_8 = "sound/dubbing/man_duiJ.mp3",
        man_two_pieces_9 = "sound/dubbing/man_duiQ.mp3",
        man_two_pieces_10 = "sound/dubbing/man_duiK.mp3",
        man_two_pieces_11 = "sound/dubbing/man_duiA.mp3",
        man_two_pieces_12 = "sound/dubbing/man_dui2.mp3",

        man_triplet_0 = "sound/dubbing/man_sanzhang.mp3", 
        man_triplet_1 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_2 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_3 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_4 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_5 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_6 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_7 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_8 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_9 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_10 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_11 = "sound/dubbing/man_sanzhang.mp3",
        man_triplet_12 = "sound/dubbing/man_sanzhang.mp3",

        man_3_with_1 = "sound/dubbing/man_sandaiyi.mp3", --三带一
        man_3_with_2 = "sound/dubbing/man_sandaiyidui.mp3",--三带对
        man_4_with_2 = "sound/dubbing/man_sidaier.mp3",--四带二
        man_4_with_2_2 = "sound/dubbing/man_sidailiangdui.mp3",--四带俩对
        man_airplane = "sound/dubbing/man_feiji.mp3", --飞机
        man_airplaneDaichibang = "sound/dubbing/man_feijidaichibang.mp3", --飞机带翅膀
        man_straight = "sound/dubbing/man_shunzi.mp3",  --顺子
        man_even_straight = "sound/dubbing/man_liandui.mp3", --连对 even_straight
        man_bomb = "sound/dubbing/man_zhadan.mp3",    --炸弹
        man_king_bomb = "sound/dubbing/man_zhadan.mp3", --王炸

        man_big_you_1 = "sound/dubbing/man_guanshang.mp3",--管牌
        man_big_you_2 = "sound/dubbing/man_guanshang.mp3",
        -- woman_big_you_3 = "sound/dubbing/guanshang.mp3",

        -- woman_pass_1 = "sound/dubbing/guo.mp3", --不出
        man_pass_1 = "sound/dubbing/man_pass.mp3",
        man_pass_2 = "sound/dubbing/man_buyao.mp3",





    },

    --图片
    IMG_HEAD_TEMPLET_RECT = "images/touxiangkuang.png", --圆角矩形蒙版
}

return SoundConfig