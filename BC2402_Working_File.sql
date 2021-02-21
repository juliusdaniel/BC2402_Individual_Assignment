#--- CoB (NBS) JULIUS DANIEL SARWONO - U1910510F ---#
#--- BC2402 Individual Assignment: COVID'19 - Safe Check-In & Trace Together ---#

#1. Based on the list of shopping malls, what are the sector names?
select distinct sector
from shoppingmalls;

#2. How many shopping malls has “city” (consider both upper and lower cases) in its name?
select Mall_Name
from shoppingmalls
where Mall_Name like "%city%";

#3. What are the top 3 most common surnames? Display the number of individuals of each.
select Surname, count(*) as Amt
from demo
group by Surname
order by Amt desc
limit 3;

#4. What is the age distribution among the data? Display the number of individuals by age in descending order.
select Age, count(*) as AMT
from demo
group by Age
order by AMT desc;

#5. What is the percentage of individuals in essential services among all individuals in the dataset?
select count(*)/(select count(*) from demo) as PerceOFEssen
from demo
where EssentialSrv = 1;

#6. What is the percentage of female who is working in essential services among all female in the dataset?
select count(*)/
(select count(*)
from demo
where Gender = 0)
as PerceOFEssenFemale
from demo
where EssentialSrv = 1 and Gender = 0;

#7. What is the percentage of male who is between 22 to 45 years (inclusive of 22 and 45) old working in essential services among all male of the age range?
select count(*)/
(select count(*)
from demo
where Gender = 1 and Age between 22 and 45)
as PerceOFEssenMale22To45yo
from demo
where EssentialSrv = 1 and Gender = 1 and Age between 22 and 45;

#8. How many unique people have checked in at shopping malls in the west sector?
select count(distinct ID) as UniquePpl
from checkin
where location in
	(select Mall_ID
	from shoppingmalls
	where Sector = "west");

#9. What are the top 3 shopping malls in the east sector with the most instances of checked in (an individual can perform multiple instances of check-in at a mall)?
select Location, count(*) as AMT
from checkin
where location in
	(select Mall_ID
	from shoppingmalls
	where Sector = "east")
group by Location
order by AMT desc
limit 3;

#10. What are the top 3 shopping malls in the west sector with the most checked in after 6pm (including 6pm sharp)?
select Location, count(*) as AMT
from checkin
where Hour >= 18 and location in
	(select Mall_ID
	from shoppingmalls
	where Sector = "west")
group by Location
order by AMT desc
limit 3;

#11. What is the check-in distribution among sectors? Display the number of individuals of each.
select Sector, count(*) as AmtOfCheckIns
from checkin A, shoppingmalls B
where A.Location = B.Mall_ID
group by Sector;

#12. How many unique people checked in at “Tiong Bahru Plaza” between 1-May- 2020 and 28-June-2020? 
select count(distinct ID) as PplTBP
from checkin
where cast(concat(year,'-',month,'-',day) as DATE) between '2020-05-01' and '2020-06-28'
and Location in
	(select Mall_ID
    from shoppingmalls
    where Mall_Name = "Tiong Bahru Plaza");
    
#13. How many people checked in at “Tiong Bahru Plaza” between 1-May-2020 and 28-June-2020, who are female and older than 40 years old (40 yo inclusive)?
select count(distinct ID) as PplTBP
from checkin
where cast(concat(year,'-',month,'-',day) as DATE) between '2020-05-01' and '2020-06-28'
and Location in
	(select Mall_ID
    from shoppingmalls
    where Mall_Name = "Tiong Bahru Plaza")
and ID in
	(select ID
    from demo
    where Gender = 0 and Age >= 40);

#14. Who (and on which day and month) has checked in at “Tiong Bahru Plaza” or at “Alexandra Central” more than once on a day?
select ID, Day, Month, count(*) as Amt
from checkin
where Location in
	(select Mall_ID
	from shoppingmalls
	where Mall_Name = "Tiong Bahru Plaza" or Mall_Name = "Alexandra Central")
group by ID, Day, Month
having Amt > 1;

#15. Display the instances of check-in at each shopping mall when it was at the maximum crowdedness level?
select Mall_Name, count(*) as Amt
from checkin A, shoppingmalls B
where A.Location = B.Mall_ID
and A.Crowdedness in
	(select Crowdedness_ID
	from crowdedness
	where Level = "Max_100percentage")
group by Mall_Name;

#16. Which are the shopping malls with more female check-ins than male check-ins?
select Location, sum(case when gender=0 then 1 else 0 end) FemaleAmt, sum(case when gender=1 then 1 else 0 end) MaleAmt
from checkin as A left join demo as B on A.ID = B.ID
group by Location
having FemaleAmt > MaleAmt;

#17. Who are the individuals with multiple check-ins at a shopping mall, sort results in descending order?
select ID, Location, count(*) as checkInAmt
from checkin
group by ID, Location
having checkInAmt > 1
order by checkInAmt desc;

#18. Show individuals (an individual who checked in with two different mobile numbers are considered two occasions of check-ins) who had multiple check-ins at a shopping mall?
select ID, Location, count(*) as checkInAmt
from checkin
group by ID, Location
having checkInAmt > 1;

#19. Among the list of individuals in the dataset, what are the mobile numbers that appear to be in proximity in at least one occasion?
select distinct MobileNO, NearByMobileNo
from tracetogether;

#20. Mobile numbers were manually entered into the system during check-ins. Are there any problems with the mobile numbers? If so, what are those?
select mobileNO
from checkin
where LENGTH (mobileNO) != 8 OR concat('',MobileNO * 1) != MobileNO;