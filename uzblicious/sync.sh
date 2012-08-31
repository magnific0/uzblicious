source ~/.config/uzbl/uzblicious.conf
echo "Synchronizing..."
resp=$(. $del_scripts_dir/fetch.sh)
denied=$(echo "$resp"|grep "Error: Access denied.")

if [ ${#denied} -gt 0 ]; then
  echo "Error: Access denied."
  exit 1
fi

echo "$resp" > $del_browser_dir/bookmarks

echo "Done."
