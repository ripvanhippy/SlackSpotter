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
        ["Healers"] = "Dispel Lucifron's Curse immediately - it increases fire damage taken. Priests dispel Impending Doom (magic debuff). Spread out to avoid chain damage.",
        ["Casters"] = "DPS adds first, then boss. Watch threat - Lucifron hits hard. Mages decurse if needed.",
        ["Melee"] = "Kill adds when they spawn. Stay behind boss. Watch for Impending Doom stun - move away from raid.",
        ["Special"] = "Assign 2-3 decursers. Warlocks banish one add if needed. Main tank needs Shadow Protection Potion."
    },
    ["Magmadar"] = {
        ["Tanks"] = "Face boss away from raid. Coordinate fear immunity - use Berserker Rage, Tremor Totem, or Fear Ward. Tank swap if feared.",
        ["Healers"] = "Heal through Panic (raid fear every 30s). Druids remove Frenzy with Tranquilizing Shot immediately.",
        ["Casters"] = "Hunters: Tranquilizing Shot rotation on Frenzy buff. Ranged DPS from max range to avoid lava spit.",
        ["Melee"] = "Attack from behind. When feared, run towards walls not lava. Pop Living Action Potion if available.",
        ["Special"] = "Hunter tranq rotation: assign 3 hunters. Fear Ward main tank. Tremor totems in melee and ranged groups."
    },
    ["Gehennas"] = {
        ["Tanks"] = "Tank Gehennas and his 2 Flamewakers separately. Flamewakers must not be near each other or boss - they buff each other.",
        ["Healers"] = "Decurse Gehennas' Curse (increases shadow damage). Dispel Rain of Fire quickly. High mana fight.",
        ["Casters"] = "Kill Flamewakers first, focus fire one at a time. Mages remove curses. Watch aggro on Rain of Fire.",
        ["Melee"] = "Assist on Flamewakers. Move out of Rain of Fire immediately. Pop Fire Protection Potions.",
        ["Special"] = "Assign curse removers (mages, druids). 3 tanks needed. Everyone needs Fire Protection Potion ready."
    },
    ["Garr"] = {
        ["Tanks"] = "Main tank holds Garr. Off-tanks each grab one add. Do NOT let adds die near each other - they explode and buff remaining adds.",
        ["Healers"] = "Dispel Magma Shackles (reduces healing received). Very heal-intensive fight. Spread mana between tanks.",
        ["Casters"] = "Banish 2 adds (warlocks). Kill unbanished adds one by one, far from other adds. Do not AoE.",
        ["Melee"] = "Focus fire called add. Move adds away from pack before killing. Expect to die to Separation Anxiety - combat res available.",
        ["Special"] = "8 off-tanks needed. 2 warlocks banish adds. Main tank needs heavy healing and Fire Protection Potion."
    },
    ["Shazzrah"] = {
        ["Tanks"] = "Tank in center. When Shazzrah blinks, he resets threat - be ready to pick him up fast. Face away from raid.",
        ["Healers"] = "Shazzrah blinks every 30-45s and AoEs - heal through it. Dispel Shazzrah's Curse (increases arcane damage).",
        ["Casters"] = "Nuke hard before blinks. Stop DPS at 45% threat - blink resets aggro. Decurse quickly.",
        ["Melee"] = "Attack from behind. When he blinks, run out 10 yards to avoid AoE. Pop Arcane Protection Potion.",
        ["Special"] = "Assign decursers. Arcane Protection Potions strongly recommended. Call out blinks - everyone stack center after."
    },
    ["Baron Geddon"] = {
        ["Tanks"] = "Tank in center of room. Be ready for Ignite Mana - it drains mana and explodes. Run out if you get Living Bomb.",
        ["Healers"] = "Watch for Living Bomb debuff - player must run FAR away (25 yards) before explosion. Heal tanks through Ignite Mana.",
        ["Casters"] = "DPS from range. If you get Living Bomb, run to designated safe spot immediately. Call out 'BOMB ON ME' in voice.",
        ["Melee"] = "Attack from behind. Run out fast if Living Bomb. Fire Protection Potions required.",
        ["Special"] = "Designate bomb run-out spots (4 corners). Fire Protection Potion mandatory. Main tank needs Greater Fire Protection Potion."
    },
    ["Golemagg"] = {
        ["Tanks"] = "Main tank holds Golemagg in center. Two off-tanks grab the two Core Hounds. Keep dogs away from Golemagg - they enrage him.",
        ["Healers"] = "Heal dog tanks heavily - dogs hit hard and apply stacking DoT. Dispel Magma Splash if possible.",
        ["Casters"] = "Kill dogs first. Focus fire one dog, then the other. After dogs dead, nuke Golemagg. Fire Protection Potions.",
        ["Melee"] = "DPS dogs from behind. After dogs die, burn Golemagg. Pop Fire Protection Potions for Magma Splash.",
        ["Special"] = "3 tanks needed. Dog tanks need Fire Resistance gear. Do NOT kill dogs near Golemagg."
    },
    ["Sulfuron Harbinger"] = {
        ["Tanks"] = "Tank Sulfuron and separate his 4 adds. Adds must die simultaneously - hold DPS at 10% on all.",
        ["Healers"] = "Heal through Inspire (adds buff each other). Priests can Mind Control an add for extra DPS.",
        ["Casters"] = "AoE adds to 10%, then single-target to even them out. Kill all 4 adds within 10 seconds of each other.",
        ["Melee"] = "Focus fire called add. Stop DPS at 10% and wait for all adds to be ready. Then burn all fast.",
        ["Special"] = "5 tanks needed (one per add + boss). Priests can Mind Control. Fire Protection Potions for everyone."
    },
    ["Majordomo Executus"] = {
        ["Tanks"] = "Tank Majordomo in center. Off-tanks grab adds. Kill adds first - they heal Majordomo. Spread adds apart.",
        ["Healers"] = "Dispel Magic Shield on adds (absorbs 8000 damage). Heal through Damage Shield (reflects damage to attackers).",
        ["Casters"] = "Kill healers first, then DPS adds. Focus fire one at a time. Watch threat - adds hit hard.",
        ["Melee"] = "Focus called add. Healers die first priority. Pop health potions when Damage Shield is up.",
        ["Special"] = "9 tanks needed. Kill order: 4 healers → 4 adds → Majordomo. Dispel Magic Shield immediately."
    },
    ["Ragnaros"] = {
        ["Tanks"] = "Tank Ragnaros facing away from raid. He submerges at 3min, 6min - kill adds during submerge. Taunt off tanks when knocked back.",
        ["Healers"] = "Heal through Lava Burst (heavy raid damage). Avoid Wrath of Ragnaros (knockback + weapon damage debuff). Stay spread for Hand of Ragnaros.",
        ["Casters"] = "DPS Ragnaros. At submerge, kill Sons of Flame fast (they heal Ragnaros). Ranged kite sons away from melee.",
        ["Melee"] = "Attack Ragnaros from behind. When he submerges, switch to Sons immediately. Greater Fire Protection Potion mandatory.",
        ["Special"] = "Everyone needs Greater Fire Protection Potion. Hunters kite sons. Tank rotation for knockbacks. Heal through lava burst waves."
    }
}

