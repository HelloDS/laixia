
package com.laixia.majiang.net;
import java.io.*;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Timer;
import java.util.TimerTask;


public class GameTcp implements Runnable
{
        private Socket s;
        public GameTcp(Socket s)
        {
            this.s=s;
        }

        public void run()
        {
            try
            {
                System.out.println(s.getInetAddress().getHostAddress()+".......conneted");
                BufferedReader fr = new BufferedReader(new InputStreamReader(s.getInputStream()));
                PrintWriter w = new PrintWriter(s.getOutputStream(),true);


                StringBuilder builder = new StringBuilder();
                String line=null;
                while((line=fr.readLine())!=null)
                {
                    builder.append(line);
                    w.println(line);
                    System.out.print(builder);
                }

                fr.close();
                //w.close();
            }
            catch(Exception e)
            {
                System.out.println("服务端错误");
            }
        }
}
