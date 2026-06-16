## MoveList.gd
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
## U = up
## D = down
## L = left (when used as a direction)
## L = light (when used for attack button)
## R = right
## H = heavy
## P = punch
## K = kick
## QC = quarter circle
## f = forward
## DP = dragon punch
## EX = extra/EX move
## 
class_name MoveList extends Node2D

# -------------------------
# Input and button constants
# -------------------------
# Directions as single-element arrays (Array[int])
const DL: Array[int] = [1]
const D: Array[int] = [2]
const DR: Array[int] = [3]
const L: Array[int] = [4]
const NEUTRAL: Array[int] = [5]
const R: Array[int] = [6]
const UL: Array[int] = [7]
const U: Array[int] = [8]
const UR: Array[int] = [9]

# Attack buttons kept as two-digit-ish numeric values in the 11..19 range, but stored as arrays
# (user requested keeping them as 2 digits then being 12 to 19; original had LPK=11 so we keep 11 for LPK)
const LPK: Array[int] = [11]
const LK: Array[int] = [12]
const EXK: Array[int] = [13]
const LP: Array[int] = [14]
const EXP: Array[int] = [17]
const HP: Array[int] = [18]
const HPK: Array[int] = [19]
const HK: Array[int] = [16]

# Motion sequences as arrays of digits (quarter circles, dp, dash)
const DQCR: Array[int] = [2,3,6]
const DQCL: Array[int] = [2,1,4]
const UQCR: Array[int] = [8,9,6]
const UQCL: Array[int] = [8,7,4]
const LQCD: Array[int] = [4,1,2]
const RQCD: Array[int] = [6,3,2]
const LQCU: Array[int] = [4,7,8]
const RQCU: Array[int] = [6,9,8]

const RDPD: Array[int] = [6,2,3]
const LDPD: Array[int] = [4,2,1]
const RDPU: Array[int] = [6,8,9]
const LDPU: Array[int] = [4,8,7]

const DASHR: Array[int] = [5,6,5,6]
const DASHL: Array[int] = [5,4,5,4]

# -------------------------
# AttackKey resource
# -------------------------
# AttackKey is used as the dictionary key instead of raw arrays.
# It packages: is_on_ground (bool), is_facing_right (bool), motion (Array[int]), button (Array[int]).
# Using a Resource makes keys easier to manage, compare, and serialize in Godot.
class AttackKey extends  Resource:
	var is_on_floor: bool
	var is_facing_right: bool
	var sequence: Array[int]
	var attack_button: Array[int]
	func _init(_on_floor: bool, right: bool, sequnce: Array[int], attack_b: Array[int]) -> void:
		is_on_floor = _on_floor
		is_facing_right = right
		sequence = sequnce
		attack_button = attack_b

# -------------------------
# all of these are individual Attacks (exported)
# -------------------------
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

# Dictionaries now keyed by AttackKey resources
@onready var grounded_light_kick_normals: Dictionary = {
	AttackKey.new(true, true, NEUTRAL, LK): light_kick,
	AttackKey.new(true, true, DL, LK): down_left_light_kick,
	AttackKey.new(true, true, D, LK): down_light_kick,
	AttackKey.new(true, true, DR, LK): down_right_light_kick,
	AttackKey.new(true, true, L, LK): back_light_kick,
	AttackKey.new(true, true, R, LK): forward_light_kick,
	AttackKey.new(true, true, UL, LK): up_left_light_kick,
	AttackKey.new(true, true, U, LK): up_light_kick,
	AttackKey.new(true, true, UR, LK): up_right_light_kick,

	AttackKey.new(true, false, NEUTRAL, LK): light_kick,
	AttackKey.new(true, false, DR, LK): down_left_light_kick,
	AttackKey.new(true, false, D, LK): down_light_kick,
	AttackKey.new(true, false, DL, LK): down_right_light_kick,
	AttackKey.new(true, false, R, LK): back_light_kick,
	AttackKey.new(true, false, L, LK): forward_light_kick,
	AttackKey.new(true, false, UR, LK): up_left_light_kick,
	AttackKey.new(true, false, U, LK): up_light_kick,
	AttackKey.new(true, false, UL, LK): up_right_light_kick}

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

