-- 0
select p.parent_id, p.payload
from parent p
where not exists(select from child c where c.parent_id = p.parent_id);

-- 1
select p.parent_id, p.payload
from parent p
where not (array[p.parent_id] && array(select c.parent_id from child c));

-- 2
select distinct p.parent_id, p.payload
from parent p
    full join child c on (c.parent_id = p.parent_id)
where c.parent_id is null;

-- 3
select p.parent_id, p.payload
from parent p
where p.parent_id not in (select c.parent_id from child c);

-- 4
select p.parent_id, p.payload
from parent p
    left join child c on (c.parent_id = p.parent_id)
where c.parent_id is null;

-- 5
with w_child_with_parents as (
    select
        c.parent_id,
        (select count(*)
         from parent p
         where c.parent_id = p.parent_id) = 1 as parent_exists
    from child c
)
select p.parent_id, p.payload
from parent p
where p.parent_id in (
    select pc.parent_id
    from w_child_with_parents pc
    where not pc.parent_exists
);

-- 6
select p.parent_id, p.payload
from parent p
    full join child c on (c.parent_id = p.parent_id)
group by
    p.parent_id,
    p.payload
having count(c) = 0;

-- 7
select p.parent_id, p.payload
from parent p
where p.parent_id in (
    select p2.parent_id from parent p2
    except all
    select c2.parent_id from child c2
);
