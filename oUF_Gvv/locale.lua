local _, ns = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

ns.L = L

local LOCALE = GetLocale()

if LOCALE:match('^en') then
	return 
end

if LOCALE == 'zhCN' then
	--Don't forget the extra space
	L['Rare '] = '稀有 '
	L['RareElite '] = '稀有精英 '
	L['Elite '] = '精英 '
	L['Boss '] = '头目 '
	L['Minus '] = '杂兵 '
	
	L[' MT'] = '·主坦克'
	L[' MA'] = '·MA'
	
	L[' A'] = '·A' -- Assistant，“团长给个A”那个A
	
	L[' Tank'] = '·坦克'
	L[' Healer'] = '·治疗' --奶妈！
	L[' Damager'] = '·输出'

	L[' Looter'] = '·拾取'
	
	L['Class Power position saved.'] = '职业资源条位置已保存。'
	L['Class Power position reset.'] = '职业资源条位置已重置。'
	L['|cFFFF0000[oUF_Gvv]|r This version of oUF_Gvv has only been tested with oUF 7.0.x, if it breaks, check your oUF core version first.'] = '|cFFFF0000[oUF_Gvv]|r 此版本的oUF_Gvv仅在oUF 7.0.x版本测试通过，如果它挂掉了，先检查一下你的oUF核心版本。'
	return 
end

--Add your own below