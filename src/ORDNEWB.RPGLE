**free
// ------------------------------------------------------------------
// ORDNEWB   Create an order header                   (CASE-030)
// Takes the next order number from data area ORDNXT, writes the
// header, then adds 1 to the data area.
// Version WITH THE WEAKNESS: trusts the data area completely.
//
// Parameter: pCust packed(7:0)
// Compile: CRTBNDRPG PGM(ORDLAB/ORDNEWB) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDR usage(*output);

dcl-pi *n;
  pCust packed(7:0);
end-pi;

dcl-s nextOrd packed(9:0) dtaara('ORDNXT');

in *lock nextOrd;

ORDNO    = nextOrd;
CUSTNO   = pCust;
ORDDATE  = %date(*date);
ORDSTS   = 'O';
SHIPDATE = %date('0001-01-01' : *iso);
MRGAMT   = 0;
CHGCOUNT = 0;
NOTE     = *blanks;
write ORDHDRR;                     // fails if ORDNO already exists

nextOrd += 1;
out nextOrd;                       // also releases the lock

*inlr = *on;
return;