@onready var air_light_kick_normals: Dictionary = {
	AttackKey.new(false, true, NEUTRAL, LK): air_light_kick,
	AttackKey.new(false, true, DL, LK): air_down_left_kick,
	AttackKey.new(false, true, D, LK): air_down_kick,
	AttackKey.new(false, true, DR, LK): air_down_right_kick,
	AttackKey.new(false, true, L, LK): air_back_kick,
	AttackKey.new(false, true, R, LK): air_forward_kick,
	AttackKey.new(false, true, UL, LK): air_up_left_kick,
	AttackKey.new(false, true, U, LK): air_up_kick,
	AttackKey.new(false, true, UR, LK): air_up_right_kick,

	AttackKey.new(false, false, NEUTRAL, LK): air_light_kick,
	AttackKey.new(false, false, DR, LK): air_down_left_kick,
	AttackKey.new(false, false, D, LK): air_down_kick,
	AttackKey.new(false, false, DL, LK): air_down_right_kick,
	AttackKey.new(false, false, R, LK): air_back_kick,
	AttackKey.new(false, false, L, LK): air_forward_kick,
	AttackKey.new(false, false, UR, LK): air_up_left_kick,
	AttackKey.new(false, false, U, LK): air_up_kick,
	AttackKey.new(false, false, UL, LK): air_up_right_kick}

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

@onready var grounded_light_punch_normals: Dictionary = {
	AttackKey.new(true, true, NEUTRAL, LP): light_punch,
	AttackKey.new(true, true, DL, LP): down_left_light_punch,
	AttackKey.new(true, true, D, LP): down_light_punch,
	AttackKey.new(true, true, DR, LP): down_right_light_punch,
	AttackKey.new(true, true, L, LP): back_light_punch,
	AttackKey.new(true, true, R, LP): forward_light_punch,
	AttackKey.new(true, true, UL, LP): up_left_light_punch,
	AttackKey.new(true, true, U, LP): up_light_punch,
	AttackKey.new(true, true, UR, LP): up_right_light_punch,

	AttackKey.new(true, false, NEUTRAL, LP): light_punch,
	AttackKey.new(true, false, DR, LP): down_left_light_punch,
	AttackKey.new(true, false, D, LP): down_light_punch,
	AttackKey.new(true, false, DL, LP): down_right_light_punch,
	AttackKey.new(true, false, R, LP): back_light_punch,
	AttackKey.new(true, false, L, LP): forward_light_punch,
	AttackKey.new(true, false, UR, LP): up_left_light_punch,
	AttackKey.new(true, false, U, LP): up_light_punch,
	AttackKey.new(true, false, UL, LP): up_right_light_punch}

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

@onready var air_light_punch_normals: Dictionary = {
	AttackKey.new(false, true, NEUTRAL, LP): air_light_punch,
	AttackKey.new(false, true, DL, LP): air_down_left_punch,
	AttackKey.new(false, true, D, LP): air_down_punch,
	AttackKey.new(false, true, DR, LP): air_down_right_punch,
	AttackKey.new(false, true, L, LP): air_back_punch,
	AttackKey.new(false, true, R, LP): air_forward_punch,
	AttackKey.new(false, true, UL, LP): air_up_left_punch,
	AttackKey.new(false, true, U, LP): air_up_punch,
	AttackKey.new(false, true, UR, LP): air_up_right_punch,

	AttackKey.new(false, false, NEUTRAL, LP): air_light_punch,
	AttackKey.new(false, false, DR, LP): air_down_left_punch,
	AttackKey.new(false, false, D, LP): air_down_punch,
	AttackKey.new(false, false, DL, LP): air_down_right_punch,
	AttackKey.new(false, false, R, LP): air_back_punch,
	AttackKey.new(false, false, L, LP): air_forward_punch,
	AttackKey.new(false, false, UR, LP): air_up_left_punch,
	AttackKey.new(false, false, U, LP): air_up_punch,
	AttackKey.new(false, false, UL, LP): air_up_right_punch}

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

