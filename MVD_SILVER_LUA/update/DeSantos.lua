script_name("MVD Helper Silver | LUA")
script_authors('Harley AHK')
script_description('MVD Helper LUA by Harley AHK')
script_moonloader('26')
script_version('2')

require("lib.moonloader") 
local inicfg = require ('inicfg')


local dialogArr = {"Óñòîíîâèòü òåêñò äëÿ ôëóäà", "Óñòîíîâèòü çàääåðæêó", "{00FF1E}Íà÷àòü ôëóä"}
local dialogStr = ""
local mvd = "{1E90FF}[ÌÂÄ]{FFFFFF}" 

local enable_autoupdate = true  
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Çàãðóæåíî %d èç %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')sampAddChatMessage(b..'Îáíîâëåíèå çàâåðøåíî!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Îáíîâëåíèå íå òðåáóåòñÿ.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, âûõîäèì èç îæèäàíèÿ ïðîâåðêè îáíîâëåíèÿ. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/Jackharley8888/MVD/main/MVD_SILVER_LUA/update/version.json" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Jackharley8888/MVD/tree/main/MVD_SILVER_LUA/update"
        end
    end
end

function main()
     if not isSampLoaded() or not isSampfuncsLoaded() then return end
        while not isSampAvailable() do wait(100) end
	sampAddChatMessage(mvd.. " {FFFFFF}Çäðàâñòâóéòå. Âû çàïóñòèëè Silver MVD Helper [by Harley].")
	sampAddChatMessage(mvd.. " {FFFFFF}Âåðñèÿ ñêðèïòà:. Ïðèÿòíîãî èñïîëüçîâàíèÿ.")
	sampAddChatMessage(mvd.. " {FFFFFF}Ãðóïïà ÂÊ: AHK Harley | Radmir RP (@ahkradmirharley)")
	sampAddChatMessage(mvd.. " {FFFFFF}Ðàçðàáîò÷èêè: {1E90FF}Îëåêñàíäð Õàðëîâ {FFFFFF}è {32CD32}Ìàðê Çàãóðñêèé.")
	
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
	
	_, idPed = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(idPed)

	if autoupdate_loaded and enable_autoupdate and Update then
    	pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

	wait(-1)
end
	
