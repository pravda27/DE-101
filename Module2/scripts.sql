select * from orders;


-- total sales---------------------------------------------------------------------------------
select sum(sales) from orders o; 

-- total Profit --------------------------------------------------------------------------------
select sum(profit) from orders o; 

-- Profit Ratio --------------------------------------------------------------------------------
select round(sum(profit) / sum(sales) * 100,2) from orders o; 

-- Profit per order ----------------------------------------------------------------------------
select sum(profit) / count(distinct order_id)  from orders o; 

--% ��������� �� ������ ------------------------------------------------------------------------
select round(sum(case when a.returned = 'Yes' then sales else 0 end) / sum(a.sales) * 100,2)  
from (
select distinct *
from orders o
left join returns r on r.order_id=o.order_id 
) a  ;  

--���� ������ �� �������� ------------------------------------------------------------------------
select region, round(sum(sales) / (select sum(sales) from orders) * 100,2) 
from orders
group by region;

--������� � ������� �� ����������------------------------------------------------------------------------
select category, sum(sales), sum(profit)  
from orders
group by category;

--�������� ������� � �������------------------------------------------------------------------------
select date_trunc('month', order_date) as per, sum(sales) as sales, sum(profit) as profit
from orders
group by  date_trunc('month', order_date)
order by 1
;

--�������� ������ �� ���������------------------------------------------------------------------------
select date_trunc('month', order_date) as per,segment,sum(sales) as sales
from orders
group by  date_trunc('month', order_date),segment
order by 1
;

--������� �� ������------------------------------------------------------------------------
select state, sum(sales) 
from orders o
group by state 
order by 2 desc