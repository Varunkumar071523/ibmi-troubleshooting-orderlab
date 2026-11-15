**free
// ------------------------------------------------------------------
// ORDSTMS   Customer statement summary, SQL version  (CASE-048)
// Same result as ORDSTMT (CASE-015): clears CUSTSTMT and writes one
// row per customer with an order count.
// Version WITH THE DEFECT: no SET OPTION, so it is compiled with the
// CRTSQLRPGI default COMMIT(*CHG). CUSTSTMT is not journaled, so
// the DELETE fails with SQL7008 (SQLSTATE 55019) and nothing runs.
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDSTMS) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run interactively: CALL ORDLAB/ORDSTMS
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

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
  text = 'ORDSTMS: statement summary rebuilt.';
else;
  text = 'ORDSTMS failed: SQLCODE ' + %char(sqlcode)
       + ' SQLSTATE ' + sqlstate;
endif;
dsply text;

*inlr = *on;
return;
