
package com.laixia.majiang.net;
import java.io.*;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Date;
import java.text.SimpleDateFormat;

import com.alibaba.fastjson.JSONObject;



public class GameTcp {
    private String hostname;
    private int port;
    private String content;

    public GameTcp(String hostname, int port,String content){
        this.hostname = hostname;
        this.port = port;
        this.content = content;
    }

    public  String Do() throws Exception
    {
        String result="";
        PrintWriter out = null;
        BufferedReader in = null;
        try
        {
            Socket socket = new Socket();
            //socket链接指定的主机,超过10秒抛出链接不上异常
            socket.connect(new InetSocketAddress(hostname,port), 10000);
            // 得到请求的输出流对象
            out = new PrintWriter(socket.getOutputStream());
            // 发送请求参数
            out.print(content);
            // flush输出流的缓冲
            out.flush();
            // 定义 BufferedReader输入流来读取URL的响应
            in = new BufferedReader(new InputStreamReader(socket.getInputStream(),"UTF-8"));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
            System.out.println("获取的结果为："+result);
        }
        catch(Exception ex)
        {
            System.out.println("发送 POST 请求出现异常！"+ex);
            ex.printStackTrace();
            throw ex;
        }
        finally
        {
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }
}