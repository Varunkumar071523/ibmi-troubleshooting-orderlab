**free
// ------------------------------------------------------------------
// ORDVALB   Pre-posting validation check            (CASE-007)
// Returns the first open order (ORDSTS = 'O') that has no order
// lines, or blanks if every open order has at least one line.
//
// Parameter: badOrd  char(9)  output
// Compile: CRTBNDRPG PGM(ORDLAB/ORDVALB) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDRI1 usage(*input) keyed;
dcl-f ORDDTLI1 usage(*input) keyed;

dcl-pi *n;
  badOrd char(9);
end-pi;

badOrd = *blanks;

setll *loval ORDHDRI1;
read ORDHDRI1;

dow not %eof(ORDHDRI1);
  if ORDSTS = 'O';
    setll ORDNO ORDDTLI1;
    if not %equal(ORDDTLI1);
      badOrd = %char(ORDNO);
      leave;
    endif;
  endif;
  read ORDHDRI1;
enddo;

*inlr = *on;
return;
