child of [[MoveList]]

manages the player inputs to pick the attack based on 4 vars 

is on floor 
is facing right 
the motion input 
the button pressed within the buffered array

has functions 
flip_x_logic
get_attack_button
movemnt manager 
jump handelers
dash handelers



[sequence spliter] could be removed if the sequnces are turned into arrays instead but i may not change it beucse intergers prolby take less space but if i wanted to make sequences with thte attack buttions i could do it in a difent game 

has many array/ dictionary  management functions 
[[chose_action function]]


works with [[dash]],[[movement]], [[gravity]], [[scale]]

as of now has player moment options as well

beccause this manages inputs it also selcts the attack via [[AttackManager]]
