import pandas as pd
from sqlite3 import connect
from os import path, listdir

def merge_db(link, filenames):
    columns = []
    i = 0
    for file in filenames:
        con = connect(path.join(link, file))
        columns.append(pd.read_sql_query("SELECT * FROM drevesa", con))

        con.close()
    columns = pd.concat(columns)
    del columns["index"]
    #columns["index"] = range(len(columns))
    columns = columns.reset_index(drop=True)
    #print(columns[ ]])
   # print(columns)
    cnx = connect("out.db")
    columns.to_sql(name="drevesa", con=cnx)
    
    cnx.close()
if __name__ == "__main__":
    PATH = "DBs/"
    files = []
    for file in listdir(PATH):
        if file.endswith(".db"):
            print(f"Dodajam bazo {PATH}{file} v out.db")
            files.append(file)
    merge_db(PATH,files)