**free
// ------------------------------------------------------------------
// ORDLDTE   Last order date for every customer       (CASE-046)
// Version WITH THE DEFECT: MAX(ORDDATE) is null for a customer with
// no orders, and there is no indicator variable to receive the
// null. The statement fails (SQLCODE -305), nothing is assigned,
// and the program - which doesn't check - shows the PREVIOUS
// customer's date.
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDLDTE) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run interactively: CALL ORDLAB/ORDLDTE
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

exec sql set option commit = *none, naming = *sys;

dcl-s cust   packed(7:0);
dcl-s lastDt date;
dcl-s text   char(52);

exec sql declare C1 cursor for
           select CUSTNO from CUSTMAST order by CUSTNO;
exec sql open C1;
exec sql fetch C1 into :cust;

dow sqlstate = '00000';
  exec sql select max(ORDDATE)
             into :lastDt
             from ORDHDR
            where CUSTNO = :cust;

  text = %char(cust) + ' last ordered ' + %char(lastDt);
  dsply text;

  exec sql fetch C1 into :cust;
enddo;

exec sql close C1;
*inlr = *on;
return;
