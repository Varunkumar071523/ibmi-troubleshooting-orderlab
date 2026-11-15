**free
// ------------------------------------------------------------------
// ORDSTSB   Hourly: mark picked orders as shipped  (CASE-025)
// Finds orders with ORDSTS = 'P' (read without lock), then locks
// each one and sets ORDSTS = 'S'. If the record cannot be
// allocated, it logs the order to ORDEXCP and carries on.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDSTSB) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDHDRI1 usage(*update) keyed;
dcl-f ORDEXCP  usage(*output);

dcl-s candOrd like(ORDNO);

setll *loval ORDHDRI1;
read(n) ORDHDRI1;

dow not %eof(ORDHDRI1);
  if ORDSTS = 'P';
    candOrd = ORDNO;
    chain(e) candOrd ORDHDRI1;      // waits up to WAITRCD
    if %error;
      EXCTS  = %timestamp();
      PGM    = 'ORDSTSB';
      ORDNO  = candOrd;
      LINENO = 0;
      STATUS = %status(ORDHDRI1);
      MSG    = 'Order not updated: record could not be allocated.';
      write ORDEXCPR;
    elseif %found(ORDHDRI1);
      ORDSTS   = 'S';
      SHIPDATE = %date();
      CHGCOUNT += 1;
      update ORDHDRR;
    endif;
    setgt candOrd ORDHDRI1;         // resume after this order
  endif;
  read(n) ORDHDRI1;
enddo;

*inlr = *on;
return;
