local Version = "1.0"
_G.kayleVersion = "1.0"
_G.kayleAUTOUPDATE = true
_G.kayleAuthor = "tianzhi"
_G.IsLoaded = "[tz]kayle"


---------------------------------------------------------------------
--- AutoUpdate for the script ---------------------------------------
---------------------------------------------------------------------
local UPDATE_FILE_PATH = SCRIPT_PATH.."[tz]kayle.lua"
local UPDATE_NAME = "[tz]kayle"
local UPDATE_HOST = "github.com"
local UPDATE_PATH = "/tianzhi1992/tianzhi/blob/master/%5Btz%5Dkayle.lua?chunk="..math.random(1, 1000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."[tz]kayle.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#eFF99CC\">[".._G.IsLoaded.."]:</font> <font color=\"#FFDFBF\">"..msg..".</font>") end
if _G.kayleAUTOUPDATE then
    local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
    if ServerData then
        local ServerVersion = string.match(ServerData, "_G.kayleVersion = \"%d+.%d+\"")
        ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
        if ServerVersion then
            ServerVersion = tonumber(ServerVersion)
            if tonumber(_G.kayleVersion) < ServerVersion then
                AutoupdaterMsg("A new version is available: ["..ServerVersion.."]")
                AutoupdaterMsg("The script is updating... please don't press [F9]!")
                DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function ()
				AutoupdaterMsg("Successfully updated! (".._G.kayleVersion.." -> "..ServerVersion.."), Please reload (double [F9]) for the updated version!") end) end, 3)
            else
                AutoupdaterMsg("Your script is already the latest version: ["..ServerVersion.."]")
            end
        end
    else
        AutoupdaterMsg("Error downloading version info!")
    end
end
	
---------------------------------------------------------------------
--- Vars ------------------------------------------------------------
---------------------------------------------------------------------




if myHero.charName ~= "Kayle" then return end
local allowed=false
local aRange = 525
local EWidth = 75
local rRange = 900
local qRange,wRange,eRange,rRange = 650, 900, 525, 900
local wRange = 900

function OnLoad()
if GetUser() == "woainima" or  GetUser() == "hnhy617369" or GetUser() == "835390" or  GetUser() == "fflovezj1221" or GetUser() == "lengbina001" or GetUser() == "kf9299" or GetUser() == "jiahongbinx" or GetUser() == "nady269" or  GetUser() == "tianzhi1992"or  GetUser() == "andrewls"

