@echo off
:hexDump [/option]... file  -- dump a file in hex format
::
::  Displays the content of a binary file using a pair of hexadecimal digits
::  for each byte. By default the ouput displays 16 bytes per line, with the
::  the bytes (hexadecimal pairs) delimited by a space.
::
::  The format of the dump can be modified by the following case insensitive
::  options:
::
::    /BblockSize   The blockSize after the /B specifies the number of bytes
::                  to print in each block. Bytes within a block are not
::                  delimited. If the blockSize is <= 0 then /C, /A and /O
::                  options are ignored and the bytes are output in a
::                  continuous stream without any delimiters or linebreaks.
::                  The default blockSize is 1.
::
::    /CblockCount  The blockCount after the /C specifies the number of blocks
::                  to include on each line of output. Blocks are delimited
::                  by a space.
::                  The default blockCount is 16.
::
::    /SstartOffset The startOffset after the /S specifies the number of bytes
::                  to skip before displaying bytes.
::                  The default startOffset is 0.
::
::    /Nlengh       The length after the /N specifies the total number of
::                  bytes to display after the startOffset. The default is to
::                  display up until the end of the file.
::
::    /A            Append the ASCII representation of the bytes to the end
::                  of each line. Non-printable and extended ASCII characters
::                  are displayed as periods.
::
::    /O            Prefix each line with the starting offset of the line in
::                  hexadecimal notation.
::
::  Each option must be entered as a separate argument.
::
  setlocal enableDelayedExpansion
  set /a blockSize=1, blockCount=16, startOffset=0
  set ascii=
  set offset=
  set len=
  set opts=
  for %%a in (%*) do (
    if not defined opts (
      set "arg=%%~a"
      if "!arg:~0,1!"=="/" (
        shift /1
        set "opt=!arg:~1,1!"
        if /i "!opt!"=="B" set /a blockSize=!arg:~2!
        if /i "!opt!"=="C" set /a blockCount=!arg:~2!
        if /i "!opt!"=="S" set /a startOffset=!arg:~2!
        if /i "!opt!"=="N" set /a len=!arg:~2!
        if /i "!opt!"=="A" set "ascii=  "
        if /i "!opt!"=="O" set offset=TRUE
      ) else set opts=TRUE
    )
  )
  if not exist %1 (
    echo ERROR: File not found >&2
    exit /b 1
  )
  set fileSize=%~z1
  if defined len (
    set /a "endOffset = startOffset + len"
    if !endOffset! gtr %fileSise% set endOffset=%fileSize%
  ) else set endOffset=%fileSize%
  if defined offset set offset=%startOffset%
  set "blockDelim= "
  if %blockSize% lss 1 (
    set /a "blockSize=0, blockCount=2000"
    set "ascii="
    set "offset="
    set "blockDelim="
  )
  set dummy="!temp!\hexDumpDummy%random%.txt"
  <nul >%dummy% set /p ".=A"
  set dummySize=1
  for /l %%n in (1,1,32) do (if !dummySize! lss %endOffset% set /a "dummySize*=2" & type !dummy! >>!dummy!)
  set /a "pos=0, cnt=0, skipStart=startOffset+1, lnBytes=blockSize*blockCount"
  set "off="
  set "hex="
  set "txt=%ascii%"
  set map= ^^^!^"#$%%^&'^(^)*+,-./0123456789:;^<=^>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^^^^_`abcdefghijklmnopqrstuvwxyz{^|}~
  set hexMap=0123456789ABCDEF
  for /f "eol=F usebackq tokens=1,2 skip=1 delims=:[] " %%A in (`fc /b "%~dpf1" %dummy%`) do (
    set /a skipEnd=0x%%A && (
      if !skipEnd! geq %startOffset% if !skipStart! leq %endOffset% (
        for /l %%n in (!skipStart!,1,!skipEnd!) do call :hexDump.addChar 41
        call :hexDump.addChar %%B
        set /a skipStart=skipEnd+2
      )
    )
  )
  for /l %%n in (%skipStart%,1,%endOffset%) do call :hexDump.addChar 41
  if %blockSize%==0 if defined hex call :hexDump.writeLn
  for /l %%n in (1,1,%lnBytes%) do if defined hex call :hexDump.addChar "  "
  del %dummy%
  exit /b
  :hexDump.addChar  hexPair
    set "hex=!hex!%~1"
    if defined ascii (
      2>nul set /a "d=0x%1-32" && (
        if !d! lss 0 set d=14
        if !d! gtr 94 set d=14
        for %%d in (!d!) do set txt=!txt!!map:~%%d,1!
      )
    )
    if %blockSize% gtr 0 set /a pos+=1
    if !pos!==%blockSize% set /a "pos=0, cnt+=1"
    if not !cnt!==!blockCount! (
        if !pos!==0 set "hex=!hex!%blockDelim%"
         exit /b
      )
    set cnt=0
  :hexDump.writeLn
    if defined offset (
      set off=
      set dec=!offset!
      for /l %%n in (1,1,8) do (
        set /a "d=dec&15,dec>>=4"
        for %%d in (!d!) do set "off=!hexMap:~%%d,1!!off!"
      )
      set "off=!off!: "
      set /a offset+=lnBytes
    )
    set "ln=!off!!hex!!txt!"
    if %blockSize%==0 (<nul set /p ".=!ln!") else echo !ln!
    set hex=
    set "txt=%ascii%"
exit /b
