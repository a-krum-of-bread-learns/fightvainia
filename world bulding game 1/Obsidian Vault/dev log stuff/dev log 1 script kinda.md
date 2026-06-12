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
	however when working with attack buttons we do want more then 1 input to be read at the same time for things like L punch + L kick = grab in sf6  or 3 buttons in guilty gear  = roman cancel ==(then show stock footage)== here is a visual example of how i did it for my project ==(show the 4 attack buttons)==  staring with 4 attack buttons when i press 2 of them i read that at both pressed at the same time i read it as 3 inputs ==(show the expanded buttons for the 2 pressed)==
- basic fighting game num-pad notation **not sure if i should explain it**
	num-pad notation can be used as one way to represent inputs in fighting games we can also use it to help us in code for people who are familiar with it or just have a number pad next to them when developing the motion in puts her are a few examples ==(examples 3 -5 one with a change example even tho i dont plan to have charge moves in my game )== 
	now that you have seen a few examples lets try a few for you to test you self if you understand it ==(a few for practice)==
- move list variable management  and choose action 
	==(pull images regarding an attack from an existing video game to make the visual tree)==
	in games with simpler combat systems they usually have 1 maybe 2 attack buttons at most 
	in fighting games its as high as 6
	additionally some games have a different attack linked to an attack button and a direction 
	then in fighting they have motion input witch basically mean up to infinity attack options
	simplified version of the variable management for a single button when explaining 
	a dictionary tree visual to explain what is happening at the end of the code 
	code sections 
	script parts
	section 0 into and pre req for building 
		if you want to follow along to build your own version the recomended prerequisite are you have an input manager system that handles and filter all inputs like in making a fighting game input system.  and you know your core conditions 
		~~this video does not cover stances or how to make those that would be int a combo attacks video~~ 
	in fighting games we have motion inputs and we have a ton of attack buttons allowing us to have basically infinite number of attacks. so how can we keep that under control and organized in a way is very easy to work with when its done. 
	
	attack uniqueness
	Every attack in a fighting game has a very specific set of conditions. Most commonly those are whether the player is on the floor, if they are facing right, and the unique motion and attack combination. this will help us decide what attack is the right one to use form our player inputs and state. they also form the key to every attack and ways to sort them. ==(image of key made of 4 parts)== 
	
	
	
	
	
	section 1 var deceleration
	here we define all of possible valid inputs such as the 9 main directions, the attack buttons and the motions we want this move list is also my single source of truth for these sequences 
	section 2 key structure 
	i use a resource witch i call an attack key to make the in a very specific way
	section 3 attack declaration
	here I declare each attack in my system they are nodes for eaerlt testign you may use stings an print them  and each name is also teling us waht the attacks contions are 
	section 4 attack org
	here every attack is given a name and that name tells us the conditions for the most part such as air_dqcf_light_punch then to put it in a dicontary we make a new attack key reousrce that has the mathcin contionds twice then make one for is facing rignt and one for is facing left
	section 5 ready func
	this function cleans up unused attacks as some characters may use a portion but not all attack combinations and other may use the rest.
	section 6 the clean look in editorby doing it in this whay and naming every thing nicely we can get a nice stuctirre like this in the editor to place an attack.

	seciotn 7 chose action 
	this was made in the making an fighting game input system but ill go over it a bit more here as well as correct a mistake i made with the final version
	
	
