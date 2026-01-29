#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "ext/rtmidi-6.0.0/rtmidi_c.h"

#include "ext/sokol/sokol_app.h"
#include "ext/sokol/sokol_log.h"

#define min(a, b) (((a) < (b)) ? (a) : (b))

struct {
	RtMidiInPtr midiIn;
} Context;

void midiInCallback(double timeStamp, const unsigned char *message, size_t messageSize, void *userData) {
	(void)userData;
	(void)timeStamp;
	char buf[1024];
	snprintf(buf, min(messageSize, 1024), "%s", (char *)message);
}

void init(void) {
	puts("Hello from musis");
	Context.midiIn = rtmidi_in_create(RTMIDI_API_UNSPECIFIED, "noone", 100);
	uint32_t ports = rtmidi_get_port_count(Context.midiIn);
	printf("There are %u ports\n", ports);
	if (ports == 0) {
		rtmidi_in_free(Context.midiIn);
		puts("No ports available. Bye");
		abort();
	}
	rtmidi_open_port(Context.midiIn, 0, "noone");
	// rtmidi_in_set_callback(in, midiInCallback, NULL);
	rtmidi_in_ignore_types(Context.midiIn, false, false, false);
}

void frame(void) {
	unsigned char msg[1024];
	size_t	      msgsize = 0;
	rtmidi_in_get_message(Context.midiIn, msg, &msgsize);
	printf("message size: %zu\n", msgsize);

	fflush(stdout);
}

void cleanup(void) {
	rtmidi_in_free(Context.midiIn);
	puts("Goodbye.");
}

sapp_desc sokol_main(int argc, char **argv) {
	(void)argc;
	(void)argv;
	return (sapp_desc){
		.init_cb = init,
		.frame_cb = frame,
		.cleanup_cb = cleanup,
		.width = 640,
		.height = 480,
		.window_title = "Musis",
		.icon.sokol_default = true,
		.logger.func = slog_func,
	};
}
