/*
 * This is an example file to show you how to use the template
 */

/* === INCLUDES === */

#include <game_engine.h>
#include <types.h>
#include <agb_debug.h>

/* === EXTERN SCRIPTS === */

void* scr_overworld_poison_death;
void* scr_egg_hatch;
void* scr_unk_per_step_end;

/* === PROTOTYPES === */

/**
 * @brief executed each step, executes scripts based on steps
 * @param tile_to the behavior ID of the tile we walk towards
 */
bool ex_per_step_scripts(u16 tile_to);

/* === IMPLEMENTATIONS === */

bool ex_per_step_scripts(u16 tile_to)
{
    if(tile_to == 0x2)
    {
        /* this is custom added code, will be executed if we step on grass in
         * bpre vanilla, which has behavior id 0x2
         */
        dprintf("we just stepped on grass, tile_to is %d", tile_to);
        /* this also shows off the debug functionality of this template, the string
         * above will be printed to the vba log, if you are using vba
         */
    }
    if(in_trade_center() || prev_quest_mode == 2)
    {
        return false;
    }
    happiness_algorithm_step();
    if((walkrun_state.bitfield & 0x40) || is_tile_control_override(tile_to))
    {
        return safari_step();
    }
    if(!script_walk_810C4EC())
    {
        if(overworld_poison_step())
        {
            script_reset_environments_and_start(scr_overworld_poison_death);
            return true;
        }
        if(get_egg())
        {
            sav_xor_increment(0xD);
            script_reset_environments_and_start(scr_egg_hatch);
            return true;
        }
        return safari_step();
    }
    script_reset_environments_and_start(scr_unk_per_step_end);
    return true;
}