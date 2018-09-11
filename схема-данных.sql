create table parent (parent_id serial primary key, payload text);

create table child (child_id serial primary key, parent_id integer unique references parent (parent_id));
