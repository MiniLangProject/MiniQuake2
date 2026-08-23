/* Quake II 3.19 SP_monster_* sound precache inventories. */
package miniquake2.game.ai.sounds

import miniquake2.game.constants as soundconstants

noSounds = []
berserkSounds = ["berserk/attack.wav", "berserk/berdeth2.wav", "berserk/beridle1.wav",
  "berserk/berpain2.wav", "berserk/bersrch1.wav", "berserk/sight.wav", "misc/udeath.wav"]
gladiatorSounds = ["gladiator/glddeth2.wav", "gladiator/gldidle1.wav",
  "gladiator/gldpain2.wav", "gladiator/gldsrch1.wav", "gladiator/melee1.wav",
  "gladiator/melee2.wav", "gladiator/melee3.wav", "gladiator/pain.wav",
  "gladiator/railgun.wav", "gladiator/sight.wav", "misc/udeath.wav"]
gunnerSounds = ["gunner/death1.wav", "gunner/gunatck1.wav", "gunner/gunatck2.wav",
  "gunner/gunatck3.wav", "gunner/gunidle1.wav", "gunner/gunpain1.wav",
  "gunner/gunpain2.wav", "gunner/gunsrch1.wav", "gunner/sight1.wav", "misc/udeath.wav"]
infantrySounds = ["infantry/infatck1.wav", "infantry/infatck2.wav",
  "infantry/infatck3.wav", "infantry/infdeth1.wav", "infantry/infdeth2.wav",
  "infantry/infidle1.wav", "infantry/infpain1.wav", "infantry/infpain2.wav",
  "infantry/infsght1.wav", "infantry/infsrch1.wav", "infantry/melee2.wav", "misc/udeath.wav"]
soldierSounds = ["infantry/infatck3.wav", "misc/lasfly.wav", "misc/udeath.wav",
  "soldier/solatck1.wav", "soldier/solatck2.wav", "soldier/solatck3.wav",
  "soldier/soldeth1.wav", "soldier/soldeth2.wav", "soldier/soldeth3.wav",
  "soldier/solidle1.wav", "soldier/solpain1.wav", "soldier/solpain2.wav",
  "soldier/solpain3.wav", "soldier/solsght1.wav", "soldier/solsrch1.wav"]
tankSounds = ["misc/udeath.wav", "tank/death.wav", "tank/sight1.wav", "tank/step.wav",
  "tank/tnkatck1.wav", "tank/tnkatck3.wav", "tank/tnkatck4.wav", "tank/tnkatck5.wav",
  "tank/tnkatk2a.wav", "tank/tnkatk2b.wav", "tank/tnkatk2c.wav", "tank/tnkatk2d.wav",
  "tank/tnkatk2e.wav", "tank/tnkdeth2.wav", "tank/tnkidle1.wav", "tank/tnkpain2.wav"]
medicSounds = ["medic/idle.wav", "medic/medatck1.wav", "medic/medatck2.wav",
  "medic/medatck3.wav", "medic/medatck4.wav", "medic/medatck5.wav",
  "medic/meddeth1.wav", "medic/medpain1.wav", "medic/medpain2.wav",
  "medic/medsght1.wav", "medic/medsrch1.wav", "misc/udeath.wav"]
flipperSounds = ["flipper/flpatck1.wav", "flipper/flpatck2.wav", "flipper/flpdeth1.wav",
  "flipper/flpidle1.wav", "flipper/flppain1.wav", "flipper/flppain2.wav",
  "flipper/flpsght1.wav", "flipper/flpsrch1.wav", "misc/udeath.wav"]
chickSounds = ["chick/chkatck1.wav", "chick/chkatck2.wav", "chick/chkatck3.wav",
  "chick/chkatck4.wav", "chick/chkatck5.wav", "chick/chkdeth1.wav",
  "chick/chkdeth2.wav", "chick/chkfall1.wav", "chick/chkidle1.wav",
  "chick/chkidle2.wav", "chick/chkpain1.wav", "chick/chkpain2.wav",
  "chick/chkpain3.wav", "chick/chksght1.wav", "chick/chksrch1.wav", "misc/udeath.wav"]
parasiteSounds = ["misc/udeath.wav", "parasite/paratck1.wav", "parasite/paratck2.wav",
  "parasite/paratck3.wav", "parasite/paratck4.wav", "parasite/pardeth1.wav",
  "parasite/paridle1.wav", "parasite/paridle2.wav", "parasite/parpain1.wav",
  "parasite/parpain2.wav", "parasite/parsght1.wav", "parasite/parsrch1.wav"]
