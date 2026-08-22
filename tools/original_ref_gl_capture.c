/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Standalone x86 host for the unmodified classic ref_gl.dll.  It supplies the
API-v3 imports, reads retail files without copying them, renders one fixed
refdef and writes a canonical top-left 32-bit TGA for differential testing.
*/
#define WIN32_LEAN_AND_MEAN
#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <gl/GL.h>
#include <ctype.h>
#include <math.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define API_VERSION 3
#define MAX_CAPTURE_ENTITIES 128
#define MAX_LIGHTSTYLES 256
#define RF_FULLBRIGHT 8

typedef struct cvar_s {
    char *name;
    char *string;
    char *latched_string;
    int flags;
    int modified;
    float value;
    struct cvar_s *next;
} cvar_t;

typedef struct entity_s {
    void *model;
    float angles[3];
    float origin[3];
    int frame;
    float oldorigin[3];
    int oldframe;
    float backlerp;
    int skinnum;
    int lightstyle;
    float alpha;
    void *skin;
    int flags;
} entity_t;

typedef struct { float origin[3], color[3], intensity; } dlight_t;
typedef struct { float origin[3]; int color; float alpha; } particle_t;
typedef struct { float rgb[3], white; } lightstyle_t;

typedef struct {
    int x, y, width, height;
    float fov_x, fov_y;
    float vieworg[3], viewangles[3], blend[4], time;
    int rdflags;
    unsigned char *areabits;
    lightstyle_t *lightstyles;
    int num_entities;
    entity_t *entities;
    int num_dlights;
    dlight_t *dlights;
    int num_particles;
    particle_t *particles;
} refdef_t;

typedef struct {
    void (__cdecl *Sys_Error)(int, char *, ...);
    void (__cdecl *Cmd_AddCommand)(char *, void (__cdecl *)(void));
    void (__cdecl *Cmd_RemoveCommand)(char *);
    int (__cdecl *Cmd_Argc)(void);
    char *(__cdecl *Cmd_Argv)(int);
    void (__cdecl *Cmd_ExecuteText)(int, char *);
    void (__cdecl *Con_Printf)(int, char *, ...);
    int (__cdecl *FS_LoadFile)(char *, void **);
    void (__cdecl *FS_FreeFile)(void *);
    char *(__cdecl *FS_Gamedir)(void);
    cvar_t *(__cdecl *Cvar_Get)(char *, char *, int);
    cvar_t *(__cdecl *Cvar_Set)(char *, char *);
    void (__cdecl *Cvar_SetValue)(char *, float);
    int (__cdecl *Vid_GetModeInfo)(int *, int *, int);
    void (__cdecl *Vid_MenuInit)(void);
    void (__cdecl *Vid_NewWindow)(int, int);
} refimport_t;

typedef struct {
    int api_version;
    int (__cdecl *Init)(void *, void *);
    void (__cdecl *Shutdown)(void);
    void (__cdecl *BeginRegistration)(char *);
    void *(__cdecl *RegisterModel)(char *);
    void *(__cdecl *RegisterSkin)(char *);
    void *(__cdecl *RegisterPic)(char *);
    void (__cdecl *SetSky)(char *, float, float *);
    void (__cdecl *EndRegistration)(void);
    void (__cdecl *RenderFrame)(refdef_t *);
    void (__cdecl *DrawGetPicSize)(int *, int *, char *);
    void (__cdecl *DrawPic)(int, int, char *);
    void (__cdecl *DrawStretchPic)(int, int, int, int, char *);
    void (__cdecl *DrawChar)(int, int, int);
    void (__cdecl *DrawTileClear)(int, int, int, int, char *);
    void (__cdecl *DrawFill)(int, int, int, int, int);
    void (__cdecl *DrawFadeScreen)(void);
    void (__cdecl *DrawStretchRaw)(int, int, int, int, int, int, unsigned char *);
    void (__cdecl *CinematicSetPalette)(const unsigned char *);
    void (__cdecl *BeginFrame)(float);
    void (__cdecl *EndFrame)(void);
    void (__cdecl *AppActivate)(int);
} refexport_t;

typedef refexport_t (__cdecl *GetRefAPI_t)(refimport_t);

#pragma pack(push, 1)
typedef struct { char magic[4]; int directory_offset, directory_length; } pak_header_t;
typedef struct { char name[56]; int file_offset, file_length; } pak_entry_t;
#pragma pack(pop)

