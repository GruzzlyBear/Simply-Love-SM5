local player = ...
local pn = ToEnumShortString(player)

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

-- note: only shows top score
local highScoreIndex = {
	Machine = stats:GetMachineHighScoreIndex(),
	Personal = stats:GetPersonalHighScoreIndex()
}

local EarnedMachineRecord  = (  highScoreIndex.Machine ~= -1 ) and stats:GetPercentDancePoints() >= 0.01
local EarnedPersonalRecord = ( highScoreIndex.Personal ~= -1 ) and stats:GetPercentDancePoints() >= 0.01

if not EarnedMachineRecord and not EarnedPersonalRecord then
	return Def.Actor{}
else

	-- else this player earned some record and the ability to enter a high score name
	-- we'll check for this flag, later, in ./BGAnimations/ScreenNameEntryTradtional underlay/default.lua
	SL[pn].HighScores.EnteringName = true

	-- record text
	local t = Def.ActorFrame{
		InitCommand=cmd(zoom, 0.3),
		OnCommand=function(self)
			self:x( (player == PLAYER_1 and 43) or 80 )
			self:y( 160 )
			self:horizalign (center)
		end
	}

	if EarnedMachineRecord then
		t[#t+1] = LoadFont("_big")..{
			Text=string.format("Machine Record %i", highScoreIndex.Machine+1),
			InitCommand=cmd(halign,0; xy,-110,-18; diffuse,color("#bdc3c7"); glowshift;effectcolor1,color("1,1,1,0"); effectcolor2,color("1,1,1,0.25")),
		}
	end

	if EarnedPersonalRecord then
		t[#t+1] = LoadFont("_big")..{
			Text=string.format("Personal Record %i", highScoreIndex.Personal+1),
			InitCommand=cmd(halign,0; xy,-110,24; diffuse,color("#bdc3c7"); glowshift;effectcolor1,color("1,1,1,0"); effectcolor2,color("1,1,1,0.25")),
		}
	end

	return t
end