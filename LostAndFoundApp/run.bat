@echo off
setlocal

:: Set project directories
set "PROJECT_DIR=%~dp0"
set "SRC_DIR=%PROJECT_DIR%src"
set "LIB_JAR=%PROJECT_DIR%lib\mysql-connector-j-9.3.0.jar"
set "OUT_DIR=%PROJECT_DIR%out"
set "SOURCE_LIST=%PROJECT_DIR%sources.txt"

:: Clean previous build
echo Cleaning previous build...
if exist "%OUT_DIR%" rmdir /s /q "%OUT_DIR%"
mkdir "%OUT_DIR%"

:: Check if src directory exists
if not exist "%SRC_DIR%" (
  echo 'src' directory not found in: %PROJECT_DIR%
  exit /b 1
)

:: Find all .java files and save to sources.txt
dir /s /b "%SRC_DIR%\*.java" > "%SOURCE_LIST%"

:: Check if sources.txt is empty
for %%I in (%SOURCE_LIST%) do set SIZE=%%~zI
if "%SIZE%"=="0" (
  echo ❌ No Java source files found in %SRC_DIR%
  del "%SOURCE_LIST%"
  exit /b 1
)

:: Compile Java files
echo  Compiling Java files...
javac -cp "%LIB_JAR%" -d "%OUT_DIR%" @"%SOURCE_LIST%"
if errorlevel 1 (
  echo Compilation failed.
  del "%SOURCE_LIST%"
  exit /b 1
)

:: Clean up
del "%SOURCE_LIST%"

:: Run main class
echo Running application...
java -cp "%OUT_DIR%;%LIB_JAR%" app.Main

endlocal

