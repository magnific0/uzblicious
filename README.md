About:
uzblicious (usable-icious) is a set of scripts designed to integrate Delicious 
bookmarking service with the uzbl browser. 

Installation:

1. Copy the uzblicious folder to ~/.local/share/uzbl/scripts/

2. Copy and edit uzblicious.conf to ~/.config/uzbl/, set up your account name 
and password.

3. Edit uzbl config (~/.config/uzbl/config) and add the following lines so uzbl 
will invoke the scripts:

set del_scripts_dir = /home/wacko/.local/share/uzbl/scripts/uzblicious

@cbind d = spawn @del_scripts_dir/add.sh

@cbind U = spawn @del_scripts_dir/browse-new.sh

@cbind u = spawn @del_scripts_dir/browse.sh

@cbind H = spawn @del_scripts_dir/browse-history-new.sh

@cbind h = spawn @del_scripts_dir/browse-history.sh
4. Make sure to comment out any current bindings to the afore mentioned keys to 
prevent any problems. 

5. Sync your bookmarks

cd ~/.local/share/uzbl/scripts/uzblicious/

./sync.sh


Todo:

1. Syncing does not happen automatically yet.

2. Not all scripts are used

3. Sorting of history should be reversed

4. End adding tags for a new link on just blank tag

5. Add some setup