-- ============================================================================
-- BLACKWING LAIR
-- ============================================================================
SS_TacticsDB["BWL"] = {
    ["Razorgore"] = {
        ["Tanks"] = "Phase 1: Hold adds away from orb controller. Rotate tanks on adds. Phase 2: Tank Razorgore, taunt swap on Conflagration stacks.",
        ["Healers"] = "Phase 1: Heal orb controller and add tanks. Dispel Fireball Volley. Phase 2: Heal through Conflagration stacks.",
        ["Casters"] = "Phase 1: AoE adds, control spawns. Phase 2: Nuke Razorgore. Mind Control orb controller to destroy eggs faster.",
        ["Melee"] = "Phase 1: Kill adds. Phase 2: DPS Razorgore from behind. Move out if targeted by Fireball Volley.",
        ["Special"] = "Orb controller (priest/warlock) destroys eggs. 4-5 tanks for add control. Phase 2: burn boss fast before Conflagration wipes raid."
    },
    ["Vaelastrasz"] = {
        ["Tanks"] = "Tank rotation every 15 seconds (Burning Adrenaline = 15s to live). 8+ tanks needed. Face boss away, move to next position fast.",
        ["Healers"] = "Spam heal tanks - they take massive damage. Healers will get Burning Adrenaline - DPS until death, battle res after.",
        ["Casters"] = "Nuke hard. Everyone has infinite mana/energy. When you get Burning Adrenaline, you have 15s to DPS before death.",
        ["Melee"] = "DPS from behind. Threat is extreme - watch Omen. Pop health potions on cooldown. Burning Adrenaline = 15s then you die.",
        ["Special"] = "8+ tank rotation. DPS race - 3 minute enrage. Accept deaths - save battle res for tanks/healers. Full consumables."
    },
    ["Broodlord Lashlayer"] = {
        ["Tanks"] = "Tank Broodlord at end of gauntlet. Hold aggro tight - Mortal Strike reduces healing. Taunt swap if needed.",
        ["Healers"] = "Heal through Mortal Strike (50% healing reduction). Suppression Room gauntlet is heal-intensive. Spread mana wisely.",
        ["Casters"] = "Gauntlet: AoE packs. Boss: Nuke hard. Threat is not an issue - he does Blast Wave knockback resetting aggro.",
        ["Melee"] = "Gauntlet: Kill suppression device dragonkin. Boss: DPS from behind, watch Mortal Strike on tanks.",
        ["Special"] = "Gauntlet is hardest part - clear packs slowly, destroy suppression devices. Boss is easy with proper tank rotation."
    },
    ["Firemaw"] = {
        ["Tanks"] = "Tank Firemaw facing away from raid. Move to safe spot during Wing Buffet (knockback). Rotate tanks to reset stacks.",
        ["Healers"] = "Heal through Flame Buffet (stacking fire DoT). Everyone takes raid damage. Los wing buffet behind pillars.",
        ["Casters"] = "DPS from max range. Move behind pillars during Wing Buffet. Fire resist gear recommended (100+).",
        ["Melee"] = "Attack from behind. Run to safe spot on Wing Buffet (knockback into whelp packs = death). Greater Fire Protection Potion mandatory.",
        ["Special"] = "Everyone needs 100+ fire resist. Greater Fire Protection Potions required. Positioning critical to avoid whelp packs."
    },
    ["Ebonroc"] = {
        ["Tanks"] = "Main tank only - Ebonroc stays on highest threat. Heal through Shadow of Ebonroc (self-heal buff on boss).",
        ["Healers"] = "Heal main tank heavily during Shadow of Ebonroc. Raid takes shadow DoT - spread healing to raid.",
        ["Casters"] = "Nuke boss. No threat issues. Avoid standing in Wing Buffet.",
        ["Melee"] = "DPS from behind. Watch for Wing Buffet knockback.",
        ["Special"] = "Easy fight. Single tank. No resistance needed. Burn fast before healer mana runs out."
    },
    ["Flamegor"] = {
        ["Tanks"] = "Tank Flamegor. Taunt immediately when Frenzy (attack speed buff) is active. Face away from raid.",
        ["Healers"] = "Heal through Frenzy - boss hits extremely fast. Dispel Shadow Flame DoT if possible.",
        ["Casters"] = "Hunters: Tranquilizing Shot rotation on Frenzy immediately. Ranged DPS nuke hard.",
        ["Melee"] = "DPS from behind. Greater Fire Protection Potion mandatory. Move out of Wing Buffet.",
        ["Special"] = "3 hunters on tranq rotation. Greater Fire Protection Potions. Tank swap on Frenzy if tranq fails."
    },
    ["Chromaggus"] = {
        ["Tanks"] = "Tank Chromaggus facing away. He has 5 random breaths (2 active per week). Coordinate tank cooldowns for heavy breath damage.",
        ["Healers"] = "Heal through double breath combos. Dispel Bronze Affliction (stun). Cure diseases/poisons as needed depending on breath combo.",
        ["Casters"] = "DPS hard. Each breath applies stacking debuff - raid damage increases over time. Check weekly breath combo before pull.",
        ["Melee"] = "Attack from behind. Move away from tank if Time Lapse (Bronze breath). Pop resist potions based on breath combo.",
        ["Special"] = "Breaths are random each week. Check breath combo: Frost/Arcane/Fire/Shadow/Nature. Adjust resist gear/potions accordingly."
    },
    ["Nefarian"] = {
        ["Tanks"] = "Phase 1: Tank adds. Phase 2: Tank Nefarian center, face away. Phase 3: Move boss to throne platform, tank skeletons.",
        ["Healers"] = "Phase 1: Heal through add damage. Phase 2: Dispel class calls (priests = healing debuff, warriors = broken weapons). Phase 3: AoE heal raid.",
        ["Casters"] = "Phase 1: AoE drakonids. Phase 2: DPS Nefarian, handle class calls (mages = polymorph raid, hunters = broken bows). Phase 3: Nuke boss.",
        ["Melee"] = "Phase 1: Kill drakonids. Phase 2: DPS boss from behind, watch class calls (rogues = teleport and AoE). Phase 3: Kill skeletons then boss.",
        ["Special"] = "Phase 2 class calls: Priests (healing -50%), Warriors (broken weapons), Rogues (teleport+AoE), Hunters (broken bows), Warlocks (infernals spawn), Mages (poly raid), Druids (cat form), Paladins (bomb). Onyxia Scale Cloak mandatory."
    }
}

