unit Graph3d;


interface
 uses Graphics,math;
const pi2=6.283185307179586476925286766559   ;
Const FOCUS_KAMERA=300;
 type
BRGB = record
B:byte;
G:byte;
R:byte;
  end;
  TRgb=array[0..2000] of BRGB;
  PRGB=array[0..2000] of ^TRgb;
TVertex3D2D=record//oei aa?oeia
X3DM,Y3DM,Z3DM:double;//ie?iaua eii?aeiaou
X3DP,Y3DP,Z3DP:double; //ei?aeiaou i?iecaieuiie eaia?u
X2D,Y2D:double; //eii?aeiaou i?iaoe?iaaiey;
TX,TY:double;//eii?aeiaoa aa?oeiu oaenoo?u
end;
TAngle=Record//oei oaie
Sin,Cos:double;
end;
 Type TFog=record
 R,G,B:byte;
 L:double;
 end;

TTexture=record
Texture:PRGB;
width,height:integer;
end;

TVector=array[1..4] of double;//oei aaeoi?
TMatrix=array[1..4,1..4] of double;//oei iao?eoa
TTriangles=array[1..3] of TVertex3D2D;  //oei o?aoaieuiee
TRender3D = class
private
   {$A4}
 MatrixOX:TMatrix;
MatrixOY:TMatrix;
MatrixOZ:TMatrix;
MatrixResult:TMatrix;
triangl,trianglr,trianglr1:TTriangles;
ArrayPointer:PRGB; //Iannea oi?ae aeoiaie ea?ou
Width,Height:integer;
cc1,cc2,cc3,cc4,c1,c2,c3,cc5,cc6:double;
ZBuffer:array of array of double;
fz,dil1:double;
z1,z2,z3:double;//ia?aoiua aaee?eiu z eii?aeiao
zmin,zmax,zmax1:double;//cia?aiey z ia?ao eioi?uie aoaao i?ienoiaeou eioa?iieyoey
zz1,zz3,zz5,cz1,cz2,cz3:double;
minxt,minyt:double;//cia?aiey eii?aeiao oaenoo?u ia?ao eioi?uie aoaao i?ienoiaeou eioa?iieyoey
tx1,tx3,tx5,ctx2:double;
ty1,ty3,ty5,cty2:double;
D,dx,dy,D2:double;
il1:double;
ZO,xo,yo:double;
an,bn,cn:double;
   {$A2}
fx,fy:integer;
kp,ko:integer;

 ScaleWidth,ScaleHeight:integer;
vo,vp:array[1..3] of integer;
//iao?eou iiai?ioia aie?oa inae ox,oy,oz
//================
//?acoeuoe?o?uay iao?eoa o??oia?iiai i?aia?aciaaiey
//================
Kamerax,KameraY,Kameraz:double; //iiei?aiea eiia?u a i?ino?ainoaa

procedure SortVertex(var Triangle:TTriangles;var xmax,xmin,ymax,ymin:double);//i?ioaao?a ni?oe?iaee 2D aa?oei
procedure PaintLineT(maxx,minx:double;y:integer;Zmin,Tminx,Tminy:double);//I?ioaao?a io?eniaee ai?eciioaeuiie oaenoo?iie eeiee
procedure PaintLine(maxx,minx:double;y:integer;Zmax,Zmin:double;R,G,B:byte);//I?ioaao?a io?eniaee ai?eciioaeuiie oaaoiie eeiee
procedure FillT(var Vertex1,Vertex2,vertex3:TVertex3d2d);
procedure Fill(var Vertex1,Vertex2,vertex3:TVertex3d2d;R,G,B:byte);
public
//oaeu iiai?ioia eaia?u ioiineoaeuii inae ox,oy,oz
//==================
   {$A4}
AngleKameraOX:TAngle;
AngleKameraOY:TAngle;
AngleKameraOZ:TAngle;
//==================
Texture:^TTexture;//oaenoo?a
TextureEnabled:boolean;
Fog:TFog;
FrontFace:boolean;
constructor Create(W,H:integer;Win3d:TBitMap);
procedure FillZBuffer; //Caiieiaiea aooa?a iaeneiaeuiui/ieieiaeuiui cia?aieai
function xyz2D(var Vertex:TVertex3D2D):boolean; //I?aia?aciaaiea 3D  eii?aeiao a 2D
procedure FillTriangle(var Vertex1,Vertex2,vertex3:TVertex3d2d;R,G,B:byte);//Io?eniaea o?aoaieuieea
Procedure RotateKamera(OX,OY,OZ:double); //i?ioaao?a iiai?ioa eaia?u
PRocedure MoveKamera(x,y,z:double); //i?ioaao?a aae?aiey eaia?u
Procedure BitMapToPointer(var PointerBitMap:PRgb; Bitmap:TBitMAp);//iieo?aiea ianneaa oeacaoaeae ia BitMap;
procedure CreateFog;
procedure SetPointKamera(X,Y,Z:double);
procedure point3d(Vertex:TVertex3d2d;r,g,b:byte);
end;

