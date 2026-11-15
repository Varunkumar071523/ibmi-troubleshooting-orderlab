**free
// ------------------------------------------------------------------
// ORDMNT2   Order maintenance (interactive)        (CASE-025)
// CORRECTED version. In production this source replaces ORDMNT;
// the lab keeps both so you can compare them.
//
// Reads WITHOUT a lock for display. On Enter it re-reads WITH a
// lock, checks CHGCOUNT to detect a change made meanwhile, and
// updates at once. The lock is held for milliseconds, not minutes.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDMNT2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDMNTD  workstn;
dcl-f ORDHDRI1 usage(*update) keyed;

dcl-s savedCount int(10);

SMSG = *blanks;

dow *on;
  exfmt ORDKEY;
  if *in03;
    leave;
  endif;
  SMSG = *blanks;

  chain(n) KORDNO ORDHDRI1;         // read, NO lock
  if not %found(ORDHDRI1);
    SMSG = 'Order not found.';
    iter;
  endif;

  savedCount = CHGCOUNT;
  SORDNO  = ORDNO;
  SORDSTS = ORDSTS;
  SNOTE   = NOTE;
  exfmt ORDEDT;                     // no lock held here

  if *in03;
    leave;
  endif;
  if *in12;
    iter;
  endif;

  chain(e) KORDNO ORDHDRI1;         // lock only now
  if %error;
    SMSG = 'Order is being updated elsewhere. Try again.';
    iter;
  endif;
  if not %found(ORDHDRI1);
    SMSG = 'Order was deleted by another job.';
    iter;
  endif;
  if CHGCOUNT <> savedCount;
    unlock ORDHDRI1;
    SMSG = 'Order changed by another job. Not saved.';
    iter;
  endif;

  ORDSTS   = SORDSTS;
  NOTE     = SNOTE;
  CHGCOUNT += 1;
  update ORDHDRR;
  SMSG = 'Order saved.';
enddo;

*inlr = *on;
return;
