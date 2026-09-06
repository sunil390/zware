# zowex

## Rexx Execution from USS 6th Sept 2026
1. zowe zo issue tso "BPXBATCH SH /u/ibmuser/extract_and_parse.rexx > /u/ibmuser/sdsf.out1 2>&1" --sp '/usr/lpp/zo/bin'
2. Note: in VSCODE setting "Ctrl + P" search for "Insert Final Newline" and enable it. Without this rexx code saved through vscode in unix files will throw these error
```sh
IBMUSER : /u/ibmuser : > ./sdsf_sysp.rexx
BPXW0003I Improper text file
BPXW0000I Exec not found

IBMUSER : /u/ibmuser : > ls -l sdsf_sysp_test.rexx sdsf_sysp.rexx                                                           
-rwx------   1 BPXROOT  SYS1        1440 Sep  6 19:29 sdsf_sysp.rexx                                                        
-rwx------   1 BPXROOT  SYS1        1441 Sep  6 19:30 sdsf_sysp_test.rexx                                                   

IBMUSER : /u/ibmuser : > cmp -l sdsf_sysp.rexx sdsf_sysp_test.rexx                                                          
cmp: EOF on sdsf_sysp.rexx                                                                                                  

After enabling "Insert Final Newline" in VSCOde and saving the file.                                                                                                                           
IBMUSER : /u/ibmuser : > ls -l sdsf_sysp_test.rexx sdsf_sysp.rexx                                                           
-rwx------   1 BPXROOT  SYS1        1441 Sep  6 20:01 sdsf_sysp.rexx                                                        
-rwx------   1 BPXROOT  SYS1        1441 Sep  6 19:30 sdsf_sysp_test.rexx                                                   
                                                                                   
```

## Console issue command zoweax setup 28th Aug 2026 - Updated to 1.0.0 on 5th Sept.
1. npm install -g @zowe/cli@zowe-v3-lts
    ```sh
    CLI Version: 8.36.1
    Zowe Release Version: v3.6.0
    ```
2. zowe plugins install zowex-for-zowe-cli-1.0.0.tgz
3. scp zowe-server-1.0.0.pax.Z user@ip:/u/user/
4. pax -ppx -rf zowe-server-1.0.0.pax.Z
5. cp zo /usr/lpp/zo/bin
6. cp zoa /usr/lpp/zo/bin/zoa
7. chown USER:GROUP /usr/lpp/zo/bin/zoa
8. chmod 750 /usr/lpp/zo/bin/zoa
9. extattr +ap /usr/lpp/zo/bin/zoa
10. extattr -s  /usr/lpp/zo/bin/zoa
11. ls -E /usr/lpp/zo/bin/zoa
12. /usr/lpp/zo/bin/zoa console issue "D T"
13. code .\zowe.config.json
```sh
        "ssh": {
            "type": "ssh",
            "properties": {
                "port": 22,
                "host": "192.168.2.44",
                "rejectUnauthorized": false,
                "serverPath": "/usr/lpp/zoa/bin"
            },
            "secure": [
                "user"
            ]
        },
```
14. zowe zo issue console-command "D IPLINFO" --server-path "/usr/lpp/zo/bin"

## zowex minimum setup 14th August 2026

1.  npm install -g @zowe/cli@zowe-v3-lts
2.  zowe plugins install zowex-for-zowe-cli-0.8.0.tgz
    ```sh
    CLI Version: 8.35.2
    Zowe Release Version: v3.6.0
    ```
4.  Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 (if ssh is missing)
5.  Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub" | ssh MFUser@ip "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
6.  zowe plugins show-first-steps zowex-for-zowe-cli
7.  zowe config init (enter hostip, userid, password)
8.  zowe zssh server install
9.  zowe zowex system view-syslog --seconds-ago 86000
10.  zowe zowex ls ds "ibmuser.**"
11.  zowe zowex view ds "sys1.parmlib(bpxprm00)"
12.  zowe zowex issue tso-command "TIME"
13.  zowe zowex system view-syslog --date 2026-04-15 --time 02:41:00 --max-lines 100
    
