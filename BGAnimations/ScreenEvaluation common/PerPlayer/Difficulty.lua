local player = ...
local pn = PlayerNumber:Reverse()[player]

return Def.ActorFrame{

	-- difficulty text ("beginner" or "expert" or etc.)
	LoadFont("_miso")..{
		OnCommand=function(self)

			self:y(_screen.cy-176)
			self:x( (player == PLAYER_1 and SCREEN_WIDTH-200) or 115 )
			self:horizalign(center)
			self:zoom(0.6)

			local currentSteps = GAMESTATE:GetCurrentSteps(player)

			if currentSteps then
				local difficulty = currentSteps:GetDifficulty();
				-- GetDifficulty() returns a value from the Difficulty Enum
				-- "Difficulty_Hard" for example.
				-- Strip the characters up to and including the underscore.
				difficulty = ToEnumShortString(difficulty)
				self:settext( THEME:GetString("Difficulty", difficulty) )
			end
		end
	},

	-- colored square as the background for the difficulty meter

	-- numerical difficulty meter
	LoadFont("_big")..{
		InitCommand=cmd(diffuse, Color.White ),
		OnCommand=function(self)
			self:zoom( 1.2 )
			self:y( _screen.cy-200 )
			self:maxwidth(35)
			self:x( (player == PLAYER_1 and SCREEN_WIDTH-200) or 134.5 )
			self:horizalign(center)

			local meter
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(player)
				if trail then
					meter = trail:GetMeter()
				end
			else
				local steps = GAMESTATE:GetCurrentSteps(player)
				if steps then
					meter = steps:GetMeter()
				end
			end

			if meter then
				self:settext(meter)
			end
		end
	}
}