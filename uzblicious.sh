#!/bin/bash
# uzblicious
# (c) 2012 magnific0 (http://www.github.com/magnific0)
# released under GPLv3
usage()
{
cat << EOF
usage: $0 [-hcsn] [-b [<browse_source>]] [-a [<url>]]

This script will control bookmarking and history for UZBL

OPTIONS:
   -h      Show this message
   -b      Browse source (bookmarks by default)
   -n      New window
   -s      Sync bookmarks with delicious
   -a      Add new bookmarks (can only be spawned from within UZBL)
   -c      Clean history

EXAMPLES:
uzblicious -b history -n
uzblicious -a http://www.google.com

EOF
}

log()
{
    dt=$(date)
    msg="${1}"
    echo "$dt - $msg">>$del_browser_dir/uzblicious.log
}

clean()
{
    cat $del_browser_dir/history >  $del_browser_dir/history.bak
    tac $del_browser_dir/history.bak | awk ' !x[$0]++' > $del_browser_dir/history.rev
    tac $del_browser_dir/history.rev > $del_browser_dir/history
    rm -f $del_browser_dir/history.bak
    rm -f $del_browser_dir/history.rev
    exit
}

add()
{
    url=$UZBL_URI
    title=$UZBL_TITLE

    resp=$(curl "https://$user:$passwd@api.del.icio.us/v1/posts/suggest?url=$url" -s)

    if echo "$resp" | grep "<result code=\"access denied\"/>" >/dev/null; then 
	echo "Error: Access denied."
	log "ERROR while fetching bookmarks from delicious. (Access denied)"
	exit 1
    fi

    recoms=`echo "$resp" | sed 's/</\n</g' | sed 's/\/>/\/>\n/g' | grep tag | sed 's/<[^>]*tag\="\([^"]*\)"[^>]*\/>/\1/g'`

    prompt=1

    while [  $prompt -eq 1 ]; do
	tag=$(echo "$recoms" | dmenu -p "Tags for $url:" $dmenu_args_colors)
  
	if [ ${#tag} -lt 1 ]; then
	    prompt=0
	else
	    tags="$tags$tag, "
	    recoms=$(echo "$recoms"|sed "/$tag/d")
	fi
    done

    log "START adding new bookmark: $url (tags: $tags, title: $title)"
    
    if $abort_on_zero_tags && [ -z "$tags" ]; then
	log "ERROR no tags were supply aborting."
    else
	sed -i  "1i $url $tags" $del_browser_dir/bookmarks

        # sync delicious
	response=$(curl -s "https://$user:$passwd@api.del.icio.us/v1/posts/add" -d "url=$url&description=$title&tags=$tags")
	if echo "$response" | grep "code=\"done\"" >/dev/null; then
	    log "DONE adding new bookmark"
	else
	    log "ERROR occured adding '$url' to delicious account ($user): $response"
	fi
    fi
    exit
}

sync()
{
    log "START fetching bookmarks from delicious. User: $user"

    resp=$(curl -s "https://$user:$passwd@api.del.icio.us/v1/posts/all")

    if echo "$resp" | grep "<result code=\"access denied\"/>" >/dev/null; then 
	echo "Error: Access denied."
	log "ERROR while fetching bookmarks from delicious. (Access denied)"
	exit 1
    fi

    echo "$resp" | sed 's/<post/\n<post/g' | sed 's/\/>/\/>\n/g' | grep href | sed 's/<[^>]*href\="\([^"]*\)"[^>]*tag\="\([^"]*\)"[^>]*\/>/\1 \2/g' > $del_browser_dir/bookmarks

    log "DONE fetching bookmarks from delicious."
    exit
}

# some defaults for browsing
BRSOURCE=bookmarks
NEWWINDOW=false

# read configuration
source ~/.config/uzbl/uzblicious.conf

while getopts hab:ncs o
do	case "$o" in
	h) 
	    usage
	    exit 1;;
	a)
	    if [ ! -z $2 ]; then
		UZBL_URI="$2"
		UZBL_TITLE=`wget --quiet -O - $UZBL_URI | sed -n -e 'H;${x;s!.*<head[^>]*>\(.*\)</head>.*!\1!;tnext};b;:next;s!.*<title>\(.*\)</title>.*!\1!p'`
	    fi
	    add
	    ;;
	b)  
	    BRSOURCE="$OPTARG"
	    ;;
	s)  
	    sync
	    ;;
	n)  
	    NEWWINDOW=true;;
	c)
	    clean
	    ;;
	[?])
	    usage
	    exit 1;;
	esac
