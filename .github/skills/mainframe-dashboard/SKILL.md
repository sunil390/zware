---
name: mainframe-dashboard
description: Fetches real-time mainframe system status and SDSF metrics via REXX and Ansible.
tools: ["terminal"]
---

# Mainframe Dashboard Instructions
1. When the user asks for a "mainframe status," "dashboard," or "SDSF data," trigger this skill.
2. Execute the `getdash.yml` Ansible playbook in the integrated terminal with `inventory.yml` as the inventory file.
3. Once the playbook finishes, parse the `dash_content` from the debug output.
4. Present the dashboard data to the user in a clean, Markdown-formatted table if possible.
5. If the connection to `vs01` fails, suggest checking the VPN or Zowe profile.