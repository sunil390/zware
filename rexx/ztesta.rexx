/* REXX */                                                                
SAY "STARTING ZTABLE EXPORT"                                              
ADDRESS TSO "PROFILE NOPREFIX"                                            
"ALLOC FI("ISPPROF") DA("IBMUSER.ZISPF.PROFILE") SHR REUSE"               
"ALLOC FI("ISPMLIB") DA("ISP.SISPMENU") SHR REUSE"                        
"ALLOC FI("ISPPLIB") DA("ISP.SISPPENU") SHR REUSE"                        
"ALLOC FI("ISPSLIB") DA("ISP.SISPSENU","ISP.SISPSLIB") SHR REUSE"         
"ALLOC FI("ISPTLIB") DA("IBMUSER.ZNEXT.TABLES","ISP.SISPTENU") SHR REUSE" 
"ALLOC FI("ISPTABL") DA("IBMUSER.ZNEXT.TABLES") SHR REUSE"                
"ALLOC FI("ISPLOG")  DELETE TRACK SPACE(1,1) LRECL(133) RECFM(F B)"       
"ALLOC FI("SYSEXEC") DA("IBMUSER.ZNEXT.REXX","ISP.SISPEXEC") SHR REUSE"   
"ALLOC FI("SYSPROC") DA("ISP.SISPCLIB") SHR REUSE"                        
"ISPSTART CMD(%ISPF2REX IBMUSER.ZNEXT.TABLES MYTABLE /u/ibmuser)"         
IF RC = 0 THEN                                                            
  SAY "TABLE EXPORTED SUCCESSFULLY."                                      
EXIT RC                                                                   
ELSE                                                                      
  SAY "ERROR: TBEXPORT FAILED WITH RC="RC                                 
EXIT RC                                                                   
