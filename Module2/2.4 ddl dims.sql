-- ************************************** "public".geography
drop table geography ;

CREATE TABLE public.geography
(
 geo_id      serial NOT NULL,
 country     varchar(50) NOT NULL,
 city        varchar(50) NOT NULL,
 state       varchar(50) NOT NULL,
 region      varchar(50) NOT NULL,
 postal_code integer,
 CONSTRAINT PK_192 PRIMARY KEY ( geo_id )
);

insert into public.geography 
select 100+row_number() over(), country,city,state,region,postal_code from (select distinct country,city,state,region,postal_code from orders ) a;

-- ************************************** "public".orders

CREATE TABLE public.orders_2
(
 order_date    timestamp NOT NULL ,
 customer_id   varchar(50) NOT NULL,
 customer_name varchar(100) NOT NULL,
 person_id     integer NOT NULL,
 order_Id      serial NOT NULL ,
 CONSTRAINT PK_Order PRIMARY KEY ( order_Id ),
 CONSTRAINT FK_258 FOREIGN KEY ( person_id ) REFERENCES "public".person_dim ( person_id )
);

CREATE INDEX fkIdx_260 ON "public".orders
(
 person_id
);

COMMENT ON TABLE "public".orders IS 'Order information
like Date, Amount';

-- ************************************** "public".person_dim

CREATE TABLE public.person_dim
(
 person_id serial NOT NULL ,
 person    varchar(100) NOT NULL,
 region    varchar(50) NOT NULL,
 CONSTRAINT PK_Product PRIMARY KEY ( person_id ),
 CONSTRAINT AK1_Product_SupplierId_ProductName UNIQUE ( person )
);

COMMENT ON TABLE "public".person_dim IS 'Basic information 
about Product';

insert into public.person_dim 
select 100+row_number() over(), person,region from (select person,region from people ) a;

-- ************************************** "public".product

CREATE TABLE "public".product
(
 product_id   serial NOT NULL,
 category     varchar(50) NOT NULL,
 subcategory  varchar(50) NOT NULL,
 product_name varchar(50) NOT NULL,
 segment      varchar(50) NOT NULL,
 CONSTRAINT PK_171 PRIMARY KEY ( product_id )
);

insert into public.product 
select 100+row_number() over(), category,subcategory,product_name,segment from (select category,subcategory,product_name,segment from orders ) a;

-- ************************************** "public".shipping_dim
drop table "public".shipping_dim;

CREATE TABLE "public".shipping_dim
(
 ship_id   serial NOT NULL,
 ship_mode varchar(50) NOT null,
-- ship_date timestamp NOT NULL,
 CONSTRAINT PK_153 PRIMARY KEY ( ship_id )
);

insert into public.shipping_dim 
select 100+row_number() over(), ship_mode from (select distinct ship_mode from orders ) a;



-- ************************************** "public".sales_fact
drop table sales_fact;

CREATE TABLE "public".sales_fact
(
 sales      numeric NOT NULL,
 order_date timestamp NOT NULL,
 quantity   numeric NOT NULL,
 ship_date  timestamp NOT NULL,
 discount   numeric NOT NULL,
 profit     numeric NOT NULL,
 ship_id    serial NOT NULL,
 geo_id     numeric ,
 product_id varchar(100) NOT NULL,
 row_id     integer NOT NULL,
 order_Id   varchar(50) NOT NULL,
 CONSTRAINT PK_163 PRIMARY KEY ( row_id, order_Id )
-- CONSTRAINT FK_214 FOREIGN KEY ( order_Id ) REFERENCES "public".orders ( order_Id ),
-- CONSTRAINT FK_235 FOREIGN KEY ( ship_id ) REFERENCES "public".shipping_dim ( ship_id ),
 --CONSTRAINT FK_241 FOREIGN KEY ( geo_id ) REFERENCES "public".geography ( geo_id ),
-- CONSTRAINT FK_244 FOREIGN KEY ( product_id ) REFERENCES "public".product ( product_id ),
-- CONSTRAINT FK_254 FOREIGN KEY ( order_date, ship_date ) REFERENCES "public".calendar_dim ( order_date, ship_date )
);

CREATE INDEX fkIdx_216 ON "public".sales_fact
(
 order_Id
);

CREATE INDEX fkIdx_237 ON "public".sales_fact
(
 ship_id
);

CREATE INDEX fkIdx_243 ON "public".sales_fact
(
 geo_id
);

CREATE INDEX fkIdx_246 ON "public".sales_fact
(
 product_id
);

CREATE INDEX fkIdx_257 ON "public".sales_fact
(
 order_date,
 ship_date
);

 insert into public.sales_fact 
select sales,order_date,quantity,a.ship_date,discount,profit,
 		 ship_id,
 		 geo_id     ,
 		 product_id ,
		 row_id,
 		 order_Id   
from orders a
left join shipping_dim b on a.ship_mode = b.ship_mode
left join geography g on a.country = g.country and a.city=g.city and a.state = g.state and a.postal_code =g.postal_code 
;

