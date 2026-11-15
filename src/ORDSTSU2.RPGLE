**free
// ------------------------------------------------------------------
// ORDSTSU2  Mark an order as picked                  (CASE-027)
// CORRECTED version. In production this source replaces ORDSTSU.
//
// Finishes its own update - releasing the lock - before calling
// the audit program, so the two programs never ask for the same
// record at the same time.
//
// Parameter: pOrd packed(9:0)
// Compile: CRTBNDRPG PGM(ORDLAB/ORDSTSU2) SRCFILE(ORDLAB/QRPGLESRC)
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

chain pOrd ORDHDRI1;
if %found(ORDHDRI1);
  ORDSTS = 'P';
  update ORDHDRR;                  // lock released
  ORDAUDB(pOrd);                   // audit after, with no lock held
endif;

*inlr = *on;
return;
