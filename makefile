uzblicious:
	exit
install:
	install -Dm644 uzblicious.conf.example /usr/share/uzbl/examples/config/uzblicious.conf.example
	install -Dm755 uzblicious /usr/bin/uzblicious

clean:
	exit
