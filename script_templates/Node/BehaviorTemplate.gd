extends BehaviourBase
#seting the reday name
func _ready():
	self.name = "behavior_template"
	super._ready()


#for intant things like a jump
func intant_thing():
	if !enabled: 
		return

	
#for contius funtions like running
func _process(delta):
	if !enabled: 
		return
