use AdventureWorks2017
--------------------------------###TRIGGERS###-----------------------------------
----------------------------AfterUpdate-----------------------
if OBJECT_ID('trAfterUpdateCustomer','TR') is not null
begin
	drop trigger trAfterUpdateCustomer
end;

GO

create trigger trAfterUpdateCustomer
on Sales.Customer
AFTER UPDATE as declare
	@ID int,
	@personID int,
	@storeID int,
	@territoryID int,
	@accountNumber varchar(25),
	@Mensaje varchar(255);

	select @ID = ins.CustomerID from DeLETED ins;
	select @personID = ins.PersonID from DeLETED ins;
	select @storeID = ins.StoreID from DeLETED ins;
	select @territoryID = ins.TerritoryID from DeLETED ins;
	select @accountNumber = ins.AccountNumber from DeLETED ins;

	set @Mensaje = 'Se realizó un UPDATE con los valores de id = '+cast(@ID as varchar)					+', PersonID = '+iif(@personID is null,'NULL',cast(@personID as varchar))					+', StoreID= '+iif(@storeID is null,'NULL', cast(@storeID as varchar))					+', TerritoryID = '+cast(@territoryID as varchar)+', Accountnumber = '+@accountNumber;		insert into Auditoria(Tabla, Accion, fecha, Mensaje)			values('Sales.Customer','UPDATE',GETDATE(),@Mensaje);	Print 'Se ha disparado el trigger: trAfterUpdateCustomer';GO---------------Instead of delete---------------------------if OBJECT_ID('trInsteadOfDelProduct','TR') is not null
begin
	drop trigger trInsteadOfDelProduct
end;
GO

create trigger trInsteadOfDelProduct
on Production.Product
INSTEAD OF DELETE  as declare
	@ID int,
	@name varchar(25),
	@productNumber varchar(25),
	@Mensaje varchar(255);	if @ID is null	Begin		select @ID = ins.ProductID from DELETED ins;
		select @name = ins.Name from DELETED ins;
		select @productNumber = ins.ProductNumber from DELETED ins;	end	set @Mensaje = 'Se intento eliminar la siguiente fila id = '+cast(@ID as varchar)+', ProductName = '+@name+', ProductNumber = '+@productNumber;	insert into Auditoria(Tabla, Accion, fecha, Mensaje)			values('Production.Product','DELETE',GETDATE(),@Mensaje);	Print 'Se ha disparado el trigger: trInsteadOfDelProduct';GO