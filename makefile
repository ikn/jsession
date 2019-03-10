PROG := jsessiond
CFLAGS += -Wall
CPPFLAGS += `pkg-config --cflags dbus-1`
LDLIBS += `pkg-config --libs dbus-1`
INSTALL_PROGRAM := install
INSTALL_DATA := install -m644

prefix := /usr/local
exec_prefix := $(prefix)
bindir := $(exec_prefix)/bin
sysconfdir := /etc

.PHONY: all clean distclean install uninstall

all: $(PROG)

clean:
	- $(RM) $(PROG)

distclean: clean

install:
	mkdir -p "$(DESTDIR)$(bindir)"
	$(INSTALL_PROGRAM) jsession jsessiond jsession-quit "$(DESTDIR)$(bindir)/"

	mkdir -p "$(DESTDIR)$(sysconfdir)/dbus-1/system.d"
	$(INSTALL_DATA) dbus.conf \
		"$(DESTDIR)$(sysconfdir)/dbus-1/system.d/jsession.conf"

	mkdir -p "$(DESTDIR)$(sysconfdir)/jsession/startup"
	$(INSTALL_DATA) conf "$(DESTDIR)$(sysconfdir)/jsession/conf"

	mkdir -p "$(DESTDIR)$(sysconfdir)/bash_completion.d"
	$(INSTALL_DATA) bash_completion \
		"$(DESTDIR)$(sysconfdir)/bash_completion.d/jsession_quit"

	mkdir -p "$(DESTDIR)$(prefix)/lib/systemd/system"
	$(INSTALL_DATA) jsession.service "$(DESTDIR)$(prefix)/lib/systemd/system/"

uninstall:
	$(RM) "$(DESTDIR)$(bindir)/jsession" \
		"$(DESTDIR)$(bindir)/jsessiond" \
		"$(DESTDIR)$(bindir)/jsession-quit" \
		"$(DESTDIR)$(sysconfdir)/dbus-1/system.d/jsession.conf" \
		"$(DESTDIR)$(sysconfdir)/bash_completion.d/jsession_quit" \
		"$(DESTDIR)$(prefix)/lib/systemd/system/jsession.service"

	@ # leave startup dir if it contains things
ifneq ("", "$(shell ls -A "$(DESTDIR)$(sysconfdir)/jsession/startup" 2> /dev/null)")
	@ # but warn about it
	@ echo >&2 "warning: leaving '$(DESTDIR)$(sysconfdir)/jsession/startup/'" \
		"in place because it contains files"
else
	$(RM) -r "$(DESTDIR)$(sysconfdir)/jsession/startup/"
endif
