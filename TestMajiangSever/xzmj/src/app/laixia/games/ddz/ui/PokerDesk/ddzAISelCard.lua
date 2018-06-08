--斗地主牌桌--提示-------

local function AIinsidedoudizhulineFunc(cards)
	if #cards == 1 then
		return cards
	end

	local xcards = {}
	for i=1,#cards,1 do
		xcards[i] = cards[i]
	end
	local intable = {}

	--从大到小的排序
	_G.table.sort(xcards,_G.doudizhuGL.DDCompareBSFunc)

	--找出手中所有的炸,并插入intable。
		if #xcards > 3 then
			local a = 1
			repeat
				if _G.MathFloor(xcards[a]/4) == _G.MathFloor(xcards[a+1]/4)
					and _G.MathFloor(xcards[a+2]/4) == _G.MathFloor(xcards[a+1]/4)
					and _G.MathFloor(xcards[a+2]/4) == _G.MathFloor(xcards[a+3]/4) then
					_G.table.insert(intable,#intable+1,xcards[a+3])
					_G.table.insert(intable,#intable+1,xcards[a+2])
					_G.table.insert(intable,#intable+1,xcards[a+1])
					_G.table.insert(intable,#intable+1,xcards[a])
					_G.table.remove(xcards,a)
					_G.table.remove(xcards,a)
					_G.table.remove(xcards,a)
					_G.table.remove(xcards,a)
					a = a - 1
				end
				a = a + 1
			until a >= #xcards-2
		end

	--找到xcards中的所有3条插入intable
		if #xcards >= 3 then
			local a = 1
			repeat
				if _G.MathFloor(xcards[a]/4) == _G.MathFloor(xcards[a+1]/4)
					and _G.MathFloor(xcards[a+2]/4) == _G.MathFloor(xcards[a+1]/4) then
					_G.table.insert(intable,#intable+1,xcards[a+2])
					_G.table.insert(intable,#intable+1,xcards[a+1])
					_G.table.insert(intable,#intable+1,xcards[a])
					_G.table.remove(xcards,a)
					_G.table.remove(xcards,a)
					_G.table.remove(xcards,a)
					a = a - 1
				end
				a = a + 1
			until a >= #xcards-1
		end
	--找到剩余牌中的所有对子插入intable
		if #xcards >= 2 then
			local a = 1
			repeat
				if _G.MathFloor(xcards[a]/4) == _G.MathFloor(xcards[a+1]/4)
					and xcards[a] < 64 then
					_G.table.insert(intable,#intable+1,xcards[a+1])
					_G.table.insert(intable,#intable+1,xcards[a])
					_G.table.remove(xcards,a)
					_G.table.remove(xcards,a)
					a = a - 1
				end
				a = a + 1
			until a >= #xcards
		end

	--将剩余牌插入intable
		if (#xcards > 0) then
			for i=1,#xcards,1 do
				_G.table.insert(intable,#intable+1,xcards[i])
			end
		end

	return intable
end


--找-到-手--中-所-有-大-于-出--牌-的-牌
local function AIFindBigCardFunc(cards,hands)--入参内部牌号={34,53,63,....}
	local xcards = hands
	local tablecards = AIinsidedoudizhulineFunc(cards)
	local ycards = {}
	--找出手牌中所有大于出牌的牌
	if _G.doudizhuGL.DDZIsFloorFunc(_G.doudizhuGL.DDZunAbsoluteAllFunc(tablecards)) ~= 0
		or _G.doudizhuGL.DDZIsTwoFloorFunc(_G.doudizhuGL.DDZunAbsoluteAllFunc(tablecards)) ~= 0
		or _G.doudizhuGL.DDZIsThreeFloorFunc(_G.doudizhuGL.DDZunAbsoluteAllFunc(tablecards)) ~= 0
		or _G.doudizhuGL.DDZIsFourFloorFunc(_G.doudizhuGL.DDZunAbsoluteAllFunc(tablecards)) ~= 0 then
		for i=#xcards,1,-1 do
			if _G.MathFloor(xcards[i]/4) > _G.MathFloor(tablecards[#tablecards]/4) and xcards[i] < 60 then
				_G.table.insert(ycards,#ycards+1,xcards[i])
			end
		end
	else
		for i=#xcards,1,-1 do
			if _G.MathFloor(xcards[i]/4) > _G.MathFloor(tablecards[1]/4) and tablecards[1] ~= 64 then
				_G.table.insert(ycards,1,xcards[i])
			elseif _G.MathFloor(xcards[i]/4) == _G.MathFloor(tablecards[1]/4) and tablecards[1] == 64 then
				_G.table.insert(ycards,1,xcards[i])
			end
		end
	end
	return ycards--返回所有大于出牌的牌，内部牌号。

end

--把-炸-和-王-炸-加-入-提-示
local function AIInsertBombFunc(hands)--入参内部牌号={34,53,63,....}
	local intable = {}
	local xcards = hands
	--找出手中所有的炸和王炸,并插入intable。
	_G.table.sort(xcards)
	if #xcards > 3 then
		for i=4,#xcards,1 do--普通“炸弹”
			if _G.MathFloor(xcards[i]/4) == _G.MathFloor(xcards[i-1]/4)
			and _G.MathFloor(xcards[i-1]/4) == _G.MathFloor(xcards[i-2]/4)
			and _G.MathFloor(xcards[i-2]/4) == _G.MathFloor(xcards[i-3]/4) then
				intable[#intable+1] = {}
				intable[#intable][4] = xcards[i-3]
				intable[#intable][3] = xcards[i-2]
				intable[#intable][2] = xcards[i-1]
				intable[#intable][1] = xcards[i]
			end
		end
	end
	if #xcards > 1 then
		if xcards[#xcards] == 65 and xcards[#xcards-1] == 64 then--“王炸”
			intable[#intable+1] = {}
			intable[#intable][1] = 65
			intable[#intable][2] = 64
		end
		if xcards[1] == 65 and xcards[2] == 64 then--“王炸”
			intable[#intable+1] = {}
			intable[#intable][1] = 65
			intable[#intable][2] = 64
		end
	end

	return intable
end

--对-子-智-能-提-示
local function AIPairAICardFunc(cards,hands)
	local intable = AIInsertBombFunc(hands)
	local ycards = AIFindBigCardFunc({10},hands)

		--第一步：提取出剩余牌(ycards)中绝对值相同的牌,插入step1。再把剩余2\王插入step1_king。
			local step1 = {}
			local step1_king = {}
			local a=1
			repeat
				if ycards[a] < 60 and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 and ycards[a] <64 and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 and ycards[a] < 64 and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1_king,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				end
				a=a+1
			until a >= #ycards
			if #ycards > 0 then
				local a = 1
				repeat
					if ycards[a] > 63 then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards+1
			end

		--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2 。
			local step2 = {}
			if #ycards > 4 then
				_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
				repeat
					local start = 0
					local j = 1
					repeat
						for k=#ycards,j+4,-1 do
							if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
								and k-j > 3 then
								start = 1
								for l=k,j,-1 do
									_G.table.insert(step2,1,ycards[l])
									_G.table.remove(ycards,l)
								end
								j = j - 1
								break
							end
						end
						j = j + 1
					until j >= #ycards-3
				until #ycards < 5 or start == 0
			end
			if #step2 > 0 then
				step2 = AIFindBigCardFunc(cards,step2)
			end

		--第三步：将step1\step1_king\ycards 合并，得ycards。
			if (step1[1]) then
				for i=1,#step1,1 do
					_G.table.insert(ycards,1,step1[i])
				end
			end
			if (step1_king[1]) then
				for i=1,#step1_king,1 do
					_G.table.insert(ycards,1,step1_king[i])
				end
			end
			if #ycards > 1 then
				ycards = AIFindBigCardFunc(cards,ycards)
				_G.table.sort(ycards)
			end

		--第四步：找到ycards中的对子（双张）插入step4 (单对+顺中3)
			local step4 = {}
			if #ycards > 2 then
				a = 1
				repeat
					if a == 1 and #ycards > 2
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+2]/4)
						and ycards[a] < 64 then
						_G.table.insert(step4,1,ycards[a])
						_G.table.insert(step4,1,ycards[a+1])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					elseif a > 1 and a < #ycards-1
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+2]/4)
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a-1]/4)
						and ycards[a] < 64 then
						_G.table.insert(step4,1,ycards[a])
						_G.table.insert(step4,1,ycards[a+1])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					elseif a > 1 and a >= #ycards-1
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a-1]/4)
						and ycards[a] < 64 then
						_G.table.insert(step4,1,ycards[a])
						_G.table.insert(step4,1,ycards[a+1])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					elseif #ycards == 2
						and ycards[a] < 64
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step4,1,ycards[a])
						_G.table.insert(step4,1,ycards[a+1])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
					end
					a = a + 1
				until a >= #ycards
			elseif #ycards == 2 then
				if _G.MathFloor(ycards[1]/4) == _G.MathFloor(ycards[2]/4)
					and ycards[1] < 64 then
					_G.table.insert(step4,1,ycards[1])
					_G.table.insert(step4,1,ycards[2])
					_G.table.remove(ycards,1)
					_G.table.remove(ycards,1)
				end
			end

		--第五步：找到剩余牌中的所有对子插入step5（顺中4+单3+单4）
			local step5 = {}
			if #ycards >= 3 then
				a = 1
				repeat
					if _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and _G.MathFloor(ycards[a+2]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step5,1,ycards[a])
						_G.table.insert(step5,1,ycards[a+1])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards-1
			end
			if #ycards >= 2 then
				a = 1
				repeat
					if _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and ycards[a] < 64 then
						_G.table.insert(step5,1,ycards[a])
						_G.table.insert(step5,1,ycards[a+1])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards
			end

		--第六步：合并ycards\step2 ，并找到其中的对插入step6 (顺中对)
			local step6 = {}
			if (step2[1]) and (ycards[1]) then
				table.sort(step2)
				for i=1,#step2,1 do
					for j=1,#ycards,1 do
						if _G.MathFloor(step2[i]/4) == _G.MathFloor(ycards[j]/4) then
							_G.table.insert(step6,1,step2[i])
							_G.table.insert(step6,1,ycards[j])
							break
						end
					end
				end
			end

		--第七步：将step4\step5\step6 依次插入intable并返回
			if (step5[1]) then
				_G.table.sort(step5,_G.doudizhuGL.DDCompareBSFunc)
				for i=1,#step5,2 do
					_G.table.insert(intable,1,{step5[i+1],step5[i]})
				end
			end

			if (step6[1]) then
				for i=1,#step6,2 do
					_G.table.insert(intable,1,{step6[i+1],step6[i]})
				end
			end

			if (step4[1]) then
				for i=1,#step4,2 do
					_G.table.insert(intable,1,{step4[i+1],step4[i]})
				end
			end
	return intable
end

--单-张-智-能-提-示
local function AIsingleAIFunc(cards,hands)
	local intable = AIInsertBombFunc(hands)
	local ycards = AIFindBigCardFunc({10},hands)
	
			--第一步：提取出剩余牌(ycards)中绝对值相同的牌,插入step1。再把单个的2\王插入step1_king ,多张的2插入STEP3 。
			local step1 = {}
			local step3 = {}
			local step1_king = {}
			local a=1
			repeat
				if ycards[a] < 60
					and #ycards > 1
					and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 and ycards[a] < 64
					and #ycards > 1
					and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 and ycards[a] < 64
					and #ycards > 1
					and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
					and (#step1 == 0 or _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(step1[1]/4)) then
					_G.table.insert(step1_king,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 and ycards[a] < 64
					and #ycards > 1
					and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
					and #step1 > 0
					and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
					_G.table.insert(step3,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif #ycards == 1
					and ycards[1] > 59 and ycards[1] < 64
					and #step1 > 0
					and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
					_G.table.insert(step3,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif #ycards == 1
					and ycards[1] > 59 and ycards[1] < 64
					and (#step1 == 0 or  _G.MathFloor(ycards[1]/4) ~= _G.MathFloor(step1[1]/4)) then
					_G.table.insert(step1_king,1,ycards[1])
					_G.table.remove(ycards,1)
					a=a-1
				end
				a=a+1
			until a >= #ycards
			if #ycards > 0 then
				local a = 1
				repeat
					if ycards[a] > 63 then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards+1
			end
			if #step1 > 0 then
				step1 = AIFindBigCardFunc(cards,step1)
			end
			if #step1_king > 0 then
				step1_king = AIFindBigCardFunc(cards,step1_king)
			end
			if #step3 > 0 then
				step3 = AIFindBigCardFunc(cards,step3)
			end

			--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2。
			local step2 = {}
			if #ycards > 4 then
				_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
				repeat
					local start = 0
					local j = 1
					repeat
						for k=#ycards,j+4,-1 do
							if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
								and k-j > 3 then
								start = 1
								for l=k,j,-1 do
									_G.table.insert(step2,1,ycards[l])
									_G.table.remove(ycards,l)
								end
								j = j - 1
								break
							end
						end
						j = j + 1
					until j >= #ycards-3
				until #ycards < 5 or start == 0
			end
			if #step2 > 0 then
				step2 = AIFindBigCardFunc(cards,step2)
			end
			if #ycards > 0 then
				ycards = AIFindBigCardFunc(cards,ycards)
			end

			--第三步：将剩余牌与step1比对，提取相同的牌到step3。
			if (step1[1] and ycards[1]) then
				local i=1
				repeat
					for j=1,#step1,1 do
						if _G.MathFloor(ycards[i]/4) == _G.MathFloor(step1[j]/4) then
							_G.table.insert(step3,1,ycards[i])
							_G.table.remove(ycards,i)
							i=i-1
							break
						end
					end
					i = i + 1
				until i >= #ycards+1
			end

			--第四步：将step1中的单牌提取出来，与step2中的牌比对，如果相同即插入ycards。
			if (step2[1] and step1[1] and #step1>1) then
					for i=1,#step1,1 do
						local j = 1
						repeat
							if i ~= 1
								and i ~= #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif  i == 1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif i == #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							end
							j = j + 1
						until j >= #step2+1
					end
				elseif (step2[1] and #step1 == 1) then
					for i=1,#step2,1 do
						if _G.MathFloor(step2[i]/4) == _G.MathFloor(step1[1]/4) then
							_G.table.insert(ycards,1,step2[i])
							_G.table.remove(step2,i)
							break
						end
					end
				end

			--第五步：将 ycards step1_king step3 step2 插入intable并返回。
			--先提示去顺后的单张+顺中对子的单张，
			--再提示单个的王和2，
			--再提示最后提示顺中的单张，
			--单对、3条、炸中的单张。
			if #step1_king > 1 then
				_G.table.sort(step1_king)
				if step1_king[#step1_king] == 65 and
					step1_king[#step1_king-1] == 64 then
					step1_king[#step1_king],step3[#step3+1] = step3[#step3+1],step1_king[#step1_king]
					_G.table.remove(step1_king,#step1_king)
				end
			end
			if (step3[1]) then
				_G.table.sort(step3)
				for i=#step3,1,-1 do
					_G.table.insert(intable,1,{step3[i]})
				end
			end

			if (step2[1]) then
				_G.table.sort(step2)
				for i=#step2,1,-1 do
					_G.table.insert(intable,1,{step2[i]})
				end
			end

			if (step1_king[1]) then
				for i=#step1_king,1,-1 do
					_G.table.insert(intable,1,{step1_king[i]})
				end
			end

			if (ycards[1]) then
				_G.table.sort(ycards)
				for i=#ycards,1,-1 do
					_G.table.insert(intable,1,{ycards[i]})
				end
			end
	return intable
end
--AIsingleAIFunc(tablecards,hands)

--3-条-智-能-提-示
local function AIThreeAICardFunc(cards,hands)
	local intable = AIInsertBombFunc(hands)
	local ycards = AIFindBigCardFunc({10},hands)

		--第一步：提取出剩余牌(ycards)中绝对值相同的牌,插入step1。再把剩余2\王插入step1_king。
			local step1 = {}
			local step1_king = {}
			local a=1
			repeat
				if ycards[a] < 60 and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 and ycards[a] < 64 and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 and ycards[a] < 64 and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4) then
					_G.table.insert(step1_king,1,ycards[a])
					_G.table.remove(ycards,a)
					a=a-1
				end
				a=a+1
			until a >= #ycards
			if #ycards > 0 then
				local a = 1
				repeat
					if ycards[a] > 63 then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards+1
			end

		--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2 。
			local step2 = {}
			_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
			if #ycards > 4 then
				repeat
					local start = 0
					local j = 1
					repeat
						for k=#ycards,j+4,-1 do
							if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
								and k-j > 3 then
								start = 1
								for l=k,j,-1 do
									_G.table.insert(step2,1,ycards[l])
									_G.table.remove(ycards,l)
								end
								j = j - 1
								break
							end
						end
						j = j + 1
					until j >= #ycards-3
				until #ycards < 5 or start == 0
			end

		--第三步：将step1\step1_king\ycards 合并，得ycards。
			if (step1[1]) then
				for i=1,#step1,1 do
					_G.table.insert(ycards,1,step1[i])
				end
			end
			if (step1_king[1]) then
				for i=1,#step1_king,1 do
					_G.table.insert(ycards,1,step1_king[i])
				end
			end
			if #ycards > 0 then
				ycards = AIFindBigCardFunc(cards,ycards)
			end

		--第四步：找到ycards中的单3插入step4 （单三，顺中4）
			local step4 = {}
			_G.table.sort(ycards)

		--第五步：找到ycards中的所有3条 （4中3）
			local step5 = {}
			if #ycards >= 3 then
				local a = 1
				repeat
					if _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and _G.MathFloor(ycards[a+2]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step5,1,ycards[a])
						_G.table.insert(step5,1,ycards[a+1])
						_G.table.insert(step5,1,ycards[a+2])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards-1
			end

		--第六步：合并step2\ycards ,并找到其中的所有3条，插入step6 (顺中3)
			local step6 = {}
			if (step2[1]) then
				for i=1,#step2,1 do
					_G.table.insert(ycards,1,step2[i])
				end
			end

			_G.table.sort(ycards)
			if #ycards >= 3 then

				local a = 1
				repeat
					if _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and _G.MathFloor(ycards[a+2]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step6,1,ycards[a])
						_G.table.insert(step6,1,ycards[a+1])
						_G.table.insert(step6,1,ycards[a+2])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards-1
			end


		--第七步：将step4\step5\step6 依次插入intable并返回
			if (step6[1]) then
				for i=1,#step6,3 do
					_G.table.insert(intable,1,{step6[i],step6[i+1],step6[i+2]})
				end
			end

			if (step5[1]) then
				for i=1,#step5,3 do
					_G.table.insert(intable,1,{step5[i],step5[i+1],step5[i+2]})
				end
			end
			if (step4[1]) then
				for i=1,#step4,3 do
					_G.table.insert(intable,1,{step4[i],step4[i+1],step4[i+2]})
				end
			end
	return intable
end

--3-带-2-智-能-提-示
local function AIThreePlusTwoFunc(cards,hands)
	cards = AIinsidedoudizhulineFunc(cards)
	local zcards = AIThreeAICardFunc({cards[1],cards[2],cards[3]},hands)

	--如果手牌中没有大于出牌的牌,直接返回intable。
		if (not zcards) then
			return zcards --提示“不出”（intable内没有值）
		end

	--如果手牌中有大于出牌的牌
	--先找到所有的对子
	local acards = AIPairAICardFunc({11,10},hands)

	--判断对牌是否与3条相同，不相同则将单牌插入zcards
	for i=1,#zcards,1 do
		for j=1,#acards,1 do
			if _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
				and #zcards[i] == 3 then
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j][2])
				break
			end
		end
	end

	--返回zcards
	if (zcards[1]) and #zcards[1] == 5 then
		return zcards
	elseif (zcards[1]) and #zcards[1] == 3 and #zcards == 1 then
		_G.table.remove(zcards,1)
		return zcards
	else
		return zcards
	end
end

--3-带-1-智-能-提-示
local function AIThreePlusoneFunc(cards,hands)
	if #hands == 4 and _G.doudizhuGL.DDZIsBombFunc(hands) ~= 0 then
		local zcards = AIInsertBombFunc(hands)
		return zcards
	end
	cards = AIinsidedoudizhulineFunc(cards)
	local zcards = AIThreeAICardFunc({cards[1],cards[2],cards[3]},hands)

	--如果手牌中没有大于出牌的牌,直接返回zcards
		if (#zcards < 1) then
			return zcards --提示“不出”（zcards 内没有值）
		end

	--如果手牌中有大于出牌的牌
	--先找到所有的单牌

	local acards = AIsingleAIFunc({11},hands)

	--判断单牌是否与3条相同，不相同则将单牌插入zcards
	for i=1,#zcards,1 do
		for j=1,#acards,1 do
			if _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
				and #zcards[i] == 3 then
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
				break
			end
		end
	end

	--返回zcards
	if #zcards > 3 and _G.MathFloor(zcards[1][1]/4) ~= _G.MathFloor(zcards[1][4]/4) then
		return zcards
	else
		return zcards
	end
end

--4-带-2-智-能-提-示
local function AIFourPlusTwoFunc(cards,hands)
	local zcards = AIFindBigCardFunc(cards,hands)

	zcards = AIInsertBombFunc(hands)

	--如果手牌中没有大于出牌的牌,直接返回intable。
		if (#zcards < 1 ) or zcards[1] == 2 then
			return zcards --提示“不出”（intable内没有值）
		end

	--如果手牌中有大于出牌的4条
	--先找到需要插入的单牌和对牌
	local intable = {}

		local ycards = AIFindBigCardFunc({11},hands)

		--如果手牌中有大于出牌的牌
			if (ycards[1]) then

				--第一步：提取出剩余牌(ycards)中绝对值相同的牌,插入step1。再把单个的2\王插入step1_king ,多张得2插入STEP3 。
				local step1 = {}
				local step3 = {}
				local step1_king = {}
				local a=1
				repeat
					if ycards[a] < 60
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and (#step1 == 0 or _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and (#step1 == 0 or  _G.MathFloor(ycards[1]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[1])
						_G.table.remove(ycards,1)
						a=a-1
					end
					a=a+1
				until a >= #ycards
				if #ycards > 0 then
					local a = 1
					repeat
						if ycards[a] > 63 then
							_G.table.insert(step1_king,1,ycards[a])
							_G.table.remove(ycards,a)
							a = a - 1
						end
						a = a + 1
					until a >= #ycards+1
				end

				--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2。
				local step2 = {}
				if #ycards > 4 then
					_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
					repeat
						local start = 0
						local j = 1
						repeat
							for k=#ycards,j+4,-1 do
								if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
									and k-j > 3 then
									start = 1
									for l=k,j,-1 do
										_G.table.insert(step2,1,ycards[l])
										_G.table.remove(ycards,l)
									end
									j = j - 1
									break
								end
							end
							j = j + 1
						until j >= #ycards-3
					until #ycards < 5 or start == 0
				end

				--第三步：将剩余牌与step1比对，提取相同的牌到step3。
				local step3 = {}
				if (step1[1] and ycards[1]) then
					local i=1
					repeat
						for j=1,#step1,1 do
							if _G.MathFloor(ycards[i]/4) == _G.MathFloor(step1[j]/4) then
								_G.table.insert(step3,1,ycards[i])
								_G.table.remove(ycards,i)
								i=i-1
								break
							end
						end
						i = i + 1
					until i >= #ycards+1
				end

				--第四步：将step1中的单牌提取出来，与step2中的牌比对，如果相同即插入ycards。
				if (step2[1] and #step1 > 1) then
					for i=1,#step1,1 do
						local j = 1
						repeat
							if i ~= 1
								and i ~= #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif  i == 1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif i == #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							end
							j = j + 1
						until j >= #step2+1
					end
				elseif (step2[1] and #step1 == 1) then
					for i=1,#step2,1 do
						if _G.MathFloor(step2[i]/4) == _G.MathFloor(step1[1]/4) then
							_G.table.insert(ycards,1,step2[i])
							_G.table.remove(step2,i)
							break
						end
					end
				end


				--第五步：将 ycards step1_king step3 step2 插入intable并返回。
				--先插入去顺后的单张+顺中对子的单张，
				--再插入单个的王和2，
				--再插入单对
				--再插入顺中的单张,
				--最后插入单对、3条、炸中的单张。
				if (step3[1]) then
					_G.table.sort(step3)
					for i=#step3,1,-1 do
						_G.table.insert(intable,1,{step3[i]})
					end
				end
				if (step2[1]) then
					for i=1,#step2,1 do
						_G.table.insert(intable,1,{step2[i]})
					end
				end

				if (step1_king[1]) then
					for i=#step1_king,1,-1 do
						_G.table.insert(intable,1,{step1_king[i]})
					end
				end

				local xcards = AIPairAICardFunc({11,10},hands)
				for i =#xcards,1,-1 do
					if #xcards[i] == 2 and xcards[i][1] < 64 then
						_G.table.insert(intable,1,xcards[i])
					end
				end
				if (ycards[1]) then
					_G.table.sort(ycards)
					for i=#ycards,1,-1 do
						_G.table.insert(intable,1,{ycards[i]})
					end
				end

			end
	local acards = intable

	--判断单牌和对牌是否与4条相同，不相同则将单牌插入zcards
		for i=1,#zcards,1 do
			if #zcards[i] == 4 then
				local a = 0
				local j = 1
				repeat
					if _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][#zcards[i]]/4) then
						if (a ~= 1 or #acards ~= 2) then
							for k=1,#acards[j],1 do
								_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
								a = a + 1
							end
						elseif a == 1 and #acards == 2  then
							_G.table.remove(zcards[i],#zcards[i])
							a =  a - 1
							for k=1,#acards[j],1 do
								_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
								a = a + 1
							end
						end
					end
					j = j + 1
				until j >= #acards+1 or a == 2
			end
		end

	--将炸弹插入zcards
	local intable = AIInsertBombFunc(hands)
	if zcards[#zcards][1] == 65 then
		_G.table.remove(zcards,#zcards)
	end
	for i=1,#intable,1 do
		_G.table.insert(zcards,#zcards+1,intable[i])
	end

	--返回zcards
	return zcards
end

--顺-子-智--能-提-示
local function AIStraiagtAIAIFunc(cards,hands)
	local intable = AIInsertBombFunc(hands)
	local ycards = AIFindBigCardFunc(cards,hands)

		--如果手牌中没有大于出牌的牌,直接返回intable。
		if (#ycards < #cards and intable[1]) then
			return intable --提示“炸弹”
		elseif (#ycards < #cards and (not intable[1])) then
			return intable --提示“不出”（intable内没有值）
		end

		--第一步：删除剩余牌(ycards)中绝对值相同的牌
			local a=1
			repeat
				if ycards[a] < 60 and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 then
					_G.table.remove(ycards,a)
					a=a-1
				end
				a=a+1
			until a >= #ycards

		--第二步：找到ycards 中所有符合cards 长度的顺牌插入intable
			if #ycards > #cards-1 then
				_G.table.sort(ycards)
				for i=#ycards-#cards+1,1,-1 do
					if _G.MathFloor(ycards[i+#cards-1]/4) - _G.MathFloor(ycards[i]/4) == #cards-1 then
						_G.table.insert(intable,1,{})
						for j=#cards-1+i,i,-1 do
							_G.table.insert(intable[1],1,ycards[j])
						end
					end
				end
			end

	return intable
end

--4-带-4-智-能-提示
local function AIFourPlusFourFunc(cards,hands)
	local zcards = AIInsertBombFunc(hands)

	--如果手牌中没有大于出牌的牌,直接返回intable。
		if (#zcards < 1 ) or zcards[1] == 2 then
			return zcards --提示“不出”（intable内没有值）
		end

	--如果手牌中有大于出牌的牌
	--先找到所有的对牌
	local acards = AIPairAICardFunc({11,10},hands)

	--判断对是否与4条相同，不相同则将对牌插入zcards
	for i=#zcards,1,-1 do
		for j=1,#acards-2,1 do
			if _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
				and _G.MathFloor(acards[j+1][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
				and #zcards[i] == 4 then
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j+1][1])
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j+1][2])
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j][2])
				break
			elseif _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
				and _G.MathFloor(acards[j+2][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
				and #zcards[i] == 4 then
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j+2][1])
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j+2][2])
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
				_G.table.insert(zcards[i],#zcards[i]+1,acards[j][2])
				break
			end
		end
	end
	--判断是否成功插入对子
	if #zcards[1] == 4 then --没成功插入对子
		return zcards
	else

		--将炸弹插入zcards
		local intable = AIInsertBombFunc(hands)
		if zcards[#zcards][1] > 63 then
			_G.table.remove(zcards,#zcards)
		end
		for i=1,#intable,1 do
			_G.table.insert(zcards,#zcards+1,intable[i])
		end

		return zcards
	end
end

--双-顺-智-能-提-示
local function AIDoublestraiagtAIFunc(cards,hands)
	local intable = AIInsertBombFunc(hands)
	local ycards = AIFindBigCardFunc(cards,hands)

		--如果手牌中没有大于出牌的牌,直接返回intable。
		if (#ycards < 6 and intable[1]) then
			return intable --提示“炸弹”
		elseif (#ycards < 6 and (not intable[1])) then
			return intable --提示“不出”（intable内没有值）
		end
		--如果手牌中有大于出牌的牌
		--第一步：找到剩余牌中的所有对子插入step5
			local step5 = {}
			local a = 1
			repeat
				if _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
					and _G.MathFloor(ycards[a+2]/4) == _G.MathFloor(ycards[a+1]/4)
					and ycards[a] < 60 then
					_G.table.insert(step5,1,ycards[a])
					_G.table.insert(step5,1,ycards[a+1])
					_G.table.remove(ycards,a)
					_G.table.remove(ycards,a)
					_G.table.remove(ycards,a)
					a = a - 1
				end
				a = a + 1
			until a >= #ycards-1
			if #ycards >= 2 then
				a = 1
				repeat
					if _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and ycards[a] < 60 then
						_G.table.insert(step5,1,ycards[a])
						_G.table.insert(step5,1,ycards[a+1])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards
			end

			if #step5 > #cards-1 then
				_G.table.sort(step5,_G.doudizhuGL.DDCompareBSFunc)
				for i=1,#step5-#cards+2,2 do
					if _G.MathFloor(step5[i]/4) - _G.MathFloor(step5[i+#cards-2]/4) == #cards/2-1 then
						_G.table.insert(intable,1,{})
						for j=i,i+#cards-2,2 do
							_G.table.insert(intable[1],1,step5[j+1])
							_G.table.insert(intable[1],1,step5[j])
						end
					end
				end
			end

	return intable
end

--智-能-提-示-6-带-2
local function AISixPlusTwoFunc(cards,hands)
	local zcards = {}
	local intable = AIInsertBombFunc(hands)

	--判断特殊情况 手中牌正好是两个炸弹 则直接提示炸弹。
	_G.table.sort(hands)
	if #hands == 8 and _G.MathFloor(hands[1]/4) == _G.MathFloor(hands[4]/4) and _G.MathFloor(hands[5]/4) == _G.MathFloor(hands[8]/4) then
		zcards = AIInsertBombFunc(hands)
		return zcards
	end
	cards = AIinsidedoudizhulineFunc(cards)
	--找出3顺中最小的内部绝对值，让后将最小绝对值作为 入参的第一个位置 入给AIThreestraiagtAIFunc
	if _G.MathFloor(cards[1]/4) < _G.MathFloor(cards[4]/4) then
		zcards = AIThreestraiagtAIFunc({cards[1],cards[2],cards[3],cards[4],cards[5],cards[6]},hands)
	else
		zcards = AIThreestraiagtAIFunc({cards[6],cards[5],cards[4],cards[3],cards[2],cards[1]},hands)
	end

	--如果手牌中没有大于出牌的牌,直接返回zcards。
		if (not zcards[1]) then
			return zcards --提示“不出”（intable内没有值）
		elseif (#zcards > 0 and #zcards[1] ~= 6) then
			return zcards
		end

	--如果手牌中有大于出牌的牌
	--先找到需要插入的单牌和对牌
	local intable = {}

		local ycards = AIFindBigCardFunc({11},hands)

		--如果手牌中有大于出牌的牌
			if (ycards[1]) then

				--第一步：提取出剩余牌(ycards)中绝对值相同的牌,插入step1。再把单个的2\王插入step1_king ,多张得2插入STEP3 。
				local step1 = {}
				local step3 = {}
				local step1_king = {}
				local a=1
				repeat
					if ycards[a] < 60
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and (#step1 == 0 or _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and (#step1 == 0 or  _G.MathFloor(ycards[1]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[1])
						_G.table.remove(ycards,1)
						a=a-1
					end
					a=a+1
				until a >= #ycards
				if #ycards > 0 then
				local a = 1
				repeat
					if ycards[a] > 63 then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards+1
			end

				--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2。
				local step2 = {}
				if #ycards > 4 then
					_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
					repeat
						local start = 0
						local j = 1
						repeat
							for k=#ycards,j+4,-1 do
								if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
									and k-j > 3 then
									start = 1
									for l=k,j,-1 do
										_G.table.insert(step2,1,ycards[l])
										_G.table.remove(ycards,l)
									end
									j = j - 1
									break
								end
							end
							j = j + 1
						until j >= #ycards-3
					until #ycards < 5 or start == 0
				end

				--第三步：将剩余牌与step1比对，提取相同的牌到step3。
				local step3 = {}
				if (step1[1] and ycards[1]) then
					local i=1
					repeat
						for j=1,#step1,1 do
							if _G.MathFloor(ycards[i]/4) == _G.MathFloor(step1[j]/4) then
								_G.table.insert(step3,1,ycards[i])
								_G.table.remove(ycards,i)
								i=i-1
								break
							end
						end
						i = i + 1
					until i >= #ycards+1
				end


				--第四步：将step1中的单牌提取出来，与step2中的牌比对，如果相同即插入ycards。
				if (step2[1] and #step1 > 1) then
					for i=1,#step1,1 do
						local j = 1
						repeat
							if i ~= 1
								and i ~= #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif  i == 1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif i == #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							end
							j = j + 1
						until j >= #step2+1
					end
				elseif (step2[1] and #step1 == 1) then
					for i=1,#step2,1 do
						if _G.MathFloor(step2[i]/4) == _G.MathFloor(step1[1]/4) then
							_G.table.insert(ycards,1,step2[i])
							_G.table.remove(step2,i)
							break
						end
					end
				end

				--第五步：将 ycards step1_king step3 step2 插入intable并返回。
				--先插入去顺后的单张+顺中对子的单张，
				--再插入单个的王和2，
				--再插入顺中的单张,
				--再插入对子
				--最后插入单对、3条、炸中的单张。
				if (step3[1]) then
					_G.table.sort(step3)
					for i=#step3,1,-1 do
						_G.table.insert(intable,1,{step3[i]})
					end
				end
				if (step2[1]) then
					for i=1,#step2,1 do
						_G.table.insert(intable,1,{step2[i]})
					end
				end

				if (step1_king[1]) then
					for i=#step1_king,1,-1 do
						_G.table.insert(intable,1,{step1_king[i]})
					end
				end

				local xcards = AIPairAICardFunc({11,10},hands)
				for i =#xcards,1,-1 do
					if #xcards[i] == 2 and xcards[i][1] < 64 then
						_G.table.insert(intable,1,xcards[i])
					end
				end
				if (ycards[1]) then
					_G.table.sort(ycards)
					for i=#ycards,1,-1 do
						_G.table.insert(intable,1,{ycards[i]})
					end
				end

			end
	local acards = intable
	--先找到所有的单牌

	--判断单牌是否与3条相同，不相同则将单牌插入zcards
	for i=1,#zcards,1 do
		if #zcards[i] == 6 then
			local a = 0
			local j = 1
			repeat
				if _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][4]/4) then
					if (a ~= 1 or #acards ~= 2) and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][#zcards[i]]/4) then
						for k=1,#acards[j],1 do
							_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
							a = a + 1
						end
					elseif a == 1 and #acards == 2  then
						_G.table.remove(zcards[i],#zcards[i])
						a =  a - 1
						for k=1,#acards[j],1 do
							_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
							a = a + 1
						end
					end
				end
				j = j + 1
			until j >= #acards+1 or a == 2
		end
	end

	if #zcards[1] == 6 then
		zcards = {hands}
		return zcards
	end

	--返回zcards
	if _G.MathFloor(zcards[1][1]/4) ~= _G.MathFloor(zcards[1][7]/4) then
		return zcards
	else
		return zcards
	end
end

--3-顺-智-能-提-示
local function AIThreestraiagtAIFunc(cards,hands)
	local intable = AIInsertBombFunc(hands)
	local ycards = AIFindBigCardFunc(cards,hands)

		--如果手牌中没有大于出牌的牌,直接返回intable。
		if (#ycards < 6 and intable[1]) then
			return intable --提示“炸弹”
		elseif (#ycards < 6 and (not intable[1])) then
			return intable --提示“不出”（intable内没有值）
		end
		--如果手牌中有大于出牌的牌
		--第一步：找到剩余牌中的所有小于2的3条插入step5
			local step5 = {}
			local a = 1
				repeat
					if _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4)
						and _G.MathFloor(ycards[a+1]/4) == _G.MathFloor(ycards[a+2]/4)
						and ycards[a] < 60 then
						_G.table.insert(step5,1,ycards[a])
						_G.table.insert(step5,1,ycards[a+1])
						_G.table.insert(step5,1,ycards[a+2])
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						_G.table.remove(ycards,a)
						a = a - 1
					end
					a = a + 1
				until a >= #ycards-1

			if #step5 > #cards-1 then
				_G.table.sort(step5,_G.doudizhuGL.DDCompareBSFunc)
				for i=1,#step5-#cards+3,3 do
					if _G.MathFloor(step5[i]/4) - _G.MathFloor(step5[i+#cards-3]/4) == #cards/3-1 then
						_G.table.insert(intable,1,{})
						for j=i,i+#cards-3,3 do
							_G.table.insert(intable[1],1,step5[j+2])
							_G.table.insert(intable[1],1,step5[j+1])
							_G.table.insert(intable[1],1,step5[j])
						end
					end
				end
			end

	return intable
end

--智-能-提-示-6-带-4
local function AISixPlusFourFunc(cards,hands)
	local zcards = {}
	cards = AIinsidedoudizhulineFunc(cards)
	if _G.MathFloor(cards[1]/4) < _G.MathFloor(cards[4]/4) then
		zcards = AIThreestraiagtAIFunc({cards[1],cards[2],cards[3],cards[4],cards[5],cards[6]},hands)
	else
		zcards = AIThreestraiagtAIFunc({cards[6],cards[5],cards[4],cards[3],cards[2],cards[1]},hands)
	end

	--如果手牌中没有大于出牌的牌,直接返回zcards。
		if (not zcards[1]) then
			return zcards --提示“不出”（intable内没有值）
		elseif (#zcards > 0 and #zcards[1] ~= 6) then
			return zcards
		end
	--如果手牌中有大于出牌的牌
	--先找到所有的对牌
	local acards ={}
	acards = AIPairAICardFunc({11,10},hands)

	--判断对牌是否与3条相同，不相同则将对牌插入zcards
	for i=#zcards,1,-1 do
		if #zcards[i] == 6 then
			local a = 0
			local j = 1
			repeat
				if #acards[j] == 2 and acards[j][1] < 64
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][4]/4) then
						_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
						_G.table.insert(zcards[i],#zcards[i]+1,acards[j][2])
						a = a + 1
				end
				j = j + 1
			until j >= #acards+1 or a == 2
		end
	end
	--判断是否成功插入对子
	if #zcards[1] ~= 10 then --没成功插入对子

		local intable = AIInsertBombFunc(hands)
		return intable
	else

		return zcards
	end
end


--智-能-提-示-12-带-4
local function AITwelveplusfourAIFunc(cards,hands)
	local zcards = {}
	cards = AIinsidedoudizhulineFunc(cards)
	_G.table.sort(hands)
	--判断特殊情况 手中牌正好是两个炸弹 则直接提示炸弹。
	if #hands == 16 and _G.MathFloor(hands[1]/4) == _G.MathFloor(hands[4]/4)
		and _G.MathFloor(hands[5]/4) == _G.MathFloor(hands[8]/4)
		and _G.MathFloor(hands[9]/4) == _G.MathFloor(hands[12]/4)
		and _G.MathFloor(hands[13]/4) == _G.MathFloor(hands[16]/4) then
		zcards = AIInsertBombFunc(hands)
		return zcards
	end

	--找出3顺中最小的内部绝对值，让后将最小绝对值作为 入参的第一个位置 入给AIThreestraiagtAIFunc
	if _G.MathFloor(cards[1]/4) < _G.MathFloor(cards[10]/4) then
		zcards = AIThreestraiagtAIFunc({cards[1],cards[2],cards[3],cards[4],cards[5],cards[6],cards[7],cards[8],cards[9],cards[10],cards[11],cards[12]},hands)
	else
		zcards = AIThreestraiagtAIFunc({cards[12],cards[11],cards[10],cards[9],cards[8],cards[7],cards[6],cards[5],cards[4],cards[3],cards[2],cards[1]},hands)
	end

	--如果手牌中没有大于出牌的牌,直接返回zcards。
		if (not zcards[1]) then
			return zcards --提示“不出”（intable内没有值）
		elseif (#zcards > 0 and #zcards[1] ~= 12) then
			return zcards
		end

	--如果手牌中有大于出牌的牌
	--先找到需要插入的单牌和对牌
	local intable = {}

		local ycards = AIFindBigCardFunc({11},hands)

		--如果手牌中有大于出牌的牌
			if (ycards[1]) then

				--第一步：提取出剩余牌(ycards)中绝对值相同的牌,插入step1。再把单个的2\王插入step1_king ,多张得2插入STEP3 。
				local step1 = {}
				local step3 = {}
				local step1_king = {}
				local a=1
				repeat
					if ycards[a] < 60
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and (#step1 == 0 or _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and (#step1 == 0 or  _G.MathFloor(ycards[1]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[1])
						_G.table.remove(ycards,1)
						a=a-1
					end
					a=a+1
				until a >= #ycards
				if #ycards > 0 then
					local a = 1
					repeat
						if ycards[a] > 63 then
							_G.table.insert(step1_king,1,ycards[a])
							_G.table.remove(ycards,a)
							a = a - 1
						end
						a = a + 1
					until a >= #ycards+1
				end

				--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2。
				local step2 = {}
				if #ycards > 4 then
					_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
					repeat
						local start = 0
						local j = 1
						repeat
							for k=#ycards,j+4,-1 do
								if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
									and k-j > 3 then
									start = 1
									for l=k,j,-1 do
										_G.table.insert(step2,1,ycards[l])
										_G.table.remove(ycards,l)
									end
									j = j - 1
									break
								end
							end
							j = j + 1
						until j >= #ycards-3
					until #ycards < 5 or start == 0
				end

				--第三步：将剩余牌与step1比对，提取相同的牌到step3。
				local step3 = {}
				if (step1[1] and ycards[1]) then
					local i=1
					repeat
						for j=1,#step1,1 do
							if _G.MathFloor(ycards[i]/4) == _G.MathFloor(step1[j]/4) then
								_G.table.insert(step3,1,ycards[i])
								_G.table.remove(ycards,i)
								i=i-1
								break
							end
						end
						i = i + 1
					until i >= #ycards+1
				end

				--第四步：将step1中的单牌提取出来，与step2中的牌比对，如果相同即插入ycards。
				if (step2[1] and #step1 > 1) then
					for i=1,#step1,1 do
						local j = 1
						repeat
							if i ~= 1
								and i ~= #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif  i == 1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif i == #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							end
							j = j + 1
						until j >= #step2+1
					end
				elseif (step2[1] and #step1 == 1) then
					for i=1,#step2,1 do
						if _G.MathFloor(step2[i]/4) == _G.MathFloor(step1[1]/4) then
							_G.table.insert(ycards,1,step2[i])
							_G.table.remove(step2,i)
							break
						end
					end
				end

				--第五步：将 ycards step1_king step3 step2 插入intable并返回。
				--先提示去顺后的单张+顺中对子的单张，
				--再提示单个的王和2，
				--再提示顺中的单张,
				--再提示对子
				--最后提示单对、3条、炸中的单张。
				if (step3[1]) then
					_G.table.sort(step3)
					for i=#step3,1,-1 do
						_G.table.insert(intable,1,{step3[i]})
					end
				end


				local xcards = AIPairAICardFunc({11,10},hands)
				for i =#xcards,1,-1 do
					if #xcards[i] == 2 and xcards[i][1] < 64 then
						_G.table.insert(intable,1,xcards[i])
					end
				end

				if (step1_king[1]) then
					for i=#step1_king,1,-1 do
						_G.table.insert(intable,1,{step1_king[i]})
					end
				end

				if (step2[1]) then
					for i=1,#step2,1 do
						_G.table.insert(intable,1,{step2[i]})
					end
				end

				if (ycards[1]) then
					_G.table.sort(ycards)
					for i=#ycards,1,-1 do
						_G.table.insert(intable,1,{ycards[i]})
					end
				end

			end
	local acards = intable

	--判断单牌是否与3条相同，不相同则将单牌插入zcards
	for i=1,#zcards,1 do
		if #zcards[i] == 12 then
			local a = 0
			local j = 1
			repeat
				if _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][4]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][7]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][10]/4) then
					if (a ~= 3 or #acards ~= 2) and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][#zcards[i]]/4) then
						for k=1,#acards[j],1 do
							_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
							a = a + 1
						end
					elseif a == 3 and #acards == 2
						and _G.MathFloor(zcards[i][#zcards[i]-1]/4) ~= _G.MathFloor(zcards[i][#zcards[i]]/4) then
						_G.table.remove(zcards[i],#zcards[i])
						a =  a - 1
						for k=1,#acards[j],1 do
							_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
							a = a + 1
						end
					elseif a == 3 and #acards == 2
						and _G.MathFloor(zcards[i][#zcards[i]-1]/4) == _G.MathFloor(zcards[i][#zcards[i]]/4) then
						_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
						a = a + 1
					end
				end
				j = j + 1
			until j >= #acards+1 or a == 4
		end
	end

	if #zcards[1] == 12 then
		zcards = {hands}
		return zcards
	end

	--返回zcards
	if _G.MathFloor(zcards[1][1]/4) ~= _G.MathFloor(zcards[1][10]/4) then
		return zcards
	else
		return zcards
	end
end

--智-能-提-示-9-带-3
local function AINineplusthreeAIFunc(cards,hands)
	local zcards = {}
	cards = AIinsidedoudizhulineFunc(cards)
	_G.table.sort(hands)
	--判断特殊情况 手中牌正好是两个炸弹 则直接提示炸弹。
	if #hands == 12 and _G.MathFloor(hands[1]/4) == _G.MathFloor(hands[4]/4)
		and _G.MathFloor(hands[5]/4) == _G.MathFloor(hands[8]/4)
		and _G.MathFloor(hands[9]/4) == _G.MathFloor(hands[12]/4) then
		zcards = AIInsertBombFunc(hands)
		return zcards
	end

	--找出3顺中最小的内部绝对值，让后将最小绝对值作为 入参的第一个位置 入给AIThreestraiagtAIFunc
	if _G.MathFloor(cards[1]/4) < _G.MathFloor(cards[7]/4) then
		zcards = AIThreestraiagtAIFunc({cards[1],cards[2],cards[3],cards[4],cards[5],cards[6],cards[7],cards[8],cards[9]},hands)
	else
		zcards = AIThreestraiagtAIFunc({cards[9],cards[8],cards[7],cards[6],cards[5],cards[4],cards[3],cards[2],cards[1]},hands)
	end

	--如果手牌中没有大于出牌的牌,直接返回zcards。
		if (not zcards[1]) then
			return zcards --提示“不出”（intable内没有值）
		elseif (#zcards > 0 and #zcards[1] ~= 9) then
			return zcards
		end

	--如果手牌中有大于出牌的牌
	--先找到需要插入的单牌和对牌
	local intable = {}

		local ycards = AIFindBigCardFunc({11},hands)

		--如果手牌中有大于出牌的牌
			if (ycards[1]) then

				--第一步：提取出剩余牌(ycards)中绝对值相同的牌,插入step1。再把单个的2\王插入step1_king ,多张得2插入STEP3 。
				local step1 = {}
				local step3 = {}
				local step1_king = {}
				local a=1
				repeat
					if ycards[a] < 60
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
						_G.table.insert(step1,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and (#step1 == 0 or _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif ycards[a] > 59 and ycards[a] < 64
						and #ycards > 1
						and _G.MathFloor(ycards[a]/4) ~= _G.MathFloor(ycards[a+1]/4)
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and #step1 > 0
						and _G.MathFloor(ycards[a]/4) == _G.MathFloor(step1[1]/4) then
						_G.table.insert(step3,1,ycards[a])
						_G.table.remove(ycards,a)
						a=a-1
					elseif #ycards == 1
						and ycards[1] > 59 and ycards[1] < 64
						and (#step1 == 0 or  _G.MathFloor(ycards[1]/4) ~= _G.MathFloor(step1[1]/4)) then
						_G.table.insert(step1_king,1,ycards[1])
						_G.table.remove(ycards,1)
						a=a-1
					end
					a=a+1
				until a >= #ycards
				if #ycards > 0 then
					local a = 1
					repeat
						if ycards[a] > 63 then
							_G.table.insert(step1_king,1,ycards[a])
							_G.table.remove(ycards,a)
							a = a - 1
						end
						a = a + 1
					until a >= #ycards+1
				end

				--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2。
				local step2 = {}
				if #ycards > 4 then
					_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
					repeat
						local start = 0
						local j = 1
						repeat
							for k=#ycards,j+4,-1 do
								if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
									and k-j > 3 then
									start = 1
									for l=k,j,-1 do
										_G.table.insert(step2,1,ycards[l])
										_G.table.remove(ycards,l)
									end
									j = j - 1
									break
								end
							end
							j = j + 1
						until j >= #ycards-3
					until #ycards < 5 or start == 0
				end

				--第三步：将剩余牌与step1比对，提取相同的牌到step3。
				local step3 = {}
				if (step1[1] and ycards[1]) then
					local i=1
					repeat
						for j=1,#step1,1 do
							if _G.MathFloor(ycards[i]/4) == _G.MathFloor(step1[j]/4) then
								_G.table.insert(step3,1,ycards[i])
								_G.table.remove(ycards,i)
								i=i-1
								break
							end
						end
						i = i + 1
					until i >= #ycards+1
				end

				--第四步：将step1中的单牌提取出来，与step2中的牌比对，如果相同即插入ycards。
				if (step2[1] and #step1 > 1) then
					for i=1,#step1,1 do
						local j = 1
						repeat
							if i ~= 1
								and i ~= #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif  i == 1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i+1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							elseif i == #step1
								and _G.MathFloor(step1[i]/4) == _G.MathFloor(step2[j]/4)
								and _G.MathFloor(step1[i]/4) ~= _G.MathFloor(step1[i-1]/4) then
								_G.table.insert(ycards,1,step2[j])
								_G.table.remove(step2,j)
								j = j - 1
							end
							j = j + 1
						until j >= #step2+1
					end
				elseif (step2[1] and #step1 == 1) then
					for i=1,#step2,1 do
						if _G.MathFloor(step2[i]/4) == _G.MathFloor(step1[1]/4) then
							_G.table.insert(ycards,1,step2[i])
							_G.table.remove(step2,i)
							break
						end
					end
				end

				--第五步：将 ycards step1_king step3 step2 插入intable并返回。
				--先提示去顺后的单张+顺中对子的单张，
				--再提示单个的王和2，
				--再提示顺中的单张,
				--再提示对子
				--最后提示单对、3条、炸中的单张。
				if (step3[1]) then
					_G.table.sort(step3)
					for i=#step3,1,-1 do
						_G.table.insert(intable,1,{step3[i]})
					end
				end

				local xcards = AIPairAICardFunc({11,10},hands)
				for i =#xcards,1,-1 do
					if #xcards[i] == 2 and xcards[i][1] < 64 then
						_G.table.insert(intable,1,xcards[i])
					end
				end

				if (step1_king[1]) then
					for i=#step1_king,1,-1 do
						_G.table.insert(intable,1,{step1_king[i]})
					end
				end

				if (step2[1]) then
					for i=1,#step2,1 do
						_G.table.insert(intable,1,{step2[i]})
					end
				end

				if (ycards[1]) then
					_G.table.sort(ycards)
					for i=#ycards,1,-1 do
						_G.table.insert(intable,1,{ycards[i]})
					end
				end

			end
	local acards = intable

	--判断单牌是否与3条相同，不相同则将单牌插入zcards
	for i=1,#zcards,1 do
		if #zcards[i] == 9 then
			local a = 0
			local j = 1
			repeat
				if _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][4]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][7]/4) then
					if (a ~= 2 or #acards ~= 2) and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][#zcards[i]]/4) then
						for k=1,#acards[j],1 do
							_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
							a = a + 1
						end
					elseif a == 2 and #acards == 2
						and _G.MathFloor(zcards[i][#zcards[i]-1]/4) ~= _G.MathFloor(zcards[i][#zcards[i]]/4) then
						_G.table.remove(zcards[i],#zcards[i])
						a =  a - 1
						for k=1,#acards[j],1 do
							_G.table.insert(zcards[i],#zcards[i]+1,acards[j][k])
							a = a + 1
						end
					elseif a == 2 and #acards == 2
						and _G.MathFloor(zcards[i][#zcards[i]-1]/4) == _G.MathFloor(zcards[i][#zcards[i]]/4) then
						_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
						a = a + 1
					end
				end
				j = j + 1
			until j >= #acards+1 or a == 3
		end
	end

	if #zcards[1] == 9 then
		zcards = {hands}
		return zcards
	end

	--返回zcards
	if _G.MathFloor(zcards[1][1]/4) ~= _G.MathFloor(zcards[1][10]/4) then
		return zcards
	else
		return zcards
	end

end

--普-通-提-示-单-张
local function single(cards,hands)
	local intable = AIInsertBombFunc(hands)
	local ycards = AIFindBigCardFunc(cards,hands)
	--如果手牌中没有大于出牌的牌,直接返回intable。
		if (not ycards[1]) and (intable[1]) then
			return intable --提示“炸弹”
		elseif ((not ycards[1]) and (not intable[1])) then
			return intable --提示“不出”（intable内没有值）
		end

	--如果手牌中有大于出牌的牌
		--第一步：删除剩余牌(ycards)中绝对值相同的牌
			local a=1
			repeat
				if _G.MathFloor(ycards[a]/4) ==  _G.MathFloor(ycards[a+1]/4) then
					_G.table.remove(ycards,a)
					a=a-1
				end
				a=a+1
			until a >= #ycards
			_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
		--第二步：将剩余牌 ycards 插入intable
			if (ycards[1]) then
				for i=1,#ycards,1 do
					_G.table.insert(intable,1,{ycards[i]})
				end
			end
	return intable
end

--智-能-提-示-9-带-6
local function AINineplusSixAIFunc(cards,hands)
	local zcards = {}
	cards = AIinsidedoudizhulineFunc(cards)
	--找出3顺中最小的内部绝对值，让后将最小绝对值作为 入参的第一个位置 入给AIThreestraiagtAIFunc
	if _G.MathFloor(cards[1]/4) < _G.MathFloor(cards[7]/4) then
		zcards = AIThreestraiagtAIFunc({cards[1],cards[2],cards[3],cards[4],cards[5],cards[6],cards[7],cards[8],cards[9]},hands)
	else
		zcards = AIThreestraiagtAIFunc({cards[9],cards[8],cards[7],cards[6],cards[5],cards[4],cards[3],cards[2],cards[1]},hands)
	end

	--如果手牌中没有大于出牌的牌,直接返回zcards。
		if (not zcards[1]) then
			return zcards --提示“不出”（intable内没有值）
		elseif (#zcards > 0 and #zcards[1] ~= 9) then
			return zcards
		end
	--如果手牌中有大于出牌的牌
	--先找到所有的单牌
	local acards ={}
	acards = AIPairAICardFunc({11,10},hands)


	--判断单牌是否与3条相同，不相同则将对牌插入zcards
	for i=#zcards,1,-1 do
		if #zcards[i] == 9 then
			local a = 0
			local j = 1
			repeat
				if #acards[j] == 2 and acards[j][1] < 64
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][1]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][4]/4)
					and _G.MathFloor(acards[j][1]/4) ~= _G.MathFloor(zcards[i][7]/4) then
						_G.table.insert(zcards[i],#zcards[i]+1,acards[j][1])
						_G.table.insert(zcards[i],#zcards[i]+1,acards[j][2])
						a = a + 1
				end
				j = j + 1
			until j >= #acards+1 or a == 3
		end
	end

	--判断是否成功插入对子
	if #zcards[1] ~= 15 then --没成功插入对子

		local intable = AIInsertBombFunc(hands)
		return intable
	else
		return zcards
	end
end

--最小到最大智能提示
local function AISelectCardFunc(cards,hands)--入参，出牌和手牌，外部数值，出参内部数值。
	if doudizhuGL.DDZIsKingBombFunc( cards ) then return {} end
	local intable = {}
	local tablecards = {}
	if (cards[1]) then
		tablecards = _G.doudizhuGL.DDZAbsoluteAllFunc(cards)
	end
	local xcards = _G.doudizhuGL.DDZAbsoluteAllFunc(_G.doudizhuGL.DDZHumanSortCardFunc(hands))

	--判断手牌张数是否大于等于出牌张数。
	if(#cards==1) then --单张
		if  _G.doudizhuGL.DDZIsKingBombFunc(hands) == true or _G.doudizhuGL.DDZIsBombFunc(hands) == true then
			intable = {xcards}
			return intable
		end
		intable = AIsingleAIFunc(tablecards,xcards)
		return intable

	elseif (cards[1]==nil or #cards==0) then --没有出牌，判断是否有多顺或单顺。
		
        if #xcards== 1 then
	        intable = {xcards}
		    return intable
		elseif(#hands>5 and  _G.doudizhuGL.DDZIsThreeFloorFunc(hands) ~= 0) then --顺子
			return {xcards}
		elseif(#hands>5 and  _G.doudizhuGL.DDZIsTwoFloorFunc(hands) ~= 0) then --顺子
			return {xcards}
		end

        local ycards = AIFindBigCardFunc({10},xcards)
		--第一步：删除剩余牌(ycards)中绝对值相同的牌。
			local a=1
			repeat
				if ycards[a] < 60
				and _G.MathFloor(ycards[a]/4) == _G.MathFloor(ycards[a+1]/4) then
					_G.table.remove(ycards,a)
					a=a-1
				elseif ycards[a] > 59 then
					_G.table.remove(ycards,a)
					a=a-1
				end
				a=a+1
			until a >= #ycards

			--第二步：如果剩余牌大于4张，则判断其中有没有顺，并将顺子牌插入step2。
			local step2 = {}
			if #ycards > 4 then
				_G.table.sort(ycards,_G.doudizhuGL.DDCompareBSFunc)
				repeat
					local start = 0
					local j = 1
					repeat
						for k=#ycards,j+4,-1 do
							if  _G.MathFloor(ycards[j]/4) - _G.MathFloor(ycards[k]/4) == k-j
								and k-j > 3 then
								start = 1
								for l=k,j,-1 do
									_G.table.insert(step2,1,ycards[l])
									_G.table.remove(ycards,l)
								end
								j = j - 1
								break
							end
						end
						j = j + 1
					until j >= #ycards-3
				until #ycards < 5 or start == 0
			end

		if (step2[1])
			and (_G.MathFloor(step2[1]/4) - _G.MathFloor(step2[#step2]/4) == #step2-1) then
				intable = {step2}
				return intable
		elseif  (step2[1]) and (_G.MathFloor(step2[1]/4) - _G.MathFloor(step2[#step2]/4) ~= #step2-1) then
			for i=#step2,2,-1 do
				if _G.MathFloor(step2[i-1]/4) - _G.MathFloor(step2[i]/4) ~= 1 then
					_G.table.insert(intable,{})
					for k=i-1,1,-1 do
						_G.table.insert(intable[1],1,step2[k])
					end
					_G.table.insert(intable,{})
					for j=#step2,i,-1 do
						_G.table.insert(intable[2],1,step2[j])
					end
					return intable
				end
			end
		end
		return intable

	elseif(#hands>1 and _G.doudizhuGL.DDZIsTwoCardFunc(cards))then --两张

		if  _G.doudizhuGL.DDZIsKingBombFunc(hands) == true or _G.doudizhuGL.DDZIsBombFunc(hands) == true then
			intable = {xcards}
			return intable
		end

		intable = AIPairAICardFunc(tablecards,xcards)
		return intable

	elseif(#hands>2 and (_G.doudizhuGL.DDZIsThreeFunc(cards))) then --三张
		if  _G.doudizhuGL.DDZIsBombFunc(hands) == true then
			return {xcards}
		end

		intable = AIThreeAICardFunc(tablecards,xcards)
		return intable

	elseif(#hands>3 and _G.doudizhuGL.DDZIsFourBombFunc(cards)) then --普通炸弹

		--找出手牌所有大于出牌的牌
		local ycards = AIFindBigCardFunc(tablecards,xcards)

		--找出大牌中的炸弹
		local intable = AIInsertBombFunc(ycards)

		--判断并返回intable
		if (intable[1]) then
			return intable
		else
			return intable --提示“不出”（intable内没有值）
		end

	elseif(#hands>3 and _G.doudizhuGL.DDZIsThreePlusOneFunc(cards)~=0) then --三带一

		intable = AIThreePlusoneFunc(tablecards,xcards)
		return intable

	elseif(#hands>4 and _G.doudizhuGL.DDZIsThreePlusTwoFunc(cards)~=0) then	--三带二

		intable = AIThreePlusTwoFunc(tablecards,xcards)
		return intable

	elseif(#hands>5 and _G.doudizhuGL.DDZIsFourPlusTwoFunc(cards)~=0) then  --四带二

		intable = AIFourPlusTwoFunc(tablecards,xcards)
		return intable

	elseif(#hands>7 and  _G.doudizhuGL.DDZIsFourFloorFunc(cards)~=0) then --顺子

		intable = AIInsertBombFunc(xcards)
		return intable

	elseif(#hands>7 and _G.doudizhuGL.DDZIsFourPlusFourFunc(cards)~=0) then --四带四

		intable = AIFourPlusFourFunc(tablecards,xcards)
		return intable

	elseif(#hands>7 and _G.doudizhuGL.DDZIsSixPlusTwoFunc(cards)~=0) then --六带二

		intable = AISixPlusTwoFunc(tablecards,xcards)
		return intable

	elseif(#hands>9 and _G.doudizhuGL.DDZIsSixPlusFourFunc(cards)~=0) then --六带四

		intable = AISixPlusFourFunc(tablecards,xcards)
		return intable

	--检查是不是顺子,包括单顺,双顺,三顺
	elseif(#hands>5 and  _G.doudizhuGL.DDZIsThreeFloorFunc(cards)~=0) then --顺子

		intable = AIThreestraiagtAIFunc(tablecards,xcards)
		return intable

	elseif(#hands>5 and  _G.doudizhuGL.DDZIsTwoFloorFunc(cards)~=0) then --顺子

		intable = AIDoublestraiagtAIFunc(tablecards,xcards)
		return intable

	elseif(#hands>4 and _G.doudizhuGL.DDZIsFloorFunc(cards)~=0 ) then --顺子

		intable = AIStraiagtAIAIFunc(tablecards,xcards)
		return intable

	elseif(#hands>11 and _G.doudizhuGL.DDZIsNinePlusThreeFunc(cards)~=0) then --九带三

		intable = AINineplusthreeAIFunc(tablecards,xcards)
		return intable

	elseif(#hands>=12 and _G.doudizhuGL.DDZIsEightPlusFourFunc(cards)~=0) then --8带4

		intable = AIInsertBombFunc(xcards)
		return intable

	elseif(#hands>=15 and _G.doudizhuGL.DDZIsNinePlusSixFunc(cards)~=0) then --九带六

		intable = AINineplusSixAIFunc(tablecards,xcards)
		return intable

	elseif(#hands>=16 and _G.doudizhuGL.DDZisTwelvePlusFourFunc(cards)~=0) then --12带4

		intable = AITwelveplusfourAIFunc(tablecards,xcards)
		return intable

	elseif(#hands>=16 and _G.doudizhuGL.DDZIsEightPlusEightFunc(cards)~=0) then --8带8

		intable = AIInsertBombFunc(xcards)
		return intable

	elseif(#hands>=18 and _G.doudizhuGL.DDZIsTwelvePlusSixFunc(cards)~=0) then --12带6

		intable = AIInsertBombFunc(xcards)
		return intable

	end

	intable = AIInsertBombFunc(xcards)
	if (intable[1]) then
		return intable
	else
		return intable
	end
end

local function AIAllChangeAbsoluteaFunc(cards)--入参{{54,54,65},...}
	local intable = {}
	local outtable = cards
	for i=1,#outtable,1 do
		intable[i] = {}
		intable[i] = _G.doudizhuGL.DDZunAbsoluteAllFunc(outtable[i])
	end
	return intable
end

local function intelletChupaiAssist(tablecards,hands)
	return AIAllChangeAbsoluteaFunc(AISelectCardFunc(tablecards,hands))
end

if (not _G.doudizhuGL) then
	_G.doudizhuGL = {}
end

_G.doudizhuGL.intelletChupaiAssist=intelletChupaiAssist



