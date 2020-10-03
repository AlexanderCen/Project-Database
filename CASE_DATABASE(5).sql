
 --1
SELECT rc.CustomerId, CustomerName, [TotalServicePrice] = SUM(ServicePrice)
FROM RaCustomer rc, HeaderServiceTransaction hst
WHERE rc.CustomerId = hst.CustomerId AND
MONTH(ServiceDate) = 7 AND CustomerGender = 'Male'
GROUP BY rc.CustomerId, CustomerName

--2
SELECT StaffName, PurchaseDate, [TotalTransaction] = COUNT(hpt.PurchaseId)
FROM RaStaff rs,  HeaderPurchaseTransaction hpt
WHERE rs.StaffId = hpt.StaffId AND
StaffName LIKE '%o%'
GROUP BY StaffName, PurchaseDate
HAVING (COUNT(hpt.PurchaseId) > 1)

--3
SELECT VendorName, PurchaseDate = CONVERT(VARCHAR,PurchaseDate,107), [TotalTransaction] = COUNT(hpt.PurchaseId), [TotalPurchasePrice] = SUM(Quantity * MaterialPrice)
FROM RaVendor rv, HeaderPurchaseTransaction hpt, RaPurchaseDetail rpd, RaMaterial rm
WHERE rv.VendorId = hpt.VendorId AND hpt.PurchaseId = rpd.PurchaseId AND rpd.MaterialId = rm.MaterialId
AND VendorName LIKE 'PT. %'
GROUP BY VendorName, PurchaseDate

--4
SELECT StaffName, MaterialName,[TotalTransaction] = COUNT(hpt.PurchaseId),[TotalQuantity] = CONVERT(VARCHAR,COUNT(Quantity)) + ' pcs'
FROM HeaderPurchaseTransaction hpt, RaPurchaseDetail rpd, RaMaterial rm, RaStaff rs
WHERE hpt.PurchaseId = rpd.PurchaseId AND rpd.MaterialId = rm.MaterialId AND rs.StaffId = hpt.StaffId AND
MONTH(PurchaseDate) = 7
GROUP BY StaffName, MaterialName
HAVING (COUNT(Quantity)<9)

--5
SELECT MaterialId = REPLACE(rpd.MaterialId,'MA','Material '), MaterialName = UPPER(MaterialName), PurchaseDate, Quantity
FROM RaMaterial rm JOIN RaPurchaseDetail rpd
ON rm.MaterialId = rpd.MaterialId JOIN HeaderPurchaseTransaction hpt
ON hpt.PurchaseId = rpd.PurchaseId,
(
	SELECT avgq = AVG(Quantity)
	FROM RaPurchaseDetail
)GetAvgq
WHERE MaterialType LIKE 'Supplies' AND Quantity > GetAvgq.avgq
ORDER BY rpd.MaterialId

--6
SELECT StaffName, CustomerName, Servicedate = CONVERT(VARCHAR,ServiceDate,13)
FROM HeaderServiceTransaction hst JOIN RaStaff rs
ON hst.StaffId = rs.StaffId JOIN RaCustomer rc
ON rc.CustomerId = hst.CustomerId,
(
	SELECT AvgSalary = AVG(StaffSalary)
	FROM RaStaff
)GetAvgSalary
WHERE StaffSalary > GetAvgSalary.AvgSalary AND CHARINDEX(' ',StaffName) = 0

--7
SELECT ClothesName, TotalTransaction = CONVERT(VARCHAR,COUNT(rsd.ServiceId)) + ' Transaction', ServiceType = LEFT(ServiceType,CHARINDEX(' ',ServiceType)-1), ServicePrice
FROM RaClothes rc JOIN RaServiceDetail rsd
ON rc.ClothesId = rsd.ClothesId JOIN HeaderServiceTransaction hst
ON rsd.ServiceId = hst.ServiceId,
(
	SELECT AvgPrice = AVG(ServicePrice)
	FROM HeaderServiceTransaction
)GetAvgPrice
WHERE ServicePrice < GetAvgPrice.AvgPrice AND ClothesType LIKE 'Cotton'
GROUP BY ClothesName, ServiceType, ServicePrice

--8
SELECT StaffFirstName = LEFT(StaffName,CHARINDEX(' ',StaffName)-1), VendorName, VendorPhone = REPLACE(VendorPhone,'08','+628'), TotalTransaction = COUNT(hpt.PurchaseId)
FROM RaStaff rs JOIN HeaderPurchaseTransaction hpt
ON rs.StaffId = hpt.StaffId JOIN RaVendor rv
ON hpt.VendorId = rv.VendorId JOIN RaPurchaseDetail rpd
ON rpd.PurchaseId = hpt.PurchaseId,
(
	SELECT AvgQuantity = AVG(Quantity)
	FROM RaPurchaseDetail
)GetAvgQuantity
WHERE Quantity > GetAvgQuantity.AvgQuantity AND CHARINDEX(' ',StaffName) != 0
GROUP BY StaffName, VendorName, VendorPhone


--9
CREATE VIEW ViewMaterialPurchase AS
SELECT MaterialName, MaterialPrice = 'Rp. ' + CONVERT(VARCHAR,MaterialPrice), [TotalTransaction] =COUNT(PurchaseId), [TotalPrice] = SUM(Quantity*MaterialPrice)
FROM RaMaterial rm, RaPurchaseDetail rpd
WHERE rm.MaterialId = rpd.MaterialId AND
MaterialType LIKE 'Supplies'
GROUP BY MaterialName, MaterialPrice
HAVING COUNT(PurchaseId) > 2

SELECT * FROM ViewMaterialPurchase

--10
CREATE VIEW ViewMaleCustomerTransaction AS
SELECT CustomerName, ClothesName, [TotalTransaction] = COUNT(hst.ServiceId), [TotalPrice] = SUM(ServicePrice)
FROM HeaderServiceTransaction hst, RaServiceDetail rsd, RaClothes rc, RaCustomer rcust
WHERE hst.ServiceId = rsd.ServiceId AND rsd.ClothesId = rc.ClothesId AND rcust.CustomerId = hst.CustomerId AND
CustomerGender LIKE 'Male' AND ClothesType IN ('Linen','Wool')
GROUP BY CustomerName, ClothesName