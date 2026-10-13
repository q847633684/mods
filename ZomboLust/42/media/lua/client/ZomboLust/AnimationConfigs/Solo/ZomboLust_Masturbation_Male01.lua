require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboLust_Masturbation_Male01", {
	animName = "ZomboLust_Masturbation_Male01",
	tags = {"Lust", "Masturbation"},
	actors = {
		{
			gender = "Male",
			stages = {
				{
					perform = "Kate_ZomboLust_Masturbation_Male01_Stage1",
					duration = 600
				},
				{
					perform = "Kate_ZomboLust_Masturbation_Male01_Stage2",
					duration = 480
				},
				{
					perform = "Kate_ZomboLust_Masturbation_Male01_Stage3",
					duration = 360
				}
			}
		}
	}
})
