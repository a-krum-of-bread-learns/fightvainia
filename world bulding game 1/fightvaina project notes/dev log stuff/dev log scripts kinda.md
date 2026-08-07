#devlog/script
things i want to talk about 

at the begin of all videos / recording say bismallah and as-salamu alakum, hello welcome to this video (video topic) i recommend you take notes while watching to help you retain the information for your own projects with a physical or digital note book. as notes are very good to have when you what to check something again.


at the end of all videos say salam and i hope this was of benift for you and i hope you took notes to retain the information to

should try motion canvas.

- [x] input management without motion inputs  
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
- [x] sequences for fighting games
- [x] how to develop a fighting game with more of the code stuff

- [x] move list variable management  and choose action  
	==(pull images regarding an attack from an existing video game to make the visual tree)==
	when making a fighting game you will quickly realize that its really hard to mange all the attacks without a nice system to stay organized
	in games with simpler combat systems they usually have 1 maybe 2 attack buttons at most 
	in fighting games it can some times seem excessive ==(hit box)== then we we have command normal adding a whole lot more attacks ==(comand normals on top of hit box)==
	then in fighting they have motion input witch basically mean up to infinity attack options ==(infinty ontop)==
	
	simplified version of the variable management for a single button when explaining 
	a dictionary tree visual to explain what is happening at the end of the code 
	code sections 
	script parts
	section 0 into and pre req for building 
		if you want to follow along to build your own version the recomended prerequisite are you have an input manager system that handles and filter all inputs like in making a fighting game input system video.  and you know your core conditions 
		~~this video does not cover stances or how to make those that would be int a combo attacks video~~ 
		if you want to build your own system you'll a prerequisite you will need is a fully working input management system that filter the inputs.
		if you are watching this early and I have not made the correction to the input system video regarding the chose action function you have heard this message and it will be corrected at the end of the video then removed when It is corrected  
	in fighting games we have motion inputs and we have a ton of attack buttons allowing us to have basically infinite number of attacks. so how can we keep that under control and organized in a way is very easy to work with when its done. 
	
	attack uniqueness
	lets see what deines each attack   
	First every attack in a fighting game has a very specific set of conditions.==(reuse image form input video on attacks with additional conditions)== Most commonly those are whether the player is on the floor, if they are facing right, and the unique motion and attack combination. this will help us decide what attack is the right one to use form our player inputs and state. they also form the key to every attack and ways to sort them. ==(image of key made of 4 parts)== 
	
	I need to explain the naming scheme some where 
	
	section 1 key structure for how i did this in code i made a resource called attack key. i added all my important universal conditions and make my own _init()_ to set them when i make a new resource in code
	section 2 var deceleration
	in my move list script i make I define all of possible valid inputs such as the 9 main directions, the attack buttons and the motions I want to allow 
	section 3 attacks and how they are sorted
	in the next part of the code I declare each attack giving it a name with the structure ground state, motion, and final input button. I use @export_group and @export_subgroup to organize the attacks both in code and in editor
	
	then ever single attack is put into a dictionary with the correct attack key. each attack gets 2 lines in the dictionary one for facing right and the other for facing left. also take note that my sequences also change from from the right facing version to the left facing version and vice versa. this is because the input system i made doesn't account for it but here the move list is where it is accounted for
	
	section 5 ready func
	the last part of the move list script is the ready function witch combines the all the smaller dictionaries into a few large ones like normals, command normals, specials . it then cleans up unused attacks and puts them in all attacks
	section 6 the clean look in editor 
	doing it in this way and naming every thing nicely we can get a nice structure like this in the editor to place an attack.
	
	section 7
	if you are coming from the my video on making the fighting game input system you'll need to add 2 conditions here to check like this. do note that this is taken form the my local code where I have fully implemented most of my systems so if you are making it your self do not assume you have all of the properties in this image.
	section 7.1 chose action correction
	regarding the correction the look at the original code here this section here is supoed to be indented and have the following code instead. you may not have noticed any issues but this fixes picking the most recent attack.
	
	to end off this video here is my full move list at the time of recording witch is over 600 lines of code. when i need to edit this very large repetitive file i use AI. I do this since it may be considered torture to have some one manually edit this file to just add a sequence and i would be surprised if this file is made to be a lot larger.
	video description 
	I go over how to keep attacks organized when fighting game characters have so many showing mostly the code side of this system while being more of an overview rather than step by step as it is a file for just managing variables.
