# zware

## AWX Minimum Config

1. add Organization
2. add admin user and tag to Oraganuzation
3. add a team in Organization
4. ssh to mainframe and generate the keypair without passphrase. AWX is one year old and is not accepting the passphrase protected RSA Key.
```
ssh-keygen -t rsa -b 3072 -N "" -m PEM
```
5. copy the id_rsa
6. create a new "Machine" credential in AWX enter mainframe user name and private key.
7. add github project with project url and sync it
8. add an inventory name
9. add a host and link to inventory name
10. add these variables in the host definition
```
---
ansible_host: 192.168.2.44
ansible_user: IBMUSER
PYZ: "/usr/lpp/IBM/cyp/v3r11/pyz"
PYZ_VERSION: "3.11"
ZOAU: "/usr/lpp/IBM/zoautil"
ZOAU_PYTHON_LIBRARY_PATH: "{{ ZOAU }}/lib/{{ PYZ_VERSION }}"
ansible_python_interpreter: "{{ PYZ }}/bin/python{{PYZ_VERSION}}" 
environment_vars:
  _BPXK_AUTOCVT: "ON"
  ZOAU_HOME: "{{ ZOAU }}"
  PYTHONPATH: "{{ ZOAU_PYTHON_LIBRARY_PATH}}"
  LIBPATH: "{{ ZOAU }}/lib:{{ PYZ }}/lib:/lib:/usr/lib:."
  PATH: "{{ ZOAU }}/bin:{{ PYZ }}/bin:/bin:/var/bin"
  _CEE_RUNOPTS: "FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
  _TAG_REDIR_ERR: "txt"
  _TAG_REDIR_IN: "txt"
  _TAG_REDIR_OUT: "txt"
  LANG: "C"
  PYTHONSTDINENCODING: "cp1047"
```
11. add a job template with a playbook and select inventory and credentials.
12. Launch Template
