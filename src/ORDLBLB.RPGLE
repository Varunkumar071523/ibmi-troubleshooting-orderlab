**free
// ------------------------------------------------------------------
// ORDLBLB   Prepare dispatch labels for an order     (CASE-042)
// Parameters: order number (char 9) and, optionally, number of
// copies (char 1). Version WITH THE DEFECT: the second parameter
// is declared OPTIONS(*NOPASS) but is used without checking %PARMS.
// Called with one parameter, it refers to a parameter that was
// never passed.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDLBLB) SRCFILE(ORDLAB/QRPGLESRC)
//          DBGVIEW(*SOURCE)
// Run: CALL ORDLAB/ORDLBLB PARM('100101' '2')   - works
//      CALL ORDLAB/ORDLBLB PARM('100101')       - fails
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

wOrd  = %dec(%trim(pOrd) : 9 : 0);
copies = %dec(pCopies : 1 : 0);            // defect: no %parms check

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
