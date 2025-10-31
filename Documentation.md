# SlackSpotter

# SLACKSPOTTER - COMPLETE UI DOCUMENTATION

**Detailed guide to every button, checkbox, and UI element in the addon.**
For users, developers, and AI understanding.

---

## OVERVIEW OF THE ADDON

**SlackSpotter** is a raid management tool for WoW 1.12.1 that:
1. Checks if raid members have required consumables (flasks, elixirs, food, etc.)
2. Checks if raid members have required class buffs (Mark of the Wild, Fortitude, etc.)
3. Sends colored announcements and countdowns to various chat channels
4. Displays boss tactics and strategies
5. Manages player spec assignments for different raid instances
6. Configures which consumables each spec needs per raid

---

## MAIN WINDOW STRUCTURE

### Window Frame
- **Draggable**: Click and drag the window to move it
- **Alpha**: Semi-transparent (0.75) to see through it
- **Size**: 800x750 pixels
- **Always on top**: Uses DIALOG frame strata

### Top Tabs (Main Navigation)
6 tabs across the top:
1. **Overview** - Main checking interface
2. **Shoutouts** - Colored messages and countdowns
3. **Assignments** - (Placeholder for future feature)
4. **Tactics** - Boss strategies and tactics
5. **Config Specs** - Assign player specializations
6. **Config Consumes** - Configure required consumables

**Function**: `SS_SelectTab(tabNum)`
**What it does**: 
- Hides all panels from other tabs
- Shows panels for selected tab
- Updates tab visual highlight
- Some tabs trigger auto-load functions

