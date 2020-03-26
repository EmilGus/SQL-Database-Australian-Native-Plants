SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Plants;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Messages;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS ShippingMultiplier;

DROP TRIGGER IF EXISTS after_orders_insert;
DROP FUNCTION IF EXISTS MultiplyShipingCost;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Members (
	MemberID INT AUTO_INCREMENT ,
	MemberName VARCHAR(50),
	ContactName VARCHAR(50),
	StartDate DATETIME DEFAULT CURRENT_TIMESTAMP,
	EndDate DATE DEFAULT NULL ,
	NurseryName VARCHAR(50),
	NurseryAddress VARCHAR(255),
	Phone VARCHAR(15),
	Email VARCHAR(255) NOT NULL ,
	Description TEXT,
    
    PRIMARY KEY (MemberID)
);

CREATE TABLE Clients (
	ClientID INT AUTO_INCREMENT ,
	ClientName VARCHAR(50) NOT NULL ,
	Email VARCHAR(255) NOT NULL ,
	Address VARCHAR(255),
	DeliveryAddress VARCHAR(255),
	Location VARCHAR(255),
	StartDate DATETIME DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY (ClientID)
);

CREATE TABLE Plants (
	PlantID INT AUTO_INCREMENT ,
	BotanicalName VARCHAR(50) NOT NULL ,
	CommonName VARCHAR(50),
	Description TEXT,

	PRIMARY KEY (PlantID)
);

CREATE TABLE Orders (
	OrderID INT AUTO_INCREMENT ,
	ClientID INT ,
	MemberID INT ,
	OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP ,
	OrderStatus VARCHAR(20),
	ShippingDate DATE DEFAULT NULL,
	CourierName VARCHAR(50),
	ShippingReference VARCHAR(50),
	ShippingCostMultiplier DECIMAL(10,2),

	PRIMARY KEY (OrderID),
	FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ,
	FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE OrderItems (
	OrderID INT,
	PlantID INT,
	Quantity INT,
	Price DECIMAL(10,2),
	UnitShippingCost DECIMAL(10,2),

	PRIMARY KEY (OrderID, PlantID),
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	FOREIGN KEY (PlantID) REFERENCES Plants(PlantID)
);

CREATE TABLE Messages (
	MessageID INT AUTO_INCREMENT ,
	ClientID INT,
	MemberID INT,
	Date DATETIME DEFAULT CURRENT_TIMESTAMP,
	Message TEXT,

	PRIMARY KEY (MessageID),
	FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
	FOREIGN KEY (MemberID) REFERENCES Members(MemberID) 
 ); 
 
CREATE TABLE Stock (
	MemberID INT,
	PlantID INT,
	Price DECIMAL(10,2),
	PriceDate DATETIME DEFAULT CURRENT_TIMESTAMP,
	UnitShippingCost DECIMAL(10,2),
	InStock BIT DEFAULT 0,

	PRIMARY KEY (MemberID, PlantID),
	FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
	FOREIGN KEY (PlantID) REFERENCES Plants(PlantID)
);

CREATE TABLE ShippingMultiplier (
	NurseryState VARCHAR(50),
	DestinationState VARCHAR(50),
	Multiplier DECIMAL(10,2),

	PRIMARY KEY (NurseryState, DestinationState)
);

INSERT INTO Clients(ClientName, Email, Address, DeliveryAddress, Location)
VALUES ('Emil Gustafsson', 'riotroot@gmail.com', '', '5/65 Neerim Drive, 4557 Mooloolaba', 'QLD');
INSERT INTO Clients(ClientName, Email, Address, DeliveryAddress, Location)
VALUES ('Vladimir Lenin', 'lenin@soviet.ru', '', 'MadeUp Road 56', 'VIC');
INSERT INTO Clients(ClientName, Email, Address, DeliveryAddress, Location)
VALUES ('Sarah Sanders', 'SarahSanders@gmail.com', '', 'MadeUp Road 67', 'NSW');

INSERT INTO Members(NurseryName, MemberName, NurseryAddress, Email, Phone)
VALUES ('Native shrubs R us', 'Joan Coats', '58 Anvidale Street, Armidale NSW 2350', 'xxx@xxx.xx', '911');
INSERT INTO Members(NurseryName, MemberName, NurseryAddress, Email, Phone)
VALUES ('Greenock Australian Native Nursery', 'Anna Zikov', '37 Greenock Road Greenock 5360 SA', 'xxx@xxx.xx', '911');
INSERT INTO Members(NurseryName, MemberName, NurseryAddress, Email, Phone)
VALUES ('Margaret River Natives', 'Tom Rodicko', '187 Wallcliffe Road Margaret River 6285 WA', 'xxx@xxx.xx', '911');
INSERT INTO Members(NurseryName, MemberName, NurseryAddress, Email, Phone)
VALUES ('Tasie Native Plants', 'Gordon Frost', '423 Lilydale road Launceston 7250 Tas', 'xxx@xxx.xx', '911');
INSERT INTO Members(NurseryName, MemberName, NurseryAddress, Email, Phone)
VALUES ('Charnwood Natives', 'Adriana Codd', '20 Tilliard Drive Charnwood ACT 2615', 'xxx@xxx.xx', '911');
INSERT INTO Members(NurseryName, MemberName, NurseryAddress, Email, Phone)
VALUES ('Territory Native Nursery', 'Beryl Anthony', '28 Larapinta Drive Alice Springs NT 0870', 'xxx@xxx.xx', '911');

INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Acacia aneura', 'mulga', 'Native tree grows in every state');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Eucalyptus rhodantha', 'rose mallee', 'Native WA tree');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Goodenia ovata', 'hop goodenia', 'Native shrub grows in every state');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Tetratheca pilosa', 'pink-eyed susan', 'Native shrub grows in SA, NT, Tas and Vic');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Acacia brachybotrya', 'grey mulga', 'Native shrub grows in NT, SA and Vic');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Grevillea arenaria', 'sand grevillea', 'Native shrub grows in NT and Qld');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Verticordia mitchelliana', 'rapier feather flower', 'Native shrub grows in WA');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Banksia repens', 'creeping banksia', 'Native shrub grows in WA');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Eucalyptus saligna', 'Sydney blue gum', 'Native tree grows in NSW ans Qld');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Verticordia plumosa', 'plumed feather flower', 'Native shrub grows in WA');
INSERT INTO Plants(BotanicalName, CommonName, Description)
VALUES ('Tetratheca thymifolia', 'black-eyed susan', 'Native shrub grows in Qld, SA and Vic');


INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'NSW', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'QLD', '1.5');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'NT', '1.9');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'VIC', '1.2');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'SA', '1.4');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'ACT', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'WA', '2.4');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NSW', 'TAS', '2');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('QLD', 'QLD', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('QLD', 'NT', '1.4');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('QLD', 'VIC', '1.9');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('QLD', 'SA', '1.8');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('QLD', 'ACT', '1.5');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('QLD', 'WA', '2.5');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('QLD', 'TAS', '2.1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NT', 'NT', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NT', 'VIC', '2.2');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NT', 'SA', '1.2');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NT', 'ACT', '1.9');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NT', 'WA', '1.5');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('NT', 'TAS', '2.5');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('VIC', 'VIC', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('VIC', 'SA', '1.2');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('VIC', 'ACT', '1.3');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('VIC', 'WA', '2.2');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('VIC', 'TAS', '1.3');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('SA', 'SA', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('SA', 'ACT', '1.5');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('SA', 'WA', '1.6');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('SA', 'TAS', '2.1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('ACT', 'ACT', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('ACT', 'WA', '2.6');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('ACT', 'TAS', '1.7');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('WA', 'WA', '1');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('WA', 'TAS', '2.4');
INSERT INTO ShippingMultiplier (NurseryState, DestinationState, Multiplier)
VALUES ('TAS', 'TAS', '1');

DELIMITER //
CREATE TRIGGER after_orders_insert 
	AFTER INSERT ON Orders
	FOR EACH ROW
BEGIN
    INSERT INTO Messages
    SET ClientID = NEW.ClientID,
	MemberID = NEW.MemberID,
	Message = 'An order has been placed.';
END//
DELIMITER ;

INSERT INTO Stock (MemberID, PlantID, Price, UnitShippingCost, InStock)
VALUES (1, 1, 500, 10, 1);
INSERT INTO Stock (MemberID, PlantID, Price, UnitShippingCost, InStock)
VALUES (2, 2, 300, 15, 1);
INSERT INTO Stock (MemberID, PlantID, Price, UnitShippingCost, InStock)
VALUES (3, 3, 200, 20, 1);

INSERT INTO Orders (ClientID, MemberID, OrderStatus, CourierName, ShippingCostMultiplier)
VALUES (1, 1, 'Order Placed', 'DHL', 1.5);

INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (1, 1, 3, 50, 10);
INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (1, 2, 2, 70, 10);
INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (1, 3, 1, 90, 10);

INSERT INTO Orders (ClientID, MemberID, OrderStatus, CourierName, ShippingCostMultiplier)
VALUES (1, 1, 'Order Placed', 'Australian Post', 1.4);

INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (2, 1, 3, 50, 10);
INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (2, 2, 2, 70, 10);
INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (2, 3, 1, 90, 10);

INSERT INTO Orders (ClientID, MemberID, OrderStatus, CourierName, ShippingCostMultiplier)
VALUES (2, 2, 'Order Placed', 'Australian Post', 1.2);
INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (2, 4, 3, 50, 10);

INSERT INTO Orders (ClientID, MemberID, OrderStatus, CourierName, ShippingCostMultiplier)
VALUES (3, 3, 'Order Placed', 'DHL', 1.3);
INSERT INTO OrderItems (OrderID, PlantID, Quantity, Price, UnitShippingCost)
VALUES (3, 2, 2, 50, 10);

DELIMITER //
CREATE FUNCTION MultiplyShipingCost(p_PlantQuantity INT, p_PlantPrice DECIMAL(10,2), p_UnitShippingCosts DECIMAL(10,2), p_ShippingCostMultiplier DECIMAL(10,2))
	RETURNS DECIMAL(10,2)
	DETERMINISTIC
BEGIN
	DECLARE plantCost DECIMAL(10,2);
	DECLARE shippingCost DECIMAL(10,2);
	DECLARE totalCost DECIMAL(10,2);

	SET plantCost = p_PlantQuantity * p_PlantPrice;
	SET shippingCost = p_ShippingCostMultiplier * p_PlantQuantity * p_UnitShippingCosts;
	SET totalCost = shippingCost + plantCost;

RETURN(totalCost);
END //
DELIMITER ;

# Produce a report of a specific order.
SELECT Clients.ClientID, Clients.ClientName, Orders.OrderID, Orders.OrderDate, sum(MultiplyShipingCost(OrderItems.Quantity, OrderItems.Price, OrderItems.UnitShippingCost, Orders.ShippingCostMultiplier)) as TotalCost
FROM Clients, Orders, OrderItems
WHERE Orders.OrderID = 1
AND Clients.ClientID = Orders.OrderID
AND OrderItems.OrderID = Orders.OrderID;

# Select the order items of a specific order.
SELECT Orders.OrderID, Orders.OrderDate, OrderItems.PlantID, Plants.BotanicalName, OrderItems.Quantity, OrderItems.Price, OrderItems.UnitShippingCost, MultiplyShipingCost(OrderItems.Quantity, OrderItems.Price, OrderItems.UnitShippingCost, Orders.ShippingCostMultiplier) as TotalPrice
   FROM Orders, OrderItems, Plants
   WHERE Orders.OrderID = 1
   AND OrderItems.OrderID = 1
   AND Plants.PlantID = OrderItems.PlantID;

# Create a report betwean specific dates for a specific member.
SELECT ClientName, OrderDate, Location, Orders.OrderID, SUM(MultiplyShipingCost(OrderItems.Quantity, OrderItems.Price, OrderItems.UnitShippingCost, Orders.ShippingCostMultiplier)) as TotalPrice
FROM Orders
	JOIN Clients
		ON Clients.ClientID = Orders.ClientID
	JOIN OrderItems
		ON OrderItems.OrderID = Orders.OrderID
WHERE MemberID = 1
AND Orders.OrderDate BETWEEN '2019-01-01' AND now()
GROUP BY OrderID
ORDER BY OrderDate ASC