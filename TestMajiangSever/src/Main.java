import cn.laixia.module.base.xml.initialize.InitizlizeManager;
import com.laixia.majiang.CommonMessageBind;
import com.laixia.majiang.MajiangHandler;

import com.laixia.majiang.handler.ChangeMJInfoHandler;
import com.laixia.majiang.handler.CreatePokerInfoHandler;

import com.laixia.majiang.Task.ThinkTask;

import com.laixia.majiang.handler.OperationHandler;
import com.laixia.majiang.handler.TestHandler;
import com.laixia.majiang.test.SimpleServer;
import com.laixia.majiang.utils.ClassUtils;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;  
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.http.HttpObjectAggregator;
import io.netty.handler.codec.http.HttpRequestDecoder;
import io.netty.handler.codec.http.HttpResponseEncoder;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Main {
    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    public static void main(String[] args) {

        InitizlizeManager.binesssConfigInit("redis");
        handlerInit();
        ThinkTask.getInstance().init();
        //serverInit();
        initgamesever();

 
//        List<Integer> in = new ArrayList<>();
//        in.add(5);
//        in.add(0);
//        in.add(0);
//        in.add(0);
//        in.add(8);
//        in.add(8);
//        in.add(8);
//        in.add(8);
//        boolean ret = false;
//        Collections.sort(in);
//        int total = 1;
//        for (int i = 0; i < in.size() - 1; i++) {
//            if (in.get(i) == in.get(i + 1)) {
//                total = total + 1;
//            }
//            else
//            {
//                total = 1;
//            }
//            if (total == 4) {
//                ret = true;
//                break;
//            }
//        }
    }

    private static void  serverInit() {
        EventLoopGroup boss = new NioEventLoopGroup();
        EventLoopGroup worker = new NioEventLoopGroup();
        ServerBootstrap b = new ServerBootstrap();
        b.channel(NioServerSocketChannel.class);
        b.group(boss, worker);
        b.childHandler(new ChannelInitializer<SocketChannel>() {
            @Override
            protected void initChannel(SocketChannel ch) throws Exception {
                ChannelPipeline pipeline = ch.pipeline();
                pipeline.addLast("encoder", new HttpResponseEncoder());
                pipeline.addLast("decoder", new HttpRequestDecoder());
                pipeline.addLast("aggregator", new HttpObjectAggregator(655360000));
                pipeline.addLast("deserializer", new MajiangHandler());
            }
        });
        final int PORT = 12345;
        b.option(ChannelOption.TCP_NODELAY, true);
        b.childOption(ChannelOption.SO_KEEPALIVE, true);
        try {
            ChannelFuture f = b.bind(PORT).sync();
            f.channel().closeFuture().sync();
            logger.info("服务器初始化完毕...");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }finally {
            worker.shutdownGracefully();
            boss.shutdownGracefully();
        }
    }


    private static void initgamesever(){
        try {
            SimpleServer.mainF();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    private static void handlerInit() {
        CommonMessageBind.getInstance().register("test", new TestHandler());
        CommonMessageBind.getInstance().register("op_card", new OperationHandler());
        CommonMessageBind.getInstance().register("create_poker", new CreatePokerInfoHandler());
        CommonMessageBind.getInstance().register("change_mj", new ChangeMJInfoHandler());
        logger.info("handler加载完成");
    }

}
