# IBM i Troubleshooting for Beginners — Order Lab

**Official companion source-code repository**

**Book:** IBM i Troubleshooting for Beginners  
**Subtitle:** 51 Practical AS400 Scenarios for Job Logs, Batch Failures, CL, RPGLE, and Db2  
**Author:** Ankur Johari

## About this repository

This repository contains the 126 source files accompanying *IBM i Troubleshooting for Beginners*.

The book teaches IBM i troubleshooting through 51 practical scenarios covering job logs, batch failures, library lists, authority, file locks, CL, RPGLE, Db2 for i, spooled output, and the IFS.

## What's included

| Source type | Files |
|---|---:|
| CLLE | 60 |
| RPGLE | 31 |
| SQL | 17 |
| SQLRPGLE | 12 |
| DDS (PF, LF, DSPF) | 6 |
| **Total** | **126** |

## Getting started

1. Read the book's **The Order Lab** chapter.
2. Review the [setup instructions](src/START_HERE.txt).
3. Browse the [source-code files](src/).
4. Prepare an authorized IBM i practice library.
5. Follow the setup, exercise, and cleanup instructions for each case.

The common setup uses `LAB000.SQL` and `LABCORE.CLLE`, with additional RPGLE programs.

## Compatibility

The book targets IBM i 7.5, with notes for IBM i 7.6.

## Verification status

**The source files have not yet been compiled or runtime-tested on IBM i.**

The archive has passed file inventory and packaging checks. Some labs intentionally produce failures or change test objects. Never execute them against production systems.

## Copyright and usage

Copyright © 2026 Ankur Johari.

The companion source code may be copied and modified for personal learning, as permitted by the book's copyright notice. No broader redistribution or commercial-use license is granted by this repository.

This is an independent educational project and is not affiliated with or endorsed by IBM.

## Additional resources

[AS400Decoded — IBM i and RPGLE Learning](https://as400decoded.com/)
