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
    unsigned short code = -1;
    if (dbus_message_get_args(m, &e, DBUS_TYPE_INT16, &code, DBUS_TYPE_INVALID)
        == FALSE)
        // no idea what went wrong; this should match the message signature
        // just don't reply
        return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    if (code > 2) return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    // take action based on received code
    if (code == 0) code = system("halt");
    else if (code == 1) code = system("reboot");
    else if (code == 2) code = system("pm-suspend");
    if (code != 0)
        // error
        return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    // reply, just so caller knows the message was received
    DBusMessage *reply = dbus_message_new_method_return(m);
    dbus_connection_send(c, reply, NULL);
    return DBUS_HANDLER_RESULT_HANDLED;
}

int main () {
    // fork off and die
    pid_t pid = fork();
    if (pid == -1) exit(1);
    if (pid > 0) exit(0);
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
    // register a handler for an object path
    struct DBusObjectPathVTable vtable;
    DBusObjectPathMessageFunction mf = &handler;
    vtable.message_function = mf;
    dbus_connection_register_object_path(c, "/prog/jsession", &vtable, NULL);
    // main loop
    while (dbus_connection_read_write_dispatch(c, -1));
    return 0;
}
