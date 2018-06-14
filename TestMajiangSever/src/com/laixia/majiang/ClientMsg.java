package com.laixia.majiang;

import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.utils.ClassUtils;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.util.CharsetUtil;
import org.apache.log4j.Logger;

import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import static io.netty.handler.codec.http.HttpResponseStatus.OK;
import static io.netty.handler.codec.http.HttpVersion.HTTP_1_1;

public abstract class ClientMsg {

    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    public transient ChannelHandlerContext ctx;

    public String liveid;
    public String gid;
    public String uid;

    public void process(JSONObject msg) throws Exception {
        businessProcess(msg);
    }
    public void endProcess() throws Exception {
        logicEndDBOperation();
    }

    public abstract void businessProcess(JSONObject msg) throws Exception ;
    public abstract void logicEndDBOperation() throws Exception ;

    public void sendError(ChannelHandlerContext ctx, HttpResponseStatus status, Exception e) {
        logger.error("Exception when process client http message", e);
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, status, Unpooled.copiedBuffer("Failure: " + status.toString() + "\r\n", CharsetUtil.UTF_8));
        response.headers().set(CONTENT_TYPE, "text/plain; charset=UTF-8");
        // Close the connection as soon as the error message is sent.
        // ctx.writeAndFlush(response).addListener(ChannelFutureListener.CLOSE);
    }

    protected void sendResponse(Object responseMsg) {
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, OK);
        response.headers().set(CONTENT_TYPE, "text/json; charset=UTF-8");
        response.headers().set("Access-Control-Allow-Origin", "*");
        String jsonString = JSONObject.toJSONString(responseMsg);
        logger.info(jsonString);
        ByteBuf buffer = Unpooled.copiedBuffer(jsonString.getBytes(CharsetUtil.UTF_8));
        response.content().writeBytes(buffer);
        buffer.release();
       // ctx.writeAndFlush(response).addListener(ChannelFutureListener.CLOSE);
    }

    protected void sendResponseFile(byte[] buffers) {
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, OK);
        response.headers().set(CONTENT_TYPE, "text/json; charset=UTF-8");
        response.headers().set("Access-Control-Allow-Origin", "*");
        ByteBuf buffer = Unpooled.copiedBuffer(buffers);
        response.content().writeBytes(buffer);
        buffer.release();
       // ctx.writeAndFlush(response).addListener(ChannelFutureListener.CLOSE);
    }

    protected void sendResponse(Object responseMsg,ChannelHandlerContext cctx) {
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, OK);
        response.headers().set(CONTENT_TYPE, "text/json; charset=UTF-8");
//        response.headers().set("Access-Control-Allow-Origin", "*");
        String jsonString = JSONObject.toJSONString(responseMsg);

        System.out.println(jsonString);
        ByteBuf buffer = Unpooled.copiedBuffer(jsonString.getBytes(CharsetUtil.UTF_8));
        response.content().writeBytes(buffer);
        buffer.release();
       // cctx.writeAndFlush(response).addListener(ChannelFutureListener.CLOSE);
    }

    //
    protected void sendMessage(Object responseMsg) {

    }


}