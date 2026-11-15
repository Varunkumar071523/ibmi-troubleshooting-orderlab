**free
// ------------------------------------------------------------------
// ORDVIEW   Look at the statement table, then wait  (CASE-026)
// Stands in for a user who opened CUSTSTMT in a query or report
// and left the screen up: the file stays open until Enter.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDVIEW) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run interactively: CALL ORDLAB/ORDVIEW
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f CUSTSTMT usage(*input);

dcl-s text char(52);

read CUSTSTMT;
if %eof(CUSTSTMT);
  text = 'CUSTSTMT is empty. File is open; press Enter.';
else;
  text = 'First customer ' + %char(CUSTNO) + '. Press Enter.';
endif;

dsply text;                        // file stays open while waiting

*inlr = *on;
return;
