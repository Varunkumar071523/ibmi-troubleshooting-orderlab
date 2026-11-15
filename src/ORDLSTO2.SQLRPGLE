**free
// ------------------------------------------------------------------
// ORDLSTO2  Show a customer's latest order           (CASE-045)
// CORRECTED version. Says WHICH row is wanted - the latest order -
// so the query can only return one, and checks SQLSTATE every time:
// '00000' found, '02000' none, anything else an error.
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDLSTO2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run: CALL ORDLAB/ORDLSTO2 PARM('5001')
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

exec sql set option commit = *none, naming = *sys;

dcl-pi *n;
  pCust char(7);
end-pi;

dcl-s cust  packed(7:0);
dcl-s ord   packed(9:0) inz(0);
dcl-s oDate date;
dcl-s text  char(52);

cust = %dec(%trim(pCust) : 7 : 0);

exec sql select ORDNO, ORDDATE
           into :ord, :oDate
           from ORDHDR
          where CUSTNO = :cust
          order by ORDDATE desc, ORDNO desc
          fetch first 1 row only;

select;
  when sqlstate = '00000';
    text = 'Customer ' + %char(cust) + ': latest order '
         + %char(ord) + ' of ' + %char(oDate);
  when sqlstate = '02000';
    text = 'Customer ' + %char(cust) + ' has no orders.';
  other;
    text = 'ORDLSTO2: SQL error, SQLSTATE ' + sqlstate;
endsl;
dsply text;

*inlr = *on;
return;
