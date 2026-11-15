-- ===================================================================
-- L028SET  CASE-028: the file change - a new column on ITEMMAST.
--          Run AFTER compiling ORDITMQ.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L028SET) COMMIT(*NONE)
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

ALTER TABLE ITEMMAST
  ADD COLUMN UNITWGT DECIMAL(7, 3) NOT NULL DEFAULT 0;
