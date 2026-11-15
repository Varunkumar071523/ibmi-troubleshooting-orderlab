-- ===================================================================
-- L014SET  CASE-014 setup: invoice table, three shipped orders and
--          one shipped free-sample order with a zero value.
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(L014SET) COMMIT(*NONE)
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

CREATE TABLE ORDINV (
  INVORD    DECIMAL(9, 0)  NOT NULL,
  INVAMT    DECIMAL(11, 2) NOT NULL,
  INVTS     TIMESTAMP      NOT NULL,
  INVJOB    CHAR(28)       NOT NULL,
  CONSTRAINT ORDINV_AMT CHECK (INVAMT > 0)
) RCDFMT ORDINVR;

UPDATE ORDHDR SET ORDSTS = 'S' WHERE ORDNO IN (100104, 100105);

-- Free sample shipment: one line, zero value
INSERT INTO ORDHDR (ORDNO, CUSTNO, ORDDATE, ORDSTS)
  VALUES (100108, 5004, '2026-11-05', 'S');
INSERT INTO ORDDTL (ORDNO, LINENO, ITEMNO, QTY, LINEAMT, LINECOST)
  VALUES (100108, 1, 'SAMPLE-KIT', 1, 0.00, 4.50);
