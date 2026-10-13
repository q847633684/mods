require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboLust_ZM0_Front_Os_S_Jerk_Off01", {
	animName = "ZomboLust_ZM0_Front_Os_S_Jerk_Off01",
	tags = {"Lust", "ZM0", "FaceToFace", "On stairs", "EndGameShy"},
	needsPenis = "human",
	actors = {
		{
			character = "Player",
			stages = {
				{
					perform = "Kate_ZomboLust_ZM0_Front_Os_Begin_Alt",
					duration = 240
				},
				{
					perform = {"Kate_ZomboLust_ZM0_Front_Os_S_Jerk_Off01"},
					duration = 60
				},
				{
					perform = "Kate_ZomboLust_ZM0_Front_Os_End_S_Alt",
					duration = 120
				}
			}
		},
		{
			character = "ZombHuman0",
			stages = {
				{
					perform = "Bob_ZomboLust_ZM0_Front_Os_Begin_Alt",
					duration = 240
				},
				{
					perform = {"Bob_ZomboLust_ZM0_Front_Os_S_Jerk_Off01"},
					duration = 60
				},
				{
					perform = "Bob_ZomboLust_ZM0_Front_Os_End_S_Alt",
					duration = 120
				}
			}
		}
	}
})
