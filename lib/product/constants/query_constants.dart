// ignore_for_file: constant_identifier_names

enum TableNames {
  X_Users,
  X_Firms,
  X_Branchs,
  CRD_Cari,
  CRD_StockWareHouse,
  L_Units,
  TRN_StockTrans,
  TRN_StockTransLines,
  V_AllItems
}

enum DataTypes { INT, BOOL, TEXT, REAL }

class DatabaseConstants {
  static const Map<String, int> fisTurleri = {
    "Alış İrsaliye": 0,
    "Satış İrsaliye": 1,
    "Alış İade": 10,
    "Satış İade": 11,
    "Ambar Transfer": 2,
    "Sayım Fişi": 14
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
  static const List<Map<String, dynamic>> types_X_Users = [
    {"column": "ID", "type": DataTypes.INT, "order": 0},
    {"column": "LogonName", "type": DataTypes.TEXT, "order": 1},
    {"column": "Password", "type": DataTypes.TEXT, "order": 2}
  ];

  static const String create_X_Firms = '''
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
)
''';
  static const String select_X_Firms =
      '''SELECT FirmNr, Name, Server, User, Pass, Database FROM X_Firms;''';
  static const List<Map<String, dynamic>> types_X_Firms = [
    {"column": "FirmNr", "type": DataTypes.INT, "order": 0},
    {"column": "Name", "type": DataTypes.TEXT, "order": 1},
    {"column": "Server", "type": DataTypes.TEXT, "order": 2},
    {"column": "User", "type": DataTypes.TEXT, "order": 3},
    {"column": "Pass", "type": DataTypes.TEXT, "order": 4},
    {"column": "Database", "type": DataTypes.TEXT, "order": 5}
  ];

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
  static const List<Map<String, dynamic>> types_CRD_Cari = [
    {"column": "ID", "type": DataTypes.INT, "order": 0},
    {"column": "Code", "type": DataTypes.TEXT, "order": 1},
    {"column": "Name", "type": DataTypes.TEXT, "order": 2},
    {"column": "TaxNumber", "type": DataTypes.TEXT, "order": 3},
    {"column": "TaxOffice", "type": DataTypes.TEXT, "order": 4},
    {"column": "TCKNo", "type": DataTypes.TEXT, "order": 5}
  ];

  static const String create_CRD_StockWareHouse = '''
CREATE TABLE "CRD_StockWareHouse" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"Name"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)''';
  static const String select_CRD_StockWareHouse =
      '''SELECT ID, Name FROM CRD_StockWareHouse;''';
  static const List<Map<String, dynamic>> types_CRD_StockWareHouse = [
    {"column": "ID", "type": DataTypes.INT, "order": 0},
    {"column": "Name", "type": DataTypes.TEXT, "order": 1}
  ];
  static const String create_L_Units = '''
CREATE TABLE "L_Units" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"UnitName"	TEXT,
	"UnitCode"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)''';
  static const String select_L_Units =
      '''SELECT ID, UnitName, UnitCode FROM L_Units;''';
  static const List<Map<String, dynamic>> types_L_Units = [
    {"column": "ID", "type": DataTypes.INT, "order": 0},
    {"column": "UnitName", "type": DataTypes.TEXT, "order": 1},
    {"column": "UnitCode", "type": DataTypes.TEXT, "order": 2}
  ];
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
  static const List<Map<String, dynamic>> types_TRN_StockTrans = [
    {"column": "ID", "type": DataTypes.INT, "order": 0},
    {"column": "FicheNo", "type": DataTypes.TEXT, "order": 1},
    {"column": "InvoiceID", "type": DataTypes.INT, "order": 2},
    {"column": "CariID", "type": DataTypes.INT, "order": 3},
    {"column": "Branch", "type": DataTypes.INT, "order": 4},
    {"column": "Type", "type": DataTypes.INT, "order": 5},
    {"column": "Status", "type": DataTypes.INT, "order": 6},
    {"column": "TransDate", "type": DataTypes.TEXT, "order": 7},
    {"column": "Notes", "type": DataTypes.TEXT, "order": 8},
    {"column": "CurrencyID", "type": DataTypes.INT, "order": 9},
    {"column": "CurrencyRate", "type": DataTypes.REAL, "order": 10},
    {"column": "StockWareHouseID", "type": DataTypes.INT, "order": 11},
    {"column": "DestStockWareHouseID", "type": DataTypes.INT, "order": 12},
    {"column": "CreatedBy", "type": DataTypes.INT, "order": 13},
    {"column": "CreatedDate", "type": DataTypes.TEXT, "order": 14},
    {"column": "GoldenSync", "type": DataTypes.INT, "order": 15}
  ];
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
  static const List<Map<String, dynamic>> types_TRN_StockTransLines = [
    {"column": "ID", "type": DataTypes.INT, "order": 0},
    {"column": "Date", "type": DataTypes.TEXT, "order": 1},
    {"column": "Direction", "type": DataTypes.INT, "order": 2},
    {"column": "Status", "type": DataTypes.INT, "order": 3},
    {"column": "InvoiceID", "type": DataTypes.INT, "order": 4},
    {"column": "StockTransID", "type": DataTypes.INT, "order": 5},
    {"column": "ProductID", "type": DataTypes.INT, "order": 6},
    {"column": "SeriNo", "type": DataTypes.TEXT, "order": 7},
    {"column": "Beden", "type": DataTypes.INT, "order": 8},
    {"column": "Renk", "type": DataTypes.INT, "order": 9},
    {"column": "Type", "type": DataTypes.INT, "order": 10},
    {"column": "ProductType", "type": DataTypes.INT, "order": 11},
    {"column": "LineExp", "type": DataTypes.TEXT, "order": 12},
    {"column": "Amount", "type": DataTypes.REAL, "order": 13},
    {"column": "UnitID", "type": DataTypes.INT, "order": 14},
    {"column": "UnitPrice", "type": DataTypes.REAL, "order": 15},
    {"column": "CurrencyID", "type": DataTypes.INT, "order": 16},
    {"column": "CurrencyRate", "type": DataTypes.REAL, "order": 17},
    {"column": "TaxRate", "type": DataTypes.REAL, "order": 18},
    {"column": "Branch", "type": DataTypes.INT, "order": 19},
    {"column": "GoldenSync", "type": DataTypes.INT, "order": 20},
    {"column": "StockWareHouseID", "type": DataTypes.INT, "order": 21},
    {"column": "DestStockWareHouseID", "type": DataTypes.INT, "order": 22},
    {"column": "CreatedBy", "type": DataTypes.INT, "order": 23},
    {"column": "CreatedDate", "type": DataTypes.TEXT, "order": 24}
  ];

  static const String create_X_Branchs = '''
CREATE TABLE "X_Branchs" (
	"BranchNo"	INTEGER NOT NULL UNIQUE,
	"Name"	TEXT,
	PRIMARY KEY("BranchNo" AUTOINCREMENT)
)''';
  static const String select_X_Branchs =
      '''SELECT BranchNo, Name FROM X_Branchs;''';
  static const List<Map<String, dynamic>> types_X_Branchs = [
    {"column": "BranchNo", "type": DataTypes.INT, "order": 0},
    {"column": "Name", "type": DataTypes.TEXT, "order": 1}
  ];

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

  static const List<Map<String, dynamic>> types_V_AllItems = [
    {"column": "ID", "type": DataTypes.INT, "order": 0},
    {"column": "Active", "type": DataTypes.INT, "order": 1},
    {"column": "AuthCode", "type": DataTypes.TEXT, "order": 2},
    {"column": "Code", "type": DataTypes.TEXT, "order": 3},
    {"column": "OzelKod", "type": DataTypes.TEXT, "order": 4},
    {"column": "Code2", "type": DataTypes.TEXT, "order": 5},
    {"column": "Barcode", "type": DataTypes.TEXT, "order": 6},
    {"column": "MainBarcode", "type": DataTypes.TEXT, "order": 7},
    {"column": "Name", "type": DataTypes.TEXT, "order": 8},
    {"column": "Name2", "type": DataTypes.TEXT, "order": 9},
    {"column": "TradeMark", "type": DataTypes.TEXT, "order": 10},
    {"column": "UnitID", "type": DataTypes.INT, "order": 11},
    {"column": "Type", "type": DataTypes.INT, "order": 12},
    {"column": "UnitPrice", "type": DataTypes.REAL, "order": 13},
    {"column": "UnitPrice2", "type": DataTypes.REAL, "order": 14},
    {"column": "UnitPrice3", "type": DataTypes.REAL, "order": 15},
    {"column": "AlisFiyati", "type": DataTypes.REAL, "order": 16},
    {"column": "PakettekiMiktar", "type": DataTypes.REAL, "order": 17},
    {"column": "AgirlikGr", "type": DataTypes.REAL, "order": 18},
    {"column": "ItemGroupID", "type": DataTypes.INT, "order": 19},
    {"column": "UrunGrubu", "type": DataTypes.TEXT, "order": 20},
    {"column": "TaxRate", "type": DataTypes.REAL, "order": 21},
    {"column": "TaxRateToptan", "type": DataTypes.REAL, "order": 22},
    {"column": "StokAdeti", "type": DataTypes.REAL, "order": 23},
    {"column": "CreatedDate", "type": DataTypes.TEXT, "order": 24},
    {"column": "CreatedBy", "type": DataTypes.INT, "order": 25},
    {"column": "ModiFiedBy", "type": DataTypes.INT, "order": 26},
    {"column": "ModifiedDate", "type": DataTypes.TEXT, "order": 27},
    {"column": "UrunRenk", "type": DataTypes.INT, "order": 28},
    {"column": "Beden", "type": DataTypes.INT, "order": 29},
    {"column": "Miktar", "type": DataTypes.REAL, "order": 30},
    {"column": "Aciklama", "type": DataTypes.TEXT, "order": 31},
    {"column": "PakettekiAdet", "type": DataTypes.INT, "order": 32},
    {"column": "PacalMaliyet", "type": DataTypes.REAL, "order": 33},
    {"column": "VaryantID", "type": DataTypes.INT, "order": 34}
  ];
}
