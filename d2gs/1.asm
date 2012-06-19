;TODO:
; 1. Fix diablowall skill cpu usage bug
; 2. Tiny Warden enchance
; 3. Treasure Class�����Ż���������NoDrop��������
; 4. �˺���������Ż�
; 5. Uber������ٻ����ɱ����ʬ��Ӧ��������ʧ��
; 6. �������ߵ�Missile������D2COMMON_10945���и������㣬�Ż���

        .486
        .model flat, stdcall
        option casemap:none   ; case sensitive
; Code Start from 68021000h
.code
; Please DONT TOUCH the following code, their offsets are very important!!
MyPatchInitOffset dd offset MyPatchInit
MyPatchInitOffset2 dd offset MyPatchInit2
LoadMyConfigOffset dd offset LoadMyConfig
ShowSOJMessageCheckerOffset dd offset ShowSOJMessageChecker		; d2server.dll 68005AAB
DualAuraPatchOffset dd offset NewDualAuraPatch
MyInitGameHandlerOffset	dd offset MyInitGameHandler			;d2server.dll 68006539
MyPacket0X68HandlerOffset	dd offset MyPacket0X68Handler	;0x18
MyPacket0X66HandlerOffset	dd offset MyPacket0X66Handler	;0x1C
TradePlayerAuraBugPatchOffset dd offset TradePlayerAuraBugPatch
SingleRoomDCPatchOffset dd offset SingleRoomDCPatch
dummy6 dd 0
dummy7 dd 0
dummy8 dd 0
dummy9 dd 0

;LevelGame Callback��1.10��ӵ��15��������������1.11b�У�ӵ��20����������Ҫ������
;d2server.dll : 68007558
cb_leavegame proc
	mov eax,[esp+48h] ; esi+190
	mov [esp+34h],eax ; ��5���� ���esi+190
	pop eax ; retaddr
	mov [esp+34h],eax ; ��4���� ���retaddr
	call cb_leavegame_orig ; ����ԭ���Ļص�����
	ret 10h	 ; ע���������ض�ջ����
cb_leavegame endp

;�ͷŵ�ExtendGameInfoStruct
;d2server.dll : 6800109C
MyCleanupHandler proc
	pushad
	xor esi,esi
	xor ebx,ebx
next_game:
	push esi
	call GetGameInfo
	add esp,4
	test eax,eax
	jz next_game_increase
	mov	esi,eax
	mov eax,[esi+4]
	test eax,eax
	jz next_game_increase
	push eax
	mov eax,free
	mov eax,[eax]
	call eax
	add esp,4
	mov [esi+4],ebx
next_game_increase:
	inc esi
	cmp	si,402h
	jb short next_game
	popad
	
	call D2GSCleanup
	ret
MyCleanupHandler endp

; OK, you can add your stuff here...
cb_leavegame_orig dd 68007310h
cb_leavegame_entry dd 68013564h
D2GSPreInit		dd	680010C0h
D2GSInit			dd	680013F0h
D2GSCleanup		dd	68001760h
GetProcAddr		dd	6800B03Ch
D2COMMON			dd	68010F20h
D2GAME				dd	68010F1Ch
D2NET					dd	68010F24h
D2COMMON_10800_GetpPlayerDataFromUnit	dd 0
D2COMMON_11003_GetInvItemByBodyLoc	dd 0
D2COMMON_10743_GetRoom1	dd 0
D2COMMON_10604_GetUnitState	dd 0
GetGameInfo		dd	680064E8h
SendSystemMessage dd 68005B20h
D2Net_10018_SendPacket dd 0
malloc				dd	6800B190h
free					dd	6800B18Ch

GetModuleHandleA	dd 6800B028h
LoadLibraryA	dd 6800B018h
FreeLibrary	dd 0040C060h
CreateEventA	dd 0040C024h
SetEvent	dd 6800B010h
WaitForSingleObject	dd 0040C014h
CreateMutexA	dd 0040C044h
CloseHandle	dd 0040C07Ch
CreateThread	dd 0040C018h
GetExitCodeThread	dd 0040C02Ch
TerminateThread	dd 0040C04Ch
Sleep	dd 0040C01Ch
InitializeCriticalSection	dd 0040C040h
EnterCriticalSection	dd 0040C090h
LeaveCriticalSection	dd 0040C080h
DeleteCriticalSection	dd 0040C050h
VirtualProtect dd 6800B040h
GetRandomNumber	dd 680055A0h
sub_68005A10	dd 68005A10h
SOJ_Counter	dd 680145E8h
;D2Game_LeaveCriticalSection	dd 68014644h
D2Game_SysPacketHandling dd 68014618h

D2GS_EventLog_off dd 6800D7D0h
aMyLogo db 'Version 1.11b patch build 43 by marsgod. 2009-03-01',0
aD2Server db 'D2Server1.11b',0
aSpawnProbability db 'SpawnProbability',0
aMaxSpawnNum db 'MaxSpawnNum',0
aSpawnInterv db 'SpawnInterval',0
aActivArea db 'ActivArea',0
aStallTime db 'StallTime',0
aSpawnMonsters db 'SpawnMonsters',0
aSplit db ', ',0

aUberMephisto db 'UberMephisto',0
aUberDiablo db 'UberDiablo',0

aWorldEvent db 'World Event',0
aDcItemRate db 'DcItemRate',0
aShowSOJMessage db 'ShowSOJMessage',0
aShowSOJMessageDisabledMsg db 'SOJ Message Disabled.',0

ShowSOJMessage dd 0
DcItemRate dd 0

aEnableWarden db 'EnableWarden',0
aWardenEnableMsg db 'Warden Enabled.',0
EnableWarden dd 0

;Other configuration
aNewFeatures db 'NewFeatures',0

aEnableMeleeHireableAI db 'EnableMeleeHireableAI',0
aMeleeHireableAIEnableMsg db 'Act2 & Act5 MeleeHireableAIFix Enabled, when IM, no attack.',0
EnableMeleeHireableAI dd 0
aEnableNeroPetAI db 'EnableNeroPetAI',0
aNeroPetAIEnableMsg db 'NeroPetAIFix Enabled, when IM, no attack.',0
EnableNeroPetAI dd 0
aEnableExpGlitchFix db 'EnableExpGlitchFix',0
aExpGlitchFixEnableMsg db 'ExpGlitchFix Enabled.',0
EnableExpGlitchFix dd 0
aDisableUberUp db 'DisableUberUp',0
aUberUpDisableMsg db 'UberUp Disabled.',0
DisableUberUp dd 0

aEnableUnicodeCharName db 'EnableUnicodeCharName',0
aEnableUnicodeCharNameMsg db 'Unicode Char Name Enabled.',0
EnableUnicodeCharName dd 0

aEnablePreCalculateTCNoDropTbl db 'EnablePreCalculateTCNoDropTbl',0
aEnablePreCalculateTCNoDropTblMsg db 'PreCalculate TC NoDropTbl Enabled.',0
EnablePreCalculateTCNoDropTbl dd 0

D2GSStrCat dd 68007DF0h
GetConfigString dd 68007DA0h
EnableDebugDumpThread dd 68013554h
_strtoul dd 6800B188h
sub_68004870 dd 68004870h
LoadWorldEventConfigFileOffset dd 68007D94h
D2GamePatched dd 0
aD2GamePatchedMsg db 'D2Game already patched.',0

cb_func00 dd 6800D9B8h ; d2game.dll 6FC903B6
cb_func01 dd 6800D9BCh ; d2game.dll 6FD0832F
cb_func02 dd 6800F9A4h ; d2game.dll 6FC4557F
cb_func03 dd 6800F9A8h ; d2game.dll 6FD0818C
cb_func04 dd 6800F9ACh ; d2game.dll 6FD0744A
cb_func05 dd 6800F980h ; d2game.dll 6FCB2859
cb_func06 dd 6800F984h ; d2game.dll 6FD0CF10
cb_save_func00	dd 0
cb_save_func01	dd 0
cb_save_func02	dd 0
cb_save_func03	dd 0
cb_save_func04	dd 0
cb_save_func05	dd 0
cb_save_func06	dd 0


dword_func00 	dd 6801467Ch	;d2client.dll	6FB7D5C1
dword_func01 	dd 68014658h	;d2game.dll		6FC903B6
dword_func02 	dd 68014618h	;d2game.dll		6FD0832F
dword_func03 	dd 68014638h	;d2game.dll		6FD04A30
dword_func04 	dd 68014610h	;d2game.dll		6FCE4C40
dword_func05 	dd 68014644h	;d2game.dll		6FD03AD0
dword_func06 	dd 68014604h	;d2game.dll		6FC3C710
dword_func07 	dd 6801460Ch	;d2game.dll		6FCBC2E0
dword_func08 	dd 68014668h	;d2game.dll		6FCBD820
dword_func09 	dd 68014640h	;d2game.dll		6FCBBB00
dword_func10 	dd 68014650h	;d2game.dll		6FC4557F
dword_func11 	dd 68014678h	;d2game.dll		6FD0818C
dword_func12 	dd 6801462Ch	;d2game.dll		6FD0744A
dword_func13 	dd 6801463Ch	;d2game.dll		6FC8A500
dword_func14 	dd 68014654h	;d2game.dll		6FC31E20
dword_func15 	dd 6801465Ch	;d2game.dll		6FC3B0E0
dword_func16 	dd 68014684h	;d2game.dll		6FC35840
dword_func17 	dd 68014670h	;d2game.dll		6FD049A0
dword_func18 	dd 6801468Ch	;d2game.dll		6FC51070
dword_func19 	dd 6801461Ch	;d2game.dll		6FCB2858
dword_func20 	dd 68014660h	;d2game.dll		6FD0CF10

dword_save_func00	dd 0	;d2client.dll	6FB7D5C1
dword_save_func01	dd 0	;d2game.dll		6FC903B6
dword_save_func02	dd 0	;d2game.dll		6FD0832F
dword_save_func03	dd 0	;d2game.dll		6FD04A30
dword_save_func04	dd 0	;d2game.dll		6FCE4C40
dword_save_func05	dd 0	;d2game.dll		6FD03AD0
dword_save_func06	dd 0	;d2game.dll		6FC3C710
dword_save_func07	dd 0	;d2game.dll		6FCBC2E0	; nocall 0
dword_save_func08	dd 0	;d2game.dll		6FCBD820
dword_save_func09	dd 0	;d2game.dll		6FCBBB00
dword_save_func10	dd 0	;d2game.dll		6FC4557F
dword_save_func11	dd 0	;d2game.dll		6FD0818C
dword_save_func12	dd 0	;d2game.dll		6FD0744A
dword_save_func13	dd 0	;d2game.dll		6FC8A500
dword_save_func14	dd 0	;d2game.dll		6FC31E20
dword_save_func15	dd 0	;d2game.dll		6FC3B0E0
dword_save_func16	dd 0	;d2game.dll		6FC35840
dword_save_func17	dd 0	;d2game.dll		6FD049A0
dword_save_func18	dd 0	;d2game.dll		6FC51070
dword_save_func19	dd 0	;d2game.dll		6FCB2858
dword_save_func20	dd 0	;d2game.dll		6FD0CF10