- how to code a fighting game input system
	assumptions
	1. you know num-pad notation
	2. you understand some games have motion inputs for attacks
	3. you have some familiarity with arrays and dictionary 
	4. you have a way to take player inputs and organize it into an array to check input history 
	cases of motion inputs frame perfect  236 exact
	just a sequences but no difrent input gaps 2333666 or some error gaps 2___3___6
	buffered allowance
	
	one of the most common things in fighting games are motion inputs ==(image)== but how do we make them in our own games. in this video i will go through the process of making a input sequence reader that starts reading only exactly one case then starts to add more flexibility *such as reading the most recent sequence as the priority and adding an attack buttion*.
	let me start by stating the outline of this video
	A. just taking in inputs form d-pad and joy buttons
		- mention previous video 
	B. saving direction information in list / array / input history 
	C. using direction information to may a special move
	lets begin with reading the inputs our player gives us. d-pad and buttons in godot this is faily easy the main lines we would need are Input.get_action_pressed("input name") and Input.get_action_just_pressed("input name")
	lets start with what the main concept  ==(images/ clips)==  the basics are we look at a set of inputs and read them then check against a reference to see if they match then we can decide if we want to do something entire with it or not.
	assumptions 
	2. you must have an array with input history
	3. you need to pick weather you will have the inputs given in rvers or you read in revers
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
		var corect_digits: int = 0
		var digits: Array[int] = sequence_spliter(sequence)
		var total_digits: int = digits.size()
		digits.reverse()
		
		for index in input_h.size():
			if input_h[index].has(digits.get(curent_digit)):# check if an input is vaild for that sqeuence 
				corect_digits += 1
				if curent_digit == total_digits:
					valid.get_or_add(index,sequence)
					corect_digits = 0
				else: pass
		return valid
	```
	some things to remember a sequence can be as long as you want it is up to the devlosepr and it can also be used to take in even single inputs to be checked like a jump 
	==**script parts**==
	part 1 first lets try to understand an existing system by looking at it. we can see on any given frame 1 direction and any number of attack buttons can be pressed. we also know that this list updates each frame to make a input history. if we break it into its components we have individual inputs that make a set of inputs for a given frame that make a full input history over time   ==(a visual aid)== input history that contains all inputs press on that frame (inputs of frame) that then contain individual inputs. what does this look like anser in your ==quiz== thing on youtube. (answer nested array or nested list )
	now that we know we are using a nested array we can start setting it up so the first thing to decide is what the data should look like for the input directions i used numpad notion ==(visual aids)==  as well as setting them to constants for the sake of code that is a little more readable so if you see any of these they are the same (the 3 versions of directions numpad notation and UL style notation) for the attack buttons i use the numpad notion + 10 since i only have 4 buttons to take in but any number will work as long as you are constants witch is why you may want a enumeration or constants that represent each attack button by name. ==(visual aid)==
	next we can put all the data from our players input into a list each frame. for 2 inputs it looks like this in godot. we just check if the input is pressed then add it to the frame 
	```
	var inputs_of_curent_frame: Array[int]
	const U = 8
	const D = 2
	const NEUTRAL = 5
	# enum {D=2, NEUTRAL=5 ,U=8} 
	
	
	func take_in_inputs():
    var up: bool = Input.is_action_pressed("ui_up")
    var down: bool = Input.is_action_pressed("ui_down")
    
    if up and down:
        inputs_of_curent_frame.append(NEUTRAL)
    elif up:
        inputs_of_curent_frame.append(U)
    elif down:
        inputs_of_curent_frame.append(D)
    else:
        inputs_of_curent_frame.append(NEUTRAL)

	```
	
	you can adapt this as you like or if you are also making a fighing game like me then it would probably look like this for the expanded code  ==(video clip)==
	for me it looks like this if you want more detailed information on how it works i have a managing inputs video witch goes over conversion of directional inputs.
	so far we have this
	```
	TAKE IN INPUTS -> MANNAGE INPUTS -> STORE IN LIST FOR THIS FRAME. 
	```
	next we save each the list each frame be careful of how it is done as you need to duplicate and the direction of witch the values are saved also matters  as you will need to be careful so that the values can be read properly the array so that it updates independently from past values. 
	==quiz==
	```
	input_history.append(inputs_of_curent_frame)
	input_history.append(inputs_of_curent_frame.duplicate())
	i dont know 
	```
	==(show sample code )==
	==(smile face visuals)== and explanation of each of us looking at different boxes showed visually so no need to show with code but do show current progress
	
	```	
	var input_history: Array[Array]
	var inputs_of_curent_frame: Array[int]
	const U = 8
	const D = 2
	cosnt NEUTRAL = 5
	# enum {D=2, NEUTRAL=5 ,U=8} 
	
	
	func take_in_inputs():
		inputs_of_curent_frame.clear
	    var up: bool = Input.is_action_pressed("ui_up")
	    var down: bool = Input.is_action_pressed("ui_down")
    
	    if up and down:
	        inputs_of_curent_frame.append(NEUTRAL)
	    elif up:
	        inputs_of_curent_frame.append(U)
	    elif down:
	        inputs_of_curent_frame.append(D)
	    else:
	        inputs_of_curent_frame.append(NEUTRAL)
   
	    input_history.append(inputs_of_curent_frame.duplicate())
	    
	```
	we now are taking in the input history of our players inputs we can start with making a sequence reader to verify that the player has input a special move correctly 
	*reading from oldest to newest*
	how this works is we take a look at our input history looking for a specific sequence ill jsu pick my new favorite fqcu can then look at the oldest frame and check if the forward input is pressed if not we can move on to the next frame and check again. once we find our first input we can check it off the continue checking the newer frames. we do this until we have the full sequence or we reach the end of the history. if we find a valid sequence we mark it and can use it for other things. ==(code example)==
	```
	func reader(input_h: Array[Array], digits: Array [int]):
		var correct_digits: int = 0
		var total_digits: int = digits.size()
		
		for index in input_h.size():
			if input_h[index].has(digits.get(correct_digits)):# check if an input is vaild for that sqeuence 
				correct_digits += 1
				if correct_digits == total_digits:
					print("vaild sequnce found")
					return true
		return false
		
		
		
		
	```
	==quiz==
	a. first come first serve 
	b. attack buttons
	c. both 
	d. nither
	*what if we have 2 or more valid sequences then we want the most recent*.
	to do this wee need to track what is the most recent valid sequence input witch we will find  at the end of our list. I do this by using a dictionary that stores the index as the key and the sequence we read as valid as the value. i store the sequence as a value because we are now tracking more than one sequence we need something that makes them unique witch is the sequence its self.

	code explain from previous code we need to declare a dictionary then when we find a valid sequence we add it to the dictionary.  we can then return the dictionary  
	```
	func get_vaild_sequences(input_h: Array[Array], digits: Array[int]) -> Dictionary[int, int]:
		var corect_digits: int = 0
		var total_digits: int = sequence.size()
		
		for index in input_h.size():
			if input_h[index].has(digits.get(curent_digit)):# check if an input is vaild for that sqeuence 
				corect_digits += 1
				if curent_digit == total_digits:
					return {index: digits}
					corect_digits = 0
		return {}
	```
	for a demo we will make a simplifed verison of my chose action function start by 
	making a fuction add the diconary of attacks
	`var move_list: Diconarty = {[2,3,6]: "attack dqcf", [6,9,8]: "attack fqcu"}
	then make a for loop that goes through it 
	```
	func choose_action():
		var most_recent_attack: String 
		var valids: Dictionary [int,Array]
		var move_list: Dictionary [Array, String] = {[2,3,6]: "attack dqcf", [6,9,8]: "attack fqcu"}
	for move_key in move_list:
		valids.merge(sequnce_reader(input_history, move_key),true)
	
	if valids:
		most_recent_attack = move_list.get(valids.get(valids.keys().min()))
	print(most_recent_attack)
	```
	*the edge case* 
	when recording this video i discoverd an edge case where if 2 sequnces have the same start index the would then have the same index. this is caused by reading from newst to oldest but not keeping track of the last digit of the sequence. the fix for it is simple when we find the first correct digit when reading newest to oldest save that index specifically 
	==(final code version of sequence reader)==
	we can then test this version but just using the process function make sure we are calling our function for taking in inputs then we can call a print to see if the reader returns the values properly print.
	part on calling the most recent 
	*attack button support*
	now that we know the input directions are working we can start to add support for attack buttons witch 
	if attack button pressed then check valid sequences 
	*buffering*

	this is the base of an input system for fighting games or any game that wants special moves like fighting games. a few things you can do to expand this is have more conditions like if the player is on the floor or in the air  you can have crazy sequences how ever you like. im sure if you want to you will be able to expand this core how you want or you could just take mine off of git hub 
	==make sure to explain why you used a dictionary  in this vid==
		i use it becue of key value paring 
		==(imgaes key and somthing)==
	my next video will probably be about the move list class witch is about 600 lines of just variable management 
	chose action things 
	loop through keys of the attacks  checking with the sequence reader then save the valid ones
	expanding saving to a dicoanrty
	we then save the sequences that we found valid and save it with its position in the history. we can then use that position in history to pick the correct attack
	attack button support with resource in the class
	currently we check if the sequence is valid but we can add any number of checks along side it we also want to standardize these checks so they are consistent and can be used in code easily.  in godot for this we will use a resoruce
	lets start by making our resource for this ill be doing it in the same script since i don't use it anywhere else. start by declaring the class attack key then add the conditions  the first being the sequence  he second being the attack button witch i put as type string to use with input.get_action_just_pressed later 
	in the chose action function we edit the move list key to be format of the Attack Key we just made and edit the parameters to match. next for clarity we add a type declaration to the for loop witch may just be a Godot thing. then we add an input check for the attack buttons before we check the sequence  
	editors note when i did the test i had digits as type Array not Array[int] its changed back to Array[int] a little later. then a little later we also edit how we call the sequence reader and here we can fix the typing for the sequcne reader
	buffered redo i make a function that takes in the buffed history and a single input. i then loop though  that history and check if it has the input we are taking in. if it does return true otherwise return false. next we edit the attack button parameter in attack key form a sting to the type we really want to use in my case i use int. we then make this change to the move list as well. we then replace when we check for an attack button to be pressed  with a call for the function we just made
- combo attacks system (target combo)
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

== lessons learned==
from how to code a fighting game input system
	when i tried to simplify it we found a few problems but made it more versatile 
	the same thing can be done in 2 different ways and still have the same result
	making a tutorial video that works is hard
