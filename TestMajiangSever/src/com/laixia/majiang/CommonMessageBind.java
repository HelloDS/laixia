package com.laixia.majiang;

import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.common.ResponseResult;
import com.laixia.majiang.common.StatusCode;
import com.laixia.majiang.utils.ClassUtils;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.util.CharsetUtil;
import org.apache.log4j.Logger;

import java.util.HashMap;
import java.util.Map;

import static com.sun.deploy.net.HttpRequest.CONTENT_TYPE;
import static io.netty.handler.codec.http.HttpVersion.HTTP_1_1;
import static io.netty.handler.codec.rtsp.RtspResponseStatuses.OK;

public class CommonMessageBind {

    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    protected static Map<String, ClientMsg> commonHandlerMap = new HashMap<>();

    public void register(String msgId, ClientMsg Handler) {
        commonHandlerMap.put(msgId, Handler);
    }

    public void processMessage(JSONObject msg, ChannelHandlerContext ctx){
        if (msg != null){
            if(!msg.containsKey("b")) return;
            JSONObject b = msg.getJSONObject("b");
            if(!b.containsKey("ev")) return;
            String msgId = b.getString("ev");
            JSONObject data = msg.getJSONArray("mc").getJSONObject(0);
            if (!commonHandlerMap.containsKey(msgId)) {
                logger.info("发现未知消息" + msgId);
                sendResponse(new ResponseResult(StatusCode.FAILURE, StatusCode.FAILURE_MSG),ctx);
                return;
            }
            ClientMsg handler = commonHandlerMap.get(msgId);
            handler.ctx = ctx;
            logger.info("消息："+msg);
            if(msg.containsKey("gid")){
                handler.gid = msg.getString("gid");
            }
            if(msg.containsKey("liveid")){
                handler.liveid = msg.getString("liveid");
            }
            if(msg.containsKey("userid")){
                handler.uid = msg.getString("userid");
            }
            try {
                handler.process(data);
            } catch (Exception e) {
                logger.error(e + "processMessage  handler.process(msg)");
            }finally {
                try {
                    ctx.close();
                } catch (Exception e) {
                    logger.error(e + "processMessage  handler.endProcess(msg)");
                }
            }
        }
    }

    private static CommonMessageBind instance = new CommonMessageBind();

    public static CommonMessageBind getInstance() {
        return instance;
    }

    protected void sendResponse(Object responseMsg,ChannelHandlerContext ctx) {
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, OK);
        response.headers().set(CONTENT_TYPE, "text/json; charset=UTF-8");
        response.headers().set("Access-Control-Allow-Origin", "*");
        String jsonString = JSONObject.toJSONString(responseMsg);
        logger.info(jsonString);
        ByteBuf buffer = Unpooled.copiedBuffer(jsonString.getBytes(CharsetUtil.UTF_8));
        response.content().writeBytes(buffer);
        buffer.release();
        ctx.writeAndFlush(response).addListener(ChannelFutureListener.CLOSE);
    }


    public static void SeleName(String str, JSONObject js)
    {
        for(String key : commonHandlerMap.keySet())
        {
            ClientMsg ms = commonHandlerMap.get(key);
            if (key.equals(str))
            {
                try {
                    ms.businessProcess(js);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }


}