then allowed = true end
if  not allowed then PrintChat("<font color='#CCCCCC'> >>[tz]kayle鏈璇佺敤鎴疯鑱旂郴浣滆�?</font>") return end
    minionMobs = {}
	minionClusters = {}
	Vars()
	PrintChat("<font color='#CCCCCC'> >> [tz]Kayle 杞藉叆鎴愬姛<<</font>")
	PrintChat("<font color='#CCCCCC'> >> 璐拱璇疯仈绯籕Q332433061<<</font>")
	PrintChat("<font color='#CCCCCC'> >> 绁濇偍娓告垙鎰夊揩<<</font>")
	KayleConfig = scriptConfig("[tz] Kayle", "Kayle_The_Judicator")
	KayleConfig:addSubMenu("爆发", "Combo")
	KayleConfig.Combo:addParam("Combo", "爆发", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	KayleConfig.Combo:addParam("Harass", "骚扰", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
	KayleConfig.Combo:permaShow("Combo")
	KayleConfig.Combo:permaShow("Harass")
	KayleConfig:addSubMenu("骚扰", "harass")
	KayleConfig.Combo:addParam("useQ", "使用Q", SCRIPT_PARAM_ONOFF, true)
	KayleConfig.Combo:addParam("useW", "使用W", SCRIPT_PARAM_ONOFF, true)
	KayleConfig.Combo:addParam("useE", "使用E", SCRIPT_PARAM_ONOFF, true)
	KayleConfig.Combo:permaShow("Combo")
	KayleConfig.Combo:permaShow("Harass")
	KayleConfig.harass:addParam("useQ", "使用Q", SCRIPT_PARAM_ONOFF, true)
	KayleConfig.harass:addParam("useW", "使用W", SCRIPT_PARAM_ONOFF, true)
	KayleConfig.harass:addParam("useE", "使用E", SCRIPT_PARAM_ONOFF, true)
	--> Heal Settings
	KayleConfig:addSubMenu("治疗", "Heal")
	KayleConfig.Heal:addSubMenu("治疗目标选择", "HealTargeting")
	KayleConfig.Heal:addParam("PercentofHealth", "使用治疗血量百分比",SCRIPT_PARAM_SLICE, 25, 0, 100, 0)	
	KayleConfig.Heal.HealTargeting:addParam(myHero.charName.."healTarget", "治疗 ".. myHero.charName, SCRIPT_PARAM_ONOFF, true)
	for i, ally in ipairs(GetAllyHeroes()) do
		KayleConfig.Heal.HealTargeting:addParam(ally.charName.."healTarget", "治疗 "..ally.charName, SCRIPT_PARAM_ONOFF, true)
	end
	KayleConfig.Heal:addParam("healAllies", "治疗队友开关键", SCRIPT_PARAM_ONOFF, true)
	--> Ult Settings
    KayleConfig:addSubMenu("大招", "ult")
	KayleConfig.ult:addSubMenu("大招目标选择", "ultTargeting")
	KayleConfig.ult:addParam("PercentofUlt", "使用大招血量百分比",SCRIPT_PARAM_SLICE, 25, 0, 100, 0)	
	KayleConfig.ult:addParam("ultAllies", "对队友使用大招", SCRIPT_PARAM_ONOFF, false)
	KayleConfig.ult:addParam("myult", "对自己使用大招", SCRIPT_PARAM_ONOFF, true)
	KayleConfig.ult.ultTargeting:addParam(myHero.charName.."ultTarget", "大招".. myHero.charName, SCRIPT_PARAM_ONOFF, true)
	for i, ally in ipairs(GetAllyHeroes()) do
		KayleConfig.ult.ultTargeting:addParam(ally.charName.."ultTarget", "大招 "..ally.charName, SCRIPT_PARAM_ONOFF, true)
	end
	KayleConfig:addSubMenu("抢人头", "KS")
	KayleConfig.KS:addParam("autoignite", "自动点燃", SCRIPT_PARAM_ONOFF, true)
	KayleConfig.KS:addParam("killSteal", "自动抢人头", SCRIPT_PARAM_ONOFF, true)

	KayleConfig:addSubMenu("距离显示", "Draw")
	KayleConfig.Draw:addParam("qDraw", "Q的范围", SCRIPT_PARAM_ONOFF, true)
    KayleConfig.Draw:addParam("cDraw", "E的范围", SCRIPT_PARAM_ONOFF, true)
	
	KayleConfig:addSubMenu("想攻击哪个鼠标左键点哪个", "12")
	
	lastBasicAttack = os.clock()
end

function OnProcessSpell(unit, spell)
if  not allowed then return end
	if unit.isMe and (spell.name:find("Attack") ~= nil) then
		swing = 1
		lastBasicAttack = os.clock() 
	end
end

function OnTick()
if  not allowed then return end
	GlobalInfo()
	DamageCalculation()
	ts:update()
	if KayleConfig.KS.killSteal then KillSteal() end
	AttackDelay = 1/(myHero.attackSpeed*startAttackSpeed)
	if swing == 1 and os.clock() > lastBasicAttack + AttackDelay then
		swing = 0
	end
	
	--[[	Harass	]]--
	if ts.target ~= nil and KayleConfig.Combo.Harass  then
		if QREADY and GetDistance(ts.target) < range then
			CastSpell(_Q, ts.target)
		end
		if EREADY and GetDistance(ts.target) < range then
			CastSpell(_E)
		end
	end  
	--[[	Basic Combo	]]--
	if ts.target ~= nil and KayleConfig.Combo.Combo then
		--[[	Items	]]--
		if GetDistance(ts.target) < 600 then
			if dfgReady then CastSpell(dfgSlot, ts.target) end
			if brkReady then CastSpell(brkSlot, ts.target) end
			if hxgReady then CastSpell(hxgSlot, ts.target) end
			if bwcReady then CastSpell(bwcSlot, ts.target) end
			if stdReady then CastSpell(stdSlot) end
		end
		--[[	Abilities	]]--
		if QREADY and GetDistance(ts.target) < range then 
				CastSpell(_Q, ts.target)
		end
		if EREADY and GetDistance(ts.target) < aRange then
			CastSpell(_E)
		end
		if WREADY and GetDistance(ts.target) > wBuffer then
			CastSpell(_W, myHero)
		end
end

		
	
	if KayleConfig.Heal.healAllies then
		if KayleConfig.Heal.HealTargeting[myHero.charName.."healTarget"] then
			if healthLow(myHero) and myHero.mana >= myHero.maxMana*0.5 then CastSpell(_W, myHero) end
		end
		for i, ally in ipairs(GetAllyHeroes()) do
			if ally and KayleConfig.Heal.HealTargeting[ally.charName.."healTarget"] then
				if healthLow(ally) and myHero.mana >= myHero.maxMana*0.5 and GetDistance(ally) <= wRange then CastSpell(_W, ally) end
			end
		end
	end
	
	if KayleConfig.ult.ultAllies then
		for i, ally in ipairs(GetAllyHeroes()) do
			if ally and KayleConfig.ult.ultTargeting[ally.charName.."ultTarget"] then
				if healthLow2(ally) and QREADY  and CountEnemyHeroInRange(650, unit) > 0then CastSpell(_R, ally) end
			end
		end
	end
		if KayleConfig.ult.myult and RREADY then 
		UltManagement(myHero)
	end

end

function UseItems(enemy)
if  not allowed then return end
	if not enemy then
		enemy = ts.target
	end
	if ValidTarget(enemy) then
		if hxgReady and GetDistance(enemy) <= 600 then CastSpell(hxgSlot, enemy) end
		if bwcReady and GetDistance(enemy) <= 450 then CastSpell(bwcSlot, enemy) end
		if brkReady and GetDistance(enemy) <= 450 then CastSpell(brkSlot, enemy) end
		if dfgReady and GetDistance(enemy) <= 600 then CastSpell(dfgSlot, enemy) end
		if tmtReady and GetDistance(enemy) <= 185 then CastSpell(tmtSlot) end
		if hdrReady and GetDistance(enemy) <= 185 then CastSpell(hdrSlot) end
	end
end

-- KillSteal function --
function KillSteal()
if  not allowed then return end
	if ValidTarget(ts.target) then
		if QREADY and ts.target.health <= qDmg and GetDistance(ts.target) <= qRange then 
			CastSpell(_Q, ts.target)
		elseif EREADY and ts.target.health <= eDmg and GetDistance(ts.target) <= eRange then
			CastE(ts.target)
		elseif QREADY and EREADY and ts.target.health <= (qDmg + eDmg) and GetDistance(ts.target) <= qRange then
			CastSpell(_Q, ts.target)
			CastSpell(_E)
		elseif EREADY and QREADY and ts.target.health <= (eDmg + qDmg) and GetDistance(ts.target) <= eRange then
			CastSpell(_E)
			CastSpell(_Q, ts.target)
		end
	end
end

function CountEnemies(point, range)
if  not allowed then return end
        local ChampCount = 0
        for j = 1, heroManager.iCount, 1 do
                local enemyhero = heroManager:getHero(j)
                if myHero.team ~= enemyhero.team and ValidTarget(enemyhero, range) then
                        if GetDistance(enemyhero, point) <= range then
                                ChampCount = ChampCount + 1
                        end
                end
        end            
        return ChampCount
end




-- Damage Calculations --
function DamageCalculation()
if  not allowed then return end
	for i=1, heroManager.iCount do
	local enemy = heroManager:GetHero(i)
		if ValidTarget(enemy) then
			dfgDmg, hxgDmg, bwcDmg, iDmg  = 0, 0, 0, 0
			qDmg, wDmg, eDmg = 0, 0, 0
			if QREADY then qDmg = getDmg("Q",enemy,myHero) end
            if WREADY then wDmg = getDmg("W",enemy,myHero) end
			if EREADY then eDmg = getDmg("E",enemy,myHero) end
			if dfgReady then dfgDmg = (dfgSlot and getDmg("DFG",enemy,myHero) or 0)	end
            if hxgReady then hxgDmg = (hxgSlot and getDmg("HXG",enemy,myHero) or 0) end
            if bwcReady then bwcDmg = (bwcSlot and getDmg("BWC",enemy,myHero) or 0) end
            if iReady then iDmg = (ignite and getDmg("IGNITE",enemy,myHero) or 0) end
            onspellDmg = (liandrysSlot and getDmg("LIANDRYS",enemy,myHero) or 0)+(blackfireSlot and getDmg("BLACKFIRE",enemy,myHero) or 0)
            itemsDmg = dfgDmg + hxgDmg + bwcDmg + iDmg + onspellDmg
				KillText[i] = 1 
			if enemy.health <= (qDmg + eDmg + wDmg + itemsDmg) then
				KillText[i] = 2
			elseif enemy.health <= ((qDmg*2) + eDmg + wDmg + itemsDmg) then
				KillText[i] = 3
			elseif enemy.health <= ((qDmg*2) + wDmg + eDmg + itemsDmg) then
				KillText[i] = 4
			end
		end
	end
end

--[Drawing our Range/Killable Enemies]--
function OnDraw()
if  not allowed then return end
if  not allowed then return end
	--> Ranges
	if not KayleConfig.Draw.drawText and not myHero.dead then
		if QREADY and KayleConfig.Draw.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x0000FF)
		end
		if eReady and KayleConfig.Draw.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, 0x0000FF)
		end
	end
	if KayleConfig.Draw.cDraw then
		for i=1, heroManager.iCount do
			local Unit = heroManager:GetHero(i)
			if ValidTarget(Unit) then
				if waittxt[i] == 1 and (KillText[i] ~= nil or 0 or 1) then
					PrintFloatText(Unit, 0, TextList[KillText[i]])
				end
			end
			if waittxt[i] == 1 then
				waittxt[i] = 30
			else
				waittxt[i] = waittxt[i]-1
			end
		end
	end
