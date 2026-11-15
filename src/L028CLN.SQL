-- ===================================================================
-- L028CLN  CASE-028 cleanup: remove the new column again.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L028CLN) COMMIT(*NONE)
-- Removing the column changes the format level ID once more, so
-- delete ORDITMQ afterwards (or recompile it):
--   DLTPGM PGM(ORDLAB/ORDITMQ)
-- No other lab program uses ITEMMAST.
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

ALTER TABLE ITEMMAST DROP COLUMN UNITWGT;
