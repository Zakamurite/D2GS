@ECHO OFF

IF NOT EXIST C:\Masm32\Bin\Ml.Exe GOTO _NoMasm32

IF EXIST %1.obj DEL %1.obj
IF EXIST %1.asm C:\MASM32\Bin\Ml.exe /IC:\MASM32\Include /c /coff %1.asm
IF EXIST Resource.rc GOTO _ExistRC
IF EXIST %1.obj C:\MASM32\Bin\Link.exe /BASE:0x68020000 /SUBSYSTEM:Console /LIBPATH:C:\MASM32\Lib %1.obj
GOTO _Done

:_ExistRC
IF NOT EXIST Resource.res C:\MASM32\Bin\Rc.exe /iC:\MASM32\Include Resource.rc
IF EXIST %1.obj C:\MASM32\Bin\Link.exe /SUBSYSTEM:Windows /LIBPATH:C:\MASM32\Lib %1.obj Resource.res

:_Done:
IF EXIST %1.obj DEL %1.obj
GOTO :_End

:_NoMasm32
ECHO Could not find "C:\Masm32\Bin\Ml.Exe".

:_End