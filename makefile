all:
	gcc -Wall jsessiond.c `pkg-config --cflags --libs dbus-1` -ojsessiond
install:
	mkdir -p $(DESTDIR)/usr/bin $(DESTDIR)/etc/jsession
	mkdir -p $(DESTDIR)/etc/dbus-1/system.d
	cp jsession-init jsession jsessiond jsession-quit $(DESTDIR)/usr/bin
	cp jsession.conf $(DESTDIR)/etc/dbus-1/system.d
	cp conf $(DESTDIR)/etc/jsession/conf
uninstall:
	-rm $(DESTDIR)/usr/bin/jsession-init $(DESTDIR)/usr/bin/jsession
	-rm $(DESTDIR)/usr/bin/jsessiond $(DESTDIR)/usr/bin/jsession-quit
	-rm -r $(DESTDIR)/etc/jsession