- [x] how to code a fighting game input system 
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
- [ ] basic fighting game num-pad notation **not sure if i should explain it**
	num-pad notation can be used as one way to represent inputs in fighting games we can also use it to help us in code for people who are familiar with it or just have a number pad next to them when developing the motion in puts her are a few examples ==(examples 3 -5 one with a change example even tho i dont plan to have charge moves in my game )== 
	now that you have seen a few examples lets try a few for you to test you self if you understand it ==(a few for practice)
- [ ] attack system 2 videos or 2 parts 1 for overview and 1 for code not including cancels multi hit attacks 
	- manager, attacks, frame, hit/hurt boxes and collision shapes, the forced structure too visible collision shapes 
	- make sure to have a spot saved on the screen for current script
	- video parts
		how attacks work: visual run through of attacks 
		multi hit attacks: 
		visual of cancel windows and the simplest form forced follow up 
	- quiz qestion where should the code for telling when the cancel window is be 
	- attack manger
	- attack 
	- hit box
	- manger outline 
		current attack
		start and contue attack
	- attack outline 
		mainly a container with a few propteys and a reset function for its self
		active frame 
		frames: array[frame]
	- frame outline
		repeat this frame 
		set frame disabled
	- hitbox outline
		on area entered 
		damage (use queue free)
		set collision layer and mask
		has hit signal
	- hurt box out line
		set collision layer and mask
		refence to host/ char body 2d or just hurt box and stun manager
	self hit protection
	- additional end of vid stuff:
		show how i do cancels and where for what a little bit 
- [ ] combo attacks and speical cancels system (target combo)
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
- [ ] responsible/ respectful usage of AI in code development  could be a video on its own
- [ ] how high low blocking works including projectile case 
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
- [ ] quick debug tool for frame by frame stuff 
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
- [ ] how to make a simple attack
	0. if you don't already have the setting =="debug > visible collision shapes on"== i recomed setting it.
	1. make new scene and instantiate the scene base character then select the root node (the ==character body 2D== or right click and turn on editable children if the scene is is not the root)
	2. since we are only making an attack just 
	3.  look for the ==attack manger node== and click on it this node will hold and manage all attacks. once you click on attack manger then on the right make sure you are on the ==inspector tab== look for and click on add attack when you press it you should see a new node appear in the scene tree with a name similar to this @Node2D@30553 rename it as you like then make sure its selected. 
	4. you should see a ==buttons section and intermediate attack properties== for now ignore those properties until the intermediate section/ video. 
	5. once its selected in the inspector you should see new buttons the first ==adds a frame node== the other 2 are for when we are editing our attack but we are still creating so skip them for now. for your first attack it is recommended to add 3 frame nodes if you are just debugging or want to get a feel for the fame data
	6. once those are added click on each frame and decide how many times you want it to repeat using the ==repeat this frame property under frame info== when you change the number you can see how it updates the name of the frame node to give you an accurate picture of the duration. 
	7. once you are satisfied with how long the attack is then you can click on the middle frame node where we will add more nodes.
	8.  there there are multiple ==add buttons== for the beginner section we will not use the projectile or spawn object buttons. as those are more complex and projectile builds on hit box
	9. if you have art your attack is based on add a sprite under the frame currently only 1 frame of animation is supported per frame but multiple sprites are supported 
	10. the hit box add just 1 then click on it. you will see a it named and a warning next to it that is the collision shape is not added warning so you can add one using the ==editor or a button i made that adds a square collision shape==. there are more than just square shapes in Godot
	11. using the ==2D editor== or the inspector you can manipulate ==the box==. you can also add another collision shape to make more complex shapes form simple shapes ill add another one and also move it around. 
	12. once I'm happy with that ill click on the the ==hurt box area== again and then edit the attack data there are a lot of properties so try them all out most are kinda of self explanatory if you know fighting games decently well if you don't care i have provided a sample data witch you can quick load.
	13. next you can click on the frame node and add a hurt box and manipulate it as well. now just to make sure you didn't break anything on acaedent make sure the nodes under the attack manger look like this tree if any node is not in its correct level that node will be ignored by the system
	14. congrats you made you first simple attack. to save it right click the attack node with the name you renamed it to then save as branch. the scene tree will hide the other node below the attack so you don't change it by mistake. if you want to edit the attack again open the scene it saved to and edit as you like
	15. the final most important thing is to assign the attack as well see creating a player or cpu for that  but for players assign to the move list node and cpu to the combos and pokes in enemy logic
- [ ] how to make advanced attacks
	0. if you have not watched the first beginner video do that first
	1. 
