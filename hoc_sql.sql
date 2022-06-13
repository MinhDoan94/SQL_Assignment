create table faculty (
	id number primary key,
	name nvarchar2(30) not null
); 
create table subject(
	id number primary key,
	name nvarchar2(100) not null,
	lesson_quantity number(2,0) not null -- tổng số tiết học
);
create table student (
	id number primary key,
	name nvarchar2(30) not null,
	gender nvarchar2(10) not null, -- giới tính
	birthday date not null,
	hometown nvarchar2(100) not null, -- quê quán
	scholarship number, -- học bổng
	faculty_id number not null constraint faculty_id references faculty(id) -- mã khoa
);
create table exam_management(
	id number primary key,
	student_id number not null constraint student_id references student(id),
	subject_id number not null constraint subject_id references subject(id),
	number_of_exam_taking number not null, -- (thi trên 1 lần được gọi là thi lại) 
	mark number(4,2) not null -- điểm
);
-- subject
insert into subject (id, name, lesson_quantity) values (1, n'Cơ sở dữ liệu', 45);
insert into subject values (2, n'Trí tuệ nhân tạo', 45);
insert into subject values (3, n'Truyền tin', 45);
insert into subject values (4, n'Đồ họa', 60);
insert into subject values (5, n'Văn phạm', 45);


-- faculty
insert into faculty values (1, n'Anh - Văn');
insert into faculty values (2, n'Tin học');
insert into faculty values (3, n'Triết học');
insert into faculty values (4, n'Vật lý');


-- student
insert into student values (1, n'Nguyễn Thị Hải', n'Nữ', to_date('19900223', 'YYYYMMDD'), 'Hà Nội', 130000, 2);
insert into student values (2, n'Trần Văn Chính', n'Nam', to_date('19921224', 'YYYYMMDD'), 'Bình Định', 150000, 4);
insert into student values (3, n'Lê Thu Yến', n'Nữ', to_date('19900221', 'YYYYMMDD'), 'TP HCM', 150000, 2);
insert into student values (4, n'Lê Hải Yến', n'Nữ', to_date('19900221', 'YYYYMMDD'), 'TP HCM', 170000, 2);
insert into student values (5, n'Trần Anh Tuấn', n'Nam', to_date('19901220', 'YYYYMMDD'), 'Hà Nội', 180000, 1);
insert into student values (6, n'Trần Thanh Mai', n'Nữ', to_date('19910812', 'YYYYMMDD'), 'Hải Phòng', null, 3);
insert into student values (7, n'Trần Thị Thu Thủy', n'Nữ', to_date('19910102', 'YYYYMMDD'), 'Hải Phòng', 10000, 1);


-- exam_management
insert into exam_management values (1, 1, 1, 1, 3);
insert into exam_management values (2, 1, 1, 2, 6);
insert into exam_management values (3, 1, 2, 2, 6);
insert into exam_management values (4, 1, 3, 1, 5);
insert into exam_management values (5, 2, 1, 1, 4.5);
insert into exam_management values (6, 2, 1, 2, 7);
insert into exam_management values (7, 2, 3, 1, 10);
insert into exam_management values (8, 2, 5, 1, 9);
insert into exam_management values (9, 3, 1, 1, 2);
insert into exam_management values (10, 3, 1, 2, 5);
insert into exam_management values (11, 3, 3, 1, 2.5);
insert into exam_management values (12, 3, 3, 2, 4);
insert into exam_management values (13, 4, 5, 2, 10);
insert into exam_management values (14, 5, 1, 1, 7);
insert into exam_management values (15, 5, 3, 1, 2.5);
insert into exam_management values (16, 5, 3, 2, 5);
insert into exam_management values (17, 6, 2, 1, 6);
insert into exam_management values (18, 6, 4, 1, 10);


