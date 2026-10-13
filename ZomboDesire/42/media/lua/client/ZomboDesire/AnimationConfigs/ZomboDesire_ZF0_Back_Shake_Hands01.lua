require "ZomboDesire/ZomboDesire_Init" --- Always include this at the top to forceload ZomboDesire.registerAnimationConfig prior to this animation file

ZomboDesire.registerAnimationConfig("ZomboDesire_ZF0_Back_Shake_Hands01", {
	animName = "ZomboDesire_ZF0_Back_Shake_Hands01",
	tags = {"Desire", "ZF0", "FaceToBack"},
	actors = {
		{
			character = "ZombHuman0",
			stages = {
				{
					perform = "Kate_ZomboDesire_ZF0_Back_Begin-TurnAround_Alt",
					duration = 240
				},
				{
					perform = {"Kate_ZomboDesire_ZF0_Back_Shake_Hands01"},
					duration = 300
				},
				{
					perform = "Kate_ZomboDesire_ZF0_Back_End-TurnAround_Alt",
					duration = 120
				}
			}
		},
		{
			character = "Player",
			stages = {
				{
					perform = "Bob_ZomboDesire_ZF0_Back_Begin-TurnAround_Alt",
					duration = 240
				},
				{
					perform = {"Bob_ZomboDesire_ZF0_Back_Shake_Hands01"},
					duration = 300
				},
				{
					perform = "Bob_ZomboDesire_ZF0_Back_End-TurnAround_Alt",
					duration = 120
				}
			}
		}
	}
})
