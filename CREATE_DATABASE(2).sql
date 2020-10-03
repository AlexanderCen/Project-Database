CREATE TABLE RaCustomer(
	CustomerId CHAR (5) PRIMARY KEY
	CHECK (CustomerId LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR (10) NOT NULL,
	CustomerAddress VARCHAR (30) NOT NULL,
	CustomerGender VARCHAR (10) NOT NULL
	CHECK (CustomerGender LIKE 'Male' OR CustomerGender LIKE 'Female'),
	CustomerDOB DATE NOT NULL
)

CREATE TABLE RaClothes(
	ClothesId CHAR(5) PRIMARY KEY
	CHECK (ClothesId LIKE 'CL[0-9][0-9][0-9]'),
	ClothesName VARCHAR (10) NOT NULL,
	ClothesType VARCHAR (10) NOT NULL
	CHECK (ClothesType IN ('Cotton','Viscose','Polyester','Linen','Wool'))
)

CREATE TABLE RaStaff(
	StaffId CHAR(5) PRIMARY KEY
	CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(20) NOT NULL,
	StaffAddress VARCHAR(30) NOT NULL,
	StaffGender VARCHAR(8) NOT NULL
	CHECK (StaffGender LIKE 'Male' or StaffGender LIKE 'Female'),
	StaffSalary INT NOT NULL
	CHECK (StaffSalary BETWEEN 1500000 AND 3000000)
)

CREATE TABLE RaServiceDetail(
	ServiceId CHAR(5) PRIMARY KEY
	CHECK (ServiceId LIKE 'SR[0-9][0-9][0-9]'),
	ClothesId CHAR(5) FOREIGN KEY REFERENCES RaClothes (ClothesId)
	CHECK (ClothesId LIKE 'CL[0-9][0-9][0-9]'),
	ClothesQty INT NOT NULL
)

CREATE TABLE HeaderServiceTransaction(
	ServiceId CHAR(5) CHECK (ServiceId LIKE 'SR[0-9][0-9][0-9]') PRIMARY KEY
	FOREIGN KEY REFERENCES RaServiceDetail (ServiceId),
	CustomerId CHAR(5) FOREIGN KEY REFERENCES RaCustomer (CustomerId)
	CHECK (CustomerId LIKE 'CU[0-9][0-9][0-9]'),
	StaffId CHAR(5) FOREIGN KEY REFERENCES RaStaff (StaffId)
	CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]'),
	ServiceType VARCHAR(25) NOT NULL
	CHECK (ServiceType IN ('Laundry Service','Dry Cleaning Service','Ironing Service')),
	ServicePrice INT NOT NULL,
	ServiceDate DATE NOT NULL
	CHECK (DATEPART(YEAR,ServiceDate) = DATEPART(YEAR,GETDATE()))
)

CREATE TABLE RaVendor(
	VendorId CHAR(5) PRIMARY KEY
	CHECK (VendorId LIKE 'VE[0-9][0-9][0-9]'),
	VendorName VARCHAR(30) NOT NULL,
	VendorAddress VARCHAR(50) NOT NULL
	CHECK (LEN(VendorAddress)>10),
	VendorPhone VARCHAR(15) NOT NULL
)

CREATE TABLE RaMaterial(
	MaterialId CHAR(5) PRIMARY KEY
	CHECK (MaterialId LIKE 'MA[0-9][0-9][0-9]'),
	MaterialName VARCHAR(10) NOT NULL,
	MaterialType VARCHAR(10) NOT NULL
	CHECK (MaterialType IN ('Equipment','Supplies')),
	MaterialPrice INT NOT NULL
)

CREATE TABLE RaPurchaseDetail(
	PurchaseId CHAR(5) PRIMARY KEY
	CHECK (PurchaseId LIKE 'PU[0-9][0-9][0-9]'),
	MaterialId CHAR(5) FOREIGN KEY REFERENCES RaMaterial (MaterialId)
	CHECK (MaterialId LIKE 'MA[0-9][0-9][0-9]'),
	Quantity INT NOT NULL,
)

CREATE TABLE HeaderPurchaseTransaction(
	PurchaseId CHAR(5) CHECK (PurchaseId LIKE 'PU[0-9][0-9][0-9]') PRIMARY KEY 
	FOREIGN KEY REFERENCES RaPurchaseDetail (PurchaseId),
	StaffId CHAR(5) FOREIGN KEY REFERENCES RaStaff (StaffId)
	CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]'),
	VendorId CHAR(5) FOREIGN KEY REFERENCES RaVendor (VendorId)
	CHECK (VendorId LIKE 'VE[0-9][0-9][0-9]'),
	PurchaseDate DATE NOT NULL
	CHECK (DATEPART(YEAR,PurchaseDate) = DATEPART(YEAR,GETDATE()))
)