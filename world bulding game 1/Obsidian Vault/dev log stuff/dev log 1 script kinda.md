#devlog/script
things i want to talk about 

at the begin of all videos / recording say bismallah and as-salamu alakum, hello welcome to this video (video topic) i recommend you take notes while watching to help you retain the information for your own projects with a physical or digital note book. as notes are very good to have when you what to check something again.


at the end of all videos say salam and i hope this was of benift for you and i hope you took notes to retain the information too

- input management without motion inputs
	*assumptions* 
	1. *you know what a fighting game is* 
	2. *you may have an interest in coding a fighting game* 
	3. you have an input system
	for the input direction we only want one direction each frame otherwise there may be unexpected behavior. 
	this could be any of the 9 values UL, U, UR, L, N, R, DL, D, DR ==(images)== that make sense
	to do this with only 4 buttons for the 4 buttons in a d-pad ==(image)== 
	if i press 2 buttons i should get the one resultant out put ==(image)==
	if we some how press 3 or 4 like when using a hitbox ==(image)== we should also filter those as well ==(image)==
	if we want to do this in code (godot editor or similar) we can have an if statement check for each condition starting with the 4 button case and going down to the 3 then 2 then 1 then 0 button case like this ==(image)==
	this can also be done with a binary look up table (or truth table or Bit mask lookup table) like this ==(image and truth table image)== corresponding to the table as shown
	now lets consider the player decides to use a joy stick instead of a d-pad or hit box. the joy stick doesn't give whole as it is an analog input  ==(clip with joy stick and position values)== values so we need to account for that by rounding or adjusting the value to be working
- basic fighting game num-pad notation **not sure if i should explain it**
	num-pad notation can be used as one way to represent inputs in fighting games we can also use it to help us in code for people who are familiar with it or just have a number pad next to them when developing the motion in puts her are a few examples ==(examples 3 -5 one with a change example even tho i dont plan to have charge moves in my game )== 
	now that you have seen a few examples lets try a few for you to test you self if you understand it ==(a few for practice)==
- move list variable management 
	==(pull images regarding an attack from an existing video game to make the visual tree)==
	in games with simper combat systems they usually have 1 maybe 2 attack buttons at most 
	in fighting games its as high as 6 
	additionally some games have a different attack linked to an attack button and a direction 
	then in fighting they have motion input witch basically mean up to infinity attack options
	simplified version of the variable management for a single button when explaining 
	a dictionary tree visual to explain what is happening at the end of the code 
