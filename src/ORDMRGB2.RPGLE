**free
// ------------------------------------------------------------------
// ORDMRGB2  Nightly margin calculation            (CASE-004)
// CORRECTED version. In production this source replaces ORDMRGB;
// the lab keeps both so you can compare them.
//
// Changes from ORDMRGB:
//   1. Zero-value lines get MRGPCT = 0 and MRGSTS = 'Z'. Their cost
//      still counts against the order margin (business decision).
//   2. Any other calculation error is logged to ORDEXCP, the line
//      is marked 'E', and processing continues with the next line.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDMRGB2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDDTLI1 usage(*update) keyed;
dcl-f ORDHDRI1 usage(*update) keyed;
dcl-f ORDEXCP  usage(*output);

dcl-s lineMargin packed(11:2);
dcl-s calcOk     ind;

setll *loval ORDDTLI1;
read ORDDTLI1;

dow not %eof(ORDDTLI1);
  if MRGSTS = 'N';
    lineMargin = LINEAMT - LINECOST;
    calcOk = *on;

    if LINEAMT = 0;
      MRGPCT = 0;
      MRGSTS = 'Z';                 // zero-value line
    else;
      monitor;
        eval(h) MRGPCT = lineMargin * 100 / LINEAMT;
        MRGSTS = 'Y';
      on-error;
        calcOk = *off;
        MRGPCT = 0;
        MRGSTS = 'E';               // needs review
        EXCTS  = %timestamp();
        PGM    = 'ORDMRGB';
        STATUS = %status();
        MSG    = 'Margin calculation failed; line marked E.';
        write ORDEXCPR;             // ORDNO/LINENO already set
      endmon;
    endif;

    update ORDDTLR;

    if calcOk;
      chain ORDNO ORDHDRI1;
      if %found(ORDHDRI1);
        MRGAMT += lineMargin;
        update ORDHDRR;
      endif;
    endif;
  endif;
  read ORDDTLI1;
enddo;

*inlr = *on;
return;
