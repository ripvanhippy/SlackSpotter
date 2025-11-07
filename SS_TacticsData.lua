-- ============================================================================
-- SLACKSPOTTER - TACTICS DATA
-- Hardcoded boss strategies for all raids
-- Structure: SS_TacticsDB[RaidName][BossName][RoleName] = "strategy text"
-- ============================================================================

SS_TacticsDB = {}

-- ============================================================================
-- MOLTEN CORE
-- ============================================================================
SS_TacticsDB["MC"] = {
    ["Lucifron"] = {
        ["Tanks"] = "Tank Lucifron north. Pick up adds immediately when they spawn. Keep adds separated from boss to prevent healing.",
        ["Healer"] = "Dispel Lucifron's Curse immediately - it increases fire damage taken. Priests dispel Impending Doom (magic debuff). Spread out to avoid chain damage.",
        ["Caster DPS"] = "DPS adds first, then boss. Watch threat - Lucifron hits hard. Mages decurse if needed.",
        ["Phys DPS"] = "Kill adds when they spawn. Stay behind boss. Watch for Impending Doom stun - move away from raid.",
        ["Special 1"] = "Assign 2-3 decursers. Warlocks banish one add if needed. Main tank needs Shadow Protection Potion.",
		["Special 2"] = ""
    },
    ["Magmadar"] = {
        ["Tanks"] = "Face boss away from raid. Coordinate fear immunity - use Berserker Rage, Tremor Totem, or Fear Ward. Tank swap if feared.",
        ["Healer"] = "Heal through Panic (raid fear every 30s). Druids remove Frenzy with Tranquilizing Shot immediately.",
        ["Caster DPS"] = "Hunters: Tranquilizing Shot rotation on Frenzy buff. Ranged DPS from max range to avoid lava spit.",
        ["Phys DPS"] = "Attack from behind. When feared, run towards walls not lava. Pop Living Action Potion if available.",
        ["Special 1"] = "Hunter tranq rotation: assign 3 hunters. Fear Ward main tank. Tremor totems in melee and ranged groups.",
		["Special 2"] = ""
    },
    ["Incindis"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
		["Special 2"] = ""
    },
	["Basalthar & Smoldaris"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
		["Special 2"] = ""
    },
	["Sorc-Thane Thaurissan"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
		["Special 2"] = ""
    },
    ["Garr"] = {
        ["Tanks"] = "Main tank holds Garr. Off-tanks each grab one add. Do NOT let adds die near each other - they explode and buff remaining adds.",
        ["Healer"] = "Dispel Magma Shackles (reduces healing received). Very heal-intensive fight. Spread mana between tanks.",
        ["Caster DPS"] = "Banish 2 adds (warlocks). Kill unbanished adds one by one, far from other adds. Do not AoE.",
        ["Phys DPS"] = "Focus fire called add. Move adds away from pack before killing. Expect to die to Separation Anxiety - combat res available.",
        ["Special 1"] = "8 off-tanks needed. 2 warlocks banish adds. Main tank needs heavy healing and Fire Protection Potion.",
		["Special 2"] = ""
    },
    ["Shazzrah"] = {
        ["Tanks"] = "Tank in center. When Shazzrah blinks, he resets threat - be ready to pick him up fast. Face away from raid.",
        ["Healer"] = "Shazzrah blinks every 30-45s and AoEs - heal through it. Dispel Shazzrah's Curse (increases arcane damage).",
        ["Caster DPS"] = "Nuke hard before blinks. Stop DPS at 45% threat - blink resets aggro. Decurse quickly.",
        ["Phys DPS"] = "Attack from behind. When he blinks, run out 10 yards to avoid AoE. Pop Arcane Protection Potion.",
        ["Special 1"] = "Assign decursers. Arcane Protection Potions strongly recommended. Call out blinks - everyone stack center after.",
		["Special 2"] = ""
    },
    ["Baron Geddon"] = {
        ["Tanks"] = "Tank in center of room. Be ready for Ignite Mana - it drains mana and explodes. Run out if you get Living Bomb.",
        ["Healer"] = "Watch for Living Bomb debuff - player must run FAR away (25 yards) before explosion. Heal tanks through Ignite Mana.",
        ["Caster DPS"] = "DPS from range. If you get Living Bomb, run to designated safe spot immediately. Call out 'BOMB ON ME' in voice.",
        ["Phys DPS"] = "Attack from behind. Run out fast if Living Bomb. Fire Protection Potions required.",
        ["Special 1"] = "Designate bomb run-out spots (4 corners). Fire Protection Potion mandatory. Main tank needs Greater Fire Protection Potion.",
		["Special 2"] = ""
    },
    ["Golemagg"] = {
        ["Tanks"] = "Main tank holds Golemagg in center. Two off-tanks grab the two Core Hounds. Keep dogs away from Golemagg - they enrage him.",
        ["Healer"] = "Heal dog tanks heavily - dogs hit hard and apply stacking DoT. Dispel Magma Splash if possible.",
        ["Caster DPS"] = "Kill dogs first. Focus fire one dog, then the other. After dogs dead, nuke Golemagg. Fire Protection Potions.",
        ["Phys DPS"] = "DPS dogs from behind. After dogs die, burn Golemagg. Pop Fire Protection Potions for Magma Splash.",
        ["Special 1"] = "3 tanks needed. Dog tanks need Fire Resistance gear. Do NOT kill dogs near Golemagg.",
		["Special 2"] = ""
    },
    ["Sulfuron Harbinger"] = {
        ["Tanks"] = "Tank Sulfuron and separate his 4 adds. Adds must die simultaneously - hold DPS at 10% on all.",
        ["Healer"] = "Heal through Inspire (adds buff each other). Priests can Mind Control an add for extra DPS.",
        ["Caster DPS"] = "AoE adds to 10%, then single-target to even them out. Kill all 4 adds within 10 seconds of each other.",
        ["Phys DPS"] = "Focus fire called add. Stop DPS at 10% and wait for all adds to be ready. Then burn all fast.",
        ["Special 1"] = "5 tanks needed (one per add + boss). Priests can Mind Control. Fire Protection Potions for everyone.",
		["Special 2"] = ""
    },
    ["Majordomo Executus"] = {
        ["Tanks"] = "Tank Majordomo in center. Off-tanks grab adds. Kill adds first - they heal Majordomo. Spread adds apart.",
        ["Healer"] = "Dispel Magic Shield on adds (absorbs 8000 damage). Heal through Damage Shield (reflects damage to attackers).",
        ["Caster DPS"] = "Kill healers first, then DPS adds. Focus fire one at a time. Watch threat - adds hit hard.",
        ["Phys DPS"] = "Focus called add. Healers die first priority. Pop health potions when Damage Shield is up.",
        ["Special 1"] = "9 tanks needed. Kill order: 4 healers → 4 adds → Majordomo. Dispel Magic Shield immediately.",
		["Special 2"] = ""
    },
    ["Ragnaros"] = {
        ["Tanks"] = "Tank Ragnaros facing away from raid. He submerges at 3min, 6min - kill adds during submerge. Taunt off tanks when knocked back.",
        ["Healer"] = "Heal through Lava Burst (heavy raid damage). Avoid Wrath of Ragnaros (knockback + weapon damage debuff). Stay spread for Hand of Ragnaros.",
        ["Caster DPS"] = "DPS Ragnaros. At submerge, kill Sons of Flame fast (they heal Ragnaros). Ranged kite sons away from melee.",
        ["Phys DPS"] = "Attack Ragnaros from behind. When he submerges, switch to Sons immediately. Greater Fire Protection Potion mandatory.",
        ["Special 1"] = "Everyone needs Greater Fire Protection Potion. Hunters kite sons. Tank rotation for knockbacks. Heal through lava burst waves.",
		["Special 2"] = ""
    }
}

