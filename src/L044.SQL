-- ===================================================================
-- L044      One unqualified statement, two naming modes  (CASE-044)
-- Member L044 in ORDLAB/QSQLSRC, source type SQL.
-- The statement changes nothing (no customer number is -1); it is
-- only there to make the system resolve the name CUSTSTMT.
--
-- Run it three ways (ORDLAB in your library list):
--   RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L044) COMMIT(*NONE)
--             NAMING(*SYS)                    -> works (*LIBL)
--   RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L044) COMMIT(*NONE)
--             NAMING(*SQL)                    -> SQL0204
--   RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L044) COMMIT(*NONE)
--             NAMING(*SQL) DFTRDBCOL(ORDLAB)  -> works
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

DELETE FROM CUSTSTMT WHERE CUSTNO = -1;
