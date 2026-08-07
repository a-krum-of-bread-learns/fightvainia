- [x] stop player from being hit multiple times when there hurt box changes for the fixed hurt box
- [x] make an object that can be hit without extra baggage
- [x] force stop animations when hit
- [x] fix the active hurt box or see if an update fixes the signal 
- [x] kill_momnetum_of_tween is unused? now used
- [x] fix crouch walking 
- [ ] projectiles do not have unique hit exceptions so theoretically it may pass right through or hit the same thing twice on one instance
- [x] fix what the active hurt box is when attacking 
- [x] fix cancels being only on the very first frame when using hit stop 
- [x] add bounus frmaes for input history to allow resopnive but delayed cancels 
	for example input on frame 8 but the move gets cancels on frame 22 where the cancel window is  defined
- [ ] command normal come out when the direction is in history and buttion is pressed after outside of buffered array
- [ ] doing up up forward jump/lk forward causes the following actions the player does grappling hook on ground then jumps a few frames after end of attack.
- [ ] animation tool is kinda vibes based
- [ ] can attack when dashing if you have air attack with no dash start up

for main branch from core branch
- [ ] the frame node has a set disabled true where it shouldent in 3  of the add functions
- [ ] the frame node should call ready when the togle visable buttion is pressed
- [ ] make the renames automatic when the value is changed
	@export_range(0,300) var repeat_this_frame: int = 0:
	set(value):
		repeat_this_frame = value
		reqest_rename.emit()
- [ ] defult knock down doesnt hide the vector propites of the attack data
- [ ] move @export var humanize_time_in_frames: int = 0 @export var pause_time_in_frames: int = 0 to enemy settings and reorder the exports with do not touch 
- [ ] remove enemy base empty file and health ,gd
- [ ] in hitbox damage fucntion remove the  this part of the if stament get_parent().get_children().has(area) == false 
- [ ] start attack has been shortened
- [ ] un indent damage in hitbox area

for all breanches
- [ ] make unset direction normal default to the no input or the crouch version 9,7=8 4,6=5 and 1,3=2
- [ ] make the naming scheme consist for all attacks in the move list as light is not stated directly on some attacks
- [ ] the spawn object for the player spawns all at once when used
- [ ] kill momentum should be outside of the loop 
- [ ] hit box and hurt box don't have fix name buttons for the collision shapes  
- [ ] custom grabs/ i need a grab option stun type
- [ ] can follow up in attack is not in reset
- [ ] one way to make multi hits is to change how hit exceptions are handled and make them only affect the player then put a series of hit boxes on separate frames but may need to be a mix, projectile case is still an issue 
