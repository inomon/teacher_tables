-- CREATE DATABASE teachers;

CREATE TABLE teachers.trn_teacher (
    id INT auto_increment NOT NULL,
    nickname varchar(100) NULL,
    status TINYINT NULL COMMENT 'status 0=discontinued, 1=active, 2=deactivated',
    created_at DATETIME NULL,
    CONSTRAINT id_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci;

CREATE TABLE trn_teacher_role (
    id INT auto_increment NOT NULL,
    teacher_id INT NOT NULL,
    role TINYINT NULL COMMENT 'role 1=trainer, 2=assessor, 3=staff',
    created_at DATETIME NULL,
    CONSTRAINT id_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci;

CREATE TABLE trn_time_table (
    id INT auto_increment NOT NULL,
    teacher_id INT NOT NULL,
    lesson_datetime DATETIME NULL,
    status TINYINT NULL COMMENT 'status 1=open, 2=backup, 3=reserved',
    CONSTRAINT id_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci;

CREATE TABLE trn_evaluation (
    id INT auto_increment NOT NULL,
    teacher_id INT NOT NULL,
    result TINYINT NULL COMMENT 'result 1=taught, 2=noshow',
    lesson_datetime DATETIME NULL,
    created_at DATETIME NULL,
    CONSTRAINT id_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci;





INSERT into trn_teacher (id,nickname,status,created_at) VALUES 
(110250, "John D", 1, "2020-01-16 19:02:18"),
(110023, "Mike", 0, "2020-01-16 19:03:25"),
(110011, "Luca", 1, "2020-01-16 19:04:10"),
(110033, "Scottie", 2, "2020-01-17 08:10:23"),
(110030, "Steph C", 1, "2020-01-17 08:12:24");


INSERT into trn_teacher_role (id,teacher_id,role,created_at) VALUES 
(1, 110250, 1, "2020-01-17 08:29:55"),
(2, 110250, 2, "2020-01-17 09:02:01"),
(3, 110250, 3, "2020-01-17 09:02:09"),
(4, 110011, 1, "2020-01-17 09:02:27"),
(5, 110030, 1, "2020-01-17 09:02:37"),
(6, 110030, 2, "2020-01-17 09:02:45"),
(7, 110023, 1, "2020-01-17 09:02:57"),
(8, 110033, 3, "2020-01-17 09:03:11");


INSERT into trn_time_table (id,teacher_id,lesson_datetime,status) VALUES 
(1, 110250, "2020-01-11 17:00:00", 1),
(2, 110250, "2020-01-11 16:30:00", 1),
(3, 110250, "2020-01-10 16:00:00", 1),
(4, 110011, "2020-01-10 17:00:00", 1),
(5, 110011, "2020-01-10 21:00:00", 2),
(6, 110011, "2020-01-10 23:00:00", 3),
(7, 110030, "2020-01-10 21:30:00", 1),
(8, 110030, "2020-01-10 20:00:00", 1),
(9, 110030, "2020-01-10 19:30:00", 1),
(10, 110023, "2020-01-07 17:00:00", 1),
(11, 110023, "2020-01-06 17:00:00", 1),
(12, 110023, "2020-01-08 16:30:00", 2),
(13, 110033, "2020-01-07 15:30:00", 1),
(14 ,110033, "2020-01-06 16:30:00", 2),
(15 ,110033 ,"2020-01-07 10:30:00", 1);

INSERT into trn_evaluation (id,teacher_id,result,lesson_datetime,created_at) VALUES 
(1,"110250",1,"2020-01-11 17:00:00","2020-01-17 09:00:34"),
(2,"110250",1,"2020-01-11 16:30:00","2020-01-17 09:00:34"),
(3,"110250",1,"2020-01-10 16:00:00","2020-01-17 09:00:34"),
(4,"110011",1,"2020-01-10 17:00:00","2020-01-17 09:00:34"),
(5,"110011",2,"2020-01-10 21:00:00","2020-01-17 09:00:34"),
(6,"110011",1,"2020-01-10 23:00:00","2020-01-17 09:00:34"),
(7,"110030",1,"2020-01-10 21:30:00","2020-01-17 09:00:34"),
(8,"110030",1,"2020-01-10 20:00:00","2020-01-17 09:00:34"),
(9,"110030",1,"2020-01-10 19:30:00","2020-01-17 09:00:34"),
(10,"110023",1,"2020-01-07 17:00:00","2020-01-17 09:00:34"),
(11,"110023",1,"2020-01-06 17:00:00","2020-01-17 09:00:34"),
(12,"110023",2,"2020-01-08 16:30:00","2020-01-17 09:00:34"),
(13,"110033",1,"2020-01-07 15:30:00","2020-01-17 09:00:34"),
(14,"110033",2,"2020-01-06 16:30:00","2020-01-17 09:00:34"),
(15,"110033",1,"2020-01-07 10:30:00","2020-01-17 09:00:34");

