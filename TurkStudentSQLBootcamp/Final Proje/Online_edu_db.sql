

create table members (
	id bigint primary key generated always as identity, 
	username varchar(50) unique not null,
	email varchar(100) unique not null check(email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
	passwords varchar(255) not null,
	register_date timestamp default current_timestamp,
	first_name varchar(50), 
	last_name varchar(50),

	is_active boolean default TRUE

	
);

create table categories (
	id integer primary key generated always as identity,
	category_name varchar(150) unique not null,
	description text
	
);

create table courses (
	id bigint primary key generated always as identity,
	title varchar(200) not null,
	description text,
	start_date timestamp with time zone not null,
	-- Farklı zaman dilimlerinde eğitimler varsa, 
	-- TIMESTAMP WITH TIME ZONE kullanarak zaman dilimi bilgisini de saklayabilirsin.
	end_date timestamp  with time zone not null,
	check(start_date < end_date),
	instruction_name varchar(100),
	category_id integer,
	
	constraint fk_category foreign key (category_id) references categories(id)
);


create table enrollments (
	id bigint primary key generated always as identity,
	member_id bigint not null,
	course_id bigint not null,
	enrollment_date timestamp default current_timestamp,

	constraint fk_member foreign key (member_id) references members(id),
	constraint fk_course foreign key (course_id) references courses(id),
	constraint uq_member_course unique (member_id, course_id) -- Aynı kullanıcı aynı eğitime bir kez katılabilir
	
);

create table certificates (
	id bigint primary key generated always as identity,
	certificate_code varchar(100) unique not null,
	issue_date date not null default current_date,
	description text
);

create table CertAssignments (
	id bigint primary key generated always as identity,
	enrollment_id bigint not null,
	certificated_id bigint not null,
	assigned_date date not null default current_date,

	constraint fk_cert_assignment_enrollment foreign key (enrollment_id) references enrollments(id),
	constraint fk_cert_assignment_certificate foreign key (certificated_id) references certificates(id),
	-- Aynı katılım (enrollment) için aynı sertifika bir daha atanamaz
	constraint uq_enrollment_certificate unique (enrollment_id, certificated_id)
);

create table blogposts (
	id bigint primary key generated always as identity,
	title varchar(255) not null,
	contents text not null,
	published_at timestamp default current_timestamp,
	author_id bigint not null,

	constraint fk_blogpost_author foreign key (author_id) references members(id)
	
);

create table comment_sys(
	id bigint primary key generated always as identity,
	content text not null,
	created_at timestamp default current_timestamp,
	post_id bigint not null,
	user_id bigint not null,

	constraint fk_comment_post foreign key (post_id) references blogposts(id),
	constraint fk_comment_user foreign key (user_id) references members(id)
	
);

create table course_reviews (
	id bigint primary key generated always as identity,
	course_id bigint not null,
	enrollment_id bigint not null,
	rating int not null check(rating between 1 and 5),
	comment text,
	created_at timestamp default current_timestamp,

	
	constraint fk_course_review foreign key (course_id) references courses(id),
	constraint fk_course_enroll foreign key (enrollment_id) references enrollments(id),
	constraint uq_enrollmet_review unique(enrollment_id)
);

create table notifications (
	id bigint primary key generated always as identity,
	user_id bigint not null,
	message text not null,
	is_read boolean default FALSE,
	created_at timestamp default current_timestamp,

	constraint fk_notification_user foreign key (user_id) references members(id)
);

create table course_statistics (
	id bigint primary key generated always as identity,
	course_id bigint not null,
	total_enrolled int not null, -- Eğitime kayıtlı toplam kullanıcı
	--total_completed int not null, -- Eğitimi tamamlayan kullanıcı sayısı
	success_rate decimal(5,2),		-- Başarı oranı (yüzde)
	last_updated timestamp default current_timestamp,

	constraint fk_course_stat foreign key (course_id) references courses(id)
);

create table roles(
	id bigint primary key generated always as identity,
	role_name varchar(15) unique not null

	
);

create table user_roles (
	id bigint primary key generated always as identity,
	user_id bigint not null,
	role_id bigint not null,
	assigned_at timestamp default current_timestamp,	-- Rol atama tarihi

	constraint fk_roles_user foreign key (user_id) references members(id),
	constraint fk_role foreign key (role_id) references roles(id)
);


--Eklenen veriler

-- Örnek üyeler

INSERT INTO members (username, email, passwords, first_name, last_name, is_active) 
VALUES 
('john_doe', 'john.doe@example.com', 'hashed_password_1', 'John', 'Doe', TRUE),
('jane_smith', 'jane.smith@example.com', 'hashed_password_2', 'Jane', 'Smith', TRUE),
('alice_jones', 'alice.jones@example.com', 'hashed_password_3', 'Alice', 'Jones', FALSE);
select * from members;

insert into members (username, email, passwords, first_name, last_name, is_active)
values
('michael_brown', 'michael.brown@example.com', 'hashed_password_4', 'Michael', 'Brown', TRUE),
('emily_white', 'emily.white@example.com', 'hashed_password_5', 'Emily', 'White', TRUE),
('david_clark', 'david.clark@example.com', 'hashed_password_6', 'David', 'Clark', FALSE),
('sophia_miller', 'sophia.miller@example.com', 'hashed_password_7', 'Sophia', 'Miller', TRUE),
('liam_wilson', 'liam.wilson@example.com', 'hashed_password_8', 'Liam', 'Wilson', FALSE);



-- Örnek kategoriler
INSERT INTO categories (category_name, description)
VALUES 
('Mathematics', 'Mathematics courses including algebra, calculus, and more.'),
('Computer Science', 'Courses related to programming, software development, and algorithms.'),
('Psychology', 'Courses focused on the study of the human mind and behavior.');

select * from categories;
-- Örnek kurslar
INSERT INTO courses (title, description, start_date, end_date, instruction_name, category_id)
VALUES 
('Introduction to Algebra', 'A beginner course in algebra.', '2025-05-01 10:00:00+00', '2025-05-30 16:00:00+00', 'Dr. John Doe', 1),
('Advanced Programming', 'Learn advanced programming concepts and techniques.', '2025-06-01 09:00:00+00', '2025-06-30 18:00:00+00', 'Dr. Jane Smith', 2),
('Introduction to Psychology', 'An overview of psychology principles and theories.', '2025-07-01 10:00:00+00', '2025-07-31 14:00:00+00', 'Dr. Alice Johnson', 3);

select * from courses;

-- Örnek kayıtlar
INSERT INTO enrollments (member_id, course_id, enrollment_date)
VALUES 
(1, 1, '2025-04-25 10:00:00'),
(2, 2, '2025-04-26 11:00:00'),
(1, 3, '2025-04-25 12:00:00');
select * from enrollments;

-- Örnek sertifikalar
INSERT INTO certificates (certificate_code, issue_date, description)
VALUES 
('CERT001', '2025-05-15', 'Certificate for completing Introduction to Algebra.'),
('CERT002', '2025-06-15', 'Certificate for completing Advanced Programming.');
select * from certificates;

-- Örnek sertifika atamaları
INSERT INTO CertAssignments (enrollment_id, certificated_id, assigned_date)
VALUES 
(1, 1, '2025-05-16'),
(2, 2, '2025-06-16');
select * from CertAssignments;

-- Örnek blog yazıları
INSERT INTO blogposts (title, contents, author_id)
VALUES 
('Understanding Algebra', 'This post discusses key concepts of Algebra for beginners.', 1),
('Top Programming Tips', 'This blog highlights some important programming tips and tricks.', 2);
select * from blogposts;

-- Örnek yorumlar
INSERT INTO comment_sys (content, post_id, user_id)
VALUES 
('Great post! Very helpful.', 1, 2),
('I learned a lot from this article.', 2, 3);
select * from comment_sys;

-- Örnek kurs değerlendirmeleri
INSERT INTO course_reviews (course_id, enrollment_id, rating, comment)
VALUES 
(1, 1, 5, 'Excellent course! Learned a lot about algebra.'),
(2, 2, 4, 'Good course but could use more examples.');
select * from course_reviews;

-- Örnek bildirimler
INSERT INTO notifications (user_id, message)
VALUES 
(1, 'You successfully enrolled in Introduction to Algebra.'),
(2, 'You successfully enrolled in Advanced Programming.');
select * from notifications;

-- Örnek kurs istatistikleri
INSERT INTO course_statistics (course_id, total_enrolled, success_rate)
VALUES 
(1, 1, 100.00),
(2, 1, 80.00);
select * from course_statistics;

-- Örnek roller
INSERT INTO roles (role_name)
VALUES 
('Admin'),
('Instructor'),
('Student');
select * from roles;

-- Örnek kullanıcı rolleri
INSERT INTO user_roles (user_id, role_id)
VALUES 
(1, 1),  -- John Doe için Admin rolü
(2, 2);  -- Jane Smith için Instructor rolü
select * from user_roles;

-- Örnek loglar
INSERT INTO logs (user_id, log_message)
VALUES 
(1, 'Admin role assigned.'),
(2, 'Instructor role assigned.');
select * from logs;








--Trigger functions
	
	
	--course_statistics güncellemesi
/*
create or replace function update_total_enrolled()
returns trigger as $$
begin
update	course_statistics
	set total_enrolled = coalesce(total_enrolled, 0) + 1,--Böylece NULL + 1 gibi bir saçmalık çıkmıyor.
		last_update= now()
	where course_id = NEW.course_id;
	
/*	set total_enrolled = total_enrolled +1,
		last_update = now()
		where course_id = NEW.course_id;
*/


  -- Eğer hiçbir satır güncellenmediyse (böyle bir course_id yoksa), hata verelim
	if not found then --Bazı SQL komutları (örneğin SELECT, UPDATE, DELETE) çalıştıktan sonra son işlem bir satırı etkiledi mi? sorusuna cevap verir.
		raise exception 'Bu % course_id bulunamadı.', NEW.course_id;
		end if;
		return new;
end;
$$ language plpgsql;

create trigger enroll_update_statistics
after insert on enrollments
for each row
execute function update_total_enrolled();
*/
create or replace function update_total_enrolled()
returns trigger as $$
begin
	if TG_OP = 'INSERT' then
		--Kayıt eklendiğinde
		update course_statistics
		set total_enrolled = coalesce(total_enrolled, 0) + 1,
			last_updated = now()
			where course_id = new.course_id;
			
        -- Eğer hiç satır güncellenmediyse, bu course_id mevcut değil demektir
		/*	if not found then
				raise exception 'Bu course_id (%) bulunamadı.', NEW.course_id;
			end if;
		*/

			return new;
			
	elsif TG_OP = 'DELETE' then
		--Kayıt silindiğinde
		update course_statistics
		set total_enrolled = GREATEST(coalesce(total_enrolled, 0) - 1, 0),
			last_updated = now()
		where course_id = old.course_id;

		if not found then
			raise exception 'Bu course_id (%), kurs bulunamadı.', OLD.course_id;
		end if;

		return old;
	end if;


	return null;	-- başka bir işlem olursa NULL döneriz
end;
$$ language plpgsql;

create trigger enroll_update_statistics_insert
after insert on enrollments
for each row
execute function update_total_enrolled();

create trigger enroll_update_statistics_delete
after delete on enrollments
for each row
execute function update_total_enrolled();




	--course_reviews sonrası başarı oranı (success_rate) güncellemesi

create or replace function update_success_rate()
returns trigger as $$
declare
	/*değişken oluşturmak
		DECLARE
    		değişken_ismi veri_tipi [DEFAULT başlangıç_değeri];
	*/
	completed_count int default 0; --belli puan üstü veren kullanıcıları
	total_count int default 0; --tüm kullanıcıları
begin
	
	select count(*) into completed_count from course_reviews
	where course_id = new.course_id and rating >= 3;
		--3 ve üstü basarılı olarak kabul edilmiştir 
	
	select count(*) into total_count from enrollments
	where course_id = new.course_id;

	update course_statistics
	set success_rate = case
							 --"Eğer şöyleyse, şunu yap; değilse, bunu yap" mantığı kuruyor.
							when total_count > 0 then
								round((completed_count::decimal / total_count)*100, 2)
							else 0
						
						end,
		last_updated = now()
	where course_id = new.course_id;

	return new;
end;
$$ language plpgsql;

create trigger review_update_statistics
after insert or update on course_reviews
for each row
execute function update_success_rate();
	
		
	
	--notifications sisteminde otomatik bildirim
/*
($$) PostgreSQL'de bir şeyin 
başlangıcını ve bitişini 
belirtmek için kullanılıyor.
*/
create or replace function enrollment_notification()
returns trigger as $$ 

begin

	if TG_OP = 'INSERT' then
		insert into notifications(user_id, message, created_at)
		values (new.member_id, 'Basariyla kursa kayit oldunuz!',now());
	
	elsif TG_OP = 'DELETE' THEN
		delete from notifications
		where user_id = old.user_id and message = 'Basariyla kursa kayit oldunuz!';
	
	end if;
	
	return null;
	/*
		Burada trigger AFTER INSERT veya DELETE için çalışıyor.
		Yani aslında zaten kayıt eklenmiş veya silinmiş.
		Bu yüzden NEW veya OLD döndürmene gerek yok.
	*/

end;
$$ language plpgsql;


create trigger notify_on_enroll
after insert or delete on enrollments
for each row
execute function enrollment_notification();


	--certificates → Sertifika atanınca bildirim gönder

create or replace function certificate_assigned_notification()
returns trigger as $$
begin
	insert into notifications (user_id, message, created_at)
	values((select member_id from enrollments where id = NEW.enrollment_id), 'Tebrikler, sertifikanız başarıyla atandı!', now());

	return new;
end;
$$ language plpgsql;

create trigger certificate_assigned_notify
after insert on CertAssignments
for each row
execute function certificate_assigned_notification();


	--user_roles → Admin atanınca özel işlem

create table logs (
	id bigint primary key generated always as identity,
	user_id bigint not null,
	log_message text,
	created_at timestamp default current_timestamp
);

create or replace function admin_role_assigned_notification()
returns trigger as $$
declare
	message_text text;
begin
	-- Kullanıcıya Admin rolü atandığında bildirim ekle
	if TG_OP = 'INSERT' THEN
		if new.role_id = (select id from roles where role_name = 'Admin') then
			message_text := 'Tebrikler, Admin rolü başarıyla atandı!';

		
			insert into notifications (user_id, message, created_at)
			values(new.user_id, message_text, now());
		
		 -- Admin rolü atanan kullanıcı için bir log kaydı oluştur
		 insert into logs(user_id, log_message, created_at)
		 values(new.user_id, 'Admin rolü atandı.', now());
		end if;
		
	
	elsif TG_OP = 'UPDATE' THEN
 	-- Admin rolü kaldırıldıysa


		if old.role_id is distinct from new.role_id then
			-- Eğer eski rol Admin değilken yeni rol Admin olmuşsa
			if new.role_id = (select id from roles where role_name = 'Admin') then
				message_text := 'Tebrikler, Admin rolü başarıyla atandı!';
	
				
				insert into notifications (user_id, message, created_at)
				VALUES (OLD.user_id, message_text, now());
	        
				-- Admin rolü kaldırılan kullanıcı için log kaydı oluştur
				insert into logs(user_id, log_message, created_at)
				values (new.user_id, 'Admin rolü atandı.', now());
				
				-- Eğer eski rol Admin iken yeni rol başka bir şey olmuşsa
				if old.role_id = (select id from roles where role_name = 'Admin') then
					message_text := 'Admin rolü kaldırıldı.';
					
					insert into notifications(user_id, message, created_at)
					values(old.user_id, message_text, now());
	
					insert into logs(user_id, log_message, created_at)
					values (old.user_id, 'Admin rolü kaldırıldı.', now());
				end if;
			end if;
		end if;
	end if;
	
	return new;

end;
$$ language plpgsql;

	 
create trigger admin_role_notify
after insert or update on user_roles
for each row
execute function admin_role_assigned_notification();

/*
ALTER TABLE tablo_adi
ADD CONSTRAINT fk_adi
FOREIGN KEY (alan_adi) REFERENCES diger_tablo(diger_alan);
*/
alter table logs 
add constraint fk_log_user foreign key (user_id) references members(id);



/*
DELETE FROM categories;

TRUNCATE categories RESTART IDENTITY CASCADE;
TRUNCATE categories RESTART IDENTITY;
TRUNCATE CertAssignments RESTART IDENTITY;
TRUNCATE enrollments RESTART IDENTITY CASCADE;
*/