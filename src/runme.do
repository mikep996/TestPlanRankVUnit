# (c) Aldec, Inc.
# All rights reserved.
#
# modified: $Date: 2017-04-25 12:23:39 +0200 (Tue, 25 Apr 2017) $
# $Revision: 448552 $
# VUnit modification: 2024-11-29 14:56 (Fri, 29 Nov 2024)

package require fileutil
set fileList {}

# preparing coverage list for merge
foreach file [fileutil::findByPattern "./vunit_out/test_output" *.acdb] {
	regexp {(./vunit_out/test_output/lib.)(.*)(\.)(.*)(_)(.*)(/rivierapro/coverage.acdb)} $file m0 m1 m2 m3 m4 m5 m6;
	puts $file
	puts $m2
	if [string match "*.*" $m2] {
		regexp {(.*)(\.)(.*)} $m2 l0 l1 l2 l3 ;
		set testbench $l1
		set testname $l3
	} else {
		set testbench $m2
		set testname $m4
	}
	puts $testbench
	puts $testname
    lappend fileList -i $file 
	# update the proper testname for coverage.acdb file (if needed)
	catch {acdb edit -i $file -move testname coverage $testname}
}

file mkdir output

# Import test plan to ACDB
xml2acdb -dataorder id,feature,description,link,type,weight,user,user -i input/testplan.xml -o input/plan.acdb
# Merge test plan with simulation results
acdb merge -associative $fileList -i input/plan.acdb -o output/results.acdb 
# Generate reports
acdb report -html -o output/results.html -i output/results.acdb
acdb rank -i output/results.acdb -html -o output/rank.html

if ![ batch_mode ] {
	# Open HTML Viewer with coverage results
	system.open output/results.html
	
	# Open HTML Viewer with ranked results
	system.open output/rank.html
}