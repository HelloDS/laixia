
import com.laixia.majiang.net.GameTcp;
import com.laixia.majiang.net.GameTcpClient;
import com.laixia.majiang.utils.ClassUtils;

import org.apache.log4j.Logger;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Timer;
import java.util.TimerTask;

public class Main {
    private static Logger logger = Logger.getLogger(ClassUtils.getCurClass());

    private  static GameTcp server = null;

    private static String hostname = "192.168.79.1";
    private static int port = 10003;
    private static String content = "sssss";
    public static void main(String[] args)
    {
        ServerSocket sk= null;
        try {
            sk = new ServerSocket(port);

        } catch (IOException e) {
            e.printStackTrace();
        }
        while(true)
        {
            Socket s= null;
            try {
                s = sk.accept();
            } catch (IOException e) {
                e.printStackTrace();
            }
            new Thread(new GameTcp(s)).start();
        }
    }
}



//        TimerTask task = new TimerTask() {
//            @Override
//            public void run() {
//                System.out.println("Hello !!!");
//                if ( server == null) {
//                    return;
//                }
//                else
//                {
//                    server.toclent();
//                }
//            }
//        };