implementation
//---------------------------------------------------------------------------
constructor TRender3D.Create(W,H:integer;Win3d:TBitMap);
 var

 i:integer;
begin

 Win3d.Width:=W;
  Win3d.Height:=H;
  BitMaptoPointer(ArrayPointer,Win3d);
setlength(ZBuffer,w);
for i:=0 to w-1 do
setlength(zbuffer[i],h);
Width:=w-1;
Height:=h-1;
ScaleWidth:=W div 2;
ScaleHeight:=H div 2;
//eieoeeecaoey iao?eo
MatrixOX[1,1]:=1; MatrixOX[1,2]:=0;
MatrixOX[1,3]:=0; MatrixOX[1,4]:=0;
MatrixOX[2,1]:=0; MatrixOX[2,4]:=0;
MatrixOX[3,1]:=0; MatrixOX[3,4]:=0;
MatrixOX[4,1]:=0; MatrixOX[4,2]:=0;
MatrixOX[4,3]:=0; MatrixOX[4,4]:=1;
MatrixOY[1,2]:=0; MatrixOY[1,4]:=0;
MatrixOY[2,1]:=0; MatrixOY[2,2]:=1;
MatrixOY[2,3]:=0; MatrixOY[2,4]:=0;
MatrixOY[3,2]:=0; MatrixOY[3,4]:=0;
MatrixOY[4,1]:=0; MatrixOY[4,2]:=0;
MatrixOY[4,3]:=0; MatrixOY[4,4]:=1;
MatrixOZ[1,3]:=0; MatrixOZ[1,4]:=0;
MatrixOZ[2,3]:=0; MatrixOZ[2,4]:=0;
MatrixOZ[3,1]:=0; MatrixOZ[3,2]:=0;
MatrixOZ[3,3]:=1; MatrixOZ[3,4]:=0;
MatrixOZ[4,1]:=0; MatrixOZ[4,2]:=0;
MatrixOZ[4,3]:=0; MatrixOZ[4,4]:=1;
MatrixResult[1,4]:=0;
MatrixResult[2,4]:=0;
MatrixResult[3,4]:=0;
MatrixResult[4,1]:=0;
MatrixResult[4,2]:=0;
MatrixResult[4,3]:=0;
MatrixResult[4,4]:=1;
fog.R:=255;
fog.g:=255;
fog.b:=255;
fog.l:=1000;

D2:=1/Focus_kamera     ;
inherited Create;
end;
//---------------------------------------------------------------------------
procedure TRender3d.FillZBuffer;
var
i,j:integer;
begin

for i:=0 to width-1 do
 for j:=0 to Height-1 do
     zbuffer[i,j]:=$ffffffff;
end;
//---------------------------------------------------------------------------
function TRender3d.xyz2D(var Vertex:TVertex3D2D):boolean;
var
   {$A4}
Vec:TVector;
begin
result:=false;
Vec[1]:=Vertex.X3DM-KameraX;   
Vec[2]:=Vertex.y3DM-Kameray;
Vec[3]:=Vertex.z3DM-Kameraz;
Vertex.X3DP:= Vec[1]*matrixResult[1,1]+Vec[2]*matrixResult[1,2]+Vec[3]*matrixResult[1,3];
Vertex.Y3DP:= Vec[1]*matrixResult[2,1]+Vec[2]*matrixResult[2,2]+Vec[3]*matrixResult[2,3];
Vertex.Z3DP:= Vec[1]*matrixResult[3,1]+Vec[2]*matrixResult[3,2]+Vec[3]*matrixResult[3,3];

if (FOCUS_KAMERA+Vertex.Z3DP)<>0then
    begin
    Vertex.X2D:=(ScaleWidth+FOCUS_KAMERA*(Vertex.X3DP) /(FOCUS_KAMERA+Vertex.Z3DP));
    Vertex.Y2D:=(ScaleHEight-FOCUS_KAMERA*(Vertex.Y3DP) /(fOCUS_KAMERA+Vertex.Z3DP));
