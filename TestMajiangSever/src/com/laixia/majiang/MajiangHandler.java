package com.laixia.majiang;

import com.alibaba.fastjson.JSONObject;
import com.laixia.majiang.utils.ClassUtils;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.util.CharsetUtil;
import org.apache.log4j.Logger;

import java.io.UnsupportedEncodingException;

import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import static io.netty.handler.codec.http.HttpVersion.HTTP_1_1;

public class MajiangHandler extends SimpleChannelInboundHandler {

    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, Object msg){
        FullHttpRequest request = (FullHttpRequest) msg;
        ByteBuf directByteBuf = request.content();
        int contentsLength = directByteBuf.readableBytes();
        byte[] contents = new byte[contentsLength];
        directByteBuf.readBytes(contents);
        String obj = null;
        try {
            obj = new String(contents, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        try {
            JSONObject ret = JSONObject.parseObject(obj);
            CommonMessageBind.getInstance().processMessage(ret, ctx);
        } catch (Exception e) {
            logger.error(e);
        }
    }

    public void sendError(ChannelHandlerContext ctx, HttpResponseStatus status) {
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, status, Unpooled.copiedBuffer("Failure: " + status.toString() + "\r\n", CharsetUtil.UTF_8));
        response.headers().set(CONTENT_TYPE, "text/plain; charset=UTF-8");
        ctx.writeAndFlush(response).addListener(ChannelFutureListener.CLOSE);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        logger.error("Exception in http pipeline", cause);
        ctx.close();
    }

    public void handlerAdded(ChannelHandlerContext ctx) throws Exception {
        super.handlerAdded(ctx);
    }

    /*
     * (non-Javadoc)
     * .覆盖了 handlerRemoved() 事件处理方法。
     * 每当从服务端收到客户端断开时
     */
    public void handlerRemoved(ChannelHandlerContext ctx) throws Exception {
        super.handlerRemoved(ctx);
    }

    @Override
    public boolean isSharable() {
        return true;
    }

}
