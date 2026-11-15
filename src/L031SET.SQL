-- ===================================================================
-- L031SET  CASE-031 setup: one order set aside with the new status
--          'H' (held), introduced in CASE-014.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L031SET) COMMIT(*NONE)
-- Cleanup (also in the case):
--   DELETE FROM ORDLAB.ORDHDR WHERE ORDNO = 100109;
--   DLTF FILE(ORDLAB/ORDOPNL)
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

INSERT INTO ORDHDR (ORDNO, CUSTNO, ORDDATE, ORDSTS, NOTE)
  VALUES (100109, 5003, '2026-11-04', 'H',
          'Held: awaiting customer credit check');