end;
end;
//---------------------------------------------------------------------------
procedure TRender3d.RotateKamera(ox,oy,oz:double);
begin
AngleKameraOX.Sin:=sin(pi2*ox/360);
AngleKameraOX.Cos:=cos(pi2*ox/360);
AngleKameraOy.Sin:=sin(pi2*oy/360);
AngleKameraOy.Cos:=cos(pi2*oy/360);
AngleKameraOz.Sin:=sin(pi2*oz/360);
AngleKameraOz.Cos:=cos(pi2*oz/360);
MatrixOX[3,2]:=-AngleKameraOX.Sin;
MatrixOX[3,3]:=AngleKameraOX.Cos;
MatrixOX[2,2]:=AngleKameraOX.Cos;
MatrixOX[2,3]:=AngleKameraOX.Sin;
MatrixOY[1,1]:=AngleKameraOy.Cos;
MatrixOY[1,3]:=AngleKameraOy.Sin;
MatrixOY[3,1]:=-AngleKameraOy.Sin;
MatrixOY[3,3]:=AngleKameraOy.Cos;
MatrixOZ[2,1]:=-AngleKameraOz.Sin;
MatrixOZ[2,2]:=AngleKameraOz.Cos;
MatrixOZ[1,1]:=AngleKameraOz.Cos;
MatrixOZ[1,2]:=AngleKameraOz.Sin;
MatrixResult[1,1]:=MatrixOZ[1,1]*MatrixOY[1,1]+MatrixOZ[2,1]*MatrixOY[3,1]*MatrixOX[2,3];
MatrixResult[1,2]:=MatrixOZ[2,1]*MatrixOX[2,2];
MatrixResult[1,3]:=MatrixOZ[1,1]*MatrixOY[1,3]+MatrixOZ[2,1]*MatrixOY[3,3]*MatrixOX[2,3];
MatrixResult[2,1]:=MatrixOZ[1,2]*MatrixOY[1,1]+MatrixOZ[2,2]*MatrixOY[3,1]*MatrixOX[2,3];
MatrixResult[2,2]:=MatrixOZ[2,2]*MatrixOX[2,2];
MatrixResult[2,3]:=MatrixOZ[1,2]*MatrixOY[1,3]+MatrixOZ[2,2]*MatrixOY[3,3]*MatrixOX[2,3];
MatrixResult[3,1]:=MatrixOY[3,1]*MatrixOX[3,3];
MatrixResult[3,2]:=MatrixOX[3,2];
MatrixResult[3,3]:=MatrixOY[3,3]*MatrixOX[3,3];
end;
//---------------------------------------------------------------------------
Procedure TRender3D.MoveKamera(x,y,z:double);
begin
Kamerax:=x;
Kameray:=y;
Kameraz:=z;
end;
//---------------------------------------------------------------------------
procedure TRender3d.SortVertex(var Triangle:TTriangles;var xmax,xmin,ymax,ymin:double);
var
M:TVertex3D2D;
i,j:integer;
m1:double;
TX:TTriangles;
begin
tx:=Triangle;
for i:=1 to 3 do
    for j:=1 to i do
        begin
         if Triangle[i].Y2D<=Triangle[j].Y2D then
            begin
            m := Triangle[j] ;
            Triangle[j]:=Triangle[i] ;
            Triangle[i]:=m ;
            end;
        end;

for i:=1 to 3 do
    for j:=1 to i do
        begin
        If tx[i].X2D<= tx[j].X2D Then
            begin
            m1 := tx[j].X2D ;
            tx[j].X2D := tx[i].X2D ;
            tx[i].X2D := m1 ;
            end;
         end;
  XMax:=tx[3].X2D;
  XMIn:=tx[1].X2D;
  yMax:=Triangle[3].Y2D;
  yMIn:=Triangle[1].Y2D


end;
//---------------------------------------------------------------------------
procedure TRender3d.FillTriangle(var Vertex1,Vertex2,vertex3:TVertex3d2d;R,G,B:byte);
begin
 if frontface=true then
 begin
  AN := (Vertex2.y3dp-Vertex1.y3dp)*(vertex3.z3dp-Vertex1.z3dp)-(Vertex2.z3dp-Vertex1.z3dp)*(vertex3.y3dp-Vertex1.y3dp) ;
    BN := (Vertex2.z3dp-Vertex1.z3dp)*(vertex3.x3dp-Vertex1.x3dp)-(Vertex2.x3dp-Vertex1.x3dp)*(vertex3.z3dp-Vertex1.z3dp) ;
    CN :=(Vertex2.x3dp-Vertex1.x3dp)*(vertex3.y3dp-Vertex1.y3dp)-(Vertex2.y3dp-Vertex1.y3dp)*(vertex3.x3dp-Vertex1.x3dp);

    if  cn*focus_kamera+an*Vertex1.x3dp+bn*Vertex1.y3dp+cn*Vertex1.z3dp<0 then
if TextureEnabled=false then fill( Vertex1,Vertex2,vertex3,r,g,b) else fillt( Vertex1,Vertex2,vertex3);
 end
 else
 if TextureEnabled=true then fillt( Vertex1,Vertex2,vertex3) else fill( Vertex1,Vertex2,vertex3,r,g,b);
 end;
//---------------------------------------------------------------------------
Procedure Trender3D.PaintLineT(maxx,minx:double;y:integer;zmin,Tminx,Tminy:double);
 var
    {$A2}
 max,min,i:integer;
    {$A4}
 raz:double;
begin
if (maxx>minx) then begin max:=trunc(maxx)-1;min:=trunc(minx) end else  begin max:=trunc(minx)-1;min:=trunc(maxx); end ;
if max<0 then max:=0; if max>width then max:=width;
if Min<0 then Min:=0; if Min>width then Min:=width;
 raz:=min-minx ;
