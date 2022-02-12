; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppVersion "1.0"
#define MyAppPublisher "Themelio Labs"
#define MyAppURL "https://themelio.org/"
#define MyAppExeName "ginkou-loader.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{09220679-1AE0-43B6-A263-AAE2CC36B9E4}}
AppName={cm:MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL} 
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{cm:MyAppName}
DefaultGroupName={cm:MyAppName}
OutputBaseFilename=mellis-windows-setup
Compression=lzma2
SolidCompression=yes
; WizardStyle=modern

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
en.MyAppName=Mellis

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[InstallDelete]
Type: filesandordirs; Name: "{app}\*"

[Files]
Source: "MicrosoftEdgeWebview2Setup.exe"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "dir\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\ginkou\public"; DestDir: "{app}\ginkou-public"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{group}\{cm:UninstallProgram,{cm:MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; Parameters: "--html-path ginkou-public" ; WorkingDir: "{app}"

[Run]
Filename: "{app}\MicrosoftEdgeWebview2Setup"; StatusMsg: "Installing WebView2..."; Parameters: "/install"; Check: WebView2IsNotInstalled


[Code]
function WebView2IsNotInstalled: Boolean;
  var Pv: String;
  var key64: String;
  var key32: String;
begin
    key64 := 'SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}';
    key32 := 'SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}'; 
    Result := True;
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, key64, 'pv', Pv) then 
    begin
        Result := 0 = Length(pV);
    end
    else begin
       if RegQueryStringValue(HKEY_LOCAL_MACHINE, key32, 'pv', Pv)  then
       begin
          Result := 0 = Length(pV);
       end;
    end; 
end;
