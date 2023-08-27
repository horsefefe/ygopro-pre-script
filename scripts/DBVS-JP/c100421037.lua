--ヴァルモニカ・ヴェルサーレ
--Valmonica Versare
--coded by Lyris
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsSetCard(0x2a3) and c:IsAbleToGrave() and not c:IsCode(id)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x2a3) and tp or 1-tp
	local c=e:GetOwner()
	local b1=c:GetFlagEffect(100421031)>0
	local b2=c:GetFlagEffect(100421032)>0
	if not (b1 or b2) then b1,b2=true,true end
	local op=aux.SelectFromOptions(p,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	if op==1 then
		if Duel.Recover(tp,500,REASON_EFFECT)<1 or not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x2a3)
		local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local seq,hc=-1
		for tc in aux.Next(g) do
			local sq=tc:GetSequence()
			if sq>seq then
				seq=sq
				hc=tc
			end
		end
		Duel.BreakEffect()
		if seq>-1 then
			Duel.ConfirmCards(tp,dct-seq)
			Duel.DisableShuffleCheck()
			if hc:IsAbleToHand() then Duel.SendtoHand(hc,nil,REASON_EFFECT)
			else Duel.SendtoGrave(hc,REASON_RULE) end
		else
			Duel.ConfirmDecktop(tp,dct)
		end
		if dct-seq>1 then Duel.ShuffleDeck(tp) end
	elseif Duel.Damage(tp,500,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end