zo:=zmin+(raz)*d;
xo:=tminx+(raz)*dx;
yo:=tminy+(raz)*dy;

for i:=min to max do
    begin
         zo:=zo+d;
        xo:=xo+dx;
        yo:=yo+dy;

        fz:=1/(zo) ;

        if (fz-focus_kamera<zbuffer[i,y])  then
        begin

         fx:=round(xo*fz);
         fy:=round(yo*fz);

                 if (fx>=0) and (fx<=texture.width) and (fy>=0) and (fy<=texture.height)  then
            begin
              ArrayPointer[y][i].r:=texture.texture[fy,fx].R ;
                ArrayPointer[y][i].G:= texture.texture[fy,fx].g;
                ArrayPointer[y][i].b:=texture.texture[fy,fx].b;
                ZBuffer[i,y]:=fz-focus_kamera;
                end;
       end;
      
    end;

end;
//---------------------------------------------------------------------------
Procedure Trender3d.PaintLine(maxx,minx:double;y:integer;Zmax,Zmin:double;R,G,B:byte);
 var
 max,min,i:integer;
 raz:double;

begin
 if (maxx-minx)<>0 then
 begin
if (maxx>minx) then begin max:=trunc(maxx)-1;min:=trunc(minx) end else  begin max:=trunc(minx)-1;min:=trunc(maxx); end ;


if max<0 then max:=0; if max>width then max:=width;
if Min<0 then Min:=0; if Min>width then Min:=width;

zo:=zmin+(min-minx)*d;
for i:=min to max do
    begin
          zo:=zo+d;
           fz:=1/zo-300;
        if  (fz<ZBuffer[i,y])   then
        begin
       ArrayPointer[y][i].r:=R ;
        ArrayPointer[y][i].G:= g;
        ArrayPointer[y][i].b:=b;
        ZBuffer[i,y]:=fz;
        end;
    
    end;
    end;
    end;
//---------------------------------------------------------------------------
procedure Trender3d.FillT(var Vertex1,Vertex2,vertex3:TVertex3d2d);
var
   {$A4}
Xmin,XMax:double;
Ymin,YMax:double;
MaxX,MinX,MaxX1:double;


i,j:integer;
y1,y2,y3:integer;
 x_start,x_end,z_start,z_end:double ;
 tx_start,tx_end,ty_start,ty_end:double ;
 yraz,yraz1:double;

begin
     kp:=0;
     ko:=0;



    triangl[1]:=vertex1;
    triangl[2]:=vertex2;
    triangl[3]:=vertex3;

     for i:=1 to 3 do
        begin
            if triangl[i].Z3DP<0 then
                begin
                    ko:=ko+1;
                    vo[ko]:=i;
                end
                else
                begin
                kp:=kp+1;
                vp[kp]:=i;
                end;
        end;

if ko=3  then exit;

if ko=2 then
    begin
        trianglr[vp[1]]:= triangl[vp[1]];
        trianglr[vo[1]].Z3DP:=0;
        trianglr[vo[2]].Z3DP:=0;
        trianglr[vo[1]].X3DP:=triangl[vo[1]].X3DP+(triangl[vp[1]].X3DP - triangl[vo[1]].X3DP)*(0-triangl[vo[1]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[1]].Z3DP) ;
        trianglr[vo[1]].Y3DP:=triangl[vo[1]].Y3DP+(triangl[vp[1]].Y3DP - triangl[vo[1]].Y3DP)*(0-triangl[vo[1]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[1]].Z3DP) ;
        trianglr[vo[1]].tx:=triangl[vo[1]].tx+(triangl[vp[1]].tx - triangl[vo[1]].tx)*(0-triangl[vo[1]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[1]].Z3DP) ;
        trianglr[vo[1]].ty:=triangl[vo[1]].ty+(triangl[vp[1]].ty - triangl[vo[1]].ty)*(0-triangl[vo[1]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[1]].Z3DP) ;
        trianglr[vo[1]].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr[vo[1]].X3DP) *d2);
        trianglr[vo[1]].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr[vo[1]].Y3DP) *d2);


        trianglr[vo[2]].X3DP:=triangl[vo[2]].X3DP+(triangl[vp[1]].X3DP - triangl[vo[2]].X3DP)*(0-triangl[vo[2]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[2]].Z3DP) ;
        trianglr[vo[2]].Y3DP:=triangl[vo[2]].Y3DP+(triangl[vp[1]].Y3DP - triangl[vo[2]].Y3DP)*(0-triangl[vo[2]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[2]].Z3DP) ;
        trianglr[vo[2]].tx:=triangl[vo[2]].tx+(triangl[vp[1]].tx - triangl[vo[2]].tx)*(0-triangl[vo[2]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[2]].Z3DP) ;
        trianglr[vo[2]].ty:=triangl[vo[2]].ty+(triangl[vp[1]].ty - triangl[vo[2]].ty)*(0-triangl[vo[2]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[2]].Z3DP) ;

        trianglr[vo[2]].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr[vo[2]].X3DP) *d2);
        trianglr[vo[2]].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr[vo[2]].Y3DP) *d2);

        fillt(trianglr[1],trianglr[2],trianglr[3]);
        exit;
    end;


   //D.t = A.t + (C.t - A.t) * (-dist - A.z) / (C.z - A.z)

