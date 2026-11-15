**free
// ------------------------------------------------------------------
// ORDRMDB2  Count open orders for the reminder run   (CASE-043)
// Reads every order, counts the open ones, and writes ONE summary
// row to ORDEXCP at the end. Nothing is changed until that write.
// CORRECTED version: the READ is inside the loop, and the loop
// checks %SHTDN so that ENDJOB OPTION(*CNTRLD) - or a controlled
// end of the subsystem or system - stops it cleanly, before it has
// written anything.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDRMDB2) SRCFILE(ORDLAB/QRPGLESRC)
//          DBGVIEW(*SOURCE)
// Run in batch: SBMJOB CMD(CALL PGM(ORDLAB/ORDRMDB2)) JOB(ORDRMD)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f ORDHDRI1 usage(*input) keyed;
dcl-f ORDEXCP  usage(*output);

dcl-s openCnt int(20) inz(0);

read ORDHDRI1;
dow not %eof(ORDHDRI1);
  if ORDSTS = 'O';
    openCnt += 1;
  endif;
  if %shtdn;                       // controlled end requested?
    *inlr = *on;
    return;                        // nothing written yet
  endif;
  read ORDHDRI1;
enddo;

EXCTS  = %timestamp();
PGM    = 'ORDRMDB2';
ORDNO  = 0;
LINENO = 0;
STATUS = 0;
MSG    = 'Open orders for reminders: ' + %char(openCnt);
write ORDEXCPR;

*inlr = *on;
return;
