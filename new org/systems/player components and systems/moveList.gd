## MoveList
## doesnt contain all attacks becuse of how combo attacks are coded
## Organizes all attacks into nested dictionaries for easy access and management.
## All attacks are separately defined as variables and then categorized into folders in the editor.
## Attacks are organized into dictionaries by priority: all_specials, command_normals, neutral_normals, all_attacks.
## If air is not specified, the attack is a grounded attack.
## 
## Dictionary types and key format:
## - all_specials: Dictionary[Array, Attack] - Motion inputs (sequences like 236)
## - command_normals: Dictionary[Array, Attack] - Direction + button (no NEUTRAL motion)
## - neutral_normals: Dictionary[Array, Attack] - NEUTRAL + button only
## - all_attacks: Dictionary[Array, Attack] - Contains all attacks merged
## Key format: [is_on_ground: bool, is_facing_right: bool, motion: int, button: int]
## 
## Variable naming legend (only change variable names):
## a = air
## b = back
## u = up
## d = down
## l = left (when used as a direction)
## l = light (when used for attack button)
## r = right
## h = heavy
## p = punch
## k = kick
## qc = quarter circle
## f = forward
## dp = dragon punch
## ex = extra/EX move
## 
## This enum holds all constants for motion inputs and attacks as sequences or numbers.
## For example: DL=1 for down-left as a number, DQCR=236 as a sequence.
class_name MoveList extends Node2D
enum {DL=1,D=2,DR=3,L=4,NEUTRAL=5,R=6,UL=7,U=8,UR=9, # input directions
LK=12,HK=16,EXK=13,LP=14,HP=18,EXP=17,LPK=11,HPK=19, #attack buttons
DQCR=236,DQCL=214,UQCR=896,UQCL=874,LQCD=412,RQCD=632,LQCU=478,RQCU=698, #quarter circle motions
RDPD=623,LDPD=421,RDPU=689,LDPU=487, #dragon punch motions
DASHR=5656,DASHL=5454} 

## all of these are individual Attacks
@export_group("normal Attacks")

@export_subgroup("grounded light kick normal Attacks")
@export var light_kick: Attack
@export var down_left_light_kick: Attack
@export var down_light_kick: Attack
@export var down_right_light_kick: Attack
@export var back_light_kick: Attack
@export var forward_light_kick: Attack
@export var up_left_light_kick: Attack
@export var up_light_kick: Attack
@export var up_right_light_kick: Attack
@onready var grounded_light_kick_normals: Dictionary[Array, Attack] = {
	#grounded right 
	[true,true,NEUTRAL,LK]: light_kick,
	[true,true,DL,LK]: down_left_light_kick,
	[true,true,D,LK]: down_light_kick,
	[true,true,DR,LK]: down_right_light_kick,
	[true,true,L,LK]: back_light_kick,
	[true,true,R,LK]: forward_light_kick,
	[true,true,UL,LK]: up_left_light_kick,
	[true,true,U,LK]: up_light_kick,
	[true,true,UR,LK]: up_right_light_kick,
	#grounded left 
	[true,false,NEUTRAL,LK]: light_kick,
	[true,false,DR,LK]: down_left_light_kick,
	[true,false,D,LK]: down_light_kick,
	[true,false,DL,LK]: down_right_light_kick,
	[true,false,R,LK]: back_light_kick,
	[true,false,L,LK]: forward_light_kick,
	[true,false,UR,LK]: up_left_light_kick,
	[true,false,U,LK]: up_light_kick,
	[true,false,UL,LK]: up_right_light_kick}

