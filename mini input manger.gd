extends Node2D
enum {DL=1,D=2,DR=3,L=4,NEUTRAL=5,R=6,UL=7,U=8,UR=9, # input directions
LK=12,HK=16,EXK=13,LP=14,HP=18,EXP=17,LPK=11,HPK=19, #attack buttons
DQCR=236,DQCL=214,UQCR=896,UQCL=874,LQCD=412,RQCD=632,LQCU=478,RQCU=698, #quarter circle motions
RDPD=623,LDPD=421,RDPU=689,LDPU=487, #dragon punch motions
DASHR=5656,DASHL=5454} 
var direction_look_up_array = [
		NEUTRAL,  # 0000 - no input
		R,        # 0001 - right only
		L,        # 0010 - left only
		NEUTRAL,  # 0011 - left + right conflict
		D,        # 0100 - down only
		DR,       # 0101 - down + right
		DL,       # 0110 - down + left
		D,        # 0111 - down + left + right (priority to down)
		U,        # 1000 - up only
		UR,       # 1001 - up + right
		UL,       # 1010 - up + left
		U,        # 1011 - up + left + right (priority to up)
		NEUTRAL,  # 1100 - up + down conflict
		R,        # 1101 - up + down + right (priority to right)
		L,        # 1110 - up + down + left (priority to left)
		NEUTRAL   # 1111 - all directions pressed
	]

var input_history: Array[Array]
var buffer_history: Array[Array]
var inputs_of_curent_frame: Array[int]
#
##const U = 8
##const D = 2
##const NEUTRAL = 5
## enum {D=2, NEUTRAL=5 ,U=8} 
	#


func take_in_inputs():
	inputs_of_curent_frame.clear()
	var up: bool = Input.is_action_pressed("up")
	var down: bool = Input.is_action_pressed("down")
	var left: bool = Input.is_action_pressed("left")
	var right: bool = Input.is_action_pressed("right")
	var bit_index =(int(up) << 3) | (int(down) << 2) | (int(left) << 1) | int(right)
	inputs_of_curent_frame.append(direction_look_up_array[bit_index])
	resize_and_append_to_array(input_history, 25, inputs_of_curent_frame)
	
func resize_and_append_to_array(array: Array, max_size: int, this_frame_inputs: Array[int]):
	if array.size() >= max_size:
		array.remove_at(0) # last index
		#add the new input the end
	array.append(this_frame_inputs.duplicate()) # add to front

func reader(input_h: Array[Array], digits: Array[int]):
	var correct_digits: int = 0
	var total_digits: int = digits.size()
	var index_of_most_recent: int
	input_h.reverse()
	digits.reverse()
	for index in input_h.size():
		if input_h[index].has(digits.get(correct_digits)):# check if an input is vaild for that sqeuence 
			if correct_digits == 0:
				index_of_most_recent = index
			correct_digits += 1
			if correct_digits == total_digits:
				print("vaild sequnce found")
				input_h.reverse()
				digits.reverse()
				return {index_of_most_recent: digits}
	input_h.reverse()
	digits.reverse()
	return {}
	
	
func reader_single_input(input_h: Array[Array], input: int):
	for index in input_h.size():
		if input_h[index].has(input):
			return true
	return false



func sequnce_reader(input_h: Array[Array], digits: Array):
	var correct_digits: int = 0
	var total_digits: int = digits.size()
	var index_of_most_recent: int
	input_h.reverse()
	digits.reverse()
	for index in input_h.size():
		if input_h[index].has(digits.get(correct_digits)):
			correct_digits += 1
			if correct_digits == total_digits:
				input_h.reverse()
				digits.reverse()
				return {index_of_most_recent: digits}
				
	input_h.reverse()
	digits.reverse()
	return {}

class AttackKey extends Resource:
	var sequnce: Array[int]
	var attack_buttion: int
	func _init(_sequnce: Array[int],_attack_buttion: int):
		sequnce = _sequnce
		attack_buttion =_attack_buttion
		
		
	

func choose_action4():
	var move_list: Dictionary[AttackKey, String] = {
		AttackKey.new([2,3,6],LK): "attack dqcf",
		AttackKey.new([6,9,8],LP): "attack fqcu"
		}
	var most_recent_attack: String 
	var valids: Dictionary [int,Array]
	

	for move_key: AttackKey in move_list.keys():
		if reader_single_input(buffer_history,move_key.attack_buttion):
			valids.merge(sequnce_reader(input_history, move_key.sequnce),true)
	
	if valids:
		var most_recent_index = valids.keys().min()
		var most_recent_sequnce = valids.get(most_recent_index)
		most_recent_attack = move_list.get(most_recent_sequnce)
		#most_recent_attack = move_list.get(valids.get(valids.keys().min()))
	print(most_recent_attack)
	
	
	
func choose_action():
	var move_list: Dictionary[Array, String] = {
		[2,3,6]: "attack dqcf",
		[6,9,8]: "attack fqcu"
		}
	var most_recent_attack: String 
	var valids: Dictionary [int,Array]
	

	for move_key in move_list.keys():
		valids.merge(sequnce_reader(input_history, move_key),true)
	
	if valids:
		var most_recent_index = valids.keys().min()
		var most_recent_sequnce = valids.get(most_recent_index)
		most_recent_attack = move_list.get(most_recent_sequnce)
		#most_recent_attack = move_list.get(valids.get(valids.keys().min()))
	print(most_recent_attack)
	
func _process(_delta: float) -> void:
	print(input_history)
	take_in_inputs()
	choose_action()
