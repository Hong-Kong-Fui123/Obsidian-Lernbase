---
typ: wissen
thema: Datenbanken SQL
tags: [sql, stored-procedure]
quelle: Word-Notizen
status: importiert
---
# SQL - Beispiel Stored Procedure set_mgr

Thema: [[Datenbanken SQL]]

```sql
CREATE PROCEDURE set_mgr
  @empno INT, -- Erster Funktionsparameter (ID des Mitarbeiters)
  @mgrno INT  -- Zweiter Funktionsparameter (ID des potenziellen Managers)
AS
BEGIN
    DECLARE @job_title VARCHAR(50); -- Variable deklarieren
    -- Variable den Wert aus der Spalte JOB in der Tabelle emp zuweisen
    SELECT @job_title = JOB FROM emp WHERE EMPNO = @mgrno;
    - -CASE WHEN funktioniert innerhalb von stored procedures nicht (Quelle: Google),

deshalb IF ELSE
    IF @job_title = 'MANAGER' OR @job_title = 'PRESIDENT'
    BEGIN
    -- Wenn der Jobtitel MANAGER oder PRESIDENT lautet setzen wir den Manager        UPDATE emp SET MGR = @mgrno WHERE EMPNO = @empno;
    END
    ELSE
    -- Andernfalls geben wir die Fehlermeldung aus
    BEGIN
        PRINT 'ERROR: Employee is not a Manager';
    END
END;
GO

-- Benötigen wir, damit wir danach weitere Sachen ins Skript schreiben können

-- Ausgeführt mit

EXEC set_mgr
```
