/*
 * This header provides methods for interacting with the core game engine
 * Flag/Var access, some basic overworld stuff etc.
 */

#ifndef GAME_ENGINE_H_
#define GAME_ENGINE_H_

/* === INCLUDES === */
#include <types.h>

/* === STRUCTURES === */

/* struct for some of the players movement states */
struct walkrun
{
    u8 bitfield;
    u8 bike;
    u8 running2;
    u8 running1;
    u8 oamid;
    u8 npcid;
    u8 lock;
    u8 field_7;
    u8 xmode;
    u8 field_9;
    u8 field_A;
    u8 field_B;
    u32 field_C;
    u32 field_10;
    u32 field_14;
    u8 field_18;
    u8 field_19;
    u16 field_1A;
    u16 most_recent_override_tile;
};

//overworld poison script 081A8DFD
//egg script 081BF546
//script per_script_end 081A8CED
/* === PROTOTYPES === */

bool in_trade_center(void);
bool happiness_algorithm_step(void);
bool is_tile_control_override(u16 tile_id);
bool safari_step(void);
bool script_walk_810C4EC(void);
bool overworld_poison_step(void);
bool get_egg(void);

void sav_xor_increment(u8 value);

void script_reset_environments_and_start(void* ptr_script);

/* === INTERNAL GLOBALS === */

/* provides access to the walkrun state, that is
 * located at the given memory address
 */
struct walkrun walkrun_state;

/* access to the prev_quest_mode byte */
u8 prev_quest_mode;

#endif /* GAME_ENGINE_H_ */