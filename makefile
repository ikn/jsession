PROG := jsessiond
SRCS := $(wildcard *.c)
CFLAGS += -Wall
CPPFLAGS += `pkg-config --cflags dbus-1`
LDFLAGS += `pkg-config --libs dbus-1`

.PHONY: all clean distclean install uninstall

all:
	$(LINK.c) $(SRCS) -o $(PROG)

clean:
	- $(RM) $(PROG)

distclean: clean

install:
	mkdir -p "$(DESTDIR)/usr/bin" "$(DESTDIR)/etc/dbus-1/system.d" \
		"$(DESTDIR)/etc/jsession/startup" "$(DESTDIR)/etc/bash_completion.d"
	cp jsession jsessiond jsession-quit "$(DESTDIR)/usr/bin"
	cp dbus.conf "$(DESTDIR)/etc/dbus-1/system.d/jsession.conf"
	cp conf "$(DESTDIR)/etc/jsession/conf"
	cp bash_completion "$(DESTDIR)/etc/bash_completion.d/jsession_quit"

uninstall:
	- rm -r "$(DESTDIR)/usr/bin/jsession" "$(DESTDIR)/usr/bin/jsessiond" \
		"$(DESTDIR)/usr/bin/jsession-quit" \
		"$(DESTDIR)/etc/dbus-1/system.d/jsession.conf" \
		"$(DESTDIR)/etc/bash_completion.d/jsession_quit"
	@ # leave startup dir if it contains things
ifneq ("", "$(shell ls -A "$(DESTDIR)/etc/jsession/startup" 2> /dev/null)")
	@ # but warn about it
	@ echo "warning: leaving '$(DESTDIR)/etc/jsession/startup/' in place" \
		"because it contains files"
else
	- rm -r "$(DESTDIR)/etc/jsession"
endif
