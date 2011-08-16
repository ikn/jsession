all:
	gcc -Wall jsessiond.c `pkg-config --cflags --libs dbus-1` -ojsessiond
install:
	mkdir -p $(DESTDIR)/usr/bin $(DESTDIR)/etc/dbus-1/system.d
	mkdir -p $(DESTDIR)/etc/jsession/startup
	cp jsession jsessiond jsession-quit $(DESTDIR)/usr/bin
	cp jsession.conf $(DESTDIR)/etc/dbus-1/system.d
	cp conf $(DESTDIR)/etc/jsession/conf
uninstall:
	-rm $(DESTDIR)/usr/bin/jsession $(DESTDIR)/usr/bin/jsessiond
	-rm $(DESTDIR)/usr/bin/jsession-quit
	-rm $(DESTDIR)/etc/dbus-1/system.d/jsession.conf
	-rm -r $(DESTDIR)/etc/jsession
