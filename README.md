# Project
For the SQL query exam, I've made it possible to test the query under a docker container.

# Installation 

## Prerequisite
Docker is installed, latest build on any platform is suggestted.

## Steps

Easy installation is as follows:

1. Clone repo via git into your local machine
2. Open a CLI (CLI/powershell/bash) on your machine, and navigate to the project directory.
3. Execute docker compose commands

## Commands

```bash
# setup the project
mkdir teacher_tables
cd teacher_tables
git clone git@github.com:inomon/teacher_tables.git .

# initialize the container with the DB/data
docker-compose up -d
docker exec -it teacher_tables_mariadb_1 bash -c "mysql --user=teach --password=teach teachers < /usr/sql/db.sql"
```

# Usage


## Accessing the data
You can use any database management app, the db credentials are as follows:

```perl
DB_HOST=localhost
DB_PORT=3336
DB_DATABASE=teachers
DB_USER=teach
DB_PASSWORD=teach
```

Or if you'd prefer the CLI experience, here is the command to bring you straight to the MySQL CLI:
```bash
docker exec -it teacher_tables_mariadb_1 mysql --user=teach --password=teach teachers
```

# Solutions


## Query #1

> 
> Requirements: 1. Write a query to display the ff columns:
> 
> ID (should start with T + 11 digits of trn_teacher.id with leading zeros like 'T00000088424'), Nickname, Status and Roles (like Trainer/Assessor/Staff) 
> 
> using table trn_teacher and trn_teacher_role.
> 

### Solution
Join `trn_teacher` with a subquery from `trn_teacher_role` that already has its `role` transformed into its string counterpart.
Together with the `trn_teacher.status` transformed with its string counterpart also.

```sql
SELECT 
	CONCAT('T', LPAD(t.id, 11, '0')) as ID,
	t.nickname as Nickname,
	IF(t.status = 0, 'Discontinued', IF(t.status = 1, 'Active', IF(t.status = 2, 'Deactivated', 'n/a'))) as Status,
	REPLACE(GROUP_CONCAT(tr.role_str), ',', '/') as Roles
FROM 
	trn_teacher t
	LEFT JOIN (
		SELECT
			sub_tr.teacher_id,
			IF(sub_tr.role = 1, 'Trailer', IF(sub_tr.role = 2, 'Assessor', IF(sub_tr.role = 3, 'Staff', 'n/a'))) as role_str
		FROM trn_teacher_role sub_tr
	) tr ON (t.id = tr.teacher_id)
GROUP BY t.id;
```

ONE-LINE EXECUTABLE FORMAT: 
```sql
SELECT CONCAT('T', LPAD(t.id, 11, '0')) as ID, t.nickname as Nickname, IF(t.status = 0, 'Discontinued', IF(t.status = 1, 'Active', IF(t.status = 2, 'Deactivated', 'n/a'))) as Status, REPLACE(GROUP_CONCAT(tr.role_str), ',', '/') as Roles FROM trn_teacher t LEFT JOIN ( SELECT sub_tr.teacher_id, IF(sub_tr.role = 1, 'Trailer', IF(sub_tr.role = 2, 'Assessor', IF(sub_tr.role = 3, 'Staff', 'n/a'))) as role_str FROM trn_teacher_role sub_tr ) tr ON (t.id = tr.teacher_id) GROUP BY t.id;
```
#### Alternative Solutions

A. For this case, the data is not normalized and still requires MySQL string manipulations, going further from this code. It would be better to create a reference table for `trn_teacher.status` as well as `trn_teacher_role.role` strings.
B. Another alternative is going down the datatable field route, where we would use `ENUM()` for the `trn_teacher.status` as well as `trn_teacher_role.role`.


## Query #2

> 
> Requirements: 2. Write a query to display the ff columns:
> 
> ID (from teacher.id), Nickname, Open (total open slots from trn_teacher_time_table), Reserved (total reserved slots from trn_teacher_time_table), Taught (total taught from trn_evaluation) and No Show (total no_show from trn_evaluation) using all tables above. 
> 
> Should show only those who are active (trn_teacher.status = 1 or 2) and those who have both Trainer and Assessor role.
> 

### Solution
We needed to have the teacher with roles who are _both_ "Trainer & Assessor", which means we have to collectively get all teacher roles and filter out those without. To achive this, `IN()` is not possible since its an `OR` statement internally, what solution I came upon with is by grouping teacher roles (by `teacher_id`), filtering if the rows have the corresponding roles we require and checking the `COUNT()` if their roles are ONLY "Trainer & Assessor" - as was requested.
Further down the condition, we have counters for `trn_time_table` & `trn_evaluation` split into its corresponding `status` or `result` type. This is so that we retrieve them in the shortest/simplest query through a `LEFT JOIN` compared to one of my theories wherein another _subquery_ is needed. I think having `LEFT JOIN` on each requested field is better.


```sql
SELECT 
	t.id as ID,
	t.nickname as Nickname,
	COUNT(DISTINCT tt_open.id) as Open,
	COUNT(DISTINCT tt_reserved.id) as Reserved,
	COUNT(DISTINCT e_taught.id) as Taught,
	COUNT(DISTINCT e_noshow.id) as 'No Show'
FROM 
	trn_teacher t
	RIGHT JOIN (
		SELECT sub_tr.*, COUNT(sub_tr.role) as role_count
		FROM trn_teacher_role sub_tr
		WHERE sub_tr.role IN (1, 2)
		GROUP BY sub_tr.teacher_id
		HAVING role_count = 2
	) tr ON (t.id = tr.teacher_id)
	LEFT JOIN trn_time_table tt_open ON (t.id = tt_open.teacher_id AND tt_open.status = 1)
	LEFT JOIN trn_time_table tt_reserved ON (t.id = tt_reserved.teacher_id AND tt_reserved.status = 3)
	LEFT JOIN trn_evaluation e_taught ON (t.id = e_taught.teacher_id AND e_taught.result = 1)
	LEFT JOIN trn_evaluation e_noshow ON (t.id = e_noshow.teacher_id AND e_noshow.result = 2)
WHERE 
	tr.role IN (1,2) 
	AND t.status IN (1, 2)
GROUP BY t.id;
```

ONE-LINE EXECUTABLE FORMAT: 
```sql
SELECT t.id as ID, t.nickname as Nickname, COUNT(DISTINCT tt_open.id) as Open, COUNT(DISTINCT tt_reserved.id) as Reserved, COUNT(DISTINCT e_taught.id) as Taught, COUNT(DISTINCT e_noshow.id) as 'No Show' FROM trn_teacher t RIGHT JOIN ( SELECT sub_tr.*, COUNT(sub_tr.role) as role_count FROM trn_teacher_role sub_tr WHERE sub_tr.role IN (1, 2) GROUP BY sub_tr.teacher_id HAVING role_count = 2 ) tr ON (t.id = tr.teacher_id) LEFT JOIN trn_time_table tt_open ON (t.id = tt_open.teacher_id AND tt_open.status = 1) LEFT JOIN trn_time_table tt_reserved ON (t.id = tt_reserved.teacher_id AND tt_reserved.status = 3) LEFT JOIN trn_evaluation e_taught ON (t.id = e_taught.teacher_id AND e_taught.result = 1) LEFT JOIN trn_evaluation e_noshow ON (t.id = e_noshow.teacher_id AND e_noshow.result = 2) WHERE tr.role IN (1,2) AND t.status IN (1, 2) GROUP BY t.id;
```

#### Alternative Solutions

I haven't dug deep into it, but it could be possible to get each Open/Reserved/Taught/NoShow counts through a _subquery_.
