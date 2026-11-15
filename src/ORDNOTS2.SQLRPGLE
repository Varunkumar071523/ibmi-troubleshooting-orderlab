**free
// ------------------------------------------------------------------
// ORDNOTS2  Add a delivery note to an order          (CASE-047)
// CORRECTED version. One UPDATE is the whole unit of work, so the
// program commits as soon as it succeeds (and rolls back if not).
// The row lock is released before control returns to the screen.
// The commitment level is stated in the source, not left to a
// compile default.
//
// Needs ORDHDR journaled (L047SET); otherwise see CASE-048.
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDNOTS2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run: CALL ORDLAB/ORDNOTS2 PARM('100102' 'Call before delivery')
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp('ORDAPP');

exec sql set option commit = *chg, naming = *sys;

dcl-pi *n;
  pOrd  char(9);
  pNote char(32);                      // see CASE-036: a literal is
                                       // padded to 32, not 40
end-pi;

dcl-s ord  packed(9:0);
dcl-s text char(52);

ord = %dec(%trim(pOrd) : 9 : 0);

exec sql update ORDHDR
            set NOTE = :pNote
          where ORDNO = :ord;

if sqlstate = '00000';
  exec sql commit;                     // releases the row lock
  text = 'Note saved for order ' + %char(ord);
else;
  text = 'ORDNOTS2: SQL error, SQLSTATE ' + sqlstate;
  exec sql rollback;
endif;
dsply text;

return;                                // activation group stays