flyerSounds = ["flyer/flyatck1.wav", "flyer/flyatck2.wav", "flyer/flyatck3.wav",
  "flyer/flydeth1.wav", "flyer/flyidle1.wav", "flyer/flypain1.wav",
  "flyer/flypain2.wav", "flyer/flysght1.wav", "flyer/flysrch1.wav"]
brainSounds = ["brain/brnatck1.wav", "brain/brnatck2.wav", "brain/brnatck3.wav",
  "brain/brndeth1.wav", "brain/brnidle1.wav", "brain/brnidle2.wav",
  "brain/brnlens1.wav", "brain/brnpain1.wav", "brain/brnpain2.wav",
  "brain/brnsght1.wav", "brain/brnsrch1.wav", "brain/melee1.wav",
  "brain/melee2.wav", "brain/melee3.wav", "misc/udeath.wav"]
floaterSounds = ["floater/fltatck1.wav", "floater/fltatck2.wav", "floater/fltatck3.wav",
  "floater/fltdeth1.wav", "floater/fltidle1.wav", "floater/fltpain1.wav",
  "floater/fltpain2.wav", "floater/fltsght1.wav", "floater/fltsrch1.wav"]
hoverSounds = ["hover/hovatck1.wav", "hover/hovdeth1.wav", "hover/hovdeth2.wav",
  "hover/hovidle1.wav", "hover/hovpain1.wav", "hover/hovpain2.wav",
  "hover/hovsght1.wav", "hover/hovsrch1.wav", "hover/hovsrch2.wav", "misc/udeath.wav"]
mutantSounds = ["misc/udeath.wav", "mutant/mutatck1.wav", "mutant/mutatck2.wav",
  "mutant/mutatck3.wav", "mutant/mutdeth1.wav", "mutant/mutidle1.wav",
  "mutant/mutpain1.wav", "mutant/mutpain2.wav", "mutant/mutsght1.wav",
  "mutant/mutsrch1.wav", "mutant/step1.wav", "mutant/step2.wav",
  "mutant/step3.wav", "mutant/thud1.wav"]
supertankSounds = ["bosstank/btkdeth1.wav", "bosstank/btkengn1.wav",
  "bosstank/btkpain1.wav", "bosstank/btkpain2.wav", "bosstank/btkpain3.wav",
  "bosstank/btkunqv1.wav", "bosstank/btkunqv2.wav"]
boss2Sounds = ["bosshovr/bhvdeth1.wav", "bosshovr/bhvengn1.wav",
  "bosshovr/bhvpain1.wav", "bosshovr/bhvpain2.wav", "bosshovr/bhvpain3.wav",
  "bosshovr/bhvunqv1.wav", "misc/udeath.wav"]
jorgSounds = ["boss3/bs3atck1.wav", "boss3/bs3atck2.wav", "boss3/bs3deth1.wav",
  "boss3/bs3idle1.wav", "boss3/bs3pain1.wav", "boss3/bs3pain2.wav",
  "boss3/bs3pain3.wav", "boss3/bs3srch1.wav", "boss3/bs3srch2.wav",
  "boss3/bs3srch3.wav", "boss3/d_hit.wav", "boss3/step1.wav", "boss3/step2.wav",
  "boss3/w_loop.wav", "boss3/xfire.wav"]
makronSounds = ["makron/bfg_fire.wav", "makron/bhit.wav", "makron/brain1.wav",
  "makron/death.wav", "makron/pain1.wav", "makron/pain2.wav", "makron/pain3.wav",
  "makron/popup.wav", "makron/rail_up.wav", "makron/spine.wav", "makron/step1.wav",
  "makron/step2.wav", "makron/voice.wav", "makron/voice3.wav", "makron/voice4.wav",
  "misc/udeath.wav"]
insaneSounds = ["insane/insane1.wav", "insane/insane2.wav", "insane/insane3.wav",
  "insane/insane4.wav", "insane/insane5.wav", "insane/insane6.wav",
  "insane/insane7.wav", "insane/insane8.wav", "insane/insane9.wav",
  "insane/insane10.wav", "insane/insane11.wav", "misc/udeath.wav"]

function inline isSoldier(className)
  return className == "monster_soldier_light" or className == "monster_soldier" or
    className == "monster_soldier_ss"
end function

function inline hasSightCallback(className)
  return className == "monster_berserk" or className == "monster_gladiator" or
    className == "monster_gunner" or className == "monster_infantry" or
    isSoldier(className) or className == "monster_tank" or
    className == "monster_tank_commander" or className == "monster_medic" or
    className == "monster_flipper" or className == "monster_chick" or
    className == "monster_parasite" or className == "monster_flyer" or
    className == "monster_brain" or className == "monster_floater" or
    className == "monster_hover" or className == "monster_mutant" or
    className == "monster_makron"
end function

