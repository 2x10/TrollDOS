
----------------------------------------------------------------------------
               Patch to fix conflict between MBD-C6XSM and
                Ensoniq Audio PCI sound card (SND-ENSAPCI)
----------------------------------------------------------------------------


Issue:
------
When playing any sound file under Real DOS mode, an initialization error
"AudioPCI legacy device was not found" will appear.



Procedure:
----------

1) Create a system startup disk from Windows 95 as follows:
      - Click on "Start" button, point to "Settings" then click on
        "Control Panel".
      - Click on the "Add/Remove Programs" icon, then click on the
        "Setup Disk" tab.
      - Insert a blank diskette into Drive A:, then click on "Create Disk..."
        to create a startup diskette.

2) Extract all the patch file onto the system startup disk by typing:

          C6XSMFIX  A:

3) Leave the system startup disk in Drive A:, then reboot the system.
   This will automatically modify the sound card driver.
