--Design/Image/Script: wyykak

local cc=13959973
local this=_G["c"..cc]

this.dlCode=13959972

c13959970={}
Duel.LoadScript("c13959970.lua")
local cnu=c13959970

function this.initial_effect(c)
	if not this.gc then
		this.gc=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START|PHASE_DRAW)
		e1:SetCondition(this.con)
		e1:SetOperation(this.op)
		Duel.RegisterEffect(e1,0)
		local es1=Effect.CreateEffect(c)
		es1:SetType(EFFECT_TYPE_FIELD)
		es1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		es1:SetCode(EFFECT_SKIP_DP)
		es1:SetTargetRange(1,1)
		es1:SetCondition(this.con1)
		Duel.RegisterEffect(es1,0)
		local es2=es1:Clone()
		es2:SetCode(EFFECT_SKIP_SP)
		es2:SetCondition(this.con2)
		Duel.RegisterEffect(es2,0)
		local es3=es2:Clone()
		es3:SetCode(EFFECT_SKIP_M1)
		Duel.RegisterEffect(es3,0)
		local es6=es1:Clone()
		es6:SetCode(EFFECT_CANNOT_BP)
		es6:SetCondition(this.con3)
		Duel.RegisterEffect(es6,0)
		local es7=es2:Clone()
		es7:SetCode(EFFECT_CANNOT_ACTIVATE)
		es7:SetValue(aux.TRUE)
		Duel.RegisterEffect(es7,0)
		local es8=Effect.CreateEffect(c)
		es8:SetType(EFFECT_TYPE_FIELD)
		es8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_IGNORE_RANGE)
		es8:SetTargetRange(0xff,0xff)
		es8:SetCode(EFFECT_DISABLE)
		es8:SetCondition(this.con4)
		Duel.RegisterEffect(es8,0)
		local es9=es7:Clone()
		es9:SetCondition(this.con5)
		Duel.RegisterEffect(es9,0)
		Duel.RegisterFlagEffect(0,cc,0,0,1)
		Duel.RegisterFlagEffect(1,cc,0,0,1)
		local es10=es1:Clone()
		es10:SetCode(EFFECT_DRAW_COUNT)
		es10:SetValue(0)
		es10:SetCondition(this.con6)
		Duel.RegisterEffect(es10,0)
	end
end

function this.con6()
	return this.isTag and Duel.GetTurnCount()==3
end

function this.con1()
	return this.isTag and ({false,true,false,true,true})[Duel.GetTurnCount()]
end
function this.con2()
	return this.isTag and ({true,true,true,true})[Duel.GetTurnCount()]
end
function this.con3()
	return this.isTag and ({true,true,true,true,true})[Duel.GetTurnCount()]
end

function this.con4()
	return this.isPicking
end

function this.con5()
	return Duel.GetCurrentPhase()==PHASE_DRAW and (Duel.GetTurnCount()==1 or (this.isTag and Duel.GetTurnCount()==3))
end

function this.con()
	return Duel.GetTurnCount()==1 or (this.isTag and Duel.GetTurnCount()==3)
end

function this.seed3()
	local result=0
	local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(0,8)
	local ct={}
	local c=g:GetFirst()
	for i=0,7 do
		ct[c]=i
		c=g:GetNext()
	end
	for i=0,10 do
		result=result+(ct[g:RandomSelect(0,1):GetFirst()]<<(3*i))
	end
	g:DeleteGroup()
	return result&0xffffffff
end

function this.op(e,tp)
	this.isPicking=true
	if Duel.GetTurnCount()==1 then
		math.randomseed(this.seed3())
	end
	Duel.Exile(Duel.GetFieldGroup(0,LOCATION_DECK|LOCATION_EXTRA|LOCATION_HAND,LOCATION_DECK|LOCATION_EXTRA|LOCATION_HAND),REASON_RULE)
	this.isTag=Duel.SelectYesNo(0,aux.Stringid(13959998,8))
	
	this.chronicle()
	
	Duel.ConfirmCards(0,Duel.GetFieldGroup(0,LOCATION_DECK,0))
	Duel.ConfirmCards(1,Duel.GetFieldGroup(1,LOCATION_DECK,0))
	Duel.SelectMatchingCard(0,nil,0,LOCATION_EXTRA,0,0,99,nil)
	Duel.SelectMatchingCard(1,nil,1,LOCATION_EXTRA,0,0,99,nil)
	Duel.ShuffleDeck(0)
	Duel.ShuffleDeck(1)
	Duel.ShuffleExtra(0)
	Duel.ShuffleExtra(1)

	if not this.isTag or Duel.GetTurnCount()==5 then
		this.isPicking=false
	end
	Duel.Draw(0,5,REASON_RULE)
	Duel.Draw(1,5,REASON_RULE)
	this.isPicking=false
	Duel.ResetTimeLimit(0)
	Duel.ResetTimeLimit(1)
end

function this.chronicle()
	if not this.deckList then
		this.deckList=cnu.loadDeckList(this.dlCode)
	end
	for tp=0,1 do
		local deck=this.deckList[math.random(1,#this.deckList)]
		local g=Group.CreateGroup()
		for code,num in pairs(deck) do
			for i=1,num do
				g:AddCard(Duel.CreateToken(tp,code))
			end
		end
		Duel.SelectYesNo(tp,aux.Stringid(cc,math.random(0,4)))
		Duel.SendtoDeck(g,tp,0,REASON_RULE)
		g:DeleteGroup()
		Duel.SelectYesNo(tp,aux.Stringid(cc,math.random(0,4)))
	end
end