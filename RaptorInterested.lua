-- Raptor Interested Behavior
--------------------------------------------------------------------------
local Behavior = CreateAIBehavior("RaptorInterested", -- "ParentBehavior",
{
  -- Optional - indicates the alert status (0 = idle, 1 = alert, 2 = engaged in combat)
	-- read by AI system to get the alert status
	Alertness = 0,
												
	---------------------------------------------
	Constructor = function (self, entity, data)
		-- called when the behavior is selected
		-- the extra data is from the signal that caused the behavior transition
		
		local targetDist = AI.GetAttentionTargetDistance(entity.id);

		--Log(entity:GetName() .." - I see you, your " .. targetDist .. " meters away");
				
		if(targetDist < 35) then
			--Log("You are within range, I think I may stalk you if I have friends around");
			local closeMembers = AI_Raptor_Utils:GetCloseGroupMembers(entity);	
			entity:SelectPipe(0, "raptor_orient_1");
			
			if(closeMembers > 0) then
				--Log("I do have " .. closeMembers .. " friends nearby, I'll stalk you");
				AI.SetBehaviorVariable(entity.id, "StalkPlayer", true);			
			else			
				--Log("I am all alone. :( I am too scared to stalk you by myself, I'll just keep an eye on you.");
				-- Maybe we could use a call for help here?
				AI.Signal(SIGNALFILTER_GROUPONLY_EXCEPT, -1, "RAPTOR_HELP",entity.id); --sends signal to everyone else nearby for help
			end
		
		else
			--Log("I saw you but your too far away so I  don't care, I am going back to idle.");
			AI.SetBehaviorVariable(entity.id, "AwareOfPlayer", false); -- send back to idle behavior
			
		end
			

	end,
	
	---------------------------------------------
	Destructor = function (self, entity, data)
		-- called when the behavior is de-selected
		-- the extra data is from the signal that is causing the behavior transition
	end,


	---------------------------------------------
	OnActionDone = function(self, entity, data)
		-- called after finishing any AI action for which this agent was "the user"
		--
		-- data.ObjectName is the action name
		-- data.iValue is 0 if action was canceled or 1 if it was finished normally
		-- data.id is the entity id of "the object" of AI action
	end,

	---------------------------------------------
	OnEnemySeen = function(self, entity, distance)
		-- called when the AI sees a living enemy
		
	end,

	---------------------------------------------
	OnCloseContact = function(self, entity)
		-- called when AI gets at close distance (entity.damageRadius) to an enemy
		--Log("ON CLOSE CONTACT");
		
		if(random(1,10)>5) then
			AI.SetBehaviorVariable(entity.id, "AttackPlayer", true);
			--Log("Attack!!!");
		else
			AI.SetBehaviorVariable(entity.id, "HideFromPlayer", true);
			--Log("Hide!!!");
		end
		
		
	end,
	
	---------------------------------------------
	OnEnemyMemory = function(self, entity)
		-- called when the AI can no longer see its enemy, but remembers where it saw it last
	end,
	
	---------------------------------------------
	OnNoTarget = function(self, entity)
		-- called when the AI stops having an attention target
	end,

	---------------------------------------------
	OnInterestingSoundHeard = function(self, entity)
		-- called when the AI hears an interesting sound
	end,

	---------------------------------------------
	OnThreateningSoundHeard = function(self, entity)
		-- called when the AI hears a threatening sound
	end,
	
	---------------------------------------------
	OnObjectSeen = function( self, entity, distance, data )
		-- called when the AI sees an object registered for this kind of signal
		-- data.iValue = AI object type
		-- example
		-- if (data.iValue == 150) then -- grenade
		-- if (data.iValue == AIOBJECT_GRENADE) then -- grenade
		-- if (data.iValue == AIOBJECT_RPG) then -- rockets
		--	 ...
	end,
	
	---------------------------------------------
	OnReload = function(self, entity)
		-- called when the AI goes into automatic reload after its clip is empty
	end,
	
	---------------------------------------------
	OnReloadDone = function(self, entity)
		-- called after reloading is done
	end,
	
	---------------------------------------------
	OnHideSpotReached = function(self, entity, sender)
		-- called when the AI reaches his hidespot and he's actually well hidden
	end,
	
	---------------------------------------------
	OnNoHidingPlace = function(self, entity, sender, data)
		-- called when no hiding place can be found with the specified parameters
		-- data.fValue = distance at which the hidespot has been searched
	end,
	
	---------------------------------------------
	OnBadHideSpot = function(self, entity, sender)
		-- called when the AI reaches a hidespot which proves to not hide correctly
	end,
		
	---------------------------------------------
	OnLowHideSpot = function(self, entity, sender)
		-- called when the AI reaches a hidespot which is too low to fit when standing up
	end,
	
	---------------------------------------------
	OnLeftLean = function(self, entity, sender)
		-- called when a bad hidespot is reached, and AI can lean on the left
	end,
	
	---------------------------------------------
	OnRightLean = function(self, entity, sender)
		-- called when a bad hidespot is reached, and AI can lean on the right
	end,
	
	---------------------------------------------
	OnNoPathFound = function(self, entity, sender)
		-- called when the AI has requested a path which is not possible
	end,
	
	---------------------------------------------
	OnEndPathOffset = function(self, entity, sender)
		-- called when the AI has requested a path and the end of path
		-- is far from the desired destination
	end,
	
	---------------------------------------------
	OnPathFound = function(self, entity, sender)
		-- called when the AI has requested a path and it's been computed succesfully
	end,
	
	---------------------------------------------
	OnBackOffFailed = function(self, entity, sender)
		-- called when the AI tried to execute a "backoff" goal which failed
	end,	


	--------------------------------------------------
	OnNoFormationPoint = function(self, entity, sender)
		-- called when the AI couldn't find a formation point
	end,

	---------------------------------------------
	OnDamage = function(self, entity, sender, data)
		-- called when AI is damaged by another friendly/unknown AI
		-- data.id = damaging AI's entity id
	end,
	
	---------------------------------------------
	OnEnemyDamage = function(self, entity, sender, data)
		-- called when AI is damaged by an enemy AI
		-- data.id = damaging enemy's entity id
	end,

	---------------------------------------------
	OnBulletRain = function(self, entity, sender)	
		-- called when there are bullet impacts nearby
		AI.SetBehaviorVariable(entity.id, "HideFromPlayer", true);
	end,

	--------------------------------------------------
	OnSomebodyDied = function(self, entity, sender)
		-- called when a member of same species dies nearby
		--Log("Fleeeeee");
		AI.SetBehaviorVariable(entity.id, "HideFromPlayer", true);
	end,
	
	---------------------------------------------
	OnFriendInWay = function(self, entity, sender)
		-- called when AI is trying to fire and another friendly AI is on his line of fire
	end,
	
	---------------------------------------------
	OnTargetTooClose = function(self, entity, sender, data)
		-- called when the attention target is too close for the current weapon range
		-- TO DO: it works only if AI is a vehicle
	end,
	
	---------------------------------------------
	OnTargetTooFar = function(self, entity, sender, data)
		-- called when the attention target is too close for the current weapon range
		-- TO DO: it works only if AI is a vehicle
	end,
	
	---------------------------------------------
	OnVehicleDanger = function(self, entity, sender, data)
		-- called when a vehicle is going towards the AI
		-- data.point = vehicle movement direction
		-- data.point2 = AI direction with respect to vehicle
	end,
	
	---------------------------------------------
	OnSeenByEnemy = function(self, entity, sender)
		-- called when AI is seen by the enemy
	end,
	
	---------------------------------------------
	OnPlayerLooking = function(self, entity, sender, data)
		-- player is looking at the AI for entity.Properties.awarenessOfPlayer seconds
		-- data.fValue = player distance
	end,

	---------------------------------------------
	OnPlayerLookingAway = function(self, entity, sender)
		-- player has just stopped looking at the AI

	end,

	---------------------------------------------
	OnPlayerSticking = function(self, entity, sender)
		-- player is staying close to the ai since <entity.Properties.awarenessOfPlayer> seconds
	end,

	----------------------------------
	OnPlayerGoingAway = function(self, entity, sender)
		-- player has just stopped staying close to the AI
		
	end,
	
	RAPTOR_HELP = function (self, entity, sender)
		--Log(entity:GetName() .. " Providing Help");
		AI.SetBehaviorVariable(entity.id, "StalkPlayer", true);	
		
	end,
})
