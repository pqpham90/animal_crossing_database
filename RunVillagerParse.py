#! /usr/bin/env python3
from VillagerParse import parse_page
import MySQLdb


def main():
    db = MySQLdb.connect(host="localhost", user="User", passwd="Password", db="animal_crossing")
    db.autocommit(1)
    cur = db.cursor()

    drop = "DROP TABLE IF EXISTS villager;"

    create = ("CREATE TABLE villager ("
              "id int(4) NOT NULL AUTO_INCREMENT, "
              "name varchar(8) NOT NULL, "
              "gender char(1) NOT NULL, "
              "personality varchar(6) NOT NULL, "
              "species varchar(9) NOT NULL, "
              "birth_month tinyint(2) NOT NULL, "
              "birth_day tinyint(2) NOT NULL, "
              "catchphrase varchar(13) NOT NULL, "
              "PRIMARY KEY(id)"
              ")"
              )

    cur.execute(drop)
    cur.execute(create)

    query = "INSERT INTO villager(name, gender, personality, species, birth_month, birth_day, catchphrase) " \
            "VALUES(%s, %s, %s, %s, %s, %s, %s)"

    villagers = parse_page()

    for outer in villagers:
        # print('{:8}'.format(outer[0]), end="\n")
        args = (outer[0], outer[1], outer[2], outer[3], outer[4], outer[5], outer[6])
        cur.execute(query, args)

    cur.close()

main()
