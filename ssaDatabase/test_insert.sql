insert into locations
values(cast(1 as binary(36)), '539 Packard', 'Ann Arbor', 'MI', '20854', 'USA');

insert into descriptions
values(cast(1 as binary(36)), cast(2 as binary(30)), 'living room table', 500);
--start
insert into descriptions
values(cast(100 as binary(36)), cast(3 as binary(30)), 'foreign key error', null);
--end
insert into descriptions
values(cast(1 as binary(36)), cast(3 as binary(30)), 'living room', null);

--start
insert into tags values(cast(0 as binary(10)), cast(1 as binary(36)), cast(2 as binary(30)), cast(10 as binary(20)));
insert into tags
values(cast(1 as binary(10)), cast(100 as binary(36)), cast(2 as binary(30)), cast(10 as binary(20)));
--end
insert into tags
values(cast(1 as binary(10)), cast(1 as binary(36)), cast(2 as binary(30)), cast(10 as binary(20)));
--start
insert into tags
values(cast(0 as binary(10)), cast(1 as binary(36)), cast(200 as binary(30)), cast(10 as binary(20)));
--end
insert into tags
values(cast(0 as binary(10)), cast(1 as binary(36)), cast(3 as binary(30)), cast(10 as binary(20)));