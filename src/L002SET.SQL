-- ===================================================================
-- L002SET  CASE-002 setup: create the exception snapshot table with
--          "yesterday's" rows in it, and make sure today's
--          exception log is empty (a good day: no exceptions).
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L002SET) COMMIT(*NONE)
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

CREATE TABLE ORDEXCPS (
  EXCTS     TIMESTAMP      NOT NULL,
  PGM       CHAR(10)       NOT NULL,
  ORDNO     DECIMAL(9, 0)  NOT NULL,
  LINENO    DECIMAL(3, 0)  NOT NULL,
  STATUS    DECIMAL(5, 0)  NOT NULL,
  MSG       CHAR(80)       NOT NULL
) RCDFMT ORDEXCPSR;

-- Yesterday's snapshot, still in the table
INSERT INTO ORDEXCPS VALUES
  ('2026-11-09-15.01.12.000000', 'ORDSTSB', 100104, 0, 1218,
   'Order not updated: record could not be allocated.');

-- Today: no exceptions at all
DELETE FROM ORDEXCP;
