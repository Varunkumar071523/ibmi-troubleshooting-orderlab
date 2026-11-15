**free
// ------------------------------------------------------------------
// ORDLSTO   Show a customer's order                  (CASE-045)
// Customer service type a customer number; the program shows "the"
// order for that customer. Version WITH THE DEFECT: SELECT INTO
// can find more than one row, and the program never checks SQLSTATE.
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDLSTO) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run: CALL ORDLAB/ORDLSTO PARM('5001')
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
          where CUSTNO = :cust;

text = 'Customer ' + %char(cust) + ': order ' + %char(ord)
     + ' of ' + %char(oDate);
dsply text;

*inlr = *on;
return;
