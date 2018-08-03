# bme280-smokeping
Smokeping's probe for reading bme280 temperature data

Based on /usr/share/perl5/Smokeping/probes/skel.pm , Smokeping::probes::base

## Reading data
bme280.pm uses [bme280.py](https://bitbucket.org/MattHawkinsUK/rpispy-misc/raw/master/python/bme280.py)

## Install
```bash
sudo cp -v bme280-smoke.py /usr/bin/bme280-smoke.py
sudo chmod +x !$
# grant i2c access to smokeping user
sudo usermod -a -G i2c smokeping
```
## Configuration
```
--- a/smokeping/config.d/Probes
+++ b/smokeping/config.d/Probes
@@ -4,3 +4,10 @@
 
 binary = /usr/bin/fping
 
++BME280
+
+binary = /usr/bin/bme280-smoke.py # mandatory
+offset = 50%
+pings = 5
+step = 60
+
```
```
--- a/smokeping/config.d/Targets
+++ b/smokeping/config.d/Targets
@@ -57,3 +57,12 @@ menu = HE
 title = Hurricane Electric Tunnelbroker London
 host = tserv1.lon1.he.net
 
++ Temp
+menu = Temp
+title = Temperature 
+++ pi-BME280
+menu = pi-BME280
+title = Raspi bme280 temperature sensor
+probe = BME280
+temperature = 1
+host = localhost
```
