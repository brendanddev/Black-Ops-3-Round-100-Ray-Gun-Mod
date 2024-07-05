/*
Author: @devDrendos 
Template: @CabCon
Assistance from @ModMeBot on ModMe Forums

First Mod with GSC.

The mod allows the player to start a zombies game at round 100, with 999,999 points, all perks found on the map, with the ray gun, 
 aswell as increased zombie speed (sprinters), and minimzed zombie health.

*/

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_perks; 

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_zm_perks.gsh;

#namespace clientids;

REGISTER_SYSTEM( "clientids", &__init__, undefined )
	
function __init__(){ // Initialization Function
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned ); 
	thread change_zombie_health(1); // Zombie Health Change Function
	thread zombie_speed(); // Zombie Speed Change Function
}	

function init(){
	level.clientid = 0;
	level.player_starting_points = 999999; // Sets the player starting points to 999,999
	thread starting_round(); // Starting Round Function so game starts at round 100.
}

function on_player_connect() { // Function executed when player(s) connect to game.
	self.clientid = matchRecordNewPlayer( self );
	if ( !isdefined( self.clientid ) || self.clientid == -1 )
	{
		self.clientid = level.clientid;
		level.clientid++;
	}
}

function on_player_spawned() { // Function executed when player(s) spawn into game.
	level flag::wait_till( "initial_blackscreen_passed" );
	iPrintln("^@devDrendos"); // Prints text to screen
	wait(5); // Creates a 'pause' between code execution
    self giveWeapon(GetWeapon("ray_gun")); // Gives player Ray Gun
    iPrintln("Ray Gun given"); // Confirms Ray Gun being given
    array::thread_all(getplayers(), &zm_utility::give_player_all_perks); // Gives players all map perks
    iPrintln("Perks Given!"); // Confirms Perks given to players
}

function change_zombie_health(starting_health) { // Zombie health manipulation function
    level endon("intermission");
    while (1) {
        zombies = GetAISpeciesArray("axis");
        foreach (z in zombies) {
            if (isDefined(z.animname) && z.animname == "zombie" && !isDefined(z.health_reset)) {
                z.health = starting_health;
                z.health_reset = true; // Prevents the reassigning of health repeatedly
            }
        }
        wait(0.25);
    }
}

function starting_round() { // Round 100 function
	level endon("game_ended");
	wait(1);
	zm_utility::zombie_goto_round(101);
}

function zombie_speed() {
	level endon("game_ended");
	while (1) {
		if (level.gamedifficulty == 0) {
			level.zombie_move_speed = 71;
		} else {
			level.zombie_move_speed = 71;
		}
		wait(1);
	}
}