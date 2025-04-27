select * from invoice;
select * from track;
select * from playlist;
select * from playlisttrack;
/*1.soru*/
select sum(total) as new_total from invoice 
where billing_country ='USA' and extract(year from invoice_date ) = 2009;

/*2.soru*/

select
	t.track_id, 
    t.name AS track_name, 
    t.album_id, 
    t.mediatype_id, 
    t.genre_id, 
    t.composer, 
    t.milliseconds, 
    t.bytes, 
    t.unitprice, 
    pt.playlist_id, 
    p.name AS playlist_name
from track t
join playlisttrack pt on t.track_id = pt.track_id
join playlist p on pt.playlist_id = p.playlist_id;


select
	t.track_id, 
    t.name AS track_name, 
    t.album_id, 
    t.mediatype_id, 
    t.genre_id, 
    t.composer, 
    t.milliseconds, 
    t.bytes, 
    t.unitprice, 
    pt.playlist_id, 
    p.name AS playlist_name
from track t
left join playlisttrack pt on t.track_id = pt.track_id
left join playlist p on pt.playlist_id = p.playlist_id;
--soldaki tablodaki tüm satırları alır sağdaki tablodan sadece eşleşen satırları alır

/*
SELECT 
    (SELECT STRING_AGG(column_name, ', ') 
     FROM information_schema.columns 
     WHERE table_name = 'track'
    ) AS column_names,
    /*
    information_schema.columns seçilen tabloda sutun bilgileri getirir.
    STRING_AGG(column_name, ', ') fonksiyonu verilen tablodaki sutunların  
    değerlerini birleştirip aralarına ayreaç koyar
    */
  	
    t.track_id, 
    t.name AS track_name, 
    t.album_id, 
    t.mediatype_id, 
    t.genre_id, 
    t.composer, 
    t.milliseconds, 
    t.bytes, 
    t.unitprice, 
    pt.playlist_id, 
    p.name AS playlist_name
FROM track t
JOIN playlisttrack pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;

YARDIM ALARAK BU SORGUYU OLUSTURDUM.
*/

select
	t.track_id, 
    t.name AS track_name, 
    t.album_id, 
    t.mediatype_id, 
    t.genre_id, 
    t.composer, 
    t.milliseconds, 
    t.bytes, 
    t.unitprice, 
    pt.playlist_id, 
    p.name AS playlist_name
from track t
join playlisttrack pt on t.track_id = pt.track_id
join playlist p on pt.playlist_id = p.playlist_id;
/*join 'inner join' in kısa halidir. tabloları kullanak sadece eşlesen satırları seçer*/


/*3.soru*/

select * from track;
select * from album;
select * from artist;

select t.*, (
				select ar.name from artist ar 
				where ar.artist_id = 
				( 
					select al.artist_id from album al where al.album_id = t.album_id 
				)   
			) as artist_information
from track t 
where 
	t.album_id = (
		select album_id from album where title='Let There Be Rock' 
	)
order by t.milliseconds desc;


select t.*, (
				select ar.name from artist ar 
				where ar.artist_id =
								(
									select al.artist_id from album al
									where al.album_id = t.album_id
								)
			) as album_informations
from track t
where t.album_id in (
						select album_id from album
						where title='Let There Be Rock'
					) order by t.milliseconds desc;
