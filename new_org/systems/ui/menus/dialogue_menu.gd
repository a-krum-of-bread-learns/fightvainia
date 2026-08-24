class_name DialogueMenu extends MenuBase

@export var dialogue_text_box: RichTextLabel
var text: Array[String]
signal progess_next
signal dialogue_end
##this is called by cutsecens  to set teh text 1 time
func start_dialogue(new_text: Array[String]):
	text = new_text
	for chat_count in text.size():
		dialogue_text_box.text = text[chat_count]
		await progess_next
	dialogue_end.emit()
	request_back()
	
func _input(event):
	if event.is_action_pressed("LK and jump"):
		progess_next.emit()
	
