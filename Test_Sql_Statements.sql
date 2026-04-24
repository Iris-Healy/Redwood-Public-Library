USE RedWood_Public_Library;

SELECT m.M_First_Name + ' ' + ISNULL(m.M_Middle_Name, '') + ' ' + m.M_Last_Name AS Member_Name,
       b.BK_Title, b.ISBN,
       a.A_First_Name+ ' ' + ISNULL(a.A_Middle_Name, '') + ' ' + a.A_Last_Name AS Author
FROM Member_Logins ml
JOIN Members m
    ON ml.M_Login_ID = m.M_Login_ID
JOIN Book_Lending bl
    ON m.Member_ID = bl.Member_ID
JOIN Book_Copies bc
    ON bl.BC_ID = bc.BC_ID
JOIN Books b
    ON bc.Book_ID = b.Book_ID
JOIN Book_Authors ba
    ON b.Book_ID = ba.Book_ID
JOIN Authors a
    ON ba.Author_ID = a.Author_ID
WHERE ml.M_Username = 'm_mgarcia004';

SELECT m.M_First_Name + ' ' + ISNULL(m.M_Middle_Name, '') + ' ' + m.M_Last_Name AS Member_Name,
       ml.M_Username,
       ml.M_Password,
       r.Role
FROM Member_Logins ml
JOIN Members m
    ON ml.M_Login_ID = m.M_Login_ID
JOIN Roles r
    ON m.Role_ID = r.Role_ID
WHERE ml.M_Username = 'm_mgarcia004';

SELECT s.S_First_Name + ' ' + ISNULL(s.S_Middle_Name, '') + ' ' + s.S_Last_Name AS Staff_Name,
       sl.S_Username,
       sl.S_Password,
       r.Role
FROM Staff_Logins sl
JOIN Staff s
    ON sl.S_Login_ID = s.S_Login_ID
JOIN Roles r
    ON s.Role_ID = r.Role_ID
WHERE sl.S_Username = '';