@export_subgroup("air light kick normal Attacks")
@export var air_light_kick: Attack
@export var air_down_left_kick: Attack
@export var air_down_kick: Attack
@export var air_down_right_kick: Attack
@export var air_back_kick: Attack
@export var air_forward_kick: Attack
@export var air_up_left_kick: Attack
@export var air_up_kick: Attack
@export var air_up_right_kick: Attack
@onready var air_light_kick_normals: Dictionary[Array, Attack] = {
	#air right
	[false,true,NEUTRAL,LK]: air_light_kick,
	[false,true,DL,LK]: air_down_left_kick,
	[false,true,D,LK]: air_down_kick,
	[false,true,DR,LK]: air_down_right_kick,
	[false,true,L,LK]: air_back_kick,
	[false,true,R,LK]: air_forward_kick,
	[false,true,UL,LK]: air_up_left_kick,
	[false,true,U,LK]: air_up_kick,
	[false,true,UR,LK]: air_up_right_kick,
	#air left
	[false,false,NEUTRAL,LK]: air_light_kick,
	[false,false,DR,LK]: air_down_left_kick,
	[false,false,D,LK]: air_down_kick,
	[false,false,DL,LK]: air_down_right_kick,
	[false,false,R,LK]: air_back_kick,
	[false,false,L,LK]: air_forward_kick,
	[false,false,UR,LK]: air_up_left_kick,
	[false,false,U,LK]: air_up_kick,
	[false,false,UL,LK]: air_up_right_kick}

@export_subgroup("grounded light punch normal Attacks")
@export var light_punch: Attack
@export var down_left_light_punch: Attack
@export var down_light_punch: Attack
@export var down_right_light_punch: Attack
@export var back_light_punch: Attack
@export var forward_light_punch: Attack
@export var up_left_light_punch: Attack
@export var up_light_punch: Attack
@export var up_right_light_punch: Attack
@onready var grounded_light_punch_normals: Dictionary[Array, Attack] = {
	#grounded right 
	[true,true,NEUTRAL,LP]: light_punch,
	[true,true,DL,LP]: down_left_light_punch,
	[true,true,D,LP]: down_light_punch,
	[true,true,DR,LP]: down_right_light_punch,
	[true,true,L,LP]: back_light_punch,
	[true,true,R,LP]: forward_light_punch,
	[true,true,UL,LP]: up_left_light_punch,
	[true,true,U,LP]: up_light_punch,
	[true,true,UR,LP]: up_right_light_punch,
	#grounded left 
	[true,false,NEUTRAL,LP]: light_punch,
	[true,false,DR,LP]: down_left_light_punch,
	[true,false,D,LP]: down_light_punch,
	[true,false,DL,LP]: down_right_light_punch,
	[true,false,R,LP]: back_light_punch,
	[true,false,L,LP]: forward_light_punch,
	[true,false,UR,LP]: up_left_light_punch,
	[true,false,U,LP]: up_light_punch,
	[true,false,UL,LP]: up_right_light_punch}

@export_subgroup("air light punch normal Attacks")
@export var air_light_punch: Attack
@export var air_down_left_punch: Attack
@export var air_down_punch: Attack
@export var air_down_right_punch: Attack
@export var air_back_punch: Attack
@export var air_forward_punch: Attack
@export var air_up_left_punch: Attack
@export var air_up_punch: Attack
@export var air_up_right_punch: Attack
@onready var air_light_punch_normals: Dictionary[Array, Attack] = {
	#air right
	[false,true,NEUTRAL,LP]: air_light_punch,
	[false,true,DL,LP]: air_down_left_punch,
	[false,true,D,LP]: air_down_punch,
	[false,true,DR,LP]: air_down_right_punch,
	[false,true,L,LP]: air_back_punch,
	[false,true,R,LP]: air_forward_punch,
	[false,true,UL,LP]: air_up_left_punch,
	[false,true,U,LP]: air_up_punch,
	[false,true,UR,LP]: air_up_right_punch,
	#air left
	[false,false,NEUTRAL,LP]: air_light_punch,
	[false,false,DR,LP]: air_down_left_punch,
	[false,false,D,LP]: air_down_punch,
	[false,false,DL,LP]: air_down_right_punch,
	[false,false,R,LP]: air_back_punch,
	[false,false,L,LP]: air_forward_punch,
	[false,false,UR,LP]: air_up_left_punch,
	[false,false,U,LP]: air_up_punch,
	[false,false,UL,LP]: air_up_right_punch}