function cmd_mpg(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me äîñòàë ôîòîðîáîòû ïîäîçðåâàåìûõ', -1)
			wait(700)
			sampSendChat('/me íàøåë íóæíûé ôîòîðîáîò, ïîñëå ÷åãî ñâåðÿåò ôîòîðîáîò ñ ëèöîì ïîäîçðåâàåìîãî', -1)
			wait(700)
			sampSendChat('/do Ïîäîçðåâàåìûé íàéäåí.', -1)
			wait(700)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/pg ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mpg {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me äîñòàë ôîòîðîáîòû ïîäîçðåâàåìûõ', -1)
			wait(700)
			sampSendChat('/me íàøåë íóæíûé ôîòîðîáîò, ïîñëå ÷åãî ñâåðÿåò ôîòîðîáîò ñ ëèöîì ïîäîçðåâàåìîãî', -1)
			wait(700)
			sampSendChat('/do Ïîäîçðåâàåìûé íàéäåí.', -1)
			wait(700)
			sampSendChat("/pg "..id)
		end) 
		end
	end
	
function cmd_mhealme()
		 lua_thread.create(function()
			sampSendChat('/do Àïòå÷êà â ðóêàõ', -1)
			wait(700)
			sampSendChat('/me îòêðûë(à) àïòå÷êó è ïåðåâÿçàë(à) ðóêó', -1)
			wait(700)
			sampSendChat('/me çàêðûë(à) àïòå÷êó', -1)
			wait(700)
			sampSendChat('/healme', -1)
		end) 
	end
	
function cmd_vzlom()
		 lua_thread.create(function()
			sampSendChat('/do Äâåðü çàêðûòà.', -1)
			wait(800)
			sampSendChat('/me âçÿë â ðóêè ëîì, ïîñëå ÷åãî çàñóíóë åãî â ïðî¸ì ìåæäó çàìêîì è ñòåíîé', -1)
			wait(800)
			sampSendChat('/me ðåçêèì äâèæåíèåì ðóêè íàæàë íà ëîì', -1)
			wait(400)
			sampSendChat('/do Ïðîöåñ...', -1)
			wait(1200)
			sampSendChat('/do Ñëûøåí òðåñê â ðàéîíå çàìêà.', -1)
			wait(800)
			sampSendChat('/me ïðèëîæèë áîëüøå óñèëèé', -1)
			wait(500)
			sampSendChat('/do Çàìîê ñëîìàëñÿ, äâåðü îòêðûòà.', -1)
		end) 
	end
	
function cmd_alko()
		 lua_thread.create(function()
			sampSendChat('/me ïîäîçðåâàåò, ÷òî ÷åëîâåê ïîä âîçäåéñòâèåì àëêîãîëüíîãî îïüÿíåíèÿ', -1)
			wait(800)
			sampSendChat('/do Àëêîòåñòåð ëåæèò â êàðìàøêå íà ïîÿñå.', -1)
			wait(800)
			sampSendChat('/me äîñòàë àëêîòåñòåð', -1)
			wait(400)
			sampSendChat('/do Àëêîòåñòåð â ðóêå.', -1)
			wait(1200)
			sampSendChat('/me íàæàë êíîïêó âêëþ÷åíèÿ íà àëêîòåñòåðå', -1)
			wait(800)
			sampSendChat('/do Àëêîòåñòåð âêëþ÷åí è ðàáîòàåò.', -1)
			wait(800)
			sampSendChat('/todo Ïîäíîñÿ àëêîòåñòåð êî ðòó ÷åëîâåêà*Äûõíèòå â òðóáî÷êó àëêîòåñòåðà...', -1)
			wait(500)
			sampSendChat('/try ïðîâåðèë äîïóñòèìûé óðîâåíü àëêîãîëÿ â âûäûõàåìîì âîçäóõå ÷åëîâåêà', -1)
		end) 
	end
	
function cmd_rob1()
		 lua_thread.create(function()
			sampSendChat('/me äîñòàë ôîòîðîáîòû ïîäîçðåâàåìûõ', -1)
			wait(400)
			sampSendChat('/me íàø¸ë íóæíûé ôîòîðîáîò, ïîñëå ÷åãî ñâåðÿåò ôîòîðîáîò ñ ëèöîì ïîäîçðåâàåìîãî', -1)
			wait(800)
			sampSendChat('/do Ëèöî èäåíòè÷íî.', -1)
		end) 
	end
	
function cmd_rob2()
		 lua_thread.create(function()
			sampSendChat('/me ñóíóâ ðóêó â êàðìàí, äîñòàë(à) ÊÏÊ', -1)
			wait(400)
			sampSendChat('/do ÊÏÊ â ðóêå.', -1)
			wait(800)
			sampSendChat('/do Ëèöî èäåíòè÷íî.', -1)
			wait(400)
			sampSendChat('/me íàæàâ íà êíîïêó Óçíàòü ëè÷íîñòü, ñäåëàë(à) ôîòîãðàôèþ ëèöà ãðàæäàíèíà(-íêè)', -1)
			wait(800)
			sampSendChat('/me óçíàë äàííûå è óáðàë ÊÏÊ â êàðìàí', -1)
			wait(800)
			sampSendChat('/do ÊÏÊ â êàðìàíå.', -1)
		end) 
	end
	
function cmd_msu(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) ÊÏÊ', -1)
			wait(800)
			sampSendChat('/do ÊÏÊ îòêðûòî.', -1)
			wait(800)
			sampSendChat('/me çàíåñ(ëà) ïîäîçðåâàåìîãî â áàçó äàííûõ', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) ÊÏÊ', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/su ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/msu {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) ÊÏÊ', -1)
			wait(800)
			sampSendChat('/do ÊÏÊ îòêðûòî.', -1)
			wait(800)
			sampSendChat('/me çàíåñ(ëà) ïîäîçðåâàåìîãî â áàçó äàííûõ', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) ÊÏÊ', -1)
			wait(500)
			sampSendChat("/su "..id)
		end) 
		end
	end
	