-- ============================================================================
-- AQ40
-- ============================================================================
SS_TacticsDB["AQ40"] = {
    ["The Prophet Skeram"] = {
        ["Tanks"] = "Tank all 3 Skerams (real + 2 copies at 75%/50%). Mark kill order. True Teleport resets threat.",
        ["Healers"] = "Heal through Arcane Explosion. Dispel Mind Control immediately - MC'd players AoE the raid.",
        ["Casters"] = "Kill Skerams evenly to 75%, then focus real one. Stop DPS when he splits. Arcane Protection Potions.",
        ["Melee"] = "DPS called Skeram. When he teleports, reposition fast. Interrupt Mind Control with stuns if possible.",
        ["Special"] = "Mark real Skeram. Kill order: Real → Copy 1 → Copy 2. Save battle res for MC deaths. Arcane Protection Potions."
    },
    ["Silithid Royalty"] = {
        ["Tanks"] = "Tank all 3 bosses separately. Yauj (heal boss), Vem (tank boss), Kri (DPS boss). Never let them touch each other.",
        ["Healers"] = "Vem tank takes heavy damage. When Yauj dies, she spawns bugs - AoE heal raid. Keep tanks topped off.",
        ["Casters"] = "Kill order: Kri → Vem → Yauj. AoE bugs when Yauj dies. Spread out for Toxic Volley.",
        ["Melee"] = "Focus fire called boss. Stay spread - Yauj fears. Kill bugs when spawned.",
        ["Special"] = "3 tanks minimum. Kill order critical. AoE bugs from Yauj death fast. Nature Protection Potions for Toxic Volley."
    },
    ["Battleguard Sartura"] = {
        ["Tanks"] = "Tank Sartura and her 3 guards separately. Whirlwind incoming - run out 10 yards. Taunt swap after Whirlwind.",
        ["Healers"] = "Heal through Whirlwind raid damage. Sundering Cleave reduces armor - heal tanks heavily.",
        ["Casters"] = "Kill guards first (Sartura enrages at 20%). Run out on Whirlwind. DPS from max range.",
        ["Melee"] = "Burn guards. Run out 10+ yards when Whirlwind starts. Pop health potions.",
        ["Special"] = "Kill guards before Sartura hits 20% (hard enrage). Spread out, call Whirlwinds. Shadow Protection Potions."
    },
    ["Fankriss the Unyielding"] = {
        ["Tanks"] = "Tank Fankriss. Taunt swap on Mortal Wound stacks (healing -10% per stack, max 10). Off-tanks grab spawned worms.",
        ["Healers"] = "Heal through Mortal Wound - use big heals on debuffed tank. AoE heal for worm explosion damage.",
        ["Casters"] = "DPS boss. When worms spawn, AoE them down fast before they reach raid. Nature Protection Potions.",
        ["Melee"] = "Focus boss. Help kill worms if they get close. Watch Mortal Wound stacks on tanks.",
        ["Special"] = "2-3 tanks for taunt rotation. AoE worms immediately. Nature Protection Potions. Healers rotate on debuffed tank."
    },
    ["Viscidus"] = {
        ["Tanks"] = "Tank Viscidus center. He must be frozen (frost hits) then shattered (physical hits). 3 phases per kill attempt.",
        ["Healers"] = "Heal through Poison Bolt Volley. When Viscidus shatters, adds spawn - heal tanks grabbing blobs.",
        ["Casters"] = "Frost mages spam Frostbolt to freeze boss (200 hits). Then melee shatters (50 hits). Repeat 3 times.",
        ["Melee"] = "Attack when boss is frozen. Need 50 melee hits to shatter. Kill blobs after shatter. Nature Protection Potions.",
        ["Special"] = "Need ~15 frost mages. Freeze (200 frost hits) → Shatter (50 melee hits) → Kill blobs. Repeat 3 times. Nature resist gear."
    },
    ["Princess Huhuran"] = {
        ["Tanks"] = "Tank Huhuran. At 30%, she enrages - burn her fast. Berserk at 5 minutes hard enrage.",
        ["Healers"] = "Heal through Noxious Poison stacks. At 30%, spam heal raid - she goes berserk.",
        ["Casters"] = "DPS to 31%, then wait for cooldowns. Burn 30%→0% in 30 seconds. Nature Protection Potions mandatory.",
        ["Melee"] = "DPS to 31%, hold. Pop all cooldowns at 30%, burn her down. Greater Nature Protection Potion at 30%.",
        ["Special"] = "30% soft enrage, 5min hard enrage. Hold DPS at 31%, pop all CDs at 30% and burn. Full nature resist gear + potions."
    },
    ["Twin Emperors"] = {
        ["Tanks"] = "Tank Vek'lor (caster) with melee, Vek'nilash (melee) with casters. Bosses teleport every 45s - tanks swap sides.",
        ["Healers"] = "Heal both tanks. During teleport, rebuff and heal. Dispel Arcane Burst. Shadow Protection Potions for caster side.",
        ["Casters"] = "DPS Vek'nilash (melee boss). Stand on caster platform. Swap sides when bosses teleport. Arcane Protection Potions.",
        ["Melee"] = "DPS Vek'lor (caster boss). Stand on melee platform. Swap sides on teleport. Shadow Protection Potions.",
        ["Special"] = "2 tank teams (warlock + warrior for each boss). Melee DPS caster boss, ranged DPS melee boss. Teleport every 45s. Shadow + Arcane pots."
    },
    ["Ouro"] = {
        ["Tanks"] = "Tank Ouro above ground. He submerges every 90s - off-tanks grab sandblast worms. Move raid away from Dirt Mounds.",
        ["Healers"] = "Heal through Sweep (frontal AoE). When submerged, heal worm tanks. Watch for Sandblast (stun + bleed).",
        ["Casters"] = "DPS Ouro above ground. When submerged, kill worms. Spread out - Ground Rupture spawns under players.",
        ["Melee"] = "DPS from behind. Move away from Dirt Mounds (predict where Ouro surfaces). Nature Protection Potions.",
        ["Special"] = "Ouro surfaces every 90s. Kill worms during submerge. Move raid away from Dirt Mounds. Nature resist gear + potions."
    },
    ["C'Thun"] = {
        ["Tanks"] = "Phase 1: No tank needed. Phase 2: Tank C'Thun body, off-tanks grab Giant Claws/Eyes. Move boss away from tentacles.",
        ["Healers"] = "Phase 1: Heal eye beam targets. Don't get chained. Phase 2: Heal tanks, dispel weakened players from stomach group.",
        ["Casters"] = "Phase 1: Kill eye tentacles. Focus Giant Eye Tentacles. Phase 2: DPS body, kill Giant Claws fast.",
        ["Melee"] = "Phase 1: Kill tentacles. If swallowed, DPS stomach tentacles to escape. Phase 2: DPS C'Thun body from behind.",
        ["Special"] = "Phase 1: Kill tentacles, avoid eye beam chains. Dark Glare wipes raid if channeled. Phase 2: Players randomly swallowed into stomach - DPS tentacles to escape. Shadow + Nature pots."
    }
}

