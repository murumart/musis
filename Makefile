

CC := gcc
CCFLAGS := -Wall -Wextra -Werror -g
CCFLAGS += -lstdc++ -lwinmm

PROGRAM := musis
PROGSRC := main.c
PROGDEP := 

CXX := g++
CXXFLAGS := -lwinmm -Wall -D__WINDOWS_MM__ -static -std=c++11
CXXFLAGS += -DRTMIDI_DEBUG

RTMIDIZIP := ext/rtmidi.zip
RTMIDIDIR := ext/rtmidi-6.0.0
RTMIDIOBJ := $(RTMIDIDIR)/RtMidi.o $(RTMIDIDIR)/rtmidi_c.o
RTMIDISRC := $(patsubst %.o,%.cpp,$(RTMIDIOBJ))

all: $(PROGRAM) $(RTMIDIOBJ) $(PROGDEP)

$(PROGRAM): $(RTMIDIOBJ) $(PROGDEP)
	$(CC) $(PROGSRC) $(RTMIDIOBJ) -o $(PROGRAM) $(CCFLAGS)

$(RTMIDIOBJ): $(RTMIDISRC)
	@echo "Compiling RtMidi object file $@"
	$(CXX) -c $(patsubst %.o,%.cpp,$@) -o $@ $(CXXFLAGS)

$(RTMIDISRC):
	@echo "Downloading RtMidi 6.0.0"
	wget "https://github.com/thestk/rtmidi/archive/refs/tags/6.0.0.zip" -O $(RTMIDIZIP)
	@echo "Unpacking RtMidi"
	-mkdir $(RTMIDIDIR)
	unzip $(RTMIDIZIP) -d ext/

clean:
	-rm $(RTMIDIZIP)
	-rm -r $(RTMIDIDIR)

.PHONY: all clean