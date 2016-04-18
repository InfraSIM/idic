!include "FileFunc.nsh"
!include "LogicLib.nsh"

; StrContains
; This function does a case sensitive searches for an occurrence of a substring in a string.
; It returns the substring if it is found.
; Otherwise it returns null("").
; Written by kenglish_hi
; Adapted from StrReplace written by dandaman32


Var STR_HAYSTACK
Var STR_NEEDLE
Var STR_CONTAINS_VAR_1
Var STR_CONTAINS_VAR_2
Var STR_CONTAINS_VAR_3
Var STR_CONTAINS_VAR_4
Var STR_RETURN_VAR

Function StrContains
  Exch $STR_NEEDLE
  Exch 1
  Exch $STR_HAYSTACK
  ; Uncomment to debug
  ;MessageBox MB_OK 'STR_NEEDLE = $STR_NEEDLE STR_HAYSTACK = $STR_HAYSTACK '
    StrCpy $STR_RETURN_VAR ""
    StrCpy $STR_CONTAINS_VAR_1 -1
    StrLen $STR_CONTAINS_VAR_2 $STR_NEEDLE
    StrLen $STR_CONTAINS_VAR_4 $STR_HAYSTACK
    loop:
      IntOp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_1 + 1
      StrCpy $STR_CONTAINS_VAR_3 $STR_HAYSTACK $STR_CONTAINS_VAR_2 $STR_CONTAINS_VAR_1
      StrCmp $STR_CONTAINS_VAR_3 $STR_NEEDLE found
      StrCmp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_4 done
      Goto loop
    found:
      StrCpy $STR_RETURN_VAR $STR_NEEDLE
      Goto done
    done:
   Pop $STR_NEEDLE ;Prevent "invalid opcode" errors and keep the
   Exch $STR_RETURN_VAR
FunctionEnd

!macro _StrContainsConstructor OUT NEEDLE HAYSTACK
  Push "${HAYSTACK}"
  Push "${NEEDLE}"
  Call StrContains
  Pop "${OUT}"
!macroend




!define StrContains '!insertmacro "_StrContainsConstructor"'
; ############################################################
; ${NSD_CB_GetCount} combo_HWND output_variable
; Retrieves the number of strings from a combobox
; ############################################################
!macro __NSD_CB_GetCount CONTROL VAR
  SendMessage ${CONTROL} ${CB_GETCOUNT} 0 0 ${VAR}
!macroend
!define NSD_CB_GetCount `!insertmacro __NSD_CB_GetCount`

; ############################################################
;  Combobox Delete String macro, defines API for CB
; ############################################################
!macro __NSD_CB_DelString CONTROL STRING
  SendMessage ${CONTROL} ${CB_FINDSTRING} -1 `STR:${STRING}` $R0
  SendMessage ${CONTROL} ${CB_DELETESTRING} $R0 0
!macroend
!define NSD_CB_DelString `!insertmacro __NSD_CB_DelString`



Function WriteINIStrNS
 Exch $R0 ; new value
 Exch
 Exch $R1 ; key
 Exch 2
 Exch $R2 ; ini file
 Exch 2
 Push $R3
 Push $R4
 Push $R5
 Push $R6
 Push $R7
 Push $R8
 Push $R9

  StrCpy $R9 0

  FileOpen $R3 $R2 r
  GetTempFileName $R4
  FileOpen $R5 $R4 w

  LoopRead:
   ClearErrors
   FileRead $R3 $R6
   IfErrors End

   StrCpy $R7 -1
   LoopGetVal:
    IntOp $R7 $R7 + 1
    StrCpy $R8 $R6 1 $R7
    StrCmp $R8 "" LoopRead
    StrCmp $R8 = 0 LoopGetVal

     StrCpy $R8 $R6 $R7
     StrCmp $R8 $R1 0 +4

      FileWrite $R5 "$R1=$R0$\r$\n"
      StrCpy $R9 1
      Goto LoopRead

    FileWrite $R5 $R6
    Goto LoopRead

  End:
   StrCmp $R9 1 +2
   FileWrite $R5 "$R1=$R0$\r$\n"

  FileClose $R5
  FileClose $R3

  SetDetailsPrint none
  Delete $R2
  Rename $R4 $R2
  SetDetailsPrint both

 Pop $R9
 Pop $R8

 Pop $R7
 Pop $R6
 Pop $R5
 Pop $R4
 Pop $R3
 Pop $R2
 Pop $R1
 Pop $R0
