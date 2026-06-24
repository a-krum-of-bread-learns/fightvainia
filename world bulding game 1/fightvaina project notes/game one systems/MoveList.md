Organizes all attacks into nested dictionaries for easy access and management.
All attacks are separately defined as variables and then categorized into folders in the editor.
Attacks are organized into three dictionaries: normals, all_specials, and all_attacks.
If air is not specified, the attack is a grounded attack.

Dictionary types and key format:
- normals: Dictionary[Array, Attack]
- all_specials: Dictionary[Array, Attack]
- all_attacks: Dictionary[Array, Attack]
Arrray / Key format: [is_on_ground: bool, is_facing_right: bool, motion: int, button: int]

Variable naming legend (only change variable names):
a = air
b = back
u = up
d = down
l = left (when used as a direction)
l = light (when used for attack button)
r = right
h = heavy
p = punch
k = kick
qc = quarter circle
f = forward
dp = dragon punch
ex = extra/EX move

This enum holds all constants for motion inputs and attacks as sequences or numbers.
For example: DL=1 for down-left as a number, DQCR=236 as a sequence.