function inline hasSearchCallback(className)
  return className == "monster_berserk" or className == "monster_gladiator" or
    className == "monster_gunner" or className == "monster_medic" or
    className == "monster_brain" or className == "monster_hover" or
    className == "monster_mutant" or className == "monster_supertank" or
    className == "monster_boss2" or className == "monster_jorg"
end function

function inline sightUsesRandom(className)
  return isSoldier(className)
end function

function inline searchUsesRandom(className)
  return className == "monster_hover" or className == "monster_supertank" or
    className == "monster_boss2" or className == "monster_jorg"
end function

function sightName(className, roll)
  if className == "monster_berserk" then return "berserk/sight.wav" end if
  if className == "monster_gladiator" then return "gladiator/sight.wav" end if
  if className == "monster_gunner" then return "gunner/sight1.wav" end if
  if className == "monster_infantry" then return "infantry/infsght1.wav" end if
  if isSoldier(className) then
    if roll < 0.5 then return "soldier/solsght1.wav" end if
    return "soldier/solsrch1.wav"
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then return "tank/sight1.wav" end if
  if className == "monster_medic" then return "medic/medsght1.wav" end if
  if className == "monster_flipper" then return "flipper/flpsght1.wav" end if
  if className == "monster_chick" then return "chick/chksght1.wav" end if
  if className == "monster_parasite" then return "parasite/parsght1.wav" end if
  if className == "monster_flyer" then return "flyer/flysght1.wav" end if
  if className == "monster_brain" then return "brain/brnsght1.wav" end if
  if className == "monster_floater" then return "floater/fltsght1.wav" end if
  if className == "monster_hover" then return "hover/hovsght1.wav" end if
  if className == "monster_mutant" then return "mutant/mutsght1.wav" end if
  // Makron's sight callback installs its 13-frame active move without sound.
  return ""
end function

function sightChannel(className)
  if className == "monster_infantry" then return soundconstants.CHAN_BODY end if
  if className == "monster_parasite" then return soundconstants.CHAN_WEAPON end if
  return soundconstants.CHAN_VOICE
end function

function searchName(className, roll)
  if className == "monster_berserk" then return "berserk/bersrch1.wav" end if
  if className == "monster_gladiator" then return "gladiator/gldsrch1.wav" end if
  if className == "monster_gunner" then return "gunner/gunsrch1.wav" end if
  if className == "monster_medic" then return "medic/medsrch1.wav" end if
  if className == "monster_brain" then return "brain/brnsrch1.wav" end if
  if className == "monster_hover" then
    if roll < 0.5 then return "hover/hovsrch1.wav" end if
    return "hover/hovsrch2.wav"
  end if
  if className == "monster_mutant" then return "mutant/mutsrch1.wav" end if
  if className == "monster_supertank" then
    if roll < 0.5 then return "bosstank/btkunqv1.wav" end if
    return "bosstank/btkunqv2.wav"
  end if
  if className == "monster_boss2" then
    if roll < 0.5 then return "bosshovr/bhvunqv1.wav" end if
    return ""
  end if
  if className == "monster_jorg" then
    if roll <= 0.3 then return "boss3/bs3srch1.wav" end if
    if roll <= 0.6 then return "boss3/bs3srch2.wav" end if
    return "boss3/bs3srch3.wav"
  end if
  return ""
end function

function searchAttenuation(className)
  if className == "monster_boss2" then return soundconstants.ATTN_NONE end if
  if className == "monster_medic" then return soundconstants.ATTN_IDLE end if
  return soundconstants.ATTN_NORM
end function

function stockNames(className)
  if className == "monster_berserk" then return berserkSounds end if
  if className == "monster_gladiator" then return gladiatorSounds end if
  if className == "monster_gunner" then return gunnerSounds end if
  if className == "monster_infantry" then return infantrySounds end if
  if className == "monster_soldier_light" or className == "monster_soldier" or
      className == "monster_soldier_ss" then return soldierSounds end if
  if className == "monster_tank" or className == "monster_tank_commander" then return tankSounds end if
  if className == "monster_medic" then return medicSounds end if
  if className == "monster_flipper" then return flipperSounds end if
  if className == "monster_chick" then return chickSounds end if
  if className == "monster_parasite" then return parasiteSounds end if
  if className == "monster_flyer" then return flyerSounds end if
  if className == "monster_brain" then return brainSounds end if
  if className == "monster_floater" then return floaterSounds end if
  if className == "monster_hover" then return hoverSounds end if
  if className == "monster_mutant" then return mutantSounds end if
  if className == "monster_supertank" then return supertankSounds end if
  if className == "monster_boss2" then return boss2Sounds end if
  if className == "monster_jorg" then return jorgSounds end if
  if className == "monster_makron" then return makronSounds end if
  if className == "misc_insane" then return insaneSounds end if
  return noSounds
end function
