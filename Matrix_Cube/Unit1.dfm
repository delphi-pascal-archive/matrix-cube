object Form1: TForm1
  Left = 226
  Top = 121
  BorderStyle = bsNone
  Caption = 'Matrix Cube'
  ClientHeight = 552
  ClientWidth = 736
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'MS Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 120
  TextHeight = 23
  object Timer1: TTimer
    Interval = 30
    OnTimer = Timer1Timer
    Left = 328
    Top = 224
  end
end
