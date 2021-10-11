unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,graph3d, ExtCtrls, StdCtrls, MMSystem, Jpeg;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
 
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    TimerId: uint;
    { Private declarations }
  public
    { Public declarations }
  end;
     Txy=record
   x,y,s:integer;
   end;
var
  Form1: TForm1;
  Bit:TBitMAp;
  Cub,cubr:array[1..8] of TVertex3d2d;
  H:TRender3d;
  pb:PRgb;
  i,j:integer;
  vr:integer;
  cosx,siny:double;
    cosx1,siny1:double;
  t:double;
 im:TBitMap;
 Tex1:TTexture;
    DefWidth, DefHeight, BPP: word;
      Tex:array[0..50] of Txy;
         ttt:integer;
implementation

{$R *.dfm}
procedure DrawMatrix;
 var
 i,j:integer;
 r:single;
 cs:integer;
begin


 for i:=1 to 619 do

    for j:=1 to 619 do
    begin

     r:=round((tex1.texture[j,i].g+tex1.texture[j,i-1].g+tex1.texture[j,i+1].g+tex1.texture[j-1,i].g+tex1.texture[j+1,i+1].g+tex1.texture[j-1,i+1].g+tex1.texture[j+1,i-1].g+tex1.texture[j-1,i-1].g)*0.1251) ;
     r:=r-(random);
       if (i=0) or (i=620) then r:=0;
        if (j=0) or (j=620) then r:=0;
    if r>255 then r:=255;
if r<0 then r:=0 ;


tex1.texture[j,i].g:=round(r);


  end;
    ;



{for i:=0 to 619 do
for j:=0 to 619 do
begin
  
if tex1.texture[j][i].r<=5 then tex1.texture[j][i].r:=5;
    tex1.texture[j][i].r:=tex1.texture[j][i].r-5;
end; }

   for i:=0 to 50 do
   begin
 if vr mod  tex[i].s =0 then
 begin tex[i].y:=tex[i].y+20;
im.Canvas.TextOut(tex[i].x,tex[i].y,char(50+Random(200)));
end;
   if tex[i].y>=620 then begin
   tex[i].y:=-20;
   tex[i].s:=1+random(7);
   end;
   end;
end;





procedure TForm1.FormCreate(Sender: TObject);
begin
bit:=Tbitmap.Create;
bit.Width:=640;
bit.height:=480;
bit.PixelFormat:=pf24bit;
im:=TBitMap.Create;
im.Width:=621;
im.Height:=621;
im.PixelFormat:=pf24bit;
h:=Trender3d.Create(640,480,Bit);
h.BitMapToPointer(pb,bit);
h.BitMapToPointer(tex1.texture,im);
tex1.width:=620;
tex1.height:=620;
h.Texture:=@tex1;
h.RotateKamera(0,0,0);
h.MoveKamera(0,0,-900);h.FrontFace:=false;
cub[1].X3DM:=-2400;
cub[1].Y3DM:=-2400;
cub[1].Z3DM:=-2400;

cub[2].X3DM:=-2400;
cub[2].Y3DM:=2400;
cub[2].Z3DM:=-2400;

cub[3].X3DM:=2400;
cub[3].Y3DM:=2400;
cub[3].Z3DM:=-2400;

cub[4].X3DM:=2400;
cub[4].Y3DM:=-2400;
cub[4].Z3DM:=-2400;

cub[5].X3DM:=-2400;
cub[5].Y3DM:=-2400;
cub[5].Z3DM:=2400;

cub[6].X3DM:=-2400;
cub[6].Y3DM:=2400;
cub[6].Z3DM:=2400;

cub[7].X3DM:=2400;
cub[7].Y3DM:=2400;
cub[7].Z3DM:=2400;

cub[8].X3DM:=2400;
cub[8].Y3DM:=-2400;
cub[8].Z3DM:=2400;
h.Fog.R:=100;
h.Fog.G:=200;
h.Fog.b:=100;
h.Fog.L:=6000;
h.TextureEnabled:=true;
bit.Canvas.Brush.Color:=0;


 randomize;
