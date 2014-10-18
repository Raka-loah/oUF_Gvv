local _, ns = ...

ns.C = {}

--Frames enabled(true/false) 是否使用本插件提供的框体，开启为true，关闭为false
ns.C.showTarget		= true	-- Target and Target of Target 目标与目标的目标框体
ns.C.showParty		= true	-- Party frames 小队框体
ns.C.showFocus		= true	-- Focus and Target of Focus 焦点与焦点的目标框体
ns.C.showExperience	= true	-- Experience and reputation bar 经验与声望条
ns.C.drawBorders	= true	-- Draw background borders 显示屏幕背景边框
ns.C.screenEffect	= true	-- Low health screen glow effect 低血量屏幕特效
ns.C.showPlayer		= true	-- Player and Pet frame 玩家血球与宠物框体
ns.C.showCastbar	= true	-- Castbar 施法条

--Default font(e.g. 'Fonts\\ARAILN.ttf') 默认字体文件路径
ns.C.normalFont		= 'Fonts\\ARHei.ttf' 

--Class power frame position 职业能力框位置
ns.C.cpXoffset		= -310	-- X offset(default:-310) 横向偏移（默认值-310）
ns.C.cpYoffset		= 19	-- Y offset(defalut:19) 纵向偏移(默认值19)

--Buff frame 增益图标框体
ns.C.useBuffframe	= true	-- Enable addon buff frame for player 插件接管玩家buff框体
ns.C.buffIconSize	= 25	-- Buff icon size(default:20px) 增益图标尺寸（默认20px）
ns.C.bframeX		= 95	-- Buff frame X offset(default:95) 横向偏移（默认值95）
ns.C.bframeY		= 125	-- Y offset(defalut:125) 纵向偏移(默认值125)

--Auto hide full HP/MP text on target frames 当目标血量蓝量满时自动隐藏文字
ns.C.ahfHPtext		= true	-- HP text
ns.C.ahfMPtext		= true	-- MP text

--Power bar colored by type 蓝条按类型着色
--Default is false and will use yellow color for all type just like GW2
--默认不启用，即所有职业都使用GW2翻滚条的黄颜色
ns.C.colorPower		= false