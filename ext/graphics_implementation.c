#define SOKOL_IMPL
#ifdef _WIN32
#define SOKOL_D3D11
#include <stringapiset.h>
#include <minwindef.h>
#endif // _WIN32
#define FONTSTASH_IMPLEMENTATION
#include <stdio.h>
#include <stdlib.h>
#include "gfx/fontstash.h"
#include "gfx/sokol_app.h"
#include "gfx/sokol_gfx.h"
#include "gfx/util/sokol_gl.h"
#include "gfx/util/sokol_fontstash.h"
#include "gfx/sokol_glue.h"
#include "gfx/sokol_log.h"

#define CLAY_IMPLEMENTATION
#include "gfx/clay.h"
#define SOKOL_CLAY_IMPL
#include "gfx/sokol_clay.h"