script_name("MVD Helper Silver | LUA")
script_authors('Harley AHK')
script_description('MVD Helper LUA by Harley AHK')
script_moonloader('26')
script_version('1')

require("lib.moonloader") 
local inicfg = require ('inicfg')


local dialogArr = {"���������� ����� ��� �����", "���������� ���������", "{00FF1E}������ ����"}
local dialogStr = ""
local mvd = "{1E90FF}[���]{FFFFFF}" 

local enable_autoupdate = true  
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
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
	sampAddChatMessage(mvd.. " {FFFFFF}������������. �� ��������� Silver MVD Helper [by Harley].")
	sampAddChatMessage(mvd.. " {FFFFFF}������ �������:. ��������� �������������.")
	sampAddChatMessage(mvd.. " {FFFFFF}������ ��: AHK Harley | Radmir RP (@ahkradmirharley)")
	sampAddChatMessage(mvd.. " {FFFFFF}������������: {1E90FF}��������� ������ {FFFFFF}� {32CD32}���� ���������.")
	
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
			sampSendChat('/me ������ ���������� �������������', -1)
			wait(700)
			sampSendChat('/me ����� ������ ���������, ����� ���� ������� ��������� � ����� ��������������', -1)
			wait(700)
			sampSendChat('/do ������������� ������.', -1)
			wait(700)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/pg ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mpg {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me ������ ���������� �������������', -1)
			wait(700)
			sampSendChat('/me ����� ������ ���������, ����� ���� ������� ��������� � ����� ��������������', -1)
			wait(700)
			sampSendChat('/do ������������� ������.', -1)
			wait(700)
			sampSendChat("/pg "..id)
		end) 
		end
	end
	
function cmd_mhealme()
		 lua_thread.create(function()
			sampSendChat('/do ������� � �����', -1)
			wait(700)
			sampSendChat('/me ������(�) ������� � ���������(�) ����', -1)
			wait(700)
			sampSendChat('/me ������(�) �������', -1)
			wait(700)
			sampSendChat('/healme', -1)
		end) 
	end
	
function cmd_vzlom()
		 lua_thread.create(function()
			sampSendChat('/do ����� �������.', -1)
			wait(800)
			sampSendChat('/me ���� � ���� ���, ����� ���� ������� ��� � ���� ����� ������ � ������', -1)
			wait(800)
			sampSendChat('/me ������ ��������� ���� ����� �� ���', -1)
			wait(400)
			sampSendChat('/do ������...', -1)
			wait(1200)
			sampSendChat('/do ������ ����� � ������ �����.', -1)
			wait(800)
			sampSendChat('/me �������� ������ ������', -1)
			wait(500)
			sampSendChat('/do ����� ��������, ����� �������.', -1)
		end) 
	end
	
function cmd_alko()
		 lua_thread.create(function()
			sampSendChat('/me �����������, ��� ������� ��� ������������ ������������ ���������', -1)
			wait(800)
			sampSendChat('/do ���������� ����� � �������� �� �����.', -1)
			wait(800)
			sampSendChat('/me ������ ����������', -1)
			wait(400)
			sampSendChat('/do ���������� � ����.', -1)
			wait(1200)
			sampSendChat('/me ����� ������ ��������� �� �����������', -1)
			wait(800)
			sampSendChat('/do ���������� ������� � ��������.', -1)
			wait(800)
			sampSendChat('/todo ������� ���������� �� ��� ��������*������� � �������� �����������...', -1)
			wait(500)
			sampSendChat('/try �������� ���������� ������� �������� � ���������� ������� ��������', -1)
		end) 
	end
	
function cmd_rob1()
		 lua_thread.create(function()
			sampSendChat('/me ������ ���������� �������������', -1)
			wait(400)
			sampSendChat('/me ����� ������ ���������, ����� ���� ������� ��������� � ����� ��������������', -1)
			wait(800)
			sampSendChat('/do ���� ���������.', -1)
		end) 
	end
	
