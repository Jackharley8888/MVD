--377
script_name("MVD Helper Silver | LUA")
script_authors('Harley AHK')
script_description('MVD Helper LUA by Harley AHK')
script_moonloader('26')
script_version('1.2')

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/Jackharley8888/MVD/main/version.json" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://raw.githubusercontent.com/Jackharley8888/MVD/main/mvd_helper_silver.lua"
        end
    end
end

require("lib.moonloader") 
local script_version = 1.1
local imgui = require 'imgui'
local encoding = require 'encoding'
local rkeys = require 'rkeys'
local tLastKeys = {}
imgui.HotKey = require('imgui_addons').HotKey
local fa = require 'fAwesome5'
local vkeys = require 'vkeys'
local imadd = require 'imgui_addons'
sampev = require 'lib.samp.events'
local requests = require 'requests'
local openKey = nil
encoding.default = 'CP1251'
u8 = encoding.UTF8
_, idPed = sampGetPlayerIdByCharHandle(PLAYER_PED)
nick = sampGetPlayerNickname(idPed)

local path = getGameDirectory()..'\\moonloader\\config\\mvd_config.json' -- Путь к JSON файлу с настройками

local config = {
    settings = {
        testHotKey = {v = {nil}}, -- Кнопка изначально none
    },
	toggles = {
		hidesms = "false",
		autoreject = "false",
		arrest = "false",
		su = "false", 
		clear = "false", 
		wanted = "false", 
		cuff = "false",
		uncuff = "false",
		search = "false",
		remove = "false",
		pg = "false",
		takelic = "false",
		putpl = "false",
		ticket = "false",
		escort = "false",
		skip = "false",
		skip_key = "false",
		breakr = "false",
		dbreak = "false",
		break_door = "false",
		police_tablet = "false",
		ejectout = "false"
	},
}

-- Это под конфигом, который выше. Как есть короче оставь. Это создает тебе сразу JSON файл с настройками.
if not doesFileExist(path) then
    local f = io.open(path, 'w+')
    f:write(encodeJson(config)):close()
else
    local f = io.open(path, "r")
    a = f:read("*a")
    config = decodeJson(a)
    f:close()
end

local file = io.open(path, "r") -- Выполняем те же действия
a = file:read("*a")	
file:close()

table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу

-- local file = io.open(path, "w") -- Выполняем те же действия
-- local table1 = decodeJson(a)
-- table1["toggles"]["hidesms"] = "true"
-- table1["toggles"]["autoreject"] = "false"
-- encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
-- file:write(encodedTable) -- Записываем нашу таблицу
-- file:flush() -- Сохраняем
-- file:close() -- Закрываем

local inicfg = require('inicfg')
local directIni = 'settings_mvd_helper_harley.ini'
local ini = inicfg.load(inicfg.load({
    config = {
        frak = '',
        rank = '',
        tag = '',
        hot = '',
        gov1 = '',
        gov2 = '',
        gov3 = '',
        gov4 = '',
        gov5 = '',
    },
}, directIni))
inicfg.save(ini, directIni)


----------------------------------------------<locales>------------------------------------------------
local arrestrp = nil
local surp = nil
local clearrp = nil 
local wantedrp = nil 
local cuffrp = nil 
local uncuffrp = nil 
local searchrp = nil 
local removerp = nil 
local pgrp = nil
local takelicrp = nil 
local putplrp = nil 
local ticketrp = nil 
local escortrp = nil 
local skiprp = nil
local skip_keyrp = nil 
local breakrp = nil 
local dbreakrp = nil
local break_doorrp = nil 
local police_tabletrp = nil 
local ejectoutrp = nil
----------------------------------------------</locales>------------------------------------------------ 

local frak = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.frak)), 130222)
local rank = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.rank)), 130333)
local tag = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.tag)), 130444)
local gov1 = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.gov1)), 130555)
local gov2 = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.gov2)), 13066)
local gov3 = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.gov3)), 130777)
local gov4 = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.gov4)), 130888)
local gov5 = imgui.ImBuffer(string.format(u8:decode('' ..ini.config.gov5)), 130999)

local menu = 1
local sw, sh = getScreenResolution()

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
end

local main_window_state = imgui.ImBool(false)
local secondary_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)

local mvd = "{1E90FF}[МВД]{FFFFFF}" 

local img2 = imgui.CreateTextureFromFile('moonloader/lib/dh.png')
local img3 = imgui.CreateTextureFromFile('moonloader/lib/mvd_close.png')
local img4 = imgui.CreateTextureFromFile('moonloader/lib/mvd_ava.png')
local img5 = imgui.CreateTextureFromFile('moonloader/lib/main_ad_1.png')
local img6 = imgui.CreateTextureFromFile('moonloader/lib/main_ad_2.png')

local tbutton1 = nil
if table1["toggles"]["hidesms"]=="false" then 
    tbutton1 = imgui.ImBool(false) 
else 
    tbutton1 = imgui.ImBool(true) 
end
if table1["toggles"]["autoreject"] == "false" then 
	tbutton2 = imgui.ImBool(false)
else
	tbutton2 = imgui.ImBool(true)
end
if table1["toggles"]["arrest"] == "false" then 
	arrestrp = imgui.ImBool(false)
else
	arrestrp = imgui.ImBool(true)
end
if table1["toggles"]["su"] == "false" then 
	surp = imgui.ImBool(false)
else
	surp = imgui.ImBool(true)
end
if table1["toggles"]["clear"] == "false" then 
	clearrp = imgui.ImBool(false)
else
	clearrp = imgui.ImBool(true)
end
if table1["toggles"]["wanted"] == "false" then 
	wantedrp = imgui.ImBool(false)
else
	wantedrp = imgui.ImBool(true)
end
if table1["toggles"]["cuff"] == "false" then 
	cuffrp = imgui.ImBool(false)
else
	cuffrp = imgui.ImBool(true)
end
if table1["toggles"]["uncuff"] == "false" then 
	uncuffrp = imgui.ImBool(false)
else
	uncuffrp = imgui.ImBool(true)
end
if table1["toggles"]["search"] == "false" then 
	searchrp = imgui.ImBool(false)
else
	searchrp = imgui.ImBool(true)
end
if table1["toggles"]["remove"] == "false" then 
	removerp = imgui.ImBool(false)
else
	removerp = imgui.ImBool(true)
end
if table1["toggles"]["pg"] == "false" then 
	pgrp = imgui.ImBool(false)
else
	pgrp = imgui.ImBool(true)
end
if table1["toggles"]["takelic"] == "false" then 
	takelicrp = imgui.ImBool(false)
else
	takelicrp = imgui.ImBool(true)
end
if table1["toggles"]["putpl"] == "false" then 
	putplrp = imgui.ImBool(false)
else
	putplrp = imgui.ImBool(true)
end
if table1["toggles"]["ticket"] == "false" then 
	ticketrp = imgui.ImBool(false)
else
	ticketrp = imgui.ImBool(true)
end
if table1["toggles"]["escort"] == "false" then 
	escortrp = imgui.ImBool(false)
else
	escortrp = imgui.ImBool(true)
end
if table1["toggles"]["skip"] == "false" then 
	skiprp = imgui.ImBool(false)
else
	skiprp = imgui.ImBool(true)
end
if table1["toggles"]["skip_key"] == "false" then 
	skip_keyrp = imgui.ImBool(false)
else
	skip_keyrp = imgui.ImBool(true)
end
if table1["toggles"]["breakr"] == "false" then 
	breakrp = imgui.ImBool(false)
else
	breakrp = imgui.ImBool(true)
end
if table1["toggles"]["dbreak"] == "false" then 
	dbreakrp = imgui.ImBool(false)
else
	dbreakrp = imgui.ImBool(true)
end
if table1["toggles"]["break_door"] == "false" then 
	break_doorrp = imgui.ImBool(false)
else
	break_doorrp = imgui.ImBool(true)
end
if table1["toggles"]["police_tablet"] == "false" then 
	police_tabletrp = imgui.ImBool(false)
