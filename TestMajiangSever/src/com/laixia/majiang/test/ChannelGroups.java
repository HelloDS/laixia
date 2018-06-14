package com.laixia.majiang.test;

import io.netty.buffer.ByteBuf;
import io.netty.channel.Channel;
import io.netty.channel.group.ChannelGroup;
import io.netty.channel.group.ChannelGroupFuture;
import io.netty.channel.group.ChannelMatcher;
import io.netty.channel.group.DefaultChannelGroup;
import io.netty.util.concurrent.GlobalEventExecutor;

import java.util.HashMap;
import java.util.Map;

public class ChannelGroups
{
 
    private static final ChannelGroup CHANNEL_GROUP = new DefaultChannelGroup(GlobalEventExecutor.INSTANCE);

    private static Map<Integer,Channel> ChannelMap = new HashMap<Integer,Channel>();

    public static void add(Integer it,Channel channel) {
        CHANNEL_GROUP.add(channel);
        ChannelMap.put(it,channel);
    }
     
    public static ChannelGroupFuture broadcast(Object msg) {
        return CHANNEL_GROUP.writeAndFlush(msg);
    }
     
    public static ChannelGroupFuture broadcast(Object msg, ChannelMatcher matcher) {
        return CHANNEL_GROUP.writeAndFlush(msg, matcher);
    }
     
    public static ChannelGroup flush() {
        return CHANNEL_GROUP.flush();
    }
     
    public static boolean discard(Channel channel) {
        return CHANNEL_GROUP.remove(channel);
    }
     
    public static ChannelGroupFuture disconnect() {
        return CHANNEL_GROUP.disconnect();
    }
     
    public static ChannelGroupFuture disconnect(ChannelMatcher matcher) {
        return CHANNEL_GROUP.disconnect(matcher);
    }
     
    public static boolean contains(Channel channel) {
        return CHANNEL_GROUP.contains(channel);
    }
     
    public static int size() {
        return ChannelMap.size();
    }

    // 发送数据给全部人
    public static void sendMes( String msg){
        if(ChannelMap.size()<=0)return;
        for(Integer key : ChannelMap.keySet())
        {
            Channel channel = ChannelMap.get(key);
            String response = msg+"\n";
            // 在当前场景下，发送的数据必须转换成ByteBuf数组 这个能发送成功
            ByteBuf encoded = channel.alloc().buffer(4 * response.length());
            encoded.writeBytes(response.getBytes());
            channel.writeAndFlush(encoded);

        }
    }
    // 发送数据给指定的人
    public static void sendMes( String msg,int[] arruid){
        if(ChannelMap.size()<=0)
        {
            return;
        }
        for (int j = 0;j < arruid.length; j++)
        {
            for(Integer key : ChannelMap.keySet())
            {
                if (arruid[j] == key)
                {
                    Channel channel = ChannelMap.get(key);
                    String response = msg;
                    // 在当前场景下，发送的数据必须转换成ByteBuf数组
                    ByteBuf encoded = channel.alloc().buffer(4 * response.length());
                    encoded.writeBytes(response.getBytes());
                    channel.writeAndFlush(encoded);
                }
            }
        }

    }
}