function cmd_rob2()
		 lua_thread.create(function()
			sampSendChat('/me ����� ���� � ������, ������(�) ���', -1)
			wait(400)
			sampSendChat('/do ��� � ����.', -1)
			wait(800)
			sampSendChat('/do ���� ���������.', -1)
			wait(400)
			sampSendChat('/me ����� �� ������ ������ ��������, ������(�) ���������� ���� ����������(-���)', -1)
			wait(800)
			sampSendChat('/me ����� ������ � ����� ��� � ������', -1)
			wait(800)
			sampSendChat('/do ��� � �������.', -1)
		end) 
	end
	
function cmd_msu(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ���', -1)
			wait(800)
			sampSendChat('/do ��� �������.', -1)
			wait(800)
			sampSendChat('/me �����(��) �������������� � ���� ������', -1)
			wait(800)
			sampSendChat('/me ������(�) ���', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/su ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/msu {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ���', -1)
			wait(800)
			sampSendChat('/do ��� �������.', -1)
			wait(800)
			sampSendChat('/me �����(��) �������������� � ���� ������', -1)
			wait(800)
			sampSendChat('/me ������(�) ���', -1)
			wait(500)
			sampSendChat("/su "..id)
		end) 
		end
	end
	
function cmd_mclear(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ���', -1)
			wait(800)
			sampSendChat('/do ��� �������.', -1)
			wait(800)
			sampSendChat('/me ������(�) �������������� �� ���� ������', -1)
			wait(800)
			sampSendChat('/me ������(�) ���', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/clear ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mclear {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ���', -1)
			wait(800)
			sampSendChat('/do ��� �������.', -1)
			wait(800)
			sampSendChat('/me ������(�) �������������� �� ���� ������', -1)
			wait(800)
			sampSendChat('/me ������(�) ���', -1)
			wait(500)
			sampSendChat("/clear "..id)
		end) 
		end
	end
	
function cmd_msearch(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ��������� �������� �� �����.', -1)
			wait(800)
			sampSendChat('/me ���������(�) ������� � ������ ���� ������ �������� ��������', -1)
			wait(800)
			sampSendChat('/me ������(�) ������ �� �������� � ������� ����� � ��������', -1)
			wait(800)
			sampSendChat('/me ����(�) ��������� �������� � �������(�) �� � ������', -1)
			wait(500)
			sampSendChat('/anim 6 1', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/search ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/msearch {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do ��������� �������� �� �����.', -1)
			wait(800)
			sampSendChat('/me ���������(�) ������� � ������ ���� ������ �������� ��������', -1)
			wait(800)
			sampSendChat('/me ������(�) ������ �� �������� � ������� ����� � ��������', -1)
			wait(800)
			sampSendChat('/me ����(�) ��������� �������� � �������(�) �� � ������', -1)
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
			sampSendChat('/me �����(�) ����� � ����������', -1)
			wait(800)
			sampSendChat('/me �������� ����������� �������� � ����������', -1)
			wait(800)
			sampSendChat('/do ����������� �������� �������.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/remove ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mremove {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me �����(�) ����� � ����������', -1)
			wait(800)
			sampSendChat('/me �������� ����������� �������� � ����������', -1)
			wait(800)
			sampSendChat('/do ����������� �������� �������.', -1)
			wait(500)
			sampSendChat("/remove "..id)
		end) 
		end
	end
	
function cmd_mcuff(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ��������� �� �����.', -1)
			wait(800)
			sampSendChat('/me ����(�) ��������� � �����', -1)
			wait(800)
			sampSendChat('/do ��������� � �����.', -1)
			wait(800)
			sampSendChat('/me �������(�) ��������, ����� �������(�) ����', -1)
			wait(800)
			sampSendChat('/me �������(�) �������� � ���������', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/cuff ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mcuff {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do ��������� �� �����.', -1)
			wait(800)
			sampSendChat('/me ����(�) ��������� � �����', -1)
			wait(800)
			sampSendChat('/do ��������� � �����.', -1)
			wait(800)
			sampSendChat('/me �������(�) ��������, ����� �������(�) ����', -1)
			wait(800)
			sampSendChat('/me �������(�) �������� � ���������', -1)
			wait(500)
			sampSendChat("/cuff "..id)
		end) 
		end
	end
	
function cmd_muncuff(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ��������� �� ��������.', -1)
			wait(800)
			sampSendChat('/me �������(�) ���� � ���������, ����� ���� ����(�) ��', -1)
			wait(800)
			sampSendChat('/do ��������� �����.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/uncuff ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/muncuff {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do ��������� �� ��������.', -1)
			wait(800)
			sampSendChat('/me �������(�) ���� � ���������, ����� ���� ����(�) ��', -1)
			wait(800)
			sampSendChat('/do ��������� �����.', -1)
			wait(500)
			sampSendChat("/uncuff "..id)
		end) 
		end
	end
	
function cmd_mescort(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ������� � ����������.', -1)
			wait(800)
			sampSendChat('/me �����(�) �������� �� �����', -1)
			wait(800)
			sampSendChat('/do ������� ���.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mescort {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do ������� � ����������.', -1)
			wait(800)
			sampSendChat('/me �����(�) �������� �� �����', -1)
			wait(800)
			sampSendChat('/do ������� ���.', -1)
			wait(500)
			sampSendChat("/escort "..id)
		end) 
		end
	end
	
function cmd_muescort(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/do ������� ��������.', -1)
			wait(800)
			sampSendChat('/me ��������(�) ���� ��������', -1)
			wait(800)
			sampSendChat('/do ������� ��������.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/escort ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/muescort {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/do ������� ��������.', -1)
			wait(800)
			sampSendChat('/me ��������(�) ���� ��������', -1)
			wait(800)
			sampSendChat('/do ������� ��������.', -1)
			wait(500)
			sampSendChat("/escort "..id)
		end) 
		end
	end
	
function cmd_mputpl(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ����� ������', -1)
			wait(800)
			sampSendChat('/me �������(�) ����������� � ������', -1)
			wait(800)
			sampSendChat('/me ������(�) �����', -1)
			wait(800)
			sampSendChat('/do ����� �������.', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/putpl ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mputpl {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ����� ������', -1)
			wait(800)
			sampSendChat('/me �������(�) ����������� � ������', -1)
			wait(800)
			sampSendChat('/me ������(�) �����', -1)
			wait(800)
			sampSendChat('/do ����� �������.', -1)
			wait(500)
			sampSendChat("/putpl "..id)
		end) 
		end
	end
	
function cmd_muputpl(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me ������(�) �����', -1)
			wait(800)
			sampSendChat('/me �������(�) �� ������ ��������', -1)
			wait(800)
			sampSendChat('/do ������� �� �����.', -1)
			wait(800)
			sampSendChat('/me ������(�) �����', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/eject ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/muputpl {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me ������(�) �����', -1)
			wait(800)
			sampSendChat('/me �������(�) �� ������ ��������', -1)
			wait(800)
			sampSendChat('/do ������� �� �����.', -1)
			wait(800)
			sampSendChat('/me ������(�) �����', -1)
			wait(500)
			sampSendChat("/eject "..id)
		end) 
		end
	end
	
function cmd_mejectout(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ����� ����� � ����', -1)
			wait(800)
			sampSendChat('/me �������(�) �� ������ ��������', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/ejectout ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mejectout {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me ������(�) ����� ����� � ����', -1)
			wait(800)
			sampSendChat('/me �������(�) �� ������ ��������', -1)
			wait(500)
			sampSendChat("/ejectout "..id)
		end) 
		end
	end
	
function cmd_marrest(id)
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me �������(�) �������� ���������', -1)
			wait(800)
			sampSendChat('/me ����(�) ������ � �����������', -1)
			wait(800)
			sampSendChat('/me �������(�) ������ � �����', -1)
			wait(800)
			sampSendChat('/me �������(�) ����������� � �������', -1)
			wait(500)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/arrest ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/marrest {ff1212}ID{FFFFFF} ]')
		end) 
	else
		 lua_thread.create(function()
			sampSendChat('/me �������(�) �������� ���������', -1)
			wait(800)
			sampSendChat('/me ����(�) ������ � �����������', -1)
			wait(800)
			sampSendChat('/me �������(�) ������ � �����', -1)
			wait(800)
			sampSendChat('/me �������(�) ����������� � �������', -1)
			wait(500)
			sampSendChat("/arrest "..id)
		end) 
		end
	end
	
function cmd_mdoc2()
		 lua_thread.create(function()
			sampSendChat('������ ����� ���������� ���� ���������, � ������:', -1)
			wait(1000)
			sampSendChat('�������, ���.����� � ��������� �� �/�.', -1)
			wait(1000)
			sampSendChat('/n /pass [id], /lic [ID] � /carpass [id]', -1)
			wait(1000)
			sampSendChat('� �����, ���������� ���������� ������ ������������.', -1)
			wait(1000)
			sampSendChat('/n /rem', -1)
		end) 
		end

	
function cmd_mdoc3()
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me ����(�) ��������� � �������� ��������', -1)
			wait(1000)
			sampSendChat('/do ��������� � ����.', -1)
			wait(1000)
			sampSendChat('/me ������(�) ��������� �� ������ ��������', -1)
			wait(1000)
			sampSendChat('/me ��������(�) ��������', -1)
			wait(1000)
			sampSendChat('/do �������� ���������.', -1)
			wait(1000)
			sampSendChat('/me ������(�) ���������', -1)
			wait(1000)
			sampSendChat('/do ��������� �������.', -1)
			wait(1000)
			sampSendChat('/me ������(�) ��������� �������� ��������', -1)
		end) 
		end
	end
	
function cmd_mdoc4()
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('������� �� �������������� ����������, ������ ���� ��������.', -1)
		end) 
		end
	end
	
function cmd_mat1()
	if #id == 0 then
		 lua_thread.create(function()
			sampSendChat('/me �������(�) �������� ��������� ���', -1)
			wait(800)
			sampSendChat('/do �������� ��������� ��� �������.', -1)
			wait(800)
			sampSendChat('/me �����(�) �� ������ � ������(�) ����������', -1)
			wait(800)
			sampSendChat('/do ���������� ��������� �� ���� ������ ���.', -1)
			wait(800)
			sampSendChat('/me �����(�) �� ������ ���������� ��������� ����������', -1)
			wait(800)
			sampSendChat('/do �������� ��������� ��������.', -1)
			wait(800)
			sampSendChat('/me ��������(�) ��������� �� ������', -1)
			wait(800)
			sampSendChat('/do ��������� ����� �� �������.', -1)
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
			sampSendChat('/do ��� � �������.', -1)
			wait(800)
			sampSendChat('/me ������(�) ��� � ������(�) ������ �������������', -1)
			wait(800)
			sampSendChat('/do �������...', -1)
			wait(800)
			sampSendChat('/wanted', -1)
		end) 
		end
	end
	
function cmd_mbreak(id)
	if #id == 0 then
		lua_thread.create(function()
			sampSendChat('/me ��������(�) ������ �� �����', -1)
			wait(800)
			sampSendChat('/do ������ �� �����.', -1)
			wait(800)
			sampSendChat('/me ��������(�) ������', -1)
			wait(800)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/break ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mbreak {ff1212}ID �������{FFFFFF} ]')
		end)
	else
		lua_thread.create(function()
			sampSendChat('/me ��������(�) ������ �� �����', -1)
			wait(800)
			sampSendChat('/do ������ �� �����.', -1)
			wait(800)
			sampSendChat('/me ��������(�) ������', -1)
			wait(800)
			sampSendChat("/break " ..id)	
		end) 
		end
	end
	
function cmd_mdbreak(id)
	if #id == 0 then
		lua_thread.create(function()
			sampSendChat('/me ��������(�) �����', -1)
			wait(800)
			sampSendChat('/do ������ ���������.', -1)
			wait(800)
			sampSendChat('/me ����(�) ������ � ����� � ��������(�) ���', -1)
			wait(800)
			sampSetChatInputEnabled(true)
			sampSetChatInputText("/dbreak ")
			sampAddChatMessage('{ff1212}������� {FFFFFF}[ {FFFFFF}/mdbreak {ff1212}ID �������{FFFFFF} ]')
		end)
	else
		lua_thread.create(function()
			sampSendChat('/me ��������(�) �����', -1)
			wait(800)
			sampSendChat('/do ������ ���������.', -1)
			wait(800)
			sampSendChat('/me ����(�) ������ � ����� � ��������(�) ���', -1)
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