dword_fog_patch00	dd 6800DCC4h; patch length to 6
dword_fog_patch01	dd 6800DCC8h; patch offset
dword_fog_patch02 db 59h, 58h, 51h, 33h, 0C0h, 0C3h ; patch code

ExtendGameInfoStruct struc
	rand_l dd ?
	rand_h dd ?
	PortalOpenedFlag dd ?
	BOSS_A_AREA	dd ?
	BOSS_B_AREA	dd ?
	BOSS_C_AREA	dd ?
	BOSS_D0_AREA	dd ?
	BOSS_D1_AREA	dd ?
	BOSS_D2_AREA	dd ?
	Diablo_rand_l	dd ?
	Diablo_rand_h	dd ?
	Meph_rand_l	dd ?
	Meph_rand_h	dd ?
	LoD_Game	dd ?
ExtendGameInfoStruct ends

start:

MyPatchInit proc

	xor eax,eax
	mov D2GamePatched,eax		; ��ʼ��D2GamePatchedΪFalse����ֹ��ζ�D2Game���в���

	; Announce my version first
	pushad
	push    offset aMyLogo
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8
	popad


	push ecx
	
	; Patch the Fog.dll 6FF65CD0h , this should be done before D2GSPreInit!
	; pop ecx  ; return address
	; pop eax  ; arg_0
	; push ecx
	; xor eax,eax
	; ret
	
	mov eax,dword_fog_patch00
	mov ecx,6
	mov [eax],ecx
	mov eax,dword_fog_patch01
	mov ecx,offset dword_fog_patch02
	mov [eax],ecx
	
; setup D2GAME CallBack Hook before D2GSPreInit!
	mov ecx, cb_func00
	mov eax,[ecx]
	mov cb_save_func00,eax
	mov eax,offset cb_stub_func00
	mov [ecx],eax
	
	mov ecx, cb_func01
	mov eax,[ecx]
	mov cb_save_func01,eax
	mov eax,offset cb_stub_func01
	mov [ecx],eax
	
	mov ecx, cb_func02
	mov eax,[ecx]
	mov cb_save_func02,eax
	mov eax,offset cb_stub_func02
	mov [ecx],eax
	
	mov ecx, cb_func03
	mov eax,[ecx]
	mov cb_save_func03,eax
	mov eax,offset cb_stub_func03
	mov [ecx],eax
	
	mov ecx, cb_func04
	mov eax,[ecx]
	mov cb_save_func04,eax
	mov eax,offset cb_stub_func04
	mov [ecx],eax
	
	mov ecx, cb_func05
	mov eax,[ecx]
	mov cb_save_func05,eax
	mov eax,offset cb_stub_func05
	mov [ecx],eax
	
	mov ecx, cb_func06
	mov eax,[ecx]
	mov cb_save_func06,eax
	mov eax,offset cb_stub_func06
	mov [ecx],eax


	; OK, let's init the d2server
	mov eax,68010EF0h
	mov [eax],esi
	call D2GSPreInit
	push eax
	
	push 10800
	mov eax,D2COMMON
	mov eax,[eax]
	push eax
	mov eax,6800B03Ch
	mov eax,[eax]
	call eax; GetProcAddr
	mov D2COMMON_10800_GetpPlayerDataFromUnit,eax

	push 11003
	mov eax,D2COMMON
	mov eax,[eax]
	push eax
	mov eax,6800B03Ch
	mov eax,[eax]
	call eax; GetProcAddr
	mov D2COMMON_11003_GetInvItemByBodyLoc,eax

	push 10604
	mov eax,D2COMMON
	mov eax,[eax]
	push eax
	mov eax,6800B03Ch
	mov eax,[eax]
	call eax; GetProcAddr
	mov D2COMMON_10604_GetUnitState,eax

	push 10743
	mov eax,D2COMMON
	mov eax,[eax]
	push eax
	mov eax,6800B03Ch
	mov eax,[eax]
	call eax; GetProcAddr
	mov D2COMMON_10743_GetRoom1,eax

; Call D2Game
;	mov ecx, dword_func00
; mov eax,[ecx]
;	mov dword_save_func00,eax
; mov eax,offset stub_func00
;	mov [ecx],eax

	mov ecx, dword_func01
	mov eax,[ecx]
	mov dword_save_func01,eax
	mov eax,offset stub_func01
	mov [ecx],eax

	mov ecx, dword_func02
	mov eax,[ecx]
	mov dword_save_func02,eax
	mov eax,offset stub_func02
	mov [ecx],eax

	mov ecx, dword_func03
	mov eax,[ecx]
	mov dword_save_func03,eax
	mov eax,offset stub_func03
	mov [ecx],eax

	mov ecx, dword_func04
	mov eax,[ecx]
	mov dword_save_func04,eax
	mov eax,offset stub_func04
	mov [ecx],eax

	mov ecx, dword_func05
	mov eax,[ecx]
	mov dword_save_func05,eax
	mov eax,offset stub_func05
	mov [ecx],eax

	mov ecx, dword_func06
	mov eax,[ecx]
	mov dword_save_func06,eax
	mov eax,offset stub_func06
	mov [ecx],eax

	mov ecx, dword_func07
	mov eax,[ecx]
	mov dword_save_func07,eax
	mov eax,offset stub_func07
	mov [ecx],eax

	mov ecx, dword_func08
	mov eax,[ecx]
	mov dword_save_func08,eax
	mov eax,offset stub_func08
	mov [ecx],eax

	mov ecx, dword_func09
	mov eax,[ecx]
	mov dword_save_func09,eax
	mov eax,offset stub_func09
	mov [ecx],eax

	mov ecx, dword_func10
	mov eax,[ecx]
	mov dword_save_func10,eax
	mov eax,offset stub_func10
	mov [ecx],eax

	mov ecx, dword_func11
	mov eax,[ecx]
	mov dword_save_func11,eax
	mov eax,offset stub_func11
	mov [ecx],eax

	mov ecx, dword_func12
	mov eax,[ecx]
	mov dword_save_func12,eax
	mov eax,offset stub_func12
	mov [ecx],eax

	mov ecx, dword_func13
	mov eax,[ecx]
	mov dword_save_func13,eax
	mov eax,offset stub_func13
	mov [ecx],eax

	mov ecx, dword_func14
	mov eax,[ecx]
	mov dword_save_func14,eax
	mov eax,offset stub_func14
	mov [ecx],eax

	mov ecx, dword_func15
	mov eax,[ecx]
	mov dword_save_func15,eax
	mov eax,offset stub_func15
	mov [ecx],eax

	mov ecx, dword_func16
	mov eax,[ecx]
	mov dword_save_func16,eax
	mov eax,offset stub_func16
	mov [ecx],eax

	mov ecx, dword_func17
	mov eax,[ecx]
	mov dword_save_func17,eax
	mov eax,offset stub_func17
	mov [ecx],eax

	mov ecx, dword_func18
	mov eax,[ecx]
	mov dword_save_func18,eax
	mov eax,offset stub_func18
	mov [ecx],eax

	mov ecx, dword_func19
	mov eax,[ecx]
	mov dword_save_func19,eax
	mov eax,offset stub_func19
	mov [ecx],eax

	mov ecx, dword_func20
	mov eax,[ecx]
	mov dword_save_func20,eax
	mov eax,offset stub_func20
	mov [ecx],eax
	
	; for warden patch 0x68,0x66 packet handler
;	mov ecx,68003815h	; system packet handler
;	mov eax,offset MyPacket0X68Handler
	mov ecx,6800F31Ch	; packet 0x68 handler 68003AC0
	mov eax,offset MyPacket0X68Handler
	mov [ecx],eax

	call UberQuestPatchInit

	pop eax
	pop ecx
	ret
MyPatchInit endp

; After D2GS init, patch it
MyPatchInit2 proc
	call D2GSInit
	test eax,eax
	jnz	continue
	pop eax
	xor eax,eax
	push 68001054h
	ret
continue:
	call Patch_sgptDataTables

over:	
	pop eax
	push 6800106Dh
	ret
MyPatchInit2 endp


D2GamePatch proc
	pushad
	mov esi,D2GAME
	mov esi,[esi]
	push esi
	push 0
	call UnProtectDLL2
	
	; for warden patch 0x68,0x66 packet handler
	mov ecx,esi
	add ecx,0FAAF0h		; packet 0x66 handler
	mov eax,offset MyPacket0X66Handler
	mov [ecx],eax
	
;Town TP corpse crash bug patch
;Creating a town portal when corpses or other objects entirely fill the area where the portal will appear in town will no longer crash the game. 
;68022800
;D2Game.dll	0X10AD9	DD9EFFFF	231D3FF8	0 #6FC30AD9 = Patch Call Offset(x-6FC30ADD)
	mov ecx,esi
	add ecx,10AD9h
	mov eax,offset TPCrashBugPatch
	sub eax,ecx
	sub eax,4
	mov [ecx],eax

;Dual Aura Bug Patch(This include the PET & Player)
;When the item remove from pet or player, the aura event is not removed from the unit.
;D2Game.dll	0X7604C	6A098BC7E80BAEFFFF	FF1510100268909090	0 #6FC9604C(7604C) remove the aura event from unit
	mov ecx,esi
	add ecx,7604Ch
	mov eax,101015FFh
	mov [ecx],eax
	add ecx,4
	mov eax,90906802h
	mov [ecx],eax
	add ecx,4
	mov eax,245C8B90h
	mov [ecx],eax

;Missile_DO_diabwallmaker Patch
;D2Game.dll	0X104B80	60F9CB6F	F0DFCB6F	3 #6FD24B80(11C4B80) replace Missile_DO_diabwallmaker with Missile_DO_01
	mov ecx,esi
	add ecx,104B80h
	mov eax,9DFF0h
	add eax,esi
	mov [ecx],eax

;Carry1 Trade Patch(for USC\ULC\UGC trade), skip the carry1 check in trade
;D2Game.dll	0X36D85	740A	EB0A	0 #6FC56D85(10F6D85)
	mov ecx,esi
	add ecx,36D84h
	mov eax,0C70AEBC0h
	mov [ecx],eax


	mov eax,EnableExpGlitchFix
	test eax,eax
	jz no_EnableExpGlitchFix