@export_subgroup("grounded heavy kick normal Attacks")
@export var heavy_kick: Attack
@export var down_left_heavy_kick: Attack
@export var down_heavy_kick: Attack
@export var down_right_heavy_kick: Attack
@export var back_heavy_kick: Attack
@export var forward_heavy_kick: Attack
@export var up_left_heavy_kick: Attack
@export var up_heavy_kick: Attack
@export var up_right_heavy_kick: Attack
@onready var grounded_heavy_kick_normals: Dictionary[Array, Attack] = {
	#grounded right 
	[true,true,NEUTRAL,HK]: heavy_kick,
	[true,true,DL,HK]: down_left_heavy_kick,
	[true,true,D,HK]: down_heavy_kick,
	[true,true,DR,HK]: down_right_heavy_kick,
	[true,true,L,HK]: back_heavy_kick,
	[true,true,R,HK]: forward_heavy_kick,
	[true,true,UL,HK]: up_left_heavy_kick,
	[true,true,U,HK]: up_heavy_kick,
	[true,true,UR,HK]: up_right_heavy_kick,
	#grounded left 
	[true,false,NEUTRAL,HK]: heavy_kick,
	[true,false,DR,HK]: down_left_heavy_kick,
	[true,false,D,HK]: down_heavy_kick,
	[true,false,DL,HK]: down_right_heavy_kick,
	[true,false,R,HK]: back_heavy_kick,
	[true,false,L,HK]: forward_heavy_kick,
	[true,false,UR,HK]: up_left_heavy_kick,
	[true,false,U,HK]: up_heavy_kick,
	[true,false,UL,HK]: up_right_heavy_kick}

@export_subgroup("air heavy kick normal Attacks")
@export var air_heavy_kick: Attack
@export var air_down_left_heavy_kick: Attack
@export var air_down_heavy_kick: Attack
@export var air_down_right_heavy_kick: Attack
@export var air_back_heavy_kick: Attack
@export var air_forward_heavy_kick: Attack
@export var air_up_left_heavy_kick: Attack
@export var air_up_heavy_kick: Attack
@export var air_up_right_heavy_kick: Attack
@onready var air_heavy_kick_normals: Dictionary[Array, Attack] = {
	#air right
	[false,true,NEUTRAL,HK]: air_heavy_kick,
	[false,true,DL,HK]: air_down_left_heavy_kick,
	[false,true,D,HK]: air_down_heavy_kick,
	[false,true,DR,HK]: air_down_right_heavy_kick,
	[false,true,L,HK]: air_back_heavy_kick,
	[false,true,R,HK]: air_forward_heavy_kick,
	[false,true,UL,HK]: air_up_left_heavy_kick,
	[false,true,U,HK]: air_up_heavy_kick,
	[false,true,UR,HK]: air_up_right_heavy_kick,
	#air left
	[false,false,NEUTRAL,HK]: air_heavy_kick,
	[false,false,DR,HK]: air_down_left_heavy_kick,
	[false,false,D,HK]: air_down_heavy_kick,
	[false,false,DL,HK]: air_down_right_heavy_kick,
	[false,false,R,HK]: air_back_heavy_kick,
	[false,false,L,HK]: air_forward_heavy_kick,
	[false,false,UR,HK]: air_up_left_heavy_kick,
	[false,false,U,HK]: air_up_heavy_kick,
	[false,false,UL,HK]: air_up_right_heavy_kick}

