#!/bin/bash

source config
source functions

export provide_i386
export install_subdir
export pxe_inst="$pxe_dir/$install_subdir"

rm -rf "$pxe_inst"

inmenu=""
for distri in "${distributions[@]}" ; do
	if [[ $distri =~ ^!.* ]] ; then
		continue
	fi
	echo "### $distri:"
	mkdir -p "$pxe_inst/$distri/"
	"./distri/$distri" "${version_limit[$distri]}" >> "$pxe_inst/$distri/menu"

	pname=`capitalize_first $distri`
	inmenu="$inmenu
	# START INSTALL DISTRI $distri
		menu begin $distri
			menu title $pname Installation
			label mainmenu
				menu label Back..
				menu exit
			include install/$distri/menu
		menu end
	# END INSTALL DISTRI $distri
	"
	echo
	echo
done

inmenu="
# START INSTALL
	menu begin install
		menu title Linux Installation
		label mainmenu
			menu label Back..
			menu exit
		$inmenu
	menu end
# END INSTALL
"

echo "$inmenu" > "$pxe_inst/menu"