if ko=1  then
    begin
    trianglr[1]:=triangl[vp[1]];
    trianglr[2]:=triangl[vp[2]];
    trianglr[3].Z3DP:=0;
    trianglr[3].X3DP :=triangl[vp[1]].X3DP +(triangl[vo[1]].X3DP-triangl[vp[1]].X3DP)*(0-triangl[vp[1]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[1]].Z3DP);
    trianglr[3].y3DP :=triangl[vp[1]].y3DP +(triangl[vo[1]].y3DP-triangl[vp[1]].y3DP)*(0-triangl[vp[1]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[1]].Z3DP);
     trianglr[3].tx :=triangl[vp[1]].tx +(triangl[vo[1]].tx-triangl[vp[1]].tx)*(0-triangl[vp[1]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[1]].Z3DP);
    trianglr[3].ty :=triangl[vp[1]].ty +(triangl[vo[1]].ty-triangl[vp[1]].ty)*(0-triangl[vp[1]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[1]].Z3DP);
     trianglr[3].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr[3].X3DP) *d2);
     trianglr[3].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr[3].Y3DP) *d2);

      trianglr1[1]:=triangl[vp[2]];

      trianglr1[2]:=trianglr[3];

        trianglr[3].Z3DP:=0;
    trianglr1[3].X3DP :=triangl[vp[2]].X3DP +(triangl[vo[1]].X3DP-triangl[vp[2]].X3DP)*(0-triangl[vp[2]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[2]].Z3DP);
    trianglr1[3].y3DP :=triangl[vp[2]].y3DP +(triangl[vo[1]].y3DP-triangl[vp[2]].y3DP)*(0-triangl[vp[2]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[2]].Z3DP);
     trianglr1[3].tx :=triangl[vp[2]].tx +(triangl[vo[1]].tx-triangl[vp[2]].tx)*(0-triangl[vp[2]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[2]].Z3DP);
    trianglr1[3].ty :=triangl[vp[2]].ty +(triangl[vo[1]].ty-triangl[vp[2]].ty)*(0-triangl[vp[2]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[2]].Z3DP);
     trianglr1[3].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr1[3].X3DP) *d2);
     trianglr1[3].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr1[3].Y3DP) *d2);




        fillt(trianglr[1],trianglr[2],trianglr[3]);
         fillt(trianglr1[1],trianglr1[2],trianglr1[3]);

        exit;

    end;


    SortVertex(triangl,Xmax,xmin,ymax,ymin);


    if ymax<0 then ymax:=0; if ymax>height then ymax:=height;
    if ymin<0 then ymin:=0; if ymin>height then ymin:=height;
    if xmax<0 then xmax:=0; if xmax>width then xmax:=width;
    if xmin<0 then xmin:=0; if xmin>width then xmin:=width;
    if (ymax <> ymin) and (xmax <> xmin) then
        begin
 z1:=(1/(FOCUS_KAMERA+triangl[1].Z3DP));
 z2:=(1/(FOCUS_KAMERA+triangl[2].Z3DP));
 z3:=(1/(FOCUS_KAMERA+triangl[3].Z3DP));
        zz1:=(z2-z1);
        zz3:=(z3-z1);
        zz5:= (z3-z2);


        triangl[1].TX:=triangl[1].TX*z1;
        triangl[2].TX:=triangl[2].TX*z2;
        triangl[3].TX:=triangl[3].TX*z3;

        triangl[1].Ty:=triangl[1].Ty*z1;
        triangl[2].Ty:=triangl[2].Ty*z2;
        triangl[3].Ty:=triangl[3].Ty*z3;


        tx1:=(triangl[2].TX-triangl[1].TX);
        tx3:=(triangl[3].TX-triangl[1].TX);
        tx5:= (triangl[3].TX-triangl[2].TX);

        ty1:=(triangl[2].TY-triangl[1].TY);
        ty3:=(triangl[3].TY-triangl[1].TY);
        ty5:= (triangl[3].TY-triangl[2].TY);


        cc1:=(Triangl[2].x2d-Triangl[1].x2d);
        cc2:=(Triangl[2].y2d-Triangl[1].y2d);
        cc3:=(Triangl[3].x2d-Triangl[1].x2d);
        cc4:=(Triangl[3].y2d-Triangl[1].y2d);
        cc5:=(Triangl[3].x2d-Triangl[2].x2d);
        cc6:=(Triangl[3].y2d-Triangl[2].y2d);
        if (cc2<>0)then begin c1:=cc1/cc2; end;
        if (cc4<>0)then begin c2:=cc3/cc4;cz2:=zz3/cc4;ctx2:=tx3/cc4;cty2:=ty3/cc4; end;
        if (cc6<>0)then begin c3:=cc5/cc6; end;
