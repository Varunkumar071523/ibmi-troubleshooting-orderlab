-- ===================================================================
-- L004CLN  CASE-004 cleanup: remove the sample line, reset results.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L004CLN) COMMIT(*NONE)
-- Then: DLTPGM PGM(ORDLAB/ORDMRGB)  and  DLTPGM PGM(ORDLAB/ORDMRGB2)
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

DELETE FROM ORDDTL WHERE ORDNO = 100103 AND LINENO = 3;
UPDATE ORDDTL SET MRGSTS = 'N', MRGPCT = 0;
UPDATE ORDHDR SET MRGAMT = 0;
DELETE FROM ORDEXCP WHERE PGM = 'ORDMRGB';
