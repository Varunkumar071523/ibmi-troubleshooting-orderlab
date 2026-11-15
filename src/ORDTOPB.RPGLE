**free
// ------------------------------------------------------------------
// ORDTOPB   Orders per customer                      (CASE-041)
// Version WITH THE DEFECT: loads every customer into arrays sized
// for 4 customers. Works with the seed data (4 customers). After
// the lab adds customer 5005, the fifth assignment is outside the
// array and the program fails with an array index error.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDTOPB) SRCFILE(ORDLAB/QRPGLESRC)
//          DBGVIEW(*SOURCE)
// Run interactively: CALL ORDLAB/ORDTOPB
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f CUSTMAST usage(*input);
dcl-f ORDHDRI2 usage(*input) keyed;

dcl-s custTab  packed(7:0) dim(4);
dcl-s cntTab  int(10)     dim(4) inz(0);
dcl-s n       int(10)     inz(0);
dcl-s i       int(10);
dcl-s text    char(52);

// Load the customers
read CUSTMAST;
dow not %eof(CUSTMAST);
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

*inlr = *on;
return;
