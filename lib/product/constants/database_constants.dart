// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TableNames {
  X_Users,
  X_Firms,
  X_Branchs,
  CRD_Cari,
  CRD_StockWareHouse,
  L_Units,
  TRN_StockTrans,
  TRN_StockTransLines,
  V_AllItems,
  FisListesi
}

enum DataTypes { INT, TEXT, REAL, BOOL }

class DatabaseConstants {
  static Map<String, int> fisTurleri = {};

  static const Map<int, Icon> fisIconlari = {
    0: Icon(Icons.add_shopping_cart),
    1: Icon(Icons.remove_shopping_cart),
    10: Icon(Icons.add_shopping_cart),
    11: Icon(Icons.remove_shopping_cart),
    2: Icon(Icons.swap_horiz),
    14: Icon(Icons.swap_horiz)
  };

  // static const Map fisInputTurleri = {};

  static const String create_X_Users = '''
CREATE TABLE "X_Users" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"LogonName"	TEXT,
	"Password"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)
''';
  static const String select_X_Users =
      '''SELECT ID, LogonName, Password FROM X_Users;''';

  static const String select_FisListesi =
      '''SELECT FisType, FisName FROM FisListesi;''';

  static const List<String> create_LocaleTables = [
    '''
CREATE TABLE "FisListesi" (
	"FisType"	INTEGER NOT NULL UNIQUE,
	"FisName"	TEXT NOT NULL UNIQUE
);
''',
    '''
CREATE TABLE "X_Firms" (
	"FirmNr"	INTEGER NOT NULL UNIQUE,
	"Name"	TEXT,
	"Server"	TEXT,
	"User"	TEXT,
	"Pass"	TEXT,
	"Database"	TEXT,
	"defaultUsername"	TEXT,
	"defaultPassword"	TEXT,
	PRIMARY KEY("FirmNr" AUTOINCREMENT)
);
''',
    "insert into FisListesi (FisType,FisName) VALUES (0, 'Alış İrsaliye'), (1, 'Satış İrsaliye'), (10, 'Alış İade'), (11, 'Satış İade'), (2, 'Ambar Transfer'), (14, 'Sayım Fişi');"
  ];
  static const String select_X_Firms =
      '''SELECT FirmNr, Name, Server, User, Pass, Database FROM X_Firms;''';

  static const String create_CRD_Cari = '''
CREATE TABLE "CRD_Cari" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"Code"	TEXT,
	"Name"	TEXT,
	"TaxNumber"	TEXT,
	"TaxOffice"	TEXT,
	"TCKNo"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)''';
  static const String select_CRD_Cari =
      '''SELECT ID, Code, Name, TaxNumber, TaxOffice, TCKNo FROM CRD_Cari;''';

  static const String create_CRD_StockWareHouse = '''
CREATE TABLE "CRD_StockWareHouse" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"Name"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)''';
  static const String select_CRD_StockWareHouse =
      '''SELECT ID, Name FROM CRD_StockWareHouse;''';

  static const String create_L_Units = '''
CREATE TABLE "L_Units" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"UnitName"	TEXT,
	"UnitCode"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)''';
  static const String select_L_Units =
      '''SELECT ID, UnitName, UnitCode FROM L_Units;''';

  static const String create_TRN_StockTrans = '''
CREATE TABLE "TRN_StockTrans" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"FicheNo"	TEXT,
	"InvoiceID"	INTEGER,
	"CariID"	INTEGER,
	"Branch"	INTEGER,
	"Type"	INTEGER,
	"Status"	INTEGER,
	"TransDate"	TEXT,
	"Notes"	TEXT,
	"CurrencyID"	INTEGER,
	"CurrencyRate"	REAL,
	"StockWareHouseID"	INTEGER,
	"DestStockWareHouseID"	INTEGER,
	"CreatedBy"	INTEGER,
	"CreatedDate"	TEXT,
	"GoldenSync"	INTEGER,
	PRIMARY KEY("ID" AUTOINCREMENT)
)''';
  static const String select_TRN_StockTrans =
      '''SELECT ID, FicheNo, InvoiceID, CariID, Branch, Type, Status, TransDate, Notes, CurrencyID, CurrencyRate, StockWareHouseID, DestStockWareHouseID, CreatedBy, CreatedDate, GoldenSync FROM TRN_StockTrans;''';

