Query #1:

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
GROUP BY t.id

Query #2:

SELECT 
	t.id as ID,
	t.nickname as Nickname,
	COUNT(DISTINCT tt_open.id) as Open,
	COUNT(DISTINCT tt_reserved.id) as Reserved,
	COUNT(DISTINCT e_taught.id) as Taught,
	COUNT(DISTINCT e_noshow.id) as 'No Show'
FROM 
	trn_teacher t
	LEFT JOIN trn_time_table tt_open ON (t.id = tt_open.teacher_id AND tt_open.status = 1)
	LEFT JOIN trn_time_table tt_reserved ON (t.id = tt_reserved.teacher_id AND tt_reserved.status = 3)
	LEFT JOIN trn_evaluation e_taught ON (t.id = e_taught.teacher_id AND e_taught.result = 1)
	LEFT JOIN trn_evaluation e_noshow ON (t.id = e_noshow.teacher_id AND e_noshow.result = 2)
GROUP BY t.id
