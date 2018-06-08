package com.laixia.majiang.common;

public class ResponseResult {


    private int dm_error;

    private String error_msg;


    public ResponseResult(int dm_error, String error_msg) {
        this.dm_error = dm_error;
        this.error_msg = error_msg;
    }

    public int getDm_error() {
        return dm_error;
    }

    public void setDm_error(int dm_error) {
        this.dm_error = dm_error;
    }

    public String getError_msg() {
        return error_msg;
    }

    public void setError_msg(String error_msg) {
        this.error_msg = error_msg;
    }
}