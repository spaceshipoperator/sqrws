with 
version_dates as (
select extract(epoch from d_date) e_date
from date_series(
  (select min(start_date) from issues where project_id = 1 and fixed_version_id = 8),
  (select max(due_date) from issues where project_id = 1 and fixed_version_id = 8))),
version_issues as (
select
id,
extract(epoch from start_date) e_start_date,
extract(epoch from due_date) e_due_date,
estimated_hours
from issues
where project_id = 1
and fixed_version_id = 8),
version_time_spent as (
select 
extract(epoch from te.spent_on) e_spent_on,
sum(hours) hours_spent
from time_entries te
join version_issues vi
on te.issue_id = vi.id
group by 1)
select
'estimate',
coalesce(sum(vi.estimated_hours), 0),
vd.e_date
from version_dates vd
left join version_issues vi
on vd.e_date <= vi.e_due_date
group by 1, 3
union
select
'spent',
coalesce(sum(vts.hours_spent), 0),
vd.e_date
from version_dates vd  
left join version_time_spent vts
on vd.e_date >= vts.e_spent_on
group by 1, 3
order by 3, 1
;
