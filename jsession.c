#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

void logout (int sig) {
    exit(EXIT_SUCCESS);
}

int main () {
    signal(SIGTERM, logout);
    getchar();
    return 0
}
