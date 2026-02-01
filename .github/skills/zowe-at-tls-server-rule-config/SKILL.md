---
name: zowe-at-tls-server-rule-config
description: Instructions for configuring Application Transparent Transport Layer Security (AT-TLS) inbound server rules for Zowe on z/OS, offloading encryption from Zowe to the IBM Communications Server.
---

# Zowe AT-TLS Server Rule Configuration
Reference: https://medium.com/zowe/zowe-and-at-tls-server-rule-fe4a26c81332
This skill outlines the process of configuring Zowe to use Application Transparent Transport Layer Security (AT-TLS) for inbound traffic. This configuration offloads SSL/TLS encryption from Zowe's native servers (API Mediation Layer, Desktop, ZSS) to the IBM Communications Server Policy Agent (PAGENT).

## Prerequisite Concepts

*   **Native Encryption:** Zowe servers access the keyring directly and perform encryption.
*   **AT-TLS Encryption:** Zowe servers communicate via unencrypted HTTP internally; PAGENT intercepts traffic at the TCP/IP stack to handle encryption/decryption transparently.
*   **Server Rule:** Handles traffic **inbound** from a client (e.g., a web browser) to Zowe.

## Configuration Steps

### 1. Disable Native Encryption in Zowe
Before configuring AT-TLS, tell Zowe to stop handling encryption itself.

1.  Open `zowe.yaml`.
2.  Locate the TLS section.
3.  Update the following values to `true`:
    *   `zowe.network.tls.attls: true`
    *   `zowe.client.tls.attls: true`
4.  Restart Zowe.
    *   *Verification:* You can now access Zowe via `http://` (unsecure) using `curl`. Browsers may reject the unsecure connection or show SSL errors if they force HTTPS.

### 2. Locate PAGENT Configuration
Identify the active policy file used by the Policy Agent (PAGENT).
*   Check the PAGENT started task JCL (usually `PROCLIB(PAGENT)`).
*   Find the `STDENV` DD pointing to the environment file (e.g., `/etc/pagent/pagent.env`).
*   Inside `.env`, find `PAGENT_CONFIG_FILE` pointing to the main config (e.g., `USER.PARMLIB(PAGENT)`).
*   Inside the config member, find the `TcpImage` statement pointing to the policy file (e.g., `/etc/pagent/tcpip.policy` or `ttls.policy`).

### 3. Define the AT-TLS Server Rule
Add the following definitions to your `ttls.policy` file. This rule captures traffic on Zowe's ports and applies server-side encryption.

#### A. TTLSRule
Defines *when* the rule applies.
```shell
TTLSRule                          ZoweServerRule
{
  LocalPortRange                  7552-7558  # Default Zowe ports
  Direction                       Inbound
  TTLSGroupActionRef              ZoweServerGroupAction
  TTLSEnvironmentActionRef        ZoweServerEnvironmentAction
  TTLSConnectionActionRef         ZoweServerConnectionAction
}
```

#### B. TTLSGroupAction
Enables AT-TLS for this group.
```shell
TTLSGroupAction                   ZoweServerGroupAction
{
  TTLSEnabled                     On
}
```

#### C. TTLSEnvironmentAction
Defines the keyring and TLS protocol versions.
```shell
TTLSEnvironmentAction             ZoweServerEnvironmentAction
{
  HandshakeRole                   Server
  EnvironmentUserInstance         0
  TTLSKeyringParmsRef             ZoweKeyring
  TTLSEnvironmentAdvancedParmsRef ServerEnvironmentAdvParms
}

TTLSKeyringParms                  ZoweKeyring
{
  Keyring                         IBMUSER/HSS_KEYRING # Format: Owner/KeyringName
}

TTLSEnvironmentAdvancedParms      ServerEnvironmentAdvParms
{
  TLSv1.2                         On
  ClientAuthType                  PassThru # Use 'Full' or 'Required' if using Client Certs
}
```

#### D. TTLSConnectionAction
Defines the specific certificate label to use.
```shell
TTLSConnectionAction              ZoweServerConnectionAction
{
  HandshakeRole                   Server
  TTLSCipherParmsRef              ZoweCipherParms # Reference to your cipher list
  TTLSConnectionAdvancedParmsRef  ZoweServerConnectionAdvParms
  CtraceClearText                 Off
}
```
*Note: You must ensure `ZoweCipherParms` is defined elsewhere in your policy with valid ciphers.*

### 4. Activate and Verify

1.  **Refresh PAGENT:** Apply the changes without restarting the stack.
    ```jcl
    /F PAGENT,REFRESH
    ```
2.  **Verify Rule Installation:**
    ```jcl
    NETSTAT TTLS
    ```
    Ensure `ZoweServerGroupAction` (or your rule name) appears in the output.
3.  **Test Connection:**
    *   Open a browser to `https://<zowe-host>:7554`.
    *   The page should load securely.

## Troubleshooting & Known Limitations
*   **Partial Functionality:** After applying only the **Server Rule**, the API Gateway dashboard may load but show red/yellow status indicators. This is because Zowe servers also communicate with each other (outbound traffic). Without a corresponding **Client Rule**, internal components (like API Gateway talking to API Discovery) fail to handshake.
*   **Logs:** Check `/tmp/pagent.log` (or your configured log path) and `ZWESLSTC` logs for handshake errors.