end

---------------------------------------------
---------ULT---------------------------------
---------------------------------------------
function UltManagement(unit)
if  not allowed then return end
	if unit.health <= unit.maxHealth*(KayleConfig.ult.PercentofUlt/100)  then CastSpell(_R, unit) end
end

function Vars()
if  not allowed then return end
ts = TargetSelector(TARGET_LOW_HP, 700, DAMAGE_MAGIC, true)
ts.name = "Kayle"
enemyMinions = minionManager(MINION_ENEMY, 525, myHero)
jungleMinions = minionManager(MINION_JUNGLE, 525, myHero)
qRange,wRange,eRange,rRange = 650, 900, 525, 900
QREADY, WREADY, EREADY, RREADY = false, false, false, false
TextList = {"harass him"}
KillText = {i}
waittxt = {} -- prevents UI lags, all credits to Dekaron
for i=1, heroManager.iCount do waittxt[i] = i*3 end
--Spells --
range = 650
wBuffer = 600 --Wont use W unless they are this far away. 600 by default.
aRange = 525
ignite = nil
lastBasicAttack = 0
swing = 0 
startAttackSpeed = 0.625
nextTick = 0
DFGREADY, BRKREADY, HXGREADY, BWCREADY, STDREADY = false, false, false, false, false
DFGSlot, BRKSlot, HXGSlot, BWCSlot, STDSlot = nil, nil, nil, nil, nil
end