typedef struct {
    char class_name[128], model[128], sky[128];
    float origin[3], angles[3], sky_axis[3], sky_rotate;
} parsed_entity_t;

static char g_root[MAX_PATH * 2];
static char g_game_dir[MAX_PATH * 2];
static int g_width = 640, g_height = 480;
static cvar_t g_cvars[160];
static int g_cvar_count;
static int g_missing_file_count;

static void normalize_name(char *output, size_t capacity, const char *input) {
    size_t index = 0;
    while (*input && index + 1 < capacity) {
        unsigned char value = (unsigned char)*input++;
        if (value == '\\') value = '/';
        output[index++] = (char)tolower(value);
    }
    output[index] = 0;
}

static int read_loose_file(const char *name, void **output) {
    char normalized[512], relative[512], path[MAX_PATH * 3];
    FILE *file;
    long length;
    size_t index;
    normalize_name(normalized, sizeof(normalized), name);
    strncpy(relative, normalized, sizeof(relative) - 1);
    relative[sizeof(relative) - 1] = 0;
    for (index = 0; relative[index]; ++index) if (relative[index] == '/') relative[index] = '\\';
    _snprintf(path, sizeof(path), "%s\\%s", g_game_dir, relative);
    file = fopen(path, "rb");
    if (!file) return -1;
    fseek(file, 0, SEEK_END); length = ftell(file); fseek(file, 0, SEEK_SET);
    if (length < 0) { fclose(file); return -1; }
    if (output) {
        void *data = malloc((size_t)length + 1);
        if (!data || fread(data, 1, (size_t)length, file) != (size_t)length) {
            free(data); fclose(file); return -1;
        }
        ((unsigned char *)data)[length] = 0;
        *output = data;
    }
    fclose(file);
    return (int)length;
}

static int read_pak_file(const char *name, void **output) {
    char wanted[512], pak_path[MAX_PATH * 3], entry_name[57];
    int pak_number;
    normalize_name(wanted, sizeof(wanted), name);
    for (pak_number = 9; pak_number >= 0; --pak_number) {
        FILE *file;
        pak_header_t header;
        int entry_count, index;
        _snprintf(pak_path, sizeof(pak_path), "%s\\pak%d.pak", g_game_dir, pak_number);
        file = fopen(pak_path, "rb");
        if (!file) continue;
        if (fread(&header, 1, sizeof(header), file) != sizeof(header) || memcmp(header.magic, "PACK", 4)) {
            fclose(file); continue;
        }
        entry_count = header.directory_length / (int)sizeof(pak_entry_t);
        if (entry_count < 0 || entry_count > 65536 || fseek(file, header.directory_offset, SEEK_SET)) {
            fclose(file); continue;
        }
        for (index = 0; index < entry_count; ++index) {
            pak_entry_t entry;
            long directory_position;
            if (fread(&entry, 1, sizeof(entry), file) != sizeof(entry)) break;
            memcpy(entry_name, entry.name, 56); entry_name[56] = 0;
            normalize_name(entry_name, sizeof(entry_name), entry_name);
            if (strcmp(entry_name, wanted)) continue;
            if (entry.file_length < 0 || entry.file_offset < 0) { fclose(file); return -1; }
            if (output) {
                void *data = malloc((size_t)entry.file_length + 1);
                if (!data) { fclose(file); return -1; }
                directory_position = ftell(file);
                if (fseek(file, entry.file_offset, SEEK_SET) ||
                    fread(data, 1, (size_t)entry.file_length, file) != (size_t)entry.file_length) {
                    free(data); fclose(file); return -1;
                }
                ((unsigned char *)data)[entry.file_length] = 0;
                *output = data;
                (void)directory_position;
            }
            fclose(file);
            return entry.file_length;
        }
        fclose(file);
    }
    return -1;
}

static int __cdecl import_load_file(char *name, void **output) {
    int result;
    if (output) *output = NULL;
    result = read_loose_file(name, output);
    if (result >= 0) return result;
    result = read_pak_file(name, output);
    if (result < 0) {
        ++g_missing_file_count;
        if (g_missing_file_count <= 32) fprintf(stderr, "missing retail file: %s\n", name);
    }
    return result;
}

static void __cdecl import_free_file(void *data) { free(data); }
static char *__cdecl import_game_dir(void) { return g_game_dir; }

