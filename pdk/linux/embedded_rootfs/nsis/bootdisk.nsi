!include "MUI2.nsh"
!include "FileFunc.nsh"

!insertmacro GetDrives

;--------------------------------
;General

  ;Name and file
  Name "vBMC BootDisk"
  OutFile "bootdisk.exe"
  SetCompress off
  VIProductVersion "0.0.0.4"
  VIAddVersionKey  "ProductName" "vBMC BootDisk"
  VIAddVersionKey "CompanyName" "EMC"
  VIAddVersionKey "FileVersion" "0.4"


;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ;first language is the default language
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Icelandic"
  !insertmacro MUI_LANGUAGE "Malay"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Kurdish"
  !insertmacro MUI_LANGUAGE "Irish"
  !insertmacro MUI_LANGUAGE "Uzbek"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Esperanto"

;--------------------------------
;Reserve Files

  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.

  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------


Var DIALOG
Var DEVICE
Var DRIVESTR
Var TYPESTR

Page custom EntryPage CreateBootDisk ""
Page instfiles


Function EntryPage
	nsDialogs::Create 1018
    Pop $DIALOG

    ${NSD_CreateLabel} 0 0 60u 12u "Select Drive"
    Pop $R0
	${NSD_CreateDroplist} 80u 0 100 100  ""

    Pop $DEVICE
	${NSD_OnChange} $DEVICE db_select.onchange
	${GetDrives} "ALL" driveListFiller
	nsDialogs::Show
FunctionEnd


Function driveListFiller
	SendMessage $DEVICE ${CB_ADDSTRING} 0 "STR:$9"
	Push 1
FunctionEnd


Function db_select.onchange
	Pop $DEVICE
	${NSD_GetText} $DEVICE $0
    StrCpy $DRIVESTR $0
FunctionEnd


Function SetDriveType
	StrCmp $9 $R0 0 +3
	StrCpy $R1 $8
	StrCpy $0 StopGetDrives
	Push $0
FunctionEnd


Function CreateBootDisk

    CreateDirectory "C:\vBMC BootDisk\"
    SetOutPath "C:\vBMC BootDisk\"
    File ${RELEASEDIR}\vbmc.iso
    File ${LINUXDIR}\embedded_rootfs\iso\syslinux.exe
    CreateDirectory "C:\vBMC BootDisk\images\"
    SetOutPath "C:\vBMC BootDisk\images\"
    File ${LINUXDIR}\root_iso\isolinux\vmlinuz
    File ${LINUXDIR}\root_iso\isolinux\ramfs.lzma
    File ${LINUXDIR}\root_iso\isolinux\config
    File ${LINUXDIR}\root_iso\isolinux\System.map
    File ${LINUXDIR}\root_iso\isolinux\syslinux.cfg

    ; MessageBox MB_OK "Drive selected: $DRIVESTR"
    StrCpy $R0 "$DRIVESTR"
    StrCpy $R1 "invalid"

    ${GetDrives} "ALL" "SetDriveType"
    StrCpy $TYPESTR $R1
    ; MessageBox MB_OK "Type of drive $DRIVESTR is $TYPESTR"

    StrCmp "$TYPESTR" "CDROM" MakeROMDevice MakeUSBDevice
    MakeROMDevice:
    Pop $1
    StrCpy $1 $DRIVESTR 2 0
    MessageBox MB_OKCANCEL "Are you sure?  Create CD/DVD BootDisk on $1 ?" IDCANCEL End
    ExecWait 'isoburn.exe /Q "$1" "C:\vBMC BootDisk\vbmc.iso"'

    MakeUSBDevice:
    MessageBox MB_OKCANCEL "Are you sure?  Create USB BootDisk on $DRIVESTR ?" IDCANCEL End
    Pop $1
    StrCpy $1 $DRIVESTR 2 0
    ExecWait '"C:\vBMC BootDisk\syslinux.exe" -fma -d \ $1'
    ExecWait 'cmd.exe /C copy /Y /V "C:\vBMC BootDisk\images"\*.* $DRIVESTR'

    End:
FunctionEnd


Section ""
SectionEnd
