
DROP DATABASE IF EXISTS youtube;
CREATE DATABASE youtube CHARACTER SET utf8mb4;

USE youtube;

CREATE TABLE users (
    id_user BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(25) UNIQUE NOT NULL,
    user_password VARCHAR(30) NOT NULL,
    birthdate DATE DEFAULT NULL,
    sex ENUM('M', 'F'),
    country_residence ENUM('ES', 'F', 'IT', 'D', 'P', 'PO', 'DK', 'NO', 'B', 'UK', 'FI', 'S', 'CH') NOT NULL,
    postalcode VARCHAR(12) DEFAULT NULL,
    user_signedup DATETIME, NOT NULL DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE videos (
    id_video BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    video_title VARCHAR(60) NOT NULL,
    video_description VARCHAR(150) NOT NULL,
    video_size SMALLINT UNSIGNED NOT NULL,
    video_file VARCHAR(60) NOT NULL,
    video_length TIME NOT NULL,
    video_face_img_file VARCHAR(60) NOT NULL,
    video_privacy ENUM('public', 'private', 'hidden') NOT NULL DEFAULT 'public',
    video_labels SET(labels.id_label) DEFAULT NULL,
    video_published DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_user INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE labels (
    id_label BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    label_name VARCHAR(24) UNIQUE NOT NULL
);

CREATE TABLE playlists (
    PRIMARY KEY (id_playlist, id_user),
    id_playlist BIGINT UNSIGNED AUTO_INCREMENT,
    id_user BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE RESTRICT ON UPDATE CASCADE,
    playlist_name VARCHAR(60) UNIQUE NOT NULL,
    playlist_created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE userplaylistscontents (
    id_playlist BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_playlist) REFERENCES playlists(id_playlist) ON DELETE RESTRICT ON UPDATE CASCADE,
    id_video BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_video) REFERENCES videos(id_video) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE user_subscribes_playlist (
    id_playlist BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_playlist) REFERENCES playlists(id_playlist) ON DELETE CASCADE ON UPDATE CASCADE,
    id_user BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
)