static void __cdecl import_error(int level, char *format, ...) {
    va_list arguments;
    fprintf(stderr, "original ref_gl fatal %d: ", level);
    va_start(arguments, format); vfprintf(stderr, format, arguments); va_end(arguments);
    fprintf(stderr, "\n");
    ExitProcess(20);
}

static void __cdecl import_print(int level, char *format, ...) {
    va_list arguments;
    (void)level;
    va_start(arguments, format); vfprintf(stdout, format, arguments); va_end(arguments);
}

static void __cdecl import_add_command(char *name, void (__cdecl *callback)(void)) { (void)name; (void)callback; }
static void __cdecl import_remove_command(char *name) { (void)name; }
static int __cdecl import_argc(void) { return 0; }
static char *__cdecl import_argv(int index) { static char empty[] = ""; (void)index; return empty; }
static void __cdecl import_execute_text(int when, char *text) { (void)when; (void)text; }

static const char *cvar_override(const char *name, const char *fallback) {
    if (!_stricmp(name, "gl_driver")) return "opengl32";
    if (!_stricmp(name, "gl_mode")) return "3";
    if (!_stricmp(name, "vid_fullscreen")) return "0";
    if (!_stricmp(name, "vid_gamma")) return "1.0";
    if (!_stricmp(name, "gl_ext_palettedtexture")) return "0";
    if (!_stricmp(name, "gl_ext_multitexture")) return "0";
    if (!_stricmp(name, "gl_ext_pointparameters")) return "0";
    if (!_stricmp(name, "gl_ext_compiled_vertex_array")) return "0";
    if (!_stricmp(name, "gl_vertex_arrays")) return "0";
    if (!_stricmp(name, "gl_swapinterval")) return "0";
    if (!_stricmp(name, "gl_ext_swapinterval")) return "0";
    if (!_stricmp(name, "gl_finish")) return "1";
    if (!_stricmp(name, "gl_clear")) return "1";
    if (!_stricmp(name, "gl_round_down")) return "0";
    return fallback;
}

static cvar_t *find_cvar(const char *name) {
    int index;
    for (index = 0; index < g_cvar_count; ++index) if (!_stricmp(g_cvars[index].name, name)) return &g_cvars[index];
    return NULL;
}

static cvar_t *__cdecl import_cvar_get(char *name, char *value, int flags) {
    cvar_t *result = find_cvar(name);
    const char *selected;
    if (result) return result;
    if (g_cvar_count >= (int)(sizeof(g_cvars) / sizeof(g_cvars[0]))) import_error(1, "cvar capacity exceeded");
    selected = cvar_override(name, value ? value : "");
    result = &g_cvars[g_cvar_count++];
    memset(result, 0, sizeof(*result));
    result->name = _strdup(name); result->string = _strdup(selected);
    result->flags = flags; result->modified = 0; result->value = (float)atof(selected);
    return result;
}

static cvar_t *__cdecl import_cvar_set(char *name, char *value) {
    cvar_t *result = import_cvar_get(name, value, 0);
    free(result->string); result->string = _strdup(value ? value : "");
    result->value = (float)atof(result->string); result->modified = 1;
    return result;
}

static void __cdecl import_cvar_set_value(char *name, float value) {
    char text[64];
    _snprintf(text, sizeof(text), "%.9g", value);
    import_cvar_set(name, text);
}

static int __cdecl import_mode_info(int *width, int *height, int mode) {
    (void)mode; *width = g_width; *height = g_height; return 1;
}
static void __cdecl import_menu_init(void) {}
static void __cdecl import_new_window(int width, int height) { g_width = width; g_height = height; }

static LRESULT CALLBACK capture_window_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam) {
    if (message == WM_CLOSE) { DestroyWindow(window); return 0; }
    return DefWindowProcA(window, message, wparam, lparam);
}

static refimport_t make_imports(void) {
    refimport_t imports;
    memset(&imports, 0, sizeof(imports));
    imports.Sys_Error = import_error;
    imports.Cmd_AddCommand = import_add_command; imports.Cmd_RemoveCommand = import_remove_command;
    imports.Cmd_Argc = import_argc; imports.Cmd_Argv = import_argv; imports.Cmd_ExecuteText = import_execute_text;
    imports.Con_Printf = import_print;
    imports.FS_LoadFile = import_load_file; imports.FS_FreeFile = import_free_file; imports.FS_Gamedir = import_game_dir;
    imports.Cvar_Get = import_cvar_get; imports.Cvar_Set = import_cvar_set; imports.Cvar_SetValue = import_cvar_set_value;
    imports.Vid_GetModeInfo = import_mode_info; imports.Vid_MenuInit = import_menu_init; imports.Vid_NewWindow = import_new_window;
    return imports;
}