@export_subgroup("grounded heavy punch normal Attacks")
@export var heavy_punch: Attack
@export var down_left_heavy_punch: Attack
@export var down_heavy_punch: Attack
@export var down_right_heavy_punch: Attack
@export var back_heavy_punch: Attack
@export var forward_heavy_punch: Attack
@export var up_left_heavy_punch: Attack
@export var up_heavy_punch: Attack
@export var up_right_heavy_punch: Attack
@onready var grounded_heavy_punch_normals: Dictionary[Array, Attack] = {
	#grounded right 
	[true,true,NEUTRAL,HP]: heavy_punch,
	[true,true,DL,HP]: down_left_heavy_punch,
	[true,true,D,HP]: down_heavy_punch,
	[true,true,DR,HP]: down_right_heavy_punch,
	[true,true,L,HP]: back_heavy_punch,
	[true,true,R,HP]: forward_heavy_punch,
	[true,true,UL,HP]: up_left_heavy_punch,
	[true,true,U,HP]: up_heavy_punch,
	[true,true,UR,HP]: up_right_heavy_punch,
	#grounded left 
	[true,false,NEUTRAL,HP]: heavy_punch,
	[true,false,DR,HP]: down_left_heavy_punch,
	[true,false,D,HP]: down_heavy_punch,
	[true,false,DL,HP]: down_right_heavy_punch,
	[true,false,R,HP]: back_heavy_punch,
	[true,false,L,HP]: forward_heavy_punch,
	[true,false,UR,HP]: up_left_heavy_punch,
	[true,false,U,HP]: up_heavy_punch,
	[true,false,UL,HP]: up_right_heavy_punch}

@export_subgroup("air heavy punch normal Attacks")
@export var air_heavy_punch: Attack
@export var air_down_left_heavy_punch: Attack
@export var air_down_heavy_punch: Attack
@export var air_down_right_heavy_punch: Attack
@export var air_back_heavy_punch: Attack
@export var air_forward_heavy_punch: Attack
@export var air_up_left_heavy_punch: Attack
@export var air_up_heavy_punch: Attack
@export var air_up_right_heavy_punch: Attack
@onready var air_heavy_punch_normals: Dictionary[Array, Attack] = {
	#air right
	[false,true,NEUTRAL,HP]: air_heavy_punch,
	[false,true,DL,HP]: air_down_left_heavy_punch,
	[false,true,D,HP]: air_down_heavy_punch,
	[false,true,DR,HP]: air_down_right_heavy_punch,
	[false,true,L,HP]: air_back_heavy_punch,
	[false,true,R,HP]: air_forward_heavy_punch,
	[false,true,UL,HP]: air_up_left_heavy_punch,
	[false,true,U,HP]: air_up_heavy_punch,
	[false,true,UR,HP]: air_up_right_heavy_punch,
	#air left
	[false,false,NEUTRAL,HP]: air_heavy_punch,
	[false,false,DR,HP]: air_down_left_heavy_punch,
	[false,false,D,HP]: air_down_heavy_punch,
	[false,false,DL,HP]: air_down_right_heavy_punch,
	[false,false,R,HP]: air_back_heavy_punch,
	[false,false,L,HP]: air_forward_heavy_punch,
	[false,false,UR,HP]: air_up_left_heavy_punch,
	[false,false,U,HP]: air_up_heavy_punch,
	[false,false,UL,HP]: air_up_right_heavy_punch}

@export_group("grounded special moves")
@export_subgroup("quarter circle special moves")
@export_subgroup("quarter circle special moves/down->forward")
@export var dqcf_light_kick: Attack
@export var dqcf_light_punch: Attack
@export var dqcf_heavy_kick: Attack
@export var dqcf_heavy_punch: Attack
@export_subgroup("quarter circle special moves/forward->down")
@export var fqcd_light_kick: Attack
@export var fqcd_light_punch: Attack
@export var fqcd_heavy_kick: Attack
@export var fqcd_heavy_punch: Attack
@export_subgroup("quarter circle special moves/up->forward")
@export var uqcf_light_kick: Attack
@export var uqcf_light_punch: Attack
@export var uqcf_heavy_kick: Attack
@export var uqcf_heavy_punch: Attack
@export_subgroup("quarter circle special moves/forward->up")
@export var fqcu_light_kick: Attack
@export var fqcu_light_punch: Attack
@export var fqcu_heavy_kick: Attack
@export var fqcu_heavy_punch: Attack
@export_subgroup("quarter circle special moves/down->back")
@export var dqcb_light_kick: Attack
@export var dqcb_light_punch: Attack
@export var dqcb_heavy_kick: Attack
@export var dqcb_heavy_punch: Attack
@export_subgroup("quarter circle special moves/back->down")
@export var bqcd_light_kick: Attack
@export var bqcd_light_punch: Attack
@export var bqcd_heavy_kick: Attack
@export var bqcd_heavy_punch: Attack
@export_subgroup("quarter circle special moves/up->back")
@export var uqcb_light_kick: Attack
@export var uqcb_light_punch: Attack
@export var uqcb_heavy_kick: Attack
@export var uqcb_heavy_punch: Attack
@export_subgroup("quarter circle special moves/back->up")
@export var bqcu_light_kick: Attack
@export var bqcu_light_punch: Attack
@export var bqcu_heavy_kick: Attack
@export var bqcu_heavy_punch: Attack

