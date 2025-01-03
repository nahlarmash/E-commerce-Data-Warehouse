-- When is the peak season of our e-commerce?
Select Top 1
       d.Season,
	   d.Quarter,
	   Count(o.Fact_ID) as Total_Orders
From Order_Item_Fact as o
Inner Join Date_Dim as d on d.Date_Key = o.Date_Key
Group By d.Season, d.Quarter
Order By Total_Orders Desc;

-- What time users are most likely to make an order or use the e-commerce app?
Select Top 10
       concat(d.Hour, ':', d.Minute, ':', d.Second) as Time_Of_Order,
	   d.Time_Period,
	   Count(o.Fact_ID) as Total_Orders
From Order_Item_Fact as o
Inner Join Date_Dim as d on d.Date_Key = o.Date_Key
Group By concat(d.Hour, ':', d.Minute, ':', d.Second),
	     d.Time_Period
Order By Total_Orders Desc;

-- What is the preferred way to pay in the ecommerce?
Select Top 1
       p.Payment_Type,
       Count_big(o.Fact_ID) as Total_Orders
From Order_Item_Fact as o
Inner Join Payment_Dim as p on Cast(o.Payment_Key as bigint) = Cast(p.Payment_Key as bigint)
Group By p.Payment_Type
Order By Total_Orders Desc;

-- How many installments are usually done when paying in the e-commerce?
Select Top 5
       p.Payment_Installments,
       Count(o.Fact_ID) as Total_Orders
From Order_Item_Fact as o
Inner Join Payment_Dim as p on o.Payment_Key = p.Payment_Key
Group By p.Payment_Installments
Order By Total_Orders Desc;

-- What is the average spending time for users in the e-commerce?
Select Avg(Datediff(Hour, o.Order_Approved_Date, o.Order_Date)) as Avg_Spending_Time
From Order_Item_Fact as f
Inner Join Order_Dim as o on f.Order_Key = o.Order_Key;

-- What is the frequency of purchase in each state?
Select u.Customer_State,
       Count(o.Fact_ID) as Total_Orders
From Order_Item_Fact as o
Inner Join User_Dim as u on o.User_Key = u.User_Key
Group By u.Customer_State
Order By Total_Orders Desc;

-- Which logistic route has heavy traffic in our e-commerce?
Select Top 10
       u.Customer_City,
       s.Seller_City,
       Count(o.Fact_ID) as Total_Orders
From Order_Item_Fact as o
Inner Join User_Dim as u on o.User_Key = u.User_Key
Inner Join Seller_Dim as s on o.Seller_Key = s.Seller_Key
Group By u.Customer_City, s.Seller_City
Order By Total_Orders Desc;

--  How many late-delivered orders are in our e-commerce? Are late orders affecting customer satisfaction?
Select Case
       When o.Delivered_Date > o.Estimated_Time_Delivery Then 'Late'
	   Else 'On-Time'
	   End As Delivery_Status,
       Count(f.Fact_ID) as Total_Orders,
	   Avg(f.Feedback_Score) As Avg_Feedback_Score
From Order_Item_Fact as f
Inner Join Order_Dim as o on f.Order_Key = o.Order_Key
Group By Case
       When o.Delivered_Date > o.Estimated_Time_Delivery Then 'Late'
	   Else 'On-Time'
	   End
Order By Total_Orders Desc;

-- How long are the delays for the delivery/shipping process in each state?
Select u.Customer_State,
       Avg(Datediff(Day, o.Estimated_Time_Delivery, o.Delivered_Date)) As Avg_Delivery_Delay
From Order_Item_Fact as f
Inner Join Order_Dim as o on o.Order_Key = f.Order_Key
Inner Join User_Dim as u on u.User_Key = f.User_Key
Where o.Delivered_Date > o.Estimated_Time_Delivery
Group By u.Customer_State
Order By Avg_Delivery_Delay Desc;

-- How long is the difference between estimated delivery time and actual delivery time in each state?
Select u.Customer_State,
       Avg(Datediff(Day, o.Delivered_Date, o.Estimated_Time_Delivery)) As Avg_Delivery_Time_Difference
From Order_Item_Fact as f
Inner Join Order_Dim as o on o.Order_Key = f.Order_Key
Inner Join User_Dim as u on u.User_Key = f.User_Key
Group By u.Customer_State
Order By Avg_Delivery_Time_Difference Desc;
