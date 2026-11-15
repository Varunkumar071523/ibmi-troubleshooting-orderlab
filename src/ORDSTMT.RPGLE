**free
// ------------------------------------------------------------------
// ORDSTMT   Build customer statement summary      (CASE-015)
// Writes one CUSTSTMT row per customer with the number of orders.
// All files are found through the library list (*LIBL).
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDSTMT) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f CUSTMAST usage(*input);
dcl-f ORDHDRI2 usage(*input) keyed;
dcl-f CUSTSTMT usage(*output);

dcl-s count int(10);

read CUSTMAST;
dow not %eof(CUSTMAST);
  count = 0;
  setll CUSTNO ORDHDRI2;
  reade CUSTNO ORDHDRI2;
  dow not %eof(ORDHDRI2);
    count += 1;
    reade CUSTNO ORDHDRI2;
  enddo;

  ORDCOUNT = count;
  RUNTS    = %timestamp();
  write CUSTSTMTR;
  read CUSTMAST;
enddo;

*inlr = *on;
return;
