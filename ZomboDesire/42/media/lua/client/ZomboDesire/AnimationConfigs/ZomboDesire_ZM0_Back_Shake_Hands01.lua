require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboDesire_ZM0_Back_Shake_Hands01", {
	animName = "ZomboDesire_ZM0_Back_Shake_Hands01",
	tags = {"Desire", "ZM0", "FaceToBack"},
	actors = {
		{
			character = "Player",
			stages = {
				{
					perform = "Kate_ZomboDesire_ZM0_Back_Begin-TurnHalfway_Alt",
					duration = 240
				},
				{
					perform = {"Kate_ZomboDesire_ZM0_Back_Shake_Hands01"},
					duration = 300
				},
				{
					perform = "Kate_ZomboDesire_ZM0_Back_End-TurnHalfway_Alt",
					duration = 120
				}
			}
		},
		{
			character = "ZombHuman0",
			stages = {
				{
					perform = "Bob_ZomboDesire_ZM0_Back_Begin-TurnHalfway_Alt",
					duration = 240
				},
				{
					perform = {"Bob_ZomboDesire_ZM0_Back_Shake_Hands01"},
					duration = 300
				},
				{
					perform = "Bob_ZomboDesire_ZM0_Back_End-TurnHalfway_Alt",
					duration = 120
				}
			}
		}
	}
})
