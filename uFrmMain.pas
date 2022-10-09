unit uFrmMain;

interface

uses
  FMX.ActnList,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.DialogService,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Maps,
  FMX.Media,
  FMX.MediaLibrary.Actions,
  FMX.Objects,
  FMX.Platform,
  FMX.StdActns,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.Types,
  {$IFDEF ANDROID}
  AndroidApi.Helpers,
  AndroidApi.JNI.App,
  AndroidApi.JNI.GraphicsContentViewText,
  AndroidApi.JNI.JavaTypes,
  AndroidApi.JNI.Net,
  AndroidApi.JNI.Os,
  AndroidApi.JNI.Provider,
  AndroidApi.JNI.Telephony,
  AndroidApi.JNIBridge,
  FMX.Maps.Android,
  FMX.Platform.Android,
  {$ENDIF}
  System.Actions,
  System.Classes,
  System.Permissions,
  System.Sensors,
  System.Sensors.Components,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;

type
  TFrmMain = class(TForm)
    rectTop: TRectangle;
    lblTitle: TLabel;
    lstbMain: TListBox;
    lstbiCamera: TListBoxItem;
    swtCamera: TSwitch;
    lstbiReadFile: TListBoxItem;
    swtReadFile: TSwitch;
    lstbiWriteFile: TListBoxItem;
    swtWriteFile: TSwitch;
    lstbiLocationCoarse: TListBoxItem;
    swtLocationCoarse: TSwitch;
    lstbiLocationGPS: TListBoxItem;
    swtLocationGPS: TSwitch;
    rectBottom: TRectangle;
    imgCamera: TImage;
    tbcMain: TTabControl;
    tbiFeatures: TTabItem;
    tbiCamera: TTabItem;
    imgCameraTake: TImage;
    actlMain: TActionList;
    takeCamera: TTakePhotoFromCameraAction;
    tbchgMain: TChangeTabAction;
    rectCamera: TRectangle;
    rectShare: TRectangle;
    shareImage: TShowShareSheetAction;
    rectPicture: TRectangle;
    takePicture: TTakePhotoFromLibraryAction;
    SensorLocation: TLocationSensor;
    tbiMap: TTabItem;
    imgMap: TImage;
    mapMain: TMapView;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    lblMapCoord: TLabel;
    lstbiReadPhoneState: TListBoxItem;
    swtReadPhoneState: TSwitch;
    lstbiReadPhoneNumber: TListBoxItem;
    swtReadPhoneNumber: TSwitch;
    imgHome: TImage;

    procedure FormCreate(Sender: TObject);
    procedure swtCameraSwitch(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure swtReadFileSwitch(Sender: TObject);
    procedure swtWriteFileSwitch(Sender: TObject);
    procedure swtLocationCoarseSwitch(Sender: TObject);
    procedure swtLocationGPSSwitch(Sender: TObject);
    procedure swtReadPhoneStateSwitch(Sender: TObject);
    procedure takeCameraDidFinishTaking(Image: TBitmap);
    procedure imgCameraClick(Sender: TObject);
    procedure rectCameraClick(Sender: TObject);
    procedure rectShareClick(Sender: TObject);
    procedure shareImageBeforeExecute(Sender: TObject);
    procedure rectPictureClick(Sender: TObject);
    procedure takePictureDidFinishTaking(Image: TBitmap);
    procedure imgMapClick(Sender: TObject);
    procedure SensorLocationLocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
    procedure swtReadPhoneNumberSwitch(Sender: TObject);
    procedure imgHomeClick(Sender: TObject);
  private
    procedure PermissionMessage(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure PermissionResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);

    function DevicePhoneNumber: string;
    function DevicePhoneNumbers: TArray<string>;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

const
  {$IFDEF ANDROID}
  PermissionCamera = 'android.permission.CAMERA';
  PermissionReadExternalStorage = 'android.permission.READ_EXTERNAL_STORAGE';
  PermissionWriteExternalStorage = 'android.permission.WRITE_EXTERNAL_STORAGE';
  PermissionAccessCoarseLocation = 'android.permission.ACCESS_COARSE_LOCATION';
  PermissionAccessFineLocation = 'android.permission.ACCESS_FINE_LOCATION';
  PermissionReadPhoneState = 'android.permission.READ_PHONE_STATE';
  PermissionReadCallLog = 'android.permission.READ_CALL_LOG';
  PermissionReadPhoneNumber = 'android.permission.READ_PHONE_NUMBERS';
  {$ENDIF}
  JustificationCamera = 'O aplicativo precisa acessar a câmera do dispositivo.';
  JustificationReadExternalStorage = 'O aplicativo precisa ler arquivos do dispositivo.';
  JustificationWriteExternalStorage = 'O aplicativo precisa escrever arquivos do dispositivo.';
  JustificationAccessCoarseLocation = 'O aplicativo precisa da Localização Aproximada do dispositivo.';
  JustificationAccessFineLocation = 'O aplicativo precisa da Localização por GPS do dispositivo.';
  JustificationReadPhoneState = 'O aplicativo precisa da Leitura do Estado do dispositivo.';
  JustificationReadPhoneNumber = 'O aplicativo precisa da Leitura do Número de Telefone do dispositivo.';

implementation

{$R *.fmx}

procedure TFrmMain.PermissionMessage(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
var
  LCount: integer;
  LMsg: string;
begin
  {$IFDEF ANDROID}
  for LCount := Low(APermissions) to High(APermissions) do
  begin
    if APermissions[LCount] = PermissionCamera then
    begin
      LMsg := LMsg + JustificationCamera + sLineBreak;
    end
    else if APermissions[LCount] = PermissionReadExternalStorage then
    begin
      LMsg := LMsg + JustificationReadExternalStorage + sLineBreak;
    end
    else if APermissions[LCount] = PermissionWriteExternalStorage then
    begin
      LMsg := LMsg + JustificationWriteExternalStorage + sLineBreak;
    end
    else if APermissions[LCount] = PermissionAccessCoarseLocation then
    begin
      LMsg := LMsg + JustificationAccessCoarseLocation + sLineBreak;
    end
    else if APermissions[LCount] = PermissionAccessFineLocation then
    begin
      LMsg := LMsg + JustificationAccessFineLocation + sLineBreak;
    end
    else if APermissions[LCount] = PermissionReadPhoneState then
    begin
      LMsg := LMsg + JustificationReadPhoneState + sLineBreak;
    end
    else if APermissions[LCount] = PermissionReadPhoneNumber then
    begin
      LMsg := LMsg + JustificationReadPhoneNumber + sLineBreak;
    end;
  end;

  TDialogService.ShowMessage(LMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end);
  {$ENDIF}
end;

procedure TFrmMain.PermissionResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
var
  LCount: integer;
begin
  {$IFDEF ANDROID}
  for LCount := Low(APermissions) to High(APermissions) do
  begin
    {$REGION 'PermissionCamera'}
    if APermissions[LCount] = PermissionCamera then
    begin
      if (AGrantResults[LCount] = TPermissionStatus.Granted) then
      begin
        lstbiCamera.ItemData.Detail := 'Liberado o acesso na Câmera.';
        swtCamera.IsChecked := True;
        swtCamera.Enabled := False;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.Denied) then
      begin
        lstbiCamera.ItemData.Detail := 'Acesso na Câmera, não liberado.';
        swtCamera.Enabled := True;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.PermanentlyDenied) then
      begin
        lstbiCamera.ItemData.Detail := 'Acesso na Câmera, não liberado permanentemente.';
        swtCamera.Enabled := True;
      end;
    end;
    {$ENDREGION}
    {$REGION 'PermissionReadExternalStorage'}
    if APermissions[LCount] = PermissionReadExternalStorage then
    begin
      if (AGrantResults[LCount] = TPermissionStatus.Granted) then
      begin
        lstbiReadFile.ItemData.Detail := 'Liberado o acesso para Leitura de Arquivos.';
        swtReadFile.IsChecked := True;
        swtReadFile.Enabled := False;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.Denied) then
      begin
        lstbiReadFile.ItemData.Detail := 'Acesso para Leitura de Arquivos, não liberado.';
        swtReadFile.Enabled := True;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.PermanentlyDenied) then
      begin
        lstbiReadFile.ItemData.Detail := 'Acesso para Leitura de Arquivos, não liberado permanentemente.';
        swtReadFile.Enabled := True;
      end;
    end;
    {$ENDREGION}
    {$REGION 'PermissionWriteExternalStorage'}
    if APermissions[LCount] = PermissionWriteExternalStorage then
    begin
      if (AGrantResults[LCount] = TPermissionStatus.Granted) then
      begin
        lstbiWriteFile.ItemData.Detail := 'Liberado o acesso para Escrita de Arquivos.';
        swtWriteFile.IsChecked := True;
        swtWriteFile.Enabled := False;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.Denied) then
      begin
        lstbiWriteFile.ItemData.Detail := 'Acesso para Escrita de Arquivos, não liberado.';
        swtWriteFile.Enabled := True;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.PermanentlyDenied) then
      begin
        lstbiWriteFile.ItemData.Detail := 'Acesso para Escrita de Arquivos, não liberado permanentemente.';
        swtWriteFile.Enabled := True;
      end;
    end;
    {$ENDREGION}
    {$REGION 'PermissionAccessCoarseLocation'}
    if APermissions[LCount] = PermissionAccessCoarseLocation then
    begin
      if (AGrantResults[LCount] = TPermissionStatus.Granted) then
      begin
        lstbiLocationCoarse.ItemData.Detail := 'Liberado o acesso para Localização Aproximada.';
        swtLocationCoarse.IsChecked := True;
        swtLocationCoarse.Enabled := False;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.Denied) then
      begin
        lstbiLocationCoarse.ItemData.Detail := 'Acesso para Localização Aproximada, não liberado.';
        swtLocationCoarse.Enabled := True;
        SensorLocation.Active := False;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.PermanentlyDenied) then
      begin
        lstbiLocationCoarse.ItemData.Detail := 'Acesso para Localização Aproximada, não liberado permanentemente.';
        swtLocationCoarse.Enabled := True;
        SensorLocation.Active := False;
      end;
    end;
    {$ENDREGION}
    {$REGION 'PermissionAccessFineLocation'}
    if APermissions[LCount] = PermissionAccessFineLocation then
    begin
      if (AGrantResults[LCount] = TPermissionStatus.Granted) then
      begin
        lstbiLocationGPS.ItemData.Detail := 'Liberado o acesso para Localização por GPS.';
        swtLocationGPS.IsChecked := True;
        swtLocationGPS.Enabled := False;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.Denied) then
      begin
        lstbiLocationGPS.ItemData.Detail := 'Acesso para Localização por GPS, não liberado.';
        swtLocationGPS.Enabled := True;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.PermanentlyDenied) then
      begin
        lstbiLocationGPS.ItemData.Detail := 'Acesso para Localização por GPS, não liberado permanentemente.';
        swtLocationGPS.Enabled := True;
      end;
    end;
    {$ENDREGION}
    {$REGION 'PermissionReadPhoneState'}
    if APermissions[LCount] = PermissionReadPhoneState then
    begin
      if (AGrantResults[LCount] = TPermissionStatus.Granted) then
      begin
        lstbiReadPhoneState.ItemData.Detail := 'Liberado o acesso para Leitura do Estado do Telefone.';
        swtReadPhoneState.IsChecked := True;
        swtReadPhoneState.Enabled := False;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.Denied) then
      begin
        lstbiReadPhoneState.ItemData.Detail := 'Acesso para Leitura do Estado do Telefone, não liberado.';
        swtReadPhoneState.Enabled := True;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.PermanentlyDenied) then
      begin
        lstbiReadPhoneState.ItemData.Detail := 'Acesso para Leitura do Estado do Telefone, não liberado permanentemente.';
        swtReadPhoneState.Enabled := True;
      end;
    end;
    {$ENDREGION}
    {$REGION 'PermissionReadPhoneNumber'}
    if APermissions[LCount] = PermissionReadPhoneNumber then
    begin
      if (AGrantResults[LCount] = TPermissionStatus.Granted) then
      begin
        lstbiReadPhoneNumber.ItemData.Detail := 'Liberado o acesso para Leitura do Número do Telefone.';
        swtReadPhoneNumber.IsChecked := True;
        swtReadPhoneNumber.Enabled := False;

        for var i: integer := Low(DevicePhoneNumbers) to High(DevicePhoneNumbers) do
          lstbiReadPhoneNumber.ItemData.Detail := //
             lstbiReadPhoneNumber.ItemData.Detail + //
             ' [' + DevicePhoneNumbers[i] + '] ';
      end
      else if (AGrantResults[LCount] = TPermissionStatus.Denied) then
      begin
        lstbiReadPhoneNumber.ItemData.Detail := 'Acesso para Leitura do Número do Telefone, não liberado.';
        swtReadPhoneNumber.Enabled := True;
      end
      else if (AGrantResults[LCount] = TPermissionStatus.PermanentlyDenied) then
      begin
        lstbiReadPhoneNumber.ItemData.Detail := 'Acesso para Leitura do Número do Telefone, não liberado permanentemente.';
        swtReadPhoneNumber.Enabled := True;
      end;
    end;
    {$ENDREGION}
  end;
  {$ENDIF}
