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
	local menu = {text = "ChatSounds Sounds", whileDead = 1, isNotSelectable = true}
	menu.func = ChatSoundsDropDown_OnClick

	local sound = {}
	local i = 1
	for name, value in pairs(ChatSounds_Sound) do
		sound[i] = name
		i = i + 1
	end

	table.sort(sound)

	-- Add "None" option
	table.insert(menu, {text = "None", value = nil, func = ChatSoundsDropDown_OnClick})

	-- Add all sounds
	for index, value in pairs(sound) do
		table.insert(menu, {text = value, value = value, func = ChatSoundsDropDown_OnClick})
	end

	UIDropDownMenu_Initialize(self, function() UIDropDownMenu_AddButtons(menu) end, "MENU")
end

function ChatSoundsDropDown_OnClick(self)
	if self.value then
		ChatSounds_PlaySound(self.value)
	end
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

	if Settings and Settings.RegisterCanvasLayoutCategory then
		local category = Settings.RegisterCanvasLayoutCategory(self, self.name)
		Settings.RegisterAddOnCategory(category)
	elseif InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(self)
	end
end

function ChatSoundsOptionsFrame_OnShow(self)
	ChatSounds_InitConfig()
	local playerConfig = ChatSounds_Config[ChatSounds_Player]
	for i = 1, 11 do
		local incoming = _G["ChatSoundsOptionsFrameGroup"..i.."Incoming"]
		local outgoing = _G["ChatSoundsOptionsFrameGroup"..i.."Outgoing"]

		if incoming then
			if incoming.SetValue then
				incoming:SetValue(playerConfig.Incoming[groupmap[i]])
			else
				UIDropDownMenu_SetSelectedValue(incoming, playerConfig.Incoming[groupmap[i]], 0)
			end
		end
		if outgoing then
			if outgoing.SetValue then
				outgoing:SetValue(playerConfig.Outgoing[groupmap[i]])
			else
				UIDropDownMenu_SetSelectedValue(outgoing, playerConfig.Outgoing[groupmap[i]], 0)
			end
		end
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

		if incoming then
			if incoming.GetValue then
				playerConfig.Incoming[groupmap[i]] = incoming:GetValue()
			else
				playerConfig.Incoming[groupmap[i]] = UIDropDownMenu_GetSelectedValue(incoming)
			end
		end
		if outgoing then
			if outgoing.GetValue then
				playerConfig.Outgoing[groupmap[i]] = outgoing:GetValue()
			else
				playerConfig.Outgoing[groupmap[i]] = UIDropDownMenu_GetSelectedValue(outgoing)
			end
		end
	end

	playerConfig.ForceWhispers = ChatSoundsOptionsFrameForceWhispersCheckBox:GetChecked()
end

function ChatSoundsOptionsFrame_OnDefaults(self)
	ChatSounds_InitConfig()
	for i = 1, 11 do
		local incoming = _G["ChatSoundsOptionsFrameGroup"..i.."Incoming"]
		local outgoing = _G["ChatSoundsOptionsFrameGroup"..i.."Outgoing"]

		if incoming then
			if incoming.SetValue then
				incoming:SetValue(ChatSounds_Defaults.Incoming[groupmap[i]])
			else
				UIDropDownMenu_SetSelectedValue(incoming, ChatSounds_Defaults.Incoming[groupmap[i]], 0)
			end
		end
		if outgoing then
			if outgoing.SetValue then
				outgoing:SetValue(ChatSounds_Defaults.Outgoing[groupmap[i]])
			else
				UIDropDownMenu_SetSelectedValue(outgoing, ChatSounds_Defaults.Outgoing[groupmap[i]], 0)
			end
		end
	end

	ChatSoundsOptionsFrameForceWhispersCheckBox:SetChecked(ChatSounds_Defaults.ForceWhispers)
end


