

CC := gcc
LDFLAGS := -lstdc++ -lwinmm -ldxgi -ld3d11 -lgdi32
CCFLAGS := -Wall -Wextra -Werror -g -D_WIN32
CCFLAGS += $(LDFLAGS)

PROGRAM := musis
PROGSRC := main.c
PROGDEP := 

CXX := g++
CXXFLAGS := -lwinmm -Wall -D__WINDOWS_MM__ -static -std=c++11
CXXFLAGS += -DRTMIDI_DEBUG

SOKOLZIP := ext/sokol.zip
SOKOLDIR := ext/sokol
SOKOLOBJ := ext/sokol_implementation.o

RTMIDIZIP := ext/rtmidi.zip
RTMIDIDIR := ext/rtmidi-6.0.0
RTMIDIOBJ := $(RTMIDIDIR)/RtMidi.o $(RTMIDIDIR)/rtmidi_c.o
RTMIDISRC := $(patsubst %.o,%.cpp,$(RTMIDIOBJ))

all: $(PROGRAM) $(RTMIDIOBJ) $(PROGDEP)

$(PROGRAM): $(RTMIDIOBJ) $(SOKOLOBJ) $(PROGDEP)
	$(CC) $(PROGSRC) $(RTMIDIOBJ) $(SOKOLOBJ) -o $(PROGRAM) $(CCFLAGS)

# windowing/graphics library stuff

$(SOKOLSRC):
	@echo "Downloading Sokol"
	wget "https://github.com/floooh/sokol/archive/53b78dd7e85c8c62622e2f7adfb63fc32814dfc4.zip" -O $(SOKOLZIP)
	@echo "Unpacking Sokol"
	unzip $(SOKOLZIP) -d $(SOKOLDIR)/temp
	mv $(SOKOLDIR)/temp/sokol-53b78dd7e85c8c62622e2f7adfb63fc32814dfc4/* $(SOKOLDIR)

# midi library stuff

$(SOKOLOBJ): $(patsubst %.o,%.c,$(SOKOLOBJ))
	$(CC) $(patsubst %.o,%.c,$(SOKOLOBJ)) -c -o $(SOKOLOBJ) -g

$(RTMIDIOBJ): $(RTMIDISRC)
	@echo "Compiling RtMidi object file $@"
	$(CXX) -c $(patsubst %.o,%.cpp,$@) -o $@ $(CXXFLAGS)

$(RTMIDISRC):
	@echo "Downloading RtMidi 6.0.0"
	wget "https://github.com/thestk/rtmidi/archive/refs/tags/6.0.0.zip" -O $(RTMIDIZIP)
	@echo "Unpacking RtMidi"
	unzip $(RTMIDIZIP) -d ext/

# else

getsokol: $(SOKOLSRC)

clean:
	-rm $(RTMIDIZIP)
	-rm -r $(RTMIDIDIR)
	-rM $()

.PHONY: all clean