BigWigsEbonroc = AceAddon:new({
	name          = "BigWigsEbonroc",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = "Ebonroc",

	loc = {
		bossname = "Ebonroc",
		disabletrigger = "Ebonroc dies.",

		trigger1 = "Ebonroc begins to cast Wing Buffet",
		trigger2 = "Ebonroc begins to cast Shadow Flame.",
		trigger3 = "^([^%s]+) ([^%s]+) afflicted by Shadow of Ebonroc",

		warn1 = "Ebonroc begins to cast Wing Buffet!",
		warn2 = "30 seconds till next Wing Buffet!",
		warn3 = "3 seconds before Ebonroc casts Wing Buffet!",
		warn4 = "Shadow Flame incoming!",
		warn5 = "You have Shadow of Ebonroc!",
		warn6 = " has Shadow of Ebonroc!", 
		bosskill = "Ebonroc has been defeated!",
		
		bar1text = "Wing Buffet",
	},
})

function BigWigsEbonroc:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsEbonroc:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_MESSAGE")
end

function BigWigsEbonroc:Disable()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 20)
end

function BigWigsEbonroc:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsEbonroc:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
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

function BigWigsEbonroc:Event()
	local _,_, EPlayer, EType = string.find(arg1, self.loc.trigger3)
	if (EPlayer and EType) then
		if (EPlayer == "You" and EType == "are") then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
		else
			self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn6, "Yellow")
		end
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsEbonroc:RegisterForLoad()