#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "ext/rtmidi-6.0.0/rtmidi_c.h"

// ass
#include <synchapi.h>

#define min(a, b) (((a) < (b)) ? (a) : (b))

void midiInCallback(double timeStamp, const unsigned char *message, size_t messageSize, void *userData) {
	(void)userData;
	(void)timeStamp;
	char buf[1024];
	snprintf(buf, min(messageSize, 1024), "%s", (char *)message);
}

int main(void) {

	puts("Hello from musis");

	RtMidiInPtr in = rtmidi_in_create(RTMIDI_API_UNSPECIFIED, "noone", 100);

	uint32_t ports = rtmidi_get_port_count(in);
	printf("There are %u ports\n", ports);
	if (ports == 0) {
		rtmidi_in_free(in);
		puts("No ports available. Bye");
		return 0;
	}
	rtmidi_open_port(in, 0, "noone");
	// rtmidi_in_set_callback(in, midiInCallback, NULL);
	rtmidi_in_ignore_types(in, false, false, false);

	unsigned char msg[1024];
	size_t	      msgsize = 0;
	while (2) {
		rtmidi_in_get_message(in, msg, &msgsize);
		printf("message size: %zu\n", msgsize);

		fflush(stdout);
		Sleep(10);
	}

	int lol = 0;
	scanf("%d", &lol);

	rtmidi_in_free(in);
	puts("Goodbye.");

	return 0;
}
