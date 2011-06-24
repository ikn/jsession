all:
	gcc -Wall jsession.c -ojsession
install:
	mkdir -p $(DESTDIR)/usr/bin $(DESTDIR)/etc/jsession
	cp jsession-init jsession jsessiond jsession-quit $(DESTDIR)/usr/bin
	cp conf $(DESTDIR)/etc/jsession/conf
uninstall:
	-rm $(DESTDIR)/usr/bin/jsession-init $(DESTDIR)/usr/bin/jsession
	-rm $(DESTDIR)/usr/bin/jsessiond $(DESTDIR)/usr/bin/jsession-quit
	-rm -r $(DESTDIR)/etc/jsession