;ExpGlitchFix
;D2Game.dll	0X7E021	E9 ExpGlitchFix	0 #6FC9E021
	pushad
	
	mov eax,offset ExpGlitchFixEnd
	mov ebx,offset ExpGlitchFix
	sub eax,ebx
	; eax has the size of proc ExpGlitchFix
	mov edi,eax
	
	;7E0AC
	mov ecx,esi
	add ecx,7E0ADh
	sub ecx,eax
	
	;ecx has the start address of ExpGlitchFix
	mov ebx,ecx	; save start address
	
	; patch first jnz at 6FC9E021
	mov eax,esi
	add eax,7E021h
	sub ecx,eax
	dec ecx
	mov byte ptr[eax],cl
	
	; patch last jl at 6FC9E0CA
	mov eax,esi
	add eax,7E0CAh
	mov byte ptr[eax],0D0h

;transfer ExpGlitchFix to target
	mov ecx,edi
	mov esi,offset ExpGlitchFix
	mov edi,ebx
	rep movsb
	popad

no_EnableExpGlitchFix:

	mov eax,EnableMeleeHireableAI
	test eax,eax
	jz no_EnableMeleeHireableAI
;D2Game.dll	0X67F99	MeleePetAIFix	0 #6FC87F99
	mov ecx,esi
	add ecx,67F99h
	mov byte ptr[ecx],0E8h
	inc ecx
	mov eax,offset MeleePetAIFix
	sub eax,ecx
	sub eax,4
	mov [ecx],eax

no_EnableMeleeHireableAI:

	mov eax,EnableNeroPetAI
	test eax,eax
	jz no_EnableNeroPetAI
;D2Game.dll	0X6E98C	NeroPetAIFix	0 #6FC8E98C
	mov ecx,esi
	add ecx,6E98Ch
	mov byte ptr[ecx],0E8h
	inc ecx
	mov eax,offset NeroPetAIFix
	sub eax,ecx
	sub eax,4
	mov [ecx],eax
	
no_EnableNeroPetAI:

	mov eax,EnableUnicodeCharName
	test eax,eax
	jz no_EnableUnicodeCharName
;D2Game.dll	0XE47B5	UnicodeCharNameCheck	0 #6FD047B5
	mov ecx,esi
	add ecx,0E47B5h
	mov eax,offset UnicodeCharNameCheck
	sub eax,ecx
	sub eax,4
	mov [ecx],eax

	pushad
	mov esi,D2COMMON
	mov esi,[esi]
	push esi
	push 0
	call UnProtectDLL
	
	mov ecx,esi
	add ecx,76B27h
	mov eax,8306B60Fh;  0FB60683
	mov [ecx],eax
	add ecx,4
	mov eax,90907FE0h;  E07F9090
	mov [ecx],eax
	add ecx,4
	mov eax,83909090h;  90909083
	mov [ecx],eax
	
	mov ecx,esi
	add ecx,74744h
	mov eax,8306B60Fh;  0FB60683
	mov [ecx],eax
	add ecx,4
	mov eax,90907FE0h;  E07F9090
	mov [ecx],eax
	add ecx,4
	mov eax,83909090h;  90909083
	mov [ecx],eax
	
	push esi
	push 0
	call ProtectDLL
	
	popad
no_EnableUnicodeCharName:
	mov eax,EnablePreCalculateTCNoDropTbl
	test eax,eax
	jz no_EnablePreCalculateTCNoDropTbl
	pushad
	call PreCalculateTreasureClassNoDropTbl
	test eax,eax
	mov PreCalculateTCNoDropTbl,eax
	popad
	jz no_EnablePreCalculateTCNoDropTbl
	mov EnablePreCalculateTCNoDropTbl,eax

;D2Game.dll	0XD20F4	CalculateTreasureClassNoDropPatch	0 #6FCF20F4
	mov ecx,esi
	add ecx,0D20F4h
	mov byte ptr[ecx],0E8h
	inc ecx
	mov eax,offset CalculateTreasureClassNoDropPatch
	sub eax,ecx
	sub eax,4
	mov [ecx],eax
	mov eax,03909090h
	add ecx,4
	mov [ecx],eax


no_EnablePreCalculateTCNoDropTbl:
; Monster Damage Fix
; D2Game.dll 6FCB4750
;MonsterDamageFix
	mov ecx,esi
	add ecx,94750h
	mov byte ptr[ecx],0E8h
	inc ecx
	mov eax,offset MonsterDamageFix
	sub eax,ecx
	sub eax,4
	mov [ecx],eax
	add ecx,4
	mov byte ptr[ecx],90h


;Uber Quest Patchs

;openPandPortal=68021BD0
;D2Game.dll	0XFA7B8	2049C56F	D01B0268 1 #6FD1A7B8(11BA7B8)
	mov ecx,esi
	add ecx,0FA7B8h
	mov eax,offset openPandPortal
	mov [ecx],eax

;openPandFinalPortal=68021C78
;D2Game.dll	0XFA7BC	1049C56F	781C0268 1 #6FD1A7BC(11BA7BC)
	mov ecx,esi
	add ecx,0FA7BCh
	mov eax,offset openPandFinalPortal
	mov [ecx],eax

;SpawnUberBossOff=68021CF0 ; Hook
;D2Game.dll	0XE6B52 6ACAF3FF	F01C0268 20  #6FD06B52(11A6B52) = Patch Call Offset
	mov ecx,esi
	add ecx,0E6B52h
	mov eax,offset SpawnUberBoss
	sub eax,ecx
	sub eax,4
	mov [ecx],eax

;#####################################################################################################
;#Marsgod's AI table !! Use Ball\Mephisto\Diablo AI
;#####################################################################################################
;UberBaal AI
;D2Game.dll	0X10F5E8	00A3C46F	80BCC46F 3 #6FD2F5E8(11CF5E8) nullsub->UberBaal_AI(6FC4BC80)
	mov ecx,esi
	add ecx,10F5E8h
	mov eax,2BC80h
	add eax,esi
	mov [ecx],eax

;UberMephisto AI
;D2Game.dll	0X10F5F8	702DCF6F	8F200268 1 #6FD2F5F8 nullsub->UberMephisto_AI(6802208F)
;D2Game.dll	0X10F5F4	00000000	5C200268 0 #6FD2F5F4 0->UberMephisto_AI0(6802205C)
	mov ecx,esi
	add ecx,10F5F8h
	mov eax,offset UberMephisto_AI
	mov [ecx],eax
	mov ecx,esi
	add ecx,10F5F4h
	mov eax,offset UberMephisto_AI0
	mov [ecx],eax

;UberDiablo AI
;D2Game.dll	0X10F608	60FEC96F	DC200268 1 #6FD2F608 nullsub->UberDiablo_AI(680220DC)
;D2Game.dll	0X10F604	00000000	29200268 0 #6FD2F604 0->UberDiablo_AI0(68022029)
	mov ecx,esi
	add ecx,10F608h
	mov eax,offset UberDiablo_AI
	mov [ecx],eax
	mov ecx,esi
	add ecx,10F604h
	mov eax,offset UberDiablo_AI0
	mov [ecx],eax

	push esi
	push 0
	call ProtectDLL2
	
	mov eax,1
	mov D2GamePatched,eax		; ���ñ�־����ֹ�ٴ�Patch
	popad
	ret
D2GamePatch endp

myEBX dd 0

LoadMyConfig proc
	mov ecx,EnableDebugDumpThread
	mov	[ecx],eax
	mov myEBX,ebx

	push esi
	mov esi,offset aNewFeatures
	push offset aEnableMeleeHireableAI
	push esi
	call    D2GSStrCat
	add esp,8
	mov EnableMeleeHireableAI,eax
	test eax,eax
	jz cont_101
	push    offset aMeleeHireableAIEnableMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8

cont_101:
	push offset aEnableNeroPetAI
	push esi
	call    D2GSStrCat
	add esp,8
	mov EnableNeroPetAI,eax
	test eax,eax
	jz cont_102
	push    offset aNeroPetAIEnableMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8
	
cont_102:
	push offset aEnableExpGlitchFix
	push esi
	call    D2GSStrCat
	add esp,8
	mov EnableExpGlitchFix,eax
	test eax,eax
	jz cont_103
	push    offset aExpGlitchFixEnableMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8
	
cont_103:
	push offset aDisableUberUp
	push esi
	call    D2GSStrCat
	add esp,8
	mov DisableUberUp,eax
	test eax,eax
	jz cont_104
	push    offset aUberUpDisableMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8
	
cont_104:

	push offset aEnableUnicodeCharName
	push esi
	call    D2GSStrCat
	add esp,8
	mov EnableUnicodeCharName,eax
	test eax,eax
	jz cont_1044
	push    offset aEnableUnicodeCharNameMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8

cont_1044:

	push offset aEnablePreCalculateTCNoDropTbl
	push esi
	call    D2GSStrCat
	add esp,8
	mov EnablePreCalculateTCNoDropTbl,eax
	test eax,eax
	jz cont_105
	push    offset aEnablePreCalculateTCNoDropTblMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8

cont_105:
	mov esi,offset aWorldEvent
	push offset aShowSOJMessage
	push esi
	call    D2GSStrCat
	add esp,8
	mov ShowSOJMessage,eax
	test eax,eax
	jnz cont_1055
	push    offset aShowSOJMessageDisabledMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8
	

cont_1055:
	mov esi,offset aWorldEvent
	push offset aDcItemRate
	push esi
	call    D2GSStrCat
	add esp,8
	cmp	eax,1000
	jle	eax_0
	mov	eax,1000
	jmp	eax_ok
eax_0:
	cmp	eax,0
	jge	eax_ok
	mov	eax,0
eax_ok:
	mov DcItemRate,eax

cont_106:

	mov esi,offset aNewFeatures
	push offset aEnableWarden
	push esi
	call    D2GSStrCat
	add esp,8
	mov EnableWarden,eax
	test eax,eax
	jz cont1
	push    offset aWardenEnableMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8
	
	; ����Warden�߳�
	call InitWardenThread
cont1:
	mov esi,offset aUberMephisto

	push offset aSpawnProbability
	push esi
	call    D2GSStrCat
	add esp,8
	cmp eax,100
	jle ok_M0
	mov eax,100
ok_M0:
	mov SpawnProbability_M,eax

	push offset aMaxSpawnNum
	push esi
	call    D2GSStrCat
	add esp,8
	mov MaxSpawnNum_M,eax
	
	push offset aSpawnInterv
	push esi
	call    D2GSStrCat
	add esp,8
	mov SpawnInterv_M,eax

	push offset aActivArea
	push esi
	call    D2GSStrCat
	add esp,8
	mov ActivArea_M,eax

	push offset aStallTime
	push esi
	call    D2GSStrCat
	add esp,8
	mov StallTime_M,eax

	; Read the SpawnMonsters from config file
	lea edx,[esp+10h] ; CHECK, CHECK, CHECK!!!
	push 400h ; nSize
	push edx ; lpReturnedString
	push offset aSpawnMonsters
	push esi ; UberMephisto
	call GetConfigString
	
	test eax,eax
	jz over_M1
	jmp haha1
