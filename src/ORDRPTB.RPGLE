**free
// ------------------------------------------------------------------
// ORDRPTB   Customer list report                (CASE-049, 050)
// Prints one line per customer to the printer file ORDRPTP.
// Where the spooled file goes - and whether it prints - is decided
// by the printer file, the job and the output queue, not by this
// program. That is the point of the two cases.
//
// Needs ORDRPTP (created by L049SET).
// Compile: CRTBNDRPG PGM(ORDLAB/ORDRPTB) SRCFILE(ORDLAB/QRPGLESRC)
// Run: CALL ORDLAB/ORDRPTB
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
dcl-f ORDRPTP  printer(80);
dcl-f CUSTMAST usage(*input);

dcl-ds line len(80);
  text char(80);
end-ds;

text = 'Order Lab - customer list';
write ORDRPTP line;
text = ' ';
write ORDRPTP line;

read CUSTMAST;
dow not %eof(CUSTMAST);
  text = %editc(CUSTNO : 'X') + '  ' + CUSTNAME + '  ' + CITY;
  write ORDRPTP line;
  read CUSTMAST;
enddo;

*inlr = *on;
return;