-- ============================================================================
-- NAXXRAMAS
-- ============================================================================
SS_TacticsDB["Naxx"] = {
    ["Anub'Rekhan"] = {
        ["Tanks"] = "Tank Anub'Rekhan center. At 1000 mana, he Impales raid - run out of melee range. Off-tanks grab spawned beetles.",
        ["Healers"] = "Heal through Locust Swarm damage. Dispel beetles' poison stacking DoT. Call out Impale - everyone run out.",
        ["Casters"] = "Kill crypt guards (beetles) fast - they stack poison. DPS boss between Locust Swarms.",
        ["Melee"] = "Attack from behind. Run out when Impale called. Kill beetles immediately when they spawn.",
        ["Special"] = "Off-tank beetles. Run out at 1000 mana (Impale). Locust Swarm every 90s. Nature resist gear helps."
    },
    ["Grand Widow Faerlina"] = {
        ["Tanks"] = "Tank Faerlina. Mind Control one Worshipper add per Frenzy. Frenzy = boss enrage, MC Worshipper to remove it.",
        ["Healers"] = "Heal through Rain of Fire. Silence Follower adds' Silence spell. Big heals during Frenzy if MC fails.",
        ["Casters"] = "Priests: Mind Control Worshippers, DPS them to low HP before pull. Keep MC ready for Frenzy. Kill Followers first.",
        ["Melee"] = "DPS boss. Interrupt Followers' Shadow Bolt. Kill MC'd Worshipper when Frenzy happens.",
        ["Special"] = "3 Priests MC Worshippers. At Frenzy, kill MC'd Worshipper to remove enrage. 4 Worshippers = 4 Frenzies to survive."
    },
    ["Maexxna"] = {
        ["Tanks"] = "Tank Maexxna. She Web Wraps 3 players (cocoon on wall) every 40s. DPS wraps fast. Taunt when tank is wrapped.",
        ["Healers"] = "Heal through Web Spray (raid-wide stun). Heal cocoons fast - wrapped players take DoT. Pre-HoT before Web Spray.",
        ["Casters"] = "Kill web wraps immediately - wrapped players die in 60s. Ranged burn wraps, melee DPS boss.",
        ["Melee"] = "Attack from behind. Move to wraps when called. Web Spray stuns everyone - can't do anything for 6s.",
        ["Special"] = "Web Spray every 40s (6s stun). 3 players wrapped - save them fast. Enrage at 10min. Nature pots help."
    },
    ["Noth the Plaguebringer"] = {
        ["Tanks"] = "Tank Noth center. He teleports every 90s - kill skeletons during teleport phase. He returns after 70s.",
        ["Healers"] = "Heal through Curse of the Plaguebringer (raid DoT). Teleport phase: heal through skeleton waves.",
        ["Casters"] = "DPS Noth. When he teleports, AoE skeletons. Plague waves spawn periodically - kill them.",
        ["Melee"] = "Burn Noth. Switch to skeletons during teleport phase. Stay spread for Blink.",
        ["Special"] = "3 teleport phases. Kill skeletons fast each phase. Decurse Curse of Plaguebringer. Long fight."
    },
    ["Heigan the Unclean"] = {
        ["Tanks"] = "Tank Heigan on platform. Follow the dance pattern (avoid erupting floor sections). Don't miss a step - instant death.",
        ["Healers"] = "Heal through Plague Cloud damage. Follow dance pattern perfectly. Pre-HoT before Decrepit Fever ticks.",
        ["Casters"] = "DPS from platform. Learn dance pattern - move in waves, left/right. Teleport phase: dance faster, ranged DPS him.",
        ["Melee"] = "Dance pattern is key. Phase 1: slow dance. Phase 2 (teleport): fast dance. One mistake = death.",
        ["Special"] = "Safety Dance achievement = everyone survives floor eruptions. Practice dance pattern. Nature pots for Plague Cloud."
    },
    ["Loatheb"] = {
        ["Tanks"] = "Tank Loatheb. Deathbloom aura = healing only works every 60s (5s window). Coordinate tank cooldowns for 55s gaps.",
        ["Healers"] = "Heal ONLY during 5s windows every 60s. Pre-HoT before window closes. Corrupted Mind buffs increase healing/crit.",
        ["Casters"] = "DPS race. Kill spores for +50% crit buff (Corrupted Mind). Consume stacks before healing window for max healing buff.",
        ["Melee"] = "Burn boss. Grab spores for crit buff. Save health pots for between heal windows.",
        ["Special"] = "3 spores spawn every 20s. Rotate classes to get spores (healers → tanks → DPS). Heal only during 5s windows. Shadow pots."
    },
    ["Instructor Razuvious"] = {
        ["Tanks"] = "Priests Mind Control two Understudies - they tank Razuvious. Rotate MC (1min duration). No player tank possible.",
        ["Healers"] = "Heal MC'd Understudies (they are the tanks). Rotate MC priests every 60s. Shield tanks before Disrupting Shout.",
        ["Casters"] = "4 Priests on MC rotation (2 active, 2 backup). MC Understudies, use Taunt and Shield abilities. DPS boss.",
        ["Melee"] = "DPS Razuvious from behind. Stay away from Understudy tanks. Watch Disrupting Shout (AoE silence).",
        ["Special"] = "Requires 4 Priests for MC rotation. MC lasts 1min, no heal/buff during MC. Backup priest must taunt fast."
    },
    ["Gothik the Harvester"] = {
        ["Tanks"] = "Phase 1: Tank undead on live side (left), rider adds on undead side (right). Gate opens at 4:30 - sides merge.",
        ["Healers"] = "Phase 1: Split healers both sides. Kill live side mobs, ghosts spawn on dead side. Phase 2: Heal center tank.",
        ["Casters"] = "Phase 1: Kill mobs on your side. Unbalanced DPS = one side overwhelmed. Phase 2: Burn Gothik center.",
        ["Melee"] = "Split raid left/right. Kill live mobs → they spawn as ghosts on dead side. Balance DPS or wipe.",
        ["Special"] = "Gate opens at 4:30. Live side → dead side spawns. Balance kills or one side wipes. Shackle undead to help."
    },
    ["The Four Horsemen"] = {
        ["Tanks"] = "8 tanks rotate on 4 bosses. Marks stack (4 stacks = death). Rotate tanks every 3 marks. Complex positioning fight.",
        ["Healers"] = "Heal through Meteor (Mograine). Dispel Void Zone (Blaumeux). Watch mark stacks on tanks - rotate heals.",
        ["Casters"] = "DPS boss call-outs. Move to assigned positions on mark rotations. Shadow Protection Potions.",
        ["Melee"] = "Focus called boss. Rotate positions with tanks. Watch mark stacks (4 = death). Complex dance.",
        ["Special"] = "8 tanks (2 per boss). Marks last 75s, stack up to 4 (then death). Rotate tanks every 3 marks. Hard coordination fight."
    },
    ["Patchwerk"] = {
        ["Tanks"] = "3-4 tank rotation. Hateful Strike hits second-highest threat. Off-tanks stack behind main tank. HP > 7500 required for off-tanks.",
        ["Healers"] = "Hardest healing check in game. Main tank takes 30k+ DPS. Rotate healer cooldowns. Flash Heal spam.",
        ["Casters"] = "Pure DPS burn. 6-minute enrage. Threat not an issue - Hateful Strike hits off-tanks.",
        ["Melee"] = "Burn hard. Stay above 7500 HP (or you get Hateful Strike). Pop health pots on cooldown.",
        ["Special"] = "3-4 tanks (1 main, 3 off-tanks behind with HP > 7500). Healing check boss. 6min enrage. Full consumables."
    },
    ["Grobbulus"] = {
        ["Tanks"] = "Kite Grobbulus around room. Slime Spray spawns clouds - move boss away. Don't walk through clouds.",
        ["Healers"] = "Heal through Mutating Injection. When you get injected, run to safe spot - you explode into poison cloud. Call it out.",
        ["Casters"] = "DPS while moving with raid. Avoid poison clouds. If you get Mutating Injection, run to designated drop spot.",
        ["Melee"] = "Attack from behind while kiting. Drop Injection clouds at safe spots. Don't overlap clouds.",
        ["Special"] = "Kite boss clockwise. Injection = 10s then explosion into poison cloud. Mark safe spots for cloud drops. Nature pots."
    },
    ["Gluth"] = {
        ["Tanks"] = "Main tank holds Gluth center. Off-tank kites zombie adds around room. Do NOT let zombies reach Gluth - he eats them and heals.",
        ["Healers"] = "Heal main tank through Mortal Wound stacks. Heal zombie kiter. Decimate every 90s drops everyone to 5% HP - spam heals.",
        ["Casters"] = "Kill zombies on kiter before Gluth Decimates. Slow/snare zombies. After Decimate, AoE remaining zombies.",
        ["Melee"] = "DPS Gluth. Help kill zombies before Decimate. After Decimate, burn zombies fast before Gluth eats them.",
        ["Special"] = "Decimate every 90s = entire raid goes to 5% HP. Zombie kiter must keep zombies away. AoE zombies after Decimate."
    },
    ["Thaddius"] = {
        ["Tanks"] = "Tank Thaddius center. Stalagg and Feugen charge tanks with + or - polarity. Touch opposite polarity = chain explosion.",
        ["Healers"] = "Phase 1: Heal both mini-boss tanks. Phase 2: Heal through Polarity Shift raid damage. Watch your polarity debuff.",
        ["Casters"] = "Phase 1: Burn mini-bosses evenly, must die within 5s. Phase 2: Stack with your polarity (+ or -), DPS Thaddius.",
        ["Melee"] = "Phase 1: Kill Stalagg and Feugen together. Phase 2: Jump to your polarity side fast (5s or wipe). DPS boss.",
        ["Special"] = "Phase 1: Kill mini-bosses within 5s. Phase 2: Polarity Shift every 30s - move to correct side instantly. + on left, - on right."
    },
    ["Sapphiron"] = {
        ["Tanks"] = "Tank Sapphiron. During Air Phase, he Ice Blocks 5 players - hide behind ice blocks for Frost Breath (LoS). Ground phase: normal tank.",
        ["Healers"] = "Heal through Life Drain (heals boss, damages raid). Air Phase: hide behind ice blocks fast. Dispel Chill debuff quickly.",
        ["Casters"] = "Ground Phase: DPS boss. Air Phase: position behind ice block for Frost Breath (blocks LoS). Frost resist gear 200+.",
        ["Melee"] = "Attack from behind. Air Phase: run to ice blocks. Ground Phase: DPS hard. Greater Frost Protection Potion mandatory.",
        ["Special"] = "Air Phase: 5 players ice blocked. Everyone hide behind blocks for Frost Breath. Ground Phase: DPS. 200+ frost resist + potions."
    },
    ["Kel'Thuzad"] = {
        ["Tanks"] = "Tank Kel'Thuzad center. Phase 1: tank skeletons and abominations. Phase 2: tank adds. Phase 3: burn boss, adds keep spawning.",
        ["Healers"] = "Heal through Frost Blast chains. Detonate Mana on target player (massive AoE) - everyone spread. Shadow Fissure moves - dodge it.",
        ["Casters"] = "Phase 1: Kill adds. Phase 2: Burn boss fast. Mind Control breaks are critical. Phase 3: Nuke boss while adds spawn.",
        ["Melee"] = "Phase 1: Focus adds. Phase 2: DPS Kel'Thuzad. Phase 3: Burn boss, off-tanks handle adds. Frost Protection Potions.",
        ["Special"] = "Phase 1 (5min): Kill waves. Phase 2: Burn KT. Phase 3: Guardian spawns every 5 attempts. Frost Blast chains = spread. Shadow + Frost pots."
    }
}

