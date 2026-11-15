-- ===================================================================
-- L024SET  CASE-024 setup: a private copy of the order header table
--          to experiment with authority on. Nothing else in the lab
--          uses ORDHDRX, so changing its authority is safe.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L024SET) COMMIT(*NONE)
-- Cleanup: DROP TABLE ORDLAB.ORDHDRX
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

CREATE TABLE ORDHDRX AS (SELECT * FROM ORDHDR) WITH DATA;