over_M1:
	add esp,10h
	jmp over_M
haha1:
	
	xor esi,esi
	lea ecx,[esp+18h] ; CHECK, CHECK, CHECK!!!
	lea edx,[esp+20h] ; CHECK, CHECK, CHECK!!!
	push ecx
	push offset aSplit ; ", "
	push edx
	call sub_68004870 ; split the string with ","
	mov ebx,eax
	add esp,1Ch ; CHECK, CHECK, CHECK!!!
	cmp ebx,esi
	jz noSpawnMonsters_M
	
	mov eax,[esp+08h]
	mov [esp+0Ch],esi
	cmp eax,esi
	jle noSpawnMonsters_M
	cmp eax,10
	jle	continue_M
	mov eax,10
	mov [esp+08h],eax
continue_M:
	
	push edi
	push ebp
	mov edi,ds:_strtoul
	mov edi,[edi]
	mov esi,ebx
	
	xor ebp,ebp
again_UberMephisto:
	mov eax,[esi] ; eax=���ִ���ƫ��
	push 10 ; ʮ����
	push 0
	push eax
	call edi ; strtoul
	add esp,0Ch
	cmp eax,733
	jle ok_M
	xor eax,eax
ok_M:
	mov SpawnMonsters_M[ebp*4],eax
	
	mov eax,[esp+14h]
	mov ecx,[esp+10h]
	inc eax
	inc ebp
	add esi,4
	cmp eax,ecx
	mov [esp+14h],eax
	jl again_UberMephisto
	mov TypeOfSpawns_M,eax
	xor esi,esi
	pop ebp
	pop edi
	
noSpawnMonsters_M:
	push ebx
	mov eax,free
	mov eax,[eax]
	call eax
	add esp,4

over_M:	
		
	mov esi,offset aUberDiablo

	push offset aSpawnProbability
	push esi
	call    D2GSStrCat
	add esp,8
	cmp eax,100
	jle ok_D0
	mov eax,100
ok_D0:
	mov SpawnProbability_D,eax

	push offset aMaxSpawnNum
	push esi
	call    D2GSStrCat
	add esp,8
	mov MaxSpawnNum_D,eax
	
	push offset aSpawnInterv
	push esi
	call    D2GSStrCat
	add esp,8
	mov SpawnInterv_D,eax

	push offset aActivArea
	push esi
	call    D2GSStrCat
	add esp,8
	mov ActivArea_D,eax

	push offset aStallTime
	push esi
	call    D2GSStrCat
	add esp,8
	mov StallTime_D,eax

	; Read the SpawnMonsters from config file
	lea edx,[esp+10h] ; CHECK, CHECK, CHECK!!!
	push 400h ; nSize
	push edx ; lpReturnedString
	push offset aSpawnMonsters
	push esi ; UberDiablo
	call GetConfigString
	test eax,eax
	jz over_D1
	jmp haha2
over_D1:
	add esp,10h
	jmp over_D
haha2:
	
	xor esi,esi
	lea ecx,[esp+18h] ; CHECK, CHECK, CHECK!!!
	lea edx,[esp+20h] ; CHECK, CHECK, CHECK!!!
	push ecx
	push offset aSplit ; ", "
	push edx
	call sub_68004870 ; split the string with ","
	mov ebx,eax
	add esp,1Ch ; CHECK, CHECK, CHECK!!!
	cmp ebx,esi
	jz noSpawnMonsters_D
	
	mov eax,[esp+08h]
	mov [esp+0Ch],esi
	cmp eax,esi
	jle noSpawnMonsters_D
	cmp eax,10
	jle	continue_D
	mov eax,10
	mov [esp+08h],eax
continue_D:
	
	push edi
	push ebp
	mov edi,ds:_strtoul
	mov edi,[edi]
	mov esi,ebx
	
	xor ebp,ebp
again_UberDiablo:
	mov eax,[esi] ; eax=���ִ���ƫ��
	push 10 ; ʮ����
	push 0
	push eax
	call edi ; strtoul
	add esp,0Ch
	cmp eax,733
	jle ok_D
	xor eax,eax
ok_D:
	mov SpawnMonsters_D[ebp*4],eax
	
	mov eax,[esp+14h]
	mov ecx,[esp+10h]
	inc eax
	inc ebp
	add esi,4
	cmp eax,ecx
	mov [esp+14h],eax
	jl again_UberDiablo
	mov TypeOfSpawns_M,eax
	xor esi,esi
	pop ebp
	pop edi
	
noSpawnMonsters_D:
	push ebx
	mov eax,free
	mov eax,[eax]
	call eax
	add esp,4
	
over_D:
	mov	eax,D2GamePatched
	test	eax,eax
	jz	Not_Patched
	push    offset aD2GamePatchedMsg
	push    offset aD2Server
	mov eax,D2GS_EventLog_off
	mov eax,[eax]
	call    eax
	add     esp, 8
	jmp Patched_Over
Not_Patched:
	call D2GamePatch
Patched_Over:
	mov ebx,myEBX
	pop esi
	mov eax,1
	jmp LoadWorldEventConfigFileOffset
LoadMyConfig endp

ShowSOJMessageChecker proc
	push ebx
	mov ebx,ShowSOJMessage
	test ebx,ebx
	pop ebx
	jz ShowSOJMessageChecker_over
	push eax
	push 4
	push 11h
	push esi
	call SendSystemMessage
	add     esp, 10h
ShowSOJMessageChecker_over:
	ret
ShowSOJMessageChecker endp

;retaddr	dd 0
;tmp			dd 0
;tmp1		dd 0
;tmp2		dd 0
;tmp3		dd 0
;tmp4		dd 0
;tmp5		dd 0

;d2client.dll	6FAA8941 4 6FBA7828(void) 6FB7D5C1 4 6FBD3320(void)
stub_func00 proc
	call dword_save_func00
	ret
stub_func00 endp

;6FC31C74 4 000576A8(ecx,edx,arg_0,arg_4)			6FC903B6 4 FFFBD3F6 4(arg_0,esi,ebx,arg_4)(void)
;��ջ����
;���Ըı�EAX��ECX��EDX���������ܱ�
;MessageHandler
; eax����ֵ����
;
;
;          ecx
;          arg_4
;ret       esi
;arg_0     ebx
;arg_4     ret
stub_func01 proc
	; stack fix...
	mov [esp-8],ecx
	mov eax,[esp+8] ; arg_4
	mov [esp-4],eax
	mov eax,[esp] ; retaddr
	mov [esp+8],eax
	mov [esp],esi ; save esi
	mov eax,[esp+4] ; arg_0
	mov [esp+4],ebx	; save ebx
	mov ebx,eax ; arg_0
	mov esi,edx
	sub esp,8
	
	call dword_save_func01
	pop esi
	pop ebx
	ret
stub_func01 endp

;6FC38551 4 FFFF93BB(ecx,edx)			6FD0832F 4 FFF8809D(arg_0,eax) packet handler!!(void)
;��ջ����
;���Ըı�EAX��ECX��EDX���������ܱ�
	; for warden patch 0x68,0x66 packet handler
;	mov ecx,68003815h	; system packet handler
;	mov eax,offset MyPacket0X68Handler
;	mov ecx,6800F31Ch	; packet 0x68 handler
;	mov eax,offset MyPacket0X68Handler
;	mov [ecx],eax
stub_func02 proc
;ecx=ClientID+ptPacket
;edx=packet_len
	sub esp,4
	mov [esp],ecx	;save the ptr
	cmp edx,25h
	jz check_0x68
not_0x68:
	push ecx
	mov eax,edx
	call dword_save_func02
	add esp,4
	ret
	
check_0x68:
	cmp byte ptr[ecx+4],68h
	jnz not_0x68
	push ecx
	mov eax,edx
	call dword_save_func02
	cmp eax,3
	jz over
	test eax,eax
	jz over
	; eax=ptClient
	push eax
	push ecx
	push edx
	mov ecx,[esp+0Ch]
	add ecx,4					; ptPacket
	mov edx,eax				; ptClient
	call MyPacket0X68Handler_Post
	pop edx
	pop ecx
	pop eax
over:
	add esp,4
	retn
stub_func02 endp

;6FC394E0 6 57E98B565553(ecx)							6FD04A30 6 FFF25912E856(esi)	;���һ�����(=eax)
;GetClient
;�Ѿ�OK
;��ջ����
; EAX��ECX��EDX���Ըı䣬�������ܱ�
stub_func03 proc
	push esi
	mov esi,ecx
	call dword_save_func03
	pop esi
	ret
stub_func03 endp

;6FC31DE0 5 681E75C985(ecx,edx)		6FCE4C40 5 681F75C085(eax,ecx)(=eax)
;��ջ����
; EAX��ECX��EDX���Ըı䣬�������ܱ�
stub_func04 proc
	mov eax,ecx
	mov ecx,edx
	call dword_save_func04
	ret
stub_func04 endp

;6FC395B0 4 1E75C985(ecx)				6FD03AD0 4 0775C085(eax)(=void)
;��ջ����
stub_func05 proc
	mov eax,ecx
	call dword_save_func05
	ret
stub_func05 endp

;6FC3C710 5 F18B565551(ecx, edx(no use), arg_0) 6FCC0D50 5 246C8B5553(eax,arg_0(no use),arg_4)(=void)
; eax=ptPlayer arg_0=ptPacket arg_4=PacketLen
; ecx=ptPlayer edx=ptPacket   arg_0=PacketLen
;��ջ����
;���Ըı�EAX��ECX��EDX���������ܱ�
;SendPacket2Client
;
;
;
;
;            edx
;ret         arg_0
;arg_0       ret
stub_func06 proc
	; stack fix
	mov [esp-4],edx
	mov edx,[esp] ; retaddr
	mov eax,[esp+4] ; arg_0
	mov [esp+4],edx ; retaddr
	mov [esp],eax   ; arg_0;
	mov eax,ecx
	sub esp,4
	
	call dword_save_func06
	ret
stub_func06 endp

;6FCBC2E0 7 39831474C985(fastcall, ecx)�Ѿ�����Ƕ�ˣ���Ҫdisable���Patch��Ȼ���Ϊ�������´���
;typedef LPCLIENT ( __fastcall * D2Game_UnitGetClientFunc)(LPUNIT lpUnitPlayer,
; 	LPCSTR szFile, DWORD dwLine);
;��ջ����
stub_func07 proc
	test    ecx, ecx
	jz      short loc_6FCBC2F8
	cmp     dword ptr [ecx], 0
	jnz     short loc_6FCBC2F8
	push    ecx
	call    D2COMMON_10800_GetpPlayerDataFromUnit
	mov     eax, [eax+9Ch]
	retn    4
