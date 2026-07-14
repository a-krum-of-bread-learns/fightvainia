extends Area2D
#TODO disable a few otehr improtn nodes for the player
#TODO make an auto load scene witch seems to be posible cool
#TODO make into 2 parts
@export var textbox: RichTextLabel
var text_is_writing : bool
var text: Array[String] =[
	"set of text 1 this fjfuiodsfniudnasfkndiuasbfyudba",
	"set of text 2 vkiomfdvjofdvdfnvdnsuicn",
	"set of text 3 asytvdatydvashbctasvcibysdvbtzuicybdsbyc"
	]
signal progess_next

func _ready() -> void:
	body_entered.connect(start_cutscene)
	collision_mask = 2 # detect player body make sure body is corectly set

func _input(event):
	if event.is_action_pressed("LK and jump"):
		progess_next.emit()

##starts cutscene is expexting enity base with colison layer 2 meaning a player
func start_cutscene(body: Node2D):
	if body is EntityBase:
		body.cutsecene_start()
		for chat_count in text.size():
			textbox.text = text[chat_count]
			await progess_next
		end_cutscene(body)
		
func end_cutscene(body: EntityBase):
	# end cutcene 
	body.cutsecene_end()
	textbox.text = ""
		
		
		
		
		
