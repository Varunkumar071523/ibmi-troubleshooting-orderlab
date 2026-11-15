-- ===================================================================
-- L025SET  CASE-025 setup/reset: two orders picked, none shipped,
--          exception log cleared for ORDSTSB.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L025SET) COMMIT(*NONE)
-- L025CLN uses the same statements, then delete the programs:
--   DLTPGM ORDLAB/ORDMNT   DLTPGM ORDLAB/ORDMNT2
--   DLTPGM ORDLAB/ORDSTSB  DLTPGM ORDLAB/ORDSTSC
--   DLTF   ORDLAB/ORDMNTD
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

UPDATE ORDHDR
   SET ORDSTS = 'P', SHIPDATE = '0001-01-01', CHGCOUNT = 0,
       NOTE = ' '
 WHERE ORDNO IN (100104, 100105);

DELETE FROM ORDEXCP WHERE PGM = 'ORDSTSB';