loc_6FCBC2F8:
	xor     eax, eax
	retn    4
stub_func07 endp

;6FCBD820 8 0C24548B0424448B(arg_0,arg_4,arg_8)				6FCDE460 8 68488B0A8964488B(eax,arg_0,edx)(=eax)
;��ջ����(ʹ��Waypoint)
;
;
;
; ret
; arg_0
; arg_4     arg_4
; arg_8     ret
stub_func08 proc
	; stack fix
	mov edx,[esp+12] ; arg_8
	mov eax,[esp] ; retaddr
	mov [esp+12],eax
	mov eax,[esp+4] ; arg_0
	add esp,8
	
	call dword_save_func08
	ret
stub_func08 endp

;6FCBBB00 4 7556C985(ecx,edx,arg_0)	6FCDEF80 4 1F75C985(ecx,eax,edx)(=eax)
;typedef LPUNIT 	( __fastcall * D2Game_GameFindUnitFunc)(LPGAME ptGame, DWORD dwUnitType, DWORD dwUnitId);
;û���ֵ���
;
;
;
; ret
; arg_0   ret
stub_func09 proc
	; stack fix
	mov [esp-4],edx ; save edx
	mov edx,[esp+4] ; arg_0
	mov eax,[esp]   ; retaddr
	mov [esp+4],eax
	mov eax,[esp-4] ; restore edx
	add esp,4
	
	call dword_save_func09
	ret
stub_func09 endp

;d2game.dll		6FC8A200(6FC8D940) 4 0000373C(ecx,edx,arg_0,arg_4,arg_8,arg_12,arg_16)  6FC4557F 4 000037BD (edx,ecx,...)
;����ecx��edx��Ȼ��ֱ����ת������call����
;typedef DWORD (__fastcall * D2Game_GetPlrSaveDataFunc)(LPGAME ptGame, LPUNIT ptUnitPlayer, 
;		LPSTR lpBuf, DWORD * pSize, DWORD dwBufSize, BOOL bInTrade, BOOL bQuit);
; ecx=ptPlayer edx=ptGame arg0=var_2000? arg_4=var_25F8filename? arg_8=2000h arg_12=0 arg_16=0
; ecx=ptGame edx=ptPlayer arg0=unk_12D884 arg_4=unk_12D244 arg_8=2000h arg_12=0 arg_16=0
stub_func10 proc
	mov eax,edx
	mov edx,ecx
	mov ecx,eax
	jmp dword_save_func10
stub_func10 endp

;6FC38F7A 4 FFFFF752(ecx)		6FD0818C 4 FFFFFDF0(eax)
;��ջ����
;UpdateGameEvent
stub_func11 proc
	mov eax,ecx
	call dword_save_func11
	ret
stub_func11 endp

;6FC39391 4 FFFFFC9B(ecx,edx,arg_0,arg_4)			6FD0744A 4 FFFFFCC2(arg_0,eax,arg_4,edx)
;typedef VOID	( __fastcall * D2Game_GameSendAllMsgsFunc)(LPGAME ptGame, LPCLIENT ptClient, BOOL u1, BOOL u2);
;��ջ����
;
;
;
;
; ret      ecx
; arg_0    arg_0
; arg_4    ret
stub_func12 proc
	; stack fix
	mov [esp-4],edx ; save edx
	mov edx,[esp] ; retaddr
	mov eax,[esp+8] ; arg_4
	mov [esp+8],edx ; retaddr
	mov [esp],ecx
	mov edx,eax			; arg_4->edx
	mov eax,[esp-4] ; restore edx
	
	call dword_save_func12
	ret
stub_func12 endp

;6FC8A500 4 002640B8(ecx,edx,arg_0,arg_4)��������ҵ����� 6FC45860 4 8538EC83(ebx,esi,arg_0,arg_4)
;GameSavePlayer
;����Hack��ҵ�����������Ҫ�ٴμ�飡��������Ŀ�ǶԵģ�����˳��֪����Σ�
;
;
;
;         arg_0
;         arg_4
; ret     esi
; arg_0   ebx
; arg_4   ret
stub_func13 proc
	; stack fix
	mov eax,[esp+8]		; arg_4
	mov [esp-4],eax
	mov eax,[esp+4]		; arg_0
	mov [esp-8],eax
	mov eax,[esp]			; retaddr
	mov [esp+8],eax
	mov [esp+4],ebx
	mov [esp],esi
	sub esp,8
	mov ebx,ecx
	mov esi,edx

	call dword_save_func13
	pop esi
	pop ebx
	ret
stub_func13 endp

;6FC31E20 4 24748B56 0 0(arg_0,arg_4)  		6FCE5600 4 1F75F685(esi,arg_0)
; ��Client���ptUnit
;û�ҵ����ã��Ѿ��������ˡ�
;
;
;
; ret    arg_4
; arg_0  esi
; arg_4  ret
stub_func14 proc
	; stack fix
	mov eax,[esp+8]	; arg_4
	mov [esp-4],eax	; save arg_4
	mov eax,[esp]		; retaddr
	mov [esp+8],eax
	mov eax,[esp-4]	; restore arg_4
	mov [esp],eax
	mov eax,[esp+4]	; arg_0
	mov [esp+4],esi	; save esi
	mov esi,eax
	
	call dword_save_func14
	pop esi
	ret
stub_func14 endp

;6FC3B0E0 6 FA8B57F18B56(ecx,edx,arg_0)				6FD036D0 6 75F685F08B56(eax,edi,ebx)
;typedef VOID	( __fastcall * D2Game_GameTraverseClientCBFunc)(LPCLIENT lpClient,LPVOID lpData);
;û�ҵ�����
;
;
;
;
;         ebx
; ret     edi
; arg_0   ret
stub_func15 proc
	; stack fix
	mov [esp-4],ebx
	mov ebx,[esp+4] ; arg_0
	mov eax,[esp]	; retaddr
	mov [esp+4],eax
	mov [esp],edi
	sub esp,4
	mov eax,ecx
	mov edi,edx
	
	call dword_save_func15
	pop ebx
	pop edi
	ret
stub_func15 endp

;6FC35840 4 57F18B56(ecx)	6FD04400 4 0125BA56(arg_0)
;typedef DWORD	( __fastcall * D2Game_GameHashFromIdFunc)(WORD wGameId);
;û�ҵ�����
stub_func16 proc
	push ecx
	call dword_save_func16
	ret
stub_func16 endp

;6FC397A0 4 358B5653(ecx)									6FD049A0 4 D31BE0A1(arg_0)
;typedef LPGAME 	( __fastcall * D2Game_GameFromHashFunc)(DWORD dwHashId);
;û�ҵ�����
stub_func17 proc
	push ecx
	call dword_save_func17
	ret
stub_func17 endp

;6FC51070 8 555300000430EC81(ecx=ptGame,edx,arg_0,arg_4=1)		6FCF0410 8 8B530000042CEC81(eax=ptGame,arg_0=item,NULL,arg_4=1)
; typedef LPUNIT  ( __fastcall * D2Game_ItemDuplicateFunc)(LPGAME lpGame,
;		LPUNIT lpUnitItem, LPUNIT lpUnitCreator, DWORD dwFlags);
;û�ҵ����ã�û�˵��ã�����
;
;
;
;
;
; ret      edx
; arg_0    arg_4
; arg_4    ret
stub_func18 proc
	; stack fix
	mov eax,[esp] ; retaddr
	mov [esp],edx
	mov edx,[esp+8] ; arg_4
	mov [esp+8],eax ; retaddr
	mov eax,[esp+4] ; arg_0
	mov [esp+4],edx ; arg_4
	
	mov eax,ecx
	call dword_save_func18
	ret
stub_func18 endp

;d2game.dll		6FCC77D0 4 00054032(arg_0,arg_4,arg_8,arg_12) 6FCB2859 4 FFF77DE5(arg_0,arg_4,arg_8,arg_12)
;typedef BOOL (__stdcall * D2Common_ItemTestFlagFunc)(LPUNIT ptItem, DWORD dwFlag, DWORD dwLine, LPCSTR lpLine); 
;static BOOL __stdcall D2GameSellItemCheck(LPUNIT ptItem, DWORD dwFlag, DWORD dwLine, LPCSTR lpFile) 
;û�ҵ�����
stub_func19 proc
	;call Send0XAEPacket
	jmp dword_save_func19
stub_func19 endp

;d2game.dll		6FC6F720 4 FFFFFAFC(ecx,edx,arg_0,arg_4,arg_8,arg_12,arg_16,arg_20) 6FD0CF10 4 FFFFF8CC(arg_0,arg_4,edx,arg_8,arg_12,arg_16,ecx,eax)
;SpawnDiabloClone
;CowKing:
;eax=1
;ecx=187
;stack=unk,unk,0,0,FFFFFFF
;
;
;
;
; ret
; arg_0      ecx
; arg_4      edx
; arg_8      arg_4
; arg_12     arg_8
; arg_16     arg_12
; arg_20     ret
;
;
;0=143b 4=FFFFFF 8=14 12=0 16=14d 20=0 x=3 ecx=ptgameE0CC4200A0... edx=CC60235B...
;0=ptgame 4=edx 8=FFFFFF 12=14 16=0 ecx=14D edx=143b eax=0
stub_func20 proc
	; stack fix
	mov eax,[esp+24]	; arg_20
	mov [esp-4],eax		; save arg_20
	mov eax,[esp+20]	; arg_16
	mov [esp-8],eax		; save arg_16
	mov eax,[esp]
	mov [esp+24],eax	; retaddr
	mov eax,[esp+16]	; arg_12
	mov [esp+20],eax
	mov eax,[esp+12]	; arg_8
	mov [esp+16],eax
	mov eax,[esp+8]		; arg_4
	mov [esp+12],eax
	mov [esp+8],edx
	mov edx,[esp+4]		; arg_0
	mov [esp+4],ecx
	
	mov eax,[esp-4]		; restore arg_20
	mov ecx,[esp-8]		; restore arg_16
	add esp,4

	call dword_save_func20
	ret
stub_func20 endp

;6FC31C74 4 000576A8(ecx,edx,arg_0,arg_4)			6FC903B6 4 FFFBD3F6(arg_0,esi,ebx,arg_4)
;��ջ����
;MessageHandling
;
;
;
;
; ret     ebx
; arg_0   arg_4
; arg_4   ret
cb_stub_func00 proc
	; stack fix
	mov eax,[esp]		; retaddr
	mov edx,[esp+8]	; arg_4
	mov [esp+8],eax	; retaddr
	mov ecx,[esp+4]	; arg_0
	mov [esp+4],edx	; arg_4
	mov [esp],ebx
	mov edx,esi
	
	call cb_save_func00
	ret
