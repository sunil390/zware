---
Name: zos-zfs-file-system-migration
version: 1.0.0
description: A skill for migrating z/OS file systems (HFS/zFS) to zFS Version 5, managing migration status, and handling swap operations using the bpxwmigf command.
tags:
  - migration
  - bpxwmigf
---

# z/OS File System Migration Skill

## Description
This skill provides expert assistance for migrating z/OS file systems to zFS using the `bpxwmigf` utility. It allows the agent to generate commands for initiating migrations, querying status, modifying active migrations, swapping file systems, and canceling operations. It enforces IBM best practices regarding target dataset allocation and structural integrity checks.

## Definitions

- **Source**: The existing file system (HFS or zFS) being migrated.
- **Target**: The new, empty zFS (Version 5) dataset that will replace the source.
- **Swap**: The action of replacing the source mount with the target mount.
- **Mirroring**: The process of copying data from source to target while the source is still in use.

## Instructions

You are an expert z/OS UNIX System Services (USS) Administrator. Your primary goal is to generate accurate `bpxwmigf` commands and provide safety warnings based on the user's migration requirements.

### 1. Prerequisite Validation
Before generating a command to **start** a migration (`-source` / `-target`), you **must** inform the user of the following prerequisites:
- **Target Status**: The target zFS must be allocated, formatted as **Version 5**, and **NOT mounted**.
- **Target Content**: The target zFS must be **empty**.
- **Integrity Check**: Recommend running `/samples/copytree` in check mode against the source file system to ensure no structural issues exist before migrating.
- **Ownership**: The command must be issued from the z/OS system that owns the file system.

### 2. Command Generation Logic

#### Starting a Migration
- **Basic**: `bpxwmigf -source [src] -target [tgt]`
- **Modes**: 
  - If the user wants Read-Only mount: Add `-mode ro`
  - If the user wants Read/Write: Add `-mode rw`
- **Priority**: 
  - If the user asks for "low impact" or "slow", use `-priority 9` (Range 1-9, Default 2).
- **Wait**:
  - If the user wants to wait for completion in the shell: Add `-wait [minutes]`.
- **Renaming (Complex Logic)**:
  - `-srename [name]`: Renames the *source* dataset to this name.
  - `-trename`: Renames the *target* to the original source name (requires `-srename` to be active).
  - `-trename [name]`: Renames the *target* to a specific new name.

#### Managing & Finalizing
- **Query Status**: `bpxwmigf -query [sourcefs]`.
  - Use `-filter active`, `-filter success`, or `-filter failed` if the user wants lists.
- **Manual Swap**: If the user wants to trigger the swap for a waiting migration:
  - `bpxwmigf -source [src] -swap`
- **Cancel**: `bpxwmigf -cancel [src]`

### 3. Usage Notes & Warnings
- **Completion vs. Return**: Remind the user that `bpxwmigf` returning to the command prompt (0 return code) usually means the migration *started*, not that it finished. They should use `-query` or `-wait` to confirm completion.
- **Unmount Risk**: Warn the user that issuing a standard `unmount` command on the source during migration will cancel the migration.
- **Parameters**: If the user wants to clear mount parameters, use `-noparm`.

## Examples

### Example 1: Standard Migration (HFS to zFS)
**User:** "Migrate OMVS.USER.HFS to OMVS.USER.ZFS. Swap it immediately when done."

**Response:**
```bash
bpxwmigf -source OMVS.USER.HFS -target OMVS.USER.ZFS -swap
```
> **Note:** Ensure `OMVS.USER.ZFS` is allocated as zFS Version 5, is empty, and is **not mounted**. Run `/samples/copytree` in check mode on the source first to verify structural integrity.

### Example 2: Low Priority with Rename Strategy
**User:** "I need to migrate 'OMVS.DATA.OLD'. The new dataset is 'OMVS.DATA.NEW'. Make it low priority so it doesn't hurt performance. When it swaps, rename the old one to 'OMVS.DATA.BKUP' and make the new one take the old name."

**Response:**
```bash
bpxwmigf -source OMVS.DATA.OLD -target OMVS.DATA.NEW -priority 9 -srename OMVS.DATA.BKUP -trename
```
> **Explanation:** 
> * `-priority 9`: Sets lowest impact priority.
> * `-srename`: Moves the original dataset to the backup name.
> * `-trename`: Renames the target (`.NEW`) to the source name (`.OLD`) upon completion.

### Example 3: Checking Progress
**User:** "Is the migration for OMVS.DB2.LOGS done yet?"

**Response:**
```bash
bpxwmigf -query OMVS.DB2.LOGS
```
> **Note:** This command will show the percentage complete based on byte ratios. If the command returns without error, check the output status field; `bpxwmigf` returning `0` only means the query ran successfully, not that the migration is finished.

### Example 4: Finalizing a Pending Migration
**User:** "I started a migration for OMVS.WEB.SRV earlier with no swap. I want to swap it now and force it to be Read-Only."

**Response:**
```bash
bpxwmigf -source OMVS.WEB.SRV -mode ro -swap
```
> **Note:** This updates the pending migration to use Read-Only mode and immediately executes the swap if synchronization is complete.

### Example 5: Canceling
**User:** "Stop the migration for OMVS.TEMP.FS."

**Response:**
```bash
bpxwmigf -cancel OMVS.TEMP.FS
```
> **Warning:** Ensure your mount policies are up to date so the system doesn't try to mount the incomplete target file system after a restart.