- [ ] how to make a cpu or a character
	to make a player or CPU is pretty similar
	1. first instantiate the scene base character or enemy base give them the stats you want  for players use player stats for enemies use enemy stats
	2. next add or make the attacks to the attack manager see the make an attack series
	3. next assign the attacks. for players assign them to the move list node where you can decide on weather the attack is a special move or a normal.
	4. for the cpu click on enemy logic assign the attack to one of the lists in combos  and edit the settings as you please then 
	5. finally assign a primary hurt boxes scene to the entity. to change the primary hurt boxes of the entity you are making then duplicate the the original primary hurt boxes and sprites scene and edit its collision shapes and sprites. then assign it and make sure its in folder to be scaled so the art flips properly 
- [ ] project overview 
	0. v = (there isn't any good resource... + (right? -> e)) x (the project + this channel me and goals add akrum in this part)
	1. there isn't any good resource on how to make a fighting game from scratch. right? my to that question answer was no. 
	2. a) what is this thing and how is it being developed and by who 
		- so i decided to make the fightvainia project. 
		- a low code fighting game creation tool focusing on the character creator its also these thing ==image list of==: copyleft, GNU 3 licence, the Godot engine open development. 
		-  made me by a_krum_of_bread_learns about 90% and free token usage of Claude 8% 1% community and 1 % other git projects. now before you leave the project is open development you can stare at me thinking to solve problems on youtube and twitch and verify how much i actually use AI witch would be nice.
		- on git hub branches:
			- core is close to release ready and bloat/ a_krum's own game stuff is mostly removed
			- main is the working branch for a_krum_of_bread_learns and his own game 
			- AI code review is for large code refactors over a good amount of time and a person still works on it recording the work on YouTube
	3. who am i 
		- I'm Muslim a student in university studying engineering as well as a person who likes a verity of games 
		- enjoys watching the chanels Veritum, RinPenrose, RTgame, Aliens rock or similar for fun and a small part of the FGC for research and fun   
		- i m learning japanes becue i want to knows arabic somewhat 
		- regarding game development and expedience in the fgc im pretty new to both so don't expect anything perfect 
	4. why release a 0.5.0 version and not wait till 1.0.0
		- community contributions
		- bugs idk how to fix listed on something git hub
		- get feedback on new features or others find bugs for me
		- see how close to ready this is from others
		- i go back to school  
	5. b) some one in the fgc please tell people this exists 
		- help me
	6. b) where can you find me 
		-  i will not make social media accounts i would rather delete them 
		-  don't contact me if you are not part of this list i like my privacy
			i emailed you, you one of the following form this list and i may be willing to work with subject to conversations: Veritum, RTgame, Rin Penrose Ch. and Snebby or Zoey the manger of managing Rin's things, brian_f/trash talk, broski, sajam, Diaphone, justan wong, lord kight, a video game development company that will use godot or wants to make a fighting game using my system (may cost my tuition in payment). 
			companies/games/people i may be okay with colabing/cross overs or stuff with on **my terms when it comes to character clothing. "game core value no sexualization of people ever"** then subject to discussion: Pal world, Terraria, Chaos Zero Nightmare, Path To Nowhere, toby fox, camellia (かめりあ), Lena Ranie, the people behind after image, team cherry, people behind guacamelee 
			you made a real bug report in the issues or are trying to contribute.
- [ ] set up with version number let 0.5.0 and Godot version 4.6.3 
	1.  set up for the project set up on a fresh install
		- open project > project settings > plugins > fightvainia auto loads. this enables hit stop and shake, partly the frame by frame mode script, and the on hit audio manager, 
		- next we can set up inputs either *run the add_inputs script to get my default input map that is like this ==image of input maps==* the other option if you have an existing input system  is to edit the 2 following the files input manger and frame_by_frame_mode search them up using the filter files option ==\<image of it==
		- you can try out an example scene to get a feel for the current default movement (mostly flexible in air and state based on ground) and how default attacking feels (when attacking walking is disabled attacks have customization of animations numbers aren't exact)
	
	- a) rember if you want to use the project look up copy left and the gnu3 licnce to before making your decion
	- b) welcome to my channel subscribe or not see you next summer
- [ ] dev update 1?
- [ ] how to experment in code
- [ ] how to design match ups in video games
	need to analyze how to pick a match up first as well as the tools each char has and what makes a severe shift in match up from altering there tools	
	one idea is have a already designed charter and design a counter for them only without it being a property that can be univeral

- [ ] what were my decisions making the game who affected them 


== lessons learned==
from how to code a fighting game input system
	when i tried to simplify it we found a few problems but made it more versatile 
	the same thing can be done in 2 different ways and still have the same result
	making a tutorial video that works is hard
from move list 
	I can edit the full time line using the sequence button to pull up its effects
