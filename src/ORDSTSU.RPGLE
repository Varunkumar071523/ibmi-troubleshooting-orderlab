**free
// ------------------------------------------------------------------
// ORDSTSU   Mark an order as picked                  (CASE-027)
// Version WITH THE DEFECT: locks the order header, then calls the
// audit program ORDAUDB - which opens the same file separately and
// asks for the same record for update. The job waits for itself.
//
// Parameter: pOrd packed(9:0)
// Compile: CRTBNDRPG PGM(ORDLAB/ORDSTSU) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDRI1 usage(*update) keyed;

dcl-pi *n;
  pOrd packed(9:0);
end-pi;

dcl-pr ORDAUDB extpgm('ORDAUDB');
  ord packed(9:0) const;
end-pr;

chain pOrd ORDHDRI1;               // record is now LOCKED
if %found(ORDHDRI1);
  ORDSTS = 'P';
  ORDAUDB(pOrd);                   // audit: still holding the lock
  update ORDHDRR;                  // lock released here
endif;

*inlr = *on;
return;