end;

function TFrmMain.DevicePhoneNumber: string;
var
  LObj: JObject;
  LPhone: JTelephonyManager;
begin
  LObj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.TELECOM_SERVICE);
  if not(LObj = nil) then
  begin
    LPhone := TJTelephonyManager.Wrap(LObj);
    if not(LObj = nil) then
    begin
      Result := JStringToString(LPhone.getLine1Number);
    end;
  end;
end;

function TFrmMain.DevicePhoneNumbers: TArray<string>;
var
  LSubMgr: JSubscriptionManager;
  LFor, LCount: integer;
  LSubList: JList;
  LSubInfo: JSubscriptionInfo;
begin
  if TOSVersion.Check(5, 1) then
  begin
    LSubMgr := TJSubscriptionManager.JavaClass.from(TAndroidHelper.Context);
    LCount := LSubMgr.getActiveSubscriptionInfoCount;
    LSubList := LSubMgr.getActiveSubscriptionInfoList;

    for LFor := 0 to Pred(LCount) do
    begin
      LSubInfo := TJSubscriptionInfo.Wrap(LSubList.get(LFor));
      if not(LSubInfo = nil) then
      begin
        Result[LFor] := JStringToString(LSubInfo.getNumber);
      end;
    end;
  end
  else
  begin
    SetLength(Result, LCount);
    Result[0] := DevicePhoneNumber;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  Self.Height := 720;
  Self.Width := 480;

  tbcMain.TabPosition := TTabPosition.Dots;
  {$ENDIF}
  {$IFDEF ANDROID}
  tbcMain.TabPosition := TTabPosition.None;
  {$ENDIF}
  tbcMain.ActiveTab := tbiFeatures;

  mapMain.LayerOptions := [ //
     TMapLayerOption.PointsOfInterest //
     , TMapLayerOption.Buildings //
     , TMapLayerOption.UserLocation //
     , TMapLayerOption.Traffic];
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  {$IFDEF ANDROID}
  PermissionsService.RequestPermissions([ //
     PermissionCamera //
     , PermissionReadExternalStorage //
     , PermissionWriteExternalStorage //
     , PermissionAccessCoarseLocation //
     , PermissionAccessFineLocation //
     , PermissionReadPhoneState //
     , PermissionReadPhoneNumber //
     ], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.swtCameraSwitch(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(PermissionCamera) then
    PermissionsService.RequestPermissions([PermissionCamera], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.swtReadFileSwitch(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(PermissionReadExternalStorage) then
    PermissionsService.RequestPermissions([PermissionReadExternalStorage], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.swtWriteFileSwitch(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(PermissionWriteExternalStorage) then
    PermissionsService.RequestPermissions([PermissionWriteExternalStorage], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.swtLocationCoarseSwitch(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(PermissionAccessCoarseLocation) then
    PermissionsService.RequestPermissions([PermissionAccessCoarseLocation], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.swtLocationGPSSwitch(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(PermissionAccessFineLocation) then
    PermissionsService.RequestPermissions([PermissionAccessFineLocation], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.swtReadPhoneStateSwitch(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(PermissionReadPhoneState) then
    PermissionsService.RequestPermissions([PermissionReadPhoneState], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.swtReadPhoneNumberSwitch(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(PermissionReadPhoneNumber) then
    PermissionsService.RequestPermissions([PermissionReadPhoneNumber], PermissionResult, PermissionMessage);
  {$ENDIF}
end;

procedure TFrmMain.imgHomeClick(Sender: TObject);
begin
  SensorLocation.Active := False;

  tbchgMain.Tab := tbiFeatures;
  tbchgMain.Execute;
end;

procedure TFrmMain.imgCameraClick(Sender: TObject);
begin
  tbchgMain.Tab := tbiCamera;
  tbchgMain.Execute;
end;

procedure TFrmMain.imgMapClick(Sender: TObject);
begin
  tbchgMain.Tab := tbiMap;
  tbchgMain.Execute;

  try
    SensorLocation.Active := True;
  except
    on E: Exception do
    begin
      SensorLocation.Active := False;

      TDialogService.ShowMessage( //
         'Erro ao abrir o Mapa!' + sLineBreak + //
         E.ClassName + '. ' + E.Message);
    end;
  end;
end;

procedure TFrmMain.rectCameraClick(Sender: TObject);
begin
  try
    takeCamera.MaxHeight := 2048;
    takeCamera.MaxWidth := 2048;

    takeCamera.CustomText := 'Fotos Tirada do Dispositivo Android em ' + FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now);

    takeCamera.Editable := True;
    takeCamera.NeedSaveToAlbum := True;

    takeCamera.Execute;
  except
    on E: Exception do
    begin
      TDialogService.ShowMessage( //
         'Erro ao abrir a Câmera!' + sLineBreak + //
         E.ClassName + '. ' + E.Message);
    end;
  end;
end;

procedure TFrmMain.takeCameraDidFinishTaking(Image: TBitmap);
begin
  imgCameraTake.Bitmap.Assign(Image);
end;

procedure TFrmMain.rectPictureClick(Sender: TObject);
begin
  try
    takePicture.MaxHeight := 2048;
    takePicture.MaxWidth := 2048;

    takePicture.CustomText := 'Fotos do Dispositivo Android em ' + FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now);

    takePicture.Editable := True;

    takePicture.Execute;
  except
    on E: Exception do
    begin
      TDialogService.ShowMessage( //
         'Erro ao abrir a Câmera!' + sLineBreak + //
         E.ClassName + '. ' + E.Message);
    end;
  end;
end;

procedure TFrmMain.takePictureDidFinishTaking(Image: TBitmap);
begin
  imgCameraTake.Bitmap.Assign(Image);
end;

procedure TFrmMain.rectShareClick(Sender: TObject);
begin
  try
    shareImage.TextMessage := 'Fotos do Dispositivo Android em ' + FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now);
    shareImage.Execute;
  except
    on E: Exception do
    begin
      TDialogService.ShowMessage( //
         'Erro ao tentar compartilhar!' + sLineBreak + //
         E.ClassName + '. ' + E.Message);
    end;
  end;
end;

procedure TFrmMain.shareImageBeforeExecute(Sender: TObject);
begin
  shareImage.Bitmap.Assign(imgCameraTake.Bitmap);
end;

procedure TFrmMain.SensorLocationLocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
var
  LLat: Double;
  LLng: Double;
  LInfo: string;
begin
  LLat := NewLocation.Latitude;
  LLng := NewLocation.Longitude;
  LInfo := Format('Você está aqui! (Lat: %3.7f Lng: %3.7f)', [LLat, LLng]);
  lstbiLocationGPS.ItemData.Detail := LInfo;
  lblMapCoord.Text := LInfo;
end;

end.
