

CC := gcc
PTFFLAGS := -D_WIN32
LDFLAGS := -lstdc++ -lwinmm -ldxgi -ld3d11 -lgdi32
CCFLAGS := -Wall -Wextra -Werror -g
CCFLAGS += $(LDFLAGS)
CCFLAGS += $(PTFFLAGS)

PROGRAM := musis
PROGSRC := main.c
PROGDEP := 

CXX := g++
CXXFLAGS := -lwinmm -Wall -D__WINDOWS_MM__ -static -std=c++11
CXXFLAGS += -DRTMIDI_DEBUG

SOKOLZIP := ext/sokol.zip
GRAPHICSDIR := ext/gfx
GRAPHICSOBJ := ext/graphics_implementation.o
GRAPHICSSRC := $(patsubst %.o,%.c,$(GRAPHICSOBJ))
GRAPHICSHEADER := $(GRAPHICSDIR)/sokol_app.h

RTMIDIZIP := ext/rtmidi.zip
RTMIDIDIR := ext/rtmidi-6.0.0
RTMIDIOBJ := $(RTMIDIDIR)/RtMidi.o $(RTMIDIDIR)/rtmidi_c.o
RTMIDISRC := $(patsubst %.o,%.cpp,$(RTMIDIOBJ))

all: $(PROGRAM) $(RTMIDIOBJ) $(PROGDEP)

$(PROGRAM): $(RTMIDIOBJ) $(GRAPHICSOBJ) $(PROGDEP)
	$(CC) $(PROGSRC) $(RTMIDIOBJ) $(GRAPHICSOBJ) -o $(PROGRAM) $(CCFLAGS)

# windowing/graphics library stuff

$(GRAPHICSHEADER):
	-mkdir $(GRAPHICSDIR)
	@echo "Downloading Sokol"
	wget "https://github.com/floooh/sokol/archive/53b78dd7e85c8c62622e2f7adfb63fc32814dfc4.zip" -O $(SOKOLZIP)
	@echo "Unpacking Sokol"
	unzip $(SOKOLZIP) -d $(GRAPHICSDIR)/temp
	mv $(GRAPHICSDIR)/temp/sokol-53b78dd7e85c8c62622e2f7adfb63fc32814dfc4/* $(GRAPHICSDIR)
	@echo "Downloading Clay"
	wget "https://github.com/nicbarker/clay/raw/5a0d301c60e6db5425537b7b808969ce54bb55d9/renderers/sokol/sokol_clay.h" -O $(GRAPHICSDIR)/sokol_clay.h
	wget "https://raw.githubusercontent.com/nicbarker/clay/5a0d301c60e6db5425537b7b808969ce54bb55d9/clay.h" -O $(GRAPHICSDIR)/clay.h
	@echo "Downloading Fontstash"
	wget "https://github.com/memononen/fontstash/raw/b5ddc9741061343740d85d636d782ed3e07cf7be/src/fontstash.h" -O $(GRAPHICSDIR)/fontstash.h
	@echo "Downloading stb_truetype"
	wget "https://raw.githubusercontent.com/memononen/fontstash/b5ddc9741061343740d85d636d782ed3e07cf7be/src/stb_truetype.h" -O $(GRAPHICSDIR)/stb_truetype.h

$(GRAPHICSOBJ): $(GRAPHICSSRC) $(GRAPHICSHEADER)
	$(CC) $(GRAPHICSSRC) -c -o $(GRAPHICSOBJ) -g $(PTFFLAGS)

# midi library stuff

$(RTMIDIOBJ): $(RTMIDISRC)
	@echo "Compiling RtMidi object file $@"
	$(CXX) -c $(patsubst %.o,%.cpp,$@) -o $@ $(CXXFLAGS)

$(RTMIDISRC):
	@echo "Downloading RtMidi 6.0.0"
	wget "https://github.com/thestk/rtmidi/archive/refs/tags/6.0.0.zip" -O $(RTMIDIZIP)
	@echo "Unpacking RtMidi"
	unzip $(RTMIDIZIP) -d ext/

# else

getsokol: $(GRAPHICSHEADER)

clean:
	-rm $(RTMIDIZIP)
	-rm -r $(RTMIDIDIR)
	-rM $()

.PHONY: all clean