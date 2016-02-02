#!/bin/bash
#set -eu              # Abort on errors and unset variables
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

#The name of the created script file
shell_script_file="apply_recommended_power_settings.sh"

#Create the powertop csv output, outputs to "powertop.csv" by default
sudo powertop --csv

#Create the base shell script file to apply recommended settings
# <<- lets the heredoc ignore leading tabs so we can indent here for clarity
# tick-marks around EOF mean don't interpret variables
cat <<- 'EOF' > "$shell_script_file"
	#!/bin/bash
	set -eu               # Abort on errors and unset variables
	IFS=$(printf '\n\t')  # IFS is only newline and tab

	#Quit if we aren't root
	if [ ${UID} -ne 0 ]
	then
	    echo -e "Root privileges needed. Exit.\n\n"
	    exit 1
	fi

EOF

#Make the new script executable
chmod +x "$shell_script_file"

#Cut out the recommended settings section from CSV output using perl
# remove first 3 and last lines using sed
# Add column 1 as comment and column 2 as command using perl
cat powertop.csv | 
	perl -wlne '/Software Settings in Need of Tuning/ .. /^____________________________________________________________________/ and print' |  
	sed '1,3d;$d' | 
	perl -lne '
	  if (/^(.*),(.*)$/) {
	    $values{$1} = $2;
	  }
	  END {
	    foreach $key (sort keys %values) {
                print "#$key";
                print "$values{$key}\n";
                }
            }
	' >> "$shell_script_file"

#Quick advice on how to make the recommended settings take effect
echo "execute 'sudo "$shell_script_file"' to make powertop's recommended settings take effect"
