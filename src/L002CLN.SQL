-- ===================================================================
-- L002CLN  CASE-002 (and CASE-003) cleanup: drop the snapshot table.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L002CLN) COMMIT(*NONE)
-- Then: DLTPGM ORDLAB/ORDXSNPC   DLTPGM ORDLAB/ORDXSNPC2
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

DROP TABLE ORDEXCPS;