-- ============================================================================
-- KARAZHAN 40
-- ============================================================================
SS_TacticsDB["Kara40"] = {
    ["Attumen the Huntsman"] = {
        ["Tanks"] = "Tank Attumen and Midnight separately. At 95% Attumen mounts Midnight - tank merged boss. Taunt swap on Intangible Presence stacks.",
        ["Healers"] = "Heal through Intangible Presence stacks (shadow DoT). When mounted, heal merged form heavily.",
        ["Casters"] = "DPS Midnight to 95%, then Attumen mounts. Burn merged form. Shadow Protection Potions.",
        ["Melee"] = "Focus Midnight, then merged boss. Stay behind boss. Pop health pots on heavy swings.",
        ["Special"] = "Kill Midnight to 95% → Attumen mounts → burn merged boss. Shadow pots help."
    },
    ["Moroes"] = {
        ["Tanks"] = "Tank Moroes and 4 adds separately. Moroes Garrotes random players (bleed DoT). Off-tanks grab adds, don't let them reach healers.",
        ["Healers"] = "Remove Garrote with abolish poison/disease abilities. Heal through Gouge stuns on main tank.",
        ["Casters"] = "CC 2 adds (poly, trap, shackle). Kill order: adds first, then Moroes. Interrupt caster adds.",
        ["Melee"] = "Focus called add. Moroes Blinds and Gouges - watch threat. Kill adds before burning boss.",
        ["Special"] = "CC 2 of 4 adds. Kill remaining 2, then Moroes. Garrote stacks - remove fast. Shadow pots."
    },
    ["Maiden of Virtue"] = {
        ["Tanks"] = "Tank Maiden center. Holy Fire damages random players. Holy Ground (consecration) deals AoE - spread out.",
        ["Healers"] = "Heal through Holy Fire. Repentance every 30s (raid-wide incapacitate) - can't heal for 8s. Pre-HoT before Repentance.",
        ["Casters"] = "DPS from range. Spread for Holy Fire. Stop casting before Repentance (8s stun).",
        ["Melee"] = "Attack from behind. Spread out. Repentance stuns entire raid every 30s.",
        ["Special"] = "Repentance every 30s = 8s raid stun. Pre-HoT before it. Holy Protection Potions help."
    },
    ["Opera Event"] = {
        ["Tanks"] = "Random event: Wizard of Oz, Big Bad Wolf, or Romulo & Julianne. Each has different mechanics.",
        ["Healers"] = "Oz: Dispel cyclones. Wolf: Heal Red Riding Hood (transforms random player). R&J: Heal both tanks.",
        ["Casters"] = "Oz: Kill Roar, then Strawman, then Tinhead, then Crone. Wolf: DPS boss, save turned player. R&J: Burn both evenly.",
        ["Melee"] = "Follow kill orders. Wolf: DPS while kiting turned player. R&J: Kill both within 10s of each other.",
        ["Special"] = "Three possible events. Check which one before pull. Adjust strategy accordingly."
    },
    ["Curator"] = {
        ["Tanks"] = "Tank Curator. At 10% mana, he Evocates (channels, restores mana). Flare adds spawn during fight - burn them fast.",
        ["Healers"] = "Heal through Hateful Bolt (arcane damage on random player). Heal Flare tanks - adds hit hard.",
        ["Casters"] = "DPS Curator. When Flares spawn, burn them immediately. Arcane Protection Potions help.",
        ["Melee"] = "Focus Flares when they spawn, then back to Curator. Interrupt Evocation if possible.",
        ["Special"] = "Flares spawn every 10s. Off-tanks grab them, DPS burn them. Arcane pots. 10-minute enrage."
    },
    ["Shade of Aran"] = {
        ["Tanks"] = "No tank needed. Don't move during Flame Wreath (red circles) or raid explodes. Stand still until it fades.",
        ["Healers"] = "Heal through Arcane Missiles. Don't move during Flame Wreath. Counterspell Polymorph if possible.",
        ["Casters"] = "DPS from range. Flame Wreath = FREEZE, don't move. Blizzard phase: run to center. Arcane pots.",
        ["Melee"] = "Don't attack during Flame Wreath. Run out during Blizzard. Return when safe.",
        ["Special"] = "Flame Wreath = DON'T MOVE. Blizzard = run center. Polymorph = interrupt. Mass Slow = accept it. Arcane pots mandatory."
    },
    ["Terestian Illhoof"] = {
        ["Tanks"] = "Tank Illhoof. Kill Demon Chains on Sacrificed player fast - they die if chains not broken. Off-tank grabs Imp adds.",
        ["Healers"] = "Heal Sacrificed player through portal damage. Heal imp tank. Spread healing to raid for Shadowbolts.",
        ["Casters"] = "Kill Demon Chains immediately when player sacrificed. AoE imps. Then DPS boss.",
        ["Melee"] = "Burn chains to save sacrificed player. Help kill imps. Focus boss after.",
        ["Special"] = "Demon Chains every 45s on random player. Kill chains fast or they die. Off-tank kites imps. Shadow pots."
    },
    ["Netherspite"] = {
        ["Tanks"] = "Three beams connect Netherspite to portals. Players soak beams (buffs player, debuffs boss). Rotate soakers - stacking debuff.",
        ["Healers"] = "Heal beam soakers - they take damage. Rotate healers on beams. Nether Burn stacks = more damage taken.",
        ["Casters"] = "Soak beams in rotation. Red beam = DPS takes. Blue beam = mana users take. Green beam = tanks take.",
        ["Melee"] = "DPS boss. Avoid void zones. Help soak beams when assigned.",
        ["Special"] = "Red beam (DPS buff), Blue beam (mana buff), Green beam (tank buff). Rotate soakers every 20s. Nether Burn stacks hurt. Shadow pots."
    },
    ["Chess Event"] = {
        ["Tanks"] = "Control pieces via consoles. King = main tank piece. Protect King at all costs - if King dies, wipe.",
        ["Healers"] = "Heal King piece. Use healing pieces to support. Coordinate cooldowns.",
        ["Casters"] = "Control caster pieces. Nuke enemy King. Use AoE pieces on enemy back line.",
        ["Melee"] = "Control melee pieces. Protect your King. Focus enemy King when able.",
        ["Special"] = "Strategy game. Protect King. Kill enemy King. Coordinate piece movements. Random but manageable."
    },
    ["Prince Malchezaar"] = {
        ["Tanks"] = "Tank Prince. Phase 2 (60%): Axes spawn - off-tanks grab them. Phase 3 (30%): Infernals fall from sky - move raid away.",
        ["Healers"] = "Heal through Enfeeble (reduces entire raid to 1 HP, then restores after 8s). Shadow Word: Pain on random players - dispel.",
        ["Casters"] = "DPS Prince. Phase 1: normal. Phase 2: Off-tanks grab axes. Phase 3: Dodge falling infernals while DPSing.",
        ["Melee"] = "Attack from behind. Enfeeble drops you to 1 HP - don't take damage for 8s. Dodge infernals.",
        ["Special"] = "Enfeeble every 30s = entire raid 1 HP for 8s. Phase 3: Infernals fall randomly - move raid. Shadow + physical pots."
    }
}

