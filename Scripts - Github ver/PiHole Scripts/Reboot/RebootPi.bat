plink -ssh -l root -pw PASSWORD 192.192.192.192 "sudo reboot"
TIMEOUT /T 3
plink -ssh -l root -pw PASSWORD 192.192.192.192 "sudo reboot"