import std.stdio;
import clid;
import xkcdclient;

// inspired from
// https://eryb.space/2020/05/27/diving-into-go-by-building-a-cli-application.html

private struct Config
{
	@Parameter("number", 'n')
	@Description("The comic number to download. Default is latest")
	int comicnumber=xkcdclient.LATEST_COMIC;
	@Parameter("save", 's')
	@Description("When specified, download and save the comic to disk")
	bool saveImgToDisk;
}


void main()
{
	auto config = parseArguments!Config();
	writefln("Getting XKCD comic #%d",config.comicnumber);
	auto client = new XKCDClient(config.comicnumber);
	writeln("Comic info:");
	writeln("Date: ",client.date);
	writeln("Title: ",client.safe_title);
	writeln("Alt: ",client.alt);
	if (config.saveImgToDisk) {
		auto fname=client.saveToDisk();
		writeln("saved to disk: ", fname);
	}

}
