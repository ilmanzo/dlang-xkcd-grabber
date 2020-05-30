module xkcdclient;

import std.net.curl : get;
import std.json;
import std.conv;
import std.format : format;

class XKCDClient
{

public:
    this(int comicnumber = LATEST_COMIC)
    {
        string data = fetchJSON(comicnumber);
        jdata = parseJSON(data);
    }

    @property auto safe_title()
    {
        return jdata["safe_title"];
    }

    @property auto date()
    {
        return format!"%s-%s-%s"(jdata["day"], jdata["month"], jdata["year"]);
    }

private:

    JSONValue jdata;
    enum LATEST_COMIC = -1;
    enum baseURL = "http://xkcd.com";

    string fetchJSON(int comicnumber = LATEST_COMIC)
    {
        string url;
        if (comicnumber == LATEST_COMIC)
            url = format!"%s/info.0.json"(baseURL);
        else
            url = format!"%s/%d/info.0.json"(baseURL, comicnumber);
        return std.conv.to!string(get(url)); // convert from char[] (mutable) to string (immutable)
    }

}