-- ============================================================================
-- KARAZHAN 10
-- ============================================================================
SS_TacticsDB["Kara10"] = {
    ["Attumen the Huntsman"] = {
        ["Tanks"] = "Tank Attumen and Midnight separately until 95%, then tank merged form. Taunt swap on Intangible Presence.",
        ["Healers"] = "Heal through shadow DoT stacks. Merged form hits harder - focus tank heals.",
        ["Casters"] = "Kill Midnight to 95%, then burn merged boss. Shadow Protection Potions.",
        ["Melee"] = "DPS Midnight, then merged form. Stay behind boss.",
        ["Special"] = "Smaller raid, same mechanics as 40-man. Shadow pots help."
    },
    ["Moroes"] = {
        ["Tanks"] = "Tank Moroes and adds. CC 2-3 adds (only 10 players available).",
        ["Healers"] = "Remove Garrote bleeds. Heal through Gouge stuns.",
        ["Casters"] = "CC adds (poly 1-2, shackle/trap 1). Kill free adds, then Moroes.",
        ["Melee"] = "Focus called add. Watch Blind/Gouge on threat.",
        ["Special"] = "CC 2-3 of 4 adds. Kill remaining, then Moroes. Remove Garrote fast."
    },
    ["Maiden of Virtue"] = {
        ["Tanks"] = "Tank center. Holy Ground AoE damage - spread out.",
        ["Healers"] = "Pre-HoT before Repentance (8s stun). Heal Holy Fire targets.",
        ["Casters"] = "DPS from range. Stop casting before Repentance.",
        ["Melee"] = "Spread out. Accept 8s stun every 30s.",
        ["Special"] = "Repentance = raid-wide 8s stun. Pre-heal before it."
    },
    ["Opera Event"] = {
        ["Tanks"] = "Random: Oz, Wolf, or R&J. Adjust tactics per event.",
        ["Healers"] = "Oz: Dispel. Wolf: Heal turned player. R&J: Dual tank heals.",
        ["Casters"] = "Oz: Kill order matters. Wolf: Save turned player. R&J: Burn evenly.",
        ["Melee"] = "Follow kill orders per event.",
        ["Special"] = "Three random events - same as 40-man but scaled."
    },
    ["Curator"] = {
        ["Tanks"] = "Tank Curator and Flare adds. Smaller raid = fewer adds.",
        ["Healers"] = "Heal through Hateful Bolts. Flare add tank needs focus.",
        ["Casters"] = "Burn Flares immediately. Arcane Protection Potions.",
        ["Melee"] = "Kill Flares, then Curator. Interrupt Evocation.",
        ["Special"] = "Flares every 10s. Burn them fast. 10min enrage."
    },
    ["Shade of Aran"] = {
        ["Tanks"] = "No tank. Don't move during Flame Wreath.",
        ["Healers"] = "Heal Arcane Missiles. Freeze during Flame Wreath.",
        ["Casters"] = "Flame Wreath = DON'T MOVE. Blizzard = run center.",
        ["Melee"] = "Don't attack during Wreath. Run from Blizzard.",
        ["Special"] = "Same mechanics as 40-man. Flame Wreath = freeze. Arcane pots."
    },
    ["Terestian Illhoof"] = {
        ["Tanks"] = "Tank boss and imps. Chains on sacrificed player = top priority.",
        ["Healers"] = "Heal sacrificed player. Heal imp tank.",
        ["Casters"] = "Kill chains immediately. AoE imps.",
        ["Melee"] = "Burn chains to save player. Then imps, then boss.",
        ["Special"] = "Chains = priority. Kill fast or player dies. Shadow pots."
    },
    ["Netherspite"] = {
        ["Tanks"] = "Soak green beam. Rotate soakers due to stacking debuff.",
        ["Healers"] = "Heal beam soakers. Rotate onto beams yourself.",
        ["Casters"] = "Soak red/blue beams. Rotate every 20s due to debuff.",
        ["Melee"] = "DPS boss. Help soak beams when assigned.",
        ["Special"] = "Red/Blue/Green beams. Rotate soakers. Shadow pots."
    },
    ["Chess Event"] = {
        ["Tanks"] = "Control King piece. Protect it - King dies = wipe.",
        ["Healers"] = "Heal King. Control healing pieces.",
        ["Casters"] = "Control caster pieces. Nuke enemy King.",
        ["Melee"] = "Control melee pieces. Protect King.",
        ["Special"] = "Strategy game. Protect King, kill enemy King."
    },
    ["Prince Malchezaar"] = {
        ["Tanks"] = "Tank Prince. Phase 2: grab axes. Phase 3: dodge infernals.",
        ["Healers"] = "Heal through Enfeeble (entire raid 1 HP for 8s).",
        ["Casters"] = "DPS Prince. Dodge infernals in Phase 3.",
        ["Melee"] = "Attack from behind. Don't take damage during Enfeeble.",
        ["Special"] = "Enfeeble every 30s = raid at 1 HP. Dodge infernals."
    }
}

