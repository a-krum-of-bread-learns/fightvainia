## base class for all addional compents that can be disbaled or enabled at will 
class_name BehaviourBase extends Node 
## this lets us chose if we want this to function at all
@export var enabled: bool
## the [EntityBase] that holds this as a chlid and will need to be refenced  
@export var host: EntityBase

# setting the name and conecting siginals to the enity that will be 
# affected and has the main script
##ready set go (4) ##used to rename the node a bit to hep find it 
func _ready():
	if !name: name= "change name"
	print(name+ " enabled is " + str(enabled)) 
	if !host: push_error("host is not defined for " +name)