@onready var grounded_light_kick_specials: Dictionary[Array,Attack] = {
	#ground right quarter circle
	[true,true,DQCR,LK]: dqcf_light_kick,
	[true,true,RQCD,LK]: fqcd_light_kick,
	[true,true,UQCR,LK]: uqcf_light_kick,
	[true,true,RQCU,LK]: fqcu_light_kick,
	[true,true,DQCL,LK]: dqcb_light_kick,
	[true,true,LQCD,LK]: bqcd_light_kick,
	[true,true,UQCL,LK]: uqcb_light_kick,
	[true,true,LQCU,LK]: bqcu_light_kick,
	#ground left quarter circle
	[true,false,DQCL,LK]: dqcf_light_kick,
	[true,false,LQCD,LK]: fqcd_light_kick,
	[true,false,UQCL,LK]: uqcf_light_kick,
	[true,false,LQCU,LK]: fqcu_light_kick,
	[true,false,DQCR,LK]: dqcb_light_kick,
	[true,false,RQCD,LK]: bqcd_light_kick,
	[true,false,UQCR,LK]: uqcb_light_kick,
	[true,false,RQCU,LK]: bqcu_light_kick}

@onready var grounded_light_punch_specials: Dictionary[Array,Attack] = {
	#ground right quarter circle
	[true,true,DQCR,LP]: dqcf_light_punch,
	[true,true,RQCD,LP]: fqcd_light_punch,
	[true,true,UQCR,LP]: uqcf_light_punch,
	[true,true,RQCU,LP]: fqcu_light_punch,
	[true,true,DQCL,LP]: dqcb_light_punch,
	[true,true,LQCD,LP]: bqcd_light_punch,
	[true,true,UQCL,LP]: uqcb_light_punch,
	[true,true,LQCU,LP]: bqcu_light_punch,
	#ground left quarter circle
	[true,false,DQCL,LP]: dqcf_light_punch,
	[true,false,LQCD,LP]: fqcd_light_punch,
	[true,false,UQCL,LP]: uqcf_light_punch,
	[true,false,LQCU,LP]: fqcu_light_punch,
	[true,false,DQCR,LP]: dqcb_light_punch,
	[true,false,RQCD,LP]: bqcd_light_punch,
	[true,false,UQCR,LP]: uqcb_light_punch,
	[true,false,RQCU,LP]: bqcu_light_punch}

@onready var grounded_heavy_kick_specials: Dictionary[Array,Attack] = {
	#ground right quarter circle
	[true,true,DQCR,HK]: dqcf_heavy_kick,
	[true,true,RQCD,HK]: fqcd_heavy_kick,
	[true,true,UQCR,HK]: uqcf_heavy_kick,
	[true,true,RQCU,HK]: fqcu_heavy_kick,
	[true,true,DQCL,HK]: dqcb_heavy_kick,
	[true,true,LQCD,HK]: bqcd_heavy_kick,
	[true,true,UQCL,HK]: uqcb_heavy_kick,
	[true,true,LQCU,HK]: bqcu_heavy_kick,
	#ground left quarter circle
	[true,false,DQCL,HK]: dqcf_heavy_kick,
	[true,false,LQCD,HK]: fqcd_heavy_kick,
	[true,false,UQCL,HK]: uqcf_heavy_kick,
	[true,false,LQCU,HK]: fqcu_heavy_kick,
	[true,false,DQCR,HK]: dqcb_heavy_kick,
	[true,false,RQCD,HK]: bqcd_heavy_kick,
	[true,false,UQCR,HK]: uqcb_heavy_kick,
	[true,false,RQCU,HK]: bqcu_heavy_kick}

