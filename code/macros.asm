;----------------------------------------
;	NES Macro for Asar
;----------------------------------------

macro org(address,bank)
    ; I think the way NES mappers work is that $8000-$BFFF was hardcoded to bank 0, then $C000-$FFFF was switchable
    ; If your mapper is different, edit this function accordingly
    if <bank> == 0
        org <address>-$8000+!headersize ; org sets the position in the output file to write to (in norom, at least)
        base <address> ; base sets the position that all labels are relative to - this is necessary so labels will still start from $8000, instead of $0000 or somewhere
    else
        org <address>-$8000+$4000*<bank>+!headersize
        base <address>
    endif
endmacro


macro fillto(address,bank,byte)
	if <bank> == 0
		padbyte <byte> : pad <address>-$8000+!headersize
	    else
		padbyte <byte> : pad <address>-$8000+$4000*<bank>+!headersize	
	endif
endmacro

