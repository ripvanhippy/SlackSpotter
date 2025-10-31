# SlackSpotter

# Wat is diz

Slackspotter is a raid management tool i created for TWoW because Slackers with consumes are a pain in the butt, and checking every single consume
drove me nuts. I had zero XP coding starting this, and Claude as well as a bit of ChatGPT did the main bulk of heavy lifting, while i guided them
through the heavy storm of AI coding smell they drove us in time and time again.
Lets call it a Love-Hate-Relationship... sometimes i want to punsh my screen, sometimes i love what i created

Anyways this is still in development as it gets more and more refiend, so please excuse the occasional bug

# Consider Supporting

This ate weeks of my time ;_;
and its still not done!

https://buymeacoffee.com/gahanaho


# setup:
# STEP 1
**- Theres a minimap button u can leftclick, otherwise type /ss**

[**-->Only needed on very first startup if you want to use the <ERROR> consume-preset**
- switch to tab 6 "config consumes" and hit "load presets" then "save"
- the hardcoded preset is then autoloaded when using the addon. it sets up mc, bwl, aq40, naxx, kara40 with Consume-Guildrules of <ERROR>
**End of First time Setup!--<]**

# STEP 2
**select the raid on the right sidepanel that you want to Raid**

# STEP 3
**If you want to change required Consumes for your raids, switch to tab 6 "Config Consumes"**
	
- changing consumes without saving affects only working memory! Working memory is used during checks, but not retained between reloads
- saving commits the change into long term memory, long term memory gets autoloaded on startup after relog.
- "any x consume:" checkboxes set a min requirement, like 1 is selected in mc because we only require at least 1 consume out of the ticked list
- if you, for some ungodly reason, want your mages to pop Giants, you can tick "List all" in the top right, to see all consumes for ticking

# STEP 2
go to tab 5 "Config Specs", hit refresh. you see all current raidmembers. you can assign each member a spec based on class
	
- you need to do this by hand, but remember to hit save guild specs when ur done!
- all guildmembers inside the raid that are from your guild are saved as per your choice and get autoloaded if detected after refresh
- after a few raids you barely have to chose anyone, addon knows usual specs of your guildies and autoloads them.

# STEP 3
**go to tab 1 "Consumes/Buffs", hit refresh to get an overview of your raid. you can see missing buffs based on raid comp and spec, also missing consumes based on your config from tab 6 "config consumes"**
- hitting "raid buff check" automatically refreshes the overview again and spits out into raidchat if there are buffs missing. if u want the tanks to have thorns, the priest to buff shadow prot or the druids to buff emerald blessing, check the boxes before hitting the button personal buffs, like Mage Armor, are whispered, to keep Raidchat clean  
- next are the buttons for the greater prot pots. if too many are missing it, message gets grouped. you can check "list everyone" to call out a long list of people in several messages.
- then the main consume check. it also autorefreshes overview and it shows you left of it what raid you have selected and if you have ppl in the raid that dont have a spec assigned by you in tab 5 "Config Specs"
- stats panel below Main Consume Check is not working for now, just placeholder

**DONE! Happy Raiding!**


# --> SILENT CHECK <--
**if you are solo without grp/raid
-or-
**you want to review what you will post in chat, you can use DEBUG mode.

- bottom right next to version number is a semi-hidden checkbox, when u tick it you generate console messages instead of chatmessages, so you know what you will post using the normal functionality b4hand

i introduced that so i can review and debug messages without spamming raidchat
-or-
when i do silent checks and whisper ppl instead of spamming 10 lines again and again in raidchat

# Other Tabs:
1. Shoutouts
- Shoutouts into various Channels with colored messages. Rainbow messages are limited into 19 letters with a max of 8 spaces on top
- countdown like many loot addons, with starting and ending message. careful, might get cut off because 11 message chatlimit with lower interval!
2. Assignments
- non populated yet
- WORK IN PROGRESS
3. Tactics
- Strategy Guildes for quick Raidchat posting
- Can be edited before posting
- buttons working, but only placeholder AI text for **some** tanking strategies, otherwise still missing the hardcoded preset strategies!
- WORK IN PROGRESS

# Known Issues:
- Consume "Tender Wolf Steak" represents all 12 stamina/12 Spirit food, despite naming only this specific one
- Spellshool Elixirs are not mutally exclusive, as this was never an Issue, since Greater Arcane Power got introduced last patch I made Arcane and Nature Elixir mutally exclusive so Boomies can chose what to pop if both are selected for them
- Tab 1 and Tab 5 are not automatically refreshing for convinience when clicking on that tab
- as stated missing functionality: tab 3 completly, tab 4 hardcoded tactics and a save button to remember changes for guild specific tactics
- stats panel at tab 1 is just a placeholder, code is not done!