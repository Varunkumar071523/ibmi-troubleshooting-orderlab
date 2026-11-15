**free
// ------------------------------------------------------------------
// ORDMNT    Order maintenance (interactive)        (CASE-025)
// Version WITH THE DEFECT: reads the order FOR UPDATE, then shows
// the edit screen while still holding the record lock.
//
// Compile: CRTDSPF  FILE(ORDLAB/ORDMNTD) SRCFILE(ORDLAB/QDDSSRC)
//          CRTBNDRPG PGM(ORDLAB/ORDMNT) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDMNTD  workstn;
dcl-f ORDHDRI1 usage(*update) keyed;

SMSG = *blanks;

dow *on;
  exfmt ORDKEY;
  if *in03;
    leave;
  endif;
  SMSG = *blanks;

  chain KORDNO ORDHDRI1;            // record is now LOCKED
  if not %found(ORDHDRI1);
    SMSG = 'Order not found.';
    iter;
  endif;

  SORDNO  = ORDNO;
  SORDSTS = ORDSTS;
  SNOTE   = NOTE;
  exfmt ORDEDT;                     // lock held while user types

  if *in03 or *in12;
    unlock ORDHDRI1;
    if *in03;
      leave;
    endif;
    iter;
  endif;

  ORDSTS   = SORDSTS;
  NOTE     = SNOTE;
  CHGCOUNT += 1;
  update ORDHDRR;                   // lock released here
  SMSG = 'Order saved.';
enddo;

*inlr = *on;
return;