x_start := Triangl[1].x2d+cc2*c2;
x_end := Triangl[2].x2d;
Z_start := z1+cc2*cz2;
Z_end := z2;
tx_start := Triangl[1].tx+cc2*ctx2;
tx_end := Triangl[2].tx;
ty_start := Triangl[1].ty+cc2*cty2;
ty_end :=Triangl[2].ty;


if (x_start-x_end)<>0 then  dil1:= 1/(x_start-x_end);
d:= (z_start-z_end)*dil1;

dx:= (tx_start-tx_end)*dil1;

dy:= (ty_start-ty_end)*dil1;


        y1:=round(0.5+ymin);
        y2:=round(0.5+Triangl[2].y2d);
        y3:=round(0.5+ymax)-1;
        if y2<0 then y2:=0;

         yraz:=y1-triangl[1].y2d  ;
         yraz1:=y2-triangl[2].y2d ;
         MinX := Triangl[1].x2d+(yraz)*c2;
          maxX :=Triangl[1].x2d+(yraz)*c1;
           maxX1 :=Triangl[2].x2d+(yraz1)*c3;


            MinXt := Triangl[1].tx+(yraz)*ctx2;


              Minyt := Triangl[1].ty+(yraz)*cty2;

         zmin:=z1+(yraz)*cz2;




          for j:=y1 to y3 do
            begin
            if j< y2 then
                begin
                    PaintLineT((MaxX),(MinX),j,zmin,minxt,minyt);
                     maxX :=maxX+c1;
                 end
                 else
                 begin
                         PaintLineT((MaxX1),(MinX),j,zmin,minxt,minyt);
                        maxX1 :=maxX1+c3;
                end;
                MinX := MinX+c2;
                zmin:=zmin+cz2;
                minyt:=minyt+cty2;
                minxt:=minxt+ctx2;
            end;
    end;
end;
//---------------------------------------------------------------------------
procedure tRender3D.Fill(var Vertex1,Vertex2,vertex3:TVertex3d2d;R,G,B:byte);
var
   {$A4}
Xmin,XMax:double;
Ymin,YMax:double;
MaxX,MaxX1,MinX:double;
x_start,x_end,z_start,z_end:double ;
i,j:integer;
y1,y2,y3:integer;
 ko,kp:integer;
begin

    triangl[1]:=vertex1;
    triangl[2]:=vertex2;
    triangl[3]:=vertex3;


         kp:=0;
     ko:=0;



    triangl[1]:=vertex1;
    triangl[2]:=vertex2;
    triangl[3]:=vertex3;

     for i:=1 to 3 do
        begin
            if triangl[i].Z3DP<0 then
                begin
                    ko:=ko+1;
                    vo[ko]:=i;
                end
                else
                begin
                kp:=kp+1;
                vp[kp]:=i;
                end;
        end;

if ko=3  then exit;

if ko=2 then
    begin
        trianglr[vp[1]]:= triangl[vp[1]];
        trianglr[vo[1]].Z3DP:=0;
        trianglr[vo[2]].Z3DP:=0;
        trianglr[vo[1]].X3DP:=triangl[vo[1]].X3DP+(triangl[vp[1]].X3DP - triangl[vo[1]].X3DP)*(0-triangl[vo[1]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[1]].Z3DP) ;
        trianglr[vo[1]].Y3DP:=triangl[vo[1]].Y3DP+(triangl[vp[1]].Y3DP - triangl[vo[1]].Y3DP)*(0-triangl[vo[1]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[1]].Z3DP) ;

        trianglr[vo[1]].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr[vo[1]].X3DP) *d2);
        trianglr[vo[1]].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr[vo[1]].Y3DP) *d2);


        trianglr[vo[2]].X3DP:=triangl[vo[2]].X3DP+(triangl[vp[1]].X3DP - triangl[vo[2]].X3DP)*(0-triangl[vo[2]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[2]].Z3DP) ;
        trianglr[vo[2]].Y3DP:=triangl[vo[2]].Y3DP+(triangl[vp[1]].Y3DP - triangl[vo[2]].Y3DP)*(0-triangl[vo[2]].Z3DP)/(triangl[vp[1]].Z3DP-triangl[vo[2]].Z3DP) ;


        trianglr[vo[2]].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr[vo[2]].X3DP) *d2);
        trianglr[vo[2]].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr[vo[2]].Y3DP) *d2);

        fill(trianglr[1],trianglr[2],trianglr[3],r,g,b);
        exit;
    end;


   //D.t = A.t + (C.t - A.t) * (-dist - A.z) / (C.z - A.z)

