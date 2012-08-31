source ~/.config/uzbl/uzblicious.conf
dmenu -p ">" -i  -l 10  -nb "#333333" -nf "#888888" -sb "#285577" -sf "#ffffff" < $del_browser_dir/history | awk '{print $3}'
