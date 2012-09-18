uzblicious:
	exit
install:
	install -Dm600 uzblicious.conf ${XDG_CONFIG_HOME}/uzbl/uzblicious.conf
	install -Dm755 uzblicious.sh ${XDG_DATA_HOME}/uzbl/scripts/uzblicious.sh

clean:
	exit