- how to handle motion inputs  like 236 lp not  5 lk 2 hp
	assumptions
	1. you know num-pad notation
	2. you understand some games have motion inputs for attacks
	3. you have some familiarity with arrays and dictionary 
	4. you have a way to take player inputs and organize it into an array to check input history 
	cases of motion inputs frame perfect  236 exact
	just a sequences but no difrent input gaps 2333666 or some error gaps 2___3___6
	buffered allowance
	
	one of the most common things in fighting games are motion inputs ==(image)== but how do we make them in our own games. in this video i will go through the process of making a input sequence reader that starts reading only exactly one case then starts to add more flexibility *such as reading the most recent sequence as the priority and adding an attack buttion*.
	lets start with what the main concept  ==(images/ clips)==  the basics are we look at a set of inputs and read them then check against a reference to see if they match  then we can decide if we want to do something entire with it or not.
	assumptions 
	1. you must have an array with input history
	2. you need to pick weather you will have the inputs given in rvers or you read in revers
	for the example of reading 236 from the sequne of 525236525
	```python
		
		input_histroy: Array[int] = [5,2,5,2,3,6,5,2,5]
		
		func reader(input_h: Array[int])
			var corect_digits = 0
			for frame in input_h
				if corect_digits == 0 and frame == 2
					corect_digits += 1
				elif corect_digits == 1 and frame == 3
					corect_digits += 1
				elif corect_digits == 2 and frame == 6
					corect_digits += 1
					print("the sequence is found at least once")
		
		
		#reset it 
		corect_digits = 0
		```
	now that we have the most basic reader i want you to try to see if you can make it read a different sequence. 252 then to read any sequence by replacing some numbers with variables ==(image / try it your self prompt)==
	
	once you have that done think about what kind of logic errors there will be or where there is more inflexibility and what problems that may occur for you game's specific systems
	the changes you may expect regarding the challenge prompt
	```python
	frame == a_vaiable
	or 
	func reader(input_h: Array[int], digits[int])
		for frame in input_h
			if frame == digits[corect_digits]
				corect_digits += 1
				if corect_digits == 3 or corect_digits == total_digits 
	
	```
	in many game you can press more than button in a single frame such as a direction and attack button in this case the input history need to be expended to take both of them you can use a nested array and use the . has function to find the specific button pressed during a frame ==(image nested array tree)== 
	```python
	input_histoy
		inputs_of_a_frame
			indvual_inputs
			
			[# full array
			[2,12], #single frame with 2 inputs
			[3],#single frame with 1 inputs
			[6,34,56] #single frame with 3 inputs
			] #end of the array
	```
	
	another problem is if you'd like the most recent sequence used rather than the first to be valid. to do this you would need to know what index the valid sequences are at then take the one corespoonding to the most recet sequence for my game i used a dictionary with the key being the index and the value being the attack/the sequence
	
	below i the reader i am currently using with not th same amout of claity *may want to edit it to match the exaples more closey* ==(can show it running in code a little)==
	
	```python
		
		func get_vaild_sequences(input_h: Array[Array], sequence: int) -> Dictionary[int, int]:
		var valid: Dictionary[int,int]
		var curent_index: int = 0
		var corect_digits: int = 0
		var digits: Array[int] = sequence_spliter(sequence)
		var total_digits: int = digits.size()
		digits.reverse()
		
		for inputs in input_h:
			curent_index += 1
			if inputs.has(digits.get(curent_digit)):# check if an input is vaild for that sqeuence 
				corect_digits += 1
				if curent_digit == total_digits:
					valid.get_or_add(curent_index,sequence)
					curent_index = 0
					corect_digits = 0
				else: pass
		return valid
	```
	some things to remember a sequence can be as long as you want it is up to the devlosepr and it can also be used to take in even siingel inputs to be checked like a jump 
- combo attacks system
	in games like devil may cry, highfi rush, Metal Gear Rising: Revengeance, Beyoneta and many ==(sevral images or clips)== fighting games and more they have what i am calling a combo attack but may be known as  or target combo or rhythm attack or special cancel system 
	to put it simply it is an attack that is followed by another attack within some time frame 
	for a visual representation that is not an example ==(put a frame bar with x length show it normally then do it again but start a combo attack before ending it )==

	to do this i code we need to specify what part of the attack is valid for canceling into the new attack

	simplified code snit-bit  must be adapted for your game with your systems
	assumptions 
	1. you have 2 separate attacks but ill be using prints instead 
	2. you are working with a frame timer not numerical timer Godot maintains 60 fps
	3. you plan  to make this work for multiple attacks using some form of attack manger
	```go
	var is_attacking: bool = false
	var can_combo_attack_start_frame = 10
	var can_combo_attack_end_frame = 100
	var timer = 0
	
	
	
	if Input.is_action_just_pressed("attack") and timer == 0:
		is_attacking = true
		print("attack 1 started")
		
	if is_attacking == true and Input.is_action_just_pressed("attack"):
		print("start attack 2 ")
		timer = 0
		
	if is_attacking and timer < 100:
		timer = timer + 1
	else: 
		timer = 0
		is_attacking = false
	```
	some considerations 
	1. should the attack combo
