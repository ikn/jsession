all:
	@echo Nothing to make.
install:
	mkdir -p $(DESTDIR)/usr/bin $(DESTDIR)/etc/jsession
	cp jsession jsessiond jsession-quit $(DESTDIR)/usr/bin
	cp conf $(DESTDIR)/etc/jsession/conf
uninstall:
	-rm $(DESTDIR)/usr/bin/jsession $(DESTDIR)/usr/bin/jsessiond
	-rm $(DESTDIR)/usr/bin/jsession-quit
	-rm -r $(DESTDIR)/etc/jsession
