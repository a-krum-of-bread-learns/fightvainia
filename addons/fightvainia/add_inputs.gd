## this script sets a defualt contol lay out based on the deveopler of fightvainia's contol scheme in a auto load
## fightvaina defualt contols witch are bad but work for testing 
# this script had some ai help  and some jsut finding things online 
@tool 
extends EditorPlugin

const dictionarykeys: Dictionary[StringName, Key] = {
	"frame by frame mode 2": KEY_F,
	"right 2": KEY_D,
	"left 2": KEY_A,
	"up 2": KEY_W,
	"down 2": KEY_S,
	"LP 2": KEY_K,
	"HP 2": KEY_O,
	"LK and jump 2": KEY_L,
	"HK and block 2": KEY_P,
	"menu 2": KEY_ESCAPE,}
const dictionaryjoys: Dictionary[StringName, JoyButton] = {
	"frame by frame mode 2": JOY_BUTTON_BACK,
	"right 2": JOY_BUTTON_DPAD_RIGHT,
	"left 2": JOY_BUTTON_DPAD_LEFT,
	"up 2": JOY_BUTTON_DPAD_UP,
	"down 2": JOY_BUTTON_DPAD_DOWN,
	"LP 2": JOY_BUTTON_X,
	"HP 2": JOY_BUTTON_Y,
	"LK and jump 2": JOY_BUTTON_A, 
	"HK and block 2": JOY_BUTTON_B,
	"menu 2": JOY_BUTTON_START,}
	## this dictoary was made with ai as i was unsure how to use the right values for the joy axis 
const dictionaryjoyaxis: Dictionary[StringName, Dictionary] = {
	"right 2": {"axis": JOY_AXIS_LEFT_X, "value": 1.0},
	"left 2": {"axis": JOY_AXIS_LEFT_X, "value": -1.0},
	"down 2": {"axis": JOY_AXIS_LEFT_Y, "value": 1.0},
	"up 2": {"axis": JOY_AXIS_LEFT_Y, "value": -1.0},}


func _enable_plugin() -> void:
	set_up(true)
	ProjectSettings.save()
	EditorInterface.restart_editor()


func _disable_plugin() -> void:
	set_up(false)
	ProjectSettings.save()
	EditorInterface.restart_editor()



func set_up(turn_on: bool):
	# clean up of inputs to prevent multiple copys of the same key
	for i in dictionarykeys:
		set_up_helper(i,dictionarykeys[i], true, 0)
	for i in dictionaryjoys:
		set_up_helper(i,dictionaryjoys[i], true, 1)
	for i in dictionaryjoyaxis:
		set_up_helper(i,dictionaryjoyaxis[i], true, 2)
	if turn_on:
		for i in dictionarykeys:
			set_up_helper(i,dictionarykeys[i], false, 0)
		for i in dictionaryjoys:
			set_up_helper(i,dictionaryjoys[i], false, 1)
		for i in dictionaryjoyaxis:
			set_up_helper(i,dictionaryjoyaxis[i], false, 2)
		
func set_up_helper(input_name: StringName, input, remove: bool = false, thing: int = 0):
	input_name = "input/"+input_name # set the input name
	var event
	if thing == 0: 
		event = InputEventKey.new() # the input event / key
		event.physical_keycode = input
	elif thing == 1: 
		event = InputEventJoypadButton.new() # the input event / key
		event.button_index = input 
		event.device = -1
	elif thing == 2: 
		event = InputEventJoypadMotion.new()
		event.axis = input["axis"]
		event.axis_value = input["value"]
		event.device = -1
		
	#append so w can have more then 1 input
	var action = ProjectSettings.get(input_name)
	if action:
		action.events.append(event) # the input events / key
	else:
		action = {
			deadzone = 0.2,
			events = [event]
		}

	if remove:
		ProjectSettings.set(input_name, null)
	else: 
		ProjectSettings.set(input_name, action)
	
	

	
	
