**free
// ------------------------------------------------------------------
// ORDFMT    Formatting procedures (service program)  (CASE-017)
// Version WITH THE TYPO: status 'S' is shown as 'Shiped'.
// The lab fixes the text, rebuilds the service program, and shows
// that a job which has already used it keeps the old copy.
//
// Build:
//   CRTRPGMOD MODULE(ORDLAB/ORDFMT) SRCFILE(ORDLAB/QRPGLESRC)
//   CRTSRVPGM SRVPGM(ORDLAB/ORDFMT) MODULE(ORDLAB/ORDFMT)
//             EXPORT(*ALL)
// Status: written, NOT yet compiled or executed on IBM i.
// ------------------------------------------------------------------
ctl-opt nomain;

dcl-proc fmtStatus export;
  dcl-pi *n varchar(20);
    sts char(1) const;
  end-pi;

  select;
    when sts = 'O';
      return 'Open';
    when sts = 'P';
      return 'Picked';
    when sts = 'S';
      return 'Shiped';                 // typo fixed in the lab
    other;
      return 'Unknown (' + sts + ')';
  endsl;
end-proc;
