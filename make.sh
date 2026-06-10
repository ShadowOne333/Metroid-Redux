#! /bin/bash -e
#-------------------------------------------------------------
# Variables used for the script
export	time=$(date +'%T %a %d/%b/%Y')
export	asar=bin/asar-standalone
export	flips=bin/flips
export	file_base=Metroid-Redux
export  out_folder=out
export	patches_folder=patches
export  clean_rom=rom/Metroid.nes
export  patched_rom=$out_folder/$file_base.nes
export  asm_file=code/main.asm
export	checksum=166a5b1344b17f98b6b18794094f745f8a7435b8
#-------------------------------------------------------------
# Help section
Help()
{
   # Display Help
   echo "Compile 'Metroid Redux' with one of the following arguments:"
   echo
   echo "Syntax: make.sh [option]"
   echo "Options:"
   echo "	-h, --help	Prints this menu."
}
#-------------------------------------------------------------
# Begin compilation
Start()
{
# Check base ROM name
	if [ -e "rom/Metroid (U).nes" ]; then
		echo "ROM detected. Verifying name..."
	else
		export error="Incorrect ROM name."
		Error;	
		echo "Please, rename the ROM to 'Metroid (U).nes' to begin the patching process."
		End;
	fi
#-------------------------------------------------------------
# Copy base ROM into the /out/ folder
	cd rom/ && cp "Metroid (U).nes" Metroid.nes && cd ..
	test ! -d "$out_folder" && mkdir "$out_folder"
	test -f "$patched_rom" && rm "$patched_rom"
#-------------------------------------------------------------
# SHA-1 sum verification
	if [ -f "$clean_rom" ]; then
		echo; echo "Base ROM detected with proper name."
		echo "Verifying SHA-1 checksum hash..."
	else
		export error="Base ROM not found."
		Error;
		echo "Place the 'Metroid (U).nes' ROM inside the 'rom' folder."
		End;
	fi

	export	sha1=$(sha1sum "$clean_rom" | awk '{ print $1 }')
#-------------------------------------------------------------
# SHA-1 sum verified, begin patching...
	if [ "$sha1" == "$checksum" ]; then
		echo; echo "Base ROM SHA-1 checksum verified."
		echo "Starting patching process..."; echo
	else
		export error="Base ROM checksum is incorrect."
		Error;
		echo "Use a Metroid ROM with the proper SHA-1 checksum for patching."
		End;
	fi
#-------------------------------------------------------------
# Copy clean ROM into a base used for patching to keep clean ROM intact
	cp "$clean_rom" "$patched_rom"
#-------------------------------------------------------------
# Compile the main assembly code

	# Patch "Metroid Mother", then "Saving Unofficial 0.5.2"
	#echo "Patching 'Metroid Mother' patch...";
	#$flips -a -i "patches/Mother.ips" "$patched_rom"
	#echo "Patching 'Metroid+Saving' Unofficial' patch...";
	#$flips -a -i "patches/Saving.ips" "$patched_rom"

	echo "Beginning main assembly code compilation with Asar..."; echo
	$asar --no-title-check --fix-checksum=off $asm_file $patched_rom	# Main code
	
	echo "Main assembly code compilation succeded!"; echo

	# Create IPS
	echo "Creating $file_base.ips patch...";
	$flips -c -i "$clean_rom" "$patched_rom" "$patches_folder/$file_base.ips"
#-------------------------------------------------------------
# Finish script and jump to the "End" function
	echo "Redux compilation finished at $time!"
	End
}
#-------------------------------------------------------------
# Error message
Error()
{
	echo; echo "Redux compilation exited with errors!"
	echo "ERROR: $error"
}
#-------------------------------------------------------------
# Finish script
End()
{
	if [ -f "$clean_rom" ]; then
		rm $clean_rom
	fi

	cp "patches/$file_base.ips" "patches/Metroid Redux.ips"
	rm "patches/$file_base.ips"

	sleep 1
	exit
}
#-------------------------------------------------------------
# Get the options
if [[ "$1" == "" ]];then
    Start;
    exit;
else
	while [ ! -z "$1" ]; do
		# Check each argument do determine action
		case "$1" in
		--help|-h) # Display Help
			Help
			exit;;
		#\?) # Invalid option
		*) # Invalid option
			echo "Error: Invalid option '$1'"
			Help
			exit;;
		esac
	shift
	done
fi
#-------------------------------------------------------------