function cmd_mclear(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) ÊÏÊ', -1)
			wait(800)
			sampSendChat('/do ÊÏÊ îòêðûòî.', -1)
			wait(800)
			sampSendChat('/me óäàëèë(à) ïîäîçðåâàåìîãî èç áàçû äàííûõ', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) ÊÏÊ', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/clear ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mclear {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) ÊÏÊ', -1)
			wait(800)
			sampSendChat('/do ÊÏÊ îòêðûòî.', -1)
			wait(800)
			sampSendChat('/me óäàëèë(à) ïîäîçðåâàåìîãî èç áàçû äàííûõ', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) ÊÏÊ', -1)
			wait(500)
			sampSendChat("/clear "..id)
		end) 
		end
	end
	
function cmd_msearch(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Ðåçèíîâûå ïåð÷àòêè íà ðóêàõ.', -1)
			wait(800)
			sampSendChat('/me ïðîõëîïàë(à) âåðõíèé è íèæíèé ñëîé îäåæäû ÷åëîâåêà íàïðîòèâ', -1)
			wait(800)
			sampSendChat('/me ïðîâåë(à) ðóêàìè ïî òóëîâèùó â îáëàñòè ïîÿñà è êàðìàíîâ', -1)
			wait(800)
			sampSendChat('/me ñíÿë(à) ðåçèíîâûå ïåð÷àòêè è ïîëîæèë(à) èõ â êàðìàí', -1)
			wait(500)
			sampSendChat('/anim 6 1', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/search ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/msearch {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Ðåçèíîâûå ïåð÷àòêè íà ðóêàõ.', -1)
			wait(800)
			sampSendChat('/me ïðîõëîïàë(à) âåðõíèé è íèæíèé ñëîé îäåæäû ÷åëîâåêà íàïðîòèâ', -1)
			wait(800)
			sampSendChat('/me ïðîâåë(à) ðóêàìè ïî òóëîâèùó â îáëàñòè ïîÿñà è êàðìàíîâ', -1)
			wait(800)
			sampSendChat('/me ñíÿë(à) ðåçèíîâûå ïåð÷àòêè è ïîëîæèë(à) èõ â êàðìàí', -1)
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
			sampSendChat('/me ïðîâ¸ë(à) îáûñê ó ãðàæäàíèíà', -1)
			wait(800)
			sampSendChat('/me çàáèðàåò çàïðåùåííûå ïðåäìåòû ó ãðàæäàíèíà', -1)
			wait(800)
			sampSendChat('/do Çàïðåùåííûå ïðåäìåòû çàáðàíû.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/remove ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mremove {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me ïðîâ¸ë(à) îáûñê ó ãðàæäàíèíà', -1)
			wait(800)
			sampSendChat('/me çàáèðàåò çàïðåùåííûå ïðåäìåòû ó ãðàæäàíèíà', -1)
			wait(800)
			sampSendChat('/do Çàïðåùåííûå ïðåäìåòû çàáðàíû.', -1)
			wait(500)
			sampSendChat("/remove "..id)
		end) 
		end
	end
	
function cmd_mcuff(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Íàðó÷íèêè íà ïîÿñå.', -1)
			wait(800)
			sampSendChat('/me ñíÿë(à) íàðó÷íèêè ñ ïîÿñà', -1)
			wait(800)
			sampSendChat('/do Íàðó÷íèêè â ðóêàõ.', -1)
			wait(800)
			sampSendChat('/me ñõâàòèë(à) ÷åëîâåêà, çàòåì çàëîìàë(à) ðóêó', -1)
			wait(800)
			sampSendChat('/me çàêîâàë(à) ÷åëîâåêà â íàðó÷íèêè', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/cuff ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mcuff {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Íàðó÷íèêè íà ïîÿñå.', -1)
			wait(800)
			sampSendChat('/me ñíÿë(à) íàðó÷íèêè ñ ïîÿñà', -1)
			wait(800)
			sampSendChat('/do Íàðó÷íèêè â ðóêàõ.', -1)
			wait(800)
			sampSendChat('/me ñõâàòèë(à) ÷åëîâåêà, çàòåì çàëîìàë(à) ðóêó', -1)
			wait(800)
			sampSendChat('/me çàêîâàë(à) ÷åëîâåêà â íàðó÷íèêè', -1)
			wait(500)
			sampSendChat("/cuff "..id)
		end) 
		end
	end
	
function cmd_muncuff(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do Íàðó÷íèêè íà ÷åëîâåêå.', -1)
			wait(800)
			sampSendChat('/me âñòàâèë(à) êëþ÷ â íàðó÷íèêè, ïîñëå ÷åãî ñíÿë(à) èõ', -1)
			wait(800)
			sampSendChat('/do Íàðó÷íèêè ñíÿòû.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/uncuff ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/muncuff {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do Íàðó÷íèêè íà ÷åëîâåêå.', -1)
			wait(800)
			sampSendChat('/me âñòàâèë(à) êëþ÷ â íàðó÷íèêè, ïîñëå ÷åãî ñíÿë(à) èõ', -1)
			wait(800)
			sampSendChat('/do Íàðó÷íèêè ñíÿòû.', -1)
			wait(500)
			sampSendChat("/uncuff "..id)
		end) 
		end
	end
	
function cmd_mescort(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ×åëîâåê â íàðó÷íèêàõ.', -1)
			wait(800)
			sampSendChat('/me ïîâåë(à) ÷åëîâåêà çà ñîáîé', -1)
			wait(800)
			sampSendChat('/do ×åëîâåê èä¸ò.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mescort {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do ×åëîâåê â íàðó÷íèêàõ.', -1)
			wait(800)
			sampSendChat('/me ïîâåë(à) ÷åëîâåêà çà ñîáîé', -1)
			wait(800)
			sampSendChat('/do ×åëîâåê èä¸ò.', -1)
			wait(500)
			sampSendChat("/escort "..id)
		end) 
		end
	end
	
function cmd_muescort(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ×åëîâåê çàäåðæàí.', -1)
			wait(800)
			sampSendChat('/me îòïóñòèë(à) ðóêó ÷åëîâåêà', -1)
			wait(800)
			sampSendChat('/do ×åëîâåê ñâîáîäåí.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/muescort {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do ×åëîâåê çàäåðæàí.', -1)
			wait(800)
			sampSendChat('/me îòïóñòèë(à) ðóêó ÷åëîâåêà', -1)
			wait(800)
			sampSendChat('/do ×åëîâåê ñâîáîäåí.', -1)
			wait(500)
			sampSendChat("/escort "..id)
		end) 
		end
	end
	
function cmd_mputpl(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) äâåðü ìàøèíû', -1)
			wait(800)
			sampSendChat('/me çàòàùèë(à) ïðåñòóïíèêà â ìàøèíó', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) äâåðü', -1)
			wait(800)
			sampSendChat('/do Äâåðü çàêðûòà.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/putpl ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mputpl {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) äâåðü ìàøèíû', -1)
			wait(800)
			sampSendChat('/me çàòàùèë(à) ïðåñòóïíèêà â ìàøèíó', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) äâåðü', -1)
			wait(800)
			sampSendChat('/do Äâåðü çàêðûòà.', -1)
			wait(500)
			sampSendChat("/putpl "..id)
		end) 
		end
	end
	
function cmd_muputpl(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) äâåðü', -1)
			wait(800)
			sampSendChat('/me âûòàùèë(à) èç ìàøèíû ÷åëîâåêà', -1)
			wait(800)
			sampSendChat('/do ×åëîâåê íà óëèöå.', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) äâåðü', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/eject ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/muputpl {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) äâåðü', -1)
			wait(800)
			sampSendChat('/me âûòàùèë(à) èç ìàøèíû ÷åëîâåêà', -1)
			wait(800)
			sampSendChat('/do ×åëîâåê íà óëèöå.', -1)
			wait(800)
			sampSendChat('/me çàêðûë(à) äâåðü', -1)
			wait(500)
			sampSendChat("/eject "..id)
		end) 
		end
	end
	
function cmd_mejectout(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) ðóêîé äâåðü â àâòî', -1)
			wait(800)
			sampSendChat('/me âûòàùèë(à) èç ìàøèíû ÷åëîâåêà', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/ejectout ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mejectout {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me îòêðûë(à) ðóêîé äâåðü â àâòî', -1)
			wait(800)
			sampSendChat('/me âûòàùèë(à) èç ìàøèíû ÷åëîâåêà', -1)
			wait(500)
			sampSendChat("/ejectout "..id)
		end) 
		end
	end
	
function cmd_marrest(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me âêëþ÷èë(à) áîðòîâîé êîìïüþòåð', -1)
			wait(800)
			sampSendChat('/me ââåë(à) äàííûå î ïðåñòóïíèêå', -1)
			wait(800)
			sampSendChat('/me ïåðåäàë(à) äàííûå â îòäåë', -1)
			wait(800)
			sampSendChat('/me ïåðåäàë(à) ïðåñòóïíèêà â ó÷àñòîê', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/arrest ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/marrest {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me âêëþ÷èë(à) áîðòîâîé êîìïüþòåð', -1)
			wait(800)
			sampSendChat('/me ââåë(à) äàííûå î ïðåñòóïíèêå', -1)
			wait(800)
			sampSendChat('/me ïåðåäàë(à) äàííûå â îòäåë', -1)
			wait(800)
			sampSendChat('/me ïåðåäàë(à) ïðåñòóïíèêà â ó÷àñòîê', -1)
			wait(500)
			sampSendChat("/arrest "..id)
		end) 
		end
	end
	
function cmd_mdoc2()
		 lua_thread.create(function()
			sampSendChat('Áóäüòå äîáðû ïðåäúÿâèòü Âàøè äîêóìåíòû, à èìåííî:', -1)
			wait(1000)
			sampSendChat('Ïàñïîðò, âîä.ïðàâà è äîêóìåíòû íà ò/ñ.', -1)
			wait(1000)
			sampSendChat('/n /pass [id], /lic [ID] è /carpass [id]', -1)
			wait(1000)
			sampSendChat('À òàêæå, îòñòåãíèòå ïîæàëóéñòà ðåìåíü áåçîïàñíîñòè.', -1)
			wait(1000)
			sampSendChat('/n /rem', -1)
		end) 
		end

	
function cmd_mdoc3()
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me âçÿë(à) äîêóìåíòû ó ÷åëîâåêà íàïðîòèâ', -1)
			wait(1000)
			sampSendChat('/do Äîêóìåíòû â ðóêå.', -1)
			wait(1000)
			sampSendChat('/me îòêðûë(à) äîêóìåíòû íà íóæíîé ñòðàíèöå', -1)
			wait(1000)
			sampSendChat('/me îñìîòðåë(à) ñòðàíèöó', -1)
			wait(1000)
			sampSendChat('/do Ñòðàíèöà îñìîòðåíà.', -1)
			wait(1000)
			sampSendChat('/me çàêðûë(à) äîêóìåíòû', -1)
			wait(1000)
			sampSendChat('/do Äîêóìåíòû çàêðûòû.', -1)
			wait(1000)
			sampSendChat('/me âåðíóë(à) äîêóìåíòû ÷åëîâåêó íàïðîòèâ', -1)
		end) 
		end
	end
	
function cmd_mdoc4()
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('Ñïàñèáî çà ïðåäîñòàâëåíèå äîêóìåíòîâ, ìîæåòå áûòü ñâîáîäíû.', -1)
		end) 
		end
	end
	
function cmd_mat1()
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me âêëþ÷èë(à) áîðòîâîé êîìïüþòåð ÄÏÑ', -1)
			wait(800)
			sampSendChat('/do Áîðòîâîé êîìïüþòåð ÄÏÑ âêëþ÷åí.', -1)
			wait(800)
			sampSendChat('/me íàæàë(à) íà êíîïêó è ñäåëàë(à) ôîòîãðàôèþ', -1)
			wait(800)
			sampSendChat('/do Ôîòîãðàôèÿ ñîõðàíåíà íà áàçå äàííûõ ÄÏÑ.', -1)
			wait(800)
			sampSendChat('/me íàæàë(à) íà êíîïêó âûêëþ÷åíèÿ áîðòîâîãî êîìïüþòåðà', -1)
			wait(800)
			sampSendChat('/do Áîðòîâîé êîìïüþòåð âûêëþ÷åí.', -1)
			wait(800)
			sampSendChat('/me ïîñòàâèë(à) ýâàêóàòîð íà ðó÷íèê', -1)
			wait(800)
			sampSendChat('/do Ýâàêóàòîð ñòîèò íà ðó÷íèêå.', -1)
			wait(800)
			sampSendChat('/c 60', -1)
			wait(800)
			setVirtualKeyDown(119, true) 
			wait(100)
			setVirtualKeyDown(119, false)
		end) 
		end
	end
	
function cmd_mwanted()
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ÊÏÊ â êàðìàíå.', -1)
			wait(800)
			sampSendChat('/me äîñòàë(à) ÊÏÊ è îòêðûë(à) ñïèñîê ðàçûñêèâàåìûõ', -1)
			wait(800)
			sampSendChat('/do Ïðîöåññ...', -1)
			wait(800)
			sampSendChat('/wanted', -1)
		end) 
		end
	end
	
