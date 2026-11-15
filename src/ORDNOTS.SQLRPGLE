**free
// ------------------------------------------------------------------
// ORDNOTS   Add a delivery note to an order          (CASE-047)
// Runs in the named activation group ORDAPP, like the other order
// screens. Version WITH THE DEFECT: compiled with the CRTSQLRPGI
// default COMMIT(*CHG) and never commits. The updated row stays
// locked until the activation group or the job ends.
//
// Needs ORDHDR journaled (L047SET); otherwise see CASE-048.
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDNOTS) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Run: CALL ORDLAB/ORDNOTS PARM('100102' 'Call before delivery')
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp('ORDAPP');

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
  text = 'Note saved for order ' + %char(ord);
else;
  text = 'ORDNOTS: SQL error, SQLSTATE ' + sqlstate;
endif;
dsply text;

return;                                // activation group stays
