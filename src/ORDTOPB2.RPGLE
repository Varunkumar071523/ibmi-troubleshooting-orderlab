**free
// ------------------------------------------------------------------
// ORDTOPB2  Orders per customer                      (CASE-041)
// CORRECTED version. The arrays are sized from one constant, and
// the load stops - with a message - before it would go past the
// end. The program still gives a result, and says it is partial.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDTOPB2) SRCFILE(ORDLAB/QRPGLESRC)
//          DBGVIEW(*SOURCE)
// Run interactively: CALL ORDLAB/ORDTOPB2
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f CUSTMAST usage(*input);
dcl-f ORDHDRI2 usage(*input) keyed;

dcl-c MAXCUST 500;
dcl-s custTab  packed(7:0) dim(MAXCUST);
dcl-s cntTab  int(10)     dim(MAXCUST) inz(0);
dcl-s full    ind         inz(*off);
dcl-s n       int(10)     inz(0);
dcl-s i       int(10);
dcl-s text    char(52);

// Load the customers
read CUSTMAST;
dow not %eof(CUSTMAST);
  if n = %elem(custTab);
    full = *on;                    // no room: stop, don't overrun
    leave;
  endif;
  n += 1;
  custTab(n) = CUSTNO;
  read CUSTMAST;
enddo;

// Count each customer's orders
for i = 1 to n;
  setll custTab(i) ORDHDRI2;
  reade custTab(i) ORDHDRI2;
  dow not %eof(ORDHDRI2);
    cntTab(i) += 1;
    reade custTab(i) ORDHDRI2;
  enddo;
endfor;

text = 'Customers: ' + %char(n) + '  first: ' + %char(custTab(1))
     + ' orders ' + %char(cntTab(1));
dsply text;
if full;
  dsply 'WARNING: over MAXCUST customers - result partial';
endif;

*inlr = *on;
return;
