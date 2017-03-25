package project2rtp;

import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.rtp.RTPHost;
import ned.DatarateChannel;


network CloudGaming
{
    @display("bgb=475,451");
    types:
        channel ethernet extends DatarateChannel
        {
            delay = normal(0.00015s, 0.00005s);
            datarate = 100Mbps;
        }
    submodules:
        client: RTPHost {
            parameters:
                @display("i=device/laptop_l;p=234,369");
                forwarding = false;
                profileName = "inet.transportlayer.rtp.RTPAVProfile";
                destinationAddress = "server";
                portNumber = 5004;
                bandwidth = 10000;
                //@display("p=150,50");
        }
        server: RTPHost {
            parameters:
                @display("i=device/server_l;p=234,94");
                forwarding = false;
                profileName = "inet.transportlayer.rtp.RTPAVProfile";
                destinationAddress = "client";
                portNumber = 5004;
                bandwidth = 10000;
                //@display("p=250,150");
        }
        router1: Router {
            parameters:
                @display("p=234,226");
            gates:
                pppg[];

        }
        configurator: IPv4NetworkConfigurator {
            @display("p=58,32");
        }
    connections:
        server.pppg++ <--> ethernet <--> router1.pppg++;
        client.pppg++ <--> ethernet <--> router1.pppg++;
}