  static const String create_TRN_StockTransLines = '''
CREATE TABLE "TRN_StockTransLines" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"Date"	TEXT,
	"Direction"	INTEGER,
	"Status"	INTEGER,
	"InvoiceID"	INTEGER,
	"StockTransID"	INTEGER,
	"ProductID"	INTEGER,
	"SeriNo"	TEXT,
	"Beden"	INTEGER,
	"Renk"	INTEGER,
	"Type"	INTEGER,
	"ProductType"	INTEGER,
	"LineExp"	TEXT,
	"Amount"	REAL,
	"UnitID"	INTEGER,
	"UnitPrice"	REAL,
	"CurrencyID"	INTEGER,
	"CurrencyRate"	REAL,
	"TaxRate"	REAL,
	"Branch"	INTEGER,
	"GoldenSync"	INTEGER,
	"StockWareHouseID"	INTEGER,
	"DestStockWareHouseID"	INTEGER,
	"CreatedBy"	INTEGER,
	"CreatedDate"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)''';
  static const String select_TRN_StockTransLines =
      '''SELECT ID, Date, Direction, Status, InvoiceID, StockTransID, ProductID, SeriNo, Beden, Renk, Type, ProductType, LineExp, Amount, UnitID, UnitPrice, CurrencyID, CurrencyRate, TaxRate, Branch, GoldenSync, StockWareHouseID, DestStockWareHouseID, CreatedBy, CreatedDate FROM TRN_StockTransLines;''';

  static const String create_X_Branchs = '''
CREATE TABLE "X_Branchs" (
	"BranchNo"	INTEGER NOT NULL UNIQUE,
	"Name"	TEXT,
	PRIMARY KEY("BranchNo" AUTOINCREMENT)
)''';
  static const String select_X_Branchs =
      '''SELECT BranchNo, Name FROM X_Branchs;''';

  static const String create_V_AllItems = '''
CREATE TABLE "V_AllItems" (
	"ID"	INTEGER NOT NULL,
	"Active"	INTEGER,
	"AuthCode"	TEXT,
	"Code"	TEXT,
	"OzelKod"	TEXT,
	"Code2"	TEXT,
	"Barcode"	TEXT,
	"MainBarcode"	TEXT,
	"Name"	TEXT,
	"Name2"	TEXT,
	"TradeMark"	TEXT,
	"UnitID"	INTEGER,
	"Type"	INTEGER,
	"UnitPrice"	REAL,
	"UnitPrice2"	REAL,
	"UnitPrice3"	REAL,
	"AlisFiyati"	REAL,
	"PakettekiMiktar"	REAL,
	"AgirlikGr"	REAL,
	"ItemGroupID"	INTEGER,
	"UrunGrubu"	TEXT,
	"TaxRate"	REAL,
	"TaxRateToptan"	REAL,
	"StokAdeti"	REAL,
	"CreatedDate"	TEXT,
	"CreatedBy"	INTEGER,
	"ModiFiedBy"	INTEGER,
	"ModifiedDate"	TEXT,
	"UrunRenk"	INTEGER,
	"Beden"	INTEGER,
	"Miktar"	REAL,
	"Aciklama"	TEXT,
	"PakettekiAdet"	INTEGER,
	"PacalMaliyet"	REAL,
	"VaryantID"	INTEGER NOT NULL
)
''';
  static const String select_V_AllItems = '''SELECT * FROM V_AllItems;''';

  static const String select_Sevkiyat = '''
SELECT        TRN_StockTrans.ID, TRN_StockTrans.FicheNo, TRN_StockTrans.TransDate, TRN_StockTrans.Notes, CRD_Cari.Name AS CariAdi, CRD_StockWareHouse.Name AS DepoAdi, X_Users.NameSirname, 
                         X_Branchs.Name AS BranchName
FROM            TRN_StockTrans INNER JOIN
                         CRD_Cari ON TRN_StockTrans.CariID = CRD_Cari.ID LEFT OUTER JOIN
                         CRD_StockWareHouse ON TRN_StockTrans.StockWareHouseID = CRD_StockWareHouse.ID INNER JOIN
                         X_Users ON TRN_StockTrans.CreatedBy = X_Users.ID LEFT OUTER JOIN
                         X_Branchs ON TRN_StockTrans.Branch = X_Branchs.BranchNo
WHERE        (TRN_StockTrans.Status = 2);
''';
}
