#!/usr/bin/env python
from netmiko import ConnectHandler
from datetime import datetime
import yaml
import re
import sys
import logging
import re

firmware={'50E62':'FGT_50E-v6-build1378-FORTINET.out',
        '80F70':'FGT_80F-v7.0.13.M-build0566-FORTINET.out',
         '80F64':'FGT_80F-v6.M-build2093-FORTINET.out'
}

#re.findall(r"(?<=build)\w{4}", s, re.IGNORECASE)
#re.findall(r"(?<=-)\w{4}", s, re.IGNORECASE)
#re.findall(r"Forti.*-\w{0,3}", s, re.IGNORECASE)
#re.findall(r"(FortiGate-)(\w{0,4})", s, re.IGNORECASE)
#re.findall(r"(Forti.*-)(\w{0,4})", s1, re.IGNORECASE)


inv="""
device:
- access: {device_type: fortinet, ip: 10.68.100.254, password: Password, port: 22, username: admin}
  model: '80F70'
  tftp: 'IP'
  run: False
  force: False
  name: Fortinet_Example

"""

inventory=yaml.safe_load(inv)
keyenable='enable'
logging.basicConfig(filename='netmiko.log', level=logging.DEBUG)
logger = logging.getLogger("netmiko")

for i in range(len(inventory['device'])):
  try:
    print('\n\n'+inventory['device'][i]['name']+': processing................................................')
    net_connect = ConnectHandler(**(inventory['device'][i]['access']))
    if(keyenable in inventory['device'][i]):
      net_connect.enable()

    result=re.findall(r'fortinet', inventory['device'][i]['access']['device_type'])
    if result:

      firm=firmware.get(inventory['device'][i]['model'],None)
      if(firm==None):
        print("no firmware found, skip")
        continue

      print(net_connect.find_prompt())
      output = net_connect.send_command("get system status | grep Version")
      print(output)
      ssys=""
      found=re.findall(r"Forti.*-\w{0,3}", output, re.IGNORECASE)
      if found:
        ssys=re.findall(r"(?<=build)\d{4}",output)[0]
        print("model found:",found[0],firm)
      else:
        print("model not found, skip")
        continue

      cmd="execute restore image tftp "+firmware[inventory['device'][i]['model']]+" "+inventory['device'][i]['tftp']
      print("cmd:",cmd)

      sfirm=re.findall(r"(?<=build)\d{4}",firm)[0]
      ifirm=int(sfirm)
      print(firm,sfirm,ifirm)

      isys=int(ssys)
      print(ssys,isys)


      if (ifirm <= isys) and not inventory['device'][i]['force']:
        print("firmware does not meet version, skip")
        continue

      print(ifirm,firmware[inventory['device'][i]['model']])
      print(isys,ssys)

      if(inventory['device'][i]['run']):
        output = net_connect.send_command(cmd,expect_string=r"continue",strip_prompt=False,strip_command=False)
        print(output)
        print("accept Y")
        output = net_connect.send_command("y",expect_string=r"restart|Return code",strip_prompt=False,strip_command=False,normalize=False,read_timeout=600)
        print(output)
      else:
        print("running disabled")

  except Exception as e: print ('%s: %s' %(inventory['device'][i]['name'],e))
