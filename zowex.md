# zowex

## zowex minimum setup 14th August 2026

1.  npm install -g @zowe/cli@zowe-v3-lts
2.  zowe plugins install zowex-for-zowe-cli-0.8.0.tgz
    ```sh
    CLI Version: 8.35.2
    Zowe Release Version: v3.6.0
    ```
4.  Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 (if ssh is missing)
5.  Get-Content $env:USERPROFILE\.ssh\id_rsa.pub | ssh mfuser@ip "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
6.  zowe plugins show-first-steps zowex-for-zowe-cli
7.  zowe config init (enter hostip, userid, password)
8.  zowe zssh server install
9.  zowe zowex system view-syslog --seconds-ago 86000
10.  zowe zowex ls ds "ibmuser.**"
11.  zowe zowex view ds "sys1.parmlib(bpxprm00)"
12.  zowe zowex issue tso-command "TIME"
13.  zowe zowex system view-syslog --date 2026-04-15 --time 02:41:00 --max-lines 100
    
