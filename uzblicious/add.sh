source ~/.config/uzbl/uzblicious.conf
url=$UZBL_URI
title=$UZBL_TITLE
tags=$(. $del_scripts_dir/prompt_tags.sh $url)

. $del_scripts_dir/log.sh "New Bookmark: $url (tags: $tags, title: $title)"

sed -i  "1i $url $tags" $del_browser_dir/bookmarks

# sync delicious
if [ ${#user} -gt 0 ]; then

  echo "new request: https://$user:$passwd@api.del.icio.us/v1/posts/add" -d "url=$url&description=$title&tags=$tags "
  response=$(curl -s "https://$user:$passwd@api.del.icio.us/v1/posts/add" -d "url=$url&description=$title&tags=$tags")
  done=$(echo "$response"|grep "code=\"done\"")

  if [ ${#done} -eq 0 ]; then
    . $del_scripts_dir/log.sh "Error occured adding '$url' to delicious account ($user)."
    echo $response
  fi

else
  . $del_scripts_dir/log.sh "'$url' not added to Delicious."
fi
