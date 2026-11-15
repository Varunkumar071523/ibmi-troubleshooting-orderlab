**free
// ------------------------------------------------------------------
// ORDSTMS2  Customer statement summary, SQL version  (CASE-048)
// Same result as ORDSTMT (CASE-015): clears CUSTSTMT and writes one
// row per customer with an order count.
// CORRECTED version: the commitment level is stated in the source.
// COMMIT = *NONE is right here: the table is rebuilt from scratch
// and the job is safe to rerun, so there is nothing to roll back.
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDSTMS2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run interactively: CALL ORDLAB/ORDSTMS2
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

exec sql set option commit = *none, naming = *sys;

dcl-s text char(52);

exec sql delete from CUSTSTMT;

if sqlstate = '00000' or sqlstate = '02000';
  exec sql insert into CUSTSTMT (CUSTNO, ORDCOUNT, RUNTS)
             select C.CUSTNO, count(H.ORDNO), current timestamp
               from CUSTMAST C
               left join ORDHDR H on H.CUSTNO = C.CUSTNO
              group by C.CUSTNO;
endif;

if sqlstate = '00000';
  text = 'ORDSTMS2: statement summary rebuilt.';
else;
  text = 'ORDSTMS2 failed: SQLCODE ' + %char(sqlcode)
       + ' SQLSTATE ' + sqlstate;
endif;
dsply text;

*inlr = *on;
return;