@onready var grounded_heavy_kick_normals: Dictionary = {
	AttackKey.new(true, true, NEUTRAL, HK): heavy_kick,
	AttackKey.new(true, true, DL, HK): down_left_heavy_kick,
	AttackKey.new(true, true, D, HK): down_heavy_kick,
	AttackKey.new(true, true, DR, HK): down_right_heavy_kick,
	AttackKey.new(true, true, L, HK): back_heavy_kick,
	AttackKey.new(true, true, R, HK): forward_heavy_kick,
	AttackKey.new(true, true, UL, HK): up_left_heavy_kick,
	AttackKey.new(true, true, U, HK): up_heavy_kick,
	AttackKey.new(true, true, UR, HK): up_right_heavy_kick,

	AttackKey.new(true, false, NEUTRAL, HK): heavy_kick,
	AttackKey.new(true, false, DR, HK): down_left_heavy_kick,
	AttackKey.new(true, false, D, HK): down_heavy_kick,
	AttackKey.new(true, false, DL, HK): down_right_heavy_kick,
	AttackKey.new(true, false, R, HK): back_heavy_kick,
	AttackKey.new(true, false, L, HK): forward_heavy_kick,
	AttackKey.new(true, false, UR, HK): up_left_heavy_kick,
	AttackKey.new(true, false, U, HK): up_heavy_kick,
	AttackKey.new(true, false, UL, HK): up_right_heavy_kick}

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

@onready var air_heavy_kick_normals: Dictionary = {
	AttackKey.new(false, true, NEUTRAL, HK): air_heavy_kick,
	AttackKey.new(false, true, DL, HK): air_down_left_heavy_kick,
	AttackKey.new(false, true, D, HK): air_down_heavy_kick,
	AttackKey.new(false, true, DR, HK): air_down_right_heavy_kick,
	AttackKey.new(false, true, L, HK): air_back_heavy_kick,
	AttackKey.new(false, true, R, HK): air_forward_heavy_kick,
	AttackKey.new(false, true, UL, HK): air_up_left_heavy_kick,
	AttackKey.new(false, true, U, HK): air_up_heavy_kick,
	AttackKey.new(false, true, UR, HK): air_up_right_heavy_kick,

	AttackKey.new(false, false, NEUTRAL, HK): air_heavy_kick,
	AttackKey.new(false, false, DR, HK): air_down_left_heavy_kick,
	AttackKey.new(false, false, D, HK): air_down_heavy_kick,
	AttackKey.new(false, false, DL, HK): air_down_right_heavy_kick,
	AttackKey.new(false, false, R, HK): air_back_heavy_kick,
	AttackKey.new(false, false, L, HK): air_forward_heavy_kick,
	AttackKey.new(false, false, UR, HK): air_up_left_heavy_kick,
	AttackKey.new(false, false, U, HK): air_up_heavy_kick,
	AttackKey.new(false, false, UL, HK): air_up_right_heavy_kick}

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

@onready var grounded_heavy_punch_normals: Dictionary = {
	AttackKey.new(true, true, NEUTRAL, HP): heavy_punch,
	AttackKey.new(true, true, DL, HP): down_left_heavy_punch,
	AttackKey.new(true, true, D, HP): down_heavy_punch,
	AttackKey.new(true, true, DR, HP): down_right_heavy_punch,
	AttackKey.new(true, true, L, HP): back_heavy_punch,
	AttackKey.new(true, true, R, HP): forward_heavy_punch,
	AttackKey.new(true, true, UL, HP): up_left_heavy_punch,
	AttackKey.new(true, true, U, HP): up_heavy_punch,
	AttackKey.new(true, true, UR, HP): up_right_heavy_punch,

	AttackKey.new(true, false, NEUTRAL, HP): heavy_punch,
	AttackKey.new(true, false, DR, HP): down_left_heavy_punch,
	AttackKey.new(true, false, D, HP): down_heavy_punch,
	AttackKey.new(true, false, DL, HP): down_right_heavy_punch,
	AttackKey.new(true, false, R, HP): back_heavy_punch,
	AttackKey.new(true, false, L, HP): forward_heavy_punch,
	AttackKey.new(true, false, UR, HP): up_left_heavy_punch,
	AttackKey.new(true, false, U, HP): up_heavy_punch,
	AttackKey.new(true, false, UL, HP): up_right_heavy_punch}

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

