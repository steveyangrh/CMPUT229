# Author: Alejandro Ramirez
# Date: March 4, 2015
#
# USAGE: ./runAllTests.sh LABFILE
#
# Loops through all testfiles in the tests folder,
# calling runTest on each of them. Based on the code
# by Taylor Lloyd for marking purposes. 

mkdir -p testEnv
cat test.s > testEnv/testSol.s
cat $1 >> testEnv/testSol.s

echo "Test 0:"
touch testEnv/packet.out
cp tests/test0.in testEnv/packet.in
echo "	Diff against:"
echo -n "	"
cd testEnv
rm -f run.out
spim -file testSol.s > run.out
awk '{if((NR>5)==1) print $0}' run.out
cd ..
diff -s tests/test0.out testEnv/packet.out

echo "Test 1:"
rm testEnv/packet.*
touch testEnv/packet.out
cp tests/test1.in testEnv/packet.in
echo "	Diff against:"
echo -n "	"
cd testEnv
rm -f run.out
spim -file testSol.s > run.out
awk '{if((NR>5)==1) print $0}' run.out
cd ..
diff -s tests/test1.out testEnv/packet.out

echo "Test 2:"
rm testEnv/packet.*
touch testEnv/packet.out
cp tests/test2.in testEnv/packet.in
echo "	Diff against:"
echo -n "	"
cd testEnv
spim -file testSol.s > run.out
awk '{if((NR>5)==1) print $0}' run.out
cd ..
diff -s tests/test2.out testEnv/packet.out

rm -rf testEnv