FunctionEnd

!define WriteINIStrNS "!insertmacro WriteINIStrNS"
!macro WriteINIStrNS Var File Key Value
 Push "${File}"
 Push "${Key}"
 Push "${Value}"
  Call WriteINIStrNS
 Pop "${Var}"
!macroend


; ################################################################
; appends \ to the path if missing
; example: !insertmacro GetCleanDir "c:\blabla"
; Pop $0 => "c:\blabla\"
!macro GetCleanDir INPUTDIR
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_GetCleanDir 'GetCleanDir_Line${__LINE__}'
  Push $R0
  Push $R1
  StrCpy $R0 "${INPUTDIR}"
  StrCmp $R0 "" ${Index_GetCleanDir}-finish
  StrCpy $R1 "$R0" "" -1
  StrCmp "$R1" "\" ${Index_GetCleanDir}-finish
  StrCpy $R0 "$R0\"
${Index_GetCleanDir}-finish:
  Pop $R1
  Exch $R0
  !undef Index_GetCleanDir
!macroend



; ################################################################
; similar to "RMDIR /r DIRECTORY", but does not remove DIRECTORY itself
; example: !insertmacro RemoveFilesAndSubDirs "$INSTDIR"
!macro RemoveFilesAndSubDirs DIRECTORY
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_RemoveFilesAndSubDirs 'RemoveFilesAndSubDirs_${__LINE__}'

  Push $R0
  Push $R1
  Push $R2

  !insertmacro GetCleanDir "${DIRECTORY}"
  Pop $R2
  FindFirst $R0 $R1 "$R2*.*"
${Index_RemoveFilesAndSubDirs}-loop:
  StrCmp $R1 "" ${Index_RemoveFilesAndSubDirs}-done
  StrCmp $R1 "." ${Index_RemoveFilesAndSubDirs}-next
  StrCmp $R1 ".." ${Index_RemoveFilesAndSubDirs}-next
  IfFileExists "$R2$R1\*.*" ${Index_RemoveFilesAndSubDirs}-directory
  ; file
  Delete "$R2$R1"
  goto ${Index_RemoveFilesAndSubDirs}-next
${Index_RemoveFilesAndSubDirs}-directory:
  ; directory
  RMDir /r "$R2$R1"
${Index_RemoveFilesAndSubDirs}-next:
  FindNext $R0 $R1
  Goto ${Index_RemoveFilesAndSubDirs}-loop
${Index_RemoveFilesAndSubDirs}-done:
  FindClose $R0

  Pop $R2
  Pop $R1
  Pop $R0
  !undef Index_RemoveFilesAndSubDirs
!macroend

Function StrRep
  Exch $R4 ; $R4 = Replacement String
  Exch
  Exch $R3 ; $R3 = String to replace (needle)
  Exch 2
  Exch $R1 ; $R1 = String to do replacement in (haystack)
  Push $R2 ; Replaced haystack
  Push $R5 ; Len (needle)
  Push $R6 ; len (haystack)
  Push $R7 ; Scratch reg
  StrCpy $R2 ""
  StrLen $R5 $R3
  StrLen $R6 $R1
loop:
  StrCpy $R7 $R1 $R5
  StrCmp $R7 $R3 found
  StrCpy $R7 $R1 1 ; - optimization can be removed if U know len needle=1
  StrCpy $R2 "$R2$R7"
  StrCpy $R1 $R1 $R6 1
  StrCmp $R1 "" done loop
