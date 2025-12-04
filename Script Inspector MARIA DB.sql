# Insert into UI_USER_TYPES the Inspector Profile
INSERT INTO UI_USER_TYPES (TITLE, HIDDEN, ACTIVE)
VALUES ('Inspector', 0, 1);

# Get the USER_TYPE_ID of Inspector
SET @ui_user_types_new_id := LAST_INSERT_ID();

# Insert into UI_USERS
SET @name := (
    SELECT SUBSTRING_INDEX(USER_NAME, '@', -1)
	FROM UI_USERS
	WHERE USER_NAME LIKE 'quatuor@%'
);

INSERT INTO UI_USERS (
    USER_NAME, 
    PASSWORD, 
    ACTIVE, 
    FULL_NAME, 
    INITIALS, 
    ID_USER_TYPE, 
    LANGUAGE, 
    PASSWORD_RESET
)
VALUES (
    CONCAT('inspector@', @name),
    '12345',
    1,
    CONCAT(
        'Inspector ',
        UPPER(LEFT(@name, 1)),
        SUBSTRING(@name, 2)
    ),
    CONCAT(
        'I',
        UPPER(LEFT(@name, 1))
    ),
    @ui_user_types_new_id,
    'ES',
    0
);

# Insert into MASTER_USER
INSERT INTO TMSSTUDIO_MASTER.MASTER_USER (MASTER_USER_NAME, ID_MASTER_EMPRESA)
VALUES (
    CONCAT('inspector@', @name),
    (
        SELECT ID_MASTER_EMPRESA
        FROM (
            SELECT ID_MASTER_EMPRESA
            FROM TMSSTUDIO_MASTER.MASTER_USER
            WHERE SUBSTRING_INDEX(MASTER_USER_NAME, '@', -1) = @name
            LIMIT 1
        ) AS x
    )
);

# Replace the ID_PERFIL_INSPECTOR with the USER_TYPE_ID of Inspector
UPDATE EMPRESA_DATA
SET ID_PERFIL_INSPECTOR = @ui_user_types_new_id
WHERE ID_EMPRESA_DATA = 1;
