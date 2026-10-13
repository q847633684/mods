require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboLust_ZF0_Front_So_S_Finger_Herself01", {
	animName = "ZomboLust_ZF0_Front_So_S_Finger_Herself01",
	tags = {"Lust", "ZF0", "FaceToFace", "Sitting on", "EndGameShy"},
	needsPenis = "human",
	actors = {
		{
			character = "ZombHuman0",
			stages = {
				{
					perform = "Kate_ZomboLust_ZF0_Front_So_Begin_Alt",
					duration = 240
				},
				{
					perform = {"Kate_ZomboLust_ZF0_Front_So_S_Finger_Herself01"},
					duration = 60
				},
				{
					perform = "Kate_ZomboLust_ZF0_Front_So_End_S_Alt",
					duration = 120
				}
			}
		},
		{
			character = "Player",
			stages = {
				{
					perform = "Bob_ZomboLust_ZF0_Front_So_Begin_Alt",
					duration = 240
				},
				{
					perform = {"Bob_ZomboLust_ZF0_Front_So_S_Finger_Herself01"},
					duration = 60
				},
				{
					perform = "Bob_ZomboLust_ZF0_Front_So_End_S_Alt",
					duration = 120
				}
			}
		}
	}
})
