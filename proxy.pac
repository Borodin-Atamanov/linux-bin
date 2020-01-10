function FindProxyForURL(url, host) 
{
    if (dnsDomainIs(host, ".onion")) 
    {
        #return "PROXY 127.0.0.1:8118";
        return "SOCKS 127.0.0.1:9050";
    } 
    if (dnsDomainIs(host, ".i2p")) 
    {
        return "PROXY 127.0.0.1:4444";
    } 
    return "DIRECT";
}
