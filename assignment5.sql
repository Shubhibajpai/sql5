use task4;

CREATE TABLE SubjectAllotments (
    studentID VARCHAR(50),
    subjectID VARCHAR(50),
    is_Valid BIT
);

CREATE TABLE SubjectRequest (
    studentID VARCHAR(50),
    subjectID VARCHAR(50)
    
);

INSERT INTO SubjectAllotments (studentID, subjectID, is_Valid)
VALUES ('159103036', 'P01491', 1),
       ('159103036', 'P01492', 0),
       ('159103036', 'P01493', 0),
       ('159103036', 'P01494', 0),
       ('159103036', 'P01495', 0);  


INSERT INTO SubjectRequest (studentID, subjectID)
VALUES ('159103036', 'P01496');  

CREATE PROCEDURE ProcessSubjectRequests
AS
BEGIN
    SET NOCOUNT ON;


    INSERT INTO SubjectAllotments (studentID, subjectID, is_Valid)
    SELECT sr.studentID, sr.subjectID, 1
    FROM SubjectRequest sr
    LEFT JOIN SubjectAllotments sa ON sr.studentID = sa.studentID AND sa.is_Valid = 1
                                   AND sa.subjectID <> sr.subjectID
    WHERE sa.studentID IS NULL;


    UPDATE sa
    SET sa.is_Valid = 0
    FROM SubjectAllotments sa
    INNER JOIN SubjectRequest sr ON sa.studentID = sr.studentID
                                AND sa.is_Valid = 1
                                AND sa.subjectID <> sr.subjectID;

    
    INSERT INTO SubjectAllotments (studentID, subjectID, is_Valid)
    SELECT sr.studentID, sr.subjectID, 1
    FROM SubjectRequest sr
    LEFT JOIN SubjectAllotments sa ON sr.studentID = sa.studentID AND sa.is_Valid = 1
                                   AND sa.subjectID = sr.subjectID
    WHERE sa.studentID IS NULL;
END;
