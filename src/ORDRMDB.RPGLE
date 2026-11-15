**free
// ------------------------------------------------------------------
// ORDRMDB   Count open orders for the reminder run   (CASE-043)
// Reads every order, counts the open ones, and writes ONE summary
// row to ORDEXCP at the end. Nothing is changed until that write.
// Version WITH THE DEFECT: the loop has no READ inside it, so it
// examines the first record for ever.
//
// LAB SAFETY: the defect version stops itself after 180 seconds so
// that a forgotten lab job cannot run all night on a shared system.
// The real program in the story had no such limit.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDRMDB) SRCFILE(ORDLAB/QRPGLESRC)
//          DBGVIEW(*SOURCE)
// Run in batch: SBMJOB CMD(CALL PGM(ORDLAB/ORDRMDB)) JOB(ORDRMD)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f ORDHDRI1 usage(*input) keyed;
dcl-f ORDEXCP  usage(*output);

dcl-s openCnt int(20) inz(0);
dcl-s started timestamp;

started = %timestamp();

read ORDHDRI1;
dow not %eof(ORDHDRI1);
  if ORDSTS = 'O';
    openCnt += 1;
  endif;
  // defect: the next READ is missing here
  if %diff(%timestamp() : started : *seconds) >= 180;   // LAB SAFETY
    leave;
  endif;
enddo;

EXCTS  = %timestamp();
PGM    = 'ORDRMDB';
ORDNO  = 0;
LINENO = 0;
STATUS = 0;
MSG    = 'Open orders for reminders: ' + %char(openCnt);
write ORDEXCPR;

*inlr = *on;
return;
