all:
	gcc -Wall jsession.c -ojsession
	gcc -Wall jsessiond.c `pkg-config --cflags --libs dbus-1` -ojsessiond
install:
	mkdir -p $(DESTDIR)/usr/bin $(DESTDIR)/etc/jsession
	cp jsession-init jsession jsessiond jsession-quit $(DESTDIR)/usr/bin
	cp jsession.conf /etc/dbus-1/system.d
	cp conf $(DESTDIR)/etc/jsession/conf
uninstall:
	-rm $(DESTDIR)/usr/bin/jsession-init $(DESTDIR)/usr/bin/jsession
	-rm $(DESTDIR)/usr/bin/jsessiond $(DESTDIR)/usr/bin/jsession-quit
	-rm -r $(DESTDIR)/etc/jsession