@onready var grounded_heavy_punch_specials: Dictionary[Array,Attack] = {
	#ground right quarter circle
	[true,true,DQCR,HP]: dqcf_heavy_punch,
	[true,true,RQCD,HP]: fqcd_heavy_punch,
	[true,true,UQCR,HP]: uqcf_heavy_punch,
	[true,true,RQCU,HP]: fqcu_heavy_punch,
	[true,true,DQCL,HP]: dqcb_heavy_punch,
	[true,true,LQCD,HP]: bqcd_heavy_punch,
	[true,true,UQCL,HP]: uqcb_heavy_punch,
	[true,true,LQCU,HP]: bqcu_heavy_punch,
	#ground left quarter circle
	[true,false,DQCL,HP]: dqcf_heavy_punch,
	[true,false,LQCD,HP]: fqcd_heavy_punch,
	[true,false,UQCL,HP]: uqcf_heavy_punch,
	[true,false,LQCU,HP]: fqcu_heavy_punch,
	[true,false,DQCR,HP]: dqcb_heavy_punch,
	[true,false,RQCD,HP]: bqcd_heavy_punch,
	[true,false,UQCR,HP]: uqcb_heavy_punch,
	[true,false,RQCU,HP]: bqcu_heavy_punch}

@export_group("air special moves")
@export_subgroup("air quarter circle special moves")
@export_subgroup("air quarter circle special moves/down->forward")
@export var air_dqcf_light_kick: Attack
@export var air_dqcf_light_punch: Attack
@export var air_dqcf_heavy_kick: Attack
@export var air_dqcf_heavy_punch: Attack
@export_subgroup("air quarter circle special moves/forward->down")
@export var air_fqcd_light_kick: Attack
@export var air_fqcd_light_punch: Attack
@export var air_fqcd_heavy_kick: Attack
@export var air_fqcd_heavy_punch: Attack
@export_subgroup("air quarter circle special moves/up->forward")
@export var air_uqcf_light_kick: Attack
@export var air_uqcf_light_punch: Attack
@export var air_uqcf_heavy_kick: Attack
@export var air_uqcf_heavy_punch: Attack
@export_subgroup("air quarter circle special moves/forward->up")
@export var air_fqcu_light_kick: Attack
@export var air_fqcu_light_punch: Attack
@export var air_fqcu_heavy_kick: Attack
@export var air_fqcu_heavy_punch: Attack
@export_subgroup("air quarter circle special moves/down->back")
@export var air_dqcb_light_kick: Attack
@export var air_dqcb_light_punch: Attack
@export var air_dqcb_heavy_kick: Attack
@export var air_dqcb_heavy_punch: Attack
@export_subgroup("air quarter circle special moves/back->down")
@export var air_bqcd_light_kick: Attack
@export var air_bqcd_light_punch: Attack
@export var air_bqcd_heavy_kick: Attack
@export var air_bqcd_heavy_punch: Attack
@export_subgroup("air quarter circle special moves/up->back")
@export var air_uqcb_light_kick: Attack
@export var air_uqcb_light_punch: Attack
@export var air_uqcb_heavy_kick: Attack
@export var air_uqcb_heavy_punch: Attack
@export_subgroup("air quarter circle special moves/back->up")
@export var air_bqcu_light_kick: Attack
@export var air_bqcu_light_punch: Attack
@export var air_bqcu_heavy_kick: Attack
@export var air_bqcu_heavy_punch: Attack

