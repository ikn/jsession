/*

jsession daemon by J

Licensed under the GNU General Public License, version 3; if this was not
included, you can find it here:
    http://www.gnu.org/licenses/gpl-3.0.txt

*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <dbus/dbus.h>

DBusHandlerResult handler (DBusConnection *c, DBusMessage *m, void *data) {
    // check the message is as expected: one int16, method call to member 'cmd'
    if (strcmp(dbus_message_get_member(m), "cmd") != 0 ||
        dbus_message_get_type(m) != DBUS_MESSAGE_TYPE_METHOD_CALL ||
        strcmp(dbus_message_get_signature(m), DBUS_TYPE_INT16_AS_STRING) != 0)
        return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    // check the received data is valid
    DBusError e;
    dbus_error_init(&e);
    short code = -1;
    if (dbus_message_get_args(m, &e, DBUS_TYPE_INT16, &code, DBUS_TYPE_INVALID)
        == FALSE)
        // no idea what went wrong; this should match the message signature
        // just don't reply
        return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    if (code < 0 || code > 3) return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    // take action based on received code
    if (code == 0) code = system("halt");
    else if (code == 1) code = system("reboot");
    else if (code == 2) code = system("pm-suspend");
    else code = system("run-parts /etc/jsession/startup");
    if (code != 0)
        // error
        return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    // reply, just so caller knows the message was received
    DBusMessage *reply = dbus_message_new_method_return(m);
    dbus_connection_send(c, reply, NULL);
    dbus_connection_flush(c);
    return DBUS_HANDLER_RESULT_HANDLED;
}

int main () {
    // connect to bus
    DBusError e;
    dbus_error_init(&e);
    DBusConnection *c = dbus_bus_get(DBUS_BUS_SYSTEM, &e);
    if (c == NULL) {
        fprintf(stderr, "error: couldn't connect to the system bus\n");
        exit(2);
    }
    // ask for a 'well-known name'
    if (dbus_bus_request_name(c, "prog.jsession", 0, &e) !=
        DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER) {
        fprintf(stderr, "error: couldn't register name with system bus\n");
        exit(2);
    }
    // everything's fine: fork off and die
    pid_t pid = fork();
    if (pid == -1) exit(1);
    if (pid > 0) exit(0);
    // register a handler for an object path
    struct DBusObjectPathVTable vtable;
    DBusObjectPathMessageFunction mf = &handler;
    vtable.message_function = mf;
    dbus_connection_register_object_path(c, "/prog/jsession", &vtable, NULL);
    // main loop
    while (dbus_connection_read_write_dispatch(c, -1));
    return 0;
}
