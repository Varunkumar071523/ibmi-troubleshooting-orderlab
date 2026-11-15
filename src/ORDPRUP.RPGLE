**free
// ------------------------------------------------------------------
// ORDPRUP   Annual price increase: +5% on every item  (CASE-032)
// Updates ITEMPRC under commitment control. The program does NOT
// commit: by design, the driver decides whether to commit the
// whole run.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDPRUP) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ITEMPRC usage(*update) commit;

read ITEMPRC;
dow not %eof(ITEMPRC);
  eval(h) PRICE = PRICE * 1.05;
  update ITEMPRCR;
  read ITEMPRC;
enddo;

*inlr = *on;
return;
