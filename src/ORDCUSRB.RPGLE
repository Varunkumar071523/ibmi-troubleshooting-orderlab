**free
// ------------------------------------------------------------------
// ORDCUSRB  One customer's order count               (CASE-036)
// Receives the customer number as packed (7, 0) and writes one
// summary row to CUSTSTMT.
//
// Parameter: pCust packed(7:0)
// Compile: CRTBNDRPG PGM(ORDLAB/ORDCUSRB) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDRI2 usage(*input) keyed;
dcl-f CUSTSTMT usage(*output);

dcl-pi *n;
  pCust packed(7:0);
end-pi;

dcl-s count int(10);

setll pCust ORDHDRI2;              // uses the parameter value
reade pCust ORDHDRI2;
dow not %eof(ORDHDRI2);
  count += 1;
  reade pCust ORDHDRI2;
enddo;

CUSTNO   = pCust;
ORDCOUNT = count;
RUNTS    = %timestamp();
write CUSTSTMTR;

*inlr = *on;
return;
