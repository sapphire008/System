REM run as administrator
net stop spooler
taskkill /IM printfilterpipelinesvc.exe /F
del %systemroot%\system32\spool\printers\*.shd
del %systemroot%\system32\spool\printers\*.spl
net start spooler
