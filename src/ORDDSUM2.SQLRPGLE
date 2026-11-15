**free
// ------------------------------------------------------------------
// ORDDSUM2  Daily order summary                      (CASE-013)
// CORRECTED version. In production this source replaces ORDDSUM.
//
// Summarises the JOB date's orders: %date(*date). A normal nightly
// run is unchanged (job date = submission date); a rerun for an
// earlier day is submitted with SBMJOB DATE(...).
//
// Compile: CRTSQLRPGI OBJ(ORDLAB/ORDDSUM2) SRCFILE(ORDLAB/QRPGLESRC)
//            DBGVIEW(*SOURCE)       (ORDLAB must be in *LIBL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt dftactgrp(*no) actgrp(*new);

exec sql set option commit = *none, naming = *sys;

dcl-s procDate date;
dcl-s errCode  packed(5:0);

procDate = %date(*date);             // job date

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
