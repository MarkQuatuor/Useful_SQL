---------------------------------------------------------
-- Insert into UI_USER_TYPES the Inspector Profile
---------------------------------------------------------
INSERT INTO [TMS_NAME].[dbo].[UI_USER_TYPES] (TITLE)
VALUES ('Inspector');

-- Get the USER_TYPE_ID of Inspector
DECLARE @ui_user_types_new_id INT = SCOPE_IDENTITY();

---------------------------------------------------------
-- Get the value after '@' for users starting with quatuor@
---------------------------------------------------------
DECLARE @name NVARCHAR(255);

SELECT TOP 1 
    @name = SUBSTRING(USER_NAME, CHARINDEX('@', USER_NAME) + 1, LEN(USER_NAME))
FROM [TMS_NAME].[dbo].[UI_USERS]
WHERE USER_NAME LIKE 'quatuor@%';

---------------------------------------------------------
-- Insert into UI_USERS
---------------------------------------------------------
INSERT INTO [TMS_NAME].[dbo].[UI_USERS] (
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
    'inspector@' + @name,
    '12345',
    1,
    'Inspector ' + UPPER(LEFT(@name, 1)) + SUBSTRING(@name, 2, LEN(@name)),
    'I' + UPPER(LEFT(@name, 1)),
    @ui_user_types_new_id,
    'ES',
    0
);

---------------------------------------------------------
-- Insert into MASTER_USER
---------------------------------------------------------
DECLARE @id_master_empresa INT;

SELECT TOP 1 
    @id_master_empresa = ID_MASTER_EMPRESA
FROM [TMS_STUDIO_MASTER].[dbo].[MASTER_USER]
WHERE SUBSTRING(MASTER_USER_NAME, CHARINDEX('@', MASTER_USER_NAME) + 1, LEN(MASTER_USER_NAME)) = @name;

INSERT INTO [TMS_STUDIO_MASTER].[dbo].[MASTER_USER] (MASTER_USER_NAME, ID_MASTER_EMPRESA)
VALUES ('inspector@' + @name, @id_master_empresa);
