**free
// ------------------------------------------------------------------
// ORDITMQ   Item enquiry                             (CASE-028)
// Shows one item's description. Compiled BEFORE the new column was
// added to ITEMMAST - so it carries the old format level ID.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDITMQ) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run interactively: CALL ORDLAB/ORDITMQ
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ITEMMAST usage(*input);       // SQL table: read in sequence

dcl-s text char(52) inz('Item VALVE-25 not found.');

read ITEMMAST;
dow not %eof(ITEMMAST);
  if ITEMNO = 'VALVE-25';
    text = %trim(ITEMNO) + ': ' + %trim(ITEMDESC);
    leave;
  endif;
  read ITEMMAST;
enddo;

dsply text;

*inlr = *on;
return;
