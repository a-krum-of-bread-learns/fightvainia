## holds all the main movemnt opptions may want to splitit up into separte compents
class_name Movement extends BehaviourBase
@export var prejump_timer: FrameTimer ## the timer fro prejumping 
@export var coyote_timer: FrameTimer ## a timer to check if we can still jump without it being considerd in air see [TimerComponet]
var current_jump_direction: int ## saves the value for the jump while the delay happens
var can_c_jump: bool = false

@onready var remaining_air_jumps: int = (host.stats as PlayerStats).max_air_jump_count ## tracks if the player can jump again in air

#FIXME jump buffering or make it an "attack" 

##ready set go (8) ## renameing 
func _ready():
	self.name= "movement"
	super._ready()
	if coyote_timer == null: push_error("Movement: coyote_timer not assigned")
	(host.control_node as InputManager).jump_signal.connect(start_jump)
	
## this fucntion alows side ways movement based on speed ans direction
func movement_update(desired_dir: int) -> void:
	if !enabled: return
	# crouch or attacking case on ground
	if host.is_on_floor() and (host.is_crouching or host.is_attacking):
		host.velocity.x = 0
		host.is_dashing = false
		return
	# if dash early return
	if host.is_dashing:
		return
	# normal walk
	if host.is_on_floor() and not host.is_crouching:
		host.velocity.x = host.stats.move_speed * desired_dir
		return
		#air contol secction
	if not host.is_on_floor():
		if desired_dir != 0:
			if host.velocity.x > host.stats.move_speed:
				pass
			else:
				host.velocity.x = clamp(
				host.velocity.x + desired_dir * 10,
				-host.stats.move_speed,
				host.stats.move_speed
			)
		# reversing direction mid-air gets a small push each frame; holding the same
		# direction as current velocity does nothing, so momentum isn't accelerated further
		#elif sign(host.velocity.x) != sign(desired_dir) and desired_dir != 0:
			#host.velocity.x = host.velocity.x + desired_dir * 3

'''

if fluid movement (more like platformers)
	level design is less restrictive and less prone to soft locks
	combos are more interesting but require more control from the attacker
	mix ups are more evil
	movement options (dash, air control, etc.) start doing double duty as both traversal AND combat tools, which can make the kit feel more expressive but harder to balance
	backgrounds/stages can use more verticality and gaps since players can reliably navigate them

elif restrictive movement (more like fighting games)
	combos are not as droppable based on player jump control (easier, but maybe less interesting)
	combos are primarily spacing dependent on the attacker's end, not defender influence


if defender air control during hitstun
	defender can drift out of some juggle routes, punishing bad spacing by the attacker
	reduces "tod" combo potential since the defender has an escape tool
	attacker needs tighter timing/spacing to keep a combo airtight rather than relying on fixed hitstun windows, and may need different moves or variable timing to continue the combo as the defender drifts
	attacker may prefer combos on the ground to reduce the chance of combos dropping from opponent influence
	defender may be able to force a low-hitting combo down to the ground early, limiting the attacker to OTG moves or forcing a larger damage scaling penalty or entering the wake up state sooner
	can force resuces to keep a nearly droping combo from droping 
	hit grab style moves that set posion become much more valuebale
	traking moves become much more valuebale
	movemnt during combos becomes more valube
	combos need to bedesigneed where safe combos are weak even if long  and risky drift prone are harder and stronger since the other player has a say 
	cpu code may need adjustments
	push back on ground combos can be adjusted a little
	can make a propery that makes the player have stronger infulance when stuned
	bigger hurt boxes means consistant combos more offten by a lot 
	

elif no defender air control during hitstun
	defender has little to no ability to influence position once launched
	combo routes are consistent and repeatable since the defender's position is predictable
	raises the importance of not getting launched in the first place, since escape is unlikely once airborne
		
'''

func start_jump(dir: int):
	#bit of set up 
	if host.is_on_floor() and host.is_jumping == false: 
		coyote_timer.start_frame_timer(host.stats.c_timer_length)
		can_c_jump = true
	elif host.is_jumping:
		can_c_jump = false
		host.is_falling = true
		host.is_dashing = false
		
	#ground 
	if host.is_on_floor():
		remaining_air_jumps = (host.stats as PlayerStats).max_air_jump_count
		continue_jump(dir)
		coyote_timer.frames_left = 0
		print("g")
	
	#coyote jump
	elif (host.is_on_floor() == false
	and coyote_timer.frames_left > 0 
	and can_c_jump): 
		coyote_timer.frames_left = 0
		continue_jump(dir)
		print("c")
	
	#air jump
	elif (remaining_air_jumps > 0):
		remaining_air_jumps -= 1
		continue_jump(dir)
		print("a")

#TODO consider using += if the speed is greater than or less then in the same direction 
# probably wont to above comment for a while
## allows the player to set speed to a vector
func continue_jump(input_direction: int):
	if !enabled: 
		return
	var jump_vector: Vector2 = Vector2(host.stats.move_speed*input_direction,host.stats.jump_velocityY)
	if host.is_jumping == false: 
		prejump_timer.start_frame_timer(host.stats.prejump_frames)
		host.is_jumping = true
		current_jump_direction = sign(jump_vector.x)
	elif prejump_timer.frames_left == 1:
		host.position = host.position + Vector2(0,-2)
	elif host.is_jumping and prejump_timer.is_stoped():
		host.velocity = jump_vector
		host.is_jumping = false
		current_jump_direction = 0
		
## process is process (7)
func _process(_delta):
	if host.is_stuned: return
	if host.is_attacking == false:
		if host.is_jumping: continue_jump(current_jump_direction)
		