function cmd_mbreak(id)
	if #id == 0 then
		lua_thread.create(function()
			sampSendChat('/me ïîñòàâèë(à) îáúåêò íà çåìëþ', -1)
			wait(800)
			sampSendChat('/do Îáúåêò íà çåìëå.', -1)
			wait(800)
			sampSendChat('/me çàêðåïèë(à) îáúåêò', -1)
			wait(800)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/break ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mbreak {ff1212}ID Îáúåêòà{FFFFFF} ]')
		end)
	else
		lua_thread.create(function()
			sampSendChat('/me ïîñòàâèë(à) îáúåêò íà çåìëþ', -1)
			wait(800)
			sampSendChat('/do Îáúåêò íà çåìëå.', -1)
			wait(800)
			sampSendChat('/me çàêðåïèë(à) îáúåêò', -1)
			wait(800)
			sampSendChat("/break " ..id)	
		end) 
		end
	end
	
function cmd_mdbreak(id)
	if #id == 0 then
		lua_thread.create(function()
			sampSendChat('/me îòêðóòèë(à) áîëòû', -1)
			wait(800)
			sampSendChat('/do Îáúåêò îòêðåïëåí.', -1)
			wait(800)
			sampSendChat('/me âçÿë(à) îáúåêò ñ çåìëè è ïîäâèíóë(à) åãî', -1)
			wait(800)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/dbreak ")
			sampAddChatMessage('{ff1212}Ââåäèòå {FFFFFF}[ {FFFFFF}/mdbreak {ff1212}ID Îáúåêòà{FFFFFF} ]')
		end)
	else
		lua_thread.create(function()
			sampSendChat('/me îòêðóòèë(à) áîëòû', -1)
			wait(800)
			sampSendChat('/do Îáúåêò îòêðåïëåí.', -1)
			wait(800)
			sampSendChat('/me âçÿë(à) îáúåêò ñ çåìëè è ïîäâèíóë(à) åãî', -1)
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

-- TEST NEW VERSION
