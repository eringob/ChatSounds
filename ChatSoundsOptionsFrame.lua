local groupmap = {} --- Map chat message types to OptionFrame's Group Numbers
groupmap[1] = "GUILD"
groupmap[2] = "OFFICER"
groupmap[3] = "PARTY"
groupmap[4] = "PARTY_LEADER"
groupmap[5] = "RAID"
groupmap[6] = "RAID_LEADER"
groupmap[7] = "INSTANCE_CHAT"
groupmap[8] = "INSTANCE_CHAT_LEADER"
groupmap[9] = "WHISPER"
groupmap[10] = "BNWHISPER"
groupmap[11] = "CHANNEL"

function ChatSoundsDropDown_OnShow (self)
	UIDropDownMenu_SetSelectedID(self, 1, 0)
	UIDropDownMenu_Initialize(self, ChatSoundsDropDown_Init)
end

function ChatSoundsDropDown_Init(self)
	local sound = {}
	local i = 1
	for name, value in pairs(ChatSounds_Sound) do
		sound[i] = name
		i = i + 1
	end

	table.sort (sound)

	local entry;
	entry = UIDropDownMenu_CreateInfo();

	entry.text    = "None"
	entry.value   = nil
	entry.func    = ChatSoundsDropDown_OnClick
	entry.checked = false
	entry.owner   = self

	UIDropDownMenu_AddButton(entry)

	for index, value in pairs(sound) do

		entry.text    = value
		entry.value   = value
		entry.func    = ChatSoundsDropDown_OnClick
		entry.checked = false
		entry.owner   = self

		UIDropDownMenu_AddButton(entry)
	end

end

function ChatSoundsDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value, 0);
	ChatSounds_PlaySound(self.value);
end

function ChatSoundsOptionsFrame_OnLoad (self)
	tinsert(UISpecialFrames, self:GetName());
	self:SetBackdropColor(0,0,0,1)
	self:SetClampedToScreen(true);

	self.name = "ChatSounds"
	self.okay = ChatSoundsOptionsFrame_OnOkay
	self.cancel = ChatSoundsOptionsFrame_OnCancel
	self.default = ChatSoundsOptionsFrame_OnDefaults
	self.refresh = ChatSoundsOptionsFrame_OnShow

	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(self)
	end
end

function ChatSoundsOptionsFrame_OnShow(self)
	ChatSounds_InitConfig()
	local playerConfig = ChatSounds_Config[ChatSounds_Player]
	for i = 1, 11 do
		local incoming = _G["ChatSoundsOptionsFrameGroup"..i.."Incoming"]
		local outgoing = _G["ChatSoundsOptionsFrameGroup"..i.."Outgoing"]

		UIDropDownMenu_SetSelectedValue(incoming, playerConfig.Incoming[groupmap[i]], 0)
		UIDropDownMenu_SetSelectedValue(outgoing, playerConfig.Outgoing[groupmap[i]], 0)
	end

	ChatSoundsOptionsFrameForceWhispersCheckBox:SetChecked (playerConfig.ForceWhispers)
end

function ChatSoundsOptionsFrame_OnCancel(self)
	HideUIPanel(self)
end

function ChatSoundsOptionsFrame_OnOkay(self)
	ChatSounds_InitConfig()
	local playerConfig = ChatSounds_Config[ChatSounds_Player]
	for i = 1, 11 do
		local incoming = _G["ChatSoundsOptionsFrameGroup"..i.."Incoming"]
		local outgoing = _G["ChatSoundsOptionsFrameGroup"..i.."Outgoing"]

		playerConfig.Incoming[groupmap[i]] = UIDropDownMenu_GetSelectedValue (incoming)
		playerConfig.Outgoing[groupmap[i]] = UIDropDownMenu_GetSelectedValue (outgoing)
	end

	playerConfig.ForceWhispers = ChatSoundsOptionsFrameForceWhispersCheckBox:GetChecked()
end

function ChatSoundsOptionsFrame_OnDefaults(self)
	ChatSounds_InitConfig()
	for i = 1, 11 do
		local incoming = _G["ChatSoundsOptionsFrameGroup"..i.."Incoming"]
		local outgoing = _G["ChatSoundsOptionsFrameGroup"..i.."Outgoing"]

		UIDropDownMenu_SetSelectedValue(incoming, ChatSounds_Defaults.Incoming[groupmap[i]], 0)
		UIDropDownMenu_SetSelectedValue(outgoing, ChatSounds_Defaults.Outgoing[groupmap[i]], 0)
	end

	ChatSoundsOptionsFrameForceWhispersCheckBox:SetChecked(ChatSounds_Defaults.ForceWhispers)
end


