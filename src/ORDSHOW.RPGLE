**free
// ------------------------------------------------------------------
// ORDSHOW   Show one order's status text             (CASE-017)
// Uses fmtStatus from service program ORDFMT. Runs in the named
// activation group ORDAPP, as the order menu programs do.
//
// Build (after ORDFMT exists):
//   CRTRPGMOD MODULE(ORDLAB/ORDSHOW) SRCFILE(ORDLAB/QRPGLESRC)
//   CRTPGM    PGM(ORDLAB/ORDSHOW) MODULE(ORDLAB/ORDSHOW)
//             BNDSRVPGM(ORDLAB/ORDFMT) ACTGRP(ORDAPP)
//   (ORDLAB must be in *LIBL)
// Run interactively: CALL ORDLAB/ORDSHOW
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f ORDHDRI1 usage(*input) keyed;

dcl-pr fmtStatus varchar(20);
  sts char(1) const;
end-pr;

dcl-s key  packed(9:0) inz(100101);
dcl-s text char(52);

chain key ORDHDRI1;
if %found(ORDHDRI1);
  text = 'Order 100101 status: ' + fmtStatus(ORDSTS);
else;
  text = 'Order 100101 not found.';
endif;

dsply text;

*inlr = *on;
return;
