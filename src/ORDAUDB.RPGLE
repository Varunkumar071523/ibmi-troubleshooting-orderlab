**free
// ------------------------------------------------------------------
// ORDAUDB   Audit an order change                    (CASE-027)
// Adds 1 to the order's change counter. Opens ORDHDRI1 itself, in
// its own activation group - a separate open of the file.
//
// Parameter: pOrd packed(9:0)
// Compile: CRTBNDRPG PGM(ORDLAB/ORDAUDB) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDRI1 usage(*update) keyed;

dcl-pi *n;
  pOrd packed(9:0) const;
end-pi;

chain pOrd ORDHDRI1;               // waits up to WAITRCD
if %found(ORDHDRI1);
  CHGCOUNT += 1;
  update ORDHDRR;
endif;

*inlr = *on;
return;
