uzblicious
==============

Copyright
-------------

[magnific0](http://www.github.com/magnific0) (c) Copyright 2012
Licenced under the GPLv3

About
--------------

uzblicious (usable-icious) is a script designed to integrate Delicious bookmarking service with the uzbl browser. It also aims at replacing and integrating the search and launch functionality of UZBL.

Features
--------------

Below the basic operation of uzblicious is explained. These include the core features, which are: selecting bookmarks, following urls and searching. For more advanced operation see Usage.

### Selecting bookmarks and running uzblicious

A favorite bookmark is easily selected with DMENU's on-the-fly look-up ability. Fire up uzblicious and type a search string (and navigate with your cursors) to select/highlight the desired match and hit `<Enter>` to visit. Whatever you type will be matched to the addresses, titles and/or tags of your bookmarks. 

### Following a URL

Simply type the address of the website you would like to visit. You do not have to type strict urls, e.g. `google.com` will do just fine. Mind that bookmarks will be given preference, so if your desired destination also matches a previously bookmarked item then selection (`<Enter>`) will follow your bookmark instead of your typed address (it was interpreted as a search word and it matched with a bookmark). To confirm what is typed and not what is high-lighted simply press `<Shift><Enter>`.

### Searching the web

To search the web with your favorite browser simply type some keywords and hit `<Enter>`. Mind that, as with following a URL, if your search string matches a bookmark hitting return will open the bookmark instead of launching a search. To confirm what is typed and not what is high-lighted simply press `<Shift><Enter>`.

### Selecting a search engine

To select a specific search engine, simply prefix your query by the search engine handle. For istance to search with Duck Duck Go, type `ddg:some test query`.

Installation
--------------

1. Use the makefile to install uzblicious on your computer

		make install

2. Edit uzbl config file with your favourite text editor, like so:

		nano $XDG_CONFIG_HOME/uzbl/config
	
	and add the following lines so uzbl will spawn the script:

		# The following command will invoke the add tag command     	    
	
		@cbind d = spawn uzblicious -a

		# Browse bookmarks, urls and search queries in a new window
	
		@cbind U = spawn uzblicious -n

		# Browse bookmarks, urls and search queries in current window	

		@cbind u = spawn uzblicious

		# Browse history in a new window

		@cbind H = spawn uzblicious -b history -n

		# Browse history in current window

		@cbind h = spawn uzblicious -b history

	*NOTE* make sure to comment out any current bindings to the afore mentioned keys to prevent any problems. Additionally you could set-up bindings to other functions, such as sync and clear history.

3. Fetch your bookmarks

		uzblicious -s

	The first time uzblicious is synced it will make a local configuration file. If you started sync from the console you will be taken through an ``interactive'' setup. Otherwise please be sure to edit and setup your Delicious login information accordingly:

		nano $XDG_CONFIG_HOME/uzbl/uzblicious.conf

4. *OPTIONAL* Regularly synchronizing will make sure your local bookmarks are up-to-date. Every time you add a bookmark it is commited to both delicious and your local cache. However, if you add delicious bookmarks on the web, mobile device, i.e. anywhere other than through uzblicious.sh, it is not added to you local cache. For this to happen you must invoke the synchronisation command. It might therefore be handy to add the command above to your `.xinitrc` or to a cron job. You can also synchronize your bookmarks every time you launch uzbl. The script will check whether there is have been changes made, so this will generate just moderate amounts additional traffic. Somewhere in your uzbl config (`~/.config/uzbl/config`) add:

		spawn uzblicious -s

Usage
--------------

	uzblicious [-hcsn] [-b [<browse_source>]] [-a [<url>]]

The following command line options are allowed:

- `-h` Display help

- `-b [<browse_source>]` Browse source (bookmarks by default)

- `-n` New window (mandatory if not spawned from within UZBL)

- `-s` Sync bookmarks with delicious

- `-a [<url>]` Add url to bookmarks (optional if spawned from within UZBL)

- `-c` Clear history

Examples:

	uzblicious -b history -n

	uzblicious -a http://www.google.com

Troubleshooting
--------------

If you are  runnig into problems please make sure to check the log file for any hints.

	cat $XDG_DATA_HOME/uzbl/uzblicious.log

If that does not work try invoking uzblicious from the commandline.

	uzblicious -h