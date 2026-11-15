**free
// ------------------------------------------------------------------
// ORDLDTE2  Last order date for every customer       (CASE-046)
// CORRECTED version. An indicator variable receives the null, the
// program says "no orders" when it is negative, and any other SQL
// error stops the loop instead of being shown as data.
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDLDTE2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run interactively: CALL ORDLAB/ORDLDTE2
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

exec sql set option commit = *none, naming = *sys;

dcl-s cust   packed(7:0);
dcl-s lastDt date;
dcl-s dtInd  int(5);                 // indicator: -1 means null
dcl-s text   char(52);

exec sql declare C1 cursor for
           select CUSTNO from CUSTMAST order by CUSTNO;
exec sql open C1;
exec sql fetch C1 into :cust;

dow sqlstate = '00000';
  exec sql select max(ORDDATE)
             into :lastDt :dtInd
             from ORDHDR
            where CUSTNO = :cust;

  if sqlstate <> '00000';
    text = 'ORDLDTE2: SQL error, SQLSTATE ' + sqlstate;
    dsply text;
    leave;
  endif;

  if dtInd < 0;
    text = %char(cust) + ' has no orders';
  else;
    text = %char(cust) + ' last ordered ' + %char(lastDt);
  endif;
  dsply text;

  exec sql fetch C1 into :cust;
enddo;

exec sql close C1;
*inlr = *on;
return;
