REM Mumu Android 6.0.1 version 2.6.16.0 desktop verison 2.5.7

set /p keyalias=< key/key.txt
java -jar helper\bundletool-all-1.10.0.jar build-apks --bundle="app.aab" --output="app.apks" --overwrite --ks=key/keystore.jks --ks-pass=file:key/keystore.pwd --ks-key-alias=%keyalias% --key-pass=file:key/key.pwd

"helper\platform-tools\adb.exe" connect 127.0.0.1:7555
java -jar helper\bundletool-all-1.10.0.jar install-apks --apks="app.apks" --adb="helper\platform-tools\adb.exe"

pause
