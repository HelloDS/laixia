package com.laixia.majiang.utils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.test.ChannelGroups;
import org.apache.log4j.Logger;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
import java.util.Set;

public class HttpUtils {

    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    private static final int desk_2 = 2;//2	比赛广播  3	比赛广播 5	全局广播  6	用户单播
    private static final int desk_3 = 3;
    private static final int desk_5 = 5;
    private static final int desk_6 = 6;

//    public static String sendUrlGet(String url) {
//        HttpClient client = new HttpClient();
//        HttpMethod method = new GetMethod(url);
//        client.getHttpConnectionManager().getParams().setConnectionTimeout(10000);
//        client.getHttpConnectionManager().getParams().setSoTimeout(10000);
//        try {
//            int statusCode = client.executeMethod(method);
//            System.out.println(statusCode);
//            byte[] responseBody = null;
//            responseBody = method.getResponseBody();
//            String result = new String(responseBody);
//            System.out.println(result);
//            return result;
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        return url;
//    }

//    public static Object httpGet(String url, String params) {
//        DefaultHttpClient client = new DefaultHttpClient();
//        HttpGet get = new HttpGet(url.concat("?").concat(params));
//        HttpResponse response = null;
//        try {
//            response = client.execute(get);
//        } catch (IOException ex) {
//            logger.error("httpGet  url = " + url + " | params = " + params + " | Message = "
//                    + ex.getMessage());
//            return null;
//        }
//        if (response.getStatusLine().getStatusCode() != 200) {
//            logger.error("httpGet  url = " + url + " | params = " + params + " | statusCode = "
//                    + response.getStatusLine().getStatusCode());
//            return null;
//        }
//        return null;
//    }

//    public static String convertHttpParams(List<NameValuePair> values) {
//        String result = "";
//        int valCt = values.size();
//        for (int i = 0; i < valCt; i++) {
//            NameValuePair value = values.get(i);
//            if (i == valCt - 1) {
//                result += value.getName() + "=" + value.getValue();
//            } else {
//                result += value.getName() + "=" + value.getValue() + "&";
//            }
//        }
//        return result;
//    }

    public static String sendPost(String url, String buffer2) {
        String result = "";
        HttpURLConnection httpURLConnection = null;
        InputStream inputStream = null;
        OutputStreamWriter outputStream = null;
        BufferedReader reader = null;
        StringBuffer resultBuffer = new StringBuffer();
        try {
            URL u = new URL(url);
            httpURLConnection = (HttpURLConnection) u.openConnection();
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setConnectTimeout(5000);
            httpURLConnection.setReadTimeout(5000);
            httpURLConnection.setDoInput(true);
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setUseCaches(false);
            httpURLConnection.setRequestProperty("Content-type", "application/x-www-form-urlencoded");
            httpURLConnection.connect();
            outputStream = new OutputStreamWriter(httpURLConnection.getOutputStream());
            logger.info(buffer2);
            outputStream.write(String.valueOf(buffer2));
            outputStream.flush();
            int contentLength = Integer.parseInt(httpURLConnection.getHeaderField("Content-Length"));
            if (contentLength > 0) {
                reader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream(), "utf-8"));
                String temp;
                while ((temp = reader.readLine()) != null) {
                    resultBuffer.append(temp);
                }
            }
            logger.info(resultBuffer.toString());
            result = resultBuffer.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (httpURLConnection != null) {
                httpURLConnection.disconnect();
            }
        }
        return result;
    }

    public static String url = "http://47.93.102.58:7833/linkroommsg/GatewayService/Push";
    public static String uaUrl = "http://47.93.102.58:7833/linkroommsg/GatewayService/UaPush";

    //map方式推送消息
