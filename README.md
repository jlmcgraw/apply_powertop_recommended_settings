# apply_powertop_recommended_settings
Creates a shell script to automatically apply powertop's recommended power settings under Linux

I've been using powertop to optimize the power settings of my Linux laptop for a while now but never have been able to get it to save and re-use its recommended settings so I've just been doing that manually every time I happen to reboot.

I finally got tired of doing this so I wrote a short bash script that generates another script that will automatically apply the optimal settings as advised by powertop

It only requires powertop, perl, sed and cut; all of which should be available in your distribution's default repositories
