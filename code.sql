BEGIN

  DECLARE search_column STRING DEFAULT 'customer_id';

  DECLARE table_name STRING;
  DECLARE sql_stmt STRING;

  -- temp table to store matches
  CREATE OR REPLACE TEMP VIEW column_matches AS
  SELECT
    '' AS table_name,
    '' AS column_name
  WHERE 1 = 0;

  -- get all tables
  FOR tbl IN
    (SHOW TABLES IN your_database)
  DO

    SET table_name = tbl.tableName;

    -- dynamically describe table and filter matching columns
    SET sql_stmt = CONCAT(
      'INSERT INTO column_matches ',
      'SELECT ''',
      table_name,
      ''' AS table_name, col_name AS column_name ',
      'FROM (DESCRIBE your_database.',
      table_name,
      ') ',
      'WHERE lower(col_name) LIKE ''%',
      lower(search_column),
      '%'''
    );

    EXECUTE IMMEDIATE sql_stmt;

  END FOR;

  -- final result
  SELECT * FROM column_matches;

END;