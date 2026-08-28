# zowex

## Console issue command zoweax setup 28th Aug 2026
1. npm install -g @zowe/cli@zowe-v3-lts
    ```sh
    CLI Version: 8.36.0
    Zowe Release Version: v3.6.0
    ```
2. zowe plugins install zowex-for-zowe-cli-0.9.0.tgz
3. scp zowe-server-0.9.0.pax.Z user@ip:/u/user/
4. pax -ppx -rf zowe-server-0.9.0.pax.Z
5. cp zowex /usr/lpp/zowex/bin
6. cp zoweax /usr/lpp/zowex/bin/zoweax
7. chown USER:GROUP /usr/lpp/zowex/bin/zoweax
8. chmod 750 /usr/lpp/zowex/bin/zoweax
9. extattr +ap /usr/lpp/zowex/bin/zoweax
10. extattr -s  /usr/lpp/zowex/bin/zoweax
11. ls -E /usr/lpp/zowex/bin/zoweax
12. /usr/lpp/zowex/bin/zoweax console issue "D T"
13. code .\zowe.config.json
```sh
        "ssh": {
            "type": "ssh",
            "properties": {
                "port": 22,
                "host": "192.168.2.44",
                "rejectUnauthorized": false,
                "serverPath": "/usr/lpp/zowex/bin"
            },
            "secure": [
                "user"
            ]
        },
```
14. zowe zowex issue console-command "D IPLINFO" --server-path "/usr/lpp/zowex/bin"

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
    
