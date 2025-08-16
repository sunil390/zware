#!/usr/lpp/ixm/bin/rexx
/* REXX */
/*--------------------------------------------------------------------*/
/* This script extracts data from the z/OS 3.1 SDSF DASH panel      */
/* and immediately parses it to display clean Key:Value pairs.      */
/* CORRECTED VERSION: Replaced FORMAT() with LEFT() for compatibility.*/
/*--------------------------------------------------------------------*/

/* 1. INITIALIZE THE SDSF ENVIRONMENT */
rc = isfcalls('ON')
if rc <> 0 then do
  say "ERROR: Could not initialize the SDSF environment. RC="rc
  exit 8
end

/* 2. EXECUTE THE DASH COMMAND TO POPULATE VARIABLES */
Address SDSF "ISFEXEC DASH"
if rc <> 0 then do
  say "ERROR: The 'ISFEXEC DASH' command failed. RC="rc
  isfcalls('OFF')
  exit 12
end

/* Check if any data was returned */
if isfrows = 0 then do
  say "INFO: The DASH command ran but returned 0 rows of data."
  isfcalls('OFF')
  exit 4
end

say "--- Extracted System Metrics from SDSF DASH Panel ---"

/* 3. LOOP THROUGH THE RETURNED DATA AND PARSE IT */
do i = 1 to isfrows
  /* Get the values for the key columns for the current row (i) */
  attr_key = strip(value('ATTRIBUTE.'i))
  attr_val = strip(value('VALUE.'i))

  metr_key = strip(value('METRIC.'i))
  metr_val = strip(value('MEASURE.'i))

  /* --- Logic to display the key-pairs --- */

  /* Display the Attribute:Value pair if the Attribute has a name */
  if attr_key <> '' then do
    /* Use LEFT() to pad the key to 20 characters for nice alignment */
    say left(attr_key, 20) || ': ' || attr_val
  end

  /* Display the Metric:Measure pair if the Metric has a name */
  if metr_key <> '' then do
    /* Use LEFT() to pad the key to 20 characters for nice alignment */
    say left(metr_key, 20) || ': ' || metr_val
  end
end

say "-----------------------------------------------------"

/* 4. CLEAN UP THE SDSF ENVIRONMENT */
isfcalls('OFF')

exit 0
