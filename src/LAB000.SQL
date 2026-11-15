-- ===================================================================
-- LAB000  Build and seed the Order Lab
-- Book: IBM i Troubleshooting for Beginners (Ankur Johari)
-- Source type: SQL      Member: LAB000 in ORDLAB/QSQLSRC
--
-- Run:  RUNSQLSTM SRCFILE(ORDLAB/QSQLSRC) SRCMBR(LAB000) COMMIT(*NONE)
--
-- Replace ORDLAB below (one place) with your own library name.
-- Status: written, NOT yet executed on IBM i.
-- ===================================================================

SET SCHEMA ORDLAB;

CREATE TABLE CUSTMAST (
  CUSTNO    DECIMAL(7, 0)  NOT NULL,
  CUSTNAME  CHAR(30)       NOT NULL,
  CITY      CHAR(20)       NOT NULL,
  CONSTRAINT CUSTMAST_PK PRIMARY KEY (CUSTNO)
) RCDFMT CUSTMASTR;

CREATE TABLE ITEMMAST (
  ITEMNO    CHAR(10)       NOT NULL,
  ITEMDESC  CHAR(30)       NOT NULL,
  CONSTRAINT ITEMMAST_PK PRIMARY KEY (ITEMNO)
) RCDFMT ITEMMASTR;

CREATE TABLE ORDHDR (
  ORDNO     DECIMAL(9, 0)  NOT NULL,
  CUSTNO    DECIMAL(7, 0)  NOT NULL,
  ORDDATE   DATE           NOT NULL,
  ORDSTS    CHAR(1)        NOT NULL DEFAULT 'O',
  SHIPDATE  DATE           NOT NULL DEFAULT '0001-01-01',
  MRGAMT    DECIMAL(11, 2) NOT NULL DEFAULT 0,
  CHGCOUNT  INTEGER        NOT NULL DEFAULT 0,
  NOTE      CHAR(40)       NOT NULL DEFAULT ' ',
  CONSTRAINT ORDHDR_PK PRIMARY KEY (ORDNO)
) RCDFMT ORDHDRR;

CREATE TABLE ORDDTL (
  ORDNO     DECIMAL(9, 0)  NOT NULL,
  LINENO    DECIMAL(3, 0)  NOT NULL,
  ITEMNO    CHAR(10)       NOT NULL,
  QTY       DECIMAL(7, 0)  NOT NULL,
  LINEAMT   DECIMAL(11, 2) NOT NULL,
  LINECOST  DECIMAL(11, 2) NOT NULL,
  MRGPCT    DECIMAL(7, 2)  NOT NULL DEFAULT 0,
  MRGSTS    CHAR(1)        NOT NULL DEFAULT 'N',
  CONSTRAINT ORDDTL_PK PRIMARY KEY (ORDNO, LINENO)
) RCDFMT ORDDTLR;

-- Exception log written by batch programs
CREATE TABLE ORDEXCP (
  EXCTS     TIMESTAMP      NOT NULL,
  PGM       CHAR(10)       NOT NULL,
  ORDNO     DECIMAL(9, 0)  NOT NULL,
  LINENO    DECIMAL(3, 0)  NOT NULL,
  STATUS    DECIMAL(5, 0)  NOT NULL,
  MSG       CHAR(80)       NOT NULL
) RCDFMT ORDEXCPR;

-- Output of the customer statement program (CASE-015)
CREATE TABLE CUSTSTMT (
  CUSTNO    DECIMAL(7, 0)  NOT NULL,
  ORDCOUNT  INTEGER        NOT NULL,
  RUNTS     TIMESTAMP      NOT NULL
) RCDFMT CUSTSTMTR;

-- Keyed access paths used by the RPGLE programs
CREATE INDEX ORDHDRI1 ON ORDHDR (ORDNO);
CREATE INDEX ORDHDRI2 ON ORDHDR (CUSTNO, ORDNO);
CREATE INDEX ORDDTLI1 ON ORDDTL (ORDNO, LINENO);

-- ---------------- Seed data (fictional) ----------------------------

INSERT INTO CUSTMAST VALUES
  (5001, 'Kaveri Industrial Supplies', 'Pune'),
  (5002, 'Northgate Engineering',      'Ludhiana'),
  (5003, 'Coastline Fabrication',      'Kochi'),
  (5004, 'Deccan Pump Services',       'Hyderabad');

INSERT INTO ITEMMAST VALUES
  ('BOLT-M8',    'Hex bolt M8 x 40'),
  ('NUT-M8',     'Hex nut M8'),
  ('GASKET-50',  'Flange gasket 50 mm'),
  ('VALVE-25',   'Ball valve 25 mm'),
  ('PUMP-HX2',   'Centrifugal pump HX2'),
  ('SAMPLE-KIT', 'Promotional sample kit');

INSERT INTO ORDHDR (ORDNO, CUSTNO, ORDDATE, ORDSTS) VALUES
  (100101, 5001, '2026-11-02', 'S'),
  (100102, 5002, '2026-11-02', 'O'),
  (100103, 5001, '2026-11-03', 'O'),
  (100104, 5003, '2026-11-03', 'P'),
  (100105, 5004, '2026-11-04', 'P'),
  (100106, 5002, '2026-11-04', 'O');

INSERT INTO ORDDTL (ORDNO, LINENO, ITEMNO, QTY, LINEAMT, LINECOST)
VALUES
  (100101, 1, 'BOLT-M8',   100,  250.00,  180.00),
  (100101, 2, 'NUT-M8',    100,  120.00,   70.00),
  (100102, 1, 'GASKET-50',  20,  400.00,  310.00),
  (100103, 1, 'VALVE-25',    4, 1800.00, 1350.00),
  (100103, 2, 'BOLT-M8',    50,  125.00,   90.00),
  (100104, 1, 'PUMP-HX2',    1, 9500.00, 7600.00),
  (100105, 1, 'NUT-M8',    200,  240.00,  140.00),
  (100105, 2, 'GASKET-50',  10,  200.00,  155.00),
  (100106, 1, 'VALVE-25',    2,  900.00,  675.00);