### Right-Side Raid Tabs (Raid Instance Selection)
10 raid instance buttons stacked vertically on the right:
- Kara40 (Karazhan 40-man)
- Naxx (Naxxramas)
- AQ40 (Ahn'Qiraj 40)
- BWL (Blackwing Lair)
- MC (Molten Core)
- ES (Emerald Sanctum)
- Ony (Onyxia)
- ZG (Zul'Gurub)
- AQ20 (Ruins of Ahn'Qiraj)
- Kara10 (Karazhan 10-man)

**Function**: `SS_SelectRaid(raidName)`
**What it does**:
- Sets `SS_ConsumeConfig_CurrentRaid` global variable
- Updates raid tab highlight (selected = full opacity, others dimmed)
- Syncs selection to Tab 4 (Tactics) - updates boss list
- Syncs selection to Tab 6 (Consume Config) - loads raid-specific presets
- If on Tab 1, future feature will auto-refresh checks

### Debug Checkbox (Bottom-Right)
Small checkbox near bottom-right corner

**Function**: `SS_Debug_Toggle()`
**What it does**:
- Toggles `SS_DebugMode` variable (true/false)
- When enabled: Shoutouts print to chat instead of sending to channels
- When enabled: Tab 6 shows internal consume IDs next to names
- Used for testing without spamming raid chat

### Minimap Button
Circular button on minimap with SlackSpotter icon

**Function**: `SS_ToggleFrame()`
**What it does**:
- Shows main window if hidden
- Hides main window if shown
- Tooltip shows available options and modifier key hints

---

## TAB 1: OVERVIEW (RAID CHECKING)

This is the main tab for checking raid readiness. It has 5 panels.

### PANEL 1: RAID BUFF CHECK (Top-Left)

**Purpose**: Check for optional raid-wide class buffs

#### Checkbox: "Check for Druid - Thorns"
**Function**: `SS_Tab1_RaidBuffCheckPanel_ThornsCheckbox_OnClick()`
**What it does**:
- Toggles `SS_RaidBuffs_Selected.Thorns` (true/false)
- When checked: Buff check will verify tanks have Thorns
- When unchecked: Thorns is ignored during buff check
- Setting persists during current session only

#### Checkbox: "Check for Priest - Shadow Protection"
**Function**: `SS_Tab1_RaidBuffCheckPanel_ShadowProtCheckbox_OnClick()`
**What it does**:
- Toggles `SS_RaidBuffs_Selected.ShadowProtection` (true/false)
- When checked: Buff check will verify all raid members have Shadow Protection
- When unchecked: Shadow Protection is ignored
- Setting persists during current session only

#### Checkbox: "Check for Druid - Emerald Blessing"
**Function**: `SS_Tab1_RaidBuffCheckPanel_EmeraldBlessCheckbox_OnClick()`
**What it does**:
- Toggles `SS_RaidBuffs_Selected.EmeraldBlessing` (true/false)
- When checked: Buff check will verify druids have Emerald Blessing
- Special logic: If ANY druid has it, all druids are marked as having it (group buff)
- Setting persists during current session only

#### Button: "Raid Buff Check"
**Function**: `SS_Tab1_RaidBuffCheckPanel_RaidBuffCheckButton_OnClick()`
**What it does**:
1. Calls `SS_Tab1_RefreshAndCheckAll()` which:
   - Auto-refreshes Tab 5 raid list (`SS_ConfigSpecs_RefreshRaid()`)
   - Auto-loads saved specs from database (`SS_ConfigSpecs_AutoLoadSavedSpecs()`)
   - Runs consume check for current raid (`SS_Check_CheckEntireRaid()`)
   - Runs buff check for all raid members (`SS_RaidBuff_CheckEntireRaid()`)
   - Merges consume and buff results into one table
2. Stores merged results in `SS_Display_RaidResults`
3. Updates the raid list display (`SS_Display_UpdateRaidList()`)
4. Updates info labels (total players, pass/fail counts)

**Technical details**:
- Scans all 32 buff slots for each raid member using `UnitBuff()`
- Matches buff names against definitions in `SS_RaidBuffs_Definitions`
- Checks class availability (e.g., needs Priest online for Fort check)
- Considers player specs from Tab 5 (e.g., mana users need Int/Spirit)
- Returns: `[playerName] = {buffsFound, buffsRequired, missing={}}`

### PANEL 2: PROTECTION POTION CHECK (Middle-Left Part 1)

**Purpose**: Quick check for which players need specific protection potions

#### Button: "Arcane"
**Function**: `SS_Tab1_ProtectionPotionPanel_ProtPotArcaneButton_OnClick()`
**What it does**:
- Placeholder for Arcane Protection Potion check
- Future: Will scan raid buffs for Arcane Protection
- Future: Will announce who needs to drink it

#### Button: "Fire"
**Function**: `SS_Tab1_ProtectionPotionPanel_ProtPotFireButton_OnClick()`
**What it does**:
- Placeholder for Fire Protection Potion check

#### Button: "Frost"
**Function**: `SS_Tab1_ProtectionPotionPanel_ProtPotFrostButton_OnClick()`
**What it does**:
- Placeholder for Frost Protection Potion check

#### Button: "Nature"
**Function**: `SS_Tab1_ProtectionPotionPanel_ProtPotNatureButton_OnClick()`
**What it does**:
- Placeholder for Nature Protection Potion check

#### Button: "Shadow"
**Function**: `SS_Tab1_ProtectionPotionPanel_ProtPotShadowButton_OnClick()`
**What it does**:
- Placeholder for Shadow Protection Potion check

#### Button: "Holy"
**Function**: `SS_Tab1_ProtectionPotionPanel_ProtPotHolyButton_OnClick()`
**What it does**:
- Placeholder for Holy Protection Potion check

#### Checkbox: "List everyone"
**Function**: `SS_Tab1_ProtectionPotionPanel_ListEveryoneCheckbox_OnClick()`
**What it does**:
- Toggles `SS_ListEveryoneProtection` (true/false)
- When checked: Future announcements will list all players
- When unchecked: Future announcements will list only those missing potions

### PANEL 3: MAIN CONSUME CHECK (Middle-Left Part 2)

**Purpose**: Run the full consumable check based on Tab 6 configuration

**Display Labels**:
- "Current Raid: [Name]" - Shows selected raid instance
- "Players: X/Y" - Shows how many have specs assigned vs total in raid
- "Passed: X Failed: Y" - Shows check results summary

#### Button: "Check Consumes"
**Function**: `SS_Tab1_ConsumeButtonCheckPanel_CheckButton_OnClick()`
**What it does**:
1. Calls `SS_Tab1_RefreshAndCheckAll()` (same as Raid Buff Check button)
2. Performs complete consume check for entire raid
3. Updates display with color-coded results (green = pass, red = fail)

**Technical flow**:
1. For each raid member:
   - Get player name and class from `GetRaidRosterInfo()`
   - Get player's assigned spec from Tab 5 (`SS_Check_GetPlayerSpec()`)
   - Get required consumes for that raid+spec from Tab 6 (`SS_Check_GetRequiredConsumes()`)
   - Scan player's buffs (32 buff slots via `UnitBuff()`)
   - Match buff names to consume names (`SS_Check_ScanBuffsForConsumes()`)
   - Compare found vs required, handle consume groups (`SS_Check_CompareWithRequired()`)
   - Calculate pass/fail based on "Any X" rules if applicable
2. Return results table: `[playerName] = {found, required, missing={}, passed}`

#### Button: "Announce to Raid"
**Function**: `SS_Tab1_ConsumeButtonCheckPanel_AnnounceButton_OnClick()`
**What it does**:
1. Formats missing consumes for announcement (`SS_ConsumeAnnounce_Format()`)
   - Groups players by missing consume
   - Handles players with no assigned spec separately
   - Uses shortened consume names for readability
2. Sends formatted messages to raid chat (`SS_ConsumeAnnounce_Send()`)
3. Also formats and sends missing raid buffs (`SS_RaidBuffAnnounce_Send()`)
   - Raid buffs go to RAID chat
   - Personal buffs go as whispers to individual players

**Announcement format example**:
```
--- Missing Consumes for MC ---
Flask of the Titans: PlayerA, PlayerB, PlayerC
Elixir of Mongoose: PlayerD, PlayerE
--- Players with no spec assigned ---
PlayerX, PlayerY
```

### PANEL 4: STATS (Middle-Left Part 3)

**Purpose**: Track and announce performance statistics (placeholder)

#### Button: "Rep +"
**Function**: `SS_Tab1_StatsPanel_RepPlusButton_OnClick()`
**What it does**:
- Placeholder for announcing best performers
- Future: Will announce players with highest consume counts
- Future: Will track across multiple checks

#### Button: "Rep -"
**Function**: `SS_Tab1_StatsPanel_RepMinusButton_OnClick()`
**What it does**:
- Placeholder for announcing underperformers
- Future: Will announce players with most missing consumes

#### Button: "Reset Stats"
**Function**: `SS_Tab1_StatsPanel_ResetButton_OnClick()`
**What it does**:
- Placeholder for resetting tracked statistics
- Future: Will clear all performance tracking data

#### Button: "Take Data"
**Function**: `SS_Tab1_StatsPanel_TakeDataButton_OnClick()`
**What it does**:
- Placeholder for capturing current check results
- Future: Will store results for statistical analysis

### PANEL 5: RAID LIST DISPLAY (Right-Side, Large)

**Purpose**: Show detailed consume and buff status for all raid members

**Display**: Scrollable list of raid members showing:
- Player name (color-coded by class)
- Spec name (from Tab 5)
- Buffs: X/Y (green if complete, red if missing)
- Consumes: X/Y (green if pass, red if fail)

**Auto-sorts by**:
1. Class (Warrior, Paladin, Hunter, Shaman, Rogue, Druid, Priest, Mage, Warlock)
2. Name (alphabetically within each class)

#### Scroll Up Button (arrow at top)
**Function**: `SS_Tab1_ScrollUp()`
**What it does**:
- Decreases `SS_Display_ScrollOffset` by 3
- Minimum value: 0 (top of list)
- Redraws visible rows

#### Scroll Down Button (arrow at bottom)
**Function**: `SS_Tab1_ScrollDown()`
**What it does**:
- Increases `SS_Display_ScrollOffset` by 3
- Maximum value: (total members - 25)
- Redraws visible rows

**Technical details**:
- Shows 25 rows at a time
- Each row is 20 pixels tall
- Rows are created dynamically in XML (SS_Tab1_RaidRow1 through SS_Tab1_RaidRow25)
- Row updates call `SS_Display_RenderRow()` which sets text and colors

---

## TAB 2: SHOUTOUTS (COLORED MESSAGES)

This tab sends colored messages and countdowns to chat channels.

### PANEL 1: CHANNEL SELECTION (Top-Left)

**Purpose**: Choose where to send messages

#### Button: "RAID"
**Function**: `SS_Shoutouts_SelectChannel("RAID")`
**What it does**:
- Sets `SS_Shoutouts_SelectedChannel = "RAID"`
- Saves to `SS_ShoutoutsDB.lastChannel`
- Highlights this button, unhighlights others
- Messages will send to raid chat

#### Button: "SAY"
**Function**: `SS_Shoutouts_SelectChannel("SAY")`
**What it does**:
- Sets channel to SAY (local area chat)

#### Button: "PARTY"
**Function**: `SS_Shoutouts_SelectChannel("PARTY")`
**What it does**:
- Sets channel to PARTY (5-man group chat)

#### Button: "GUILD"
**Function**: `SS_Shoutouts_SelectChannel("GUILD")`
**What it does**:
- Sets channel to GUILD

#### Button: "YELL"
**Function**: `SS_Shoutouts_SelectChannel("YELL")`
**What it does**:
- Sets channel to YELL (larger area than say)

#### Button: "OFFICER"
**Function**: `SS_Shoutouts_SelectChannel("OFFICER")`
**What it does**:
- Sets channel to OFFICER (officer chat)

#### Button: "WHISPER"
**Function**: `SS_Shoutouts_SelectChannel("WHISPER")`
**What it does**:
- Sets channel to WHISPER
- Shows "Whisper Target" text box
- Requires target name to be entered

**Whisper Target EditBox**: Text input field that appears only when WHISPER is selected
- Stores name in `SS_Shoutouts_WhisperTarget`
- Loads last used target from `SS_ShoutoutsDB.lastWhisperTarget`

### PANEL 2: COLOR SELECTION (Top-Right)

**Purpose**: Choose message color

#### Button: "Red"
**Function**: `SS_Shoutouts_SelectColor("red")`
**What it does**:
- Sets `SS_Shoutouts_SelectedColor = "red"`
- Uses hex code: ff0000
- Highlights button in red
- Updates character counter limit display

#### Button: "Blue"
**Function**: `SS_Shoutouts_SelectColor("blue")`
**What it does**:
- Sets color to blue (hex: 0080ff)

#### Button: "Green"
**Function**: `SS_Shoutouts_SelectColor("green")`
**What it does**:
- Sets color to green (hex: 00ff00)

#### Button: "Yellow"
**Function**: `SS_Shoutouts_SelectColor("yellow")`
**What it does**:
- Sets color to yellow (hex: ffff00)

#### Button: "Orange"
**Function**: `SS_Shoutouts_SelectColor("orange")`
**What it does**:
- Sets color to orange (hex: ff8000)

#### Button: "Purple"
**Function**: `SS_Shoutouts_SelectColor("purple")`
**What it does**:
- Sets color to purple (hex: c080ff)

#### Button: "White"
**Function**: `SS_Shoutouts_SelectColor("white")`
**What it does**:
- Sets color to white (hex: ffffff)

#### Button: "Pink"
**Function**: `SS_Shoutouts_SelectColor("pink")`
**What it does**:
- Sets color to pink (hex: ff80c0)

#### Button: "Rainbow"
**Function**: `SS_Shoutouts_SelectColor("rainbow")`
**What it does**:
- Sets special rainbow mode
- Each letter gets different color from sequence: red, orange, yellow, green, blue, indigo, violet
- Spaces are preserved (not colored)
- **Special limits**: Max 19 letters (not including spaces) and max 8 spaces
- Updates counter to show both letter count and space count

### PANEL 3: MESSAGE INPUT (Middle)

**Purpose**: Type and send the colored message

#### EditBox: Message Input
Large text box for typing message
- Updates character counter on every keystroke (`OnTextChanged`)
- Function: `SS_Shoutouts_UpdateCharCounter()`
- Shows "X/243" for normal colors
- Shows "X/19 (Y/8 spaces)" for rainbow

#### Character Counter
**Function**: `SS_Shoutouts_UpdateCharCounter()`
**What it does**:
- Counts characters in message
- For normal colors: Max 243 characters total
- For rainbow: Max 19 letters + max 8 spaces (separate limits)
- Turns red when over limit
- Blocks sending if over limit

#### Button: "Send"
**Function**: `SS_Shoutouts_SendButton_OnClick()`
**What it does**:
1. Validates message length (blocks if over limit)
2. Validates whisper target (if WHISPER channel selected)
3. Colorizes message:
   - Normal: Wraps in `|cffXXXXXX....|r` tags
   - Rainbow: Each letter gets own color tag
4. Sends via `SS_Shoutouts_SendToChannel()`:
   - Uses `SendChatMessage(message, channel)`
   - Checks if in raid/party before sending
   - In debug mode: prints to chat instead of sending

**Technical details**:
- Color codes use format: `|cffRRGGBB` + text + `|r`
- Rainbow alternates through 7 colors, preserving spaces
- Validation prevents spam/errors

### PANEL 4: COUNTDOWN (Bottom)

**Purpose**: Automated countdown sequence with custom messages

#### Checkbox: "Enable Countdown"
**Function**: `SS_Shoutouts_CountdownCheckbox_OnClick()`
**What it does**:
- Toggles `SS_Shoutouts_CountdownEnabled` (true/false)
- When enabled: Countdown section becomes active
- Currently always enabled (checkbox might be placeholder)

#### EditBox: "Countdown Seconds"
**Function**: Input field for countdown duration
**What it does**:
- Sets how many seconds to count down
- Default: 8
- Stored in `SS_Shoutouts_CountdownSeconds`

#### EditBox: "Interval"
**Function**: Input field for time between countdown numbers
**What it does**:
- Sets seconds between each countdown number
- Default: 2
- Example: 8 seconds with 2-second interval = "8... 6... 4... 2..."
- Stored in `SS_Shoutouts_CountdownInterval`

#### EditBox: "Before Message"
**Function**: Input field for message sent before countdown starts
**What it does**:
- Message sent first, then countdown begins after interval
- Example: "Pull in..."
- Uses selected color
- For rainbow: shows character counter below box

#### EditBox: "After Message"
**Function**: Input field for message sent after countdown finishes
**What it does**:
- Final message sent 1 second after countdown reaches 0
- Example: "Pull now!"
- Uses selected color
- For rainbow: shows character counter below box

#### Button: "Start Countdown"
**Function**: `SS_Shoutouts_StartCountdown()`
**What it does**:
1. Validates countdown not already running
2. Gets settings (seconds, interval, before/after messages)
3. Sends "before" message (if provided)
4. Waits interval seconds
5. Begins countdown loop (`SS_Shoutouts_CountdownTick()`):
   - Sends current number + "..."
   - Waits interval seconds
   - Decrements counter
   - Repeats until 0
6. Waits 1 second after 0
7. Sends "after" message (if provided)
8. Sets `SS_Shoutouts_CountdownActive = false`

**Technical details**:
- Uses `SS_ScheduleTimer()` for delays (creates OnUpdate frame)
- Each countdown tick is independent function call (not a loop)
- Prevents multiple countdowns running simultaneously

**Example countdown flow** (8 seconds, 2-second interval):
```
[T=0] "Pull in..."
[T=2] "8..."
[T=4] "6..."
[T=6] "4..."
[T=8] "2..."
[T=9] "Pull now!"
```

---

## TAB 3: ASSIGNMENTS (PLACEHOLDER)

**Status**: Not yet implemented
**Purpose**: Future feature for raid assignment management
- Tank assignments
- Healer assignments
- DPS rotations
- Mark assignments

---

## TAB 4: TACTICS (BOSS STRATEGIES)

This tab displays boss tactics and strategies organized by raid, boss, and role.

### PANEL 1: BOSS/TRASH SELECTION (Top)

**Purpose**: Select which encounter to view

**Display**: Shows current raid instance name at top

#### Boss Buttons (Dynamically Created)
**Function**: `SS_Tactics_SelectBoss(bossName)`
**What it does**:
- Sets `SS_Tactics_SelectedBoss = bossName`
- Sets view mode to "boss"
- Loads strategy for selected boss + current role
- Highlights selected button
- Creates buttons based on `SS_Tactics_BossOrder[raidName]`

**Technical details**:
- Buttons created in `SS_Tactics_CreateBossButtons()`
- Called on PLAYER_ENTERING_WORLD event
- Shows up to 50 bosses per raid (5 columns x 10 rows)
- Button names: SS_Tab4_BossButton1 through SS_Tab4_BossButton50

#### Trash Buttons (Dynamically Created)
**Function**: `SS_Tactics_SelectTrash(trashName)`
**What it does**:
- Same as boss selection but for trash encounters
- Sets view mode to "trash"
- Shows trash-specific strategies

### PANEL 2: ROLE SELECTION (Middle)

**Purpose**: Choose which role's strategy to view

**Roles**: Tanks, Healer, Special 1, Phys DPS, Caster DPS, Special 2

#### Role Buttons (Dynamically Created)
**Function**: `SS_Tactics_SelectRole(roleName)`
**What it does**:
- Sets `SS_Tactics_SelectedRole = roleName`
- Loads strategy for current boss + selected role
- Highlights selected role button

**Technical details**:
- Creates 6 buttons from `SS_Tactics_RoleOrder`
- Button names: SS_Tab4_RoleButton1 through SS_Tab4_RoleButton6

### PANEL 3: STRATEGY DISPLAY (Bottom)

**Purpose**: Show the actual strategy text

**Display**: Large scrollable text area

**Function**: `SS_Tactics_LoadStrategy()`
**What it does**:
1. Gets current raid, boss, and role selections
2. Looks up strategy in `SS_Tactics_Strategies[raid][boss][role]`
3. Displays text in scrollable frame
4. If no strategy found, shows "No strategy available"

**Data source**: SS_TacticsData.lua contains all strategy texts

### SYNC BEHAVIOR

When raid instance is changed (right-side tabs):
**Function**: `SS_Tactics_SyncRaidSelection(raidName)`
**What it does**:
1. Updates `SS_Tactics_CurrentRaid`
2. Updates instance label display
3. Refreshes boss button list
4. Refreshes trash button list
5. Auto-selects first boss in new raid
6. Auto-selects "Tanks" role
7. Loads strategy for first boss + Tanks

---

## TAB 5: CONFIG SPECS (SPEC ASSIGNMENT)

This tab assigns player specializations for consume checking.

### PANEL 1: CONTROL BUTTONS (Top-Left)

**Purpose**: Manage the raid member list and save specs

#### Button: "Refresh"
**Function**: `SS_ConfigSpecs_RefreshRaid()`
**What it does**:
1. Clears `SS_ConfigSpecs_RaidMembers` table
2. Scans raid using `GetNumRaidMembers()` and `GetRaidRosterInfo()`
3. Builds member list: `{name, class, originalIndex}`
4. Sorts by class order, then alphabetically
5. Resets scroll to top
6. Updates display
7. Prints: "Loaded X raid members"

**When to use**: 
- When raid composition changes
- When players join/leave
- Before saving specs

#### Button: "Save Guild Specs"
**Function**: `SS_ConfigSpecs_SaveGuildSpecs()` (wrapper for `SS_ConfigSpecs_Save()`)
**What it does**:
1. Loops through all players in `SS_ConfigSpecs_SelectedSpecs`
2. Copies spec assignments to `SS_GuildSpecsDB` (SavedVariables)
3. Data persists across sessions
4. Prints: "Saved X player specs to guild database"

**When to use**:
- After assigning specs to raid members
- Before logging out
- To create permanent spec assignments

**SavedVariables format**: `SS_GuildSpecsDB = {["PlayerName"] = specIndex}`

### PANEL 2: RAID LIST (Right-Side, Large)

**Purpose**: Show all raid members with spec dropdowns

**Display**: Scrollable list showing:
- Player name (color-coded by class)
- Spec dropdown buttons (one per available spec for that class)

#### Spec Buttons (Dynamically Created)
**Function**: `SS_ConfigSpecs_SelectSpec(playerName, specIndex)`
**What it does**:
1. Sets `SS_ConfigSpecs_SelectedSpecs[playerName] = specIndex`
2. Updates button highlights (selected = locked highlight)
3. Does NOT automatically save to database (must click Save button)

**Technical details**:
- Buttons created in `SS_ConfigSpecs_CreateSpecButtons()`
- Each row has 2-5 buttons depending on class
- Button text shows spec name (e.g., "DPS", "Tank", "Holy")
- Specs defined in `SS_ConfigSpecs_ClassSpecs[className]`

**Available specs per class**:
- Warrior: DPS, Tank
- Paladin: Retri, Holy, Tank
- Hunter: Surv, MM
- Shaman: EnhDPS, Ele (Nat), Ele (Fire), Resto, EnhTank
- Rogue: DPS
- Druid: Cat, Owl, Tree, Bear
- Priest: Disc, Shadow, Holy
- Warlock: Shadow, Fire
- Mage: Arcane, Fire, Frost

#### Auto-Load Behavior
**Function**: `SS_ConfigSpecs_AutoLoadSavedSpecs()`
**What it does**:
- Automatically called when Tab 5 is first opened
- Loads specs from `SS_GuildSpecsDB` for raid members
- Only applies to players WITHOUT already-assigned specs
- Allows manual overrides to persist during session

#### Scroll Up/Down Buttons
**Function**: `SS_Tab5_ScrollUp()` and `SS_Tab5_ScrollDown()`
**What it does**:
- Scrolls through raid member list (25 visible rows at a time)
- Increments by 3 rows per click

---

## TAB 6: CONFIG CONSUMES (CONSUME CONFIGURATION)

This tab configures which consumables each spec needs for each raid.

### PANEL 1: CONTROL BUTTONS (Top-Left)

**Purpose**: Manage spec selection and save/load configurations

#### Spec Buttons (Dynamically Created)
**Function**: `SS_ConsumeConfig_SelectSpec(specName)`
**What it does**:
1. Saves current UI state to working memory
2. Sets `SS_ConsumeConfig_CurrentSpec = specName`
3. Loads that spec's config from working memory
4. Updates consume checkboxes display
5. Updates "Any X" checkbox states
6. Highlights selected spec button

**Technical details**:
- Creates ~36 spec buttons (all class specs combined)
- Button names: SS_Tab6_SpecButton1 through SS_Tab6_SpecButton[N]
- Only shows specs for current raid instance
- Buttons arranged in grid: 3 columns

#### Checkbox: "Show All"
**Function**: `SS_ConsumeConfig_ShowAllCheckbox_OnClick()`
**What it does**:
- Toggles `SS_ConsumeConfig_ShowAll` (true/false)
- When checked: Shows all 70+ consumables
- When unchecked: Filters to only show consumables relevant to current spec's role
- Resets scroll to top
- Useful for quickly seeing spec-appropriate options

**Role filtering logic**:
- Gets spec's role from `SS_ConsumeConfig_SpecRoles[specName]`
- Shows only consumables with matching role in `SS_ConsumeData_ItemRoles`
- Example: WarriorDPS (Physical) sees flasks, melee elixirs, physical food, but not caster items

#### Checkboxes: "Any X Consume" (1, 2, 3, 4)
**Function**: `SS_ConsumeConfig_MinRequiredCheckbox_OnClick(checkboxNum)`
**What it does**:
- Mutually exclusive selection (only one can be checked)
- Sets `SS_ConsumeConfig_MinRequired` to selected number (or 0 if none)
- Allows "any X out of Y" requirement instead of "all"
- Example: Check "Any 1" for elixir slots = player needs at least 1 of 4 elixirs
- Immediately saves to working memory

**Use case example**:
- Elixir Slot 1 has 4 options: Mongoose, Giants, Fortitude, Superior Defense
- Check "Any 1": Player needs ANY ONE of these (pass if they have 1+)
- Uncheck: Player needs ALL FOUR (almost never used)

#### Button: "Save"
**Function**: `SS_ConsumeConfig_Save()`
**What it does**:
1. Saves current UI state to working memory first
2. Copies ENTIRE working memory to `SS_ConsumeConfigDB` (SavedVariables)
3. Persists across sessions/reloads
4. Prints: "Saved X specs to SavedVariables"

**What gets saved**:
- All checked consumables for all specs in all raids
- All "Any X" settings
- Format: `DB[raid][spec] = {consumes={name=true}, minRequired=X}`

#### Button: "Load"
**Function**: `SS_ConsumeConfig_Load()`
**What it does**:
1. Clears working memory
2. Copies ALL data from `SS_ConsumeConfigDB` to working memory
3. Reloads current spec display
4. Prints: "Loaded X specs from SavedVariables"

**When to use**:
- After making changes and want to revert
- After editing SavedVariables file manually
- To restore last saved state

#### Button: "Delete"
**Function**: `SS_ConsumeConfig_Delete()`
**What it does**:
1. Removes ONLY current spec from working memory
2. Clears all checkboxes
3. Resets "Any X" to 0
4. Does NOT delete from SavedVariables until Save is clicked
5. Prints: "Deleted [spec] from working memory"

**When to use**:
- To remove a spec configuration completely
- To start fresh with a spec

#### Button: "Load Presets"
**Function**: `SS_ConsumeConfig_LoadPresets()`
**What it does**:
1. Clears entire working memory
2. Loads default presets from `SS_ConsumePresets`
3. Parses compact format strings (ConsumePresets.lua)
4. Populates working memory with 100+ pre-configured specs
5. Reloads current spec display
6. Prints: "Loaded presets (X specs)"

**When to use**:
- First time setup
- To restore default recommended configurations
- After deleting everything

**Preset format** (internal):
```
"MC|WarriorDPS|2,10,11,13,14,27,28|any1"
Raid | Spec | ConsumeIDs | MinRequired
```

### PANEL 2: CONSUME LIST (Right-Side, Large)

**Purpose**: Show all consumables with checkboxes to enable/disable

**Display**: Scrollable list organized by category:
1. Flasks (4 items)
2. Worldbuffs (5 items)
3. Elixirs (12 items)
4. Food (10 items)
5. Alcohol (3 items)
6. Other (4 items)

#### Consume Checkboxes (Dynamically Created)
**Function**: `SS_ConsumeConfig_CheckboxClicked(consumeName)`
**What it does**:
1. Toggles `SS_ConsumeConfig_CheckedConsumes[consumeName]` (true/false)
2. Does NOT immediately save to working memory (saves on spec switch or Save button)
3. Updates checkbox state

**Technical details**:
- Creates 70+ checkboxes dynamically
- Checkbox names: SS_Tab6_ConsumeCheckbox1 through SS_Tab6_ConsumeCheckbox[N]
- 24 visible rows at a time
- Each row: [Checkbox] Consume Name (ID: X) ← ID only shows in debug mode

#### Scroll Up/Down Buttons
**Function**: `SS_ConsumeConfig_ScrollUp()` and `SS_ConsumeConfig_ScrollDown()`
**What it does**:
- Scrolls through consume list (24 visible at a time)
- Increments by 3 rows per click
- Handles category headers (don't count as rows)

### WORKING MEMORY vs SAVED VARIABLES

**Working Memory** (`SS_ConsumeConfig_WorkingMemory`):
- In-session only (lost on reload)
- All edits go here first
- Used by Tab 1 for consume checking
- Fast to read/write

**SavedVariables** (`SS_ConsumeConfigDB`):
- Persisted in WTF folder
- Survives reload/logout
- Only updated when "Save" button clicked
- Auto-loads on addon start

**Workflow**:
1. User opens Tab 6
2. Auto-loads from SavedVariables to working memory (once per session)
3. User makes changes (checks/unchecks boxes, changes specs)
4. Changes stored in working memory only
5. User clicks "Save" → copies working memory to SavedVariables
6. On next login: SavedVariables → working memory

### AUTO-LOAD BEHAVIOR

**Function**: `SS_ConsumeConfig_AutoLoad()`
**When**: Automatically called once after addon loads
**What it does**:
1. Checks `SS_ConsumeConfigLoadedThisSession` flag
2. If 0 (not loaded yet):
   - Copies `SS_ConsumeConfigDB` to working memory
   - Sets flag to 1
   - Prints: "Auto-loaded X specs from SavedVariables"
3. If 1 (already loaded): Does nothing

**Why**: Prevents re-loading every time Tab 6 is opened, which would lose unsaved changes

---

## DATA FLOW DIAGRAMS

### Consume Check Flow (Tab 1 → Tab 5 → Tab 6)

```
User clicks "Check Consumes" on Tab 1
    ↓
SS_Tab1_RefreshAndCheckAll()
    ↓
Refreshes Tab 5 raid list (gets player names/classes)
    ↓
Auto-loads specs from SS_GuildSpecsDB (Tab 5 saves)
    ↓
For each player:
    ↓
    Gets spec from Tab 5: SS_Check_GetPlayerSpec(name)
        → Checks SS_ConfigSpecs_SelectedSpecs (session)
        → Falls back to SS_GuildSpecsDB (saved)
    ↓
    Gets required consumes from Tab 6: SS_Check_GetRequiredConsumes(raid, spec)
        → Reads SS_ConsumeConfig_WorkingMemory[raid][spec]
    ↓
    Scans player buffs: UnitBuff("raidN", 1-32)
    ↓
    Matches buffs to consume names
    ↓
    Compares found vs required (handles groups, "Any X")
    ↓
    Returns: {found, required, missing, passed}
    ↓
Merges all results + buff check
    ↓
Displays in Tab 1 raid list (green/red)
```

### Spec Assignment Flow (Tab 5)

```
User opens Tab 5
    ↓
Auto-loads if first time: SS_ConfigSpecs_AutoLoad()
    → Checks SS_SpecsLoadedThisSession flag
    → If 0: Load from SS_GuildSpecsDB
    ↓
User clicks "Refresh"
    ↓
Scans raid: GetRaidRosterInfo(1-40)
    → Builds SS_ConfigSpecs_RaidMembers
    ↓
User clicks spec button for a player
    ↓
SS_ConfigSpecs_SelectSpec(name, specIndex)
    → Stores in SS_ConfigSpecs_SelectedSpecs (session only)
    ↓
User clicks "Save Guild Specs"
    ↓
SS_ConfigSpecs_Save()
    → Copies SS_ConfigSpecs_SelectedSpecs to SS_GuildSpecsDB
    → Writes to WTF/Account/[Name]/SavedVariables/SlackSpotter.lua
```

### Consume Config Flow (Tab 6)

```
User opens Tab 6
    ↓
Auto-loads if first time: SS_ConsumeConfig_AutoLoad()
    → Checks SS_ConsumeConfigLoadedThisSession flag
    → If 0: Copy SS_ConsumeConfigDB to SS_ConsumeConfig_WorkingMemory
    ↓
User selects raid (right tabs)
    ↓
Updates spec button list for that raid
    ↓
User selects spec (left buttons)
    ↓
SS_ConsumeConfig_SelectSpec(specName)
    → Saves current spec to working memory first
    → Loads new spec from working memory
    → Updates checkboxes
    ↓
User checks/unchecks consumes
    → Stores in SS_ConsumeConfig_CheckedConsumes (UI state)
    ↓
User selects "Any X" checkbox
    → Stores in SS_ConsumeConfig_MinRequired
    ↓
User clicks "Save"
    ↓
SS_ConsumeConfig_Save()
    → Saves current UI to working memory first
    → Copies entire working memory to SS_ConsumeConfigDB
    → Writes to SavedVariables file
```

---

## SLASH COMMANDS

### /ss
**Function**: `SS_Command("")`
**What it does**: Toggles main window (show/hide)

### /ss help
**Function**: `SS_ShowHelp()`
**What it does**: Shows help text in chat

### /ss [channel] [color] [message]
**Function**: Handled by `SS_Shoutouts_HandleCommand(args)`
**What it does**: Sends colored message to channel
**Example**: `/ss raid red Pull now!`

---

## MINIMAP BUTTON BEHAVIOR

### Left Click
**Function**: `SS_ToggleFrame()`
**What it does**: Show/hide main window

### Tooltip
Shows:
- "SlackSpotter"
- "Click to toggle addon"
- When holding Shift: "Hold Shift for advanced options"

### Positioning
- Default: Top-left of minimap (-15, 15)
- Can be adjusted in code for pfUI compatibility

---

## COMMON USER WORKFLOWS

### First-Time Setup

1. Install addon
2. Type `/ss` to open window
3. Go to Tab 6 (Config Consumes)
4. Click "Load Presets" (loads default configs for all specs)
5. Click "Save" (saves to your SavedVariables)
6. Go to Tab 5 (Config Specs)
7. Click "Refresh" (loads raid members)
8. Assign specs to all players by clicking spec buttons
9. Click "Save Guild Specs"
10. Go to Tab 1 (Overview)
11. Select raid instance (right tabs)
12. Click "Check Consumes"

### Pre-Raid Check

1. Open addon (`/ss`)
2. Ensure correct raid selected (right tabs)
3. Tab 5: Click "Refresh" (updates raid roster)
4. Tab 1: Click "Check Consumes"
5. Review red/green results in raid list
6. Click "Announce to Raid" to send results

### Sending Countdown

1. Open addon
2. Go to Tab 2 (Shoutouts)
3. Select channel (usually RAID)
4. Select color (usually red or orange)
5. Type "Before" message: "Pull in..."
6. Set countdown seconds: 8
7. Set interval: 2
8. Type "After" message: "GO GO GO!"
9. Click "Start Countdown"

### Viewing Boss Tactics

1. Open addon
2. Go to Tab 4 (Tactics)
3. Select raid (right tabs)
4. Click boss button (top panel)
5. Click role button (middle panel) - usually "Tanks"
6. Read strategy in bottom panel

---

## TECHNICAL NOTES FOR DEVELOPERS

### Event System
- Single frame handles all events: `SS_EventFrame`
- ADDON_LOADED: Initializes all modules once
- PLAYER_ENTERING_WORLD: Creates boss buttons (after UI fully loaded)
- Prevents double-init with `SlackSpotter_Initialized` flag

### Tab System
- 6 tabs use template "SS_TabTemplate"
- Each calls `SS_SelectTab(N)` on click
- Function hides all panels, shows selected panels
- Tab alpha: 0.6 inactive, 1.0 active

### Raid Tab System
- 10 raid tabs use template "SS_RaidTabTemplate"
- Each calls `SS_SelectRaid("Name")` on click
- Syncs to Tab 4 (tactics) and Tab 6 (consume config)
- Highlight uses LockHighlight()/UnlockHighlight()

### Dynamic Button Creation
- Spec buttons (Tab 5): Created per row, based on class
- Boss buttons (Tab 4): Created on PLAYER_ENTERING_WORLD
- Consume checkboxes (Tab 6): Created dynamically, 24 visible

### Scroll Implementation
- All scrollable lists use offset + max visible rows
- Scroll by 3 rows per click (configurable)
- Bounds checking prevents scroll past edges
- Redraws visible rows only (performance)

### Color Code Format
- Standard: `|cffRRGGBB` + text + `|r`
- RR/GG/BB: Hex values 00-FF for red/green/blue
- Example: `|cffff0000Red Text|r`

### SavedVariables Structure
```lua
SS_ShoutoutsDB = {
    lastChannel = "RAID",
    lastColor = "red",
    lastWhisperTarget = "PlayerName"
}

SS_GuildSpecsDB = {
    ["PlayerName1"] = 1,  -- specIndex
    ["PlayerName2"] = 2
}

SS_ConsumeConfigDB = {
    ["Kara40"] = {
        ["WarriorDPS"] = {
            consumes = {
                ["Flask of the Titans"] = true,
                ["Elixir of the Mongoose"] = true
            },
            minRequired = 0  -- or 1-4 for "Any X"
        }
    }
}
```

### Memory Management
- Working memory tables cleared/rebuilt as needed
- Scroll offsets reset on refresh
- Old button references reused (not recreated)
- Session flags prevent double-loading

### Namespace Protection
- All functions prefixed with `SS_`
- All globals prefixed with `SS_`
- Module-specific prefixes: `SS_Shoutouts_`, `SS_Tactics_`, etc.

---

## TROUBLESHOOTING UI ISSUES

### Button not responding
- Check if correct tab is active
- Verify function exists in .lua file
- Check for Lua errors (`/console scriptErrors 1`)

### Checkboxes not saving
- Tab 5: Must click "Save Guild Specs"
- Tab 6: Must click "Save" after changes
- Check SavedVariables file exists

### Raid list shows no players
- Tab 1: Click "Check Consumes" to populate
- Tab 5: Click "Refresh" to load raid

### Spec buttons not showing
- Tab 5: Player must be in raid and scanned via "Refresh"
- Tab 6: Must select raid instance first (right tabs)

### Countdown not sending
- Verify channel (must be in raid for RAID channel)
- Check for running countdown (blocks multiple)
- Verify target for whispers

### Scroll not working
- Check if enough items to scroll
- Verify scroll offset not at bounds
- Try clicking scroll buttons multiple times

---

END OF UI DOCUMENTATION


# SLACKSPOTTER - COMPLETE REFERENCE

All functions, variables, and mapping tables organized by file.
Prefix `SS_` = SlackSpotter namespace

---

## GLOBAL VARIABLES

### Main State
- `SlackSpotter_Initialized` - Prevents double-init (false/true)
- `SS_CurrentTab` - Active tab number (1-6)
- `SS_DebugMode` - Debug mode on/off (false/true)

### Raid Selection
- `SS_RaidBuffs_Selected` - Table: {Thorns, ShadowProtection, EmeraldBlessing} = boolean
- `SS_ListEveryoneProtection` - Show all players for protection potions (false/true)

---

## SLACKSPOTTER.LUA (Main File)

### Initialization
- `SS_InitializeFrame()` - Setup main frame, dragging, alpha, tabs
- `SS_EventFrame` - Event handler frame (ADDON_LOADED, PLAYER_ENTERING_WORLD)

### Frame Control
- `SS_ToggleFrame()` - Show/hide main window
- `SS_CreateMinimapButton()` - Create minimap icon

### Tab System
- `SS_SelectTab(tabNum)` - Switch to tab 1-6, show/hide panels
- `SS_UpdateRaidTabHighlights()` - Update raid tab button highlights
- `SS_HideAllTabContent()` - Hide all tab panels
- `SS_ShowTab1Content()` - Show Tab 1 panels

### Raid Selection
- `SS_SelectRaid(raidName)` - Set active raid instance (Kara40, MC, etc.)

### Tab 1 Functions
- `SS_Tab1_RaidBuffCheckPanel_ThornsCheckbox_OnClick()` - Toggle Thorns check
- `SS_Tab1_RaidBuffCheckPanel_ShadowProtCheckbox_OnClick()` - Toggle Shadow Prot
- `SS_Tab1_RaidBuffCheckPanel_EmeraldBlessCheckbox_OnClick()` - Toggle Emerald Bless
- `SS_Tab1_RaidBuffCheckPanel_RaidBuffCheckButton_OnClick()` - Run buff check
- `SS_Tab1_ProtectionPotionPanel_ListEveryoneCheckbox_OnClick()` - Toggle list mode
- `SS_Tab1_ProtectionPotionPanel_CheckButton_OnClick()` - Check protection potions
- `SS_Tab1_ConsumeButtonCheckPanel_CheckButton_OnClick()` - Check consumes
- `SS_Tab1_ConsumeButtonCheckPanel_AnnounceButton_OnClick()` - Announce results
- `SS_Tab1_StatsPanel_RepPlusButton_OnClick()` - Announce high performers
- `SS_Tab1_StatsPanel_RepMinusButton_OnClick()` - Announce low performers
- `SS_Tab1_StatsPanel_ResetButton_OnClick()` - Reset stats
- `SS_Tab1_RefreshAndCheckAll()` - Run both consume and buff check
- `SS_Tab1_UpdateInfoLabels()` - Update stats display

### Debug
- `SS_Debug_Toggle()` - Toggle debug mode

### Commands
- `SS_Command(msg)` - Slash command handler (/ss)
- `SS_ShowHelp()` - Display help text

---

## MAPPINGDATA.LUA (Lookups & Mappings)

### Class Colors
- `SS_ClassColors` - Table: [CLASS] = {r, g, b} (0-1 range)
- `SS_GetColoredName(playerName, class)` - Returns colored player name string

### Spec Type Checks
- `SS_ManaUsingSpecs` - Table: [specName] = true (needs Int/Spirit buffs)
- `SS_IsManaUser(specName)` - Returns true if spec uses mana
- `SS_InnerFireSpecs` - Table: Priest specs needing Inner Fire
- `SS_NeedsInnerFire(specName)` - Returns true if needs Inner Fire
- `SS_TrueshotAuraSpecs` - Table: Hunter specs needing Trueshot
- `SS_NeedsTrueshotAura(specName)` - Returns true if needs Trueshot

### Consume Names
- `SS_ConsumeShortNames` - Table: [fullName] = shortName for announcements

### Initialization
- `SS_MappingData_Initialize()` - Load message

---

## CONSUMEDATA.LUA (Item Definitions)

### Consume Categories
- `SS_ConsumeData_Categories` - Array of category names (order matters)
  - "Flasks", "Worldbuffs", "Elixirs", "Food", "Alcohol", "Other"

### Consume to Role Mapping
- `SS_ConsumeData_ItemRoles` - Table: [consumeName] = {roleArray}
  - Roles: "Physical", "Tanks", "Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost", "PhysRanged"

### Consume Groups (Mutually Exclusive)
- `SS_ConsumeData_Groups` - Array of tables: {groupName, consumes={...}}
  - Groups: "Flask", "Elixir Slot 1", "Elixir Slot 2", "Food", "Alcohol"

### ID Mapping (for Presets)
- `SS_ConsumeData_IDMapping` - Table: [numericID] = consumeName
- `SS_ConsumeData_NameToID` - Table: [consumeName] = numericID

---

## CONSUMEPRESETS.LUA (Default Configs)

### Preset Data
- `SS_ConsumePresets_Compact` - Array of strings: "Raid|Spec|ID1,ID2|anyX"
  - Format: Raid instance, Spec name, Consume IDs (comma-separated), minRequired
  - Example: "MC|WarriorDPS|2,10,11,13,14|any1"

### Parsed Presets
- `SS_ConsumePresets` - Table: [raidName][specName] = {consumes={}, minRequired=X}

### Functions
- `SS_ConsumePresets_Parse()` - Convert compact strings to full table structure

---

## CONFIGSPECS.LUA (Tab 5 - Spec Assignment)

### SavedVariables
- `SS_GuildSpecsDB` - Table: [playerName] = specIndex (persistent)

### Working Memory
- `SS_ConfigSpecs_RaidMembers` - Array: {name, class, originalIndex}
- `SS_ConfigSpecs_SelectedSpecs` - Table: [playerName] = specIndex (session only)
- `SS_ConfigSpecs_ScrollOffset` - Scroll position
- `SS_ConfigSpecs_MaxVisibleRows` - 25
- `SS_ConfigSpecs_RowHeight` - 20
- `SS_SpecsLoadedThisSession` - Load flag (0/1)

### Definitions
- `SS_ConfigSpecs_ClassSpecs` - Table: [className] = {spec1, spec2, ...}
- `SS_ConfigSpecs_ClassColors` - Table: [className] = colorCode

### Functions
- `SS_ConfigSpecs_Initialize()` - Load message
- `SS_ConfigSpecs_ProperCase(str)` - WARRIOR -> Warrior
- `SS_ConfigSpecs_RefreshRaid()` - Scan raid, build member list
- `SS_ConfigSpecs_AutoLoadSavedSpecs()` - Apply saved specs to new players
- `SS_ConfigSpecs_UpdateDisplay()` - Render visible rows
- `SS_ConfigSpecs_UpdateRow(rowIndex, memberData)` - Render single row
- `SS_ConfigSpecs_CreateSpecButtons(row, member)` - Create spec dropdowns
- `SS_ConfigSpecs_SelectSpec(playerName, specIndex)` - Assign spec to player
- `SS_ConfigSpecs_Save()` - Write to SS_GuildSpecsDB
- `SS_ConfigSpecs_ScrollUp()` - Scroll up 3 rows
- `SS_ConfigSpecs_ScrollDown()` - Scroll down 3 rows
- `SS_Tab5_ScrollUp()` - Alias for scroll up
- `SS_Tab5_ScrollDown()` - Alias for scroll down

---

## CONSUMECONFIG.LUA (Tab 6 - Consume Setup)

### SavedVariables
- `SS_ConsumeConfigDB` - Table: [raid][spec] = {consumes={}, minRequired=X}

### Working Memory
- `SS_ConsumeConfig_CurrentRaid` - Selected raid (default "Kara40")
- `SS_ConsumeConfig_CurrentSpec` - Selected spec (default "WarriorDPS")
- `SS_ConsumeConfig_WorkingMemory` - Session table (same structure as DB)
- `SS_ConsumeConfig_CheckedConsumes` - Table: [consumeName] = boolean (UI state)
- `SS_ConsumeConfig_MinRequired` - Selected "Any X" value (0-4)
- `SS_ConsumeConfig_ShowAll` - Show all or filter by role (false/true)
- `SS_ConsumeConfig_ScrollOffset` - Scroll position
- `SS_ConsumeConfig_MaxVisibleRows` - 24
- `SS_ConsumeConfig_RowHeight` - 18
- `SS_ConsumeConfigLoadedThisSession` - Load flag (0/1)

### Spec-to-Role Mapping
- `SS_ConsumeConfig_SpecRoles` - Table: [specName] = roleName

### Functions
- `SS_ConsumeConfig_Initialize()` - Load message
- `SS_ConsumeConfig_UpdateSpecButtons()` - Render spec list for current raid
- `SS_ConsumeConfig_SelectSpec(specName)` - Switch to spec, load data
- `SS_ConsumeConfig_LoadSpecData()` - Load spec config from working memory
- `SS_ConsumeConfig_SaveCurrentSpecToMemory()` - Save UI state to memory
- `SS_ConsumeConfig_UpdateDisplay()` - Render consume checkboxes
- `SS_ConsumeConfig_UpdateRow(rowIndex, consumeName, category)` - Render single checkbox
- `SS_ConsumeConfig_CheckboxClicked(consumeName)` - Toggle consume checkbox
- `SS_ConsumeConfig_UpdateMinRequiredCheckboxes()` - Update "Any X" checkboxes
- `SS_ConsumeConfig_ScrollUp()` - Scroll up 3 rows
- `SS_ConsumeConfig_ScrollDown()` - Scroll down 3 rows
- `SS_ConsumeConfig_ShowAllCheckbox_OnClick()` - Toggle show all/filtered
- `SS_ConsumeConfig_MinRequiredCheckbox_OnClick(num)` - Select "Any X"
- `SS_ConsumeConfig_Save()` - Write to SS_ConsumeConfigDB
- `SS_ConsumeConfig_Load()` - Load from SS_ConsumeConfigDB
- `SS_ConsumeConfig_Delete()` - Delete current spec from memory
- `SS_ConsumeConfig_LoadPresets()` - Load default presets into memory
- `SS_ConsumeConfig_AutoLoad()` - Auto-load on addon start

---

## CHECKCONSUMES.LUA (Consume Scanning)

### Functions
- `SS_Check_Initialize()` - Load message
- `SS_Check_CheckPlayer(playerName, raidInstance)` - Scan one player's buffs
- `SS_Check_GetPlayerBuffs(unitID)` - Returns table: [buffName] = true
- `SS_Check_ScanBuffsForConsumes(buffs)` - Match buffs to consume names
- `SS_Check_CompareWithRequired(detectedConsumes, requiredData)` - Calculate pass/fail
- `SS_Check_GetRequiredConsumes(raidInstance, specName)` - Get consume list from Tab 6
- `SS_Check_BuildConsumeGroups(consumeList)` - Group mutually exclusive items
- `SS_Check_GetPlayerSpec(playerName)` - Get spec from Tab 5
- `SS_Check_SpecIndexToName(playerName, specIndex)` - Convert index to full name
- `SS_Check_GetPlayerClass(playerName)` - Get class from raid roster
- `SS_Check_CheckEntireRaid(raidInstance)` - Scan all players
  - Returns: [playerName] = {class, spec, found, required, missing, passed}

---

## RAIDBUFFCHECK.LUA (Buff Scanning)

### Buff Definitions
- `SS_RaidBuffs_Definitions` - Array of tables:
  - {name, buffNames, needsClass, appliesTo, personal, optional, groupCheck, tooltipCheck}

### Functions
- `SS_RaidBuff_Initialize()` - Load message
- `SS_RaidBuff_CheckEntireRaid()` - Scan all players for buffs
  - Returns: [playerName] = {class, spec, buffsFound, buffsRequired, missing}
- `SS_RaidBuff_GetClassPresence()` - Returns: [className] = {online=bool, count=num}
- `SS_RaidBuff_PlayerNeedsBuff(buffDef, playerName, class, spec)` - Check if player needs buff

---

## DISPLAYRAIDLIST.LUA (Tab 1 Display)

### Working Memory
- `SS_Display_RaidResults` - Table: [playerName] = {combined consume+buff data}
- `SS_Display_ScrollOffset` - Scroll position
- `SS_Display_MaxVisibleRows` - 25
- `SS_Display_RowHeight` - 20

### Functions
- `SS_Display_Initialize()` - Load message
- `SS_Display_UpdateRaidList()` - Render raid member table
- `SS_Display_RenderRow(row, memberData)` - Render single member row
- `SS_Tab1_ScrollUp()` - Scroll up 3 rows
- `SS_Tab1_ScrollDown()` - Scroll down 3 rows

---

## ANNOUNCEMENTS.LUA (Result Output)

### Variables
- `SS_Announce_Channel` - Output channel (default "RAID")

### Functions
- `SS_Announce_Initialize()` - Load message
- `SS_Announce_SetChannel(channel)` - Set output channel
- `SS_Announce_Output(message)` - Send message to channel
- `SS_ConsumeAnnounce_Format(raidResults)` - Format consume results
  - Returns: {missingPlayers, noSpecPlayers}
- `SS_ConsumeAnnounce_Send(raidResults)` - Announce missing consumes
- `SS_RaidBuffAnnounce_Format(raidResults)` - Format buff results
  - Returns: {raidBuffsMissing, personalBuffsMissing}
- `SS_RaidBuffAnnounce_Send(raidResults)` - Announce missing buffs

---

## SHOUTOUTS.LUA (Tab 2 - Colored Messages)

### SavedVariables
- `SS_ShoutoutsDB` - Table: {lastChannel, lastColor, lastWhisperTarget}

### Working Memory
- `SS_Shoutouts_SelectedChannel` - Active channel (default "RAID")
- `SS_Shoutouts_SelectedColor` - Active color (default "red")
- `SS_Shoutouts_WhisperTarget` - Whisper recipient name
- `SS_Shoutouts_CountdownEnabled` - Countdown checkbox (false/true)
- `SS_Shoutouts_CountdownSeconds` - Countdown length (default 8)
- `SS_Shoutouts_CountdownInterval` - Tick interval (default 2)
- `SS_Shoutouts_CountdownActive` - Countdown running (false/true)

### Color Definitions
- `SS_Shoutouts_Colors` - Table: [colorName] = hexCode
- `SS_Shoutouts_RainbowColors` - Array: rainbow hex codes

### Limits
- `SS_Shoutouts_NormalLimit` - 243 characters
- `SS_Shoutouts_RainbowLimit` - 19 letters (separate space limit: 8)

### Functions
- `SS_Shoutouts_Initialize()` - Load saved settings
- `SS_Shoutouts_ShowTab()` - Show Tab 2 panels
- `SS_Shoutouts_CreateChannelButtons()` - Create channel buttons
- `SS_Shoutouts_CreateColorButtons()` - Create color buttons
- `SS_Shoutouts_SelectChannel(channel)` - Set channel
- `SS_Shoutouts_UpdateChannelButtons()` - Update button highlights
- `SS_Shoutouts_UpdateWhisperTargetVisibility()` - Show/hide whisper box
- `SS_Shoutouts_SelectColor(color)` - Set color
- `SS_Shoutouts_UpdateColorButtons()` - Update button highlights
- `SS_Shoutouts_UpdateCharCounter()` - Update character counter display
- `SS_Shoutouts_UpdateCountdownCounters()` - Update countdown message counters
- `SS_Shoutouts_SendButton_OnClick()` - Validate and send message
- `SS_Shoutouts_ColorizeMessage(message)` - Apply color codes
- `SS_Shoutouts_RainbowText(text)` - Apply rainbow colors
- `SS_Shoutouts_SendToChannel(message)` - Send to channel
- `SS_Shoutouts_CountdownCheckbox_OnClick()` - Toggle countdown
- `SS_Shoutouts_StartCountdown()` - Begin countdown sequence
- `SS_Shoutouts_CountdownTick(remaining, afterMsg, interval)` - Countdown loop
- `SS_ScheduleTimer(func, delay)` - Execute function after delay
- `SS_Shoutouts_HandleCommand(args)` - Parse slash command

---

## SS_TACTICSDATA.LUA (Boss Info)

### Boss Order
- `SS_Tactics_BossOrder` - Table: [raidName] = {boss1, boss2, ...}

### Strategy Data
- `SS_Tactics_Strategies` - Table: [raidName][bossName][roleName] = strategyText

### Trash Encounters
- `SS_Tactics_TrashEncounters` - Table: [raidName] = {trash1, trash2, ...}

### Role Order
- `SS_Tactics_RoleOrder` - Array: {"Tanks", "Healer", ...}

---

## SS_TACTICS.LUA (Tab 4 - Tactics Display)

### Working Memory
- `SS_Tactics_CurrentRaid` - Selected raid (default "Kara40")
- `SS_Tactics_SelectedBoss` - Selected boss name
- `SS_Tactics_SelectedRole` - Selected role (default "Tanks")
- `SS_Tactics_ViewMode` - "boss" or "trash"

### Functions
- `SS_Tactics_Initialize()` - Load message
- `SS_Tactics_SyncRaidSelection(raidName)` - Update when raid changes
- `SS_Tactics_ShowTab()` - Show Tab 4 panels
- `SS_Tactics_UpdateInstanceLabel()` - Update raid name display
- `SS_Tactics_CreateBossButtons()` - Create boss buttons (called on PLAYER_ENTERING_WORLD)
- `SS_Tactics_UpdateBossButtons()` - Update boss button highlights
- `SS_Tactics_SelectBoss(bossName)` - Select boss, load strategy
- `SS_Tactics_CreateTrashButtons()` - Create trash buttons
- `SS_Tactics_UpdateTrashButtons()` - Update trash button highlights
- `SS_Tactics_SelectTrash(trashName)` - Select trash encounter
- `SS_Tactics_CreateRoleButtons()` - Create role buttons
- `SS_Tactics_UpdateRoleButtons()` - Update role button highlights
- `SS_Tactics_SelectRole(roleName)` - Select role, load strategy
- `SS_Tactics_LoadStrategy()` - Display strategy text
- `SS_Tactics_SwitchView(mode)` - Switch between "boss" and "trash"

---

## COMMAND REFERENCE

### Slash Commands
- `/ss` - Toggle main window
- `/ss <channel> <color> <message>` - Send colored message (handled by Shoutouts module)

---

## SAVEDVARIABLES (Persistent Data)

### SS_ShoutoutsDB
- `lastChannel` - Last used channel
- `lastColor` - Last used color
- `lastWhisperTarget` - Last whisper recipient

### SS_GuildSpecsDB
- `[playerName] = specIndex` - Saved spec assignments

### SS_ConsumeConfigDB
- `[raidName][specName] = {consumes={}, minRequired=X}` - Saved consume configs

---

## COMMON PATTERNS

### Get Player in Raid
```lua
for i = 1, GetNumRaidMembers() do
    local name, _, _, _, class = GetRaidRosterInfo(i)
end
```

### Get Player Buffs
```lua
for i = 1, 32 do
    local buffName = UnitBuff("player", i)
    if not buffName then break end
end
```

### Scroll Pattern
```lua
if offset > 0 then
    offset = offset - 3
    if offset < 0 then offset = 0 end
end
```

### Table Iteration (Lua 5.0)
```lua
for key, value in pairs(table) do
    -- code
end

for i = 1, table.getn(array) do
    local item = array[i]
end
```

---

## FILE LOAD ORDER (from .toc)

1. SlackSpotter.xml (UI layout)
2. MappingData.lua
3. ConsumeData.lua
4. ConsumePresets.lua
5. ConfigSpecs.lua
6. ConsumeConfig.lua
7. CheckConsumes.lua
8. RaidBuffCheck.lua
9. DisplayRaidList.lua
10. Announcements.lua
11. Shoutouts.lua
12. SS_TacticsData.lua
13. SS_Tactics.lua
14. SlackSpotter.lua (main, loads last)

---

END OF REFERENCE