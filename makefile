PROG := jsessiond
CFLAGS += -Wall
CPPFLAGS += `pkg-config --cflags dbus-1`
LDLIBS += `pkg-config --libs dbus-1`
INSTALL_PROGRAM := install
INSTALL_DATA := install -m644

prefix := /usr/local
exec_prefix := $(prefix)
bindir := $(exec_prefix)/bin

.PHONY: all clean distclean install uninstall

all: $(PROG)

clean:
	- $(RM) $(PROG)

distclean: clean

install:
	mkdir -p "$(DESTDIR)$(bindir)" "$(DESTDIR)/etc/dbus-1/system.d" \
		"$(DESTDIR)/etc/jsession/startup" \
		"$(DESTDIR)/etc/bash_completion.d"
	$(INSTALL_PROGRAM) jsession jsessiond jsession-quit \
		"$(DESTDIR)$(bindir)"
	$(INSTALL_DATA) dbus.conf \
		"$(DESTDIR)/etc/dbus-1/system.d/jsession.conf"
	$(INSTALL_DATA) conf "$(DESTDIR)/etc/jsession/conf"
	$(INSTALL_DATA) bash_completion \
		"$(DESTDIR)/etc/bash_completion.d/jsession_quit"

uninstall:
	$(RM) -r "$(DESTDIR)$(bindir)/jsession" \
		"$(DESTDIR)$(bindir)/jsessiond" \
		"$(DESTDIR)$(bindir)/jsession-quit" \
		"$(DESTDIR)/etc/dbus-1/system.d/jsession.conf" \
		"$(DESTDIR)/etc/bash_completion.d/jsession_quit"
	@ # leave startup dir if it contains things
ifneq ("", "$(shell ls -A "$(DESTDIR)/etc/jsession/startup" 2> /dev/null)")
	@ # but warn about it
	@ echo "warning: leaving '$(DESTDIR)/etc/jsession/startup/' in place" \
		"because it contains files" 1>&2
else
	$(RM) -r "$(DESTDIR)/etc/jsession"
endif
