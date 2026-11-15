**free
// ------------------------------------------------------------------
// ORDLBLB2  Prepare dispatch labels for an order     (CASE-042)
// CORRECTED version. Uses the optional second parameter only when
// %PARMS says it was passed; otherwise one copy. Both parameters
// are checked before use.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDLBLB2) SRCFILE(ORDLAB/QRPGLESRC)
//          DBGVIEW(*SOURCE)
// Run: CALL ORDLAB/ORDLBLB2 PARM('100101' '2')  - 2 copies
//      CALL ORDLAB/ORDLBLB2 PARM('100101')      - 1 copy
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f ORDHDRI1 usage(*input) keyed;

dcl-pi *n;
  pOrd    char(9);
  pCopies char(1) options(*nopass);
end-pi;

dcl-s wOrd  packed(9:0);
dcl-s copies packed(1:0);
dcl-s text   char(52);

copies = 1;                                // default
monitor;
  wOrd = %dec(%trim(pOrd) : 9 : 0);
  if %parms >= 2;                          // passed at all?
    copies = %dec(pCopies : 1 : 0);
  endif;
on-error;
  dsply 'ORDLBLB2: order or copies is not a number.';
  *inlr = *on;
  return;
endmon;

chain wOrd ORDHDRI1;
if %found(ORDHDRI1);
  text = 'Labels for ' + %char(wOrd) + ': ' + %char(copies)
       + ' copies';
else;
  text = 'Order ' + %char(wOrd) + ' not found.';
endif;
dsply text;

*inlr = *on;
return;
