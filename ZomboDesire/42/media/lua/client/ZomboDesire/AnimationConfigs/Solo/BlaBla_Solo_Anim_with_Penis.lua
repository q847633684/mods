require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("BlaBla_Solo_Anim_with_Penis", {
	animName = "BlaBla_Solo_Anim_with_Penis",
	tags = {"Desire", "Solo"},
	actors = {
		{
			gender = "Female",
			stages = {
				{
					perform = "BlaBla_Solo_Anim_with_Penis",
					duration = 500
				}
			}
		},
		{
			gender = "Male",
			stages = {
				{
					perform = "BlaBla_Solo_Anim_with_Penis",
					duration = 500
				}
			}
		}
	}
})
