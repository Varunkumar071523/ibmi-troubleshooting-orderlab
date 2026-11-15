-- ===================================================================
-- L004SET  CASE-004 setup: add a zero-value sample line and reset
--          margin results so ORDMRGB processes every line.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L004SET) COMMIT(*NONE)
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

-- Free promotional kit entered as a zero-value line (the trigger)
INSERT INTO ORDDTL (ORDNO, LINENO, ITEMNO, QTY, LINEAMT, LINECOST)
  VALUES (100103, 3, 'SAMPLE-KIT', 1, 0.00, 4.50);

UPDATE ORDDTL SET MRGSTS = 'N', MRGPCT = 0;
UPDATE ORDHDR SET MRGAMT = 0;
