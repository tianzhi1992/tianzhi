local version = "1.1"

local AUTOUPDATE= true
local UPDATE_SCRIPT_NAME = "Fiora"
local UPDATE_NAME = "Fiora"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/tianzhi1992/tianzhi/master/Fiora.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>"..UPDATE_NAME..":</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH, "", 5)
	if ServerData then
		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
		if ServerVersion then
			ServerVersion = tonumber(ServerVersion)
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end)	 
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end
	
--[[    Fiora ]]
local allowed=false

if myHero.charName ~= "Fiora" then return end
--[[    Ranges  ]]--
local qRange = 600
local rRange = 400
local eBuffer = 300
--[[    Farm    ]]--
local nextTick = 0
local waitDelay = 400
--[[    Damage Calculation      ]]--
local calculationenemy = 1
local killable = {}
local waittxt = {}
local floattext = {"Skills on cooldown.","Full Combo!"}
--[[    Attacks ]]--
local lastBasicAttack = 0
local swingDelay = 0.25
local startAttackSpeed = 0.625
local swing = 0
local LastQ = 0
--[[    Items   ]]--
local ignite = nil
local QREADY, WREADY, EREADY, RREADY  = false, false, false, false
local BRKSlot, DFGSlot, HXGSlot, BWCSlot, TMTSlot, RAHSlot, RNDSlot, YGBSlot = nil, nil, nil, nil, nil, nil, nil, nil
local BRKREADY, DFGREADY, HXGREADY, BWCREADY, TMTREADY, RAHREADY, RNDREADY, YGBREADY = false, false, false, false, false, false, false, false
 
