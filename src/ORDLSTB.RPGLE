**free
// ------------------------------------------------------------------
// ORDLSTB   Order status summary                    (CASE-039)
// Counts orders by status and shows each status as text, using
// fmtStatus from service program ORDFMT (CASE-017 lab).
// Version WITH THE BUILD DEFECT: the source is fine, but the lab
// builds it with CRTPGM and no BNDSRVPGM, so the bind step cannot
// find FMTSTATUS (message CPD5D02) and no program is created.
//
// Build (defect):
//   CRTRPGMOD MODULE(ORDLAB/ORDLSTB) SRCFILE(ORDLAB/QRPGLESRC)
//   CRTPGM    PGM(ORDLAB/ORDLSTB) MODULE(ORDLAB/ORDLSTB)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f ORDHDRI1 usage(*input) keyed;

dcl-pr fmtStatus varchar(20);
  sts char(1) const;
end-pr;

dcl-c CODES 'OPS';
dcl-s cnt  int(10) dim(3) inz(0);
dcl-s i    int(10);
dcl-s text char(52);

read ORDHDRI1;
dow not %eof(ORDHDRI1);
  i = %scan(ORDSTS : CODES);
  if i > 0;
    cnt(i) += 1;
  endif;
  read ORDHDRI1;
enddo;

for i = 1 to %len(CODES);
  text = fmtStatus(%subst(CODES : i : 1)) + ': ' + %char(cnt(i));
  dsply text;
endfor;

*inlr = *on;
return;
