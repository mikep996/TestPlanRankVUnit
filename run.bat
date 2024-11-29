call d:\Aldec\Riviera-PRO-2024.04-x64\etc\setenv.bat 
set VUNIT_SIMULATOR=rivierapro
vsim -version
python run.py %1 %2 %3 %4 %5
vsim -c -do "do src/runme.do; quit"
rem pause