else
	police_tabletrp = imgui.ImBool(true)
end
if table1["toggles"]["ejectout"] == "false" then 
	ejectoutrp = imgui.ImBool(false)
else
	ejectoutrp = imgui.ImBool(true)
end
local active1 = false
local active2 = false
local ToggleTest1 = false

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(50) end
	gov1.v = string.format(ini.config.gov1)
	gov2.v = string.format(ini.config.gov2)
	gov3.v = string.format(ini.config.gov3)
	gov4.v = string.format(ini.config.gov4)
	gov5.v = string.format(ini.config.gov5)	
	if not doesFileExist("moonloader/lib/main_ad_1.png") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/main_ad_1.png', 'moonloader/lib/main_ad_1.png', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/main_ad_2.png") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/main_ad_2.png', 'moonloader/lib/main_ad_2.png', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/fAwesome5.lua") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/fAwesome5.lua', 'moonloader/lib/fAwesome5.lua', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/fa-solid-900.ttf") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/fa-solid-900.ttf', 'moonloader/lib/fa-solid-900.ttf', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/dh.png") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/dh.png', 'moonloader/lib/dh.png', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/mvd_ava.png") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/mvd_ava.png', 'moonloader/lib/mvd_ava.png', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/mvd_close.png") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/mvd_close.png', 'moonloader/lib/mvd_close.png', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/rkeys.lua") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/rkeys.lua', 'moonloader/lib/rkeys.lua', function(id, status, p1, p2)
		end)
	end
	if not doesFileExist("moonloader/lib/imgui_addons.lua") then
	download_id = downloadUrlToFile('https://ahkharley.online/download-for-players/imgui_addons.lua', 'moonloader/lib/imgui_addons.lua', function(id, status, p1, p2)
		end)
	end
    local memory = require "memory"
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
	bind = rkeys.registerHotKey(config.settings.testHotKey.v, true, function()
		-- Тут действие на кнопку.
		sampAddChatMessage("Привет", -1)
	end)

    imgui.Process = false
    
     if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    
	sampAddChatMessage(mvd.. " {FFFFFF}Здравствуйте. Вы запустили Silver MVD Helper [by Harley].")
	sampAddChatMessage(mvd.. " {FFFFFF}Активация: Alt + G.")
	sampAddChatMessage(mvd.. " {FFFFFF}Группа ВК: AHK Harley | Radmir RP (@ahkradmirharley)")
	sampAddChatMessage(mvd.. " {FFFFFF}Discord: https://discord.gg/24V57kvsZr")
	
	sampRegisterChatCommand("mpg",cmd_mpg)
	sampRegisterChatCommand("mhealme",cmd_mhealme)
	sampRegisterChatCommand("vzlom",cmd_vzlom)
	sampRegisterChatCommand("alko",cmd_alko)
	sampRegisterChatCommand("rob1",cmd_rob1)
	sampRegisterChatCommand("rob2",cmd_rob2)
	sampRegisterChatCommand("msu",cmd_msu)
	sampRegisterChatCommand("mclear",cmd_mclear)
	sampRegisterChatCommand("msearch",cmd_msearch)
	sampRegisterChatCommand("mremove",cmd_mremove)
	sampRegisterChatCommand("mcuff",cmd_mcuff)
	sampRegisterChatCommand("muncuff",cmd_muncuff)
	sampRegisterChatCommand("mescort",cmd_mescort)
	sampRegisterChatCommand("muescort",cmd_muescort)
	sampRegisterChatCommand("mputpl",cmd_mputpl)
	sampRegisterChatCommand("muputpl",cmd_muputpl)
	sampRegisterChatCommand("mejectout",cmd_mejectout)
	sampRegisterChatCommand("marrest",cmd_marrest)
	sampRegisterChatCommand("mdoc1",cmd_mdoc1)
	sampRegisterChatCommand("mdoc2",cmd_mdoc2)
	sampRegisterChatCommand("mdoc3",cmd_mdoc3)
	sampRegisterChatCommand("mdoc4",cmd_mdoc4)
	sampRegisterChatCommand("mat1",cmd_mat1)
	sampRegisterChatCommand("mat2",cmd_mat2)
	sampRegisterChatCommand("mat3",cmd_mat3)
	sampRegisterChatCommand("mwanted",cmd_mwanted)
	sampRegisterChatCommand("mbreak",cmd_mbreak)
	sampRegisterChatCommand("mdbreak",cmd_mdbreak)
	sampRegisterChatCommand("cc",cmd_cc)
	sampRegisterChatCommand("msm",cmd_msm)
	sampRegisterChatCommand("mvd",cmd_mvd)
	sampRegisterChatCommand("mrec",cmd_mrec)

	-- MVD ------------------------------------
	sampRegisterChatCommand("arrest", cmd_arrest)
	sampRegisterChatCommand("su", cmd_su)
	sampRegisterChatCommand("clear", cmd_clear)
	sampRegisterChatCommand("wanted", cmd_wanted)
	sampRegisterChatCommand("cuff", cmd_cuff)
	sampRegisterChatCommand("uncuff", cmd_uncuff)
	sampRegisterChatCommand("search", cmd_search)
	sampRegisterChatCommand("remove", cmd_remove)
	sampRegisterChatCommand("pg", cmd_pg)
	sampRegisterChatCommand("talelic", cmd_takelic)
	sampRegisterChatCommand("putpl", cmd_putpl)
	sampRegisterChatCommand("ticket", cmd_ticket)
	sampRegisterChatCommand("escort", cmd_escort)
	sampRegisterChatCommand("skip", cmd_skip)
	sampRegisterChatCommand("skip_key", cmd_skip_key)
	sampRegisterChatCommand("break", cmd_break)
	sampRegisterChatCommand("dbreak", cmd_dbreak)
	sampRegisterChatCommand("break_door", cmd_break_door)
	sampRegisterChatCommand("police_tablet", cmd_police_tablet)
	sampRegisterChatCommand("ejectout", cmd_ejectout)	
	--------------------------------------------
	setCharProofs(PLAYER_PED, true, true, true, true, true)
	sampRegisterChatCommand('dc', function()
		sampDisconnectWithReason("Пидорас.")
	end)
	sampRegisterChatCommand("hi", cmd_hi)
	sampRegisterChatCommand('hp', function() 
		setCharHealth(PLAYER_PED, 10)
	end)
	sampRegisterChatCommand("imgui",cmd_imgui)
	local hp = false
	while true do
		wait(0)
		if isKeyJustPressed(VK_F2) then
			cmd_imgui()
		end
		if isKeyDown(VK_MENU) and isKeyJustPressed(VK_G) then 
			cmd_mvd()
		end
		if isCharInAnyCar(PLAYER_PED) then
			if getCarHealth(storeCarCharIsInNoSave(PLAYER_PED), -1) <= 997 then 
				sampSendChat('/fixcar')
			end
		elseif not isCharInAnyCar(PLAYER_PED) then
			-- Если стример не в тачке
		end
		if res and time ~= nil then
			sampDisconnectWithReason(quit)
			wait(time*1000)
			sampSetGamestate(1)
			res= false
			else if res and time == nil then
				sampDisconnectWithReason(quit)
				wait(15500)
				sampSetGamestate(1)
				res= false
			end
		end
		
		local hp = sampGetPlayerHealth(idPed)
	end

	wait(-1)
end

function hp()
	sampSendChat('/hp')	
end

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
	style.WindowPadding = ImVec2(15, 15)
	style.WindowRounding = 15.0
	style.FramePadding = ImVec2(5, 5)
	style.ItemSpacing = ImVec2(12, 8)
	style.ItemInnerSpacing = ImVec2(8, 6)
	style.IndentSpacing = 25.0
	style.ScrollbarSize = 15.0
	style.ScrollbarRounding = 15.0
	style.GrabMinSize = 15.0
	style.GrabRounding = 7.0
	style.ChildWindowRounding = 8.0
	style.FrameRounding = 6.0
	colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
	colors[clr.Button] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.30, 0.40, 1.00, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.25, 0.35, 1.00, 1.00)
	colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function sampev.onServerMessage(color, text)
	local textf = "SMS"
	if text:find(textf) and table1["toggles"]["hidesms"] == true then
		return false
	end