local allowed = false
function OnLoad()
if GetUser() == "zhaolei" or  GetUser() == "hnhy617369" or GetUser() == "18671862732" then allowed = true end
if  not allowed then return end
        PrintChat("<font color='#CCCCCC'> >> Fiora loading<<</font>")
        FCConfig = scriptConfig("burn Fiora", "FioraCombo")
        FCConfig:addParam("scriptActive", "scriptActive", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        FCConfig:addParam("autoParry", "autoParry", SCRIPT_PARAM_ONKEYTOGGLE, true, 90)
        FCConfig:addParam("autoks", "autoks", SCRIPT_PARAM_ONKEYTOGGLE, true, 88)
        FCConfig:addParam("lasthit", "lasthit", SCRIPT_PARAM_ONKEYDOWN, false,string.byte"M")
        FCConfig:addParam("doubleLunge", "doubleLunge", SCRIPT_PARAM_ONOFF, false)
        FCConfig:addParam("useR", "useR", SCRIPT_PARAM_ONOFF, true)
        FCConfig:addParam("alwaysParry", "alwaysParry", SCRIPT_PARAM_ONOFF, true)
        FCConfig:addParam("autoignite", "autoignite", SCRIPT_PARAM_ONOFF, true)
        FCConfig:addParam("mousemoving", "mousemoving", SCRIPT_PARAM_ONOFF, true)
        FCConfig:addParam("drawcirclesSelf", "drawcirclesSelf", SCRIPT_PARAM_ONOFF, false)
        FCConfig:addParam("drawcirclesEnemy", "drawcirclesEnemy", SCRIPT_PARAM_ONOFF, false)
        FCConfig:addParam("drawtextEnemy", "drawtextEnemy", SCRIPT_PARAM_ONOFF, false)
        FCConfig:addParam("qBuffer", "qBuffer",SCRIPT_PARAM_SLICE, 250, 0, 600, 2)
        FCConfig:addParam("waitDelay", "waitDelay?",SCRIPT_PARAM_SLICE, 200, 0, 800, 2)
        FCConfig:permaShow("scriptActive")
        FCConfig:permaShow("autoParry")
        FCConfig:permaShow("autoks")
        ts = TargetSelector(TARGET_LOW_HP, qRange+50, DAMAGE_PHYSICAL)
        ts.name = "Fiora"
        FCConfig:addTS(ts)
        LastBasicAttack = os.clock()
        LastQ = 0
       
        enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
 
        if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
                elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2
        end
       
        for i=1, heroManager.iCount do waittxt[i] = i*3 end
end
 
function OnTick()



if  not allowed then return end





        ts:update()
        enemyMinions:update()
       
        if tick == nil or GetTickCount()-tick>=100 then
                tick = GetTickCount()
                DmgCalculation()
        end
       
        AttackDelay = 1/(myHero.attackSpeed*startAttackSpeed)
        if swing == 1 and os.clock() > lastBasicAttack + AttackDelay then
                swing = 0
        end
       
        BRKSlot, DFGSlot, HXGSlot, BWCSlot, TMTSlot, RAHSlot, RNDSlot, YGBSlot = GetInventorySlotItem(3153), GetInventorySlotItem(3128), GetInventorySlotItem(3146), GetInventorySlotItem(3144), GetInventorySlotItem(3077), GetInventorySlotItem(3074),  GetInventorySlotItem(3143), GetInventorySlotItem(3142)
        QREADY = (myHero:CanUseSpell(_Q) == READY)
        WREADY = (myHero:CanUseSpell(_W) == READY)
        EREADY = (myHero:CanUseSpell(_E) == READY)
        RREADY = (myHero:CanUseSpell(_R) == READY)
        DFGREADY = (DFGSlot ~= nil and myHero:CanUseSpell(DFGSlot) == READY)
        HXGREADY = (HXGSlot ~= nil and myHero:CanUseSpell(HXGSlot) == READY)
        BWCREADY = (BWCSlot ~= nil and myHero:CanUseSpell(BWCSlot) == READY)
        BRKREADY = (BRKSlot ~= nil and myHero:CanUseSpell(BRKSlot) == READY)
        TMTREADY = (TMTSlot ~= nil and myHero:CanUseSpell(TMTSlot) == READY)
        RAHREADY = (RAHSlot ~= nil and myHero:CanUseSpell(RAHSlot) == READY)
        RNDREADY = (RNDSlot ~= nil and myHero:CanUseSpell(RNDSlot) == READY)
        YGBREADY = (YGBSlot ~= nil and myHero:CanUseSpell(YGBSlot) == READY)
        IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
 
        --[[    Auto Ignite     ]]--
        if FCConfig.autoignite then    
                if IREADY then
                        local ignitedmg = 0    
                        for i = 1, heroManager.iCount, 1 do
                                local enemyhero = heroManager:getHero(i)
                                if ValidTarget(enemyhero,600) then
                                        ignitedmg = 50 + 20 * myHero.level
                                        if enemyhero.health <= ignitedmg then
                                                CastSpell(ignite, enemyhero)
                                        end
                                end
                        end
                end
        end
       
        --[[    Auto Q  ]]--
        if FCConfig.autoks then
                if QREADY then
                        local dmgQ = 0
                        for i = 1, heroManager.iCount, 1 do
                                local qTarget = heroManager:getHero(i)
                                if ValidTarget(qTarget, qRange) then
                                        if FCConfig.doubleLunge then
                                                dmgQ = getDmg("Q", qTarget, myHero)*2
                                                else dmgQ = getDmg("Q", qTarget, myHero)
                                        end
                                        if qTarget.health <= dmgQ then
                                                CastSpell(_Q, qTarget)
                                        end
                                end
                        end
                end
        end
       
        --[[    Basic Combo     ]]--
        if ts.target ~= nil and FCConfig.scriptActive then
                --[[    Items   ]]--
                if GetDistance(ts.target) < 550 then
                        if DFGREADY then CastSpell(DFGSlot, ts.target) end
                        if HXGREADY then CastSpell(HXGSlot, ts.target) end
                        if BWCREADY then CastSpell(BWCSlot, ts.target) end
                        if BRKREADY then CastSpell(BRKSlot, ts.target) end
                        if YGBREADY then CastSpell(YGBSlot, ts.target) end
                        if TMTREADY and GetDistance(ts.target) < 275 then CastSpell(TMTSlot) end
                        if RAHREADY and GetDistance(ts.target) < 275 then CastSpell(RAHSlot) end
                        if RNDREADY and GetDistance(ts.target) < 275 then CastSpell(RNDSlot) end
                end
                local QDMG = getDmg("Q", ts.target, myHero)
                --[[    Abilities       ]]--
                if swing == 0 then
                        if QREADY and GetTickCount() > nextTick and GetDistance(ts.target) <= qRange and (GetDistance(ts.target) >= FCConfig.qBuffer or os.clock() - LastQ > 3.5) then
                                CastSpell(_Q, ts.target)
                                nextTick = GetTickCount() + FCConfig.waitDelay
                                myHero:Attack(ts.target)
                                elseif ts.target.health < QDMG then
                                        CastSpell(_Q, ts.target)
                        end
                        if GetDistance(ts.target) <= 400 then
                                myHero:Attack(ts.target)
                        end
                        if moreThanOne() then
                                RDamage =  getDmg("R",ts.target,myHero,1)
                                else RDamage =  getDmg("R", ts.target,myHero,3)
                        end
                        if RREADY and FCConfig.useR and RDamage >= ts.target.health and GetDistance(ts.target) <= rRange then
                                CastSpell(_R, ts.target)
                        end
                        elseif swing == 1 then
                        if EREADY and GetDistance(ts.target) <= eBuffer and os.clock() - lastBasicAttack > swingDelay then
                                CastSpell(_E)
                                swing = 0
                        end
                        if QREADY and GetTickCount() > (nextTick+150) and GetDistance(ts.target) <= qRange and (GetDistance(ts.target) >= FCConfig.qBuffer or os.clock() - LastQ > 3.5) then
                                CastSpell(_Q, ts.target)
                                nextTick = GetTickCount() + FCConfig.waitDelay
                        end
                end
        end
 
        --[[    Last Hit        ]]--
        if FCConfig.lasthit then  
                if FCConfig.mousemoving and GetTickCount() > nextTick then
                        myHero:MoveTo(mousePos.x, mousePos.z)
                end
       
                for index, minion in pairs(enemyMinions.objects) do
                        local aDmg = getDmg("AD", minion, myHero)
                        if minion.health <= aDmg  and GetDistance(minion) <= (myHero.range+75) and GetTickCount() > nextTick then
                                myHero:Attack(minion)
                                nextTick = GetTickCount() + waitDelay
                        end
                end
        end
end
 
function OnDraw()      





if  not allowed then return end





        if FCConfig.drawcirclesSelf and not myHero.dead then
                DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x00FF00)
                DrawCircle(myHero.x, myHero.y, myHero.z, rRange, 0xFF0000)
                DrawCircle(myHero.x, myHero.y, myHero.z, FCConfig.qBuffer, 0x00FFFF)
        end
        if ts.target ~= nil and FCConfig.drawcirclesEnemy then
                for j=0, 10 do
                        DrawCircle(ts.target.x, ts.target.y, ts.target.z, 40 + j*1.5, 0x00FF00)
                end
        end
        for i=1, heroManager.iCount do
                local enemydraw = heroManager:GetHero(i)
                if ValidTarget(enemydraw) then
                        if FCConfig.drawcirclesEnemy then
                                if killable[i] == 1 then
                                        for e=0, 15 do
                                                DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 80 + e*1.5, 0x0000FF)
                                        end
                                        elseif killable[i] == 2 then
                                        for e=0, 10 do
                                                DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 80 + e*1.5, 0xFF0000)
                                                DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 110 + e*1.5, 0xFF0000)
                                                DrawCircle(enemydraw.x, enemydraw.y, enemydraw.z, 140 + e*1.5, 0xFF0000)
                                        end
                                end
                        end
                        if FCConfig.drawtextEnemy and waittxt[i] == 1 and killable[i] ~= 0 then
                                PrintFloatText(enemydraw,0,floattext[killable[i]])
                        end
                end
                if waittxt[i] == 1 then waittxt[i] = 30
                        else waittxt[i] = waittxt[i]-1
                end
        end