@onready var air_heavy_punch_normals: Dictionary = {
	AttackKey.new(false, true, NEUTRAL, HP): air_heavy_punch,
	AttackKey.new(false, true, DL, HP): air_down_left_heavy_punch,
	AttackKey.new(false, true, D, HP): air_down_heavy_punch,
	AttackKey.new(false, true, DR, HP): air_down_right_heavy_punch,
	AttackKey.new(false, true, L, HP): air_back_heavy_punch,
	AttackKey.new(false, true, R, HP): air_forward_heavy_punch,
	AttackKey.new(false, true, UL, HP): air_up_left_heavy_punch,
	AttackKey.new(false, true, U, HP): air_up_heavy_punch,
	AttackKey.new(false, true, UR, HP): air_up_right_heavy_punch,

	AttackKey.new(false, false, NEUTRAL, HP): air_heavy_punch,
	AttackKey.new(false, false, DR, HP): air_down_left_heavy_punch,
	AttackKey.new(false, false, D, HP): air_down_heavy_punch,
	AttackKey.new(false, false, DL, HP): air_down_right_heavy_punch,
	AttackKey.new(false, false, R, HP): air_back_heavy_punch,
	AttackKey.new(false, false, L, HP): air_forward_heavy_punch,
	AttackKey.new(false, false, UR, HP): air_up_left_heavy_punch,
	AttackKey.new(false, false, U, HP): air_up_heavy_punch,
	AttackKey.new(false, false, UL, HP): air_up_right_heavy_punch}

# -------------------------
# grounded special moves
# -------------------------
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

@onready var grounded_light_kick_specials: Dictionary = {
	AttackKey.new(true, true, DQCR, LK): dqcf_light_kick,
	AttackKey.new(true, true, RQCD, LK): fqcd_light_kick,
	AttackKey.new(true, true, UQCR, LK): uqcf_light_kick,
	AttackKey.new(true, true, RQCU, LK): fqcu_light_kick,
	AttackKey.new(true, true, DQCL, LK): dqcb_light_kick,
	AttackKey.new(true, true, LQCD, LK): bqcd_light_kick,
	AttackKey.new(true, true, UQCL, LK): uqcb_light_kick,
	AttackKey.new(true, true, LQCU, LK): bqcu_light_kick,

	AttackKey.new(true, false, DQCL, LK): dqcf_light_kick,
	AttackKey.new(true, false, LQCD, LK): fqcd_light_kick,
	AttackKey.new(true, false, UQCL, LK): uqcf_light_kick,
	AttackKey.new(true, false, LQCU, LK): fqcu_light_kick,
	AttackKey.new(true, false, DQCR, LK): dqcb_light_kick,
	AttackKey.new(true, false, RQCD, LK): bqcd_light_kick,
	AttackKey.new(true, false, UQCR, LK): uqcb_light_kick,
	AttackKey.new(true, false, RQCU, LK): bqcu_light_kick}

@onready var grounded_light_punch_specials: Dictionary = {
	AttackKey.new(true, true, DQCR, LP): dqcf_light_punch,
	AttackKey.new(true, true, RQCD, LP): fqcd_light_punch,
	AttackKey.new(true, true, UQCR, LP): uqcf_light_punch,
	AttackKey.new(true, true, RQCU, LP): fqcu_light_punch,
	AttackKey.new(true, true, DQCL, LP): dqcb_light_punch,
	AttackKey.new(true, true, LQCD, LP): bqcd_light_punch,
	AttackKey.new(true, true, UQCL, LP): uqcb_light_punch,
	AttackKey.new(true, true, LQCU, LP): bqcu_light_punch,

	AttackKey.new(true, false, DQCL, LP): dqcf_light_punch,
	AttackKey.new(true, false, LQCD, LP): fqcd_light_punch,
	AttackKey.new(true, false, UQCL, LP): uqcf_light_punch,
	AttackKey.new(true, false, LQCU, LP): fqcu_light_punch,
	AttackKey.new(true, false, DQCR, LP): dqcb_light_punch,
	AttackKey.new(true, false, RQCD, LP): bqcd_light_punch,
	AttackKey.new(true, false, UQCR, LP): uqcb_light_punch,
	AttackKey.new(true, false, RQCU, LP): bqcu_light_punch}

@onready var grounded_heavy_kick_specials: Dictionary = {
	AttackKey.new(true, true, DQCR, HK): dqcf_heavy_kick,
	AttackKey.new(true, true, RQCD, HK): fqcd_heavy_kick,
	AttackKey.new(true, true, UQCR, HK): uqcf_heavy_kick,
	AttackKey.new(true, true, RQCU, HK): fqcu_heavy_kick,
	AttackKey.new(true, true, DQCL, HK): dqcb_heavy_kick,
	AttackKey.new(true, true, LQCD, HK): bqcd_heavy_kick,
	AttackKey.new(true, true, UQCL, HK): uqcb_heavy_kick,
	AttackKey.new(true, true, LQCU, HK): bqcu_heavy_kick,

	AttackKey.new(true, false, DQCL, HK): dqcf_heavy_kick,
	AttackKey.new(true, false, LQCD, HK): fqcd_heavy_kick,
	AttackKey.new(true, false, UQCL, HK): uqcf_heavy_kick,
	AttackKey.new(true, false, LQCU, HK): fqcu_heavy_kick,
	AttackKey.new(true, false, DQCR, HK): dqcb_heavy_kick,
	AttackKey.new(true, false, RQCD, HK): bqcd_heavy_kick,
	AttackKey.new(true, false, UQCR, HK): uqcb_heavy_kick,
	AttackKey.new(true, false, RQCU, HK): bqcu_heavy_kick}

