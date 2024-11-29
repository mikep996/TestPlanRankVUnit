OVERVIEW:

    The sample design in this directory presents a new approach to the design
    verification methodology. Instead of focusing on detailed coverage results,
    the verification process aims at meeting requirements and allows reaching
    a higher level of project validation.

    The verification plan (testplan.ods) created with the LibreOffice Calc
    program, can be found in the input directory.
    The test plan, stored in the format compatible with XML Spreadsheet 2003
    (testplan.xml), is located in the same directory as the previous file.
    Subsequently, the XML document is imported to an ACDB file by using
    the xml2acdb command.

    The design goes through all prepared test cases in order to obtain coverage
    results. The six designed test cases meet the Functional and Code Coverage
    verification requirements.
    Since some of them are redundant, the acdb rank command has to be used
    in order to find only the contribution tests against all others to determine
    their usability.

    Once the macro is executed, two HTML reports will be generated.
    The first one is obtained after running the simulation with the verification
    plan (results.html), whereas the second one is created after the ranking
    operation (rank.html).


LANGUAGE:

        SystemVerilog

___________________________
(c) Aldec, Inc.
All rights reserved.

Last modified: $Date: 2015-02-26 08:24:56 +0100 (Thu, 26 Feb 2015) $
$Revision: 357294 $
