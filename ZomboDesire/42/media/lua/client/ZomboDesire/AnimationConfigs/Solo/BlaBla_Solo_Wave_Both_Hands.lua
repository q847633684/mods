require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("BlaBla_Solo_Wave_Both_Hands", {
	animName = "BlaBla_Solo_Wave_Both_Hands",
	tags = {"Desire", "Solo"},
	actors = {
		{
			gender = "Female",
			stages = {
				{
					perform = "BlaBla_Solo_Wave_Both_Hands",
					duration = 200
				}
			}
		},
		{
			gender = "Male",
			stages = {
				{
					perform = "BlaBla_Solo_Wave_Both_Hands",
					duration = 200
				}
			}
		}
	}
})