end

function sampev.onServerMessage(color, text)
    local textf = "входящий"
	if table1["toggles"]["autoreject"] == true and text:find(textf) then
		sampSendChat('/h')
		return false
	end
end

function sampev.onServerMessage(color, text)
    local textf = "СМИ"
	if table1["toggles"]["hidetrk"] == true and text:find(textf) then
		return false
	end
end


function imgui.VerticalSeparator()
    local p = imgui.GetCursorScreenPos()
    imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x, p.y + imgui.GetContentRegionMax().y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Separator]))
end

function cmd_imgui(arg)
	main_window_state.v = not main_window_state.v 
	imgui.Process = main_window_state.v 
end

function save_frak()
    ini.config.frak = frak.v
    inicfg.save(ini, directIni)
end

function save_rank()
    ini.config.rank = rank.v
    inicfg.save(ini, directIni)
end

function save_tag()
    ini.config.tag = tag.v
    inicfg.save(ini, directIni)
end

function save_gov1()
    ini.config.gov1 = gov1.v
    inicfg.save(ini, directIni)
end

function save_gov2()
    ini.config.gov2 = gov2.v
    inicfg.save(ini, directIni)
end

function save_gov3()
    ini.config.gov3 = gov3.v
    inicfg.save(ini, directIni)
end

function save_gov4()
    ini.config.gov4 = gov4.v
    inicfg.save(ini, directIni)
end

function save_gov5()
    ini.config.gov5 = gov5.v
    inicfg.save(ini, directIni)
end

