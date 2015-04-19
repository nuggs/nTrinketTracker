local nTrinketTracker = CreateFrame("Frame");

function nTrinketTracker:PLAYER_LOGIN()
	nTrinketTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	nTrinketTracker:UnregisterEvent("PLAYER_LOGIN");
end

function nTrinketTracker:COMBAT_LOG_EVENT_UNFILTERED(...)
	local _, event, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, sourceID, _, _, spellID, spellName, spellSchool = ...
	local isDestEnemy = (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE);

	if bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		local enemy = UnitName(destGUID);

		if event == "SPELL_INTERRUPT" and UnitIsPlayer("target") and isDestEnemy then
			SendChatMessage(">>>> Interrupt "..GetSpellLink(spellID).." ["..destName.."] <<<<", "SAY");
		end

		if event=="SPELL_AURA_APPLIED" then
			spellId, spellName, spellSchool = select(12,...);
			if spellId == 42292 or spellId == 59752 then
				SendChatMessage("<<<< TRINKET USED! >>>>", "SAY");
			end
		end
	end

	if event == "SPELL_AURA_APPLIED" and isDestEnemy then
		spellId, spellName, spellSchool = select(12,...);
		if spellId == 42292 or spellId == 59752 then
			SendChatMessage(">>>> TRINKET USED ".." ["..destName.."] <<<<", "SAY");
		end
	end
end

nTrinketTracker:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end);
nTrinketTracker:RegisterEvent("PLAYER_LOGIN");