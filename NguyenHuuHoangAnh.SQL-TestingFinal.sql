CREATE DATABASE ManageStudent;
USE ManageStudent;

DROP TABLE IF EXISTS Student;
CREATE TABLE Student (
    StudentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Age DATE NOT NULL,
    Gender ENUM('Male', 'Female')
);


DROP TABLE IF EXISTS `Subject`;
CREATE TABLE `Subject` (
    SubjectID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(50) NOT NULL
);


DROP TABLE IF EXISTS StudentSubject;
CREATE TABLE StudentSubject(
	StudentID INT NOT NULL,
    SubjectID INT NOT NULL,
    Mark DECIMAL(3,1) NOT NULL,
    `Date` Date NOT NULL,
    PRIMARY KEY(StudentID,SubjectID),
    FOREIGN KEY(StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY(SubjectID) REFERENCES `Subject`(SubjectID)
);


INSERT INTO Student	(StudentName			,Age		,Gender)
VALUES 				('Nguyen Huu Hoang Anh','2000-2-8','Male'),
					('Nguyen Nhat Anh'	   ,'2000-5-8','Female'),
					('Nguyen Sy Nguyen'    ,'2001-2-8','Male'),
					('Nguyen Minh Vu'      ,'2002-2-8','Male'),
					('Nguyen Van A'        ,'2000-2-8', null);
        

INSERT INTO `Subject`(`Name`)
VALUE				 ('Toan'),
					 ('Vat Li'),
                     ('Hoa');
			
INSERT INTO StudentSubject(StudentID,SubjectID,Mark,`Date`)
VALUES 					  (1		,1		  ,9.5 ,'2020-8-8'),
						  (1		,2		  ,9.5 ,'2020-8-8'),
						  (2		,1	  	  ,9.5 ,'2020-8-8'),
					      (3		,1		  ,9.5 ,'2020-8-8');
						
-- cau 2a
 
 SELECT 
    t1.*
FROM
    `subject` t1
        LEFT JOIN
    StudentSubject t2 ON t1.SubjectID = t2.SubjectID
WHERE
    t2.SubjectID IS NULL;
    
-- cau 2b

SELECT 
    t1.SubjectID, t1.`Name`
FROM
    `subject` t1
        JOIN
    StudentSubject t2 ON t1.SubjectID = t2.SubjectID
GROUP BY SubjectID
HAVING COUNT(t2.mark) >= 2;

-- cau 3
DROP VIEW IF EXISTS StudentInfo;
CREATE VIEW StudentInfo AS
    SELECT 
        t1.StudentID,
        IFNULL(t2.SubjectID,'Chua Dang Ki') As SubjectID,
        t1.StudentName,
        t1.Age,
        IFNULL(t1.Gender, 'Unknown') AS Gender,
        IFNULL(t2.`Name`,'Chua Dang Ki') As `Name`,
        IFNULL(t3.Mark,'Chua co') AS Mark,
		IFNULL(t3.`Date`,'Chua co') As `Date`
    FROM
         Student t1
          LEFT JOIN
        StudentSubject t3 ON t3.StudentID = t1.StudentID
           LEFT JOIN
        `Subject` t2 ON t3.SubjectID = t2.SubjectID;


SELECT 
    *
FROM
    StudentInfo;
-- cau 4
DROP TRIGGER IF EXISTS SubjectUpdateID;
DELIMITER $$
CREATE TRIGGER SubjectUpdateID 
BEFORE UPDATE ON `Subject`
FOR EACH ROW
BEGIN
	UPDATE StudentSubject
    SET SubjectID=NEW.SubjectID
    WHERE SubjectID=OLD.SubjectID;
END $$
DELIMITER ;



UPDATE `Subject`
SET SubjectID=4
WHERE SubjectID=3;

-- b
DROP TRIGGER IF EXISTS StudentDeleteID;
DELIMITER $$
CREATE TRIGGER StudentDeleteID
BEFORE DELETE ON Student
FOR EACH ROW
BEGIN
	DELETE FROM StudentSubject 
	WHERE
		StudentID = OLD.StudentID;
END $$
DELIMITER ;


SELECT 
    *
FROM
    student;
DELETE FROM Student 
WHERE
    StudentId = 4;

SELECT 
    *
FROM
    StudentSubject;

-- cau 5
DROP PROCEDURE IF EXISTS DelelteStudent;
DELIMITER $$
CREATE PROCEDURE DelelteStudent(IN stu_name varchar(30))
BEGIN
	IF(stu_name='*') THEN
     DELETE FROM Student;
	ELSE 
		DELETE FROM Student
        WHERE StudentName=stu_name;
	END IF;
END $$
DELIMITER ;


CALL DelelteStudent('Nguyen Nhat Anh');

SELECT 
    *
FROM
    StudentSubject;
    
SELECT 
    *
FROM
    student;