found:
  StrCpy $R2 "$R2$R4"
  StrCpy $R1 $R1 $R6 $R5
  StrCmp $R1 "" done loop
done:
  StrCpy $R3 $R2
  Pop $R7
  Pop $R6
  Pop $R5
  Pop $R2
  Pop $R1
  Pop $R4
  Exch $R3
FunctionEnd





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reverse a string
;; P1 :o: Reversed string
;; P2 :i: Original string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!define StrRev "!insertmacro _StrRev"
!macro _StrRev _REV_ _STR_
   Push "${_STR_}"
   Call StrRev
   Pop ${_REV_}
!macroend


Function StrRev
   Exch $1  ;; Orig string
   Push $0  ;; Reversed string
   Exch
   Push $2  ;; String Len / Counter
   Push $3  ;; Current character

   StrCpy $0 ""
   StrLen $2 "$1"

   IntCmp $2 0 +5
      IntOp $2 $2 - 1
      StrCpy $3 "$1" 1 $2
      StrCpy $0 "$0$3"
      Goto -4

   Pop $3
   Pop $2
   Pop $1
   Exch $0
FunctionEnd

!define Trim "!insertmacro Trim"

!macro Trim ResultVar String
  Push "${String}"
  Call Trim
  Pop "${ResultVar}"
!macroend

; Trim
;   Removes leading & trailing whitespace from a string
; Usage:
;   Push
;   Call Trim
;   Pop
Function Trim
	Exch $R1 ; Original string
	Push $R2

Loop:
	StrCpy $R2 "$R1" 1
	StrCmp "$R2" " " TrimLeft
	StrCmp "$R2" "$\r" TrimLeft
	StrCmp "$R2" "$\n" TrimLeft
	StrCmp "$R2" "$\t" TrimLeft
	GoTo Loop2
TrimLeft:
	StrCpy $R1 "$R1" "" 1
	Goto Loop

Loop2:
	StrCpy $R2 "$R1" 1 -1
	StrCmp "$R2" " " TrimRight
	StrCmp "$R2" "$\r" TrimRight
	StrCmp "$R2" "$\n" TrimRight
	StrCmp "$R2" "$\t" TrimRight
	GoTo Done
TrimRight:
	StrCpy $R1 "$R1" -1
	Goto Loop2

Done:
	Pop $R2
	Exch $R1
FunctionEnd


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reverse a string
;; P1 :o: Reversed string
;; P2 :i: Original string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!define SplitFirstStrPart "!insertmacro _SplitFirstStrPart"
!macro _SplitFirstStrPart _FirstPart_ _LatterPart_ _SPLITTER_ _STR_
   Push "${_SPLITTER_}"
   Push "${_STR_}"
   Call SplitFirstStrPart
   Pop  ${_FirstPart_}
   Pop ${_LatterPart_}
!macroend


Function SplitFirstStrPart
  Exch $R0
  Exch
  Exch $R1
  Push $R2
  Push $R3
  StrCpy $R3 $R1
  StrLen $R1 $R0
  IntOp $R1 $R1 + 1
  loop:
    IntOp $R1 $R1 - 1
    StrCpy $R2 $R0 1 -$R1
    StrCmp $R1 0 exit0
    StrCmp $R2 $R3 exit1 loop
  exit0:
  StrCpy $R1 ""
  Goto exit2
  exit1:
    IntOp $R1 $R1 - 1
    StrCmp $R1 0 0 +3
     StrCpy $R2 ""
     Goto +2
    StrCpy $R2 $R0 "" -$R1
    IntOp $R1 $R1 + 1
    StrCpy $R0 $R0 -$R1
    StrCpy $R1 $R2
  exit2:
  Pop $R3
  Pop $R2
  Exch $R1 ;rest
  Exch
  Exch $R0 ;first
FunctionEnd