static int next_token(const char **cursor, const char *end, char *output, size_t capacity) {
    const char *position = *cursor;
    size_t length = 0;
    while (position < end && (unsigned char)*position <= ' ') ++position;
    if (position >= end) return 0;
    if (*position == '{' || *position == '}') {
        output[0] = *position++; output[1] = 0; *cursor = position; return 1;
    }
    if (*position == '"') {
        ++position;
        while (position < end && *position != '"') {
            char value = *position++;
            if (value == '\\' && position < end) value = *position++;
            if (length + 1 < capacity) output[length++] = value;
        }
        if (position < end && *position == '"') ++position;
    } else {
        while (position < end && (unsigned char)*position > ' ' && *position != '{' && *position != '}') {
            if (length + 1 < capacity) output[length++] = *position;
            ++position;
        }
    }
    output[length] = 0; *cursor = position; return 1;
}

static void parse_vector(const char *text, float output[3]) {
    output[0] = output[1] = output[2] = 0.0f;
    sscanf(text, "%f %f %f", &output[0], &output[1], &output[2]);
}

static int parse_entities(const unsigned char *bsp_data, int bsp_length,
    parsed_entity_t *entities, int capacity) {
    int offset, length, count = 0;
    const char *cursor, *end;
    char token[1024], key[1024], value[1024];
    if (bsp_length < 8 + 19 * 8 || memcmp(bsp_data, "IBSP", 4)) return -1;
    memcpy(&offset, bsp_data + 8, 4); memcpy(&length, bsp_data + 12, 4);
    if (offset < 0 || length < 0 || offset > bsp_length - length) return -1;
    cursor = (const char *)bsp_data + offset; end = cursor + length;
    while (next_token(&cursor, end, token, sizeof(token))) {
        parsed_entity_t current;
        if (strcmp(token, "{")) continue;
        memset(&current, 0, sizeof(current)); current.sky_axis[2] = 1.0f;
        while (next_token(&cursor, end, token, sizeof(token)) && strcmp(token, "}")) {
            strncpy(key, token, sizeof(key) - 1); key[sizeof(key) - 1] = 0;
            if (!next_token(&cursor, end, value, sizeof(value))) return -1;
            if (!_stricmp(key, "classname")) strncpy(current.class_name, value, sizeof(current.class_name) - 1);
            else if (!_stricmp(key, "model")) strncpy(current.model, value, sizeof(current.model) - 1);
            else if (!_stricmp(key, "origin")) parse_vector(value, current.origin);
            else if (!_stricmp(key, "angles")) parse_vector(value, current.angles);
            else if (!_stricmp(key, "angle")) current.angles[1] = (float)atof(value);
            else if (!_stricmp(key, "sky")) strncpy(current.sky, value, sizeof(current.sky) - 1);
            else if (!_stricmp(key, "skyrotate")) current.sky_rotate = (float)atof(value);
            else if (!_stricmp(key, "skyaxis")) parse_vector(value, current.sky_axis);
        }
        if (count < capacity) entities[count++] = current;
    }
    return count;
}

static void angle_forward(const float angles[3], float forward[3]) {
    const double radians = 3.14159265358979323846 / 180.0;
    double pitch = angles[0] * radians, yaw = angles[1] * radians;
    forward[0] = (float)(cos(pitch) * cos(yaw));
    forward[1] = (float)(cos(pitch) * sin(yaw));
    forward[2] = (float)-sin(pitch);
}

static int write_tga(const char *path, int width, int height, const unsigned char *bottom_up_rgba) {
    FILE *file = fopen(path, "wb");
    unsigned char header[18], pixel[4];
    int x, y;
    if (!file) return 0;
    memset(header, 0, sizeof(header)); header[2] = 2;
    header[12] = (unsigned char)width; header[13] = (unsigned char)(width >> 8);
    header[14] = (unsigned char)height; header[15] = (unsigned char)(height >> 8);
    header[16] = 32; header[17] = 0x28;
    fwrite(header, 1, sizeof(header), file);
    for (y = height - 1; y >= 0; --y) for (x = 0; x < width; ++x) {
        const unsigned char *source = bottom_up_rgba + (y * width + x) * 4;
        pixel[0] = source[2]; pixel[1] = source[1]; pixel[2] = source[0]; pixel[3] = source[3];
        fwrite(pixel, 1, 4, file);
    }
    fclose(file); return 1;
}

