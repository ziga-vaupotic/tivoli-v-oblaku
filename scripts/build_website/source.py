import pandas as pd
from os import listdir
from os import path as pth

def to_website(path, filename, type_fixes, fixes, extract):
    infile = pth.join(path, filename)

    db = pd.read_excel(infile)
    db = db.dropna(how='all', axis='columns') #zbrise prazne stolpce
    db = db.fillna(value=-1) #zamenja prazne celice z -1
    for x in db:
        if(x in fixes):
            db[x] = db[x].apply(fixes[x])
        elif(x in type_fixes):
            db[x] = db[x].astype(type_fixes[x])
    def gen_url(x):
        if(not type(new_db["Koordinate"][x]) == int and not type(new_db["Ime drevesa"][x]) == int):
            return f"""<a href=\"https://www.google.com/maps/dir/?api=1&travelmode=walking&destination={new_db["Koordinate"][x][0]},{new_db["Koordinate"][x][1]}\">{new_db["Ime drevesa"][x]}</a>"""
        return -1
    new_db = pd.DataFrame({})
    for ex in extract:
        new_db[ex] = db[ex]
    ser = []
    for x in range(len(new_db["Koordinate"])):
        ser.append(gen_url(x))
    #print(ser)
    new_db["Pot"] = ser
    with open(pth.join(path, "out.html"), "w+", encoding="utf-8") as out:
        new_db.to_html(out, index_names=False, index=False, escape=False, columns=["Pot", "ID_DREVESA"])

if (__name__ == "__main__"):


    def la(x): #potrebno ce so prazne celice
        try:
            return tuple(float(y) for y in x.split(","))
        except:
            return x
    type_fixes = {"ID_DREVESA": int}
    fixes = {"Koordinate": la}
    extract = ["Ime drevesa", "Koordinate", "ID_DREVESA"]
    PATH = "excel/"
    for file in listdir(PATH):
        if file.endswith(".xlsx"):
            print(f"Pretvarjam datoteko {PATH}{file} v {pth.join(PATH, pth.splitext(file)[0])}.html")
            to_website(PATH,file, type_fixes, fixes, extract)