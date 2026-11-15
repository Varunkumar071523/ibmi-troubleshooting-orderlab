**free
// ------------------------------------------------------------------
// ORDDSUM   Daily order summary                      (CASE-013)
// Version WITH THE DEFECT: summarises the SYSTEM date's orders
// (%date() with no argument), not the job date's. A rerun
// submitted with an earlier job date still processes "today".
//
// Replaces any existing summary row for the date, so a rerun for
// the same date does not create duplicates.
// SQL errors are logged to ORDEXCP.
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDDSUM) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

exec sql set option commit = *none, naming = *sys;

dcl-s procDate date;
dcl-s errCode  packed(5:0);

procDate = %date();                  // system date - the defect

exec sql delete from ORDDAYSUM where SUMDATE = :procDate;

exec sql insert into ORDDAYSUM (SUMDATE, ORDCOUNT, ORDAMT, RUNTS)
  select :procDate, count(distinct H.ORDNO),
         coalesce(sum(D.LINEAMT), 0), current timestamp
    from ORDHDR H
    left join ORDDTL D on D.ORDNO = H.ORDNO
   where H.ORDDATE = :procDate;

if sqlcode < 0;
  errCode = sqlcode;
  exec sql insert into ORDEXCP
             (EXCTS, PGM, ORDNO, LINENO, STATUS, MSG)
           values(current timestamp, 'ORDDSUM', 0, 0, :errCode,
                  'Daily summary insert failed; see SQLCODE.');
endif;

*inlr = *on;
return;
