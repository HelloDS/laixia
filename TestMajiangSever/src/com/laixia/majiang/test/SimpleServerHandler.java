package com.laixia.majiang.test;
  

import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.CommonMessageBind;
import com.laixia.majiang.utils.TablesUtils;
import com.laixia.majiang.vo.TableInstance;
import com.laixia.majiang.vo.TablePlayers;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.Channel;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.channel.group.ChannelGroup;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

public class SimpleServerHandler extends ChannelInboundHandlerAdapter {

    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private static final AtomicInteger response = new AtomicInteger();

    @Override  
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {


         String body=(String)msg;
//         System.out.println("服务端收到："+body+"，次数:");
//         SimpleDateFormat  dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//         String time=dateFormat.format(new Date());
//         String res="来自与服务端的回应,时间:"+ time;
//         ByteBuf resp=Unpooled.copiedBuffer(res.getBytes());
//         ctx.writeAndFlush(resp);


//        System.out.print("---------------------msg"+msg);
//        ByteBuf result = (String)msg;
//        byte[] result1 = new byte[result.readableBytes()];
//        // msg中存储的是ByteBuf类型的数据，把数据读取到byte[]中
//        result.readBytes(result1);
//        String resultStr = new String(result1);
//        // 接收并打印客户端的信息
//        System.out.println("接收并打印客户端的信息:" + resultStr);
//        // 释放资源，这行很关键
//        result.release();

        //将json字符串转化为JSONObject
        JSONObject  jsobj = JSONObject.parseObject(body);
        int msgid = jsobj.getIntValue("msgid");
        if(msgid == 1001) // 绑定id
        {
            int id = jsobj.getIntValue("id");
            Channel ch = ctx.channel();
            if(ch != null) {
                ChannelGroups.add(id,ch);
                if(ChannelGroups.size()== 4 ) //
                {
                    CommonMessageBind.getInstance().SeleName("create_poker",new JSONObject());
                }
            }
            else{
                System.out.print("channelActive 获取通道出错===");
            }
        }
        else if (msgid == 1002)
        {
            JSONObject info = jsobj;
            CommonMessageBind.getInstance().SeleName("op_card",info);
        }
        //else if()
    }  
  
    @Override  
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {  
        // 当出现异常就关闭连接  
        cause.printStackTrace();  
        ctx.close();  
    }  
  
    @Override  
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {  
        ctx.flush();  
    }

    // 通道激活时触发，当客户端connect成功后，服务端就会接收到这个事件，从而可以把客户端的Channel记录下来，供后面复用
    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {

    }
}









//        // 向客户端发送消息
//        String response = "hello client!aaaaa----";
//        // 在当前场景下，发送的数据必须转换成ByteBuf数组
//        ByteBuf encoded = ctx.alloc().buffer(4 * response.length());
//        encoded.writeBytes(response.getBytes());
//        ctx.write(encoded);
//        ctx.flush();


//        for(Channel channel:CHANNEL_GROUP){
//            String response = "hello client!aaaaa----";
//            // 在当前场景下，发送的数据必须转换成ByteBuf数组
//            ByteBuf encoded = ctx.alloc().buffer(4 * response.length());
//            encoded.writeBytes(response.getBytes());
//
//            channel.writeAndFlush(encoded);
//        }




