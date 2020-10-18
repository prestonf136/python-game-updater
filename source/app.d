import std.stdio;
//see libfuncs,d
import libfuncs;
import dawait;

import gtk.Main;
import gtk.Builder;

import std.conv;
import std.process: ProcessException;
import core.thread : Thread,dur;

import gtk.Window;
import gtk.Button;
import gtk.Label;

string serversion =  "v0.0.1";

void main(string[] args)
{	

	Main.init(args);

	Builder builder = new Builder();
	builder.addFromFile("uimain.glade");
	builder.connectSignals(null);

	Window Window = cast(Window)builder.getObject("Window");
	Window.showAll();

	//TODO: if statement to change button to play or download
	Button btn = cast(Button)builder.getObject("Button");
	

	if (CheckVers(serversion)) {
		btn.setLabel("Play!");
	} else {
		btn.setLabel("Download");
	}
	Main.run();
}

extern(C) void on_Window_destroy() {
	Main.quit();
}

//TODO: download or run file depending on version number
extern(C) void on_Button_clicked(GtkButton *button) {
	Button b = new Button(button);
	if (b.getLabel() == "Play!") {
		try {
			PlayFiles();
		} catch(ProcessException s) {

			b.setLabel("error: please redownload");
		}
	} else {
		try {
			b.setSensitive(false);
			startScheduler({
				DownloadFiles();
			});
			b.setLabel("Play!");
			b.setSensitive(true);
		} finally {
			//poop;
		}
	}
}