@onready var grounded_heavy_punch_specials: Dictionary = {
	AttackKey.new(true, true, DQCR, HP): dqcf_heavy_punch,
	AttackKey.new(true, true, RQCD, HP): fqcd_heavy_punch,
	AttackKey.new(true, true, UQCR, HP): uqcf_heavy_punch,
	AttackKey.new(true, true, RQCU, HP): fqcu_heavy_punch,
	AttackKey.new(true, true, DQCL, HP): dqcb_heavy_punch,
	AttackKey.new(true, true, LQCD, HP): bqcd_heavy_punch,
	AttackKey.new(true, true, UQCL, HP): uqcb_heavy_punch,
	AttackKey.new(true, true, LQCU, HP): bqcu_heavy_punch,

	AttackKey.new(true, false, DQCL, HP): dqcf_heavy_punch,
	AttackKey.new(true, false, LQCD, HP): fqcd_heavy_punch,
	AttackKey.new(true, false, UQCL, HP): uqcf_heavy_punch,
	AttackKey.new(true, false, LQCU, HP): fqcu_heavy_punch,
	AttackKey.new(true, false, DQCR, HP): dqcb_heavy_punch,
	AttackKey.new(true, false, RQCD, HP): bqcd_heavy_punch,
	AttackKey.new(true, false, UQCR, HP): uqcb_heavy_punch,
	AttackKey.new(true, false, RQCU, HP): bqcu_heavy_punch}

# -------------------------
# air special moves
# -------------------------
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

@onready var air_light_kick_specials: Dictionary = {
	AttackKey.new(false, true, DQCR, LK): air_dqcf_light_kick,
	AttackKey.new(false, true, RQCD, LK): air_fqcd_light_kick,
	AttackKey.new(false, true, UQCR, LK): air_uqcf_light_kick,
	AttackKey.new(false, true, RQCU, LK): air_fqcu_light_kick,
	AttackKey.new(false, true, DQCL, LK): air_dqcb_light_kick,
	AttackKey.new(false, true, LQCD, LK): air_bqcd_light_kick,
	AttackKey.new(false, true, UQCL, LK): air_uqcb_light_kick,
	AttackKey.new(false, true, LQCU, LK): air_bqcu_light_kick,

	AttackKey.new(false, false, DQCL, LK): air_dqcf_light_kick,
	AttackKey.new(false, false, LQCD, LK): air_fqcd_light_kick,
	AttackKey.new(false, false, UQCL, LK): air_uqcf_light_kick,
	AttackKey.new(false, false, LQCU, LK): air_fqcu_light_kick,
	AttackKey.new(false, false, DQCR, LK): air_dqcb_light_kick,
	AttackKey.new(false, false, RQCD, LK): air_bqcd_light_kick,
	AttackKey.new(false, false, UQCR, LK): air_uqcb_light_kick,
	AttackKey.new(false, false, RQCU, LK): air_bqcu_light_kick}

@onready var air_light_punch_specials: Dictionary = {
	AttackKey.new(false, true, DQCR, LP): air_dqcf_light_punch,
	AttackKey.new(false, true, RQCD, LP): air_fqcd_light_punch,
	AttackKey.new(false, true, UQCR, LP): air_uqcf_light_punch,
	AttackKey.new(false, true, RQCU, LP): air_fqcu_light_punch,
	AttackKey.new(false, true, DQCL, LP): air_dqcb_light_punch,
	AttackKey.new(false, true, LQCD, LP): air_bqcd_light_punch,
	AttackKey.new(false, true, UQCL, LP): air_uqcb_light_punch,
	AttackKey.new(false, true, LQCU, LP): air_bqcu_light_punch,

	AttackKey.new(false, false, DQCL, LP): air_dqcf_light_punch,
	AttackKey.new(false, false, LQCD, LP): air_fqcd_light_punch,
	AttackKey.new(false, false, UQCL, LP): air_uqcf_light_punch,
	AttackKey.new(false, false, LQCU, LP): air_fqcu_light_punch,
	AttackKey.new(false, false, DQCR, LP): air_dqcb_light_punch,
	AttackKey.new(false, false, RQCD, LP): air_bqcd_light_punch,
	AttackKey.new(false, false, UQCR, LP): air_uqcb_light_punch,
	AttackKey.new(false, false, RQCU, LP): air_bqcu_light_punch}