im.Canvas.Brush.Color:=0;
im.Canvas.FillRect(Rect(0,0,621,621));
im.Canvas.Font.Assign(Form1.Font);
im.Canvas.Font.Color:=rgb(0,255,0);
   for i:=0 to 50 do
   begin
   tex[i].x:=i*20;
   tex[i].y:=-20;
   tex[i].s:=1+random(7);

   end;
 im.Canvas.Brush.Style:=bsclear;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    vr:=vr+1;
h.FillZBuffer;
drawmatrix;
t:=t+10;
            randomize;
bit.Canvas.FillRect(Rect(0,0,640,480));
siny:=sin(pi2*1/360);
cosx:=cos(pi2*1/360);
siny1:=sin(pi2*1/60);
cosx1:=cos(pi2*1/60);

//if vr mod 2 =0 then begin h.MoveKamera(-100,0,-1100);im.Canvas.Brush.Color:=255   end  else  begin h.MoveKamera(100,0,-1100);im.Canvas.Brush.Color:=clblue end ;
 im.canvas.FillRect(rect(0,0,1000,1000));
h.MoveKamera(2000*sin(t/500),2000*cos(t/1000),2000*cos(t/1450));
h.SetPointKamera(2000*cos(t/400),2000*cos(t/2200),2000*sin(t/650));
for i:=1 to 8 do
begin
cubr[i].X3DM:=(cub[i].X3DM*cosx-cub[i].y3DM*siny);
cubr[i].y3DM:=(cub[i].X3DM*siny+cub[i].y3DM*cosx)*siny1-cub[i].z3DM*cosx1;
cubr[i].z3DM:=(cub[i].X3DM*siny+cub[i].y3DM*cosx)*cosx1+cub[i].z3DM*siny1;
end;

for i:=1 to 8 do
begin
h.xyz2D(cubr[i]);
end;

cubr[1].TX:=0;
cubr[1].Ty:=620;
cubr[3].TX:=620;
cubr[3].Ty:=0;
cubr[2].TX:=0;
cubr[2].Ty:=0;
h.FillTriangle(cubr[1],cubr[3],cubr[2],0,255,255);
cubr[1].TX:=0;
cubr[1].Ty:=620;
cubr[4].TX:=620;
cubr[4].Ty:=620;
cubr[3].TX:=620;
cubr[3].Ty:=0;
h.FillTriangle(cubr[1],cubr[4],cubr[3],0,255,255);


cubr[4].TX:=0;
cubr[4].Ty:=620;
cubr[7].TX:=620;
cubr[7].Ty:=0;
cubr[3].TX:=0;
cubr[3].Ty:=0;
h.FillTriangle(cubr[4],cubr[7],cubr[3],0,255,255);
cubr[4].TX:=0;
cubr[4].Ty:=620;
cubr[8].TX:=620;
cubr[8].Ty:=620;
cubr[7].TX:=620;
cubr[7].Ty:=0;
h.FillTriangle(cubr[4],cubr[8],cubr[7],0,255,255);


cubr[8].TX:=0;
cubr[8].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
cubr[7].TX:=0;
cubr[7].Ty:=0;
h.FillTriangle(cubr[8],cubr[6],cubr[7],0,255,255);

cubr[8].TX:=0;
cubr[8].Ty:=620;
cubr[5].TX:=620;
cubr[5].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
h.FillTriangle(cubr[8],cubr[5],cubr[6],0,255,255);
cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[2].TX:=620;
cubr[2].Ty:=0;
cubr[6].TX:=0;
cubr[6].Ty:=0;
h.FillTriangle(cubr[5],cubr[2],cubr[6],0,255,255);
cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[1].TX:=620;
cubr[1].Ty:=620;
cubr[2].TX:=620;
cubr[2].Ty:=0;
h.FillTriangle(cubr[5],cubr[1],cubr[2],0,255,255);

cubr[3].TX:=0;
cubr[3].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
cubr[2].TX:=0;
cubr[2].Ty:=0;
h.FillTriangle(cubr[3],cubr[6],cubr[2],0,255,255);

cubr[3].TX:=0;
cubr[3].Ty:=620;
cubr[7].TX:=620;
cubr[7].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
h.FillTriangle(cubr[3],cubr[7],cubr[6],0,255,255);


cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[4].TX:=620;
cubr[4].Ty:=0;
cubr[1].TX:=0;
cubr[1].Ty:=0;
h.FillTriangle(cubr[5],cubr[4],cubr[1],0,255,255);
cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[8].TX:=620;
cubr[8].Ty:=620;
cubr[4].TX:=620;
cubr[4].Ty:=0;
h.FillTriangle(cubr[5],cubr[8],cubr[4],0,255,255);


   h.SetPointKamera(2000*cos(t/400),2000*cos(t/2200),2000*sin(t/650));


 for i:=1 to 8 do
begin
cubr[i].X3DM:=(cub[i].X3Dm)/10+2000*cos(t/400);
cubr[i].y3DM:=(cub[i].y3DM)/10+2000*cos(t/2200);
cubr[i].z3DM:=(cub[i].z3DM)/10+2000*sin(t/650);
end;

for i:=1 to 8 do
begin
h.xyz2D(cubr[i]);
end;

cubr[1].TX:=0;
cubr[1].Ty:=620;
cubr[3].TX:=620;
cubr[3].Ty:=0;
cubr[2].TX:=0;
cubr[2].Ty:=0;
h.FillTriangle(cubr[1],cubr[3],cubr[2],0,255,255);
cubr[1].TX:=0;
cubr[1].Ty:=620;
cubr[4].TX:=620;
cubr[4].Ty:=620;
cubr[3].TX:=620;
cubr[3].Ty:=0;
h.FillTriangle(cubr[1],cubr[4],cubr[3],0,255,255);


cubr[4].TX:=0;
cubr[4].Ty:=620;
cubr[7].TX:=620;
cubr[7].Ty:=0;
cubr[3].TX:=0;
cubr[3].Ty:=0;
h.FillTriangle(cubr[4],cubr[7],cubr[3],0,255,255);
cubr[4].TX:=0;
cubr[4].Ty:=620;
cubr[8].TX:=620;
cubr[8].Ty:=620;
cubr[7].TX:=620;
cubr[7].Ty:=0;
h.FillTriangle(cubr[4],cubr[8],cubr[7],0,255,255);


cubr[8].TX:=0;
cubr[8].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
cubr[7].TX:=0;
cubr[7].Ty:=0;
h.FillTriangle(cubr[8],cubr[6],cubr[7],0,255,255);

cubr[8].TX:=0;
cubr[8].Ty:=620;
cubr[5].TX:=620;
cubr[5].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
h.FillTriangle(cubr[8],cubr[5],cubr[6],0,255,255);
cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[2].TX:=620;
cubr[2].Ty:=0;
cubr[6].TX:=0;
cubr[6].Ty:=0;
h.FillTriangle(cubr[5],cubr[2],cubr[6],0,255,255);
cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[1].TX:=620;
cubr[1].Ty:=620;
cubr[2].TX:=620;
cubr[2].Ty:=0;
h.FillTriangle(cubr[5],cubr[1],cubr[2],0,255,255);

cubr[3].TX:=0;
cubr[3].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
cubr[2].TX:=0;
cubr[2].Ty:=0;
h.FillTriangle(cubr[3],cubr[6],cubr[2],0,255,255);

cubr[3].TX:=0;
cubr[3].Ty:=620;
cubr[7].TX:=620;
cubr[7].Ty:=620;
cubr[6].TX:=620;
cubr[6].Ty:=0;
h.FillTriangle(cubr[3],cubr[7],cubr[6],0,255,255);


cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[4].TX:=620;
cubr[4].Ty:=0;
cubr[1].TX:=0;
cubr[1].Ty:=0;
h.FillTriangle(cubr[5],cubr[4],cubr[1],0,255,255);
cubr[5].TX:=0;
cubr[5].Ty:=620;
cubr[8].TX:=620;
cubr[8].Ty:=620;
cubr[4].TX:=620;
cubr[4].Ty:=0;
h.FillTriangle(cubr[5],cubr[8],cubr[4],0,255,255);



//h.CreateFog;
form1.Canvas.StretchDraw(Rect(0,0,width,height),bit);



end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
application.Terminate;
end;

end.