//    public static String pushMessage(Map map, String gid, String liveid) {
//        HttpUtils utils = new HttpUtils();
//        JSONObject buffer2 = new JSONObject();
//        Set<String> keys = map.keySet();
//        for (String key : keys) {
//            buffer2.put(key, map.get(key));
//        }
//        String ary = buffer2.toString();
//        ary = ary.replaceAll("\"", "\\\\\"");
//        String ret = "{\"message\":\"[{\\\"b\\\":{\\\"ev\\\":\\\"s.dd\\\"},\\\"dest\\\":" + desk_6 + "," +
//                "\\\"userid\\\":" + map.get("pid") + ",\\\"liveid\\\":\\\"" + liveid + "\\\"," +
//                "\\\"gid\\\":\\\"" + gid + "\\\",\\\"ms\\\":" +
//                "[" + ary + "]}]\"," +
//                "\"priority\":2,\"messageFrom\":2}";
//        return utils.sendPost(url, ret);
//    }

    //json 推送消息
    public static String pushMessage(JSONObject msg, int pid, String gid, String liveid) {
        String ary = msg.toString();
        ary = ary.replaceAll("\"", "\\\\\"");
        String ret = "{\"message\":\"[{\\\"b\\\":{\\\"ev\\\":\\\"s.dd\\\"},\\\"dest\\\":" + desk_6 + "," +
                "\\\"userid\\\":" + pid + ",\\\"liveid\\\":\\\"" + liveid + "\\\"," +
                "\\\"gid\\\":\\\"" + gid + "\\\",\\\"ms\\\":" +
                "[" + ary + "]}]\"," +
                "\"priority\":2,\"messageFrom\":2}";
        return sendPost(url, ret);
    }

    //批量推送消息
    public static String pushMessage(JSONObject msg, int[] pids,int pid, String gid, String liveid) {
        String ary = msg.toString();
        ary = ary.replaceAll("\"", "\\\\\"");
        String ret = "{\"message\":\"[{\\\"b\\\":{\\\"ev\\\":\\\"s.dd\\\"},\\\"dest\\\":" + desk_6 + "," +
                "\\\"userid\\\":" + pid + ",\\\"liveid\\\":\\\"" + liveid + "\\\"," +
                "\\\"gid\\\":\\\"\\\",\\\"ms\\\":" +
                "[" + ary + "]}]\",\"uids\":" + pids + "}";
        return sendPost(uaUrl, ret);
    }

    //批量推送消息
    public static String pushMessage(JSONObject msg, int[] pids,int pid,String liveid) {
        String ary = msg.toString();
        ary = ary.replaceAll("\"", "\\\\\"");
        String ret = "{\"message\":\"[{\\\"b\\\":{\\\"ev\\\":\\\"s.dd\\\"},\\\"dest\\\":" + desk_6 + "," +
                "\\\"userid\\\":" + pid + ",\\\"liveid\\\":\\\"" + liveid + "\\\"," +
                "\\\"gid\\\":\\\"\\\",\\\"ms\\\":" +
                "[" + ary + "]}]\",\"uids\":" + pids + "}";
        return sendPost(uaUrl, ret);
    }

    //批量推送消息
    public static String pushMessage(String msg, int[] pids,String liveid) {
        String ary = msg;
        ary = ary.replaceAll("\"", "\\\\\"");
        String ret = "{\"message\":\"[{\\\"b\\\":{\\\"ev\\\":\\\"s.dd\\\"},\\\"dest\\\":" + desk_6 + "," +
                "\\\"userid\\\":0,\\\"liveid\\\":\\\"" + liveid + "\\\"," +
                "\\\"gid\\\":\\\"\\\",\\\"ms\\\":" +
                "[" + ary + "]}]\",\"uids\":" + JSONArray.toJSONString(pids) + "}";

        pushMessagecl( msg,pids,liveid );
        return "";
    }

    //批量推送消息 群发
    public static String pushMessage(JSONObject msg) {
        String ary = msg.toString();
        ary = ary.replaceAll("\"", "\\\\\"");
        String ret = "{\"message\":\"[{\\\"b\\\":{\\\"ev\\\":\\\"s.dd\\\"},\\\"dest\\\":" + desk_5 + "," +
                "\\\"ms\\\":" +
                "[" + ary + "]}]\",\"priority\":2,\"messageFrom\":2}";
        return sendPost(url, ret);
    }

    //批量推送消息
    public static String pushMessagecl(String msg, int[] pids,String liveid) {

        logger.info(msg);
        ChannelGroups.sendMes(msg);
        return "";
    }
}