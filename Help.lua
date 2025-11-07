-- ============================================================================
-- SLACKSPOTTER - HELP MODULE
-- Setup guide and usage instructions
-- ============================================================================

SS_HelpTextLoaded = false
SS_Help_OriginalText = nil

-- ============================================================================
-- SHOW TAB 8
-- ============================================================================
function SS_ShowTab8Content()
    if SS_Tab8_HelpPanel then 
        SS_Tab8_HelpPanel:Show() 
    end
    
    if not SS_HelpTextLoaded then
        local editBox = getglobal("SS_Tab8_HelpEditBox")
        if editBox then
            editBox:SetText(
[[
|cffff0000-Paladins are not properly integrated yet-|r

-------------------------------------------

|cff00ff00SlackSpotter - Setup & Usage Guide|r


|cffff8000Step 1:|r
  |cffff8000Configure Consumables inside Tab 6 "Config Consumes"|r
  |cffff8000Optional: "Load Presets"|r loads default requirements from the guild <ERROR> on Tel'Abim
  
- |cffffff00Select a raid instance|r from the right-side buttons
- |cffffff00Edit consumes|r per class/spec and enable what your guild/you require
- |cffffff00"Any X" checkboxes|r let you allow any x number of Consumes from the selected ones as a mnimum requirement
- Notes:
   |cff00ff00"Load Presets"|r loads default requirements from the guild <ERROR> on Tel'Abim
   |cff80ff80Tender Wolf Steak|r covers all +Stamina/+Spirit foods


|cffff8000Step 2:|r
  |cffff8000Assign Player Specs inside Tab 5 "Config Specs"|r
  
- Click |cffffff00"Refresh"|r to load your current raid
- Assign each player a spec by hand yourself and click |cffffff00"Save Guild Specs"|r
- SlackSpotter will |cffffff00auto-load saved specs|r next time you use it
- Notes:
    You can "Enable Whisperspec" to make the addon watch your whispers
	When you "Confirm Specs" you ask people to enter their specs themself by whispering you
	You can check the "Also /w unassigned" checkbox, so that people without a selected spec get called out to select one

|cffff8000Step 3:|r
  |cffff8000Consume Check on Tab 1 "Consumes/Buffs"|r
  
- Click |cffffff00"Check Consumes"|r to see if everybody has his required consumes running
- Click |cffffff00"Raid Buffs"|r to see if all have their available buffs
- Click any of the |cffffff00Spellschool Buttons|r to see who has Greater Prot Pots running.
- Notes:
    Groups mutually exclusive buffs (if several flasks are selected for ex.)
    Optional raidbuff checkboxes:
      |cffffd000Thorns|r if you want your Tanks to have Thorns
      |cff00ff00Emerald Blessing|r if you want your Druids to buff Emerald Blessing
      |cff8080ffShadow Protection|r if the encounter requires Priests to buff Shadow Resistance

-------------------------------------------

|cff00ffccAdditional Features|r

- |cffffff00Tab 2 – Shoutouts:|r Colored messages and countdowns in chat
- |cffffff00Tab 3 – Assignments/CDs:|r In development, CDs need debugging!
- |cffffff00Tab 4 – Tactics:|r Post raid strategies, working, but currently only AI Text on traditional classic Bosses!
- |cffffff00Tab 7 – Stats:|r In development!
- |cffffff00Debug Mode:|r Prints all messages locally instead of in raidchat -> enable with Checkbox at bottom right next to version #

|cff00ffccThat's it! Happy Raiding!|r
]]
            )
			SS_Help_OriginalText = editBox:GetText()
            editBox:ClearFocus()
            SS_HelpTextLoaded = true
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[SlackSpotter] Help EditBox missing.|r")
        end
    end
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function SS_Help_Initialize()
--    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Help module loaded!|r")
end