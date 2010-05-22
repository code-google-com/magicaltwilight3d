@echo off
jpg2tga.exe sk_free1_256+6.jpg sk_free1_256+6.tga
echo decompress sk_free1_256+6
jpg2tga.exe sk_free1_512+6.jpg sk_free1_512+6.tga
echo decompress sk_free1_512+6
jpg2tga.exe sk_free2_256+6.jpg sk_free2_256+6.tga
echo decompress sk_free2_256+6
jpg2tga.exe sk_free2_512+6.jpg sk_free2_512+6.tga
echo decompress sk_free2_512+6
jpg2tga.exe sk_free3_256+6.jpg sk_free3_256+6.tga
echo decompress sk_free3_256+6
jpg2tga.exe sk_free3_512+6.jpg sk_free3_512+6.tga
echo decompress sk_free3_512+6
jpg2tga.exe sk_free4_256+6.jpg sk_free4_256+6.tga
echo decompress sk_free4_256+6
jpg2tga.exe sk_free4_512+6.jpg sk_free4_512+6.tga


if exist sk_free1_256+6.tga del sk_free1_256+6.jpg > nul 
if exist sk_free1_512+6.tga del sk_free1_512+6.jpg > nul
if exist sk_free2_256+6.tga del sk_free2_256+6.jpg > nul
if exist sk_free2_512+6.tga del sk_free2_512+6.jpg > nul
if exist sk_free3_256+6.tga del sk_free3_256+6.jpg > nul
if exist sk_free3_512+6.tga del sk_free3_512+6.jpg > nul
if exist sk_free4_256+6.tga del sk_free4_256+6.jpg > nul
if exist sk_free4_512+6.tga del sk_free4_512+6.jpg > nul
pause done