local Players = GAMESTATE:GetHumanPlayers()

-- Start by loading actors that would be the same whether 1 or 2 players are joined.
local t = Def.ActorFrame{

	OnCommand=function(self)
		SL.Global.Stages.Stats[SL.Global.Stages.PlayedThisGame + 1] = {
			song = GAMESTATE:GetCurrentSong()
		}
	end,

	LoadActor("./ScreenshotHandler.lua"),

	LoadActor("./TitleAndBanner.lua"),

	LoadActor("./RateMod.lua"),

	LoadActor("./ScoreVocalization.lua")
	
}



-- Then, load the player-specific actors.
for pn in ivalues(Players) do

	-- the upper half of ScreenEvaluation
	t[#t+1] = Def.ActorFrame{
		Name=ToEnumShortString(pn).."_AF_Upper",
		OnCommand=function(self)
			if pn == PLAYER_1 then
				self:x(_screen.cx - 155)
			elseif pn == PLAYER_2 then
				self:x(_screen.cx + 155)
			end
		end,

		-- store player stats for later retrieval on EvaluationSummary and NameEntryTraditional
		LoadActor("./PerPlayer/Storage.lua", pn),

		--letter grade
		LoadActor("./PerPlayer/LetterGrade.lua", pn),

		--stepartist
		LoadActor("./PerPlayer/StepArtist.lua", pn),

		--difficulty text and meter
		LoadActor("./PerPlayer/Difficulty.lua", pn),

		-- Record Texts
		LoadActor("./PerPlayer/RecordTexts.lua", pn),
		
		
	}

	-- the lower half of ScreenEvaluation
	t[#t+1] = Def.ActorFrame{
		Name=ToEnumShortString(pn).."_AF_Lower",
		OnCommand=function(self)

			-- if double style, center the gameplay stats
			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				self:x(_screen.cx)
			else
				if pn == PLAYER_1 then
					self:x(_screen.cx + 155)
				elseif pn == PLAYER_2 then
					self:x(_screen.cx + 155)
				end
			end
		end,

		-- background quad for player stats
		Def.Quad{
			InitCommand=cmd(diffuse,color("#000000"); y,_screen.cy+240; zoomto, 331,600 )
		},
		-- labels (like "FANTASTIC, MISS, holds, rolls, etc.")
		LoadActor("./PerPlayer/JudgmentLabels.lua", pn),

		-- DP score displayed as a percentage
		LoadActor("./PerPlayer/Percentage.lua", pn),

		-- numbers (how many Fantastics? How many misses? etc.)
		LoadActor("./PerPlayer/JudgmentNumbers.lua", pn),

		-- "Look at this graph."
		-- Some sort of meme on the Internet
		LoadActor("./PerPlayer/Graphs.lua", pn),

		-- list of modifiers used by this player for this song
		LoadActor("./PerPlayer/PlayerModifiers.lua", pn),

		-- was this player disqualified from ranking?
		LoadActor("./PerPlayer/Disqualified.lua", pn),
		
		
		
	}
end

-- t[#t+1] = LoadFont("Common Normal") .. {
	-- InitCommand=cmd(xy,SCREEN_WIDTH-15,15;halign,1;zoom,1;maxwidth,(frameWidth-10)/0.45);
	-- BeginCommand=cmd(queuecommand,"Set");
	-- SetCommand=function(self)
		-- local sort = GAMESTATE:GetSortOrder()
		-- local song = GAMESTATE:GetCurrentSong()
		-- if sort == nil then
			-- self:settext("Sort: ")
		-- elseif sort == "SortOrder_Group" and song ~= nil then
			-- self:settext(song:GetGroupName())
		-- else
			-- self:settext(song:GetGroupName())
		-- end

	-- end;
	-- SortOrderChangedMessageCommand=cmd(queuecommand,"Set");
	-- CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
-- };



return t