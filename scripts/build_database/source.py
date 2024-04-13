import pandas as pd
from sqlite3 import connect
from os import path, listdir
def to_db(link,filename, type_fixes, fixes):
    db = pd.read_excel(path.join(link, filename))
    db = db.dropna(how='all', axis='columns') #zbrise prazne stolpce
    db = db.fillna(value=-1) #zamenja prazne celice z -1
    for x in db:
        if(x in fixes):
            db[x] = db[x].apply(fixes[x])
        elif(x in type_fixes):
            db[x] = db[x].astype(type_fixes[x])

    try:
        del db["LATITUDE"]
        del db["LONGITUDE"]
    except:
        pass

    longLat = []
    for l in db["OBMOČJE"]:
        longLat.append(l.split(","))
    del db["OBMOČJE"]
    db["LATITUDE"] = float(longLat[0][0])
    db["LONGITUDE"] = float(longLat[0][1])

    cnx = connect(path.join(link, path.splitext(filename)[0] + ".db"))
    db.to_sql(name="drevesa", con=cnx)

if __name__ == "__main__":

    type_fixes = {"ID_DREVESA": int, "Obseg": float}
    fixes = {}

    PATH = "excel/"
    for file in listdir(PATH):
        if file.endswith(".xlsx"):
            print(f"Pretvarjam datoteko {PATH}{file}, kot {path.join(PATH, path.splitext(file)[0])}.db")
            to_db(PATH,file, type_fixes, fixes)