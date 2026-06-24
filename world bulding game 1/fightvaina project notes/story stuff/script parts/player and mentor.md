#worldbulding/script/draft 
note to self italics is thing that happens  strike through is thing said in text box or controls
**causal conversations**
	player: asks how mentor got good with sword and magic
		- mentor: i went to class most of the time and payed attention studded and practiced in my free time. even if it was just a few sword swings i still tried to keep at it every day regardless of how tired i was. but i kept my minimum as low as a single sword swing a day if i was really tired and the most important thing was to keep doing it every day till i die.
		- player: that seems exhausting 
		- mentor: 1 swing a day do it right now its not hard
		- player: *swings sword* 1 time
		- mentor: that's it just keep at it every day till the day you die and you'll be as good as i am with the sword by my age or sooner 
		- player but i want to be strong now isn't there--*cut them off*
		- mentor: every single day till the day you die swing the sword
		- player but i want--*cut them off*
		- mentor: every. single. day.
		- player: okay :( 
		- mentor: and if you miss a day make it up 
		- player: fine :(
		- i did the same with magic too
	player: do i have to learn sword fighting and magic cant i just learn one t
		- mentor here a simple scenario way over there is a magic user and over there is a  sword user who do you thing would win
		- player: player choice
		- mentor here another simple scenario the sword user and magic user are right infront of each other who would win this time
		- player: player choice 
		- mentor in the first scenario the magic user would win in the second the sword user would but if one knew both sword and magic they would be able to fight in both scenarios well
		- but even then there are some examples of masters of one who can still beat the other such as (example char name who uses sword) vs a bunch of skilled magic users who beat them by being strong defensively and approaching when they can 
	mentor: asks did you you do your homework or assignment that's due soon. 
		- player: *player choice yes or no*
		```if (no) 
			then go back home and do your homework i wont teach you until then ~~becuse you have picked this option a 1 hour timer has will only start when you go back home and begin working on home work in game after witch you can close the game and do your home work such as math, english, that project you've been puting off, editing that video that needs to get done soon, that university assiment due by the end of the day some time this week, that hobbie you used to do, etc, etc  becuse if you wont hold yourself acountable i will #the dev (: learing is important and dont cheat or ill see you at the end of the world :) you may now close the tv or monitor#~~
		elif (yes)
		``` mentor: okay then we can get on with our lesson / training ~~go to training dialog~~
	mentor: nice weather we are having? - favorite season
		player:  *player choice i prefer* 
		```if (sunny)
			mentor: the sun is nice and bright good for a walk and to shop is 
		elif (colder)
			mentor: cold weather is decent i prefer it to hot weather 
		elif (snowy)
			mentor: snow is fun for kids i dont like it too much but the ocainal snow man is a good time 
		elif (summer)
			mentor:  i don't like summer weather it gets too hot and some times the crops dry up 
		elif (rainy)
			mentor: the rain can be an annoyance 
		elif (hot)
			mentor: hot weather is not fun it sucks and theres no good way to cool down exept ice magic that i dont know yet```
		 - mentor: append to end: but my favorite is nice and mild weather not too hot not too cold no rain and good shade is the best i can ask for witch is why i like Fall a lot along with the variety of colors spring is good too but summer comes too fast
		 - play: my favorite season is (player choice)
		 - mentor: you may have your own opinion  just don't force it on other people 
	
**training the player with defense first (use the strike, throw, reversal/trap/shimmy triangle)**
mentor is causally speaking for most of this maybe messing around playfully 
	- mentor: one of the most important thing about staying alive in battle is being able to defend your self so im going to come at you and you have to block my attacks if you get hit its gonna hurt ~~so block by pressing the button~~
	- player: *after an small onslaught gets hit by low and falls (they technically could counter but do they actually know that?)* ow that hurt that's not fair i didn't know you were going to go ==low== and hit my legs 
	```if (they block the low )
		mentor congrats them 
	else```
	- mentor: i told you it would hurt but that is why you're here to learn every one gets hit at first but in real combat you might have lost your legs rather than just a small fall.
	- player: you could have warned me 
	- mentor: alright alright this time block low when i come at you ~~so block by pressing the button and down~~
	- player: *after an small onslaught gets hit by overhead (they technically could counter but do they actually know that?)*  hey you said you'd go low why'd you go ==overhead== that hurt now im gonna have a bump on my head
	```if (they block the overhead) 
		- mentor congrats them
	else```
	- mentor: ha ha you'll be fine but now you know my tricks so you better be ready to block ==low and overhead== but it will be random so you better react or predict it we are going to do this a few time so be ready to be hit *again: ~~if they didn't block it all already~~* ~~so block by pressing the button and/or down~~
	```if (fails blocking too much)
		mentor: get back try again you'll get the hang of it you're just practicing+spoken variation
	elif (blocks with 80 % on the low or high using last 5 sets)```
	- mentor: good job you seem comfortable blocking now so now i want you to look for an opening to strike back at me with a quick attack ~~by using a light attack button~~
	- player: *the player must hit the mentor with a counter attack using a light attack*
	```if (fails counter attack)
		mentor: again +spoken variation
	elif (succeeds counter attack few times)```
	**throw**
	- mentor: congrats now i'm going to mix it up a bit by ==throwing== you. you'll have to react or predict to stop me from ==throwing== you ~~by pressing the buttons or grab macro~~. ill make sure it doesn't hurt too much 
	- player: *needs to do a throw tech a few times*
	```if (fails techs to much )
		- mentor: again +spoken variation
	elif (they tech a few times in a row )```
	- mentor: *congrats them* that is all the defensive stuff i want you to learn for now you look like your getting tired why don't you head home for now  take break or something
	- player: finally its over 
	- mentor: ill see you tomorrow
	- player: noo ok ill see you tomorrow *heads home* 
	~~- go to some other dialog list stuff~~ 
	- player:  *returns for another day* hey teach where are you 
**special moves filler**
	- mentor: welcome back ready for another lesson 
	```if (no)
		go to causal dialog
	elif (yes)```
	- mentor: great today i want you to practice some different moves to get the form right we will start with some good slash motions lets start with a downwards slash at this target ~~by doing a fqcd + button~~ *provides example with inputs shown*
	- player: *must do it with good form 7 times in a row*
	- mentor: next we will do an upwards slash ~~by doing a dqcf + button~~ *provides example with inputs shown*
	- player: *must do it with good form 7 times in a row* 
	- mentor good but on the battle field you may need to fend off more than one person so turn around do the same as me ~~combo trial fqcd + button dqcb + button ~~
	- player: *must do it 10 times well*
	- mentor: your form needs work but that comes with practice witch we will do a lot of  next sometimes you want to knock someone down  to apply more pressure on them before they can get up so use this technique that requires a little bit of magic to help with the force of the attack *does a swing forwards up and jumps* now you try ~~by pressing fqcu + button~~ it also works well if some one is coming at you from above you head because magic users do some tricky stuff. ill throw something up on the air at and you have to hit it out of the air from in front or behind you witch ever you can 
	- player: this seems like it might be fun *must do it 7 times in a row and hit the target*
	- player: how did you make fire that so cool could you teach me how to do that 
	- mentor: have you not learned in school yet  they should have taught you by now 
	- player: i didn't pay the most attention only a bit so i can feel it 
	- mentor that bit should be enough for magic control internally witch will allow you to jump high 
	
**light combo**
	mentor: for this time i want you to practice a short combo that gives you some pressure on your opponent after its done it looks like this *does combo* ~~light button  -> light button -> light button (could do 3 asks for 2) -> fqcu +button~~ you can also try to hit them low to open them up but i wont expect that of you yet ~~optional challenge light low light the special~~
**heavy combo**
	mentor: alight now that you have the basics we can try a combo what you need to do is a heavy attack into the up swing then the jump swing like this *shows example* ~~heavy button -> fqcd + button -> dqcb + button ->  (side switch) bqcu + button~~ 
	- player: that's a lot of steps 
	- mentor: its okay once your used to it will become second nature and you wont even remember it being hard so do it 15 times




**special moves situational/ key ablity**
	- mentor: ok ok this is the simplest combat spell i can teach you but its important that you don't try to burn every thing down around you ill teach you how to throw a fire bal--
	- player: yay this is the best day ever
	- mentor: so first i'm going to help you get a feel for it *approaches player and helps from the side* i'm going to cast the spell through you i want to remember the feeling and the motions i make you do okay
	- player: okay ill try 
	- mentor: this is not the only way to learn a magic spell but it is the easily to teach as it can be felt rather then trying to recreate a feeling the feeling form a book 
	- 
	