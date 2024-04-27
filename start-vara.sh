#! /bin/sh

DISPLAY=:0
export DISPLAY

if [ ! -f ~/.wine/drive_c/VARA/VARA.exe ]; then
	wget https://downloads.winlink.org/VARA%20Products/VARA%20HF%20v4.8.7%20setup.zip
	unzip VARA*.zip
	DISPLAY=0 WINEARCH=win32 WINEDEBUG=-all wine wineboot
	mkdir -p ~/.cache/wine
	wget -q -P ~/.cache/wine https://dl.winehq.org/wine/wine-mono/7.2.0/wine-mono-7.2.0-x86.msi 
	wine msiexec /i ~/.cache/wine/wine-mono-7.2.0-x86.msi
	BOX86_DYNAREC=0 BOX86_NOBANNER=1 winetricks -q vb6run pdh_nt4 win7 sound=alsa
	mv 'VARA setup (Run as Administrator).exe' .wine/drive_c/vara_setup.exe
	wine ~/.wine/drive_c/vara_setup.exe /SILENT
fi
wine ~/.wine/drive_c/VARA/VARA.exe
exit $?
