#include <stdio.h>
#include <stdlib.h>

#include "ext/rtmidi-6.0.0/rtmidi_c.h"

int main(void) {

	puts("hello");

	RtMidiInPtr in = rtmidi_in_create (RTMIDI_API_UNSPECIFIED, "noone", 100);

	rtmidi_in_free(in);

	return 0;
}