if ko=1  then
    begin
    trianglr[1]:=triangl[vp[1]];
    trianglr[2]:=triangl[vp[2]];
    trianglr[3].Z3DP:=0;
    trianglr[3].X3DP :=triangl[vp[1]].X3DP +(triangl[vo[1]].X3DP-triangl[vp[1]].X3DP)*(0-triangl[vp[1]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[1]].Z3DP);
    trianglr[3].y3DP :=triangl[vp[1]].y3DP +(triangl[vo[1]].y3DP-triangl[vp[1]].y3DP)*(0-triangl[vp[1]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[1]].Z3DP);

     trianglr[3].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr[3].X3DP) *d2);
     trianglr[3].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr[3].Y3DP) *d2);

      trianglr1[1]:=triangl[vp[2]];

      trianglr1[2]:=trianglr[3];

        trianglr[3].Z3DP:=0;
    trianglr1[3].X3DP :=triangl[vp[2]].X3DP +(triangl[vo[1]].X3DP-triangl[vp[2]].X3DP)*(0-triangl[vp[2]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[2]].Z3DP);
    trianglr1[3].y3DP :=triangl[vp[2]].y3DP +(triangl[vo[1]].y3DP-triangl[vp[2]].y3DP)*(0-triangl[vp[2]].Z3DP)/(triangl[vo[1]].Z3DP-triangl[vp[2]].Z3DP);

     trianglr1[3].X2D:=(ScaleWidth+FOCUS_KAMERA*(trianglr1[3].X3DP) *d2);
     trianglr1[3].Y2D:=(ScaleHEight-FOCUS_KAMERA*(trianglr1[3].Y3DP) *d2);




        fill(trianglr[1],trianglr[2],trianglr[3],r,g,b);
         fill(trianglr1[1],trianglr1[2],trianglr1[3],r,g,b);

        exit;

    end;


    SortVertex(triangl,Xmax,xmin,ymax,ymin);
    if ymax<0 then ymax:=0; if ymax>height then ymax:=height;
    if ymin<0 then ymin:=0; if ymin>height then ymin:=height;
    if xmax<0 then xmax:=0; if xmax>width then xmax:=width;
    if xmin<0 then xmin:=0; if xmin>width then xmin:=width;
    if (ymax <> ymin) and (xmax <> xmin) then
        begin
        if (FOCUS_KAMERA+triangl[1].Z3DP)<>0 then z1:=(1/(FOCUS_KAMERA+triangl[1].Z3DP));
        if (FOCUS_KAMERA+triangl[2].Z3DP)<>0 then z2:=(1/(FOCUS_KAMERA+triangl[2].Z3DP));
        if (FOCUS_KAMERA+triangl[3].Z3DP)<>0 then z3:=(1/(FOCUS_KAMERA+triangl[3].Z3DP));
        zz1:=(z2-z1);
        zz3:=(z3-z1);
        zz5:= (z3-z2);
        cc1:=(Triangl[2].x2d-Triangl[1].x2d);
        cc2:=(Triangl[2].y2d-Triangl[1].y2d);
        cc3:=(Triangl[3].x2d-Triangl[1].x2d);
        cc4:=(Triangl[3].y2d-Triangl[1].y2d);
        cc5:=(Triangl[3].x2d-Triangl[2].x2d);
        cc6:=(Triangl[3].y2d-Triangl[2].y2d);
        if (cc2<>0)then begin c1:=cc1/cc2; cz1:=zz1/cc2; end;
        if (cc4<>0)then begin c2:=cc3/cc4;cz2:=zz3/cc4;end;
        if (cc6<>0)then begin c3:=cc5/cc6;cz3:=zz5/cc6; end;
  
x_start := Triangl[1].x2d+(Triangl[2].y2d-Triangl[1].y2d)*c2;
x_end := Triangl[2].x2d;
Z_start := z1+(Triangl[2].y2d-Triangl[1].y2d)*cz2;
Z_end := z2;
if (x_start-x_end)<>0 then d:= (z_start-z_end)/(x_start-x_end);

             y1:=round(0.5+ymin);
        y2:=round(0.5+Triangl[2].y2d);
        y3:=round(0.5+ymax)-1;
        if y2<0 then y2:=0;
         MinX := Triangl[1].x2d+(y1-triangl[1].y2d)*c2;
         zmin:=z1+(y1-triangl[1].y2d)*cz2;

         maxX :=Triangl[1].x2d+(y1-triangl[1].y2d)*c1;
         zmax:=z1+(y1-triangl[1].y2d)*cz1 ;

         maxX1 :=Triangl[2].x2d+(y2-triangl[2].y2d)*c3;
         zmax1:=z2+(y2-triangl[2].y2d)*cz3 ;



        for j:=y1 to y3 do
            begin

                if j< y2 then
                    begin
                         PaintLine((MaxX),(MinX),j,zmax,zmin,r,g,b);
                        zmax:=zmax+cz1;
                        maxX :=maxX+c1;
                    end
                    else

                    begin
                    PaintLine((MaxX1),(MinX),j,zmax1,zmin,r,g,b);
                    zmax1:=zmax1+cz3 ;
                    maxX1 :=maxX1+c3;

                end;
                 MinX := MinX+c2;
                zmin:=zmin+cz2;
            end;
    end;
