source .config/uzbl/uzblicious.conf
cat $del_browser_dir/history >  $del_browser_dir/history.bak
tac $del_browser_history.bak | awk ' !x[$0]++' > $del_browser_dir/history.rev
tac $del_browser_dir/history.rev > $del_browser_dir/history
rm -f $del_browser_dir/history.bak
rm -f $del_browser_dir/history.rev
