# sdrplay_dump1090
Docker container for ADS-B - This is the flightaware dump1090 component

This is part of a suite of applications that can be used to feed ADSB data with compatible devices including:
* RSP1, RSP1A, RSP2, RSPDuo (single tuner mode) SDRPlay devices
* Any RTLSDR USB device
* Any network AVR or BEAST device

# Container Setup

Ensure you pass your USB device path.
Also make sure you add the capability ```--cap-add=SYS_NICE``` otherwise you will get errors (this helps it play nice ;) )
### Defaults
* Port 30002/tcp is used for raw output and is exposed by default
* Port 30003/tcp is used for BaseStation output and is exposed by default
* Port 30005/tcp is for Beast output and is exposed by default

### User Configured
* No user configurable options

#### Example docker run

```
docker run -d \
--restart unless-stopped \
--name='dump1090' \
--cap-add=SYS_NICE \
--device=/dev/bus/usb \
f4fhh/sdrplay_dump1090
```
### HISTORY
 - Version 0.1.0: Initial build

### Credits
 - [SDRPlay](https://github.com/SDRplay) for the SDK of the RSP devices
