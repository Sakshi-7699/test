@echo off
REM Directories (Update these paths accordingly)
SET SOURCE_DIR=C:\path\to\source          REM Directory containing the original files
SET INPUT_DIR=C:\path\to\input            REM Directory to place the input files
SET PROCESS_DIR=C:\path\to\process        REM Directory where Java script processes the file
SET FINAL_DIR=C:\path\to\final_output     REM Directory to place the final output files
SET SCRIPT1=C:\path\to\first_java_script  REM First Java script
SET SCRIPT2=C:\path\to\second_java_script REM Second Java script
SET SCRIPT3=C:\path\to\third_script       REM Third script to run at the end

REM Ensure the directories exist
if not exist "%INPUT_DIR%" mkdir "%INPUT_DIR%"
if not exist "%PROCESS_DIR%" mkdir "%PROCESS_DIR%"
if not exist "%FINAL_DIR%" mkdir "%FINAL_DIR%"

REM Loop through all files in the source directory
for %%f in ("%SOURCE_DIR%\*") do (
    REM Get the filename without the path
    set "filename=%%~nxf"
    
    REM Copy the file to the input directory
    copy "%%f" "%INPUT_DIR%\%filename%"

    REM Create a file with the same name in the process directory
    copy "%%f" "%PROCESS_DIR%\%filename%"
    
    REM Run the first Java script and wait for it to finish
    echo Running first Java script on %filename%
    java -jar "%SCRIPT1%" "%PROCESS_DIR%\%filename%" 
    if errorlevel 1 (
        echo Error running first Java script on %filename%. Exiting.
        exit /b 1
    )

    REM Move the updated output file to the final output directory
    copy "%PROCESS_DIR%\%filename%" "%FINAL_DIR%\%filename%"

    REM Create a file with the same name in the final output directory
    echo Running second Java script on %filename%
    java -jar "%SCRIPT2%" "%FINAL_DIR%\%filename%"
    if errorlevel 1 (
        echo Error running second Java script on %filename%. Exiting.
        exit /b 1
    )
)

REM Run the final script after processing all files
echo Running final script...
call "%SCRIPT3%"

echo Processing complete.
pause