cb_stub_func00 endp

;6FC38551 4 FFFF93BB(ecx,edx)			6FD0832F 4 FFF8809D(arg_0,eax)
;��ջ����
;
;
;
; ret
; arg_0 ret
cb_stub_func01 proc
	; stack fix
	pop edx	; retaddr
	pop ecx	; arg_0
	push edx	; retaddr
	mov edx,eax

	call cb_save_func01
	ret
cb_stub_func01 endp

;d2game.dll		6FC8A200(6FC8D940) 4 0000373C(ecx,edx,arg_0,arg_4,arg_8,arg_12,arg_16)  6FC4557F 4 000037BD (edx,ecx,...)
;û�ҵ�����
cb_stub_func02 proc
	mov eax,ecx
	mov ecx,edx
	mov edx,eax
	jmp cb_save_func02
cb_stub_func02 endp

;6FC38F7A 4 FFFFF752(ecx)			6FD0818C 4 FFFFFDF0(eax)
;��ջ�������Ʋ⣩
cb_stub_func03 proc
	mov ecx,eax
	call cb_save_func03
	ret
cb_stub_func03 endp

;6FC39391 4 FFFFFC9B(ecx,edx,arg_0,arg_4)			6FD0744A 4 FFFFFCC2(arg_0,eax,arg_4,edx)
;��ջ�������Ʋ⣩
;
;
;
;
;
; ret     arg_4
; arg_0   edx
; arg_4   ret
cb_stub_func04 proc
	; stack fix
	mov [esp-4],eax	; save eax
	mov ecx,[esp+4]	; arg_0
	mov [esp+4],edx
	mov eax,[esp]	; retaddr
	mov edx,[esp+8]	; arg_4
	mov [esp+8],eax	; retaddr
	mov [esp],edx
	
	mov edx,[esp-4]	; restore eax

	call cb_save_func04
	ret
cb_stub_func04 endp

;d2game.dll		6FCC77D0 4 00054032(arg_0,arg_4,arg_8,arg_12) 6FCB2859 4 FFF77DE5(arg_0,arg_4,arg_8,arg_12)
;û�ҵ�����
cb_stub_func05 proc
	jmp cb_save_func05
cb_stub_func05 endp

;d2game.dll		6FC6F720 4 FFFFFAFC(ecx,edx,arg_0,arg_4,arg_8,arg_12,arg_16,arg_20) 6FD0CF10 4 FFFFF8CC(arg_0,arg_4,edx,arg_8,arg_12,arg_16,ecx,eax)
;SpawnDiabloClone
;
;
;
;
;
;          edx
; ret      arg_8
; arg_0    arg_12
; arg_4    arg_16
; arg_8    ecx
; arg_12   eax
; arg_16   ret
cb_stub_func06 proc
	; stack fix
	mov [esp-4],edx
	mov [esp-8],eax		; save eax
	mov [esp-12],esi	; save esi
	mov edx,[esp+20]	; arg_16
	mov eax,[esp]			; retaddr
	mov [esp+20],eax
	mov eax,[esp+12]	; arg_8
	mov [esp],eax
	mov [esp+12],ecx
	mov eax,[esp+8]		; arg_4
	mov [esp+8],edx
	mov edx,eax				; arg_4
	mov ecx,[esp+4]		; arg_0
	mov esi,[esp+16]	; arg_12
	mov eax,[esp-8]		; restore eax
	mov [esp+16],eax
	mov [esp+4],esi		; arg_12
	mov esi,[esp-12]	; restore esi
	sub esp,4
	
	
	call cb_save_func06
	ret
cb_stub_func06 endp

	INCLUDE UberQuest.asm

;˫�⻷PET��BUG
;����ԭ�򣺵���Ʒ���Ƴ���ʱ�򣬹���PET������Ӧ�Ĺ⻷�¼���û�б��Ƴ��������ٴ�װ����Ʒ��ʱ�򣬹⻷�¼���������
;�������������Ʒ���Ƴ���ʱ�򣬼��PET���ϵ��¼����������Ƴ���Ʒ��Ӧ�Ĺ⻷�¼��Ƴ���
;�½����������AuraSkill_related_event9_handler->UpdateAuraEvent�У����������¼���׼���������¼���ʱ�򣬼��UID�Ƿ��ǺϷ���UID
NewDualAuraPatch proc
	;������ȡPET����Player��������װ����UID�����浽һ�����飬Ȼ���PET��Player�������еĹ⻷�¼��������UID�Ƿ����װ����UID��������ǣ����Ƴ��⻷

	;	6FC9604C push    9
	;(ecx=ptGame,edx=?,ebx=UID,edi=ptPet)
	; ebx,ecx,eax,edx�������ƻ������ر���
	
	test ecx,ecx
	jz over
	test edi,edi
	jz over
	
	pushad
	sub esp,80
	mov ebp,esp
	
	mov ebx,15
	push ecx

again:							; ��ȡPET��������װ����UID�������浽һ����ʱ������
	mov edx,[edi+60h]	; ptPet->Inv
	push ebx
	push edx
	call D2COMMON_11003_GetInvItemByBodyLoc
	test eax,eax
	jz check_next_loc
	mov eax,[eax+0Ch]
check_next_loc:
	mov [ebp+ebx*4],eax
	dec ebx
	jge again

	pop ecx
		
	mov esi,[edi+0DCh]	; ptPet->EventChain
	test esi,esi
	jz my_over1
	
again_event:
	movzx edx,byte ptr [esi]
	cmp edx,9		; an Aura event
	jnz next_event_prev
	mov eax,[esi+14h] ; the Aura Owner Item uid	��ÿһ���⻷�¼�������Ƿ�����PET����װ����UID
	
	cmp eax,0FFFFFFFFh
	jz next_event_prev
	
	mov ebx,15
again_uid:
	cmp eax,[ebp+ebx*4]
	jz next_event_prev
	dec ebx
	jge again_uid

	pushad				; �Ƿ��⻷�������
	mov edi,ecx
	mov eax,esi
	call D2GAME_DestoryAEvent		; eax=the event edi=ptGame
	popad
;	mov esi,[edi+0DCh] ; Get the Event chain from pet unit
;	test esi,esi
;	jnz again_event
next_event_prev:
	mov esi,[esi+24h] ; set prev event
	test esi,esi
	jnz again_event
	
my_over1:
	add esp,80
	popad
	
over:
	ret

NewDualAuraPatch endp

D2GAME_DestoryAEvent dd 0

DualAuraPatch proc
	; ebp the PET
	; eax the Item
	pushad
	
	mov edi,[ebp+80h] ; Get the ptGame
	mov esi,[ebp+0DCh] ; Get the Event chain from pet unit
	test esi,esi
	jz over
	test edi,edi
	jz over
	
	
	
again_prev:
	mov edx,[esi]	
	cmp edx,9		; an Aura event
	jnz next_event_prev
	mov ebx,[esi+14h] ; the Aura Owner Item uid
	cmp ebx,[eax+0Ch] ; the Item->uid
	jnz next_event_prev
	pushad
	mov eax,esi
	call D2GAME_DestoryAEvent		; eax=the event edi=ptGame
	popad
	mov esi,[ebp+0DCh] ; Get the Event chain from pet unit
	test esi,esi
	jnz again_prev
next_event_prev:
	mov esi,[esi+20h] ; set prev event
	test esi,esi
	jnz again_prev

	mov esi,[ebp+0DCh] ; Get the Event chain from pet unit
	test esi,esi
	jz over

again_next:
	mov edx,[esi]	
	cmp edx,9		; an Aura event
	jnz next_event_next
	mov ebx,[esi+14h] ; the Aura Owner Item uid
	cmp ebx,[eax+0Ch] ; the Item->uid
	jnz next_event_next
	pushad
	mov eax,esi
	call D2GAME_DestoryAEvent		; eax=the event edi=ptGame
	popad
	mov esi,[ebp+0DCh] ; Get the Event chain from pet unit
	test esi,esi
	jnz again_next
next_event_next:
	mov esi,[esi+24h] ; set next event
	test esi,esi
	jnz again_next

over:
	popad
	ret
DualAuraPatch endp

; ��齻��˫�����Ƿ��ж���Ĺ⻷�¼�
TradePlayerAuraBugPatch proc
	test edx,edx
	jz over
	pushad
	mov ebp,edx
	call PlayerAuraCheckPatch
	
	mov edx,[ebp+64h]	; ��ȡ���׶Է���UnitID
	mov ecx,[ebp+80h]	; ptGame
	xor eax,eax				; Player Type
	call dword_save_func09	; ��ȡ���׶Է���Unit
	test eax,eax
	jz over1
	mov ebp,eax
	call PlayerAuraCheckPatch
over1:
	popad
over:
	mov di,[eax+3]
	xor esi,esi
	ret
TradePlayerAuraBugPatch endp

; ���������ϵ����й⻷������Щ�⻷�¼���Item UID�Ƿ�װ����������ϣ����ûװ����������ϣ����Ƴ����¼�
PlayerAuraCheckPatch proc
	; ebp the Player
	pushad
	
	mov edi,[ebp+80h] ; Get the ptGame
	mov esi,[ebp+0DCh] ; Get the Event chain from player unit
	test esi,esi
	jz over
	test edi,edi
	jz over
	
again_prev:
	mov edx,[esi]	; Get the event type
	cmp edx,9		; an Aura event
	jnz next_event_prev
	
	mov ebx,[esi+14h] ; the Aura Owner Item uid
	
; ѭ������������װ����������Ʒ
	pushad
	xor edi,edi
next_inv_item1:
	push edi					; body location
	mov eax,[ebp+60h]	; Player's Inventory
	push eax
	call D2COMMON_11003_GetInvItemByBodyLoc
	test eax,eax
	jz try_next_item1
	cmp ebx,[eax+0Ch]	; item->nUnitId
	jz found_aura_item1
try_next_item1:
	inc edi
	cmp edi,0Bh
	jnz next_inv_item1
	popad
	jmp remove_aura1
found_aura_item1:
	popad
	jmp next_event_prev

remove_aura1:	
	pushad
	mov eax,esi
	call D2GAME_DestoryAEvent		; eax=the event edi=ptGame
	popad
	mov esi,[ebp+0DCh] ; Get the Event chain from player unit
	test esi,esi
	jnz again_prev
next_event_prev:
	mov esi,[esi+20h] ; set prev event
	test esi,esi
	jnz again_prev

	mov esi,[ebp+0DCh] ; Get the Event chain from player unit
	test esi,esi
	jz over

again_next:
	mov edx,[esi]	
	cmp edx,9		; an Aura event
	jnz next_event_next
	mov ebx,[esi+14h] ; the Aura Owner Item uid