- responsible/ respectful usage of AI in code development  could be a video on its own
- how high low blocking works including projectile case 
	*assumptions* 
	1. *blocking exists* 
	2. *you may have an interest in coding a block mechanic* 
	3. *how Godot has areas and collision shapes separate in operation* 
	when it comes to blocking in fighting games there is more than one way to do it for example in street fighter 6 they has single direction blocking and omni-blocking witch they call parry.   super smash bros also uses omni blocking but the method of inputting a block is diffident. there are also there things that could fall under the category of blocking such as counters and armor but those will not be covered her only single direction and omni blocking.

	so for the most simplified version of a block when an attacker attacks check for the blockers blocking state if they are blocking great they don't get hurt if not then some damage may be dealt. this is one way to implement blocking called omni-blocking witch doesn't care about direction or type of attack like parry in street fighter 6. ==(short clip)== 
	
	next there is type dependent blocking witch is like the high, mid, low cases in many fighting games. in this case an attack is assigned a type high mid or low==(short clip either an attack with that property or some shapes)== and so is the block. when an attacker attacks in this case then you must check whether the blocker is blocking and check why block type the blocker is using. in street fighter 6 there are the 3 attack types mentioned before and 2 block types witch are high and low, the mid attacks are blocked by both block types.
	
	next some blocks are not omni-directional but instead block only limited number of  directions. for the case of sf6 you can call it single directional as you either block left or right. this is what causes the cross up notification to pop up ==(short clip)== when the blocker is hit in some cases. when this happens  it is because of the following the attacker attacks from the one direction while the blocker is blocking in the wrong direction ==(image)==. 

	now for the directional blocking there is a special case to consider witch occurs when there is a projectile attacking from one direction and the character is on the other side there are is more than one way to handle it in street fighter 6 it is handled by the blocker needing to block the the attacker direction ==(image or clip)== or the blocker need to block the projectile direction ==(image or clip )== this one depends on what you think is best for you game. 
	
	now lets consider how to make this in code each of these in code ill be using Godot and i'm making the following assumptions 
	1. you have an attack, attacker, or  an active hit box that does an attack
	2. you have a blocker entity like a hurt box
	3. either the blocker or the attacker can read the information from one of them.
	4. you have a projectile for the projectile case 
	*what this means to me is they have 2 areas one that attacks / deals damage and one that blocks or gets hurt*

	code segment
	key code using ifs 
	```
	attacker code 
	const HIGH: int = 1
	const LOW: int = 2
	var attack_type: int =  HIGH
	
	on_body_entered (blocker):
		if blocker is !Blocker:
			return # exiting this wrong area type
		
		var attack_from_right: bool = self.global_position.x > blocker.global_position.x
		
		
		if blocker.is_blocking:
			print("blocker is blocking")
			
			if blocker.block_type == attack_type:
				print(" and blocker chose the corect block type")
				
				if attack_from_right == blocker.is_facing_right:
					print(" and blocker chose the corect direction")
					
				else: print(" and blocker chose the wrong direction")
				
			else print(" and blocker chose the wrong block type")
			
		else: print("blocker is not blocking")
		
		
		
	blocker code --------------------------------------------
	
	const HIGH: int = 1
	const LOW: int = 2
	var block_type: int =  HIGH
	var is_blocking = true
	var is_facing_right true
	``` 

	some additional consideration 
	1. you need to decide how damage works using i-frames or hit exceptions 


- one way to handle frame by frame stuff ?
- quick debug tool for frame by frame stuff 
	when working on a fighting game one of the most important things is frame data.  what we need is something that freezes the game but still allows us to control it in some ways like giving inputs 1 frame at a time. for Godot there are 2 key things for this one a nodes process_mode and 2 the scene tree. 
	we can use the scene tree and its boolean property paused to freeze the game. then we can un-pause the game for 1 frame at a time when we want to progress it. if we try to make this we will find that we can pause it but not un pause this is where the process_mode comes in. for something to work when the scene tree is paused its process mode must be changed  from the default type. 
	this code paused and unpauses only
	asumptions 
	1. you know how to make an input button for your engine 
	```python
	func _ready() -> void:
		process_mode = Node.PROCESS_MODE_ALWAYS
	
	func _process(_delta: float) -> void:
		if Input.is_action_just_pressed("frame by frame mode button"):
		get_tree().paused = !get_tree().paused
		frame_by_frame_mode_endabled = not frame_by_frame_mode_endabled
	```
	 if we want to progress exactly 1 frame we need to un pause it then wait till every thing is processed for that frame then we can pause it again we can use the key word await to do this.
	 this code is the progess by 1 frame
	```python
	 if Input.is_action_just_pressed("frame forward"):
		if get_tree().paused:
			get_tree().paused = false   
			await get_tree().process_frame# this must be the same process tiype
			get_tree().paused = true
	```
