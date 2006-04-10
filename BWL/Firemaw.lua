BigWigsFiremaw = AceAddon:new({
	name          = "BigWigsFiremaw",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = "Firemaw",

	loc = {
		bossname = "Firemaw",
		disabletrigger = "Firemaw dies.",

		trigger1 = "Firemaw begins to cast Wing Buffet",
		trigger2 = "Firemaw begins to cast Shadow Flame.",

		warn1 = "Firemaw begins to cast Wing Buffet!",
		warn2 = "30 seconds till next Wing Buffet!",
		warn3 = "3 seconds before Firemaw casts Wing Buffet!",
		warn4 = "Shadow Flame Incoming!",
		bosskill = "Firemaw has been defeated!",
		
		bar1text = "Wing Buffet",
	},
})

function BigWigsFiremaw:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsFiremaw:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_MESSAGE")
end

function BigWigsFiremaw:Disable()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 20)
end

function BigWigsFiremaw:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsFiremaw:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 27, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SelfDestruct")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	elseif (arg1 == self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsFiremaw:RegisterForLoad()