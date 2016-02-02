# apply_powertop_recommended_settings
Creates a shell script to automatically apply powertop's recommended power settings under Linux

This bash script generates another script that applies the optimal settings for your device as determinedby  powertop

If you don't ever need to change anything it should be equivalent to running 

```
sudo powertop --auto-tune
```

However, if you do need to change things (e.g. to avoid applying power saving to a particular device like a mouse or trackpad) then it gives you an easy way to disable various settings.  

Just comment out (put a # in front of) the lines of the script that you don't want to run.  Each setting includes the descriptive text as a comment so you know what it's doing

E.g.
```  
#Runtime PM for PCI Device InnoTek Systemberatung GmbH VirtualBox Graphics Adapter
echo 'auto' > '/sys/bus/pci/devices/0000:00:02.0/power/control';

#Runtime PM for PCI Device InnoTek Systemberatung GmbH VirtualBox Guest Service
echo 'auto' > '/sys/bus/pci/devices/0000:00:04.0/power/control';
```

It only requires powertop, perl, and sed; all of which should be available in your distribution's default repositories