-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
--      a. id tăng dần
select id
from student
order by id asc;
--      b. giới tính
select gender
from student
order by gender asc;
--      c. ngày sinh TĂNG DẦN và học bổng GIẢM DẦN
select birthday, scholarship
from student
order by birthday asc,scholarship desc ;
-- 2. Môn học có tên bắt đầu bằng chữ 'T'
select * from subject 
where name like "%T%";
-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
select * from student
where name like '%i';
-- 4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
select * from faculty
where name like '_n%' ;
-- 5. Sinh viên trong tên có từ 'Thị'
select * from student
where name like '%Th?%';
-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
select * from student
where name  between  'A' and  'M'
order by student.name;
-- 7. Sinh viên có học bổng lớn hơn 100000, sắp xếp theo mã khoa giảm dần
select * from student
where student.scholarship > 100000
order by student.faculty_id desc;
-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
select * from student
where student.scholarship > 100000 and student.hometown = 'Hà Nội';
-- 9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
select * from student
where student.birthday between (to_date('19910101', 'YYYYMMDD')) and (to_date('19920605', 'YYYYMMDD'));
-- 10. Những sinh viên có học bổng từ 80000 đến 150000
select * from student
where student.scholarship >= 80000 and student.scholarship <= 150000;
-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
select * from subject
where subject.lesson_quantity >= 30 and subject.lesson_quantity <= 45;

/* B. CALCULATION QUERY */

-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
		-- khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị 
		-- của học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.
select student.id, student.name, student.gender, student.faculty_id,
    (case when student.scholarship >= 500000 then 'Học bổng cao' else 'Mức trung bình' end ) from student;
-- 2. Tính tổng số sinh viên của toàn trường

select count(student.id) as sum_of_student 
from student;

-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.

select student.gender, count(student.gender) as sum_of_student
from student
group by student.gender;

-- 4. Tính tổng số sinh viên từng khoa

select faculty.name, count(student.faculty_id) as sum_of_student
from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;

-- 5. Tính tổng số sinh viên của từng môn học

select subject.name, count(distinct exam_management.student_id) as sum_of_student
from student, subject, exam_management 
where student.id = exam_management.student_id and subject.id = exam_management.subject_id
group by subject.name;

-- 6. Tính số lượng môn học mà sinh viên đã học

select count(distinct exam_management.subject_id) as sum_of_student
from exam_management;

-- 7. Tổng số học bổng của mỗi khoa

select faculty.name, sum(student.scholarship) as sum_of_scholarship from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;

-- 8. Cho biết học bổng cao nhất của mỗi khoa

select faculty.name, max(student.scholarship) as highest_of_scholarship from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;

-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
select faculty.id,
(select count(student.gender) from student where student.gender = 'Nam' and student.faculty_id = faculty.id) as number_of_male,
(select count(student.gender) from student where student.gender = 'Nữ' and student.faculty_id = faculty.id) as number_of_female 
from student, faculty
where student.faculty_id = faculty.id
group by faculty.id;

-- 10. Cho biết số lượng sinh viên theo từng độ tuổi

select age.age, count (age.age) "number_student" from (select round ((current_date - student.birthday)/365, 0) as age from student, dual) age
group by age.age;

select round ((current_date - student.birthday)/365, 0) "age" from student, dual;

-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường

select student.hometown, count( student.hometown) from student
group by student.hometown
having count( student.hometown) >= 2;

-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần

select student.id, student.name from student,
(select distinct exam_management.student_id from exam_management
    where (exam_management.number_of_exam_taking) >= 2) exam_taking_studentID
where student.id = exam_taking_studentID.student_id
order by student.id;

-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0 

select student.name from student,
(select distinct exam_management.student_id from exam_management 
    where exam_management.mark >= 7 and exam_management.number_of_exam_taking = 1) exam_mark_studentID
where student.id = exam_mark_studentID.student_id and  student.gender = 'Nam'
order by student.id;

-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)

select student_id.student_id, count(student_id.student_id) as number_subject
from (select exam_management.student_id as student_id from exam_management
where number_of_exam_taking = 1 and mark <= 4) student_id
group by student_id, student_id.student_id
having count(student_id.student_id) >= 2;

-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam

select faculty.name, count (student.gender) from faculty, student
where student.faculty_id = faculty.id and student.gender = 'Nam'
group by faculty.name
having count (student.gender) >= 2;

-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000

select faculty.name, count (student.scholarship) as num_student from faculty, student
where student.faculty_id = faculty.id and student.scholarship >= 200000 and student.scholarship <= 300000
group by faculty.name
having count (student.scholarship) >= 2;

-- 17. Cho biết sinh viên nào có học bổng cao nhất

select student.name from student
where student.scholarship = (select max(student.scholarship) from student);

/* C. DATE/TIME QUERY */

-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02

