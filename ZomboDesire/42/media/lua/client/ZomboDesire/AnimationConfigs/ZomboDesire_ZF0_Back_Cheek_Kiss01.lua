require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboDesire_ZF0_Back_Cheek_Kiss01", {
	animName = "ZomboDesire_ZF0_Back_Cheek_Kiss01",
	tags = {"Desire", "ZF0", "FaceToBack"},
	actors = {
		{
			character = "ZombHuman0",
			stages = {
				{
					perform = "Kate_ZomboDesire_ZF0_Back_Begin-TurnHalfway_Alt",
					duration = 240
				},
				{
					perform = {"Kate_ZomboDesire_ZF0_Back_Cheek_Kiss01"},
					duration = 300
				},
				{
					perform = "Kate_ZomboDesire_ZF0_Back_End-TurnHalfway_Alt",
					duration = 120
				}
			}
		},
		{
			character = "Player",
			stages = {
				{
					perform = "Bob_ZomboDesire_ZF0_Back_Begin-TurnHalfway_Alt",
					duration = 240
				},
				{
					perform = {"Bob_ZomboDesire_ZF0_Back_Cheek_Kiss01"},
					duration = 300
				},
				{
					perform = "Bob_ZomboDesire_ZF0_Back_End-TurnHalfway_Alt",
					duration = 120
				}
			}
		}
	}
})
