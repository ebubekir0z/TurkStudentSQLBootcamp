![Online_edu_dbtable](https://github.com/user-attachments/assets/0ab0e9c0-438e-4db4-965c-8feab74769dc)

"""
# Final Proje - Eğitim Platformu Veritabanı Tasarımı

Yukarıda **TurkStudentCommunity** tarafından verilen eğitim sonunda gerçekleştirdiğim final projenin veritabanı ilişki diyagramı (ERD) bulunmaktadır.

## Proje Hakkında

Proje kapsamında bir online eğitim platformu için veritabanı şeması (ERD) tasarlanmıştır.

Bu veritabanı tasarımı, bir eğitim platformunda temel işlevleri desteklemek amacıyla oluşturulmuştur:

- Kategori bazlı kurs yönetimi
- Üye kaydı ve giriş işlemleri
- Kullanıcı rolleri ve yetkilendirme
- Kurslara kayıt olma ve ilerleme takibi
- Kurslar hakkında yorum yapma ve değerlendirme
- Sertifika atama ve yönetimi
- Bildirim sistemi
- Blog yazıları ve yorumları

## Veritabanı Tabloları

- `categories`: Kurs kategorilerini içerir.
- `courses`: Kurs bilgilerini tutar.
- `members`: Platforma kayıtlı kullanıcı bilgilerini tutar.
- `roles`: Kullanıcı rollerini belirtir (Öğrenci, Eğitmen vb.).
- `user_roles`: Kullanıcı ve rol ilişkisini tanımlar.
- `enrollments`: Kullanıcıların kurs kayıtlarını tutar.
- `course_reviews`: Kullanıcıların kurslara yaptığı yorum ve puanlamaları tutar.
- `course_statistics`: Kursların başarı oranlarını ve güncellemelerini takip eder.
- `certificates`: Verilen sertifikaları tutar.
- `certificate_assignments`: Sertifika atamalarını yönetir.
- `notifications`: Kullanıcılara gönderilen bildirimleri tutar.
- `logs`: Kullanıcı işlemlerinin kayıtlarını tutar.
- `blogposts`: Platformda yayımlanan blog yazılarını tutar.
- `comment_sys`: Blog yazılarına yapılan yorumları tutar.

## Kullanılan Teknolojiler

- **PostgreSQL**
- **pgAdmin** (Veritabanı yönetimi ve şema oluşturma için)
