**free
// ------------------------------------------------------------------
// ORDLSTB2  Order status summary                    (CASE-039)
// CORRECTED version: same logic as ORDLSTB, plus a control option
// naming the binding directory ORDBND, which lists the service
// program ORDFMT. The bind step now finds FMTSTATUS, and a one-step
// CRTBNDRPG works too.
//
// Set up once:
//   CRTBNDDIR BNDDIR(ORDLAB/ORDBND) TEXT('Order Lab binding dir')
//   ADDBNDDIRE BNDDIR(ORDLAB/ORDBND) OBJ((ORDLAB/ORDFMT *SRVPGM))
// Build (ORDLAB in *LIBL):
//   CRTBNDRPG PGM(ORDLAB/ORDLSTB2) SRCFILE(ORDLAB/QRPGLESRC)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new) bnddir('ORDBND');

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
