local kids, judgmentSet
local player = Var "Player"

local judType = SL[ToEnumShortString(player)].ActiveModifiers.JudgmentGraphic or "Love"

local JudgeCmds = {
	TapNoteScore_W1 = THEME:GetMetric( "Judgment", "JudgmentW1Command" ),
	TapNoteScore_W2 = THEME:GetMetric( "Judgment", "JudgmentW2Command" ),
	TapNoteScore_W3 = THEME:GetMetric( "Judgment", "JudgmentW3Command" ),
	TapNoteScore_W4 = THEME:GetMetric( "Judgment", "JudgmentW4Command" ),
	TapNoteScore_W5 = THEME:GetMetric( "Judgment", "JudgmentW5Command" ),
	TapNoteScore_Miss = THEME:GetMetric( "Judgment", "JudgmentMissCommand" )
}

local TNSFrames = {
	TapNoteScore_W1 = 0,
	TapNoteScore_W2 = 1,
	TapNoteScore_W3 = 2,
	TapNoteScore_W4 = 3,
	TapNoteScore_W5 = 4,
	TapNoteScore_Miss = 5
}


local t = Def.ActorFrame {
	InitCommand=cmd(fov,90),

	 Def.Sprite{
		Name="JudgmentWithOffsets",
		InitCommand=cmd(pause;visible,false),
		OnCommand=function(self)

			-- if we are on ScreenEdit, judgment font is always "Love"
			if string.match(tostring(SCREENMAN:GetTopScreen()),"ScreenEdit") then
				self:Load( THEME:GetPathG("", "_judgments/Love") )
			elseif judType == "None" then
				self:Load( THEME:GetPathG("", "_blank") )
			elseif judType == "3.9" then
				self:Load( THEME:GetPathG("", "_judgments/3_9"))
			else
				self:Load( THEME:GetPathG("", "_judgments/" .. judType) )
			end
		end,
		ResetCommand=cmd(finishtweening;x,0;y,0;stopeffect;visible,false)
	},

	InitCommand=function(self)
		kids = self:GetChildren()
		judgmentSet = kids.JudgmentWithOffsets
	end,
	JudgmentMessageCommand=function(self, param)
		if param.Player ~= player then return end
		if not param.TapNoteScore then return end
		if param.HoldNoteScore then return end

		-- frame check; actually relevant now.
		local iNumStates = judgmentSet:GetNumStates()
		local frame = TNSFrames[ param.TapNoteScore ]
		if not frame then return end
		if iNumStates == 12 then
			frame = frame * 2
			if not param.Early then
				frame = frame + 1
			end
		end
		self:playcommand("Reset")

		-- begin commands
		judgmentSet:visible( true )
		judgmentSet:y(-115)
		judgmentSet:setstate( frame )

		-- frame0 is like (-fantastic)
		-- frame1 is like (fantastic-)
		if frame == 0 or frame == 1 then
			judgmentSet:zoom(1)
		else
			judgmentSet:zoom(1)
		end
	

		judgmentSet:decelerate(0)
		judgmentSet:zoom(1)
		judgmentSet:sleep(0.5)
		judgmentSet:accelerate(0)
		judgmentSet:zoom(0)
	end
}

return t