insert into store
value
(1,'banda',0509226548,'banda@gmail.com','street54','Makkah','Batha Quraish'),
(2,'banda',050675398,'banda@gmail.com','street7','Makkah','Azizia'),
(3,'banda',0508211398,'banda@gmail.com','street12','Makkah','Al-Awali'),
(4,'banda',0508214320,'banda@gmail.com','street99','Makkah','Al-Shawqia'),
(5,'banda',0508214777,'banda@gmail.com','street29','Makkah','Crown Prince');

insert into Department
value
(1,'fruits and vegetables',1),
(2,'sweets',2),
(3,'Cheeses',3),
(4,'Baked goods',4),
(5,'Organic food',5);

insert into Product
value
('bc-145','Apple',5,'2020-01-11','2020-06-12',1),
('bc-97','kinder',3,'2020-05-01','2020-09-19',2),
('bc-765','Almarai cheese',20,'2020-06-18','2020-08-12',3),
('bc-91','Braed',1,'2020-03-10','2020-03-13',4),
('bc-63','Oats',30,'2020-12-05','2021-02-05',5),
('bc-144','orange',4,'2020-01-11','2020-06-12',1),
('bc-143','Grape',6,'2020-01-11','2020-06-12',1),
('bc-153','Tomatoes',6,'2020-01-11','2020-06-12',1),
('bc-150','lettuce',6,'2020-01-11','2020-06-12',1),
('bc-98','twix',5,'2020-05-01','2020-09-19',2),
('bc-764','puck cheese',20,'2020-06-18','2020-08-12',3),
('bc-712','Mozzarella cheese',20,'2020-06-18','2020-08-12',3),
('bc-710','parmesan cheese',15,'2020-06-18','2020-08-12',3);

insert into employee
value
(439010950,'Alaa','Abdullah','street12','Makkah','Al-Awali','2000-05-27',5500,1,439010950),
(439009442,'shahad','Abdullah','street29','Makkah','Crown Prince','2000-06-01',5500,5,439009442),
(439004660,'Manar','Mohammed','street99','Makkah','Al-Shawqia','2000-09-22',5500,3,439004660),
(439001527,'Ruba','Abed','street7','Makkah','Azizia','2000-03-16',5500,4,439001527),
(439008245,'Sara','Ali','street54','Makkah','Batha Quraish','2000-10-10',5500,2,439008245);

insert into customer
value
(1167,'Ahmed',0509337651),
(7834,'Amal',0536519980),
(9581,'Lama',0597333610),
(6131,'Asma',0509222758),
(4836,'Rana',0509241165);

insert into employeephone
value
(439010950,0509354421),
(439009442,0509988456),
(439004660,0500006647),
(439001527,0551127640),
(439008245,0567633090);

insert into buying
value
('bc-145',1167,439010950,300,65,'card'),
('bc-63',4836,439009442,450,10,'card'),
('bc-765',6131,439004660,600,30,'cash'),
('bc-91',7834,439001527,10,66,'card'),
('bc-97',9581,439008245,3,4,'cash');

-- -----------------------------------------------------------------------------------------
-- use select command

-- 1) display the employee ID , the first name and the department she works in
select empID , fName , deptNum
from supermarket.employee
order by deptNum ;

-- 2) count the number of prudects in the product table
select count(barcode) as prudectCount
from supermarket.product;

-- 3) display the sum of total cost of diffrent payment methods
select PaymentMethode ,sum(totalCost) as reciptsTotalCostSum
from supermarket.buying
group by PaymentMethode;

-- 4) display the count of product in dpartments that has more than one prudect
select deptNum , count(deptNum) as productCount
from supermarket.product 
group by deptNum
having count(deptNum) > 1;

-- 5) display the customer name , recipt Number, total cost and the product he bought.
select custName , reciptNum , totalCost , productName 
from supermarket.customer a , supermarket.buying b , supermarket.product c
where a.custID = b.custID and b.barcode = c.barcode;

-- 6) display the store from which the ricept was issued 
--    and the name of the emplyee who sold the product
select store.storeName , store.neighborhood, a.fName , b.reciptNum
from supermarket.employee a , supermarket.buying b , supermarket.product c , supermarket.department d , supermarket.store
where a.empID = b.empID and b.barcode = c.barcode
and c.deptNum = d.deptNum and store.storeNum = d.storeNum 
order by neighborhood , fName , reciptNum;

-- 7) diplay the emplyee name who have a salary larger or equal the avrege salarey
select fName ,lName , salary
from supermarket.employee
where salary >= (select avg(salary) from supermarket.employee);

-- 8) display what the department in each store
select store.storeNum ,store.neighborhood ,deptName
from supermarket.store , supermarket.department
where store.storeNum = department.storeNum;

-- 9) display the name of employee who sold a product to the costmer Ahmad and Rana
select fName , lName
from supermarket.employee
where empID in (select empID 
				from supermarket.buying
                where custID in (select custID
								 from supermarket.customer
                                 where custName = 'Ahmed' or custName = 'Rana'));

-- 10) diplay the emplyee ID and number who works in department number = 5
select empID, phone 
from supermarket.employeephone
where empID in (select empID
				from supermarket.employee
                where deptNum = 5);
                
-- -----------------------------------------------------------------------------------------
-- update cammands
-- 1) insert a supervisor and assign her to supervise emplyees of department 5
insert into supermarket.employee
value
(439010900,'Amera','Omar','street29','Makkah','Crown Prince','2000-10-11',7000,5,439010900);
insert into supermarket.employeephone
value
(439010900,0508839123);

update supermarket.employee
set super_ID = 439010900 
where deptNum = 5 ;

-- 2) 10% increase in salary for the supervisor Amera and her supervisees
update supermarket.employee
set salary = (salary + (salary*10/100))
where super_ID = 439010900 ;

-- delete command 
-- 1) delete a recipt with a price under 10 
delete from supermarket.buying
where totalCost <10 ;

-- 2) delete all the products in the sweets department
delete from supermarket.product
where deptNum in ( select deptNum
					from supermarket.department
                    where deptName ='sweets');