select student.name, student.hometown, student.birthday from student
where student.hometown = 'Hà Nội' and to_char(birthday, 'MM') = '02'; 

select to_char(birthday) from student;
select to_char(birthday, 'MM') from student;
select to_char(birthday, 'DD-MM-YYYY') from student; 
select to_char(birthday, 'Q-YY') from student;  

-- 2. Sinh viên có tuổi lớn hơn 20

select student.name as name, round ((current_date - student.birthday)/365, 0) as age from student, dual
where round ((current_date - student.birthday)/365, 0) >= 20;

-- 3. Sinh viên sinh vào mùa xuân năm 1990

select student.name from student
where student.birthday between to_date('19900101', 'YYYYMMDD') and to_date('19900331', 'YYYYMMDD');

/* D. JOIN QUERY */

-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ

select * from student
join faculty on student.faculty_id = faculty.id
where student.faculty_id = 1 or student.faculty_id = 4;

-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN HỌC

select * from student
join faculty on student.faculty_id = faculty.id
where (student.faculty_id = 1 or student.faculty_id = 2) and student.gender = 'Nam';

-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất

select studentid STUDENTID,
mark MARK,
number_of_exam_taking NUMBER_OF_EXAM_TAKING from student
join (select exam_management.student_id as studentID, exam_management.mark, exam_management.number_of_exam_taking  from exam_management
        where exam_management.subject_id = 1 
        and exam_management.mark = (select max(exam_management.mark) from exam_management where subject_id = 1)) maxMarkTable
on student.id = maxMarkTable.studentID;

select max(exam_management.mark) from exam_management
where subject_id = 1 ;

-- 4. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
select * from student s
join (select student.id as student_id from  student
        where student.faculty_id = 1 
        and round ((current_date - student.birthday), 0) = (select max(age.age_student) 
                                                                from (select round ((current_date - temp_sv.birthday), 0) as age_student 
                                                                        from (select * from student
                                                                                where student.faculty_id = 1) temp_sv) age )) temp
on temp.student_id = s.id
join faculty f
on f.id = s.faculty_id;
select round ((current_date - student.birthday)/365, 0) from student;
select max(age.age_student) from (select round ((current_date - student.birthday)/365, 0) as age_student from student) age ;

-- 5. Cho biết khoa nào có đông sinh viên nhất

select * from (select * from faculty f
join (select student.faculty_id as faculty_id, count(student.faculty_id) as number_student from student group by faculty_id, student.faculty_id) a
on f.id = a.faculty_id
order by a.number_student desc)
where number_student = (select max(number_student)from (select * from faculty f
join (select student.faculty_id as faculty_id, count(student.faculty_id) as number_student from student group by faculty_id, student.faculty_id) a
on f.id = a.faculty_id
order by a.number_student desc));



-- 6. Cho biết khoa nào có đông nữ nhất

select * from (select * from faculty f
join (select student.faculty_id as faculty_id, count(student.faculty_id) as number_student from student where student.gender = 'Nữ' group by faculty_id, student.faculty_id) a
on f.id = a.faculty_id)
where number_student = (select max(number_student)from (select * from faculty f
join (select student.faculty_id as faculty_id, count(student.faculty_id) as number_student from student where student.gender = 'Nữ' group by faculty_id, student.faculty_id) a
on f.id = a.faculty_id));



-- 7. Cho biết những sinh viên đạt điểm cao nhất trong từng môn

select * from student s
join (select e.student_id as student_id , e.subject_id as subject_id, e.mark as mark from exam_management e
                                            join (select subject_id , max(mark) as mark from exam_management
                                                    group by subject_id) a
                                            on e.subject_id = a.subject_id and e.mark = a.mark) f1
on f1.subject_id = s.id
where f1.student_id  is not null;

-- 8. Cho biết những khoa không có sinh viên học

insert into faculty values (5, 'test');
delete from faculty where id = 5;
select f.id, f.name from faculty f
left join student s
on f.id = s.faculty_id 
where s.faculty_id is null;

-- 9. Cho biết sinh viên chưa thi môn cơ sở dữ liệu

select * from student s
left join (select s.id as id from student s
            right join exam_management e
            on s.id = e.student_id
            where e.subject_id = 1)temp
on s.id = temp.id
where temp.id is null
order by s.id;


-- 10. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2