@onready var air_light_kick_specials: Dictionary[Array,Attack] = {
	#air right quarter circle
	[false,true,DQCR,LK]: air_dqcf_light_kick,
	[false,true,RQCD,LK]: air_fqcd_light_kick,
	[false,true,UQCR,LK]: air_uqcf_light_kick,
	[false,true,RQCU,LK]: air_fqcu_light_kick,
	[false,true,DQCL,LK]: air_dqcb_light_kick,
	[false,true,LQCD,LK]: air_bqcd_light_kick,
	[false,true,UQCL,LK]: air_uqcb_light_kick,
	[false,true,LQCU,LK]: air_bqcu_light_kick,
	#air left quarter circle
	[false,false,DQCL,LK]: air_dqcf_light_kick,
	[false,false,LQCD,LK]: air_fqcd_light_kick,
	[false,false,UQCL,LK]: air_uqcf_light_kick,
	[false,false,LQCU,LK]: air_fqcu_light_kick,
	[false,false,DQCR,LK]: air_dqcb_light_kick,
	[false,false,RQCD,LK]: air_bqcd_light_kick,
	[false,false,UQCR,LK]: air_uqcb_light_kick,
	[false,false,RQCU,LK]: air_bqcu_light_kick}

@onready var air_light_punch_specials: Dictionary[Array,Attack] = {
	#air right quarter circle
	[false,true,DQCR,LP]: air_dqcf_light_punch,
	[false,true,RQCD,LP]: air_fqcd_light_punch,
	[false,true,UQCR,LP]: air_uqcf_light_punch,
	[false,true,RQCU,LP]: air_fqcu_light_punch,
	[false,true,DQCL,LP]: air_dqcb_light_punch,
	[false,true,LQCD,LP]: air_bqcd_light_punch,
	[false,true,UQCL,LP]: air_uqcb_light_punch,
	[false,true,LQCU,LP]: air_bqcu_light_punch,
	#air left quarter circle
	[false,false,DQCL,LP]: air_dqcf_light_punch,
	[false,false,LQCD,LP]: air_fqcd_light_punch,
	[false,false,UQCL,LP]: air_uqcf_light_punch,
	[false,false,LQCU,LP]: air_fqcu_light_punch,
	[false,false,DQCR,LP]: air_dqcb_light_punch,
	[false,false,RQCD,LP]: air_bqcd_light_punch,
	[false,false,UQCR,LP]: air_uqcb_light_punch,
	[false,false,RQCU,LP]: air_bqcu_light_punch}

@onready var air_heavy_kick_specials: Dictionary[Array,Attack] = {
	#air right quarter circle
	[false,true,DQCR,HK]: air_dqcf_heavy_kick,
	[false,true,RQCD,HK]: air_fqcd_heavy_kick,
	[false,true,UQCR,HK]: air_uqcf_heavy_kick,
	[false,true,RQCU,HK]: air_fqcu_heavy_kick,
	[false,true,DQCL,HK]: air_dqcb_heavy_kick,
	[false,true,LQCD,HK]: air_bqcd_heavy_kick,
	[false,true,UQCL,HK]: air_uqcb_heavy_kick,
	[false,true,LQCU,HK]: air_bqcu_heavy_kick,
	#air left quarter circle
	[false,false,DQCL,HK]: air_dqcf_heavy_kick,
	[false,false,LQCD,HK]: air_fqcd_heavy_kick,
	[false,false,UQCL,HK]: air_uqcf_heavy_kick,
	[false,false,LQCU,HK]: air_fqcu_heavy_kick,
	[false,false,DQCR,HK]: air_dqcb_heavy_kick,
	[false,false,RQCD,HK]: air_bqcd_heavy_kick,
	[false,false,UQCR,HK]: air_uqcb_heavy_kick,
	[false,false,RQCU,HK]: air_bqcu_heavy_kick}

