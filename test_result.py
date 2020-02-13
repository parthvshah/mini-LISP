import os

for r, d, f in os.walk("test_case"):
    for file in f:
        print("\n\n",file)
        os.system('./a.out < test_case/' + file)
print("\n\n\n")