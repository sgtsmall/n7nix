## DRAWS Raspberry Pi image

###### Download the image file

* [Go to the download site](http://nwdig.net/downloads/) to find the current filename of the image
  * You can get the image using the following or just click on the filename using your browser.
```bash
wget http://nwdig.net/downloads/<draws_download_file_name>
```

###### Unzip the image file
```bash
unzip <draws_image_download_file_name>
```
###### Provision an SD card
* At least an 8GB microSD card is recommend
```
time dcfldd if=<draws_image_download_file_name> of=/dev/sdf bs=4M
```

* Boot the new microSD card

###### Configure core functionality

* If you want direwolf functionality with the draws hat do this:

```bash
cd
cd n7nix/config
sudo su
./app_config.sh core
```

* This will run a script that sets up AX.25, direwolf & systemd

* **Now reboot your RPi** & [verify your installation is working properly](https://github.com/nwdigitalradio/n7nix/blob/master/VERIFY_CONFIG.md)


###### More program options

* After confirming that the core functionality works you can configure rmsgw, paclink-unix or some other packet
program that requires direwolf:

```bash
./app_config.sh rmsgw
./app_config.sh plu
```

* If you want to run some other program that does NOT use direwolf like: jscall, wsjtx, fldigi, then do this:
```bash
cd
cd bin
sudo su
./ax25-stop
```
* This will bring down direwolf & all the ax.25 services allowing another program to use the DRAWS sound card.
* To stop direwolf & the AX.25 stack from running after a boot do this:
```bash
cd
cd bin
sudo su
./ax25-disable
```