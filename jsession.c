#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

void logout (int sig) {
    exit(0);
}

int main () {
    signal(SIGTERM, logout);
    getchar();
    return 0;
}