end
 

function DmgCalculation()
        local enemy = heroManager:GetHero(calculationenemy)
        if ValidTarget(enemy) then
                local ignitedamage, dfgdamage, hxgdamage, bwcdamage, brkdamage = 0, 0, 0, 0, 0
                local qdamage = getDmg("Q",enemy,myHero)
                local rdamage =  getDmg("R", enemy, myHero,3)
                local hitdamage = getDmg("AD", enemy, myHero)
                local ignitedamage = (ignite and getDmg("IGNITE",enemy,myHero) or 0)
                local dfgdamage = (DFGSlot and getDmg("DFG",enemy,myHero) or 0)
                local hxgdamage = (HXGSlot and getDmg("HXG",enemy,myHero) or 0)
                local bwcdamage = (BWCSlot and getDmg("BWC",enemy,myHero) or 0)
                local brkdamage = (BRKSlot and getDmg("RUINEDKING",enemy,myHero) or 0)
                local tmtdamage = (TMTSlot and getDmg("TIAMAT",enemy,myHero) or 0)
                local rahdamage = (RAHSlot and getDmg("HYDRA",enemy,myHero) or 0)
                local combo1 = hitdamage*1 + (qdamage*2) + rdamage
                local combo2 = hitdamage*1
        if QREADY then
                combo2 = combo2 + (qdamage*2)
        end
        if RREADY then
                combo2 = combo2 + rdamage
        end
        if DFGREADY then
                combo1 = combo1 + dfgdamage
                combo2 = combo2 + dfgdamage
        end
        if HXGREADY then
                combo1 = combo1 + hxgdamage
                combo2 = combo2 + hxgdamage
        end
        if BWCREADY then
                combo1 = combo1 + bwcdamage
                combo2 = combo2 + bwcdamage
        end
        if BRKREADY then
                combo1 = combo1 + brkdamage
                combo2 = combo2 + brkdamage
        end
        if TMTREADY then
                combo1 = combo1 + tmtdamage
                combo2 = combo2 + tmtdamage
        end
        if RAHREADY then
                combo1 = combo1 + rahdamage
                combo2 = combo2 + rahdamage
        end
        if IREADY then
                combo1 = combo1 + ignitedamage
                combo2 = combo2 + ignitedamage
        end
        if combo2 >= enemy.health then killable[calculationenemy] = 2
                elseif combo1 >= enemy.health then killable[calculationenemy] = 1
                else killable[calculationenemy] = 0 end
        end
                if calculationenemy == 1 then calculationenemy = heroManager.iCount
                        else calculationenemy = calculationenemy-1
                end