function healthLow(ally)
if  not allowed then return end
	return ally.health <= ally.maxHealth*(KayleConfig.Heal.PercentofHealth/100)
end
function healthLow2(ally)
if  not allowed then return end
	return ally.health <= ally.maxHealth*(KayleConfig.ult.PercentofUlt/100) 
end

function GlobalInfo()
if  not allowed then return end

	MouseScreen = WorldToScreen(D3DXVECTOR3(mousePos.x, mousePos.y, mousePos.z))
	QREADY = myHero:CanUseSpell(_Q) == READY 
    WREADY = myHero:CanUseSpell(_W) == READY
	EREADY = myHero:CanUseSpell(_E) == READY
	RREADY = myHero:CanUseSpell(_R) == READY
	
	iSlot = ((myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") and SUMMONER_1) or (myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") and SUMMONER_2) or nil)
	iReady = (iSlot ~= nil and myHero:CanUseSpell(iSlot) == READY)
	dfgSlot = GetInventorySlotItem(3128)
	dfgReady = (dfgSlot ~= nil and GetInventoryItemIsCastable(3128,myHero))
	lichSlot = GetInventorySlotItem(3100)
	lichReady = (lichSlot ~= nil and myHero:CanUseSpell(lichSlot) == READY)
	sheenSlot = GetInventorySlotItem(3057)
	sheenReady = (sheenSlot ~= nil and myHero:CanUseSpell(sheenSlot) == READY)
	enemyMinions:update()
	jungleMinions:update()
	
		-- Slots for Items / Pots / Wards --
	rstSlot, ssSlot, swSlot, vwSlot =    GetInventorySlotItem(2045),
									     GetInventorySlotItem(2049),
									     GetInventorySlotItem(2044),
									     GetInventorySlotItem(2043)
	dfgSlot, hxgSlot, bwcSlot, brkSlot = GetInventorySlotItem(3128),
										 GetInventorySlotItem(3146),
										 GetInventorySlotItem(3144),
										 GetInventorySlotItem(3153)
	hpSlot, mpSlot, fskSlot =            GetInventorySlotItem(2003),
							             GetInventorySlotItem(2004),
							             GetInventorySlotItem(2041)
	znaSlot, wgtSlot =                   GetInventorySlotItem(3157),
	                                     GetInventorySlotItem(3090)
	tmtSlot, hdrSlot = 					 GetInventorySlotItem(3077),
										 GetInventorySlotItem(3074)
	
	
		-- Items --
	dfgReady = (dfgSlot ~= nil and myHero:CanUseSpell(dfgSlot) == READY)
	hxgReady = (hxgSlot ~= nil and myHero:CanUseSpell(hxgSlot) == READY)
	bwcReady = (bwcSlot ~= nil and myHero:CanUseSpell(bwcSlot) == READY)
	brkReady = (brkSlot ~= nil and myHero:CanUseSpell(brkSlot) == READY)
	znaReady = (znaSlot ~= nil and myHero:CanUseSpell(znaSlot) == READY)
	wgtReady = (wgtSlot ~= nil and myHero:CanUseSpell(wgtSlot) == READY)
	tmtReady = (tmtSlot ~= nil and myHero:CanUseSpell(tmtSlot) == READY)
	hdrReady = (hdrSlot ~= nil and myHero:CanUseSpell(hdrSlot) == READY)
	end