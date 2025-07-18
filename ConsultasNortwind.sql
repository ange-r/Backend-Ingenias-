/* ppt 21
1. Ejecuta una consulta de selección sobre todos los campos de la tabla Customers
2. Ejecuta una consulta de selección de los siguientes campos de la tabla Customers:
	○ CustomerID, CompanyName, ContactName, ContactTitle, City, Phone
	○ Ordena esta consulta por el campo CompanyName
3.Ejecuta una consulta de selección sobre los siguientes campos de la tabla Customers:
	○ CustomerID, CompanyName, ContactName, ContactTitle
	○ Ordena esta consulta por el campo ContactName de forma descendente
4.Ejecuta una consulta de selección sobre todos los campos de la tabla Customers:
	○ Ordena esta consulta por el campo CustomerID
	○ Limita el total de registros a visualizar a 20
5.Ejecuta una consulta de selección sobre todos los campos de la tabla Customers:
	○ Ordena esta consulta por el campo ContactName
	○ Limita el total de registros a visualizar: muestra solo 10 registros a partir del cliente
número 10 de esta consulta resultante */

SELECT * FROM Northwind.Customers;
SELECT CustomerID, CompanyName, ContactName, ContactTitle, City, Phone FROM Northwind.Customers c ORDER BY c.CompanyName;
SELECT CustomerID, CompanyName, ContactName, ContactTitle FROM Northwind.Customers c ORDER BY c.ContactName DESC;
SELECT * FROM Northwind.Customers c ORDER BY c.CustomerID LIMIT 20;
SELECT * FROM Northwind.Customers c ORDER BY c.ContactName LIMIT 10, 10;

/* ppt 22
Necesitamos simplificar la visualización de datos de esta tabla, presentando en una consulta de selección,
los siguientes campos:
● EmployeeID, TitleOfCourtesy, LastName, FirstName, Title, BirthDate, HireDate
Sobre esta consulta de selección base, realiza las siguientes consignas:
1. En una nueva consulta de selección con la base anterior, concatena los campos:
	a. (TitleOfCourtesy, LastName, FirstName) con el alias NombreCompleto
	b. respeta los espacios entre los diferentes campos mencionados
2.En una nueva consulta de selección con la base inicial:
	a. elimina el formato fecha y hora sobre el campo BirthDate, utilizando la función Date()
	b. aplica un alias a dicho campo para llamarlo FechaNacimiento
3.Copia la consulta resultante del punto dos, y modifícala aplicando lo siguiente:
	a. utiliza la función YEAR sobre campo HireDate, para mostrar sólo el año de contratación
	b. aplica un alias a dicha campo, para llamarlo AnioContratacion */
SELECT EmployeeID, TitleOfCourtesy, LastName, FirstName, Title, BirthDate, HireDate FROM Northwind.Employees e;
SELECT EmployeeID, CONCAT(TitleOfCourtesy, " ", LastName," ", FirstName) AS NombreCompleto, Title, BirthDate, HireDate FROM Northwind.Employees e;
SELECT EmployeeID, TitleOfCourtesy, LastName, FirstName, Title, DATE(BirthDate) AS FechaNacimiento, HireDate FROM Northwind.Employees e;
SELECT EmployeeID, TitleOfCourtesy, LastName, FirstName, Title, DATE(BirthDate) AS FechaNacimiento, YEAR(HireDate) AS AnioContratacion FROM Northwind.Employees e;

/* ppt 23
Necesitamos simplificar la visualización de datos de la tabla Products, presentando en una consulta de
selección, los siguientes campos:
● ProductID, ProductName, UnitPrice, UnitsInStock, ReorderLevel
Sobre esta consulta de selección base, realiza las siguientes consignas:
1. Ejecuta una consulta de selección de todos estos datos, ordenando los mismos por:
	a.CategoryID, ProductName
2. En una nueva consulta de selección con la base inicial:
	a.Muestra una leyenda en el campo ReorderLevel, que diga ‘Reponer Stock’, en aquellos
productos donde el campo UnitsInStock esté por debajo de ReorderLevel
	b.Ordena los productos por ProductName
3.Ejecuta una consulta de selección igual al Punto 1, agregando la siguiente condición
	a.CategoryID = (el id de la categoría llamada ‘Seafood’)
		i.utiliza una subconsulta SQL en esta condición */
