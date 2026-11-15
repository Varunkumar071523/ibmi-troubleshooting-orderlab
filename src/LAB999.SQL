-- ===================================================================
-- LAB999  Remove the whole Order Lab (tables and indexes only)
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(LAB999) COMMIT(*NONE)
-- Removes ONLY the objects created by LAB000. Programs, display
-- files and job descriptions are removed by each case's cleanup.
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

DROP INDEX ORDHDRI1;
DROP INDEX ORDHDRI2;
DROP INDEX ORDDTLI1;
DROP TABLE CUSTSTMT;
DROP TABLE ORDEXCP;
DROP TABLE ORDDTL;
DROP TABLE ORDHDR;
DROP TABLE ITEMMAST;
DROP TABLE CUSTMAST;
