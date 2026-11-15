-- ===================================================================
-- L013SET  CASE-013 setup: daily order summary table.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L013SET) COMMIT(*NONE)
-- Cleanup: DROP TABLE ORDLAB.ORDDAYSUM, then
--          DLTPGM ORDLAB/ORDDSUM  and  DLTPGM ORDLAB/ORDDSUM2
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

CREATE TABLE ORDDAYSUM (
  SUMDATE   DATE           NOT NULL,
  ORDCOUNT  INTEGER        NOT NULL,
  ORDAMT    DECIMAL(13, 2) NOT NULL,
  RUNTS     TIMESTAMP      NOT NULL,
  CONSTRAINT ORDDAYSUM_PK PRIMARY KEY (SUMDATE)
) RCDFMT ORDDAYSUMR;
