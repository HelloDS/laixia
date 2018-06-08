package com.laixia.majiang.utils;

public final class ClassUtils {

    public static Class getCurClass() {
        return new RuntimeException().getStackTrace()[0].getClass();
    }

}
