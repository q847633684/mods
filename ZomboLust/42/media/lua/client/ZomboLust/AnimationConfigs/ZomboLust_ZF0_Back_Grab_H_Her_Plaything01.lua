require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboLust_ZF0_Back_Grab_H_Her_Plaything01", {
	animName = "ZomboLust_ZF0_Back_Grab_H_Her_Plaything01",
	tags = {"Lust", "ZF0", "FaceToBack", "EndGameHardcore"},
	needsPenis = "human",
	actors = {
		{
			character = "ZombHuman0",
			stages = {
				{
					perform = "Kate_ZomboLust_ZF0_Back_GrabbingStanding_Begin_Alt",
					duration = 240
				},
				{
					perform = {"Kate_ZomboLust_ZF0_Back_Grab_H_Her_Plaything01"},
					duration = 60
				},
				{
					perform = "Kate_ZomboLust_ZF0_Back_StandingGroggy_End_Alt",
					duration = 240
				}
			}
		},
		{
			character = "Player",
			stages = {
				{
					perform = "Bob_ZomboLust_ZF0_Back_GrabbingStanding_Begin_Alt",
					duration = 240
				},
				{
					perform = {"Bob_ZomboLust_ZF0_Back_Grab_H_Her_Plaything01"},
					duration = 60
				},
				{
					perform = "Bob_ZomboLust_ZF0_Back_StandingGroggy_End_Alt",
					duration = 240
				}
			}
		}
	}
})
