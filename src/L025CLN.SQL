-- ===================================================================
-- L025CLN  CASE-025 cleanup: reset the two orders and the log.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L025CLN) COMMIT(*NONE)
-- Then delete the case objects:
--   DLTPGM ORDLAB/ORDMNT    DLTPGM ORDLAB/ORDMNT2
--   DLTPGM ORDLAB/ORDSTSB   DLTPGM ORDLAB/ORDSTSC
--   DLTF   ORDLAB/ORDMNTD
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

UPDATE ORDHDR
   SET ORDSTS = 'P', SHIPDATE = '0001-01-01', CHGCOUNT = 0,
       NOTE = ' '
 WHERE ORDNO IN (100104, 100105);

DELETE FROM ORDEXCP WHERE PGM = 'ORDSTSB';
