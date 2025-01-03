Create database EcommerceDWH;

Use EcommerceDWH;

-- User Dimension
CREATE TABLE User_Dim (
    User_Key INT PRIMARY KEY IDENTITY(1,1),
    User_Name VARCHAR(50),
    Customer_Zip_Code VARCHAR(10),
    Customer_City VARCHAR(50),
    Customer_State VARCHAR(50)
);

-- Order Dimension
CREATE TABLE Order_Dim (
    Order_Key INT PRIMARY KEY IDENTITY(1, 1),
    Order_ID VARCHAR(50),
    Order_Status VARCHAR(20),
    Order_Date DATETIME,
    Order_Approved_Date DATETIME,
    Pickup_Date DATETIME,
    Delivered_Date DATETIME,
    Estimated_Time_Delivery DATETIME
);

-- Product Dimension
CREATE TABLE Product_Dim (
    Product_Key INT PRIMARY KEY IDENTITY(1,1),
    Product_ID VARCHAR(50),
    Product_Category VARCHAR(50),
    Product_Name_Length INT,
    Product_Description_Length INT,
    Product_Photos_Qty INT,
    Product_Weight_G INT,
    Product_Length_CM INT,
    Product_Height_CM INT,
    Product_Width_CM INT
);

-- Seller Dimension
CREATE TABLE Seller_Dim (
    Seller_Key INT PRIMARY KEY IDENTITY(1,1),
    Seller_ID VARCHAR(50),
    Seller_Zip_Code VARCHAR(20),
    Seller_City VARCHAR(50),
    Seller_State VARCHAR(50)
);

-- Payment Dimension
CREATE TABLE Payment_Dim (
    Payment_Key INT PRIMARY KEY IDENTITY(1, 1),
	Order_ID VARCHAR(50),
    Payment_Type VARCHAR(20),
    Payment_Installments INT,
	Payment_Sequential INT
);

-- Feedback Dim
CREATE TABLE Feedback_Dim (
    Feedback_Key INT IDENTITY PRIMARY KEY,
	Feedback_ID VARCHAR(50),
	Order_ID VARCHAR(50),
    Feedback_Form_Sent_Date DATE,
    Feedback_Answer_Date DATE
);

-- Date Dimension
CREATE TABLE Date_Dim (
    Date_Key INT PRIMARY KEY IDENTITY(1,1),
    Full_Date DATETIME,
    Day INT,
    Month INT,
    Month_Name VARCHAR(20),
    Quarter INT,
    Year INT,
    Day_Of_Week VARCHAR(10),
    Week_Of_Year INT,
	Hour INT,
    Minute INT,
	Second INT,
    Is_Weekend CHAR(1),
    Is_Holiday CHAR(1),
    Season VARCHAR(20),
	Time_Period VARCHAR(20)
);

-- Order Item Fact
CREATE TABLE Order_Item_Fact (
    Fact_ID INT PRIMARY KEY IDENTITY(1, 1),
    Order_Key INT FOREIGN KEY REFERENCES Order_Dim(Order_Key),
    Product_Key INT FOREIGN KEY REFERENCES Product_Dim(Product_Key),
    Seller_Key INT FOREIGN KEY REFERENCES Seller_Dim(Seller_Key),
    User_Key INT FOREIGN KEY REFERENCES User_Dim(User_Key),
    Payment_Key INT FOREIGN KEY REFERENCES Payment_Dim(Payment_Key),
    Date_Key INT FOREIGN KEY REFERENCES Date_Dim(Date_Key),
	Feedback_Key INT FOREIGN KEY REFERENCES Feedback_Dim(Feedback_Key),
	Pickup_Limit_Date DATETIME,
    Price INT,
    Shipping_Cost INT, 
	Payment_Value INT,
	Total_Cost INT,
	Feedback_Score INT,
);