end
 
--[[     Ultimate       ]]--
function moreThanOne()
        local boolean = false
        for j = 1, heroManager.iCount, 1 do
                local enemyhero = heroManager:getHero(j)
                if myHero.team ~= enemyhero.team and ValidTarget(enemyhero) then
                        if ValidTargetNear(enemyhero,400,ts.target) then
                                boolean = true
                                else boolean = (false or boolean)
                        end
                end
        end            
        return boolean
end
 
--[[function GetMostAD()
        local MostAD = nil
        local CurrentAD = nil
        for i=1, heroManager.iCount do
                CurrentAD = heroManager:GetHero(i)
                if CurrentAD.team ~= myHero.team and not CurrentAD.dead and CurrentAD.visible then
                        if MostAD == nil then
                                MostAD = CurrentAD
                                elseif getDmg("AD", myHero, CurrentAD) <  getDmg("AD", myHero, MostAD) then
                                        MostAD = CurrentAD
                        end
                end
        end
return MostAD
end]]
 
 
--[[    Parry   ]]--
function OnProcessSpell(unit, spell)
if  not allowed then return end
        if unit.isMe and (spell.name:find("Attack") ~= nil) then
                swing = 1
                lastBasicAttack = os.clock()
        end
       
        if unit.isMe and spell.name == ("FioraQ")  then
                LastQ = os.clock()
        end
       
        if FCConfig.autoParry then
                if unit ~= nil and unit.type == "obj_AI_Hero" and GetDistance(spell.endPos) <= 50 and unit.team ~= myHero.team and not unit.isMe then
                        for i=1, #Abilities do
						 if FCConfig.alwaysParry and myHero:CanUseSpell(_W) == READY then
                                                CastSpell(_W)
												   else
                                if (spell.name == Abilities[i] or spell.name:find(Abilities[i]) ~= nil) then
                                        if myHero:CanUseSpell(_W) == READY and (getDmg("AD", myHero, unit) >= (myHero.maxHealth*0.06) or getDmg("AD", myHero, unit) >= (myHero.health*0.01)) then
                                                CastSpell(_W)
                                     
							    
                                        end
                                end
                        end
                end
        end
end
Abilities = {
"GarenSlash2", "SiphoningStrikeAttack", "LeonaShieldOfDaybreakAttack", "RenektonExecute", "ShyvanaDoubleAttackHit", "DariusNoxianTacticsONHAttack", "TalonNoxianDiplomacyAttack", "Parley", "MissFortuneRicochetShot", "RicochetAttack", "jaxrelentlessattack", "Attack"
}













