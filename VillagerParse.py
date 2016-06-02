#! /usr/bin/env python3
import calendar
import re


class Month:
    january, february, march, april, may, june, july, august, september, october, november, december = range(1, 13)


def get_match(att, match):
    result = "***Match Failed***"
    if match:
        result = match.group(1)
        # print(att, ": ", result, sep='')
        return result
    else:
        # print(att, ": ", result, sep='')
        return result


def convert_gender(gender):
    if gender == "♂":
        return "male"
    elif gender == "♀":
        return "female"


def parse_page():
    villagers = []

    months = {v: k for k, v in enumerate(calendar.month_name)}

    file = open("villager_list", "r")

    file.readline().rstrip("\n\r")

    for villager in range(0, 333):
        villagers.append([])
        # skip <tr>
        file.readline()

        # read name
        line = file.readline().rstrip("\n\r")
        name = re.search("title=\"([\w\s.-]+)", line)
        villagers[villager].append(get_match("Name", name))
        # print(line)

        # skip </td>
        file.readline()

        # read gender
        line = file.readline().rstrip("\n\r")
        gender = re.search(">([♂♀])", line)
        gender = get_match("Gender", gender)
        if gender == "♂":
            gender = "M"
        elif gender == "♀":
            gender = "F"
        villagers[villager].append(gender)

        # read personality
        personality = re.search(">[♂♀]\s([\w\s.]+)", line)
        villagers[villager].append(get_match("Personality", personality))
        # print(line)

        # read species
        line = file.readline().rstrip("\n\r")
        species = re.search("title=\"([\w\s.]+)", line)
        villagers[villager].append(get_match("Species", species))
        # print(line)

        # read Month
        line = file.readline().rstrip("\n\r")
        birth_month = re.search("<td>([\w]+)", line)
        birth_month = get_match("Month", birth_month)
        villagers[villager].append(str(months.get(birth_month)))

        # read Day
        birth_day = re.search("<td>[\w]+\s([\w]+)", line)
        villagers[villager].append(get_match("Day", birth_day))
        # print(line)

        # read Catchphrase
        line = file.readline().rstrip("\n\r")
        catchphrase = re.search("<td><i>(\"[\w\s.\-'!,]+\")", line)
        villagers[villager].append(get_match("Catchphrase", catchphrase))
        # print(line)

        # skip </tr>
        file.readline()

        # print()

    return villagers
