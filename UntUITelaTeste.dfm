object UITelaTeste: TUITelaTeste
  Left = 0
  Top = 0
  Caption = 'UITelaTeste'
  ClientHeight = 333
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 32
    Top = 16
    Width = 561
    Height = 232
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Width = 106
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Title.Caption = 'Descri'#231#227'o'
        Width = 443
        Visible = True
      end>
  end
  object BtnIncluir: TButton
    Left = 32
    Top = 272
    Width = 75
    Height = 25
    Caption = 'BtnIncluir'
    TabOrder = 1
    OnClick = BtnIncluirClick
  end
  object BtnAlterar: TButton
    Left = 120
    Top = 272
    Width = 75
    Height = 25
    Caption = 'BtnAlterar'
    TabOrder = 2
    OnClick = BtnAlterarClick
  end
  object BtnExcluir: TButton
    Left = 208
    Top = 272
    Width = 75
    Height = 25
    Caption = 'BtnExcluir'
    TabOrder = 3
    OnClick = BtnExcluirClick
  end
end
