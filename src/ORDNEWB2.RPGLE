**free
// ------------------------------------------------------------------
// ORDNEWB2  Create an order header                   (CASE-030)
// CORRECTED version. In production this source replaces ORDNEWB.
//
// If the number from ORDNXT is already used, the program does not
// guess a new one. It releases the data area unchanged, records
// the problem in ORDEXCP, and returns pOk = 'N' so that the caller
// can stop the import.
//
// Parameters: pCust packed(7:0) in, pOk char(1) out
// Compile: CRTBNDRPG PGM(ORDLAB/ORDNEWB2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDR  usage(*output);
dcl-f ORDEXCP usage(*output);

dcl-pi *n;
  pCust packed(7:0);
  pOk   char(1);
end-pi;

dcl-s nextOrd packed(9:0) dtaara('ORDNXT');
dcl-s newOrd  packed(9:0);

pOk = 'Y';
in *lock nextOrd;
newOrd = nextOrd;

ORDNO    = newOrd;
CUSTNO   = pCust;
ORDDATE  = %date(*date);
ORDSTS   = 'O';
SHIPDATE = %date('0001-01-01' : *iso);
MRGAMT   = 0;
CHGCOUNT = 0;
NOTE     = *blanks;
write(e) ORDHDRR;

if %error;
  unlock nextOrd;                  // leave the data area unchanged
  EXCTS  = %timestamp();
  PGM    = 'ORDNEWB';
  ORDNO  = newOrd;
  LINENO = 0;
  STATUS = %status(ORDHDR);
  MSG    = 'Order number from ORDNXT already used. Import stopped.';
  write ORDEXCPR;
  pOk = 'N';
else;
  nextOrd += 1;
  out nextOrd;
endif;

*inlr = *on;
return;
