import docx
from os import path, listdir

def getText(filename):
    doc = docx.Document(filename)
    fullText = []
    for para in doc.paragraphs:
        fullText.append(para.text)
    return '\n'.join(fullText)


if __name__ == "__main__":
    PATH = "docx/"
    files = []
    towrite = ""
    for file in listdir(PATH):
        if file.endswith(".docx"):
            print(f"Dodajam {PATH}{file} v out.txt")
            towrite+=(getText(path.join(PATH, file)))
    with open("drevesa.txt", "wb") as f:
        f.write(towrite.encode("utf-8s"))