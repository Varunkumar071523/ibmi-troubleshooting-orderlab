**free
// ------------------------------------------------------------------
// ORDPOST   Nightly invoice posting                  (CASE-014)
// Version WITH THE DEFECT: writes one invoice per shipped order
// (ORDSTS = 'S') but never marks the order as invoiced. If the run
// stops part-way, a rerun invoices the earlier orders again.
//
// Parameter: pOk char(1) output - 'Y' completed, 'N' stopped
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDPOST) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-pi *n;
  pOk char(1);
end-pi;

dcl-ds psds psds qualified;
  jobName char(10) pos(244);
  jobUser char(10) pos(254);
  jobNbr  char(6)  pos(264);
end-ds;

dcl-s ordNo   packed(9:0);
dcl-s invAmt  packed(11:2);
dcl-s fullJob char(28);
dcl-s errCode packed(5:0);

exec sql set option commit = *none, naming = *sys,
                    closqlcsr = *endmod;

fullJob = psds.jobNbr + '/' + %trim(psds.jobUser) + '/'
        + %trim(psds.jobName);
pOk = 'Y';

exec sql declare C1 cursor for
  select ORDNO from ORDHDR
   where ORDSTS = 'S'
   order by ORDNO;

exec sql open C1;
exec sql fetch C1 into :ordNo;

dow sqlcode = 0;
  exec sql select coalesce(sum(LINEAMT), 0) into :invAmt
             from ORDDTL where ORDNO = :ordNo;

  exec sql insert into ORDINV (INVORD, INVAMT, INVTS, INVJOB)
           values(:ordNo, :invAmt, current timestamp, :fullJob);

  if sqlcode < 0;
    errCode = sqlcode;
    exec sql insert into ORDEXCP
               (EXCTS, PGM, ORDNO, LINENO, STATUS, MSG)
             values(current timestamp, 'ORDPOST', :ordNo, 0,
                    :errCode, 'Invoice insert failed; run stopped.');
    pOk = 'N';
    leave;
  endif;

  exec sql fetch C1 into :ordNo;
enddo;

if sqlcode < 0 and pOk = 'Y';      // fetch failed
  pOk = 'N';
endif;

exec sql close C1;

*inlr = *on;
return;
