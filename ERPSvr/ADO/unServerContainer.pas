unit unServerContainer;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSTCPServerTransport,
  Datasnap.DSServer, Datasnap.DSCommonServer, IPPeerServer, IPPeerAPI,
  Datasnap.DSAuth, unGlobal;

type
  TServerContainer = class(TDataModule)
    DSServer1: TDSServer;
    DSTCPServerTransport1: TDSTCPServerTransport;
    DSServerClass1: TDSServerClass;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  ServerContainer: TServerContainer;

implementation


{$R *.dfm}

uses
  unServerMethods;

procedure TServerContainer.DataModuleCreate(Sender: TObject);
begin
  DSTCPServerTransport1.Port := g_Port;
  DSServer1.Start;
end;

procedure TServerContainer.DSServerClass1GetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := unServerMethods.TServerMethods;
end;

end.

