**free
// ------------------------------------------------------------------
// ORDAUDW   Lab writer for the audit log             (CASE-029)
// Writes 15 audit records: four 'VIEW' records for every 'PICK',
// the pattern the new enquiry program produced in the story.
// With the lab's SIZE(10 2 1) the member is full after 12 records.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDAUDW) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDAUDL usage(*output);

dcl-s i int(10);

for i = 1 to 15;
  AUDTS  = %timestamp();
  AUDPGM = 'ORDAUDW';
  ORDNO  = 100100 + i;
  if %rem(i : 5) = 0;
    ACTION = 'PICK';
  else;
    ACTION = 'VIEW';
  endif;
  write ORDAUDLR;
endfor;

*inlr = *on;
return;
