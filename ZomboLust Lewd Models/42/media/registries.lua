--- File: ZomboLust Lewd Models/42/media/registries.lua
--- Registers new body locations for hair and stubble
--- @author BlaBla 2026

ZLLewdModelsRegistries = ZLLewdModelsRegistries or {}

ZLLewdModelsRegistries.ChestHair = ItemBodyLocation.register("zllewdmodels:chesthair")
ZLLewdModelsRegistries.ArmpitHair = ItemBodyLocation.register("zllewdmodels:armpithair")
ZLLewdModelsRegistries.PubicHair = ItemBodyLocation.register("zllewdmodels:pubichair")
ZLLewdModelsRegistries.LegHair = ItemBodyLocation.register("zllewdmodels:leghair")
ZLLewdModelsRegistries.BeardStubble = ItemBodyLocation.register("zllewdmodels:beardstubble")
ZLLewdModelsRegistries.HeadStubble = ItemBodyLocation.register("zllewdmodels:headstubble")

-- Spongie Character Customisation
SPNCC = {}
SPNCC.ItemTag = {}
SPNCC.ItemBodyLocation = {}

SPNCC.ItemTag.RemoveOnZombification = ItemTag.register("SPNCC:RemoveOnZombification")
SPNCC.ItemTag.CanHaveBlood = ItemTag.register("SPNCC:CanHaveBlood")
SPNCC.ItemTag.AppearanceChanger = ItemTag.register("SPNCC:AppearanceChanger")
SPNCC.ItemTag.AppearanceUnlocker = ItemTag.register("SPNCC:AppearanceUnlocker")
SPNCC.ItemTag.Face = ItemTag.register("SPNCC:Face")
SPNCC.ItemTag.BodyDetail = ItemTag.register("SPNCC:BodyDetail")

SPNCC.ItemBodyLocation.Blank = ItemBodyLocation.register("SPNCC:Blank")
SPNCC.ItemBodyLocation.BodyHair = ItemBodyLocation.register("SPNCC:BodyHair")
SPNCC.ItemBodyLocation.Muscle = ItemBodyLocation.register("SPNCC:Muscle")
SPNCC.ItemBodyLocation.Face = ItemBodyLocation.register("SPNCC:Face")
SPNCC.ItemBodyLocation.BodyDetail = ItemBodyLocation.register("SPNCC:BodyDetail")
SPNCC.ItemBodyLocation.StubbleBeard = ItemBodyLocation.register("SPNCC:StubbleBeard")
SPNCC.ItemBodyLocation.StubbleHead = ItemBodyLocation.register("SPNCC:StubbleHead")
SPNCC.ItemBodyLocation.BodyDetail2 = ItemBodyLocation.register("SPNCC:BodyDetail2")
SPNCC.ItemBodyLocation.Face_Model = ItemBodyLocation.register("SPNCC:Face_Model")

return ZLLewdModelsRegistries