static void usage(void) {
    fprintf(stderr, "usage: original_ref_gl_capture ROOT MAP OUTPUT.tga [MODEL|- [WIDTH HEIGHT FRAMES [INLINE(0|1) [X Y Z PITCH YAW ROLL]]]]\n");
}

int main(int argc, char **argv) {
    HMODULE library;
    GetRefAPI_t get_api;
    refexport_t renderer;
    refimport_t imports;
    static parsed_entity_t parsed[2048];
    entity_t render_entities[MAX_CAPTURE_ENTITIES];
    lightstyle_t lightstyles[MAX_LIGHTSTYLES];
    refdef_t frame;
    unsigned char *map_data = NULL, *pixels = NULL;
    char map_path[256], dll_path[MAX_PATH * 3], output_path[MAX_PATH * 3];
    const char *map_name, *model_name = "";
    int map_length, parsed_count, render_count = 0, include_inline = 1, frames = 4;
    int index, frame_index, camera_found = 0;
    float camera_origin[3] = {0.0f, 0.0f, 32.0f}, camera_angles[3] = {0.0f, 0.0f, 0.0f};
    parsed_entity_t *worldspawn = NULL;
    MSG message;

    if (argc < 4 || argc > 15 || (argc > 9 && argc != 15)) { usage(); return 2; }
    if (!GetFullPathNameA(argv[1], sizeof(g_root), g_root, NULL)) return 3;
    _snprintf(g_game_dir, sizeof(g_game_dir), "%s\\baseq2", g_root);
    map_name = argv[2]; strncpy(output_path, argv[3], sizeof(output_path) - 1); output_path[sizeof(output_path) - 1] = 0;
    if (argc >= 5 && strcmp(argv[4], "-")) model_name = argv[4];
    if (argc >= 6) g_width = atoi(argv[5]);
    if (argc >= 7) g_height = atoi(argv[6]);
    if (argc >= 8) frames = atoi(argv[7]);
    if (argc >= 9) include_inline = atoi(argv[8]) != 0;
    if (g_width < 64 || g_width > 4096 || g_height < 64 || g_height > 4096 || frames < 1 || frames > 1000) return 4;
    if (argc == 15) {
        for (index = 0; index < 3; ++index) camera_origin[index] = (float)atof(argv[9 + index]);
        for (index = 0; index < 3; ++index) camera_angles[index] = (float)atof(argv[12 + index]);
        camera_found = 1;
    }

    _snprintf(map_path, sizeof(map_path), "maps/%s.bsp", map_name);
    map_length = import_load_file(map_path, (void **)&map_data);
    if (map_length < 0) { fprintf(stderr, "map unavailable: %s\n", map_path); return 5; }
    parsed_count = parse_entities(map_data, map_length, parsed, (int)(sizeof(parsed) / sizeof(parsed[0])));
    if (parsed_count < 0) { fprintf(stderr, "malformed BSP entity lump\n"); return 6; }
    for (index = 0; index < parsed_count; ++index) {
        if (!worldspawn && !_stricmp(parsed[index].class_name, "worldspawn")) worldspawn = &parsed[index];
        if (!camera_found && !_stricmp(parsed[index].class_name, "info_player_start")) {
            memcpy(camera_origin, parsed[index].origin, sizeof(camera_origin)); camera_origin[2] += 22.0f;
            memcpy(camera_angles, parsed[index].angles, sizeof(camera_angles)); camera_found = 1;
        }
    }
    import_free_file(map_data); map_data = NULL;

    _snprintf(dll_path, sizeof(dll_path), "%s\\ref_gl.dll", g_root);
    library = LoadLibraryA(dll_path);
    if (!library) { fprintf(stderr, "cannot load %s (error %lu)\n", dll_path, GetLastError()); return 7; }
    get_api = (GetRefAPI_t)GetProcAddress(library, "GetRefAPI");
    if (!get_api) return 8;
    imports = make_imports(); renderer = get_api(imports);
    if (renderer.api_version != API_VERSION) { fprintf(stderr, "ref API %d\n", renderer.api_version); return 9; }
    if (renderer.Init(GetModuleHandleA(NULL), capture_window_proc) == -1) { fprintf(stderr, "ref_gl Init failed\n"); return 10; }

    renderer.BeginRegistration((char *)map_name);
    /* The client registers CS_MODELS+1 (the world BSP) after BeginRegistration.
       Without this touch EndRegistration legitimately frees the world model. */
    if (!renderer.RegisterModel(map_path)) { fprintf(stderr, "world model registration failed\n"); return 12; }
    memset(render_entities, 0, sizeof(render_entities));
    if (model_name[0] && render_count < MAX_CAPTURE_ENTITIES) {
        entity_t *entity = &render_entities[render_count++];
        float forward[3];
        entity->model = renderer.RegisterModel((char *)model_name);
        angle_forward(camera_angles, forward);
        for (index = 0; index < 3; ++index) entity->origin[index] = camera_origin[index] + forward[index] * 96.0f;
        entity->origin[2] -= 22.0f; memcpy(entity->oldorigin, entity->origin, sizeof(entity->origin));
        entity->angles[1] = camera_angles[1] + 180.0f; entity->flags = RF_FULLBRIGHT; entity->alpha = 1.0f;
    }
    if (include_inline) for (index = 0; index < parsed_count && render_count < MAX_CAPTURE_ENTITIES; ++index) {
        if (parsed[index].model[0] == '*') {
            entity_t *entity = &render_entities[render_count++];
            entity->model = renderer.RegisterModel(parsed[index].model);
            memcpy(entity->origin, parsed[index].origin, sizeof(entity->origin));
            memcpy(entity->oldorigin, parsed[index].origin, sizeof(entity->oldorigin));
            memcpy(entity->angles, parsed[index].angles, sizeof(entity->angles)); entity->alpha = 1.0f;
        }
    }
    if (worldspawn && worldspawn->sky[0]) renderer.SetSky(worldspawn->sky, worldspawn->sky_rotate, worldspawn->sky_axis);
    renderer.EndRegistration();

    memset(&frame, 0, sizeof(frame));
    frame.width = g_width; frame.height = g_height; frame.fov_x = 90.0f; frame.fov_y = 73.7398f;
    memcpy(frame.vieworg, camera_origin, sizeof(camera_origin)); memcpy(frame.viewangles, camera_angles, sizeof(camera_angles));
    for (index = 0; index < MAX_LIGHTSTYLES; ++index) {
        lightstyles[index].rgb[0] = lightstyles[index].rgb[1] = lightstyles[index].rgb[2] = lightstyles[index].white = 1.0f;
    }
    frame.lightstyles = lightstyles; frame.num_entities = render_count; frame.entities = render_entities;
    for (frame_index = 0; frame_index < frames; ++frame_index) {
        frame.time = frame_index * 0.1f;
        renderer.BeginFrame(0.0f);
        glDisable(GL_DITHER);
        renderer.RenderFrame(&frame);
        if (frame_index == frames - 1) {
            pixels = (unsigned char *)malloc((size_t)g_width * g_height * 4);
            glFinish(); glPixelStorei(GL_PACK_ALIGNMENT, 1); glReadBuffer(GL_BACK);
            glReadPixels(0, 0, g_width, g_height, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
        }
        renderer.EndFrame();
        while (PeekMessageA(&message, NULL, 0, 0, PM_REMOVE)) { TranslateMessage(&message); DispatchMessageA(&message); }
    }

    if (!pixels || !write_tga(output_path, g_width, g_height, pixels)) { fprintf(stderr, "capture write failed\n"); return 11; }
    printf("original ref_gl visual capture: PASS\n");
    printf("  map=%s output=%s size=%dx%d frames=%d time=%.1f\n", map_name, output_path, g_width, g_height, frames, (frames - 1) * 0.1f);
    printf("  camera=%.9g %.9g %.9g %.9g %.9g %.9g entities=%d\n",
        camera_origin[0], camera_origin[1], camera_origin[2], camera_angles[0], camera_angles[1], camera_angles[2], render_count);
    printf("  missing-files=%d\n", g_missing_file_count);
    free(pixels); renderer.Shutdown(); FreeLibrary(library);
    for (index = 0; index < g_cvar_count; ++index) { free(g_cvars[index].name); free(g_cvars[index].string); free(g_cvars[index].latched_string); }
    return 0;
}