@onready var air_heavy_punch_specials: Dictionary[Array,Attack] = {
	#air right quarter circle
	[false,true,DQCR,HP]: air_dqcf_heavy_punch,
	[false,true,RQCD,HP]: air_fqcd_heavy_punch,
	[false,true,UQCR,HP]: air_uqcf_heavy_punch,
	[false,true,RQCU,HP]: air_fqcu_heavy_punch,
	[false,true,DQCL,HP]: air_dqcb_heavy_punch,
	[false,true,LQCD,HP]: air_bqcd_heavy_punch,
	[false,true,UQCL,HP]: air_uqcb_heavy_punch,
	[false,true,LQCU,HP]: air_bqcu_heavy_punch,
	#air left quarter circle
	[false,false,DQCL,HP]: air_dqcf_heavy_punch,
	[false,false,LQCD,HP]: air_fqcd_heavy_punch,
	[false,false,UQCL,HP]: air_uqcf_heavy_punch,
	[false,false,LQCU,HP]: air_fqcu_heavy_punch,
	[false,false,DQCR,HP]: air_dqcb_heavy_punch,
	[false,false,RQCD,HP]: air_bqcd_heavy_punch,
	[false,false,UQCR,HP]: air_uqcb_heavy_punch,
	[false,false,RQCU,HP]: air_bqcu_heavy_punch}

# Organized dictionaries for priority checking
@onready var all_specials: Dictionary[Array, Attack] = {}
@onready var command_normals: Dictionary[Array, Attack] = {}
@onready var neutral_normals: Dictionary[Array, Attack] = {}
@onready var all_attacks: Dictionary[Array, Attack] = {}

# removes all the nulls and filters attacks into priority categories
func _ready():
	var normals_temp: Dictionary[Array, Attack] = {}
	
	# Merge all normals into temp dictionary
	normals_temp.merge(grounded_light_kick_normals)
	normals_temp.merge(air_light_kick_normals)
	normals_temp.merge(grounded_light_punch_normals)
	normals_temp.merge(air_light_punch_normals)
	normals_temp.merge(grounded_heavy_kick_normals)
	normals_temp.merge(air_heavy_kick_normals)
	normals_temp.merge(grounded_heavy_punch_normals)
	normals_temp.merge(air_heavy_punch_normals)
	
	# Merge all specials
	all_specials.merge(grounded_light_kick_specials)
	all_specials.merge(air_light_kick_specials)
	all_specials.merge(grounded_light_punch_specials)
	all_specials.merge(air_light_punch_specials)
	all_specials.merge(grounded_heavy_kick_specials)
	all_specials.merge(air_heavy_kick_specials)
	all_specials.merge(grounded_heavy_punch_specials)
	all_specials.merge(air_heavy_punch_specials)
	
	# Filter normals into command_normals and neutral_normals
	for key in normals_temp.keys():
		if normals_temp[key] == null:
			continue # Skip null entries
		
		# key[2] is the motion value
		if key[2] == NEUTRAL:
			neutral_normals[key] = normals_temp[key]
		else:
			command_normals[key] = normals_temp[key]
	
	# Remove nulls from specials
	for key in all_specials.keys():
		if all_specials[key] == null:
			all_specials.erase(key)
	
	# Merge everything into all_attacks (for compatibility/debugging)
	all_attacks.merge(all_specials)
	all_attacks.merge(command_normals)
	all_attacks.merge(neutral_normals)
	
	print("Specials: ", all_specials.size())
	print("Command Normals: ", command_normals.size())
	print("Neutral Normals: ", neutral_normals.size())
	print("Total Attacks: ", all_attacks.size())

#class AttackKey extends  Resource:
	#var is_on_floor: bool
	#var is_facing_right: bool
	#var sequence: int
	#var attack_button: int
	#func _init(_on_floor: bool, right: bool, sequnce: int, attack_b: int) -> void:
		#is_on_floor = _on_floor
		#is_facing_right = right
		#sequence = sequnce
		#attack_button = attack_b
		
