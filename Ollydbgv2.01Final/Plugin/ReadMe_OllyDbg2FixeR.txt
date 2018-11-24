Title: OllyDbg2FixeR 201.02
Author: quygia128
Home: http://cin1team.biz
	
Description:  

    - "OllyDbg2FixeR" is a plugin for OllyDbg201(I).                  

    - OllyDbg2FixeR allow to Fix OllyDbg Assemble BUG when you        
    press Space/DoubleClick on CALL/JUMP commands.                   

    if you had choose "Show Symbolic Addresses" in OllyDbg Options,   
    This BUG only decode by Name of API/Label when it's exist.       

    You must be checked in "Fix Assemble" Menu to Fix BUG and         
    Uncheck if you want to ReStore Assemble as default of ollyDbg.
		
    You can also add new parameter by manual for OllyDbg2FixeR to    
    Patch OllyDbg, include (ManualPatch, Address, OldByte       
    NewByte, PatchLen, PatchTime)                                              

    ManualPatch must be = 1 (Flag to Enable)                          
    PathTime must be valid.                                           
    Address[x] must be valid.                                          
    PatchLen[x] must be <= 1024 Byte.                                    
    OldByte[x] = Original Byte at adress.                                
    NewByte[x] = New Byte to patch at address.                          
    See "OllyDbg2FixeR.png" for more detail.
	
    It's easy to fix SMALL BUG of OllyDbg automatic way when 
    you run OllyDbg with OllyDbg2FixeR Plugin.

[OllyDbg2FixeR]
Fix Assemble=1
ManualPatch=1
Address1=0070D80E
OldByte1=90909090909090 
NewByte1=83FA1B740AEBE9
PatchLen1=7
Address2=0072D80E
OldByte2=NIL
NewByte2=83FA1B740AEBE9
PatchLen2=7
PatchTime=2
[Example]
//This Config To Fix(KeyBug) In SnD 2.2 and SnD 2.3 	