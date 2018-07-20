#!/bin/bash
set -eu               # Abort on errors and unset variables
IFS=$(printf '\n\t')  # IFS is only newline and tab

# Create a shell script to automatically apply powertop's recommened settings

# Copyright (C) 2016  Jesse McGraw (jlmcgraw@gmail.com)
#
#-------------------------------------------------------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see [http://www.gnu.org/licenses/].
#-------------------------------------------------------------------------------

# Text formatting codes
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# The name of the created script file
shell_script_file="./apply_recommended_power_settings.sh"

# Create the powertop csv output, outputs to "powertop.csv" by default
sudo powertop --csv --time=1

# Create the base shell script file to apply recommended settings
# <<- lets the heredoc ignore leading tabs so we can indent here for clarity
# tick-marks around EOF mean don't interpret variables
cat <<- 'EOF' > "$shell_script_file"
	#!/bin/bash
	set -eu               # Abort on errors and unset variables
	IFS=$(printf '\n\t')  # IFS is only newline and tab

	# Quit if we aren't root
	if [ ${UID} -ne 0 ]
	then
	    echo -e "Root privileges are needed to modify power settings\n"
	    exit 1
	fi

EOF

# Make the new script executable
chmod +x "$shell_script_file"

# Cut out the "recommended settings" section from CSV output using perl
# Remove first and last lines using sed
# Add column 1 as comment and column 2 as command to output shell script
#   using perl
cat powertop.csv | 
	perl -wlne '/^ Description [,;] Script/ix .. /^ [_]+ $/x and print' |  
	sed '1d;$d' | 
	perl -wlne '
	  if (/ ^ (.*?) [,;] (.*?) [,;] $/x) {
            # The key is the comment, the value is the script
	    $values{$1} = $2;
	  }
	  END {
	    foreach $key (sort keys %values) {
                print "# $key";
                print "$values{$key}\n";
                }
            }
	' >> "$shell_script_file"

# Quick advice on how to make the recommended settings take effect
echo "execute ${BOLD}sudo $shell_script_file${NORMAL} to make powertop's recommended settings take effect"
