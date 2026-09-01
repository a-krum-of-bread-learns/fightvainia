class_name MenuControllerRootScript extends CanvasLayer
@export var disable: bool
@export var start_menu: MenuBase
@export var pause_menu: MenuBase
@export var settings_menu: MenuBase
@export var cutscecne_pause_menu: MenuBase
@export var dialogue_menu: DialogueMenu
@export var generic_confermation_dialogue: MenuBase# ????????
@export var menu_background: Control
var menu_path: Array[MenuBase] = []
enum GameState {START_GAME, GAME_PLAY, CUTSCENE}
var curret_game_state: GameState
func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	start_menu.hide()
	pause_menu.hide()
	settings_menu.hide()
	cutscecne_pause_menu.hide()
	dialogue_menu.hide()
	if disable: return
	layer = 20
	curret_game_state = GameState.START_GAME
	open_menu()
	
	

func open_menu(menu: MenuBase = null):
	if menu_path.is_empty() and menu == null:
		menu = get_root_menu_based_on_game_state()
	elif menu_path.is_empty():
		pass
	else: menu_path[-1].hide()
	menu_path.append(menu)
	menu.show()
	menu.defult_focus.grab_focus()


func close_all_but_1_menu():
	while menu_path.size() > 1:
		back_1_menu()
## cloes the most recent menu opened and focue son the previous
func back_1_menu():
	if menu_path.is_empty():
		return
	menu_path[-1].hide()
	menu_path.remove_at(-1)
	if menu_path:
		menu_path[-1].show()
		menu_path[-1].defult_focus.grab_focus()
	else: pass # menus have all been closed
	

func get_root_menu_based_on_game_state() -> MenuBase:
	match curret_game_state:
		GameState.START_GAME:
			return start_menu
		GameState.CUTSCENE:
			return cutscecne_pause_menu
		GameState.GAME_PLAY:
			return pause_menu
		_: 
			push_error("game state tracking broke")
			return null


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("HK and block") and menu_path: 
		if menu_path[-1] is not DialogueMenu:
			back_1_menu()
			if menu_path.is_empty():
				get_tree().paused = false
	if menu_path.is_empty() and Input.is_action_just_pressed("menu"):
		open_menu(pause_menu)
		get_tree().paused = true
	elif Input.is_action_just_pressed("menu"):
		close_all_but_1_menu()
	if menu_path.is_empty():
		menu_background.hide()
	elif menu_path[-1] is not DialogueMenu:
		menu_background.show()
	
	#print(menu_path)