SELECT ProductID, ProductName, UnitPrice, UnitsInStock, ReorderLevel FROM Northwind.Products p ORDER BY p.CategoryID, p.ProductName;
SELECT ProductID, ProductName, UnitPrice, UnitsInStock, CASE WHEN UnitsInStock < ReorderLevel THEN 'Reponer Stock' ELSE ReorderLevel END AS ReorderLevel FROM Northwind.Products p ORDER BY p.ProductName;
SELECT ProductID, ProductName, UnitPrice, UnitsInStock, ReorderLevel FROM Northwind.Products p WHERE p.CategoryID = (SELECT c.Categoryid FROM Northwind.Categories c WHERE c.CategoryName = "Seafood" ) ORDER BY p.CategoryID, p.ProductName;
	
/* ppt 24
Necesitamos simplificar la visualización de datos de la tabla Products, Customers,
Categories y Employees, a través de diferentes consultas de selección:
Realiza para ello, las siguientes consignas:
1.Ejecuta una consulta de selección para obtener los campos ProductID,
ProductName, Quantity y UnitPrice, combinando la tabla Products y la tabla
OrderDetails.
	a.Deberás visualizar los datos de la órden número: 10255
2. Ejecuta una consulta de selección para visualizar el campo CustomerName, de la tabla
Customers, y los campos FirstName y LastName de la tabla Employees.
	a.Concatena FistName y LastName como un único campo llamado EjecutivoDeCuentas
3. Ejecuta una consulta de selección para visualizar los datos ProductID, ProductName de
la tabla Products y los campos CompanyName y ContactName de la tabla Suppliers.
	a.Visualizar la información solo de los productos correspondientes a la categoría 7  */
SELECT p.ProductID, p.ProductName, o.Quantity , p.UnitPrice FROM Northwind.Products p 
	INNER JOIN Northwind.OrderDetails o ON p.ProductID = o.ProductID WHERE o.OrderID = 10255;
SELECT c.CompanyName as "CustomerName", CONCAT(e.FirstName, e.LastName) AS "EjecutivoDeCuentas" FROM Northwind.Customers c 
	INNER JOIN Northwind.Employees e ON c.ContactTitle = e.Title;
SELECT p.ProductID, p.ProductName, s.CompanyName, s.ContactName FROM Northwind.Products p 
	INNER JOIN Northwind.Suppliers s ON p.SupplierID = s.SupplierID WHERE p.CategoryID = 7;
	
/* ppt 25
Trabajemos sobre la tabla Products, aplicando algunas funciones de agregación.
Realiza para ello, las siguientes consignas:
1.Ejecuta una consulta de selección para obtener los campos ProductID, UnitPrice
	a. cuenta el total de Productos con el alias TotalProductos
	b. contabiliza solo aquellos que tengan un precio superior a 30
2.Ejecuta una consulta de selección para visualizar el campo ProductID, y CategoryID
	a. cuenta los productos de la tabla y muestra el resultado con el alias TotalProductos
	b. agrupa por CategoryID
3.Replica la consulta anterior (punto 2), y agrega la siguiente condición:
	a. muestra solo los resultados de aquellas categorías que tengan más de 7 productos
	b. TIP: (deberás utilizar HAVING en este último punto) */
SELECT p.ProductID, p.UnitPrice, (SELECT COUNT(*) FROM Northwind.Products p WHERE p.UnitPrice > 30) AS "TotalProductos"
FROM Northwind.Products p;
SELECT p.CategoryID, COUNT(p.ProductID) AS "TotalProductos" FROM Northwind.Products p GROUP BY CategoryID;
SELECT p.CategoryID, COUNT(p.ProductID) AS "TotalProductos" FROM Northwind.Products p GROUP BY CategoryID;