-- ============================================================================
-- EMERALD SANCTUM
-- ============================================================================
SS_TacticsDB["ES"] = {
    ["Primalist Thurloga"] = {
        ["Tanks"] = "Tank boss. Interrupt Shadow Bolt Volley. Taunt swap on stacking debuff.",
        ["Healers"] = "Heal through Curse of Weakness. Dispel curses fast.",
        ["Casters"] = "Nuke boss. Interrupt Shadow Bolt Volley. Shadow Protection Potions.",
        ["Melee"] = "DPS from behind. Pop health pots as needed.",
        ["Special"] = "Shadow damage heavy. Shadow Protection Potions recommended."
    },
    ["Summoner Sardon"] = {
        ["Tanks"] = "Tank boss and demon adds. Kill adds before boss.",
        ["Healers"] = "Heal through Immolate DoTs. Dispel fire effects.",
        ["Casters"] = "Kill adds first (imps/felguards). Then burn boss.",
        ["Melee"] = "Focus called add. Switch to boss when adds dead.",
        ["Special"] = "Adds spawn throughout fight. Kill them fast. Fire pots help."
    },
    ["High Priestess Jeklik"] = {
        ["Tanks"] = "Tank boss. During bat phase, she flies - kill bat adds.",
        ["Healers"] = "Heal through Psychic Scream fear. Shadow Word: Pain on random players.",
        ["Casters"] = "DPS boss in ground phase. Kill bats in air phase.",
        ["Melee"] = "Burn boss on ground. Switch to bats when she flies.",
        ["Special"] = "Bat phase every 50%. Kill bats, she lands. Shadow pots."
    },
    ["Ysondre"] = {
        ["Tanks"] = "Tank Ysondre. Taunt swap on stacking nature DoT. Off-tanks grab spawned drakes.",
        ["Healers"] = "Heal through Noxious Breath. Cure poison on Lightning Wave targets.",
        ["Casters"] = "Kill drakes when they spawn. Focus Ysondre otherwise. Nature Protection Potions.",
        ["Melee"] = "DPS boss. Help kill drakes. Stay spread for Lightning Wave.",
        ["Special"] = "Drakes spawn at 75%/50%/25%. Kill them fast. Nature pots mandatory."
    }
}

-- ============================================================================
-- AQ20
-- ============================================================================
SS_TacticsDB["AQ20"] = {
    ["Kurinnaxx"] = {
        ["Tanks"] = "Tank boss. Mortal Wound stacks reduce healing - taunt swap at 3-4 stacks.",
        ["Healers"] = "Heal through stacking Mortal Wound. Wide Slash does raid damage.",
        ["Casters"] = "Nuke boss. Stay spread for Sand Trap (roots + damage).",
        ["Melee"] = "DPS from behind. Avoid Wide Slash frontal cone.",
        ["Special"] = "2 tanks for taunt swaps. Nature pots help with Sand Trap."
    },
    ["General Rajaxx"] = {
        ["Tanks"] = "Tank boss and waves of adds. 7 waves before Rajaxx spawns.",
        ["Healers"] = "Heal through Thundercrash (AoE knock-up). Long fight, manage mana.",
        ["Casters"] = "AoE waves. Focus captains. Save cooldowns for Rajaxx.",
        ["Melee"] = "Kill waves. Burn captains fast. Rajaxx at wave 8.",
        ["Special"] = "7 waves of adds, then Rajaxx. Kill captains first each wave."
    },
    ["Moam"] = {
        ["Tanks"] = "Tank Moam. At 0 mana, he transforms into stone form (immune, spawns adds).",
        ["Healers"] = "Drain his mana fast with mana burns. Heal stone form add tanks.",
        ["Casters"] = "Mana burn boss to trigger stone form. Kill adds during stone form. Arcane pots.",
        ["Melee"] = "DPS boss. Switch to adds during stone form.",
        ["Special"] = "Drain mana → stone form → kill adds → repeat. Arcane pots help."
    },
    ["Buru the Gorger"] = {
        ["Tanks"] = "Kite Buru over egg piles. Eggs explode when Buru walks over them, damaging him and stunning him briefly.",
        ["Healers"] = "Heal kiting tank. Heal through Creeping Plague stacking DoT.",
        ["Casters"] = "Nuke Buru when he's stunned by egg explosions. Lure him over eggs.",
        ["Melee"] = "DPS during egg stuns. Help kite boss over eggs.",
        ["Special"] = "Kite boss over eggs to stun him and deal damage. Nature pots for Plague."
    },
    ["Ayamiss the Hunter"] = {
        ["Tanks"] = "Tank spawned wasps. Ayamiss flies above - ranged DPS only phase 1.",
        ["Healers"] = "Heal through wasp swarms. Paralyze on random players - dispel stuns.",
        ["Casters"] = "Ranged DPS Ayamiss while she flies. Kill wasps. At 70% she lands - burn her.",
        ["Melee"] = "Kill wasps during air phase. DPS boss when she lands.",
        ["Special"] = "Air phase until 70%. Ranged DPS only. Lands at 70% - burn fast."
    },
    ["Ossirian the Unscarred"] = {
        ["Tanks"] = "Tank Ossirian near crystals. He has random Supreme Mode (element buff) - use matching crystal to remove it.",
        ["Healers"] = "Heal through Curse of Tongues. Remove curses. Supreme Mode hits hard - pop cooldowns.",
        ["Casters"] = "DPS boss. When Supreme Mode activates, someone activates matching crystal (Fire/Frost/Arcane/Shadow/Nature).",
        ["Melee"] = "Attack from behind. Help activate crystals when called. Matching resist pot for active Supreme Mode.",
        ["Special"] = "Supreme Mode = random element buff. Click matching crystal to remove. Resist pots match active element."
    }
}

