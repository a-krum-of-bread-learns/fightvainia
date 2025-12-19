# TODO make comment this thing way more 
## a class allmost like a resourse to hold the wayy too many export varabils
class_name MoveList extends BehaviourBase
## This enum holds all of the constants for motion inputs and Attacks as sequences or numbers
## For example DL=1 for down left as a number and DQCR=236 as a sequence
# D=DOWN, L=LEFT, R=RIGHT, U=UP, QC=QuarterCircle, 
#K=Kick, P=Punch, L can aslo be light, H = heavy, EX=EXtra or somthing 
enum {DL=1,D=2,DR=3,L=4,NEUTRAL=5,R=6,UL=7,U=8,UR=9,
LK=12,HK=16,EXK=13,LP=14,HP=18,EXP=17,LPK=11,HPK=19,
DQCR=236,DQCL=214,UQCR=896,UQCL=874,LQCD=412,RQCD=632,LQCU=478,RQCU=698,
RDPD=623,LDPD=421,RDPU=689,LDPU=487,
DASHR=5656,DASHL=5454}


## all of these are indivual Attacks as of now ther are nurtal air couch and back Attacks
@export_group("normal Attacks")
enum attack_type {N,C,A,B,AB}
#sort order nemerical  a = air b= back c = crouch
# lpk need to be made
@export_subgroup("lk normal Attacks")
@export var lk: Attack
@export var clk: Attack
@export var alk: Attack
@export var blk: Attack
@export var ablk: Attack
@onready var lk_normals: Dictionary[attack_type, Attack] = {
	attack_type.N: lk,
	attack_type.C: clk, 
	attack_type.A: alk,
	attack_type.B: blk,
	attack_type.AB: ablk
}
#exk need to be made
@export_subgroup("hk normal Attacks")
@export var hk: Attack
@export var chk: Attack
@export var ahk: Attack
@export var bhk: Attack
@export var abhk: Attack
@onready var hk_normals: Dictionary[attack_type,Attack] ={
	attack_type.N: hk,
	attack_type.C: chk,
	attack_type.A: ahk,
	attack_type.B: bhk,
	attack_type.AB: abhk,
}
@export_subgroup("lp normal Attacks")
@export var lp: Attack
@export var alp: Attack
@export var clp: Attack
@export var blp: Attack
@export var ablp: Attack
@onready var lp_normals: Dictionary[attack_type,Attack] ={
	attack_type.N: lp,
	attack_type.C: clp,
	attack_type.A: alp,
	attack_type.B: blp,
	attack_type.AB: ablp,
}

#exp need to be made
@export_subgroup("hp normal Attacks")
@export var hp: Attack
@export var chp: Attack
@export var ahp: Attack
@export var bhp: Attack
@export var abhp: Attack
@onready var hp_normals: Dictionary[attack_type,Attack] ={
	attack_type.N: hp,
	attack_type.C: chp,
	attack_type.A: ahp,
	attack_type.B: bhp,
	attack_type.AB: abhp}
#hpk need to be made

enum attack_pad {ZERO=0,LK=12,HK=16,EXK=13,LP=14,HP=18,EXP=17,LPK=11,HPK=19}
@onready var normals: Dictionary[attack_pad, Dictionary]={
	attack_pad.ZERO: {},
	attack_pad.LK: lk_normals,
	attack_pad.HK: hk_normals,
	attack_pad.LP: lp_normals,
	attack_pad.HP: hp_normals}

@export_group("specal moves")
## these have sequnecs but are the same as the other Attacks
@export_subgroup("forward specal moves") 
@export var dqcflk: Attack
@export var dqcflp: Attack
@export var dqcfhk: Attack
@export var dqcfhp: Attack
@export var fqcdlk: Attack
@export var fqcdlp: Attack
@export var fqcdhk: Attack
@export var fqcdhp: Attack


@export_subgroup("back specal moves")
@export var dqcblk: Attack
@export var dqcblp: Attack
@export var dqcbhk: Attack
@export var dqcbhp: Attack
@export var bqcdlk: Attack
@export var bqcdlp: Attack
@export var bqcdhk: Attack
@export var bqcdhp: Attack


@onready var right_lk_dictionary: Dictionary[int,Attack] = {
	#back
	DQCL:dqcblk,
	LQCD:null,
	UQCL:null,
	LQCU:null,
	#forward
	DQCR:dqcflk,
	RQCD:null,
	UQCR:null,
	RQCU:null,}