@onready var air_heavy_kick_specials: Dictionary = {
	AttackKey.new(false, true, DQCR, HK): air_dqcf_heavy_kick,
	AttackKey.new(false, true, RQCD, HK): air_fqcd_heavy_kick,
	AttackKey.new(false, true, UQCR, HK): air_uqcf_heavy_kick,
	AttackKey.new(false, true, RQCU, HK): air_fqcu_heavy_kick,
	AttackKey.new(false, true, DQCL, HK): air_dqcb_heavy_kick,
	AttackKey.new(false, true, LQCD, HK): air_bqcd_heavy_kick,
	AttackKey.new(false, true, UQCL, HK): air_uqcb_heavy_kick,
	AttackKey.new(false, true, LQCU, HK): air_bqcu_heavy_kick,

	AttackKey.new(false, false, DQCL, HK): air_dqcf_heavy_kick,
	AttackKey.new(false, false, LQCD, HK): air_fqcd_heavy_kick,
	AttackKey.new(false, false, UQCL, HK): air_uqcf_heavy_kick,
	AttackKey.new(false, false, LQCU, HK): air_fqcu_heavy_kick,
	AttackKey.new(false, false, DQCR, HK): air_dqcb_heavy_kick,
	AttackKey.new(false, false, RQCD, HK): air_bqcd_heavy_kick,
	AttackKey.new(false, false, UQCR, HK): air_uqcb_heavy_kick,
	AttackKey.new(false, false, RQCU, HK): air_bqcu_heavy_kick}

@onready var air_heavy_punch_specials: Dictionary = {
	AttackKey.new(false, true, DQCR, HP): air_dqcf_heavy_punch,
	AttackKey.new(false, true, RQCD, HP): air_fqcd_heavy_punch,
	AttackKey.new(false, true, UQCR, HP): air_uqcf_heavy_punch,
	AttackKey.new(false, true, RQCU, HP): air_fqcu_heavy_punch,
	AttackKey.new(false, true, DQCL, HP): air_dqcb_heavy_punch,
	AttackKey.new(false, true, LQCD, HP): air_bqcd_heavy_punch,
	AttackKey.new(false, true, UQCL, HP): air_uqcb_heavy_punch,
	AttackKey.new(false, true, LQCU, HP): air_bqcu_heavy_punch,

	AttackKey.new(false, false, DQCL, HP): air_dqcf_heavy_punch,
	AttackKey.new(false, false, LQCD, HP): air_fqcd_heavy_punch,
	AttackKey.new(false, false, UQCL, HP): air_uqcf_heavy_punch,
	AttackKey.new(false, false, LQCU, HP): air_fqcu_heavy_punch,
	AttackKey.new(false, false, DQCR, HP): air_dqcb_heavy_punch,
	AttackKey.new(false, false, RQCD, HP): air_bqcd_heavy_punch,
	AttackKey.new(false, false, UQCR, HP): air_uqcb_heavy_punch,
	AttackKey.new(false, false, RQCU, HP): air_bqcu_heavy_punch}

# -------------------------
# Organized dictionaries for priority checking
# -------------------------
@onready var all_specials: Dictionary[AttackKey, Attack] = {}
@onready var command_normals: Dictionary[AttackKey, Attack] = {}
@onready var neutral_normals: Dictionary[AttackKey, Attack] = {}
@onready var all_attacks: Dictionary[AttackKey, Attack] = {}

# removes all the nulls and filters attacks into priority categories
func _ready():
	var normals_temp: Dictionary[AttackKey, Attack] = {}
	
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
	for key: AttackKey in normals_temp.keys():
		if normals_temp[key] == null:
			continue # Skip null entries
		
		# key.motion is the motion array; compare to NEUTRAL constant
		if key.sequence == NEUTRAL:
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