-- ============================================================================
-- ZULGURIB
-- ============================================================================
SS_TacticsDB["ZG"] = {
    ["High Priestess Jeklik"] = {
        ["Tanks"] = "Tank Jeklik. Bat phase: she flies, spawn bat adds - off-tanks grab them.",
        ["Healers"] = "Heal through Psychic Scream fear. Remove Curse of Blood (healing reduction).",
        ["Casters"] = "Ground phase: DPS boss. Bat phase: Kill bats. Shadow Protection Potions.",
        ["Melee"] = "DPS boss on ground. Kill bats when she flies.",
        ["Special"] = "Bat phase at 75%/50%. Kill bats, she lands. Shadow pots recommended."
    },
    ["High Priest Venoxis"] = {
        ["Tanks"] = "Tank Venoxis. At 50% he transforms into snake - hits harder, casts Poison Cloud.",
        ["Healers"] = "Heal through Holy Wrath (AoE fire). Snake phase: cure poisons, heal heavy tank damage.",
        ["Casters"] = "Burn boss. Snake phase: nature pots for Poison Cloud.",
        ["Melee"] = "DPS from behind. Snake phase: greater nature pots mandatory.",
        ["Special"] = "50% = snake form. Heavy tank damage + poison clouds. Nature pots required."
    },
    ["High Priestess Mar'li"] = {
        ["Tanks"] = "Tank Mar'li. She spawns spider adds - off-tank grabs them.",
        ["Healers"] = "Dispel Poison Bolt DoT. Heal through spider adds' poison.",
        ["Casters"] = "Kill spider adds immediately. Then DPS boss. Nature pots.",
        ["Melee"] = "Burn adds, then boss. Watch for Enveloping Web (roots).",
        ["Special"] = "Spider adds spawn periodically. Kill them fast. Nature pots help."
    },
    ["Bloodlord Mandokir"] = {
        ["Tanks"] = "Tank Mandokir. He gains Threatening Gaze (fixate on random player) - that player must stop all actions or raid wipes.",
        ["Healers"] = "Heal tank. Watch for Threatening Gaze - stop healing that player. Rez killed players (boss levels up per death).",
        ["Casters"] = "DPS boss. If you get Threatening Gaze, STOP ALL ACTIONS immediately.",
        ["Melee"] = "Attack from behind. Threatening Gaze = freeze completely.",
        ["Special"] = "Threatening Gaze = stop everything or raid wipes. Boss levels up +1 per player death. Battle res critical."
    },
    ["Edge of Madness"] = {
        ["Tanks"] = "One of 4 random bosses. Check which one before pull.",
        ["Healers"] = "Gri'lek: dispel poison. Hazza'rah: heal charm. Renataki: heal bleeds. Wushoolay: heal lightning.",
        ["Casters"] = "Adjust DPS per boss. Gri'lek = nature pots. Hazza'rah = shadow pots.",
        ["Melee"] = "Follow boss mechanics. Different each week.",
        ["Special"] = "4 possible bosses (Gri'lek, Hazza'rah, Renataki, Wushoolay). Random weekly."
    },
    ["High Priest Thekal"] = {
        ["Tanks"] = "Tank Thekal and his 2 zealot adds. All 3 must die within 10s or they resurrect.",
        ["Healers"] = "Heal all 3 tanks. Tiger phase: heavy tank damage, heal through Frenzy.",
        ["Casters"] = "Burn all 3 evenly to 10%. Kill within 10s of each other. Tiger phase: nuke fast.",
        ["Melee"] = "DPS called target. Even them out, then burn all 3. Tiger phase: pop cooldowns.",
        ["Special"] = "Kill Thekal + 2 adds within 10s or they rez. Tiger phase after deaths - hits very hard."
    },
    ["High Priestess Arlokk"] = {
        ["Tanks"] = "Tank Arlokk. Panther phase: she vanishes, spawns panthers. Mark of Arlokk = fixate on player.",
        ["Healers"] = "Heal marked player (panthers chase them). Heal panther tanks.",
        ["Casters"] = "Kill panthers. When boss visible, burn her. Shadow pots.",
        ["Melee"] = "DPS panthers. Switch to boss when she appears.",
        ["Special"] = "Panther phase: kill adds. Mark of Arlokk = panthers chase marked player. Kite them."
    },
    ["Jin'do the Hexxer"] = {
        ["Tanks"] = "Tank Jin'do. Periodically teleports raid to spirit world - kill shades to return.",
        ["Healers"] = "Heal through Curse of Jin'do (mana drain). Banish Healing Totem (heals boss).",
        ["Casters"] = "Destroy Healing Totem immediately. Spirit world: kill shades fast to escape.",
        ["Melee"] = "DPS boss. Break totem. Spirit world: burn shades.",
        ["Special"] = "Destroy Healing Totem instantly (heals boss to full if left up). Spirit world teleports - kill shades to return."
    },
    ["Hakkar the Soulflayer"] = {
        ["Tanks"] = "Tank Hakkar center. Kill all 5 priest bosses before Hakkar or he gains their powers (much harder).",
        ["Healers"] = "Heal through Blood Siphon (raid-wide life drain, heals Hakkar). Dispel Corrupted Blood (disease, spreads to nearby players).",
        ["Casters"] = "DPS hard. Spread out for Corrupted Blood. Mind Control on random players - CC them.",
        ["Melee"] = "Attack from behind. Spread 10+ yards apart for Corrupted Blood. Nature pots for Poisonous Cloud.",
        ["Special"] = "Kill all 5 priests before Hakkar. Spread for Corrupted Blood (spreads like plague). Nature pots. Blood Siphon heals him - DPS race."
    }
}

-- ============================================================================
-- ONYXIA
-- ============================================================================
SS_TacticsDB["Ony"] = {
    ["Onyxia"] = {
        ["Tanks"] = "Phase 1: Tank Onyxia. Phase 2: She flies - no tank needed. Phase 3: Tank her again, face away from raid.",
        ["Healers"] = "Phase 1: Heal tank through Flame Breath. Phase 2: Heal raid from Fireball Barrage. Phase 3: Heavy tank healing + Deep Breath dodging.",
        ["Casters"] = "Phase 1: DPS boss. Phase 2: Kill whelps and guards. Phase 3: Nuke her fast before Deep Breaths wipe raid.",
        ["Melee"] = "Phase 1: Attack from behind (tail swipe knocks back). Phase 2: Kill adds. Phase 3: Burn boss, dodge Deep Breath.",
        ["Special"] = "Phase 1 (100-65%): Tank and spank. Phase 2 (65-40%): Air phase, kill adds. Phase 3 (40-0%): Burn fast, dodge Deep Breath. Greater Fire Protection Potion mandatory."
    }
}