end;
//---------------------------------------------------------------------------
procedure TRender3d.BitMapToPointer(var PointerBitMap:PRgb; Bitmap:TBitMAp);
var i:integer;
H:integer;
begin
 h:=bitmap.height-1 ;
 for i:=0 to h do
PointerBitMap[i]:=Bitmap.ScanLine[i];
end;
//---------------------------------------------------------------------------
procedure TRender3d.CreateFog;
var
   {$A2}
i,j:integer;
    {$A4}
per,per1:double;
begin
 per:=-1/(fog.L);
for i:=0 to width-1 do
    for j:=0 to Height-1 do
        begin
            if (zbuffer[i,j]<>$ffffffff) and (zbuffer[i,j]<fog.L) then
                begin
                    per1:=per*(zbuffer[i,j]-fog.L) ;
                    ArrayPointer[j][i].R:=round(fog.R+(ArrayPointer[j][i].R-fog.R)*per1);
                    ArrayPointer[j][i].g:=round(fog.g+(ArrayPointer[j][i].g-fog.g)*per1);
                    ArrayPointer[j][i].b:=round(fog.b+(ArrayPointer[j][i].b-fog.b)*per1);
                end
                else
                begin
                 ArrayPointer[j][i].R:=fog.R;
                    ArrayPointer[j][i].g:=fog.g;
                    ArrayPointer[j][i].b:=fog.b;
                end;
        end;
end;
//---------------------------------------------------------------------------
Procedure Trender3d.SetPointKamera(x,y,z:double);
var
   {$A4}
vx,vy,vz:double;
begin

 vx:=x-kamerax;
vy:=y-kameray;
vz:=z-kameraz;


AngleKameraOX.cos:=sqrt(vx*vx+vz*vz)/sqrt(vy*vy+vx*vx+vz*vz)   ;
AngleKameraOX.sin:=-vy/sqrt(vy*vy+vx*vx+vz*vz) ;

AngleKameraOY.cos:=  vz/sqrt(vx*vx+vz*vz);
AngleKameraOy.sin:=  -vx/sqrt(vx*vx+vz*vz);

MatrixOX[3,2]:=-AngleKameraOX.Sin;
MatrixOX[3,3]:=AngleKameraOX.Cos;
MatrixOX[2,2]:=AngleKameraOX.Cos;
MatrixOX[2,3]:=AngleKameraOX.Sin;
MatrixOY[1,1]:=AngleKameraOy.Cos;
MatrixOY[1,3]:=AngleKameraOy.Sin;
MatrixOY[3,1]:=-AngleKameraOy.Sin;
MatrixOY[3,3]:=AngleKameraOy.Cos;

MatrixResult[1,1]:=MatrixOZ[1,1]*MatrixOY[1,1]+MatrixOZ[2,1]*MatrixOY[3,1]*MatrixOX[2,3];
MatrixResult[1,2]:=MatrixOZ[2,1]*MatrixOX[2,2];
MatrixResult[1,3]:=MatrixOZ[1,1]*MatrixOY[1,3]+MatrixOZ[2,1]*MatrixOY[3,3]*MatrixOX[2,3];
MatrixResult[2,1]:=MatrixOZ[1,2]*MatrixOY[1,1]+MatrixOZ[2,2]*MatrixOY[3,1]*MatrixOX[2,3];
MatrixResult[2,2]:=MatrixOZ[2,2]*MatrixOX[2,2];
MatrixResult[2,3]:=MatrixOZ[1,2]*MatrixOY[1,3]+MatrixOZ[2,2]*MatrixOY[3,3]*MatrixOX[2,3];
MatrixResult[3,1]:=MatrixOY[3,1]*MatrixOX[3,3];
MatrixResult[3,2]:=MatrixOX[3,2];
MatrixResult[3,3]:=MatrixOY[3,3]*MatrixOX[3,3];
end;
procedure TRender3d.point3d(vertex:TVertex3d2d;r,g,b:byte);
 var
xx,yy:integer;
begin


 xx:=round(0.5+Vertex.X2D);
  yy:=round(0.5+Vertex.y2D);

if (xx>=0) and (xx<=width) and (yy>=0) and (yy<=height) then

   if  (vertex.Z3DP<ZBuffer[xx,yy]) and (vertex.Z3DP>=0)   then
        begin
       ArrayPointer[yy][xx].r:=R ;
        ArrayPointer[yy][xx].G:= g;
        ArrayPointer[yy][xx].b:=b;
        ZBuffer[xx,yy]:=vertex.Z3DP;
        end;

 end;
end.


