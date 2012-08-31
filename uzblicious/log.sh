source ~/.config/uzbl/uzblicious.conf

dt=$(date)
msg="$1"
echo "$dt - $msg">>$del_browser_dir/uzblicious.log
