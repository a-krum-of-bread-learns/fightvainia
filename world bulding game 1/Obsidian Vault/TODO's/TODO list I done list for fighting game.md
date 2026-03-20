#TODO
- [x] jump
- [x] double jump
- [x] 3 primary hurt boxes
- [x] flip player (uses scale)
- [x] the attack manager for putting things together
- [x] input manager basics 
- [x] sequence reader
- [x] make motion inputs stuff optimized
- [x] add check for motion plus attack
- [x] bug fixes 1
- [x] make a forwards 
- [x] pre-jump frames technically
- [x] make turn around stuff better 5 frames min
- [x] make attacks not spam able 
- [x] add null check for the input manager statement
- [x] raise mic volume
- [x] finish frame timer
- [x] make players not stand on each other but still collide
- [x] make health kinda
- [x] make attacks deal damage 
- [x] add knock back 
- [x] make a good forwards '
- [x] make stun and forwards do the math
- [x] write a bit of documentation 1
- [x] move start stun from health compent to the hitbox compnent
- [x] projectiles
- [x] top level in visibility to work with projectile
- [x] blocking left right with projectile jank
- [x] block high low stuff
- [x] fix dash to be fixed distance 
- [x] remove triple jump
- [x] add dash cancelable jump
- [x] jump cancelable dash
- [x] jump handler2
- [x] fix dash handler
- [x] cancel able attacks
- [x] target combos
- [x] dash
- [x] forward movement while attacking animation player?
- [x] hit stop 
- [x] screen shake
- [x] add difference for air stun and ground stun
- [x] move child is a function can be used for rename function
- [x] used tweens for animation
- [x] make animation interuptable by geting hit
- [x] make animation not intraptabe by input during attack exept when attack is canacalbe at that time
- [x] use tweens in stun manager 
- [x] fix error given when tween not used for air stun
- [x] need to make a contiune stun working with tweens
- [x]  fix hurt boxes for ground air and crouch may want a new component
- [x] change basic stun to custom based on attack data extra
- [x] make a system map to see how it all fits right now when i return to it
- [x] make a repeating frame class that extends frame just added a property 
- [x] re making the chose action function to be clearer
- [x] fix the problem with is_attacking in 2 places at the same time (attack manager and entity base) 
 - [x] decide these 2 where they should be jump_velocityY:, move_speed, 
 - [x] add a add projectie under frames
- [ ] save system
- [ ] healing could just be a negative hit box damage?  this needs an exception to self exception
- [ ] consideration motion attacks? like motion inputs for directions rhythm character or something

- [ ] decide these 2 where they should be fast_move_speed, gravity
- [ ] combine player and input manager?
- [ ] run?
- [ ] stop some stuff from processing that don't need it when running
- [ ] give the hurt able player text over head saying is stunned 
- [ ] a bit of combo ui
- [ ] do i want air blocking ?

- [ ] fix collisions so i can push another player using if im being detected then i will be pushing
	the layer pushes the mask witch means i need 2 player layers needs a work a round to have both the players push each other 
- [ ] try an attack with the animation player need to watch vids or dont and skip this
- [ ] make grabs and command grabs (related to above) or dont and skip this 


- [ ] make simple boolens for modifiers of hurt and hit boxes? skip this scopecreep


can use array inside of a dictionary  for buttion + sequence + direction
- [ ] make a character now ?
- [ ] add input release option
- [ ] for combo attacks add option to start from not frame 0 or 1 witch ever it is 

are all normal cancel-able ?

- [ ] make the last script for the current list of scripts 
- [ ] make animation node or thing work from stun manager may be or from scratch 

- [x] sepratet x and y compnets of animations
- [ ] add a loop functionality 
- [ ] do a documentation check 
- [ ] do a charater journy map for values when doing things like doing damage via function names to see the information paths 
- [x] add the licnece i want for the game 
- [x] make gitub public
- [ ] consider the health and other similar components that are nodes as resources instead
- [ ] make a scope limit 
- [ ] make a danger zone section 
- [ ] learn conditional editor tools or separate projectile animation and entity animation
- [ ] 
- [ ] make a demo (limits: 1 char 1-3 basic enemy 1 boss that is the same char and a bit of ability to unlock and put it on itch if you use boxes then do it see [[Demo scope ToDo for summer test release of a char|demo scope]] 