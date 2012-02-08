all:
	gcc $(CFLAGS) `pkg-config --cflags --libs dbus-1` -Wall jsessiond.c \
		-ojsessiond
install:
	mkdir -p "$(DESTDIR)/usr/bin" "$(DESTDIR)/etc/dbus-1/system.d" \
		"$(DESTDIR)/etc/jsession/startup" "$(DESTDIR)/etc/bash_completion.d"
	cp jsession jsessiond jsession-quit "$(DESTDIR)/usr/bin"
	cp dbus.conf "$(DESTDIR)/etc/dbus-1/system.d/jsession.conf"
	cp conf "$(DESTDIR)/etc/jsession/conf"
	cp bash_completion "$(DESTDIR)/etc/bash_completion.d/jsession_quit"
uninstall:
	-rm -r "$(DESTDIR)/usr/bin/jsession" "$(DESTDIR)/usr/bin/jsessiond" \
		"$(DESTDIR)/usr/bin/jsession-quit" \
		"$(DESTDIR)/etc/dbus-1/system.d/jsession.conf" \
		"$(DESTDIR)/etc/jsession" \
		"$(DESTDIR)/etc/bash_completion.d/jsession_quit"
