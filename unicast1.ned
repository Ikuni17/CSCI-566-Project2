package project2rtp;

import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.rtp.RTPHost;
import ned.DatarateChannel;


network CloudGaming
{
    parameters:
        double numrouters @prompt("Number of routers") = default(1);
        @display("bgb=475,451");
        double procDelay @unit("s") = default(1s);
    types:
        channel ethernet extends DatarateChannel
        {
            delay = normal(0.00015s, 0.00005s);
            datarate = 100Mbps;
        }
    submodules:
        client1: RTPHost {
            parameters:
                @display("i=device/laptop_l;p=234,369");
                forwarding = false;
                profileName = "inet.transportlayer.rtp.RTPAVProfile";
                destinationAddress = "server";
                portNumber = 5004;
                bandwidth = 10000;
                //@display("p=150,50");
        }
        //        client2: RTPHost {
        //            parameters:
        //                @display("i=device/laptop_l;p=331,369");
        //                forwarding = false;
        //                profileName = "inet.transportlayer.rtp.RTPAVProfile";
        //                destinationAddress = "server";
        //                portNumber = 5004;
        //                bandwidth = 10000;
        //                //@display("p=150,50");
        //        }
        server: RTPHost {
            parameters:
                @display("i=device/server_l;p=234,50");
                forwarding = false;
                profileName = "inet.transportlayer.rtp.RTPAVProfile";
                destinationAddress = "client1";
                portNumber = 5004;
                bandwidth = 10000;
                
                //@display("p=250,150");
        }
        router[numrouters]: Router {
            parameters:
                @display("i=abstract/router_l");
            gates:
                pppg[];

        }
        configurator: IPv4NetworkConfigurator {
            @display("p=58,32");
        }
    connections:
        server.pppg++ <--> ethernet <--> router[numrouters - 1].pppg++;
        client1.pppg++ <--> ethernet <--> router[0].pppg++;
        for i=1..numrouters-1 {
            router[i-1].pppg++ <--> ethernet <--> router[i].pppg++;
        }
}
