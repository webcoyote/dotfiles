@echo off

set SUBLIME=C:\Program Files\Sublime Text 3\sublime_text.exe
if exist "%SUBLIME%" goto run
echo ERROR: Sublime text not found
exit /b 1

:run
for %%f in (%*) do start "Sublime" "%SUBLIME%" "%%f"
start "Sublime" "%SUBLIME%"
