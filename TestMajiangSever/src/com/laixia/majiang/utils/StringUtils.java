package com.laixia.majiang.utils;

import com.alibaba.fastjson.JSONArray;
import org.apache.log4j.Logger;

public class StringUtils {
    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    /**
     * JSONArray 转换成数组 int[]
     * @param ary
     * @return
     */
    public static int[] jsonAryToAry(JSONArray ary){
        if(ary == null || ary.size() == 0){
            logger.error("ary is null");
            return null;
        }
        int[] ret = new int[ary.size()];
        for(int i = 0;i < ary.size();i++){
            ret[i] = (int) ary.get(i);
        }
        return ret;
    }
}
