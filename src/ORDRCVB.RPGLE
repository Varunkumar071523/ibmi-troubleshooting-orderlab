**free
// ------------------------------------------------------------------
// ORDRCVB   Goods received value report             (CASE-040)
// Reads ORDRCV and shows the total value received (qty x cost).
// Read-only: changes nothing, so it is safe to run again.
// Fails with a decimal data error on record 3 after L040SET.
//
// Compile: CRTBNDRPG PGM(ORDLAB/ORDRCVB) SRCFILE(ORDLAB/QRPGLESRC)
//          DBGVIEW(*SOURCE)
// Run interactively: CALL ORDLAB/ORDRCVB
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f ORDRCV usage(*input);

dcl-s total packed(13:2) inz(0);
dcl-s recs  int(10) inz(0);
dcl-s text  char(52);

read ORDRCV;
dow not %eof(ORDRCV);
  recs += 1;
  total += RCVQTY * RCVCOST;
  read ORDRCV;
enddo;

text = 'Receipts: ' + %char(recs) + '  value: ' + %char(total);
dsply text;

*inlr = *on;
return;