-- ============================================================================
-- BLACKWING LAIR
-- ============================================================================
SS_TacticsDB["BWL"] = {
    ["Razorgore"] = {
        ["Tanks"] = "Phase 1: Hold adds away from orb controller. Rotate tanks on adds. Phase 2: Tank Razorgore, taunt swap on Conflagration stacks.",
        ["Healer"] = "Phase 1: Heal orb controller and add tanks. Dispel Fireball Volley. Phase 2: Heal through Conflagration stacks.",
        ["Caster DPS"] = "Phase 1: AoE adds, control spawns. Phase 2: Nuke Razorgore. Mind Control orb controller to destroy eggs faster.",
        ["Phys DPS"] = "Phase 1: Kill adds. Phase 2: DPS Razorgore from behind. Move out if targeted by Fireball Volley.",
        ["Special 1"] = "Orb controller (priest/warlock) destroys eggs. 4-5 tanks for add control. Phase 2: burn boss fast before Conflagration wipes raid.",
        ["Special 2"] = ""
    },
    ["Vaelastrasz"] = {
        ["Tanks"] = "Tank rotation every 15 seconds (Burning Adrenaline = 15s to live). 8+ tanks needed. Face boss away, move to next position fast.",
        ["Healer"] = "Spam heal tanks - they take massive damage. Healers will get Burning Adrenaline - DPS until death, battle res after.",
        ["Caster DPS"] = "Nuke hard. Everyone has infinite mana/energy. When you get Burning Adrenaline, you have 15s to DPS before death.",
        ["Phys DPS"] = "DPS from behind. Threat is extreme - watch Omen. Pop health potions on cooldown. Burning Adrenaline = 15s then you die.",
        ["Special 1"] = "8+ tank rotation. DPS race - 3 minute enrage. Accept deaths - save battle res for tanks/healers. Full consumables.",
        ["Special 2"] = ""
    },
    ["Broodlord Lashlayer"] = {
        ["Tanks"] = "Tank Broodlord at end of gauntlet. Hold aggro tight - Mortal Strike reduces healing. Taunt swap if needed.",
        ["Healer"] = "Heal through Mortal Strike (50% healing reduction). Suppression Room gauntlet is heal-intensive. Spread mana wisely.",
        ["Caster DPS"] = "Gauntlet: AoE packs. Boss: Nuke hard. Threat is not an issue - he does Blast Wave knockback resetting aggro.",
        ["Phys DPS"] = "Gauntlet: Kill suppression device dragonkin. Boss: DPS from behind, watch Mortal Strike on tanks.",
        ["Special 1"] = "Gauntlet is hardest part - clear packs slowly, destroy suppression devices. Boss is easy with proper tank rotation.",
        ["Special 2"] = ""
    },
    ["Firemaw"] = {
        ["Tanks"] = "Tank Firemaw facing away from raid. Move to safe spot during Wing Buffet (knockback). Rotate tanks to reset stacks.",
        ["Healer"] = "Heal through Flame Buffet (stacking fire DoT). Everyone takes raid damage. Los wing buffet behind pillars.",
        ["Caster DPS"] = "DPS from max range. Move behind pillars during Wing Buffet. Fire resist gear recommended (100+).",
        ["Phys DPS"] = "Attack from behind. Run to safe spot on Wing Buffet (knockback into whelp packs = death). Greater Fire Protection Potion mandatory.",
        ["Special 1"] = "Everyone needs 100+ fire resist. Greater Fire Protection Potions required. Positioning critical to avoid whelp packs.",
        ["Special 2"] = ""
    },
    ["Ebonroc"] = {
        ["Tanks"] = "Main tank only - Ebonroc stays on highest threat. Heal through Shadow of Ebonroc (self-heal buff on boss).",
        ["Healer"] = "Heal main tank heavily during Shadow of Ebonroc. Raid takes shadow DoT - spread healing to raid.",
        ["Caster DPS"] = "Nuke boss. No threat issues. Avoid standing in Wing Buffet.",
        ["Phys DPS"] = "DPS from behind. Watch for Wing Buffet knockback.",
        ["Special 1"] = "Easy fight. Single tank. No resistance needed. Burn fast before healer mana runs out.",
        ["Special 2"] = ""
    },
    ["Flamegor"] = {
        ["Tanks"] = "Tank Flamegor. Taunt immediately when Frenzy (attack speed buff) is active. Face away from raid.",
        ["Healer"] = "Heal through Frenzy - boss hits extremely fast. Dispel Shadow Flame DoT if possible.",
        ["Caster DPS"] = "Hunters: Tranquilizing Shot rotation on Frenzy immediately. Ranged DPS nuke hard.",
        ["Phys DPS"] = "DPS from behind. Greater Fire Protection Potion mandatory. Move out of Wing Buffet.",
        ["Special 1"] = "3 hunters on tranq rotation. Greater Fire Protection Potions. Tank swap on Frenzy if tranq fails.",
        ["Special 2"] = ""
    },
    ["Chromaggus"] = {
        ["Tanks"] = "Tank Chromaggus facing away. He has 5 random breaths (2 active per week). Coordinate tank cooldowns for heavy breath damage.",
        ["Healer"] = "Heal through double breath combos. Dispel Bronze Affliction (stun). Cure diseases/poisons as needed depending on breath combo.",
        ["Caster DPS"] = "DPS hard. Each breath applies stacking debuff - raid damage increases over time. Check weekly breath combo before pull.",
        ["Phys DPS"] = "Attack from behind. Move away from tank if Time Lapse (Bronze breath). Pop resist potions based on breath combo.",
        ["Special 1"] = "Breaths are random each week. Check breath combo: Frost/Arcane/Fire/Shadow/Nature. Adjust resist gear/potions accordingly.",
        ["Special 2"] = ""
    },
    ["Nefarian"] = {
        ["Tanks"] = "Phase 1: Tank adds. Phase 2: Tank Nefarian center, face away. Phase 3: Move boss to throne platform, tank skeletons.",
        ["Healer"] = "Phase 1: Heal through add damage. Phase 2: Dispel class calls (priests = healing debuff, warriors = broken weapons). Phase 3: AoE heal raid.",
        ["Caster DPS"] = "Phase 1: AoE drakonids. Phase 2: DPS Nefarian, handle class calls (mages = polymorph raid, hunters = broken bows). Phase 3: Nuke boss.",
        ["Phys DPS"] = "Phase 1: Kill drakonids. Phase 2: DPS boss from behind, watch class calls (rogues = teleport and AoE). Phase 3: Kill skeletons then boss.",
        ["Special 1"] = "Phase 2 class calls: Priests (healing -50%), Warriors (broken weapons), Rogues (teleport+AoE), Hunters (broken bows), Warlocks (infernals spawn), Mages (poly raid), Druids (cat form), Paladins (bomb). Onyxia Scale Cloak mandatory.",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- AQ40
-- ============================================================================
SS_TacticsDB["AQ40"] = {
    ["The Prophet Skeram"] = {
        ["Tanks"] = "Tank all 3 Skerams (real + 2 copies at 75%/50%). Mark kill order. True Teleport resets threat.",
        ["Healer"] = "Heal through Arcane Explosion. Dispel Mind Control immediately - MC'd players AoE the raid.",
        ["Caster DPS"] = "Kill Skerams evenly to 75%, then focus real one. Stop DPS when he splits. Arcane Protection Potions.",
        ["Phys DPS"] = "DPS called Skeram. When he teleports, reposition fast. Interrupt Mind Control with stuns if possible.",
        ["Special 1"] = "Mark real Skeram. Kill order: Real → Copy 1 → Copy 2. Save battle res for MC deaths. Arcane Protection Potions.",
        ["Special 2"] = ""
    },
    ["Silithid Royalty"] = {
        ["Tanks"] = "Tank all 3 bosses separately. Yauj (heal boss), Vem (tank boss), Kri (DPS boss). Never let them touch each other.",
        ["Healer"] = "Vem tank takes heavy damage. When Yauj dies, she spawns bugs - AoE heal raid. Keep tanks topped off.",
        ["Caster DPS"] = "Kill order: Kri → Vem → Yauj. AoE bugs when Yauj dies. Spread out for Toxic Volley.",
        ["Phys DPS"] = "Focus fire called boss. Stay spread - Yauj fears. Kill bugs when spawned.",
        ["Special 1"] = "3 tanks minimum. Kill order critical. AoE bugs from Yauj death fast. Nature Protection Potions for Toxic Volley.",
        ["Special 2"] = ""
    },
    ["Battleguard Sartura"] = {
        ["Tanks"] = "Tank Sartura and her 3 guards separately. Whirlwind incoming - run out 10 yards. Taunt swap after Whirlwind.",
        ["Healer"] = "Heal through Whirlwind raid damage. Sundering Cleave reduces armor - heal tanks heavily.",
        ["Caster DPS"] = "Kill guards first (Sartura enrages at 20%). Run out on Whirlwind. DPS from max range.",
        ["Phys DPS"] = "Burn guards. Run out 10+ yards when Whirlwind starts. Pop health potions.",
        ["Special 1"] = "Kill guards before Sartura hits 20% (hard enrage). Spread out, call Whirlwinds. Shadow Protection Potions.",
        ["Special 2"] = ""
    },
    ["Fankriss the Unyielding"] = {
        ["Tanks"] = "Tank Fankriss. Taunt swap on Mortal Wound stacks (healing -10% per stack, max 10). Off-tanks grab spawned worms.",
        ["Healer"] = "Heal through Mortal Wound - use big heals on debuffed tank. AoE heal for worm explosion damage.",
        ["Caster DPS"] = "DPS boss. When worms spawn, AoE them down fast before they reach raid. Nature Protection Potions.",
        ["Phys DPS"] = "Focus boss. Help kill worms if they get close. Watch Mortal Wound stacks on tanks.",
        ["Special 1"] = "2-3 tanks for taunt rotation. AoE worms immediately. Nature Protection Potions. Healers rotate on debuffed tank.",
        ["Special 2"] = ""
    },
    ["Viscidus"] = {
        ["Tanks"] = "Tank Viscidus center. He must be frozen (frost hits) then shattered (physical hits). 3 phases per kill attempt.",
        ["Healer"] = "Heal through Poison Bolt Volley. When Viscidus shatters, adds spawn - heal tanks grabbing blobs.",
        ["Caster DPS"] = "Frost mages spam Frostbolt to freeze boss (200 hits). Then melee shatters (50 hits). Repeat 3 times.",
        ["Phys DPS"] = "Attack when boss is frozen. Need 50 melee hits to shatter. Kill blobs after shatter. Nature Protection Potions.",
        ["Special 1"] = "Need ~15 frost mages. Freeze (200 frost hits) → Shatter (50 melee hits) → Kill blobs. Repeat 3 times. Nature resist gear.",
        ["Special 2"] = ""
    },
    ["Princess Huhuran"] = {
        ["Tanks"] = "Tank Huhuran. At 30%, she enrages - burn her fast. Berserk at 5 minutes hard enrage.",
        ["Healer"] = "Heal through Noxious Poison stacks. At 30%, spam heal raid - she goes berserk.",
        ["Caster DPS"] = "DPS to 31%, then wait for cooldowns. Burn 30%→0% in 30 seconds. Nature Protection Potions mandatory.",
        ["Phys DPS"] = "DPS to 31%, hold. Pop all cooldowns at 30%, burn her down. Greater Nature Protection Potion at 30%.",
        ["Special 1"] = "30% soft enrage, 5min hard enrage. Hold DPS at 31%, pop all CDs at 30% and burn. Full nature resist gear + potions.",
        ["Special 2"] = ""
    },
    ["Twin Emperors"] = {
        ["Tanks"] = "Tank Vek'lor (caster) with melee, Vek'nilash (melee) with casters. Bosses teleport every 45s - tanks swap sides.",
        ["Healer"] = "Heal both tanks. During teleport, rebuff and heal. Dispel Arcane Burst. Shadow Protection Potions for caster side.",
        ["Caster DPS"] = "DPS Vek'nilash (melee boss). Stand on caster platform. Swap sides when bosses teleport. Arcane Protection Potions.",
        ["Phys DPS"] = "DPS Vek'lor (caster boss). Stand on melee platform. Swap sides on teleport. Shadow Protection Potions.",
        ["Special 1"] = "2 tank teams (warlock + warrior for each boss). Melee DPS caster boss, ranged DPS melee boss. Teleport every 45s. Shadow + Arcane pots.",
        ["Special 2"] = ""
    },
    ["Ouro"] = {
        ["Tanks"] = "Tank Ouro above ground. He submerges every 90s - off-tanks grab sandblast worms. Move raid away from Dirt Mounds.",
        ["Healer"] = "Heal through Sweep (frontal AoE). When submerged, heal worm tanks. Watch for Sandblast (stun + bleed).",
        ["Caster DPS"] = "DPS Ouro above ground. When submerged, kill worms. Spread out - Ground Rupture spawns under players.",
        ["Phys DPS"] = "DPS from behind. Move away from Dirt Mounds (predict where Ouro surfaces). Nature Protection Potions.",
        ["Special 1"] = "Ouro surfaces every 90s. Kill worms during submerge. Move raid away from Dirt Mounds. Nature resist gear + potions.",
        ["Special 2"] = ""
    },
    ["C'Thun"] = {
        ["Tanks"] = "Phase 1: No tank needed. Phase 2: Tank C'Thun body, off-tanks grab Giant Claws/Eyes. Move boss away from tentacles.",
        ["Healer"] = "Phase 1: Heal eye beam targets. Don't get chained. Phase 2: Heal tanks, dispel weakened players from stomach group.",
        ["Caster DPS"] = "Phase 1: Kill eye tentacles. Focus Giant Eye Tentacles. Phase 2: DPS body, kill Giant Claws fast.",
        ["Phys DPS"] = "Phase 1: Kill tentacles. If swallowed, DPS stomach tentacles to escape. Phase 2: DPS C'Thun body from behind.",
        ["Special 1"] = "Phase 1: Kill tentacles, avoid eye beam chains. Dark Glare wipes raid if channeled. Phase 2: Players randomly swallowed into stomach - DPS tentacles to escape. Shadow + Nature pots.",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- NAXXRAMAS
-- ============================================================================
SS_TacticsDB["Naxx"] = {
    ["Anub'Rekhan"] = {
        ["Tanks"] = "Tank Anub'Rekhan center. At 1000 mana, he Impales raid - run out of melee range. Off-tanks grab spawned beetles.",
        ["Healer"] = "Heal through Locust Swarm damage. Dispel beetles' poison stacking DoT. Call out Impale - everyone run out.",
        ["Caster DPS"] = "Kill crypt guards (beetles) fast - they stack poison. DPS boss between Locust Swarms.",
        ["Phys DPS"] = "Attack from behind. Run out when Impale called. Kill beetles immediately when they spawn.",
        ["Special 1"] = "Off-tank beetles. Run out at 1000 mana (Impale). Locust Swarm every 90s. Nature resist gear helps.",
        ["Special 2"] = ""
    },
    ["Grand Widow Faerlina"] = {
        ["Tanks"] = "Tank Faerlina. Mind Control one Worshipper add per Frenzy. Frenzy = boss enrage, MC Worshipper to remove it.",
        ["Healer"] = "Heal through Rain of Fire. Silence Follower adds' Silence spell. Big heals during Frenzy if MC fails.",
        ["Caster DPS"] = "Priests: Mind Control Worshippers, DPS them to low HP before pull. Keep MC ready for Frenzy. Kill Followers first.",
        ["Phys DPS"] = "DPS boss. Interrupt Followers' Shadow Bolt. Kill MC'd Worshipper when Frenzy happens.",
        ["Special 1"] = "3 Priests MC Worshippers. At Frenzy, kill MC'd Worshipper to remove enrage. 4 Worshippers = 4 Frenzies to survive.",
        ["Special 2"] = ""
    },
    ["Maexxna"] = {
        ["Tanks"] = "Tank Maexxna. She Web Wraps 3 players (cocoon on wall) every 40s. DPS wraps fast. Taunt when tank is wrapped.",
        ["Healer"] = "Heal through Web Spray (raid-wide stun). Heal cocoons fast - wrapped players take DoT. Pre-HoT before Web Spray.",
        ["Caster DPS"] = "Kill web wraps immediately - wrapped players die in 60s. Ranged burn wraps, melee DPS boss.",
        ["Phys DPS"] = "Attack from behind. Move to wraps when called. Web Spray stuns everyone - can't do anything for 6s.",
        ["Special 1"] = "Web Spray every 40s (6s stun). 3 players wrapped - save them fast. Enrage at 10min. Nature pots help.",
        ["Special 2"] = ""
    },
    ["Noth the Plaguebringer"] = {
        ["Tanks"] = "Tank Noth center. He teleports every 90s - kill skeletons during teleport phase. He returns after 70s.",
        ["Healer"] = "Heal through Curse of the Plaguebringer (raid DoT). Teleport phase: heal through skeleton waves.",
        ["Caster DPS"] = "DPS Noth. When he teleports, AoE skeletons. Plague waves spawn periodically - kill them.",
        ["Phys DPS"] = "Burn Noth. Switch to skeletons during teleport phase. Stay spread for Blink.",
        ["Special 1"] = "3 teleport phases. Kill skeletons fast each phase. Decurse Curse of Plaguebringer. Long fight.",
        ["Special 2"] = ""
    },
    ["Heigan the Unclean"] = {
        ["Tanks"] = "Tank Heigan on platform. Follow the dance pattern (avoid erupting floor sections). Don't miss a step - instant death.",
        ["Healer"] = "Heal through Plague Cloud damage. Follow dance pattern perfectly. Pre-HoT before Decrepit Fever ticks.",
        ["Caster DPS"] = "DPS from platform. Learn dance pattern - move in waves, left/right. Teleport phase: dance faster, ranged DPS him.",
        ["Phys DPS"] = "Dance pattern is key. Phase 1: slow dance. Phase 2 (teleport): fast dance. One mistake = death.",
        ["Special 1"] = "Safety Dance achievement = everyone survives floor eruptions. Practice dance pattern. Nature pots for Plague Cloud.",
        ["Special 2"] = ""
    },
    ["Loatheb"] = {
        ["Tanks"] = "Tank Loatheb. Deathbloom aura = healing only works every 60s (5s window). Coordinate tank cooldowns for 55s gaps.",
        ["Healer"] = "Heal ONLY during 5s windows every 60s. Pre-HoT before window closes. Corrupted Mind buffs increase healing/crit.",
        ["Caster DPS"] = "DPS race. Kill spores for +50% crit buff (Corrupted Mind). Consume stacks before healing window for max healing buff.",
        ["Phys DPS"] = "Burn boss. Grab spores for crit buff. Save health pots for between heal windows.",
        ["Special 1"] = "3 spores spawn every 20s. Rotate classes to get spores (healers → tanks → DPS). Heal only during 5s windows. Shadow pots.",
        ["Special 2"] = ""
    },
    ["Instructor Razuvious"] = {
        ["Tanks"] = "Priests Mind Control two Understudies - they tank Razuvious. Rotate MC (1min duration). No player tank possible.",
        ["Healer"] = "Heal MC'd Understudies (they are the tanks). Rotate MC priests every 60s. Shield tanks before Disrupting Shout.",
        ["Caster DPS"] = "4 Priests on MC rotation (2 active, 2 backup). MC Understudies, use Taunt and Shield abilities. DPS boss.",
        ["Phys DPS"] = "DPS Razuvious from behind. Stay away from Understudy tanks. Watch Disrupting Shout (AoE silence).",
        ["Special 1"] = "Requires 4 Priests for MC rotation. MC lasts 1min, no heal/buff during MC. Backup priest must taunt fast.",
        ["Special 2"] = ""
    },
    ["Gothik the Harvester"] = {
        ["Tanks"] = "Phase 1: Tank undead on live side (left), rider adds on undead side (right). Gate opens at 4:30 - sides merge.",
        ["Healer"] = "Phase 1: Split healers both sides. Kill live side mobs, ghosts spawn on dead side. Phase 2: Heal center tank.",
        ["Caster DPS"] = "Phase 1: Kill mobs on your side. Unbalanced DPS = one side overwhelmed. Phase 2: Burn Gothik center.",
        ["Phys DPS"] = "Split raid left/right. Kill live mobs → they spawn as ghosts on dead side. Balance DPS or wipe.",
        ["Special 1"] = "Gate opens at 4:30. Live side → dead side spawns. Balance kills or one side wipes. Shackle undead to help.",
        ["Special 2"] = ""
    },
    ["The Four Horsemen"] = {
        ["Tanks"] = "8 tanks rotate on 4 bosses. Marks stack (4 stacks = death). Rotate tanks every 3 marks. Complex positioning fight.",
        ["Healer"] = "Heal through Meteor (Mograine). Dispel Void Zone (Blaumeux). Watch mark stacks on tanks - rotate heals.",
        ["Caster DPS"] = "DPS boss call-outs. Move to assigned positions on mark rotations. Shadow Protection Potions.",
        ["Phys DPS"] = "Focus called boss. Rotate positions with tanks. Watch mark stacks (4 = death). Complex dance.",
        ["Special 1"] = "8 tanks (2 per boss). Marks last 75s, stack up to 4 (then death). Rotate tanks every 3 marks. Hard coordination fight.",
        ["Special 2"] = ""
    },
    ["Patchwerk"] = {
        ["Tanks"] = "3-4 tank rotation. Hateful Strike hits second-highest threat. Off-tanks stack behind main tank. HP > 7500 required for off-tanks.",
        ["Healer"] = "Hardest healing check in game. Main tank takes 30k+ DPS. Rotate healer cooldowns. Flash Heal spam.",
        ["Caster DPS"] = "Pure DPS burn. 6-minute enrage. Threat not an issue - Hateful Strike hits off-tanks.",
        ["Phys DPS"] = "Burn hard. Stay above 7500 HP (or you get Hateful Strike). Pop health pots on cooldown.",
        ["Special 1"] = "3-4 tanks (1 main, 3 off-tanks behind with HP > 7500). Healing check boss. 6min enrage. Full consumables.",
        ["Special 2"] = ""
    },
    ["Grobbulus"] = {
        ["Tanks"] = "Kite Grobbulus around room. Slime Spray spawns clouds - move boss away. Don't walk through clouds.",
        ["Healer"] = "Heal through Mutating Injection. When you get injected, run to safe spot - you explode into poison cloud. Call it out.",
        ["Caster DPS"] = "DPS while moving with raid. Avoid poison clouds. If you get Mutating Injection, run to designated drop spot.",
        ["Phys DPS"] = "Attack from behind while kiting. Drop Injection clouds at safe spots. Don't overlap clouds.",
        ["Special 1"] = "Kite boss clockwise. Injection = 10s then explosion into poison cloud. Mark safe spots for cloud drops. Nature pots.",
        ["Special 2"] = ""
    },
    ["Gluth"] = {
        ["Tanks"] = "Main tank holds Gluth center. Off-tank kites zombie adds around room. Do NOT let zombies reach Gluth - he eats them and heals.",
        ["Healer"] = "Heal main tank through Mortal Wound stacks. Heal zombie kiter. Decimate every 90s drops everyone to 5% HP - spam heals.",
        ["Caster DPS"] = "Kill zombies on kiter before Gluth Decimates. Slow/snare zombies. After Decimate, AoE remaining zombies.",
        ["Phys DPS"] = "DPS Gluth. Help kill zombies before Decimate. After Decimate, burn zombies fast before Gluth eats them.",
        ["Special 1"] = "Decimate every 90s = entire raid goes to 5% HP. Zombie kiter must keep zombies away. AoE zombies after Decimate.",
        ["Special 2"] = ""
    },
    ["Thaddius"] = {
        ["Tanks"] = "Tank Thaddius center. Stalagg and Feugen charge tanks with + or - polarity. Touch opposite polarity = chain explosion.",
        ["Healer"] = "Phase 1: Heal both mini-boss tanks. Phase 2: Heal through Polarity Shift raid damage. Watch your polarity debuff.",
        ["Caster DPS"] = "Phase 1: Burn mini-bosses evenly, must die within 5s. Phase 2: Stack with your polarity (+ or -), DPS Thaddius.",
        ["Phys DPS"] = "Phase 1: Kill Stalagg and Feugen together. Phase 2: Jump to your polarity side fast (5s or wipe). DPS boss.",
        ["Special 1"] = "Phase 1: Kill mini-bosses within 5s. Phase 2: Polarity Shift every 30s - move to correct side instantly. + on left, - on right.",
        ["Special 2"] = ""
    },
    ["Sapphiron"] = {
        ["Tanks"] = "Tank Sapphiron. During Air Phase, he Ice Blocks 5 players - hide behind ice blocks for Frost Breath (LoS). Ground phase: normal tank.",
        ["Healer"] = "Heal through Life Drain (heals boss, damages raid). Air Phase: hide behind ice blocks fast. Dispel Chill debuff quickly.",
        ["Caster DPS"] = "Ground Phase: DPS boss. Air Phase: position behind ice block for Frost Breath (blocks LoS). Frost resist gear 200+.",
        ["Phys DPS"] = "Attack from behind. Air Phase: run to ice blocks. Ground Phase: DPS hard. Greater Frost Protection Potion mandatory.",
        ["Special 1"] = "Air Phase: 5 players ice blocked. Everyone hide behind blocks for Frost Breath. Ground Phase: DPS. 200+ frost resist + potions.",
        ["Special 2"] = ""
    },
    ["Kel'Thuzad"] = {
        ["Tanks"] = "Tank Kel'Thuzad center. Phase 1: tank skeletons and abominations. Phase 2: tank adds. Phase 3: burn boss, adds keep spawning.",
        ["Healer"] = "Heal through Frost Blast chains. Detonate Mana on target player (massive AoE) - everyone spread. Shadow Fissure moves - dodge it.",
        ["Caster DPS"] = "Phase 1: Kill adds. Phase 2: Burn boss fast. Mind Control breaks are critical. Phase 3: Nuke boss while adds spawn.",
        ["Phys DPS"] = "Phase 1: Focus adds. Phase 2: DPS Kel'Thuzad. Phase 3: Burn boss, off-tanks handle adds. Frost Protection Potions.",
        ["Special 1"] = "Phase 1 (5min): Kill waves. Phase 2: Burn KT. Phase 3: Guardian spawns every 5 attempts. Frost Blast chains = spread. Shadow + Frost pots.",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- KARAZHAN 40
-- ============================================================================
SS_TacticsDB["Kara40"] = {
    ["Keeper Gnarlmoon"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Ley-Watcher Incantagos"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Anomalus"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Echo of Medivh"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Chess King"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Sanv Tas'dal"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Kruul"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Rupturan"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Mephistroth"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- KARAZHAN 10
-- ============================================================================
SS_TacticsDB["Kara10"] = {
    ["Master Blacksmith Rolfen"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Lord Blackwald II"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Clawlord Howlfang"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Grizikil"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Brood Queen Araxxna"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Moroes"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- EMERALD SANCTUM
-- ============================================================================
SS_TacticsDB["ES"] = {
    ["Erennius"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Solnius the Awakener"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    },
    ["Solnius Hardmode"] = {
        ["Tanks"] = "",
        ["Healer"] = "",
        ["Caster DPS"] = "",
        ["Phys DPS"] = "",
        ["Special 1"] = "",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- AQ20
-- ============================================================================
SS_TacticsDB["AQ20"] = {
    ["Kurinnaxx"] = {
        ["Tanks"] = "Tank boss. Mortal Wound stacks reduce healing - taunt swap at 3-4 stacks.",
        ["Healer"] = "Heal through stacking Mortal Wound. Wide Slash does raid damage.",
        ["Caster DPS"] = "Nuke boss. Stay spread for Sand Trap (roots + damage).",
        ["Phys DPS"] = "DPS from behind. Avoid Wide Slash frontal cone.",
        ["Special 1"] = "2 tanks for taunt swaps. Nature pots help with Sand Trap.",
        ["Special 2"] = ""
    },
    ["General Rajaxx"] = {
        ["Tanks"] = "Tank boss and waves of adds. 7 waves before Rajaxx spawns.",
        ["Healer"] = "Heal through Thundercrash (AoE knock-up). Long fight, manage mana.",
        ["Caster DPS"] = "AoE waves. Focus captains. Save cooldowns for Rajaxx.",
        ["Phys DPS"] = "Kill waves. Burn captains fast. Rajaxx at wave 8.",
        ["Special 1"] = "7 waves of adds, then Rajaxx. Kill captains first each wave.",
        ["Special 2"] = ""
    },
    ["Moam"] = {
        ["Tanks"] = "Tank Moam. At 0 mana, he transforms into stone form (immune, spawns adds).",
        ["Healer"] = "Drain his mana fast with mana burns. Heal stone form add tanks.",
        ["Caster DPS"] = "Mana burn boss to trigger stone form. Kill adds during stone form. Arcane pots.",
        ["Phys DPS"] = "DPS boss. Switch to adds during stone form.",
        ["Special 1"] = "Drain mana → stone form → kill adds → repeat. Arcane pots help.",
        ["Special 2"] = ""
    },
    ["Buru the Gorger"] = {
        ["Tanks"] = "Kite Buru over egg piles. Eggs explode when Buru walks over them, damaging him and stunning him briefly.",
        ["Healer"] = "Heal kiting tank. Heal through Creeping Plague stacking DoT.",
        ["Caster DPS"] = "Nuke Buru when he's stunned by egg explosions. Lure him over eggs.",
        ["Phys DPS"] = "DPS during egg stuns. Help kite boss over eggs.",
        ["Special 1"] = "Kite boss over eggs to stun him and deal damage. Nature pots for Plague.",
        ["Special 2"] = ""
    },
    ["Ayamiss the Hunter"] = {
        ["Tanks"] = "Tank spawned wasps. Ayamiss flies above - ranged DPS only phase 1.",
        ["Healer"] = "Heal through wasp swarms. Paralyze on random players - dispel stuns.",
        ["Caster DPS"] = "Ranged DPS Ayamiss while she flies. Kill wasps. At 70% she lands - burn her.",
        ["Phys DPS"] = "Kill wasps during air phase. DPS boss when she lands.",
        ["Special 1"] = "Air phase until 70%. Ranged DPS only. Lands at 70% - burn fast.",
        ["Special 2"] = ""
    },
    ["Ossirian the Unscarred"] = {
        ["Tanks"] = "Tank Ossirian near crystals. He has random Supreme Mode (element buff) - use matching crystal to remove it.",
        ["Healer"] = "Heal through Curse of Tongues. Remove curses. Supreme Mode hits hard - pop cooldowns.",
        ["Caster DPS"] = "DPS boss. When Supreme Mode activates, someone activates matching crystal (Fire/Frost/Arcane/Shadow/Nature).",
        ["Phys DPS"] = "Attack from behind. Help activate crystals when called. Matching resist pot for active Supreme Mode.",
        ["Special 1"] = "Supreme Mode = random element buff. Click matching crystal to remove. Resist pots match active element.",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- ZUL GURUB
-- ============================================================================
SS_TacticsDB["ZG"] = {
    ["High Priestess Jeklik"] = {
        ["Tanks"] = "Tank Jeklik. Bat phase: she flies, spawn bat adds - off-tanks grab them.",
        ["Healer"] = "Heal through Psychic Scream fear. Remove Curse of Blood (healing reduction).",
        ["Caster DPS"] = "Ground phase: DPS boss. Bat phase: Kill bats. Shadow Protection Potions.",
        ["Phys DPS"] = "DPS boss on ground. Kill bats when she flies.",
        ["Special 1"] = "Bat phase at 75%/50%. Kill bats, she lands. Shadow pots recommended.",
        ["Special 2"] = ""
    },
    ["High Priest Venoxis"] = {
        ["Tanks"] = "Tank Venoxis. At 50% he transforms into snake - hits harder, casts Poison Cloud.",
        ["Healer"] = "Heal through Holy Wrath (AoE fire). Snake phase: cure poisons, heal heavy tank damage.",
        ["Caster DPS"] = "Burn boss. Snake phase: nature pots for Poison Cloud.",
        ["Phys DPS"] = "DPS from behind. Snake phase: greater nature pots mandatory.",
        ["Special 1"] = "50% = snake form. Heavy tank damage + poison clouds. Nature pots required.",
        ["Special 2"] = ""
    },
    ["High Priestess Mar'li"] = {
        ["Tanks"] = "Tank Mar'li. She spawns spider adds - off-tank grabs them.",
        ["Healer"] = "Dispel Poison Bolt DoT. Heal through spider adds' poison.",
        ["Caster DPS"] = "Kill spider adds immediately. Then DPS boss. Nature pots.",
        ["Phys DPS"] = "Burn adds, then boss. Watch for Enveloping Web (roots).",
        ["Special 1"] = "Spider adds spawn periodically. Kill them fast. Nature pots help.",
        ["Special 2"] = ""
    },
    ["Bloodlord Mandokir"] = {
        ["Tanks"] = "Tank Mandokir. He gains Threatening Gaze (fixate on random player) - that player must stop all actions or raid wipes.",
        ["Healer"] = "Heal tank. Watch for Threatening Gaze - stop healing that player. Rez killed players (boss levels up per death).",
        ["Caster DPS"] = "DPS boss. If you get Threatening Gaze, STOP ALL ACTIONS immediately.",
        ["Phys DPS"] = "Attack from behind. Threatening Gaze = freeze completely.",
        ["Special 1"] = "Threatening Gaze = stop everything or raid wipes. Boss levels up +1 per player death. Battle res critical.",
        ["Special 2"] = ""
    },
    ["Edge of Madness"] = {
        ["Tanks"] = "One of 4 random bosses. Check which one before pull.",
        ["Healer"] = "Gri'lek: dispel poison. Hazza'rah: heal charm. Renataki: heal bleeds. Wushoolay: heal lightning.",
        ["Caster DPS"] = "Adjust DPS per boss. Gri'lek = nature pots. Hazza'rah = shadow pots.",
        ["Phys DPS"] = "Follow boss mechanics. Different each week.",
        ["Special 1"] = "4 possible bosses (Gri'lek, Hazza'rah, Renataki, Wushoolay). Random weekly.",
        ["Special 2"] = ""
    },
    ["High Priest Thekal"] = {
        ["Tanks"] = "Tank Thekal and his 2 zealot adds. All 3 must die within 10s or they resurrect.",
        ["Healer"] = "Heal all 3 tanks. Tiger phase: heavy tank damage, heal through Frenzy.",
        ["Caster DPS"] = "Burn all 3 evenly to 10%. Kill within 10s of each other. Tiger phase: nuke fast.",
        ["Phys DPS"] = "DPS called target. Even them out, then burn all 3. Tiger phase: pop cooldowns.",
        ["Special 1"] = "Kill Thekal + 2 adds within 10s or they rez. Tiger phase after deaths - hits very hard.",
        ["Special 2"] = ""
    },
    ["High Priestess Arlokk"] = {
        ["Tanks"] = "Tank Arlokk. Panther phase: she vanishes, spawns panthers. Mark of Arlokk = fixate on player.",
        ["Healer"] = "Heal marked player (panthers chase them). Heal panther tanks.",
        ["Caster DPS"] = "Kill panthers. When boss visible, burn her. Shadow pots.",
        ["Phys DPS"] = "DPS panthers. Switch to boss when she appears.",
        ["Special 1"] = "Panther phase: kill adds. Mark of Arlokk = panthers chase marked player. Kite them.",
        ["Special 2"] = ""
    },
    ["Jin'do the Hexxer"] = {
        ["Tanks"] = "Tank Jin'do. Periodically teleports raid to spirit world - kill shades to return.",
        ["Healer"] = "Heal through Curse of Jin'do (mana drain). Banish Healing Totem (heals boss).",
        ["Caster DPS"] = "Destroy Healing Totem immediately. Spirit world: kill shades fast to escape.",
        ["Phys DPS"] = "DPS boss. Break totem. Spirit world: burn shades.",
        ["Special 1"] = "Destroy Healing Totem instantly (heals boss to full if left up). Spirit world teleports - kill shades to return.",
        ["Special 2"] = ""
    },
    ["Hakkar the Soulflayer"] = {
        ["Tanks"] = "Tank Hakkar center. Kill all 5 priest bosses before Hakkar or he gains their powers (much harder).",
        ["Healer"] = "Heal through Blood Siphon (raid-wide life drain, heals Hakkar). Dispel Corrupted Blood (disease, spreads to nearby players).",
        ["Caster DPS"] = "DPS hard. Spread out for Corrupted Blood. Mind Control on random players - CC them.",
        ["Phys DPS"] = "Attack from behind. Spread 10+ yards apart for Corrupted Blood. Nature pots for Poisonous Cloud.",
        ["Special 1"] = "Kill all 5 priests before Hakkar. Spread for Corrupted Blood (spreads like plague). Nature pots. Blood Siphon heals him - DPS race.",
        ["Special 2"] = ""
    }
}

-- ============================================================================
-- ONYXIA
-- ============================================================================
SS_TacticsDB["Ony"] = {
    ["Onyxia"] = {
        ["Tanks"] = "Phase 1: Tank Onyxia. Phase 2: She flies - no tank needed. Phase 3: Tank her again, face away from raid.",
        ["Healer"] = "Phase 1: Heal tank through Flame Breath. Phase 2: Heal raid from Fireball Barrage. Phase 3: Heavy tank healing + Deep Breath dodging.",
        ["Caster DPS"] = "Phase 1: DPS boss. Phase 2: Kill whelps and guards. Phase 3: Nuke her fast before Deep Breaths wipe raid.",
        ["Phys DPS"] = "Phase 1: Attack from behind (tail swipe knocks back). Phase 2: Kill adds. Phase 3: Burn boss, dodge Deep Breath.",
        ["Special 1"] = "Phase 1 (100-65%): Tank and spank. Phase 2 (65-40%): Air phase, kill adds. Phase 3 (40-0%): Burn fast, dodge Deep Breath. Greater Fire Protection Potion mandatory.",
        ["Special 2"] = ""
    }
}