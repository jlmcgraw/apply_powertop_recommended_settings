# apply_powertop_recommended_settings
Creates a shell script to automatically apply powertop's recommended power settings under Linux

This bash script generates another script that applies the optimal settings for your device as determinedby  powertop

If you don't ever need to change anything it should be equivalent to running 

```
sudo powertop --auto-tune
```

However, if you do need to change things (e.g. to avoid applying power saving to a particular device like a mouse or trackpad) then it gives you a easy way to comment out various settings.  Just put a # in front of the lines you don't want to run

It only requires powertop, perl, and sed; all of which should be available in your distribution's default repositories
