--Chronicle Utilities
--by wyykak

local cc=13959970
local this=_G["c"..cc]

c13959997={}
Duel.LoadScript("c13959997.lua")

local tpu=c13959997

function this.error(deckname,card,reason)
	Debug.Message(string.format("卡组%s中的卡片%d非法：%s",deckname,card,reason))
end

function this.loadDeck(fname,strict)
	local result={}
	local mct=0
	local ect=0
	local at={}
	local f=io.open(fname,"r")
	if not f then
		this.error(fname,-1,"卡组文件不存在")
		return
	end
	for l in f:lines() do
		if l:sub(1,1)=="!" then
			break
		end
		if l:sub(1,1)~="#" and tonumber(l) then
			local tcc=math.floor(tonumber(l))
			if tcc<10000 or tcc>99999999 then
				this.error(fname,tcc,"卡号范围非法")
				if strict then f:close() return end
			elseif not Duel.ReadCard(tcc,CARDDATA_TYPE) then
				this.error(fname,tcc,"卡片不存在")
				if strict then f:close() return end
			elseif Duel.ReadCard(tcc,CARDDATA_TYPE)&TYPE_TOKEN~=0 then
				this.error(fname,tcc,"卡片是衍生物")
				if strict then f:close() return end
			else
				if not result[tcc] then
					result[tcc]=0
				end
				result[tcc]=result[tcc]+1
				if Duel.ReadCard(tcc,CARDDATA_TYPE)&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)~=0 then
					ect=ect+1
				else
					mct=mct+1
				end
				local ca=Duel.ReadCard(tcc,CARDDATA_ALIAS)
				local real=0
				if ca==0 then
					real=tcc
				else
					real=ca
				end
				if not at[real] then
					at[real]=0
				end
				at[real]=at[real]+1
				if at[real]>3 then
					this.error(fname,real,"同名卡超过3张")
					if strict then f:close() return end
				end
			end
		end
	end
	if mct>60 or mct<40 then
		this.error(fname,-1,"主卡组数量错误")
		if strict then f:close() return end
	end
	if ect>15 then
		this.error(fname,-1,"额外卡组数量错误")
		if strict then f:close() return end
	end
	f:close()
	return result,mct,ect
end

function this.loadNumSeq(s)
	local result={}
	for i=1,#s do
		result[#result+1]=tonumber(s:sub(i,i))
	end
	return result
end

function this.loadDeckList(dlCode)
	if not _G["c"..dlCode] then
		_G["c"..dlCode]={}
		Duel.LoadScript("c"..dlCode..".lua")
	end
	local dl=_G["c"..dlCode].deckList
	local decks={}
	for i=1,#dl//2 do
		local cardList=tpu.toList(tpu.loadSet(dl[2*i-1]))
		local numList=this.loadNumSeq(dl[2*i])
		local deck={}
		for j=1,#cardList do
			deck[cardList[j]]=numList[j]
		end
		decks[#decks+1]=deck
	end
	return decks
end


		