**free
// ------------------------------------------------------------------
// ORDCUSRB2 One customer's order count               (CASE-036)
// CORRECTED version. In production this source replaces ORDCUSRB.
//
// Receives the customer number as CHARACTER, so it arrives intact
// whether the caller uses CALL, SBMJOB or a command line, and
// converts it with a check.
//
// Parameters: pCustC char(7) in, pOk char(1) out
// Compile: CRTBNDRPG PGM(ORDLAB/ORDCUSRB2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDRI2 usage(*input) keyed;
dcl-f CUSTSTMT usage(*output);

dcl-pi *n;
  pCustC char(7);
  pOk    char(1);
end-pi;

dcl-s cust  packed(7:0);
dcl-s count int(10);

pOk = 'N';
monitor;
  cust = %dec(%trim(pCustC) : 7 : 0);
on-error;
  return;                          // not a number: caller decides
endmon;

setll cust ORDHDRI2;
reade cust ORDHDRI2;
dow not %eof(ORDHDRI2);
  count += 1;
  reade cust ORDHDRI2;
enddo;

CUSTNO   = cust;
ORDCOUNT = count;
RUNTS    = %timestamp();
write CUSTSTMTR;
pOk = 'Y';

*inlr = *on;
return;
