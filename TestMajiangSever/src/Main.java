
import com.laixia.majiang.net.GameTcp;
import com.laixia.majiang.utils.ClassUtils;

import org.apache.log4j.Logger;

public class Main {
    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    public static void main(String[] args) {

        logger.info("hello,world");


        System.out.println("服务器启动...\n");
        GameTcp server = new GameTcp();
        server.init();
    }



}
