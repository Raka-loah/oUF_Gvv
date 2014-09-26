local _, ns = ...
ns.C = {}

--Frames enabled 是否使用本插件提供的框体 true/false
ns.C.showTarget = true -- Target and Target of Target 目标与目标的目标框体
ns.C.showParty	= true -- Party frames 小队框体
ns.C.showFocus	= true -- Focus and Target of Focus 焦点与焦点的目标框体
ns.C.showExperience = true -- Experience and reputation bar 经验与声望条
ns.C.drawBorders = true -- Draw background borders 显示屏幕背景边框
ns.C.screenEffect = true -- Low health screen glow effect 低血量屏幕特效

ns.C.normalFont = 'Fonts\\ARHei.ttf' -- Default font(e.g. 'Fonts\\ARAILN.ttf') 默认字体文件路径

--Class power frame position 职业能力框位置
ns.C.cpXoffset = -310 --X offset(default:-310) 横向偏移（默认值-310）
ns.C.cpYoffset = 19  --Y offset(defalut:19) 纵向偏移(默认值19)

--Buff size 增益图标尺寸
ns.C.buffIconSize = 20