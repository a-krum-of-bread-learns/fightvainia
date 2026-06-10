class_name FighingGameSettings
## this class is unimplented but i think a good idea for a open source project
# GameSettings autoload
## makes all stuns that launch into air always foorce a type of knockdown
@export var is_must_recover_on_ground_enabled: bool = true
@export var is_hitstopv: bool = true
## self explatory 
@export var is_chip_damage_enabled: bool = false
##unimpmetned in any way
@export var defualt_chip_multiplyer: float
##nomals into noramls exluing previous normals
@export var is_rapid_beat_enabled: bool = true  # you already have this concept
##speical into speicals up to
@export var is_speical_cancelable_special_moves_by_defult_enabled: bool = false

@export var speical_into_special_limit: int = 1