; ѭ������������װ����������Ʒ
	pushad
	xor edi,edi
next_inv_item2:
	push edi					; body location
	mov eax,[ebp+60h]	; Player's Inventory
	push eax
	call D2COMMON_11003_GetInvItemByBodyLoc
	test eax,eax
	jz try_next_item2
	cmp ebx,[eax+0Ch]	; item->nUnitId
	jz found_aura_item2
try_next_item2:
	inc edi
	cmp edi,0Bh
	jnz next_inv_item2
	popad
	jmp remove_aura2
found_aura_item2:
	popad
	jmp next_event_next

remove_aura2:	
	pushad
	mov eax,esi
	call D2GAME_DestoryAEvent		; eax=the event edi=ptGame
	popad
	mov esi,[ebp+0DCh] ; Get the Event chain from player unit
	test esi,esi
	jnz again_next
next_event_next:
	mov esi,[esi+24h] ; set next event
	test esi,esi
	jnz again_next

over:
	popad
	ret
PlayerAuraCheckPatch endp

TPCrashBugPatch proc
	; fix the stack first
	; save the retaddr
	pop esi		; retaddr
	
	call D2COMMON_10743_GetRoom1
	push esi	; retaddr
	push ebx
	push ecx
	push edx
	push eax	; retval
			
	mov ecx,[esp+30h]	; X
	mov edx,[esp+34h]	; Y
			
	mov esi,eax
	test esi,esi
	jz fail_over
	mov eax,[esi+8]	; Get room XStart
	cmp ecx,eax
	jl fail_over		; X<XStart, fail
	mov ebx,[esi+10h]	; Get room XSize
	add ebx,eax				; room XEnd
	cmp ecx,ebx				; X>XEnd, fail
	jge fail_over
	mov eax,[esi+0Ch]	; Get room YStart
	cmp edx,eax
	jl fail_over			; Y<YStart, fail
	mov ebx,[esi+14h]	; Get room YSize
	add ebx,eax				; room YEnd
	cmp edx,ebx
	jge fail_over			; Y>YEnd, fail
	pop eax	; retval	; the corrent room return
	pop edx
	pop ecx
	pop ebx
	ret
fail_over:
	pop eax	; stack fix: retval
	pop edx
	pop ecx
	pop ebx
	pop eax	;	stack fix: retaddr
	mov eax,D2GAME_0X10B1B		; fail, destroy the town portal already created
	push eax	; new retaddr
	xor eax,eax
	ret
TPCrashBugPatch endp

ExpGlitchFix proc
	;6FC9E051
	; esi=MonsterBaseExp=0x0039FD64(Diablo)���0x004537D4(Baal)
	; ecx=NumberOfPlayerShareExp=8
	; [esp+5C] = ͬһ������������Ҽ���֮��

	; eax=exp1
	
	;exp1=(MonsterBaseExp*(NumberOfPlayerShareExp-1)*89)/256+MonsterBaseExp=0xEDAAB0
	;player_exp=exp1*CLVL/TotalCLVL
	;exp1*CLVL=EDAAB0*99=0x5BE90210
	
	mov		esi,[esp+70h]	; ����������أ��ܾ���ֵexp=0x0039FD64
	lea		eax,[ecx-1]
	imul	eax,59h			; (NumberOfPlayerShareExp-1)*89
	mul		esi					; MonsterBaseExp*(NumberOfPlayerShareExp-1)*89
	xor		edx,edx
	mov		ebx,256
	div		ebx					; (MonsterBaseExp*(NumberOfPlayerShareExp-1)*89)/256
	add		eax,esi			;	(MonsterBaseExp*(NumberOfPlayerShareExp-1)*89)/256+MonsterBaseExp
	
	mov		[esp+5Ch+arg_8],eax
	
	xor		esi,esi

Loop_ExpGlitchFix:
	mov		edi,[esp+esi*4+34h]	;��Ҽ���
	mov		ebx,[esp+esi*4+14h]	;ptPlayer
	mov		eax,[esp+5Ch+arg_8]
	mul		edi
	div		dword ptr [esp+58h]						; TotalCLVL
;6FC9E0A9
ExpGlitchFix endp

ExpGlitchFixEnd proc
ExpGlitchFixEnd endp

;.text:6FC9E09C                 mov     [esp+5Ch+arg_8], edi
;.text:6FC9E0A0                 fild    [esp+5Ch+arg_8] ; 4B
;.text:6FC9E0A4                 fmul    dword ptr [esp+70h]
;.text:6FC9E0A8                 call    __ftol2       
;
;�޸�Ϊ��
;	mov eax,[esp+5Ch+arg_8]
;	mul edi
;	div [esp+5Ch]						; TotalCLVL
	


MyInitGameHandler	proc
	; eax=ptGameInfo
;	xor ecx,ecx
;	mov [eax],ecx
;	mov [eax+4],ecx
;	ret

	
	pushad
	mov	esi,eax
	mov ebx,[esi+4]
	test ebx,ebx
	jnz already_malloc
	push 1024					; sizeof ExtendGameInfoStruct
	mov eax,malloc
	mov eax,[eax]
	call eax ; malloc
	add esp,4
	mov [esi+4],eax ; ָ���µ�ExtendGameInfoStruct
	test eax,eax
	jz fail_over
already_malloc:
	xor ebx,ebx
	mov [esi],ebx
	mov eax,[esi+4]
	
	mov [eax+ExtendGameInfoStruct.PortalOpenedFlag],ebx
	
;00300004	��ϷFlag��
;test ecx,100000h	�����ж��Ƿ���D2C����LOD��Ϸ
	mov ecx,[esp+2Ch];	��ȡD2C��־
	test ecx,100000h
	jz D2C_Type
	mov [eax+ExtendGameInfoStruct.LoD_Game],1
	jmp fail_over
D2C_Type:
	mov [eax+ExtendGameInfoStruct.LoD_Game],0
fail_over:
	popad
	ret
MyInitGameHandler	endp

MeleePetAIFix proc
	;6FC87F99
	; esi=ptPet ecx=petType=152=Act2Pet
	
	push 55		; STATE_IRONMAIDEN
	push esi
	call D2COMMON_10604_GetUnitState
	test eax,eax
	mov  edi,62h
	jz over
	xor  edi,edi	; ���������IM�����������ж�
over:
	ret
MeleePetAIFix endp

NeroPetAIFix proc
	; 6FC8E98C
	; ebx=ptPet
	
	push 55		; STATE_IRONMAIDEN
	push ebx
	call D2COMMON_10604_GetUnitState
	test eax,eax
	mov  eax,64h
	jz over
	mov eax,07FFFFFFFh	; ���������IM�����������ж�
over:
	ret
NeroPetAIFix endp

UnicodeCharNameCheck proc
	; edi=��󳤶ȣ�eax=CharName
	push esi
	push ebx
	xor ebx,ebx
	test edi,edi
	mov esi,eax
	jle fail_over
	
next_char:
	mov al,byte ptr[esi]
	test al,al
	jz success_ok
	inc esi
	inc ebx
	
	xor ecx,ecx
next_invalid_char:
	mov dl,byte ptr InvalidChar[ecx]
	test dl,dl
	jz over
	cmp al,dl
	jz fail_over
	inc ecx
	jmp next_invalid_char

over:
	cmp ebx,edi
	jle next_char
success_ok:
	mov eax,1
	jmp ok
fail_over:
	xor eax,eax
ok:
	pop ebx
	pop esi
	ret
UnicodeCharNameCheck endp

InvalidChar db '\','/',':','*','?','"','<','>','|',0

MonsterDamageFix proc
	; 6FCB4750
	; ebp=ptMonster
	
	;orig code
	mov	eax,[ebp+0]
	cmp	eax,1
	jnz	fail_over
	; Check monster emode
	; 0,1,2,3,6,12,15~������Ҫ����MonsterDamage���㣡
	mov eax,[ebp+10h]
	cmp eax,14
	jg	fail_over
	cmp	eax,4
	jl	fail_over
	cmp	eax,6
	jz	fail_over
	cmp	eax,12
	jz	fail_over
	;������
	xor eax,eax
	cmp eax,0
	ret
fail_over:
	;set the NZ flag
	xor eax,eax
	cmp eax,1
	ret
MonsterDamageFix endp


INCLUDE Warden.asm

ProtectDLL proc
	flOldProtect    = dword ptr -4
	arg_0           = byte ptr  4
	arg_4           = dword ptr  8
	
	push    ecx
	mov     ecx, [esp+4+arg_4]
	mov     eax, [ecx+3Ch]
	push    esi
	push    edi
	add     eax, ecx
	mov     [esp+0Ch+flOldProtect], 0
	mov     edi, [eax+1Ch]
	mov     esi, [eax+2Ch]
	lea     eax, [esp+0Ch+flOldProtect]
	push    eax             ; lpflOldProtect
	push    20h             ; flNewProtect
	add     esi, ecx
	push    edi             ; dwSize
	push    esi             ; lpAddress
	mov			eax,VirtualProtect
	mov			eax,[eax]
	call    eax

	pop     edi
	pop     esi
	pop     ecx
	retn 8
ProtectDLL endp

UnProtectDLL proc
	flOldProtect    = dword ptr -4
	arg_0           = byte ptr  4
	arg_4           = dword ptr  8
	
	push    ecx
	mov     ecx, [esp+4+arg_4]
	mov     eax, [ecx+3Ch]
	push    esi
	push    edi
	add     eax, ecx
	mov     [esp+0Ch+flOldProtect], 0
	mov     edi, [eax+1Ch]
	mov     esi, [eax+2Ch]
	lea     eax, [esp+0Ch+flOldProtect]
	push    eax             ; lpflOldProtect
	push    40h             ; flNewProtect	PAGE_EXECUTE_READWRITE=0x40 PAGE_EXECUTE_READ=0x20 PAGE_READWRITE=0x04
	add     esi, ecx
	push    edi             ; dwSize
	push    esi             ; lpAddress
	mov			eax,VirtualProtect
	mov			eax,[eax]
	call    eax
	
	pop     edi
	pop     esi
	pop     ecx
	retn 8
UnProtectDLL endp