@onready var right_lp_dictionary: Dictionary[int,Attack] = {
	#back
	DQCL:dqcblp,
	LQCD:null,
	UQCL:null,
	LQCU:null,
	#forward
	DQCR:dqcflp,
	RQCD:null,
	UQCR:null,
	RQCU:null,}
@onready var right_hk_dictionary: Dictionary[int,Attack] = {
	#back
	DQCL:null,
	LQCD:null,
	UQCL:null,
	LQCU:null,
	#forward
	DQCR:null,
	RQCD:null,
	UQCR:null,
	RQCU:null,}
@onready var right_hp_dictionary: Dictionary[int,Attack] = {
	#back
	DQCL:dqcbhp,
	LQCD:bqcdhp,
	UQCL:null,
	LQCU:null,
	#forward
	DQCR:dqcfhp,
	RQCD:fqcdhp,
	UQCR:null,
	RQCU:null,}

@onready var left_lp_dictionary: Dictionary[int,Attack] = {
	#forward
	DQCL:right_lp_dictionary[DQCR],
	LQCD:right_lp_dictionary[RQCD],
	UQCL:right_lp_dictionary[UQCR],
	LQCU:right_lp_dictionary[RQCU],
	#back
	DQCR:right_lp_dictionary[DQCL],
	RQCD:right_lp_dictionary[LQCD],
	UQCR:right_lp_dictionary[UQCL],
	RQCU:right_lp_dictionary[LQCU],}
@onready var left_lk_dictionary: Dictionary[int,Attack] = {
	#forward
	DQCL:right_lk_dictionary[DQCR],
	LQCD:right_lk_dictionary[RQCD],
	UQCL:right_lk_dictionary[UQCR],
	LQCU:right_lk_dictionary[RQCU],
	#back
	DQCR:right_lk_dictionary[DQCL],
	RQCD:right_lk_dictionary[LQCD],
	UQCR:right_lk_dictionary[UQCL],
	RQCU:right_lk_dictionary[LQCU],}
@onready var left_hk_dictionary: Dictionary[int,Attack] = {
	#forward
	DQCL:right_hk_dictionary[DQCR],
	LQCD:right_hk_dictionary[RQCD],
	UQCL:right_hk_dictionary[UQCR],
	LQCU:right_hk_dictionary[RQCU],
	#back
	DQCR:right_hk_dictionary[DQCL],
	RQCD:right_hk_dictionary[LQCD],
	UQCR:right_hk_dictionary[UQCL],
	RQCU:right_hk_dictionary[LQCU],}
@onready var left_hp_dictionary: Dictionary[int,Attack] = {
	#forward
	DQCL:right_hp_dictionary[DQCR],
	LQCD:right_hp_dictionary[RQCD],
	UQCL:right_hp_dictionary[UQCR],
	LQCU:right_hp_dictionary[RQCU],
	#back
	DQCR:right_hp_dictionary[DQCL],
	RQCD:right_hp_dictionary[LQCD],
	UQCR:right_hp_dictionary[UQCL],
	RQCU:right_hp_dictionary[LQCU],}
@onready var all_special_motions: Dictionary[Array,Dictionary] = {
	[false,LK]: left_lk_dictionary,
	[true,LK]: right_lk_dictionary,
	[false,LP]: left_lp_dictionary,
	[true,LP]: right_lp_dictionary,
	
	[false,HK]: left_hk_dictionary,
	[true,HK]: right_hk_dictionary,
	[false,HP]: left_hp_dictionary,
	[true,HP]: right_hp_dictionary
	}

## ehhh i may need to work on this one 
@onready var Attacks: Array[Attack] = [lp,lk,hp,hk]

# removes all the nulls in the nested Dictionaries for all Dictionaries
func _ready():
	for attack in Attacks:
		if attack == null: Attacks.erase(attack)
	#FIXME rename the keys please
	for keys in normals.keys():
		for key in normals[keys].keys():
			if normals[keys][key] == null:
				normals[keys].erase(key)
				
	for keys in all_special_motions.keys():
		for key in all_special_motions[keys].keys():
			if all_special_motions[keys][key] == null:
				all_special_motions[keys].erase(key)
				
	print(all_special_motions)
	super._ready() # behavior base
