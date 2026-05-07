#add_docs
has tool scripts for adding the[collision shapes] and fixing color
contains the [[HitBoxData resource]] from inheritance [[ActiveHitbox]]


 [[damage system| damage]] can be dealt witch grabs the 
 has reference to the [[AttackManager]]

grabs the [[EntityBase|entity's]] [[HurtBox]] it collides with then checks hit exceptions 


#add_docs
#refactor 
does [[block check function]] is here checks high/low and side of the hit that also decide the knock back

check left right based on postions

[[Projectile]] is extened form this class