ProtectDLL2 proc
	flOldProtect    = dword ptr -4
	arg_0           = byte ptr  4
	arg_4           = dword ptr  8
	
	push    ecx
	mov     ecx, [esp+4+arg_4]
	mov     eax, [ecx+3Ch]
	push    esi
	push    edi
	add     eax, ecx
	mov     [esp+0Ch+flOldProtect], 0
	mov     edi, [eax+1Ch]
	mov     esi, [eax+2Ch]
	lea     eax, [esp+0Ch+flOldProtect]
	push    eax             ; lpflOldProtect
	push    20h             ; flNewProtect
	add     esi, ecx
	push    edi             ; dwSize
	push    esi             ; lpAddress
	mov			eax,VirtualProtect
	mov			eax,[eax]
	call    eax

	;protect the .rdata segment
	mov     ecx, [esp+0Ch+arg_4]
	add     ecx, 0F8D64h				; .rdata start address
	lea     eax, [esp+0Ch+flOldProtect]
	push    eax             ; lpflOldProtect
	push    2	              ; flNewProtect	PAGE_EXECUTE_READWRITE=0x40 PAGE_EXECUTE_READ=0x20 PAGE_READWRITE=0x04
	push    0000629Ch       ; dwSize
	push    ecx             ; lpAddress
	mov			eax,VirtualProtect
	mov			eax,[eax]
	call    eax

	pop     edi
	pop     esi
	pop     ecx
	retn 8
ProtectDLL2 endp

UnProtectDLL2 proc
	flOldProtect    = dword ptr -4
	arg_0           = byte ptr  4
	arg_4           = dword ptr  8
	
	push    ecx
	mov     ecx, [esp+4+arg_4]
	mov     eax, [ecx+3Ch]
	push    esi
	push    edi
	add     eax, ecx
	mov     [esp+0Ch+flOldProtect], 0
	mov     edi, [eax+1Ch]
	mov     esi, [eax+2Ch]
	lea     eax, [esp+0Ch+flOldProtect]
	push    eax             ; lpflOldProtect
	push    40h             ; flNewProtect	PAGE_EXECUTE_READWRITE=0x40 PAGE_EXECUTE_READ=0x20 PAGE_READWRITE=0x04
	add     esi, ecx
	push    edi             ; dwSize
	push    esi             ; lpAddress
	mov			eax,VirtualProtect
	mov			eax,[eax]
	call    eax
	
	;unprotect the .rdata segment
	mov     ecx, [esp+0Ch+arg_4]
	add     ecx, 0F8D64h				; .rdata start address
	lea     eax, [esp+0Ch+flOldProtect]
	push    eax             ; lpflOldProtect
	push    4	              ; flNewProtect	PAGE_EXECUTE_READWRITE=0x40 PAGE_EXECUTE_READ=0x20 PAGE_READWRITE=0x04
	push    0000629Ch       ; dwSize
	push    ecx             ; lpAddress
	mov			eax,VirtualProtect
	mov			eax,[eax]
	call    eax
	
	
	pop     edi
	pop     esi
	pop     ecx
	retn 8
UnProtectDLL2 endp

SingleRoomDCPatch proc
	; esi=����NPC��Item
	
	push	1000
	push	0
	call	GetRandomNumber
	mov		edx,DcItemRate
	add		esp,8
	cmp		eax,edx
	sbb		eax,eax
	neg		eax
	
	test	eax,eax
	jz		over_retn
	
	mov		esi,[esi+80h]
	test	esi,esi
	jz		over_retn
	push	1		;�Ƿ��ͷ�DiabloClone��
	push	1		;�Ƿ���ʾxx��SOJ�������ˣ�
	push	esi
	call	sub_68005A10
	add		esp,0Ch
;	mov		ecx,esi
;	mov		eax,D2Game_LeaveCriticalSection
;	mov		eax,[eax]
;	call	eax

over_retn:
	mov		eax,SOJ_Counter
	mov		eax,[eax]
	inc		eax
	
	ret
SingleRoomDCPatch endp

dbl_1000FDF0    dq 1.0
PreCalculateTCNoDropTbl	dd 0

PreCalculateTreasureClassNoDropTbl proc near

var_1C          = dword ptr -1Ch
var_18          = dword ptr -18h
var_14          = qword ptr -14h
var_C           = dword ptr -0Ch
var_8           = dword ptr -8
var_4           = dword ptr -4

                push    ebp
                mov     ebp, esp
                sub     esp, 1Ch
                push    esi
                mov     eax, 6FDF114Ch
                mov     esi, [eax]
                test    esi, esi
                push    edi
                mov     edi, ds:6FDF1150h
                mov     [ebp+var_18], edi
                jz      loc_10003F98
                test    edi, edi
                jz      loc_10003F98
                lea     eax, ds:0[edi*8]
                sub     eax, edi
                add     eax, eax
                add     eax, eax
                add     eax, eax
                push    eax             ; Size
                mov			eax,malloc
								mov			eax,[eax]
                call    eax
                add     esp, 4
                test    eax, eax
                mov     [ebp+var_1C], eax
                jz      loc_10003F98
                push    ebx
                xor     ebx, ebx
                test    edi, edi
                jle     loc_10003F8E
                mov     edi, eax
                add     esi, 8
                jmp     short loc_10003E90
; ---------------------------------------------------------------------------
                align 10h

loc_10003E90:                           ; CODE XREF: PreCalculateTreasureClassNoDropTbl+5Bj
                                        ; PreCalculateTreasureClassNoDropTbl+158j
                lea     ecx, [esi-8]
                test    ecx, ecx
                jz      loc_10003F8E
                mov     eax, [esi+0Ch]
                test    eax, eax
                mov     ecx, [esi]
                mov     edx, [esi+4]
                mov     [ebp+var_4], eax
                mov     [ebp+var_C], ecx
                mov     dword ptr [ebp+var_14+4], edx
                jnz     short loc_10003EDA
                mov     eax, edi
                mov     ecx, 7
                jmp     short loc_10003EC0
; ---------------------------------------------------------------------------
                align 10h

loc_10003EC0:                           ; CODE XREF: PreCalculateTreasureClassNoDropTbl+87j
                                        ; PreCalculateTreasureClassNoDropTbl+A3j
                mov     dword ptr [eax+1Ch], 0
                mov     dword ptr [eax], 0
                add     eax, 4
                sub     ecx, 1
                jnz     short loc_10003EC0
                jmp     loc_10003F7C
; ---------------------------------------------------------------------------

loc_10003EDA:                           ; CODE XREF: PreCalculateTreasureClassNoDropTbl+7Ej
                fild    [ebp+var_4]
                add     ecx, eax
                mov     [ebp+var_8], ecx
                add     edx, eax
                fstp    [ebp+var_4]
                lea     ecx, [edi+1Ch]
                fild    [ebp+var_8]
                mov     [ebp+var_8], edx
                mov     edx, 7
                fdivr   [ebp+var_4]
                fld     st
                fild    [ebp+var_8]
                fdivr   [ebp+var_4]
                fld     st
                fild    [ebp+var_C]
                fild    dword ptr [ebp+var_14+4]

loc_10003F08:                           ; CODE XREF: PreCalculateTreasureClassNoDropTbl+13Ej
                fld     st(5)
                add     ecx, 4
                fmulp   st(5), st
                fld     st(4)
                fld     ds:dbl_1000FDF0
                fsub    st, st(1)
                fnstcw  word ptr [ebp+var_4+2]
                movzx   eax, word ptr [ebp+var_4+2]
                or      ah, 0Ch
                fdivr   st, st(3)
                mov     dword ptr [ebp+var_14+4], eax
                fmul    st, st(1)
                fldcw   word ptr [ebp+var_14+4]
                fistp   qword ptr [ebp-14h]
                mov     eax, dword ptr [ebp+var_14]
                mov     [ecx-20h], eax
                fstp    st
                fldcw   word ptr [ebp+var_4+2]
                fld     st(3)
                fmulp   st(3), st
                fld     st(2)
                fld     ds:dbl_1000FDF0
                fsub    st, st(1)
                fnstcw  word ptr [ebp+var_4+2]
                movzx   eax, word ptr [ebp+var_4+2]
                or      ah, 0Ch
                sub     edx, 1
                fdivr   st, st(2)
                mov     dword ptr [ebp+var_14+4], eax
                fmul    st, st(1)
                fldcw   word ptr [ebp+var_14+4]
                fistp   [ebp+var_14]
                mov     eax, dword ptr [ebp+var_14]
                mov     [ecx-4], eax
                fstp    st
                fldcw   word ptr [ebp+var_4+2]
                jnz     short loc_10003F08
                fstp    st
                fstp    st
                fstp    st
                fstp    st
                fstp    st
                fstp    st

loc_10003F7C:                           ; CODE XREF: PreCalculateTreasureClassNoDropTbl+A5j
                add     ebx, 1
                add     esi, 2Ch
                add     edi, 38h
                cmp     ebx, [ebp+var_18]
                jl      loc_10003E90

loc_10003F8E:                           ; CODE XREF: PreCalculateTreasureClassNoDropTbl+50j
                                        ; PreCalculateTreasureClassNoDropTbl+65j
                mov     eax, [ebp+var_1C]
                pop     ebx
                pop     edi
                pop     esi
                mov     esp, ebp
                pop     ebp
                retn
; ---------------------------------------------------------------------------

loc_10003F98:                           ; CODE XREF: PreCalculateTreasureClassNoDropTbl+1Aj
                                        ; PreCalculateTreasureClassNoDropTbl+22j ...
                pop     edi
                xor     eax, eax
                pop     esi
                mov     esp, ebp
                pop     ebp
                retn
PreCalculateTreasureClassNoDropTbl endp

CalculateTreasureClassNoDropPatch proc
	; edi=����
	mov	eax,EnablePreCalculateTCNoDropTbl
	test eax,eax
	jz orig_code
	; ʹ��Ԥ�����TC NoDrop
  mov     esi, ds:6FDF114Ch ;start address
  mov     ebx, ds:6FDF1150h
;  test esi,esi
;  jz orig_code
;  test ebx,ebx
;  jz orig_code
  
	mov eax,[esp+3Ch]	; the record address
;	cmp eax,esi
;	jl orig_code
	
;	mov ecx,ebx
;	imul ecx,2Ch
;	mov ebx,esi
;	add ebx,ecx
;	cmp eax,ebx
;	jg orig_code
	
	sub eax,esi
	xor edx,edx
	mov ecx,2Ch
	div ecx
;	test edx,edx
;	jnz orig_code
	
	;eaxָ���¼���
	mov ebx,[esp+30h] ;��Ϸ����d2x=1��d2c=0
	xor ecx,ecx
	test ebx,ebx
	jz d2c
	mov ecx,28
d2c:	
	imul eax,56	;56���ֽ�һ����¼
	mov ebx,PreCalculateTCNoDropTbl
	lea ebx,[eax+ebx]
	lea esi,[ebx+ecx]
	dec edi
	dec edi

	mov esi,[esi+edi*4]
	mov [esp+10h],esi
	pop eax
	mov eax,D2GAME
	mov eax,[eax]
	add eax,0D21BFh
	push eax
	ret
orig_code:
	mov ecx,[esp+14h]
	fild dword ptr [esp+10h]
	ret
CalculateTreasureClassNoDropPatch endp
end start
