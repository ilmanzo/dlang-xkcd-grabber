import std.stdio;
import clid;
import xkcdclient;

// inspired from
// https://eryb.space/2020/05/27/diving-into-go-by-building-a-cli-application.html

private struct Config
{
	@Parameter("number", 'n')
	@Description("The comic number to download. Default is latest")
	int comicnumber;
	@Parameter("save", 's')
	@Description("When specified, download and save the comic to disk")
	bool save;
}


void main()
{
	auto config = parseArguments!Config();
	auto c = new XKCDClient();
	writeln(c.safe_title);
	writeln(c.date);
}
