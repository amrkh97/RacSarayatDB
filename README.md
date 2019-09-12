![Rotaract Sarayat El-Maadi's Logo](https://github.com/amrkh97/RacSarayatBackEnd/blob/master/RAC%20SARAYAT%20LOGO%202018-02.png)
# RacSarayatDB

Database Files for Rotaract Sarayat El-Maadi's App.

## Getting Started

* Please refer to the Readme File in the BackEnd Repo After installing the Database files, you can find it [Here](https://github.com/amrkh97/RacSarayatBackEnd/blob/master/README.md)
* These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You will need to Install:

* **[SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)**
* **[SQL Management Studio -SSMS-](https://docs.microsoft.com/ar-sa/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017)**

### Installing

After Installing all the programs and cloning the repo:

* **Setting Up The Database**
1. Open SQL management Studio.
2. Choose your server and choose your server and press connect.
3. In Object Explorer, Choose Security -> Logins -> New Login
4. Choose Login Name: admin / Choose SQL Server Authentication And the password should be 1234
5. Click ok, then in object explorer click on connect and choose SQl Server Authentication
6. If prompted to change password then re-type 1234 and click connect.
7. Create New Database With the Name : **Rac_Sarayat**
8. In the newly created database click on Security -> Users -> Right click New User
9. Choose user name: admin / login name: admin
10. Click on owned schemas, Tick on:

```
      -db_datareader
      -db_datawriter
      -db_ddladmin
      -db_owner
```

11. Click on membership and tick on the same entries as in **Owned Schemas**
12. Execute the File Named: **RacTables.sql** then **CombinedSP.sql**

---
**Your database is all set right now, Happy Coding :revolving_hearts:**
---

## Testing

For testing our APIs, Postman is used and you can find the collection ready for import [Here](https://github.com/amrkh97/RacSarayatDB/blob/master/Rotaract.postman_collection.json)

---
## Built With

* SQL

## Contributing

Please read [CONTRIBUTING.md](https://github.com/amrkh97/RacSarayatDB/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **[Amr Khaled](https://www.linkedin.com/in/amrkh97/)** 

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/amrkh97/RacSarayatBackEnd/blob/master/LICENSE) file for details
