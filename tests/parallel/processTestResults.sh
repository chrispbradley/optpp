#!/bin/sh

/bin/rm -f failures.log details.log results.dat
touch failures.log details.log results.dat

echo "-------------------------------------------------------" >> details.log;
echo " " >> details.log;
echo "OPT++ parallel test results: " `date` >> details.log ;
echo " " >> details.log;
echo "-------------------------------------------------------" >> details.log;

runcommand=$1

for reg_test in ./tstfdnewtpds ./tstnewtpds ./tstpds ./tsttrpds ./tstGSS
do
#
#   First check to see if the program runs at all
#
    if ($runcommand $reg_test erosen 2); then
	if [ -f erosen.out ]; then
	    mv erosen.out $reg_test.out;
        else
	    mv erosen.out.0 $reg_test.out;
	fi
    else
	echo -e "$reg_test crashed\n" >> failures.log;
    fi
#
#   Now check to see if the test problems passed/failed
#
    set status = `grep PASSED $reg_test.out >> details.log`
    set status = `grep FAILED $reg_test.out >> details.log`
    set status = `grep PASSED $reg_test.out >> results.dat`
    set status = `grep FAILED $reg_test.out >> results.dat`
done
#
#   If any of the tests resulted in a failure store result in failures log
#   The flag -s checks for existence and nonzero size file
#
set status = `grep -l FAILED *.out >> failures.log`
#
#  Print out messages depending on whether all tests passed or not
#
if [ -s failures.log ]; then
    echo "----------------------------------------------------------------";
    echo " ";
    echo "  OPT++ parallel test results: FAILURES DETECTED";
    echo "  ";
    echo "      " `date` ;
    echo " ";
    echo "The following tests failed:";
    echo `cat failures.log`;
    echo " "
    echo "Please check the *.out files for details";
    echo "----------------------------------------------------------------";

    echo "----------------------------------------------------" >> details.log;
    echo "OPT++ parallel test results: FAILURES DETECTED" >> details.log;
    echo "----------------------------------------------------" >> details.log;

else
    echo "----------------------------------------------------------------";
    echo " ";
    echo "  OPT++ parallel test results: all tests PASSED";
    echo "  ";
    echo "      " `date` ;
    echo "----------------------------------------------------------------";

    echo "----------------------------------------------------" >> details.log;
    echo "OPT++ parallel test results: all tests PASSED" >> details.log;
    echo "-----------------------
-----------------------------" >> details.log;

fi

exit 0
