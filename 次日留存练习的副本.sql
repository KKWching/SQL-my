-- 计算'2021-11-01'这天的次日、2日、3日留存-------------------
with ord as
(
select
uid,
date(in_time) as call_time
from tb_user_log
)

,a as
(
select 
uid,
-- t1.call_time as ftm,
-- t2.call_time as atm,
datediff(t2.call_time,t1.call_time) as '时间间隔'
from ord t1
left join ord t2 using(uid)
-- on t1.uid=t2.uid
where t1.call_time = '2021-11-01'
)

select
count(distinct if(时间间隔=1,uid,null))/count(distinct uid) as 2_day,
count(distinct if(时间间隔=2,uid,null))/count(distinct uid) as 3_day,
count(distinct if(时间间隔=3,uid,null))/count(distinct uid) as 4_day
from a
;

-- 计算每天的次日留存------------------------------------
with ord as
(
select
uid,
date(in_time) as call_time
from tb_user_log
)

, a as 
(
select
*,
min(call_time) over(partition by uid) as first_in
from ord 
)

select
count(distinct if(datediff(call_time,first_in)=1,uid,null))
/count(distinct uid) as 2_day
from a
group by first_in
