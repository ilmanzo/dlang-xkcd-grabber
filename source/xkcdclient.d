module xkcdclient;

import requests;
import std.json;
import std.conv;
import std.format : format;
import std.stdio;
import std.array : split;

enum LATEST_COMIC = -1;

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
        return jdata["safe_title"].get!string;
    }

    @property auto alt()
    {
        return jdata["alt"].get!string;
    }

    @property auto date()
    {
        return format!"%s-%s-%s"(jdata["day"].get!string,jdata["month"].get!string,jdata["year"].get!string);
    }

    //infers filename from img url and return it
    string saveToDisk()
    {
        Request rq = Request();
        auto imgurl=jdata["img"].get!string;
        auto filename=split(imgurl,"/")[$-1]; // $ is the array length, -1 is the latest element
        rq.useStreaming = true;
        auto rs = rq.get(imgurl);
        auto stream = rs.receiveAsRange();
        File file = File(filename, "wb");
        while (!stream.empty)
        {
            file.rawWrite(stream.front);
            stream.popFront;
        }
        file.close();
        return filename;
    }

private:

    JSONValue jdata;

    enum baseURL = "https://xkcd.com";

    string fetchJSON(int comicnumber = LATEST_COMIC)
    {
        string url;
        if (comicnumber == LATEST_COMIC)
            url = format!"%s/info.0.json"(baseURL);
        else
            url = format!"%s/%d/info.0.json"(baseURL, comicnumber);
        return to!string(getContent(url));
    }

}
