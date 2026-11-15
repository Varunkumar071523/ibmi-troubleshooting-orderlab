**free
// ------------------------------------------------------------------
// ORDHARB   Nightly order archive                    (CASE-020)
// Copies every shipped order (ORDSTS = 'S') to ORDHIST, stamped
// with the job date. The member is chosen by the caller's override.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDHARB) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
//          The compiler reads the record format from file ORDHIST;
//          the member is opened only when the program runs.
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDRI1 usage(*input) keyed;
dcl-f ORDHIST  usage(*output);

setll *loval ORDHDRI1;
read ORDHDRI1;

dow not %eof(ORDHDRI1);
  if ORDSTS = 'S';
    ARCDATE = %date(*date);
    write ORDHISTR;
  endif;
  read ORDHDRI1;
enddo;

*inlr = *on;
return;