function imgui.OnDrawFrame()
	apply_custom_style()
	imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1000, 570), imgui.Cond.FirstUseEver)                          
	imgui.Begin(u8"Главное Окно", imgui.WindowFlags.NoMove, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
	imgui.BeginGroup()
		imgui.SetCursorPosX(74) -- Расположение по X
        imgui.SetCursorPosY(-10) -- Расположение по Y
		size = imgui.ImVec2(70,70) 
		imgui.Image(img2, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1));
		imgui.SetCursorPosX(53) -- Расположение по X
        imgui.SetCursorPosY(42) -- Расположение по Y
        imgui.Text('MVD HELPER SILVER') -- этот текст будет на X,Y
        imgui.SetCursorPosY(70) -- Расположение по Y
    if imgui.Button(fa.ICON_FA_HOUSE_DAMAGE .. u8" Главная", imgui.ImVec2(190, 35)) then
        menu = 1
    end
    if imgui.Button(fa.ICON_FA_KEY .. u8" Бинд клавиш", imgui.ImVec2(190, 35)) then
        menu = 2
    end
    if imgui.Button(fa.ICON_FA_KEY .. u8" Настройки отыгровок", imgui.ImVec2(190, 35)) then
        menu = 3
    end
    if imgui.Button(fa.ICON_FA_INBOX .. u8" Информация", imgui.ImVec2(190, 35)) then
        menu = 4
    end
    if imgui.Button(fa.ICON_FA_SIGNAL .. u8" Стримерам/Лидерам", imgui.ImVec2(190, 35)) then
        menu = 5
    end
    if imgui.Button(fa.ICON_FA_SHOPPING_BASKET .. u8" Магазин", imgui.ImVec2(190, 35)) then
        menu = 6
    end
    if imgui.Button(fa.ICON_FA_WRENCH .. u8" Настройки", imgui.ImVec2(190, 35)) then
        menu = 7
    end
    imgui.Text("___________________________")
    imgui.SetCursorPosY(402) -- Расположение по Y
    if imgui.Button(fa.ICON_FA_HEADSET .. u8" Поддержка", imgui.ImVec2(190, 30)) then
      	os.execute("start https://discord.gg/24V57kvsZr")
    end
    if imgui.Button(fa.ICON_FA_SHARE .. u8" ВКонтакте", imgui.ImVec2(190, 30)) then
       	os.execute("start https://vk.com/ahkradmirharley")
    end
    if imgui.Button(fa.ICON_FA_SITEMAP .. u8" Сайт", imgui.ImVec2(190, 30)) then
       	os.execute("start https://ahkharley.online/")
    end
	imgui.SetCursorPosX(100) -- Расположение по X
	imgui.SetCursorPosY(540) -- Расположение по Y
	imgui.Text(script_version) -- этот текст будет на X,Y
	imgui.EndGroup()
	imgui.SameLine()
	imgui.BeginGroup()
    if menu == 1 then
    	  imgui.BeginChild("Home", imgui.ImVec2(768, 540), true, imgui.WindowFlags.NoScrollbar)
    	  imgui.SetCursorPosX(322) -- Расположение по X
		  imgui.SetCursorPosY(10) -- Расположение по Y
    	  size = imgui.ImVec2(100,100) 
    	  imgui.Image(img4, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1));
		  imgui.SameLine(273)
		  imgui.SetCursorPosY(125) -- Расположение по Y
    	  imgui.Text(u8"Ваше Имя_Фамилия: "..nick)
    	  imgui.SameLine(298)
		  imgui.SetCursorPosY(155) -- Расположение по Y
    	  imgui.Text(u8"Ваша фракция:")
    	  imgui.SameLine(392)
		  imgui.SetCursorPosY(150) -- Расположение по Y
		  imgui.PushItemWidth(60) -- ширина
		  if imgui.InputText(u8'##frak', frak) then save_frak() end
		  	imgui.SameLine(283)
		  	imgui.SetCursorPosY(180) -- Расположение по Y
    	  	imgui.Text(u8"Ваш ранг(название):")
    	    imgui.SameLine(408)
		   	imgui.SetCursorPosY(180) -- Расположение по Y
		   	imgui.PushItemWidth(60) -- ширина
    	  if imgui.InputText(u8'##rank', rank) then save_rank() end
    	  	imgui.SameLine(297)
		  	imgui.SetCursorPosY(210) -- Расположение по Y
    	 	imgui.Text(u8"Ваш позывной:")
    	   	imgui.SameLine(392)
		   	imgui.SetCursorPosY(210) -- Расположение по Y
		   	imgui.PushItemWidth(60) -- ширина
    	  if imgui.InputText(u8'##tag', tag) then save_tag() end
    	  	imgui.SameLine(30)
		  	imgui.SetCursorPosY(250) -- Расположение по Y
    	  	imgui.Text(u8"___________________________________________    НОВОСТИ    _____________________________________________")
    	  	imgui.SameLine(10)
          	imgui.SetCursorPosY(307) -- Расположение по Y
    	  	size = imgui.ImVec2(370,200) 
    	  	imgui.Image(img5, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1));
    	  	imgui.SameLine(390)
          	imgui.SetCursorPosY(307) -- Расположение по Y
    	  	size = imgui.ImVec2(370,200) 
    	  	imgui.Image(img6, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1));
    	  	imgui.SetCursorPosX(733) -- Расположение по X
          	imgui.SetCursorPosY(10) -- Расположение по Y
    	  	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.11, 0.15, 0.17, 1.00))
    	  	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
		 	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
		  	size = imgui.ImVec2(15,15) 
		  if imgui.ImageButton(img3, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1)) then
		  		main_window_state.v = not main_window_state.v 
				imgui.Process = main_window_state.v 
        end
        imgui.PopStyleColor(3)
        imgui.EndChild()
    end
     if menu == 2 then
     		imgui.BeginChild("Bind", imgui.ImVec2(379, 540), true, imgui.WindowFlags.NoScrollbar)
            imgui.InputText(u8'Введите текст', text_buffer)
			if imgui.HotKey("##1", config.settings.testHotKey, tLastKeys, 100) then
				rkeys.changeHotKey(bind, config.settings.testHotKey.v)
				JSONSave() -- Сохранение клавиши
			end
			
			if imgui.Button('Press me') then
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/msu {ff1212}ID{FFFFFF} ]')
			end
			if imgui.Button('Press me 2') then
				sampAddChatMessage(u8:decode(text_buffer.v), -1)
			end
			imgui.Text(text_buffer.v)
			size = imgui.ImVec2(100,100) 
			imgui.EndChild()
		    imgui.SameLine(389)
		    imgui.SetCursorPosY(15) -- Расположение по Y
			imgui.BeginChild("Bind2", imgui.ImVec2(379, 540), true, imgui.WindowFlags.NoScrollbar)
			imgui.SetCursorPosX(344) -- Расположение по X
            imgui.SetCursorPosY(10) -- Расположение по Y
            imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.11, 0.15, 0.17, 1.00))
    	    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
		    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
			size = imgui.ImVec2(15,15) 
		    if imgui.ImageButton(img3, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1)) then
		  		main_window_state.v = not main_window_state.v 
				imgui.Process = main_window_state.v 
            end
            imgui.PopStyleColor(3)
			imgui.EndChild()
    end
    if menu == 3 then
     		imgui.BeginChild("RP", imgui.ImVec2(250, 540), true, imgui.WindowFlags.NoScrollbar)
			size = imgui.ImVec2(100,100) 
			if imadd.ToggleButton('##arrest', arrestrp) then
			if arrestrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["arrest"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["arrest"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##su', surp) then
			if surp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["su"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["su"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##clear', clearrp) then
			if clearrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["clear"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["clear"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##wanted', wantedrp) then
			if wantedrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["wanted"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["wanted"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##cuff', cuffrp) then
			if cuffrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["cuff"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["cuff"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##uncuff', uncuffrp) then
			if uncuffrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["uncuff"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["uncuff"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##search', searchrp) then
			if searchrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["search"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["search"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##remove', removerp) then
			if removerp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["remove"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["remove"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##pg', pgrp) then
			if pgrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["pg"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["pg"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##takelic', takelicrp) then
			if takelicrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["takelic"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["takelic"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##putpl', putplrp) then
			if putplrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["putpl"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["putpl"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##ticket', ticketrp) then
			if ticketrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["ticket"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["ticket"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##escort', escortrp) then
			if escortrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["escort"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["escort"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##skip', skiprp) then
			if skiprp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["skip"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["skip"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##skip_key', skip_keyrp) then
			if skip_keyrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["skip_key"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["skip_key"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##break', breakrp) then
			if breakrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["breakr"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["breakr"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##dbreak', dbreakrp) then
			if dbreakrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["dbreak"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["dbreak"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			imgui.SameLine(110)
			imgui.SetCursorPosY(18) -- Расположение по Y
			imgui.Text(u8"/arrest")
			imgui.SameLine(110)
			imgui.SetCursorPosY(48) -- Расположение по Y
			imgui.Text(u8"/su")
			imgui.SameLine(110)
			imgui.SetCursorPosY(78) -- Расположение по Y
			imgui.Text(u8"/clear")
			imgui.SameLine(110)
			imgui.SetCursorPosY(108) -- Расположение по Y
			imgui.Text(u8"/wanted")
			imgui.SameLine(110)
			imgui.SetCursorPosY(138) -- Расположение по Y
			imgui.Text(u8"/cuff")
			imgui.SameLine(110)
			imgui.SetCursorPosY(168) -- Расположение по Y
			imgui.Text(u8"/uncuff")
			imgui.SameLine(110)
			imgui.SetCursorPosY(198) -- Расположение по Y
			imgui.Text(u8"/search")
			imgui.SameLine(110)
			imgui.SetCursorPosY(228) -- Расположение по Y
			imgui.Text(u8"/remove")
			imgui.SameLine(110)
			imgui.SetCursorPosY(258) -- Расположение по Y
			imgui.Text(u8"/pg")
			imgui.SameLine(110)
			imgui.SetCursorPosY(288) -- Расположение по Y
			imgui.Text(u8"/takelic")
			imgui.SameLine(110)
			imgui.SetCursorPosY(318) -- Расположение по Y
			imgui.Text(u8"/putpl")
			imgui.SameLine(110)
			imgui.SetCursorPosY(348) -- Расположение по Y
			imgui.Text(u8"/ticket")
			imgui.SameLine(110)
			imgui.SetCursorPosY(378) -- Расположение по Y
			imgui.Text(u8"/escort")
			imgui.SameLine(110)
			imgui.SetCursorPosY(408) -- Расположение по Y
			imgui.Text(u8"/skip")
			imgui.SameLine(110)
			imgui.SetCursorPosY(438) -- Расположение по Y
			imgui.Text(u8"/skip_key")
			imgui.SameLine(110)
			imgui.SetCursorPosY(468) -- Расположение по Y
			imgui.Text(u8"/break")
			imgui.SameLine(110)
			imgui.SetCursorPosY(498) -- Расположение по Y
			imgui.Text(u8"/dbreak")
			imgui.EndChild()
		    imgui.SameLine(260)
		    imgui.SetCursorPosY(15) -- Расположение по Y
			imgui.BeginChild("Bind2", imgui.ImVec2(250, 540), true, imgui.WindowFlags.NoScrollbar)
			if imadd.ToggleButton('##ejectout', ejectoutrp) then
			if ejectoutrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["ejectout"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["ejectout"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##police_tablet', police_tabletrp) then
			if police_tabletrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["police_tablet"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["police_tablet"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			if imadd.ToggleButton('##break_door', break_doorrp) then
			if break_doorrp.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["break_door"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["break_door"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
			imgui.Separator()
			imgui.SameLine(110)
			imgui.SetCursorPosY(18) -- Расположение по Y
			imgui.Text(u8"/break_door")
			imgui.SameLine(110)
			imgui.SetCursorPosY(48) -- Расположение по Y
			imgui.Text(u8"/police_tablet")
			imgui.SameLine(110)
			imgui.SetCursorPosY(78) -- Расположение по Y
			imgui.Text(u8"/ejectout")
			imgui.EndChild()
			imgui.SameLine(520)
		    imgui.SetCursorPosY(15) -- Расположение по Y
			imgui.BeginChild("Bind3", imgui.ImVec2(248, 540), true, imgui.WindowFlags.NoScrollbar)
			imgui.SetCursorPosX(213) -- Расположение по X
            imgui.SetCursorPosY(10) -- Расположение по Y
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.11, 0.15, 0.17, 1.00))
    	    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
		    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
			size = imgui.ImVec2(15,15) 
		    if imgui.ImageButton(img3, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1)) then
		  		main_window_state.v = not main_window_state.v 
				imgui.Process = main_window_state.v 
            end
            imgui.PopStyleColor(3)
			imgui.EndChild()
    end
    if menu == 5 then
		imgui.BeginChild("Stream", imgui.ImVec2(379, 540), true, imgui.WindowFlags.NoScrollbar)
		size = imgui.ImVec2(100,100) 
		if imadd.ToggleButton('##ToggleButton1', tbutton1) then
			if tbutton1.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["hidesms"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["hidesms"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
		imgui.SameLine(80)
		imgui.SetCursorPosY(18) -- Расположение по Y
		imgui.Text(u8"Скрыть входящие СМС сообщения")
		if imadd.ToggleButton("##ToggleButton2", tbutton2) then 
			if tbutton2.v == true then 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["autoreject"] = "true"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			else 
				local file = io.open(path, "r") -- Выполняем те же действия
				a = file:read("*a")	
				file:close()
				table1 = decodeJson(a) -- Читаем нашу JSON-Таблицу
				local file = io.open(path, "w") -- Выполняем те же действия
				local table1 = decodeJson(a)
				table1["toggles"]["autoreject"] = "false"
				encodedTable = encodeJson(table1) -- превращаем наш Lua ма    ссив в JSON
				file:write(encodedTable) -- Записываем нашу таблицу
				file:flush() -- Сохраняем
				file:close() -- Закрываем
			end
		end
		imgui.SameLine(80)
		imgui.SetCursorPosY(51) -- Расположение по Y
		imgui.Text(u8"Автоматический сброс входящего звонка")
		imgui.EndChild()
		imgui.SameLine(389)
		imgui.SetCursorPosY(15) -- Расположение по Y
		imgui.BeginChild("Bind2", imgui.ImVec2(379, 540), true, imgui.WindowFlags.NoScrollbar)
		imgui.SameLine(160)
		imgui.SetCursorPosY(110) -- Расположение по Y
		imgui.Text(u8"Гос.волна")
		imgui.SetCursorPosY(150) -- Расположение по Y
		imgui.PushItemWidth(350) -- ширина
		if imgui.InputText('##gov1', gov1) then save_gov1() end
		if imgui.InputText('##gov2', gov2) then save_gov2() end
		if imgui.InputText('##gov3', gov3) then save_gov3() end
		if imgui.InputText('##gov4', gov4) then save_gov4() end
		if imgui.InputText('##gov5', gov5) then save_gov5() end
		if imgui.Button(u8"Отправить", imgui.ImVec2(350, 30)) then
			lua_thread.create(function()
			sampSendChat(u8:decode('/n ' ..gov1.v))
			wait(700)
			sampSendChat(u8:decode('/n ' ..gov2.v))
			wait(700)
			sampSendChat(u8:decode('/n ' ..gov3.v))
			wait(700)
			sampSendChat(u8:decode('/n ' ..gov4.v))
			wait(700)
			sampSendChat(u8:decode('/n ' ..gov5.v))
			end)
		end
		imgui.SetCursorPosX(344) -- Расположение по X
		imgui.SetCursorPosY(10) -- Расположение по Y
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.11, 0.15, 0.17, 1.00))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.07, 0.1, 0.11, 1.00))
		size = imgui.ImVec2(15,15) 
		if imgui.ImageButton(img3, size, imgui.ImVec2(0,0),  imgui.ImVec2(1,1), -1, imgui.ImVec4(1,1,1,0), imgui.ImVec4(1,1,1,1)) then
			main_window_state.v = not main_window_state.v 
			imgui.Process = main_window_state.v 
		end
		imgui.PopStyleColor(3)
		imgui.EndChild()
    end
	imgui.EndGroup()
	imgui.End()
end

function cmd_arrest(id)
	if arrestrp.v == true then 
		lua_thread.create(function()
		sampSendChat('/me включил(а) бортовой компьютер', -1)
		wait(800)
		sampSendChat('/me ввел(а) данные о преступнике', -1)
		wait(800)
		sampSendChat('/me передал(а) данные в отдел', -1)
		wait(800)
		sampSendChat('/me передал(а) преступника в участок', -1)
		sampSendChat('/arrest '..id)
		end)
	else
		sampSendChat('/arrest '..id)
	end
end

function cmd_su(id)
	if surp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me занес(ла) подозреваемого в базу данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/su '..id)
		end)
	else
		sampSendChat('/su '..id)
	end
end

function cmd_clear(id)
	if clearrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/clear '..id)
		end)
	else
		sampSendChat('/clear '..id)
	end
end

function cmd_wanted()
	if wantedrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/wanted')
		end)
	else
		sampSendChat('/wanted')
	end
end

function cmd_cuff(id)
	if cuffrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/cuff '..id)
		end)
	else
		sampSendChat('/cuff '..id)
	end
end

function cmd_uncuff(id)
	if uncuffrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/uncuff '..id)
		end)
	else
		sampSendChat('/uncuff '..id)
	end
end

function cmd_search(id)
	if searchrp.v == true then 
		lua_thread.create(function()
		sampSendChat('/me открыл(а) КПК', -1)
		wait(800)
		sampSendChat('/do КПК открыто.', -1)
		wait(800)
		sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
		wait(800)
		sampSendChat('/me закрыл(а) КПК', -1)
		sampSendChat('/search '..id)
		end)
	else
		sampSendChat('/search '..id)
	end
end

function cmd_remove(id)
	if removerp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/remove '..id)
		end)
	else
		sampSendChat('/remove '..id)
	end
end

function cmd_pg(id)
	if pgrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/pg '..id)
		end)
	else
		sampSendChat('/pg '..id)
	end
end

function cmd_takelic(id)
	if takelicrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/takelic '..id)
		end)
	else
		sampSendChat('/takelic '..id)
	end
end

function cmd_putpl(id)
	if putplrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/putpl '..id)
		end)
	else
		sampSendChat('/putpl '..id)
	end
end

function cmd_ticket(id)
	if ticketrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/ticket '..id)
			end)
	else
		sampSendChat('/ticket '..id)
	end
end

function cmd_escort(id)
	if escortrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/escort '..id)
		end)
	else
		sampSendChat('/escort '..id)
	end
end

function cmd_skip(id)
	if skiprp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/skip '..id)
		end)
	else
		sampSendChat('/skip '..id)
	end
end

function cmd_skip_key(id)
	if skip_keyrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/skip_key '..id)
		end)
	else
		sampSendChat('/skip_key '..id)
	end
end

function cmd_break(id)
	if breakrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/break '..id)
		end)
	else
		sampSendChat('/break '..id)
	end
end

function cmd_dbreak(id)
	if dbreakrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/dbreak '..id)
		end)
	else
		sampSendChat('/dbreak '..id)
	end
end

function cmd_break_door()
	if break_doorrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/break_door')
		end)
	else
		sampSendChat('/break_door')
	end
end

function cmd_police_tablet()
	if police_tabletrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/police_tablet')
			end)
	else
		sampSendChat('/police_tablet')
	end
end

function cmd_ejectout(id)
	if ejectoutrp.v == true then 
		lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			sampSendChat('/ejectout '..id)
		end)
	else
		sampSendChat('/ejectout '..id)
	end
end

function cmd_mpg(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me достал фотороботы подозреваемых', -1)
			wait(700)
			sampSendChat('/me нашел нужный фоторобот, после чего сверяет фоторобот с лицом подозреваемого', -1)
			wait(700)
			sampSendChat('/do Подозреваемый найден.', -1)
			wait(700)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/pg ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mpg {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me достал фотороботы подозреваемых', -1)
			wait(700)
			sampSendChat('/me нашел нужный фоторобот, после чего сверяет фоторобот с лицом подозреваемого', -1)
			wait(700)
			sampSendChat('/do Подозреваемый найден.', -1)
			wait(700)
			sampSendChat("/pg "..id)
		end) 
	end
end
	
function cmd_mhealme()
		 lua_thread.create(function()
			sampSendChat('/do Аптечка в руках', -1)
			wait(700)
			sampSendChat('/me открыл(а) аптечку и перевязал(а) руку', -1)
			wait(700)
			sampSendChat('/me закрыл(а) аптечку', -1)
			wait(700)
			sampSendChat('/healme', -1)
	end) 
end
	
function cmd_vzlom()
		 lua_thread.create(function()
			sampSendChat('/do Дверь закрыта.', -1)
			wait(800)
			sampSendChat('/me взял в руки лом, после чего засунул его в проём между замком и стеной', -1)
			wait(800)
			sampSendChat('/me резким движением руки нажал на лом', -1)
			wait(400)
			sampSendChat('/do Процес...', -1)
			wait(1200)
			sampSendChat('/do Слышен треск в районе замка.', -1)
			wait(800)
			sampSendChat('/me приложил больше усилий', -1)
			wait(500)
			sampSendChat('/do Замок сломался, дверь открыта.', -1)
	end) 
end
	
function cmd_alko()
		lua_thread.create(function()
		sampSendChat('/me подозревает, что человек под воздействием алкогольного опьянения', -1)
		wait(800)
		sampSendChat('/do Алкотестер лежит в кармашке на поясе.', -1)
		wait(800)
		sampSendChat('/me достал алкотестер', -1)
		wait(400)
		sampSendChat('/do Алкотестер в руке.', -1)
		wait(1200)
		sampSendChat('/me нажал кнопку включения на алкотестере', -1)
		wait(800)
		sampSendChat('/do Алкотестер включен и работает.', -1)
		wait(800)
		sampSendChat('/todo Поднося алкотестер ко рту человека*Дыхните в трубочку алкотестера...', -1)
		wait(500)
		sampSendChat('/try проверил допустимый уровень алкоголя в выдыхаемом воздухе человека', -1)
	end) 
end
	
function cmd_rob1()
		 lua_thread.create(function()
			sampSendChat('/me достал фотороботы подозреваемых', -1)
			wait(400)
			sampSendChat('/me нашёл нужный фоторобот, после чего сверяет фоторобот с лицом подозреваемого', -1)
			wait(800)
			sampSendChat('/do Лицо идентично.', -1)
	end) 
end
	
function cmd_rob2()
		 lua_thread.create(function()
			sampSendChat('/me сунув руку в карман, достал(а) КПК', -1)
			wait(400)
			sampSendChat('/do КПК в руке.', -1)
			wait(800)
			sampSendChat('/do Лицо идентично.', -1)
			wait(400)
			sampSendChat('/me нажав на кнопку Узнать личность, сделал(а) фотографию лица гражданина(-нки)', -1)
			wait(800)
			sampSendChat('/me узнал данные и убрал КПК в карман', -1)
			wait(800)
			sampSendChat('/do КПК в кармане.', -1)
	end) 
end
	
function cmd_msu(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me занес(ла) подозреваемого в базу данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/su ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/msu {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me занес(ла) подозреваемого в базу данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			wait(500)
			sampSendChat("/su "..id)
		end) 
	end
end
	
function cmd_mclear(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/clear ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mclear {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me удалил(а) подозреваемого из базы данных', -1)
			wait(800)
			sampSendChat('/me закрыл(а) КПК', -1)
			wait(500)
			sampSendChat("/clear "..id)
		end) 
	end
end
	
function cmd_msearch(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Резиновые перчатки на руках.', -1)
			wait(800)
			sampSendChat('/me прохлопал(а) верхний и нижний слой одежды человека напротив', -1)
			wait(800)
			sampSendChat('/me провел(а) руками по туловищу в области пояса и карманов', -1)
			wait(800)
			sampSendChat('/me снял(а) резиновые перчатки и положил(а) их в карман', -1)
			wait(500)
			sampSendChat('/anim 6 1', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/search ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/msearch {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Резиновые перчатки на руках.', -1)
			wait(800)
			sampSendChat('/me прохлопал(а) верхний и нижний слой одежды человека напротив', -1)
			wait(800)
			sampSendChat('/me провел(а) руками по туловищу в области пояса и карманов', -1)
			wait(800)
			sampSendChat('/me снял(а) резиновые перчатки и положил(а) их в карман', -1)
			wait(500)
			sampSendChat('/anim 6 1', -1)
			wait(500)
			sampSendChat("/search "..id)
		end) 
	end
end
	
function cmd_mremove(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me провёл(а) обыск у гражданина', -1)
			wait(800)
			sampSendChat('/me забирает запрещенные предметы у гражданина', -1)
			wait(800)
			sampSendChat('/do Запрещенные предметы забраны.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/remove ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mremove {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me провёл(а) обыск у гражданина', -1)
			wait(800)
			sampSendChat('/me забирает запрещенные предметы у гражданина', -1)
			wait(800)
			sampSendChat('/do Запрещенные предметы забраны.', -1)
			wait(500)
			sampSendChat("/remove "..id)
		end) 
	end
end
	
function cmd_mcuff(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Наручники на поясе.', -1)
			wait(800)
			sampSendChat('/me снял(а) наручники с пояса', -1)
			wait(800)
			sampSendChat('/do Наручники в руках.', -1)
			wait(800)
			sampSendChat('/me схватил(а) человека, затем заломал(а) руку', -1)
			wait(800)
			sampSendChat('/me заковал(а) человека в наручники', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/cuff ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mcuff {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Наручники на поясе.', -1)
			wait(800)
			sampSendChat('/me снял(а) наручники с пояса', -1)
			wait(800)
			sampSendChat('/do Наручники в руках.', -1)
			wait(800)
			sampSendChat('/me схватил(а) человека, затем заломал(а) руку', -1)
			wait(800)
			sampSendChat('/me заковал(а) человека в наручники', -1)
			wait(500)
			sampSendChat("/cuff "..id)
		end) 
	end
end
	
function cmd_muncuff(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Наручники на человеке.', -1)
			wait(800)
			sampSendChat('/me вставил(а) ключ в наручники, после чего снял(а) их', -1)
			wait(800)
			sampSendChat('/do Наручники сняты.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/uncuff ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/muncuff {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Наручники на человеке.', -1)
			wait(800)
			sampSendChat('/me вставил(а) ключ в наручники, после чего снял(а) их', -1)
			wait(800)
			sampSendChat('/do Наручники сняты.', -1)
			wait(500)
			sampSendChat("/uncuff "..id)
		end) 
	end
end
	
function cmd_mescort(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Человек в наручниках.', -1)
			wait(800)
			sampSendChat('/me повел(а) человека за собой', -1)
			wait(800)
			sampSendChat('/do Человек идёт.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mescort {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Человек в наручниках.', -1)
			wait(800)
			sampSendChat('/me повел(а) человека за собой', -1)
			wait(800)
			sampSendChat('/do Человек идёт.', -1)
			wait(500)
			sampSendChat("/escort "..id)
		end) 
	end
end
	
function cmd_muescort(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Человек задержан.', -1)
			wait(800)
			sampSendChat('/me отпустил(а) руку человека', -1)
			wait(800)
			sampSendChat('/do Человек свободен.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/muescort {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Человек задержан.', -1)
			wait(800)
			sampSendChat('/me отпустил(а) руку человека', -1)
			wait(800)
			sampSendChat('/do Человек свободен.', -1)
			wait(500)
			sampSendChat("/escort "..id)
		end) 
	end
end
	
function cmd_mputpl(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) дверь машины', -1)
			wait(800)
			sampSendChat('/me затащил(а) преступника в машину', -1)
			wait(800)
			sampSendChat('/me закрыл(а) дверь', -1)
			wait(800)
			sampSendChat('/do Дверь закрыта.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/putpl ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mputpl {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) дверь машины', -1)
			wait(800)
			sampSendChat('/me затащил(а) преступника в машину', -1)
			wait(800)
			sampSendChat('/me закрыл(а) дверь', -1)
			wait(800)
			sampSendChat('/do Дверь закрыта.', -1)
			wait(500)
			sampSendChat("/putpl "..id)
		end) 
	end
end
	
function cmd_muputpl(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) дверь', -1)
			wait(800)
			sampSendChat('/me вытащил(а) из машины человека', -1)
			wait(800)
			sampSendChat('/do Человек на улице.', -1)
			wait(800)
			sampSendChat('/me закрыл(а) дверь', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/eject ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/muputpl {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) дверь', -1)
			wait(800)
			sampSendChat('/me вытащил(а) из машины человека', -1)
			wait(800)
			sampSendChat('/do Человек на улице.', -1)
			wait(800)
			sampSendChat('/me закрыл(а) дверь', -1)
			wait(500)
			sampSendChat("/eject "..id)
		end) 
	end
end
	
function cmd_mejectout(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) рукой дверь в авто', -1)
			wait(800)
			sampSendChat('/me вытащил(а) из машины человека', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/ejectout ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mejectout {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me открыл(а) рукой дверь в авто', -1)
			wait(800)
			sampSendChat('/me вытащил(а) из машины человека', -1)
			wait(500)
			sampSendChat("/ejectout "..id)
		end) 
	end
end
	
function cmd_marrest(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me включил(а) бортовой компьютер', -1)
			wait(800)
			sampSendChat('/me ввел(а) данные о преступнике', -1)
			wait(800)
			sampSendChat('/me передал(а) данные в отдел', -1)
			wait(800)
			sampSendChat('/me передал(а) преступника в участок', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/arrest ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/marrest {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me включил(а) бортовой компьютер', -1)
			wait(800)
			sampSendChat('/me ввел(а) данные о преступнике', -1)
			wait(800)
			sampSendChat('/me передал(а) данные в отдел', -1)
			wait(800)
			sampSendChat('/me передал(а) преступника в участок', -1)
			wait(500)
			sampSendChat("/arrest "..id)
		end) 
	end
end
	
function cmd_mdoc2()
	lua_thread.create(function()
	sampSendChat('Будьте добры предъявить Ваши документы, а именно:', -1)
	wait(1000)
	sampSendChat('Паспорт, вод.права и документы на т/с.', -1)
	wait(1000)
	sampSendChat('/n /pass [id], /lic [ID] и /carpass [id]', -1)
	wait(1000)
	sampSendChat('А также, отстегните пожалуйста ремень безопасности.', -1)
	wait(1000)
	sampSendChat('/n /rem', -1)
	end) 
end

	
function cmd_mdoc3()
	lua_thread.create(function()
	sampSendChat('/me взял(а) документы у человека напротив', -1)
	wait(1000)
	sampSendChat('/do Документы в руке.', -1)
	wait(1000)
	sampSendChat('/me открыл(а) документы на нужной странице', -1)
	wait(1000)
	sampSendChat('/me осмотрел(а) страницу', -1)
	wait(1000)
	sampSendChat('/do Страница осмотрена.', -1)
	wait(1000)
	sampSendChat('/me закрыл(а) документы', -1)
	wait(1000)
	sampSendChat('/do Документы закрыты.', -1)
	wait(1000)
	sampSendChat('/me вернул(а) документы человеку напротив', -1)
	end) 
end
	
function cmd_mdoc4()
	lua_thread.create(function()
		sampSendChat('Спасибо за предоставление документов, можете быть свободны.', -1)
	end) 
end	
	
function cmd_mat1()
	lua_thread.create(function()
		sampSendChat('/me включил(а) бортовой компьютер ДПС', -1)
		wait(800)
		sampSendChat('/do Бортовой компьютер ДПС включен.', -1)
		wait(800)
		sampSendChat('/me нажал(а) на кнопку и сделал(а) фотографию', -1)
		wait(800)
		sampSendChat('/do Фотография сохранена на базе данных ДПС.', -1)
		wait(800)
		sampSendChat('/me нажал(а) на кнопку выключения бортового компьютера', -1)
		wait(800)
		sampSendChat('/do Бортовой компьютер выключен.', -1)
		wait(800)
		sampSendChat('/me поставил(а) эвакуатор на ручник', -1)
		wait(800)
		sampSendChat('/do Эвакуатор стоит на ручнике.', -1)
		wait(800)
		sampSendChat('/c 60', -1)
		wait(800)
		setVirtualKeyDown(119, true) 
		wait(100)
		setVirtualKeyDown(119, false)
	end) 
end
	
function cmd_mwanted()
	lua_thread.create(function()
		sampSendChat('/do КПК в кармане.', -1)
		wait(800)
		sampSendChat('/me достал(а) КПК и открыл(а) список разыскиваемых', -1)
		wait(800)
		sampSendChat('/do Процесс...', -1)
		wait(800)
		sampSendChat('/wanted', -1)
	end) 
end
	
function cmd_mbreak(id)
	if #id == 0 then
		lua_thread.create(function()
			sampSendChat('/me поставил(а) объект на землю', -1)
			wait(800)
			sampSendChat('/do Объект на земле.', -1)
			wait(800)
			sampSendChat('/me закрепил(а) объект', -1)
			wait(800)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/break ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mbreak {ff1212}ID Объекта{FFFFFF} ]')
		end)
	else
		lua_thread.create(function()
			sampSendChat('/me поставил(а) объект на землю', -1)
			wait(800)
			sampSendChat('/do Объект на земле.', -1)
			wait(800)
			sampSendChat('/me закрепил(а) объект', -1)
			wait(800)
			sampSendChat("/break " ..id)	
		end) 
	end
end
	
function cmd_mdbreak(id)
	if #id == 0 then
		lua_thread.create(function()
			sampSendChat('/me открутил(а) болты', -1)
			wait(800)
			sampSendChat('/do Объект откреплен.', -1)
			wait(800)
			sampSendChat('/me взял(а) объект с земли и подвинул(а) его', -1)
			wait(800)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/dbreak ")
			sampAddChatMessage('{ff1212}Введите {FFFFFF}[ {FFFFFF}/mdbreak {ff1212}ID Объекта{FFFFFF} ]')
		end)
	else
		lua_thread.create(function()
			sampSendChat('/me открутил(а) болты', -1)
			wait(800)
			sampSendChat('/do Объект откреплен.', -1)
			wait(800)
			sampSendChat('/me взял(а) объект с земли и подвинул(а) его', -1)
			wait(800)
			sampSendChat("/dbreak " ..id)	
		end) 
	end
end	
	
function cmd_cc()
	local memory = require "memory"
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function cmd_mrec(param)
	time = tonumber(param)
	res = true
end

function cmd_mvd()
	lua_thread.create(function() -- Нужен для цыкла (while на 3-й строке)
    sampShowDialog(6405, "{FFD700}МВД Helper [by Harley]", "{FFFFFF}[МВД] Надеть наручники\n[МВД] Повести за собой\n[МВД] Посадить преступника в авто\n[МВД] Снять наручники\n[МВД] Не вести за собой\n[МВД] Высадить игрока из авто\n[МВД] Посадить преступника в КПЗ\n[МВД] Обьявить преступника в розыск\n[МВД] Выписать штраф\n[МВД] Изьять права у нарушителя\n[МВД] Изьять лицензию на оружие у нарушителя\n[МВД] Открыть список разыскиваемых\n[МВД] Вытащить из авто силой\n------------------------\n[Доп] Надеть маску по РП\n[Доп] Информация", "Выбрать", "Отмена", 2) -- сам диалог
    while sampIsDialogActive(6405) do wait(100) end -- ждёт пока вы ответите на диалог
    local _, button, list, _ = sampHasDialogRespond(6405) -- получаем ответ на диалог
    if button == 1 then -- Если кнопка 1-я("Выбрать") тогда...
        if list == 0 then
			sampSendChat('/do Наручники на поясе.', -1)
			wait(800)
			sampSendChat('/me снял(а) наручники с пояса', -1)
			wait(800)
			sampSendChat('/do Наручники в руках.', -1)
			wait(800)
			sampSendChat('/me схватил(а) человека, затем заломал(а) руку', -1)
			wait(800)
			sampSendChat('/me заковал(а) человека в наручники', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/cuff ")
        elseif list == 1 then
            sampSendChat('/do Человек в наручниках.', -1)
			wait(800)
			sampSendChat('/me повел(а) человека за собой', -1)
			wait(800)
			sampSendChat('/do Человек идёт.', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
        elseif list == 2 then
            sampSendChat('/me открыл(а) дверь машины', -1)
			wait(800)
			sampSendChat('/me затащил(а) преступника в машину', -1)
			wait(800)
			sampSendChat('/me закрыл(а) дверь', -1)
			wait(800)
			sampSendChat('/do Дверь закрыта.', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/putpl ")
		elseif list == 3 then
            sampSendChat('/do Наручники на человеке.', -1)
			wait(800)
			sampSendChat('/me вставил(а) ключ в наручники, после чего снял(а) их', -1)
			wait(800)
			sampSendChat('/do Наручники сняты.', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/uncuff ")
		elseif list == 4 then
            sampSendChat('/do Человек задержан.', -1)
			wait(800)
			sampSendChat('/me отпустил(а) руку человека', -1)
			wait(800)
			sampSendChat('/do Человек свободен.', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
		elseif list == 5 then
            sampSendChat('/me открыл(а) дверь', -1)
			wait(800)
			sampSendChat('/me вытащил(а) из машины человека', -1)
			wait(800)
			sampSendChat('/do Человек на улице.', -1)
			wait(800)
			sampSendChat('/me закрыл(а) дверь', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/eject ")
		elseif list == 6 then
            sampSendChat('/me включил(а) бортовой компьютер', -1)
			wait(800)
			sampSendChat('/me ввел(а) данные о преступнике', -1)
			wait(800)
			sampSendChat('/me передал(а) данные в отдел', -1)
			wait(800)
			sampSendChat('/me передал(а) преступника в участок', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/arrest ")
		elseif list == 7 then
            sampSendChat('/me открыл(а) КПК', -1)
			wait(800)
			sampSendChat('/do КПК открыто.', -1)
			wait(800)
			sampSendChat('/me занес(ла) подозреваемого в базу данных', -1)
			wait(800)
			sampSendChat('me закрыл(а) КПК.', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/su ")
		elseif list == 8 then
            sampSendChat('/do Бланк в руках.', -1)
			wait(800)
			sampSendChat('/me начал(а) заполнять бланк', -1)
			wait(800)
			sampSendChat('/me записал(а) причину выписывания протокола', -1)
			wait(800)
			sampSendChat('/me записал(а) данные правонарушителя', -1)
			wait(800)
			sampSendChat('/do Протокол заполнен.', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/ticket ")
		elseif list == 9 then
            sampSendChat('/me взял(а) права у человека напротив', -1)
			wait(800)
			sampSendChat('/do Штамп в руках.', -1)
			wait(800)
			sampSendChat('/me поставил(а) штамп "недействительно" на права', -1)
			wait(800)
			sampSendChat('/me передал(а) права человеку напротив', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/takelic ")
		elseif list == 10 then
            sampSendChat('/me взял(а) лицензию у человека напротив', -1)
			wait(800)
			sampSendChat('/do Штамп в руках.', -1)
			wait(800)
			sampSendChat('/me поставил(а) штамп "недействительно" на лицензию', -1)
			wait(800)
			sampSendChat('/me вернул(а) недействительную лицензию человеку напротив', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/takelic ")
		elseif list == 11 then
            sampSendChat('/do КПК в кармане.', -1)
			wait(800)
			sampSendChat('/me достал(а) КПК и открыл(а) список разыскиваемых', -1)
			wait(800)
			sampSendChat('/do Процесс...', -1)
			wait(800)
			sampSendChat('/wanted', -1)
		elseif list == 12 then
            sampSendChat('/me прикладом разбил(а) окно в авто и открыл(а) дверь', -1)
			wait(800)
			sampSendChat('/me вытащил(а) из машины человека', -1)
			wait(800)
			sampSendChat('/do Человек на улице.', -1)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/ejectout ")
		elseif list == 13 then
            sampAddChatMessage(mvd.. " {FFFFFF}Это разделитель...")
		elseif list == 14 then
            sampSendChat('/me достал(а) маску из кармана', -1)
			wait(800)
			sampSendChat('/do Маска в руках.', -1)
			wait(800)
			sampSendChat('/me надел(а) маску на голову', -1)
			wait(800)
			sampSendChat('/do Маска надета.', -1)
			wait(500)
			sampSendChat('/mask', -1)
		elseif list == 15 then
            sampShowDialog(6406, "{87CEFA}Помощь - МВД Helper [by Harley] - 1 страница", "{87CEFA}Alt + G{ffffff} - Меню скрипта.\n{87CEFA}/mhealme{ffffff} - /healme [Использовать аптечку].\n{87CEFA}/msu {D6492D}[ID]{ffffff} - /su [Выдать розыск].\n{87CEFA}/mclear {D6492D}[ID] [Кол-во] [Причина]{ffffff} - /clear [Снять розыск].\n{87CEFA}/marrest {D6492D}[ID]{ffffff} - /arrest [Арестовать].\n{87CEFA}/mtakelic {D6492D}[ID] [Причина]{ffffff} - /takelic [Изъять права].\n{87CEFA}/mmtakelic {D6492D}[ID] [Причина]{ffffff} - /takelic [Изъять лиц.оружие].\n{87CEFA}/msearch {D6492D}[ID]{ffffff} - /search [Обыскать].\n{87CEFA}/mremove {D6492D}[ID]{ffffff} - /remove [Изъять нелегал].\n{87CEFA}/mcuff {D6492D}[ID]{ffffff} - /cuff [Надеть наручники].\n{87CEFA}/muncuff {D6492D}[ID]{ffffff} - /uncuff [Снять наручники]. \n{87CEFA}/mescort {D6492D}[ID]{ffffff} - /escort [Начать конвоировать].\n{87CEFA}/muescort {D6492D}[ID]{ffffff} - /escort [Перестать конвоировать].\n{87CEFA}/mticket {D6492D}[ID] [Кол-во] [Причина]{ffffff} - /ticket [Штраф].\n{87CEFA}/mputpl {D6492D}[ID]{ffffff} - /putpl [Засунуть в пат.авто].\n{87CEFA}/muputpl {D6492D}[ID]{ffffff} - /eject [Высунуть из пат.авто].\n{87CEFA}/mejectout {D6492D}[ID]{ffffff} - /ejectout [Вытащить из авто].\n{87CEFA}/mg {D6492D}[ID]{ffffff} - Требование прижаться к обочине [Мегафон].\n{87CEFA}/rob1{ffffff} - Проверка игрока по фотороботу, если не показывает паспорт.\n{87CEFA}/rob2{ffffff} - Проверка игрока по фотороботу, если не показывает паспорт.\n{87CEFA}/mdoc1 {D6492D}[ID]{ffffff} - /doc [Представиться].", "Закрыть", "Далее", 0)
            while sampIsDialogActive(6406) do wait(100) end 
    		local _, button, list, _ = sampHasDialogRespond(6406) 
    		if button == 1 then 
    
    	else
    		sampShowDialog(6406, "{87CEFA}Помощь - МВД Helper [by Harley] - 2 страница", "{87CEFA}/mdoc2{ffffff} - [Попросить документы].\n{87CEFA}/mdoc3{ffffff} - [Осмотреть документы].\n{87CEFA}/mdoc4{ffffff} - [Отпустить после проверки].\n{87CEFA}/mr{ffffff} - [Открыть рацию с поставленным тэгом].\n{87CEFA}/mat1{ffffff} - /at [Скрин авто].\n{87CEFA}/mat2{ffffff} - /at [Зацепить авто].\n{87CEFA}/mat3{ffffff} - /at [Отцепить авто].\n{87CEFA}/mpost1{ffffff} - Меню доклада [Заступил на пост].\n{87CEFA}/mpost2{ffffff} - Меню доклада [Продолжил пост].\n{87CEFA}/mpost3{ffffff} - Меню доклада [Покинул пост].\n{87CEFA}/msm {D6492D}[ID]{ffffff} - /setmark [Flood - /setmark].\n{87CEFA}/mpg {D6492D}[ID]{ffffff} - /pg [Начать погоню].\n{87CEFA}/mwanted{ffffff} - /wanted [Списокк разыскиваемых].\n{87CEFA}/mbreak {D6492D}[ID]{ffffff} - /break [Поставить приграду].\n{87CEFA}/mdbreak {D6492D}[ID]{ffffff} - /dbreak [Убрать приграду].\n{87CEFA}/vzlom{ffffff} - Отыгровка взлома замка двери.\n{87CEFA}/alko{ffffff} - Отыгровка проверки на алкоголь в выдыхаемом воздухе.\n{87CEFA}/mvisit {ffffff} - RP визитка [Номер, ранг, имя, телефон, дс].\n{87CEFA}/mbank {ffffff} - RP банковский счёт.\n{87CEFA}/fraza {ffffff} - Рандомная цитата актеров / персонажей.\n{87CEFA}/random {D6492D}[От n-числа до n-числа]{ffffff} - Рандомная цифра.\n{87CEFA}/cc{ffffff} - Очистка чата.\n{87CEFA}/koap1-15 {ffffff} - КоАП 1 - 15 сервера.\n{87CEFA}/koap13_2 {ffffff} - КоАП 13 сервера, вторая страница. Спс админам за огромный КоАп.", "Отмена", "Закрыть", 0)
        end
    	else 
			end
    	end
	end)
end

function JSONSave()
    if doesFileExist(path) then
        local f = io.open(path, 'w+')
        if f then
            f:write(encodeJson(config)):close()
        end
    end
end
