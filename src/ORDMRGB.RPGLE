**free
// ------------------------------------------------------------------
// ORDMRGB   Nightly margin calculation            (CASE-004)
// Version WITH THE DEFECT: divides by LINEAMT without checking it.
//
// For each order line not yet processed (MRGSTS = 'N'):
//   - calculate margin percent and mark the line done ('Y')
//   - add the line margin to the order header (MRGAMT)
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDMRGB) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDDTLI1 usage(*update) keyed;
dcl-f ORDHDRI1 usage(*update) keyed;

dcl-s lineMargin packed(11:2);

setll *loval ORDDTLI1;
read ORDDTLI1;

dow not %eof(ORDDTLI1);
  if MRGSTS = 'N';
    lineMargin = LINEAMT - LINECOST;
    eval(h) MRGPCT = lineMargin * 100 / LINEAMT;   // fails if 0
    MRGSTS = 'Y';
    update ORDDTLR;

    chain ORDNO ORDHDRI1;
    if %found(ORDHDRI1);
      MRGAMT += lineMargin;
      update ORDHDRR;
    endif;
  endif;
  read ORDDTLI1;
enddo;

*inlr = *on;
return;
