USE youtube;

-- 1- Retornar un listado con los títulos de TODOS los vídeos en el sistema indicando su título, nombre y apellido del usuario que lo subió y los totales de likes, dislikes. Ordenar por LIKES DESC.

SUBQUERY 1 :
SELECT vp.id_video, SUM(vp.user_likes IN ('like')) AS 'likes', SUM(vp.user_likes IN ('dislike')) AS 'dislikes', COUNT(vp.user_comments_video) AS 'comments' FROM videos_performance vp GROUP BY vp.id_video;

SUBQUERY 2 :
SELECT  v.video_title, v.id_user_uploads, subquery1.likes, subquery1.dislikes, subquery1.comments FROM videos v JOIN (SELECT vp.id_video, SUM(vp.user_likes IN ('like')) AS 'likes', SUM(vp.user_likes IN ('dislike')) AS 'dislikes', COUNT(vp.user_comments_video) AS 'comments' FROM videos_performance vp GROUP BY vp.id_video) AS subquery1 ON v.id_video = subquery1.id_video GROUP BY v.id_video;

QUERY FINAL :
SELECT u.username, subquery2.video_title, subquery2.likes, subquery2.dislikes, subquery2.comments FROM users u JOIN (SELECT  v.video_title, v.id_user_uploads AS 'useruploads', subquery1.likes, subquery1.dislikes, subquery1.comments FROM videos v JOIN (SELECT vp.id_video, SUM(vp.user_likes IN ('like')) AS 'likes', SUM(vp.user_likes IN ('dislike')) AS 'dislikes', COUNT(vp.user_comments_video) AS 'comments' FROM videos_performance vp GROUP BY vp.id_video) AS subquery1 ON v.id_video = subquery1.id_video GROUP BY v.id_video) AS subquery2 ON u.id_user = subquery2.useruploads GROUP BY u.username ORDER BY subquery2.likes DESC;

-- 2- Retornar un listado con el total de comentarios que cada usuario ha hecho a videos de otros usuarios y los likes/dislikes que sus comentarios han recibido. Ordenar por total de comentarios hechos DESC.

SUBQUERY :
SELECT vp.id_user_interacts, COUNT(vp.user_comments_video) AS 'total_comentarios', SUM(cp.user_rates_comment IN('like')) AS 'likes_recibidos', SUM(cp.user_rates_comment IN('dislike')) AS 'dislikes_recibidos' FROM videos_performance vp JOIN comments_performance cp ON vp.user_comments_video = cp.user_comments_video GROUP BY vp.id_user_interacts ORDER BY total_comentarios DESC;

QUERY FINAL :
SELECT u.username, subquery.total_comentarios, subquery.likes_recibidos, subquery.dislikes_recibidos FROM users u JOIN (SELECT vp.id_user_interacts, COUNT(vp.user_comments_video) AS 'total_comentarios', SUM(cp.user_rates_comment IN('like')) AS 'likes_recibidos', SUM(cp.user_rates_comment IN('dislike')) AS 'dislikes_recibidos' FROM videos_performance vp JOIN comments_performance cp ON vp.user_comments_video = cp.user_comments_video GROUP BY vp.id_user_interacts ORDER BY total_comentarios DESC) AS subquery ON u.id_user = subquery.id_user_interacts GROUP BY u.id_user ORDER BY subquery.total_comentarios DESC;

-- 3- Generar un listado con los usuarios que han creado canales, la descripción de su canal y el numero de suscriptores. Ordenar por número de suscriptores DESC.

SUBQUERY :
SELECT ch.id_user_creates_channel, ch.channel_description, COUNT(subs.id_user_subscribes) AS 'total_users_subscribed' FROM channels ch JOIN user_subscribes_channel subs ON ch.id_channel = subs.id_channel GROUP BY ch.id_user_creates_channel;

QUERY FINAL :
SELECT u.username, subquery.channel_description, subquery.total_users_subscribed FROM users u JOIN (SELECT ch.id_user_creates_channel, ch.channel_description, COUNT(subs.id_user_subscribes) AS 'total_users_subscribed' FROM channels ch JOIN user_subscribes_channel subs ON ch.id_channel = subs.id_channel GROUP BY ch.id_user_creates_channel) AS subquery ON u.id_user = subquery.id_user_creates_channel GROUP BY u.username ORDER BY subquery.total_users_subscribed DESC;

-- 4- Para todos los usuarios indicar a que playlists están suscritos, a qué usuario pertenece cada playlist y cuantos vídeos existen en cada una de ellas.

SUBQUERY 1 :
SELECT p.id_playlist, p.playlist_name, p.id_user_creates_playlist AS 'id_playlist_owner', COUNT(upc.id_video) AS 'total_videos_in_playlist' FROM playlists p JOIN userplaylistscontents upc ON p.id_playlist = upc.id_playlist GROUP BY p.id_playlist;

SUBQUERY 2 :
SELECT u.username AS 'playlist_owner', subquery1.id_playlist, subquery1.playlist_name, subquery1.total_videos_in_playlist FROM users u JOIN (SELECT p.id_playlist, p.playlist_name, p.id_user_creates_playlist AS 'id_playlist_owner', COUNT(upc.id_video) AS 'total_videos_in_playlist' FROM playlists p JOIN userplaylistscontents upc ON p.id_playlist = upc.id_playlist GROUP BY p.id_playlist) AS subquery1 ON u.id_user = subquery1.id_playlist_owner GROUP BY id_playlist;

SUBQUERY 3 :
SELECT usp.id_user_subscribes, subquery2.playlist_owner, subquery2.playlist_name, subquery2.total_videos_in_playlist FROM user_subscribes_playlist usp JOIN (SELECT u.username AS 'playlist_owner', subquery1.id_playlist, subquery1.playlist_name, subquery1.total_videos_in_playlist FROM users u JOIN (SELECT p.id_playlist, p.playlist_name, p.id_user_creates_playlist AS 'id_playlist_owner', COUNT(upc.id_video) AS 'total_videos_in_playlist' FROM playlists p JOIN userplaylistscontents upc ON p.id_playlist = upc.id_playlist GROUP BY p.id_playlist) AS subquery1 ON u.id_user = subquery1.id_playlist_owner GROUP BY id_playlist) AS subquery2 ON usp.id_playlist = subquery2.id_playlist GROUP BY usp.id_user_subscribes;

QUERY FINAL :
SELECT u.username AS 'users_subscribed_to_playlists', subquery3.playlist_owner, subquery3.playlist_name, subquery3.total_videos_in_playlist FROM users u JOIN (SELECT usp.id_user_subscribes, subquery2.playlist_owner, subquery2.playlist_name, subquery2.total_videos_in_playlist FROM user_subscribes_playlist usp JOIN (SELECT u.username AS 'playlist_owner', subquery1.id_playlist, subquery1.playlist_name, subquery1.total_videos_in_playlist FROM users u JOIN (SELECT p.id_playlist, p.playlist_name, p.id_user_creates_playlist AS 'id_playlist_owner', COUNT(upc.id_video) AS 'total_videos_in_playlist' FROM playlists p JOIN userplaylistscontents upc ON p.id_playlist = upc.id_playlist GROUP BY p.id_playlist) AS subquery1 ON u.id_user = subquery1.id_playlist_owner GROUP BY id_playlist) AS subquery2 ON usp.id_playlist = subquery2.id_playlist GROUP BY usp.id_user_subscribes) AS subquery3 ON u.id_user = subquery3.id_user_subscribes GROUP BY u.username ORDER BY u.username;

