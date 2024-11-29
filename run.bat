call d:\Aldec\Riviera-PRO-2024.04-x64\etc\setenv.bat 
set VUNIT_SIMULATOR=rivierapro
set CONTRIBUTION=0
vsim -version
python run.py %1 %2 %3 %4 %5
rem vsim -c -do "do src/runme.do; quit"
rem pause