done

if [ $BRSOURCE == "history" ]; then
    # get choice back from history
    URL=`sort -r $del_browser_dir/history | dmenu ${dmenu_args_colors} ${dmenu_args_browse} | awk '{print $3}'`
else
    # get the choice back from dmenu and extract very first "word"
    URL=`dmenu ${dmenu_args_colors} ${dmenu_args_browse} < $del_browser_dir/bookmarks`
    URL_1=`echo $URL | awk '{print $1}'`

    # match the input to see if url, 
    # http://www.example.com www.example.com example.com are all allowed
    URLRGX='^((([hH][tT][tT][pP][sS]?|[fF][tT][pP])\:\/\/)?([\w\.\-]+(\:[\w\.\&%\$\-]+)*@)?((([^\s\(\)\<\>\\\"\.\[\]\,@;:]+)(\.[^\s\(\)\<\>\\\"\.\[\]\,@;:]+)*(\.[a-zA-Z]{2,4}))|((([01]?\d{1,2}|2[0-4]\d|25[0-5])\.){3}([01]?\d{1,2}|2[0-4]\d|25[0-5])))(\b\:(6553[0-5]|655[0-2]\d|65[0-4]\d{2}|6[0-4]\d{3}|[1-5]\d{4}|[1-9]\d{0,3}|0)\b)?((\/[^\/][\w\.\,\?'\''\\\/\+&%\$#\=~_\-@]*)*[^\.\,\?\"'\''\(\)\[\]!;<>{}\s\x7F-\xFF])?)$'

    if echo "$URL_1" | grep -Pe $URLRGX >/dev/null; then 
	URL=$URL_1
    else
        # match the specified search engine
	for i in $(eval echo {0..`expr ${#search_handlers[@]} - 1`..2}); do
	    if echo "$URL_1" | egrep ${search_handlers[i]} >/dev/null; then
	        #get the search url from array and extract keywords
		ARG=`echo $URL | awk -F: '{for (i=2; i<=NF; i++) print $i}'`
		URL=${search_handlers[`expr $i + 1`]}
		break
	    fi 
	done

         # none found: take the first (default) search engine
	if [ -z $ARG ]; then
	    ARG=$URL
	    URL=${search_handlers[1]}
	    
	fi

        # function to encode the keywords
	rawurlencode() {
	    local string="${1}"
	    local strlen=${#string}
	    local encoded=""

	    for (( pos=0 ; pos<strlen ; pos++ )); do
		c=${string:$pos:1}
		case "$c" in
		    [-_.~a-zA-Z0-9] ) 
			o="${c}" 
			;;
		    * ) 
			printf -v o '%%%02x' "'$c"
		esac
		encoded+="${o}"
	    done
	    ARG="${encoded}"
	}

        # encode the keywords and create url
	rawurlencode "$ARG"
	URL=`echo $URL | sed "s/%s/$ARG/g"`
    fi
fi



# if a URL is set
if [ ! -z $URL ]; then
  # see if a new window is required
  if $NEWWINDOW; then
    eval "uzbl-browser \"$URL\" 2> /dev/null"
  else    
    echo "uri $URL" | socat - "unix-connect:$UZBL_SOCKET"
  fi
else
    echo "no proper url was returned"
    usage
fi

exit
