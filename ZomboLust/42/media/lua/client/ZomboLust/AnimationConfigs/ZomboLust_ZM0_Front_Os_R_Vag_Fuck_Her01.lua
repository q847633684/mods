require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboLust_ZM0_Front_Os_R_Vag_Fuck_Her01", {
	animName = "ZomboLust_ZM0_Front_Os_R_Vag_Fuck_Her01",
	tags = {"Lust", "ZM0", "FaceToFace", "On stairs", "EndGameRegular", "Pregnancy"},
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
					perform = {"Kate_ZomboLust_ZM0_Front_Os_R_Fuck_Her01"},
					duration = 60
				},
				{
					perform = {"Kate_ZomboLust_ZM0_Front_Os_R_Fuck_Her01_Faster"},
					duration = 60
				},
				{
					perform = {"Kate_ZomboLust_ZM0_Front_Os_R_Fuck_Her01_Harder"},
					duration = 60
				},
				{
					perform = "Kate_ZomboLust_ZM0_Front_Os_End_Vag_Alt",
					duration = 240
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
					perform = {"Bob_ZomboLust_ZM0_Front_Os_R_Fuck_Her01"},
					duration = 60
				},
				{
					perform = {"Bob_ZomboLust_ZM0_Front_Os_R_Fuck_Her01_Faster"},
					duration = 60
				},
				{
					perform = {"Bob_ZomboLust_ZM0_Front_Os_R_Fuck_Her01_Harder"},
					duration = 60
				},
				{
					perform = "Bob_ZomboLust_ZM0_Front_Os_End_Vag_Alt",
					duration = 240
				}
			}
		}
	}
})
